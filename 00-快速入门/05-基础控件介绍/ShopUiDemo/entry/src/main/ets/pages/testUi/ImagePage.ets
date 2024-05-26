@Entry
@Component
struct ImagePage {
  @State message: string = 'Hello World';

  build() {
    Column({space: 10}){
      Image($r('app.media.weibo'))
        .width(50)
        .height(50)


      Image('https://avatars.githubusercontent.com/u/23235986?v=4')
        .width(80)
        .height(50)

      Image('https://avatars.githubusercontent.com/u/23235986?v=4')
        .objectFit(ImageFit.Fill)
        .width(80)
        .height(50)

    }.width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
  }
}