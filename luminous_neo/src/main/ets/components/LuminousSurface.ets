import { LuminousNeoTokens, LuminousSelectionItem } from '../foundation/LuminousFoundation';

/**
 * 拟物化容器。depth > 0 表示浮起，depth < 0 表示内凹，0 表示纯平。
 * 调用方会在外层用 shadowPaddingFor() 预留投影空间，这里只负责自身绘制。
 */
@Component
export struct LuminousSurface {
  @Prop depth: number = 0;
  @Prop surfaceWidth: number = 0;
  @Prop surfaceHeight: number = 0;
  @Prop cornerRadius: number = 16;
  @Prop motionEnabled: boolean = true;
  @Prop contentAlignment: Alignment = Alignment.Center;
  @BuilderParam content: () => void = this.PlaceholderContent;

  @Builder
  PlaceholderContent(): void {
  }

  private inset(): boolean {
    return this.depth < 0;
  }

  private magnitude(): number {
    return Math.min(2, Math.abs(this.depth));
  }

  private shadowRadius(): number {
    return this.inset() ? 0 : Math.round(10 * this.magnitude());
  }

  private shadowOffset(): number {
    return this.inset() ? 0 : Math.round(4 * this.magnitude());
  }

  // ArkTS 对三元表达式产生的联合类型很敏感，这里显式收敛到 Length
  private resolvedWidth(): Length {
    return this.surfaceWidth > 0 ? this.surfaceWidth as Length : '100%' as Length;
  }

  private resolvedHeight(): Length {
    return this.surfaceHeight > 0 ? this.surfaceHeight as Length : '100%' as Length;
  }

  private motion(): AnimateParam {
    return { duration: this.motionEnabled ? 160 : 0, curve: Curve.EaseOut };
  }

  build(): void {
    Stack({ alignContent: this.contentAlignment }) {
      this.content();
    }
    .width(this.resolvedWidth())
    .height(this.resolvedHeight())
    .borderRadius(this.cornerRadius)
    .backgroundColor(this.inset() ? $r('app.color.lm_field_background') : $r('app.color.lm_base'))
    .border({
      width: this.magnitude() > 0 ? 1 : 0,
      color: this.inset() ? $r('app.color.lm_field_border') : $r('app.color.lm_shadow_light'),
    })
    .shadow({
      radius: this.shadowRadius(),
      color: $r('app.color.lm_shadow_dark'),
      offsetX: this.shadowOffset(),
      offsetY: this.shadowOffset(),
    })
    .animation(this.motion())
  }
}

/**
 * 分段控制器。items 用 LuminousSelectionItem 承载，选中项以强调色实心块表示。
 */
@Component
export struct LuminousSegmentedControl {
  @Prop items: LuminousSelectionItem[] = [];
  @Prop selectedIndex: number = 0;
  @Prop controlWidth: number = 280;
  @Prop controlHeight: number = 50;
  @Prop motionEnabled: boolean = true;
  onChange: (index: number) => void = () => {
  };

  private segmentBackground(index: number): ResourceColor {
    return index === this.selectedIndex
      ? $r('app.color.lm_accent') as ResourceColor
      : Color.Transparent as ResourceColor;
  }

  private segmentForeground(index: number): ResourceColor {
    return index === this.selectedIndex
      ? $r('app.color.lm_on_accent')
      : $r('app.color.lm_text_primary');
  }

  build(): void {
    Column() {
      Row() {
      ForEach(this.items, (item: LuminousSelectionItem, index: number) => {
        Stack() {
          Text(item.title)
            .fontSize(14)
            .fontWeight(index === this.selectedIndex ? FontWeight.Medium : FontWeight.Normal)
            .fontColor(this.segmentForeground(index))
            .maxLines(1)
            .textAlign(TextAlign.Center)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .padding({ left: 2, right: 2 })
        }
        .layoutWeight(1)
        .height(Math.max(24, this.controlHeight - 8))
        .borderRadius(Math.max(8, this.controlHeight / 2 - 4))
        .backgroundColor(this.segmentBackground(index))
        .onClick(() => {
          this.onChange(index);
        })
      }, (item: LuminousSelectionItem) => item.id)
      }
      .width(this.controlWidth)
      .height(this.controlHeight)
      .padding(4)
      .borderRadius(this.controlHeight / 2)
      .backgroundColor($r('app.color.lm_field_background'))
      .border({ width: 1, color: $r('app.color.lm_field_border') })
    }
    .padding(LuminousNeoTokens.shadowPaddingFor(this.controlHeight))
    .clip(false)
  }
}

/**
 * 二级下拉菜单。收起时显示当前项，展开后列出全部选项。
 */
@Component
export struct LuminousSecondaryMenu {
  @Prop items: LuminousSelectionItem[] = [];
  @Prop selectedIndex: number = 0;
  @Prop controlWidth: number = 280;
  @Prop mainHeight: number = 54;
  @Prop itemHeight: number = 52;
  @Prop accessibilityLabel: ResourceStr = '';
  @Prop handleAccessibilityLabel: ResourceStr = '';
  @Prop isEnabled: boolean = true;
  @Prop motionEnabled: boolean = true;
  onChange: (index: number) => void = () => {
  };
  @State private expanded: boolean = false;

  private currentTitle(): ResourceStr {
    if (this.selectedIndex >= 0 && this.selectedIndex < this.items.length) {
      return this.items[this.selectedIndex].title;
    }
    return '';
  }

  build(): void {
    Column() {
      Row() {
        Text(this.currentTitle())
          .fontSize(16)
          .fontColor(this.isEnabled ? $r('app.color.lm_text_primary') : $r('app.color.lm_disabled_text'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .layoutWeight(1)

        Text(this.expanded ? '▲' : '▼')
          .fontSize(12)
          .fontColor($r('app.color.lm_text_secondary'))
          .margin({ left: 8 })
      }
      .width('100%')
      .height(this.mainHeight)
      .padding({ left: 16, right: 16 })
      .borderRadius(14)
      .backgroundColor($r('app.color.lm_field_background'))
      .border({ width: 1, color: $r('app.color.lm_field_border') })
      .onClick(() => {
        if (this.isEnabled) {
          this.expanded = !this.expanded;
        }
      })

      if (this.expanded) {
        Column() {
          ForEach(this.items, (item: LuminousSelectionItem, index: number) => {
            Column() {
              Text(item.title)
                .fontSize(15)
                .fontColor(index === this.selectedIndex
                  ? $r('app.color.lm_accent')
                  : $r('app.color.lm_text_primary'))
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width('100%')
            }
            .width('100%')
            .height(this.itemHeight)
            .padding({ left: 16, right: 16 })
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Start)
            .onClick(() => {
              this.onChange(index);
              this.expanded = false;
            })
          }, (item: LuminousSelectionItem) => item.id)
        }
        .width('100%')
        .margin({ top: 6 })
        .borderRadius(14)
        .backgroundColor($r('app.color.lm_base'))
        .border({ width: 1, color: $r('app.color.lm_field_border') })
      }
    }
    // width 是含 padding 的边框盒，这样内部 '100%' 正好等于 controlWidth
    .width(this.controlWidth + LuminousNeoTokens.shadowPaddingFor(this.mainHeight) * 2)
    .padding(LuminousNeoTokens.shadowPaddingFor(this.mainHeight))
    .clip(false)
    .alignItems(HorizontalAlign.Start)
  }
}
