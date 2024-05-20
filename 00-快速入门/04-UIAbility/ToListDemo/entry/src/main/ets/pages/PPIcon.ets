@Component
@Preview
export struct PPIcon{
  @Prop isDo: boolean

  build() {
    Image(this.isDo ? $r('app.media.ic_ok') : $r('app.media.ic_default'))
      .width(20)
      .height(20)
      .margin(10)
  }
}