@Entry
@Component
struct TextPage {
  @State message: string = 'Hello World';

  build() {
    Column({ space: 10 }) {
      Text('我是一个什么都没设置的textview')

      Text('字体大小颜色调整')
        .fontSize(18)
        .fontColor(Color.Red)

      Text('字体粗细')
        .fontSize(20)
        .fontColor(Color.Green)
        .fontWeight(FontWeight.Bold)

      Text('字体斜体')
        .fontSize(20)
        .fontColor(Color.Green)
        .fontStyle(FontStyle.Italic)

      Text('字体斜体')
        .fontSize(20)
        .fontColor(Color.Green)
        .decoration({type: TextDecorationType.LineThrough})

      // 文本对齐方式
      Text('文本对齐方式 TextAlign.Start')
        .textAlign(TextAlign.Start)
        .width('100%')
      Text('文本对齐方式 TextAlign.End')
        .textAlign(TextAlign.End)
        .width('100%')
      Text('文本对齐方式 TextAlign.Center')
        .textAlign(TextAlign.Center)
        .width('100%')
      Text('文本对齐方式文本对，齐方式文本对齐方式文本对齐方式文。本对齐方式文本对齐方式，文本对齐方式文本对齐方式 TextAlign.JUSTIFY')
        .textAlign(TextAlign.JUSTIFY)
        .width('100%')
    }
    .height('100%')
    .width('100%')
  }
}