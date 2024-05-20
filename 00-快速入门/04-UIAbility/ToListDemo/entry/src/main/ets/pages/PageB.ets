import { router } from '@kit.ArkUI';

@Entry
@Component
struct PageB {
  @State message: string = 'Hello World B';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld B')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          router.pushUrl({ url: 'pages/PageA' }, router.RouterMode.Single)
        })
    }
    .height('100%')
    .width('100%')
  }
}