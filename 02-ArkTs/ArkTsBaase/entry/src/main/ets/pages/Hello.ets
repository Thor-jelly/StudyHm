@Entry
@Component
struct Hello {
  @State desStr: string = 'World'

  build() {
    Column() {
      Text(`Hello ${this.desStr}`)
        .fontSize(50)
      Divider()
      Button('click me')
        .onClick(() => {
          this.desStr = "ArkTS"
        })
        .height(50)
        .width(100)
        .margin({ top: 20 })
    }
  }
}

