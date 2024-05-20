import { A } from '../model/A'

@Component
@Preview
export struct ToDoItem {
  private text: string = ''
  @State isDo: boolean = false

  @Builder
  Icon(r: Resource) {
    Image(r)
      .width(20)
      .height(20)
      .margin(10)
  }

  @Builder
  ZIcon(r: A) {
    Image(r.r)
      .width(20)
      .height(20)
      .margin(10)
  }

  @Builder
  PIcon() {
    Image(this.isDo ? $r('app.media.ic_ok') : $r('app.media.ic_default'))
      .width(20)
      .height(20)
      .margin(10)
  }

  build() {
    Row() {
      //图标
      if(this.isDo){
        this.Icon($r('app.media.ic_ok'))
      }else {
        this.Icon($r('app.media.ic_default'))
      }
      this.Icon(this.isDo ? $r('app.media.ic_ok') : $r('app.media.ic_default'))
      this.ZIcon({r: this.isDo ? $r('app.media.ic_ok') : $r('app.media.ic_default')})
      this.PIcon()
      //this.PPIcon()
      //文本
      Text(this.text)
        .fontSize(15)
        .fontColor(Color.Blue)
        .opacity(this.isDo ? 0.4 : 1)
        .decoration({type: this.isDo ? TextDecorationType.LineThrough: TextDecorationType.None})
    }.backgroundColor(Color.White)
    .borderRadius(20)
    .width('100%')
    .onClick(()=>{
      this.isDo = !this.isDo
    })
  }
}