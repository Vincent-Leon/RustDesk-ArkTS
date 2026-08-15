import { LuminousControlSize, LuminousNeoTokens, LuminousTone } from '../foundation/LuminousFoundation';

@Component
export struct LuminousButton {
  @Prop label: ResourceStr = '';
  @Prop controlWidth: number = 120;
  @Prop controlSizeMode: LuminousControlSize = LuminousControlSize.Regular;
  @Prop tone: LuminousTone = LuminousTone.Neutral;
  @Prop isEnabled: boolean = true;
  @Prop motionEnabled: boolean = true;
  onAction: () => void = () => {
  };

  private resolvedHeight(): number {
    return LuminousNeoTokens.controlHeight(this.controlSizeMode);
  }

  private backgroundTone(): ResourceColor {
    if (!this.isEnabled) {
      return $r('app.color.lm_disabled_background');
    }
    if (this.tone === LuminousTone.Accent) {
      return $r('app.color.lm_accent');
    }
    if (this.tone === LuminousTone.Danger) {
      return $r('app.color.lm_danger');
    }
    return $r('app.color.lm_base');
  }

  private foregroundTone(): ResourceColor {
    if (!this.isEnabled) {
      return $r('app.color.lm_disabled_text');
    }
    if (this.tone === LuminousTone.Neutral) {
      return $r('app.color.lm_text_primary');
    }
    return $r('app.color.lm_on_accent');
  }

  build(): void {
    // 外层只负责撑出投影用的一圈内边距，视觉本体仍是 controlWidth × controlHeight
    Column() {
      Button() {
        Text(this.label)
          .fontSize(this.controlSizeMode === LuminousControlSize.Compact ? 15 : 16)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.foregroundTone())
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .padding({ left: 10, right: 10 })
      }
      .type(ButtonType.Normal)
      .stateEffect(this.isEnabled && this.motionEnabled)
      .enabled(this.isEnabled)
      .width(this.controlWidth)
      .height(this.resolvedHeight())
      .borderRadius(this.controlSizeMode === LuminousControlSize.Compact ? 14 : 16)
      .backgroundColor(this.backgroundTone())
      // 禁用态的底色与页面背景过于接近，补一圈描边让按钮仍然可辨认
      .border({
        width: (this.tone === LuminousTone.Neutral || !this.isEnabled) ? 1 : 0,
        color: $r('app.color.lm_field_border'),
      })
      .shadow({
        radius: this.isEnabled ? 8 : 0,
        color: $r('app.color.lm_shadow_dark'),
        offsetX: this.isEnabled ? 3 : 0,
        offsetY: this.isEnabled ? 3 : 0,
      })
      .onClick(() => {
        this.onAction();
      })
    }
    .padding(LuminousNeoTokens.shadowPaddingFor(this.resolvedHeight()))
    .clip(false)
  }
}

@Component
export struct LuminousTextField {
  @Prop value: string = '';
  @Prop placeholder: ResourceStr = '';
  @Prop fieldWidth: number = 240;
  @Prop fieldHeight: number = 54;
  @Prop inputType: InputType = InputType.Normal;
  @Prop maxLength: number = 0;
  @Prop isEnabled: boolean = true;
  @Prop motionEnabled: boolean = true;
  onChange: (value: string) => void = () => {
  };

  build(): void {
    Column() {
      TextInput({ text: this.value, placeholder: this.placeholder })
        .type(this.inputType)
        .maxLength(this.maxLength > 0 ? this.maxLength : 1024)
        .enabled(this.isEnabled)
        .width(this.fieldWidth)
        .height(this.fieldHeight)
        .borderRadius(14)
        .padding({ left: 16, right: 16 })
        .backgroundColor($r('app.color.lm_field_background'))
        .border({ width: 1, color: $r('app.color.lm_field_border') })
        .fontSize(16)
        .fontColor(this.isEnabled ? $r('app.color.lm_text_primary') : $r('app.color.lm_disabled_text'))
        .placeholderColor($r('app.color.lm_text_secondary'))
        .caretColor($r('app.color.lm_accent'))
        .onChange((next: string) => {
          this.onChange(next);
        })
    }
    .padding(LuminousNeoTokens.shadowPaddingFor(this.fieldHeight))
    .clip(false)
  }
}

@Component
export struct LuminousSearchField {
  @Prop value: string = '';
  @Prop placeholder: ResourceStr = '';
  @Prop fieldWidth: number = 240;
  @Prop fieldHeight: number = 48;
  @Prop isEnabled: boolean = true;
  @Prop motionEnabled: boolean = true;
  onChange: (value: string) => void = () => {
  };

  build(): void {
    Column() {
      Search({ value: this.value, placeholder: this.placeholder })
        .enabled(this.isEnabled)
        .width(this.fieldWidth)
        .height(this.fieldHeight)
        .borderRadius(this.fieldHeight / 2)
        .backgroundColor($r('app.color.lm_field_background'))
        .border({ width: 1, color: $r('app.color.lm_field_border') })
        .textFont({ size: 15 })
        .fontColor($r('app.color.lm_text_primary'))
        .placeholderColor($r('app.color.lm_text_secondary'))
        .caretStyle({ color: $r('app.color.lm_accent') })
        .onChange((next: string) => {
          this.onChange(next);
        })
    }
    .padding(LuminousNeoTokens.shadowPaddingFor(this.fieldHeight))
    .clip(false)
  }
}

@Component
export struct LuminousSwitch {
  @Prop label: ResourceStr = '';
  @Prop description: ResourceStr = '';
  @Prop isOn: boolean = false;
  @Prop rowWidth: number = 280;
  @Prop isEnabled: boolean = true;
  @Prop motionEnabled: boolean = true;
  onChange: (value: boolean) => void = () => {
  };

  private hasDescription(): boolean {
    if (typeof this.description === 'string') {
      return (this.description as string).length > 0;
    }
    return true;
  }

  build(): void {
    Row() {
      Column() {
        Text(this.label)
          .fontSize(16)
          .fontColor(this.isEnabled ? $r('app.color.lm_text_primary') : $r('app.color.lm_disabled_text'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        if (this.hasDescription()) {
          Text(this.description)
            .fontSize(13)
            .fontColor($r('app.color.lm_text_secondary'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('100%')
            .margin({ top: 2 })
        }
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Toggle({ type: ToggleType.Switch, isOn: this.isOn })
        .enabled(this.isEnabled)
        .selectedColor($r('app.color.lm_accent'))
        .margin({ left: 12 })
        .onChange((next: boolean) => {
          this.onChange(next);
        })
    }
    .width(this.rowWidth)
    .padding({ left: 16, right: 12 })
    .borderRadius(16)
    .backgroundColor($r('app.color.lm_base'))
    .border({ width: 1, color: $r('app.color.lm_field_border') })
  }
}

@Component
export struct LuminousSlider {
  @Prop label: ResourceStr = '';
  @Prop value: number = 0;
  @Prop minimum: number = 0;
  @Prop maximum: number = 100;
  @Prop step: number = 1;
  @Prop sliderWidth: number = 240;
  @Prop motionEnabled: boolean = true;
  onChange: (value: number, mode: SliderChangeMode) => void = () => {
  };

  build(): void {
    Column() {
      Row() {
        Text(this.label)
          .fontSize(15)
          .fontColor($r('app.color.lm_text_primary'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .layoutWeight(1)

        Text(`${Math.round(this.value)}`)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.lm_accent'))
          .margin({ left: 8 })
      }
      .width('100%')

      Slider({
        value: this.value,
        min: this.minimum,
        max: this.maximum,
        step: this.step,
        style: SliderStyle.OutSet,
      })
        .width('100%')
        .margin({ top: 4 })
        .trackColor($r('app.color.lm_field_background'))
        .selectedColor($r('app.color.lm_accent'))
        .blockColor($r('app.color.lm_base'))
        .onChange((next: number, mode: SliderChangeMode) => {
          this.onChange(next, mode);
        })
    }
    .width(this.sliderWidth)
    .alignItems(HorizontalAlign.Start)
  }
}
