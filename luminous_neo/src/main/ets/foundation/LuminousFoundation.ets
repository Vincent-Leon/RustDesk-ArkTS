/**
 * 本地替身实现：私有仓库的 luminous_neo@1.0.2 无法匿名获取（CodeArts 私仓 401），
 * 这里按 entry 模块的全部调用点反推出等价接口，仅用于本地开发与真机验证。
 * 数值取自 entry 自带的 neu_* 设计 token，因此布局度量与原库保持同一量级。
 */

export enum LuminousControlSize {
  Compact = 0,
  Regular = 1,
}

export enum LuminousTone {
  Neutral = 0,
  Accent = 1,
  Danger = 2,
}

export class LuminousSelectionItem {
  public readonly id: string;
  public readonly title: ResourceStr;
  public readonly subtitle: ResourceStr;
  public readonly enabled: boolean;

  constructor(id: string, title: ResourceStr, subtitle?: ResourceStr, enabled?: boolean) {
    this.id = id;
    this.title = title;
    this.subtitle = subtitle === undefined ? '' : subtitle;
    this.enabled = enabled === undefined ? true : enabled;
  }
}

/**
 * 原库用重力传感器驱动拟物高光随设备倾斜移动。替身不做光照效果，
 * 只保留生命周期接口，因此也不会订阅任何传感器。
 */
export class LuminousMotionLight {
  static enableSensorSubscription(): void {
  }

  static disableSensorSubscription(): void {
  }

  static resume(): void {
  }

  static suspend(): void {
  }
}

export class LuminousNeoTokens {
  /** 悬浮面板的基准短边，FloatingSurface 用它来夹取阴影半径 */
  static readonly BASE_SURFACE_SIZE: number = 56;
  /** 常规控件高度，与 entry 中 fieldHeight: 54 的用法一致 */
  static readonly REGULAR_HEIGHT: number = 54;
  /** 紧凑控件高度 */
  static readonly COMPACT_HEIGHT: number = 44;
  /** 弱化的浮起深度，取值小于 1 使阴影更轻 */
  static readonly SUBTLE_RAISED_DEPTH: number = 0.5;

  static controlHeight(size: LuminousControlSize): number {
    return size === LuminousControlSize.Compact
      ? LuminousNeoTokens.COMPACT_HEIGHT
      : LuminousNeoTokens.REGULAR_HEIGHT;
  }

  /**
   * 控件为投影预留的内边距：控件节点在每条边上都比视觉本体多出这一圈。
   *
   * 依据来自 PasswordDialog.buttonWidth()：两个按钮无间距并排填满 panelWidth - 48，
   * 而 buttonWidth = (panelWidth - 48 - shadowPadding * 4) / 2，
   * 即 2 * (controlWidth + 2 * shadowPadding) = panelWidth - 48。
   *
   * 比例取 0.28，使 ConnectTab 中 -6 / -26 / -28 这组负 margin 叠加后
   * 恰好留出几个像素的正向间距，与原库的紧凑排布一致。
   */
  static shadowPaddingFor(edge: number): number {
    const normalized: number = Math.max(1, edge);
    return Math.min(20, Math.max(8, Math.round(normalized * 0.28)));
  }
}
