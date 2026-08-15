# luminous_neo 本地替身模块

## 这是什么

上游 `RustDesk-ArkTS` 的 `entry` 模块依赖 `luminous_neo@1.0.2`，它托管在作者的华为
CodeArts 私有 OHPM 仓库里，匿名访问返回 401，公共 OHPM 仓库没有这个包。因此
**公开仓库无法独立构建**（见 upstream issue #1）。

这个目录是一套本地替身实现，按 `entry` 中全部调用点反推出等价接口，让工程可以在
没有私有依赖的情况下编译、运行和真机调试。

## 覆盖的接口

14 个界面文件共引用 12 个符号，全部实现：

| 类别 | 符号 |
|---|---|
| 设计 token | `LuminousNeoTokens` |
| 枚举 | `LuminousControlSize`、`LuminousTone` |
| 数据类 | `LuminousSelectionItem` |
| 组件 | `LuminousSurface`、`LuminousButton`、`LuminousTextField`、`LuminousSearchField`、`LuminousSwitch`、`LuminousSlider`、`LuminousSegmentedControl`、`LuminousSecondaryMenu` |

## 尺寸约定

控件节点在每条边上都比视觉本体多出一圈 `shadowPaddingFor()` 的投影内边距。

依据来自 `PasswordDialog.buttonWidth()`：两个按钮无间距并排填满 `panelWidth - 48`，
而 `buttonWidth = (panelWidth - 48 - shadowPadding * 4) / 2`，
即 `2 * (controlWidth + 2 * shadowPadding) = panelWidth - 48`。

调用方普遍使用负 margin（`-6` / `-10` / `-26` / `-28`）把控件拉回，
少了这圈内边距会导致控件互相重叠。

配色取自 `entry` 自带的 `neu_*` 设计 token，明暗两套齐全，因此与原库同一量级。

## 接入方式

克隆后需要手工改两处（这两个文件在上游是被跟踪的，本分支不修改它们，
以免把本地签名配置一起提交）：

**1. 根目录 `build-profile.json5`** —— 在 `modules` 数组里追加：

```json5
{
  "name": "luminous_neo",
  "srcPath": "./luminous_neo"
}
```

**2. `entry/oh-package.json5`** —— 把依赖改成本地模块：

```json5
"luminous_neo": "file:../luminous_neo"
```

然后在根目录和 `entry` 目录各执行一次 `ohpm install`。

## 局限

真实的 `luminous_neo` 谁也没见过，接口是从调用点反推的。手机与 2in1 上验证过布局
不重叠、明暗主题正常，但**视觉细节必然与原库有出入**。

因此：涉及 UI 外观的改动无法在这套替身下做视觉验证，不适合据此提交样式类 PR。
功能性改动（连接、事件、状态管理）不受影响。

## 不要提交到上游

这是本地开发脚手架，仅用于绕开无法获取的私有依赖。给上游提 PR 时，
改动范围不应包含本目录，也不应包含上面那两处接入修改。
