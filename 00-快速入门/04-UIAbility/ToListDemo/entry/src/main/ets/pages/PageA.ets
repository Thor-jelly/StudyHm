import router from '@ohos.router';

@Entry
@Component
struct PageA {
  @State message: string = 'Hello World A';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld A')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          router.pushUrl({url: 'pages/PageB'}, router.RouterMode.Standard)
        })
    }
    .height('100%')
    .width('100%')
  }
}