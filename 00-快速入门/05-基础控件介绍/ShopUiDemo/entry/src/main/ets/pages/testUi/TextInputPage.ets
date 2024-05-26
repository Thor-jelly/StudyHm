@Entry
@Component
struct TextInputPage {
  @State message: string = 'Hello World';
  @State text: string = 'Hello World';
  private changeController = new TextInputController()

  build() {


    Column({ space: 10 }) {
      TextInput({ placeholder: '占位符' })
        .fontColor(Color.Blue)
        .placeholderColor(Color.Orange)
        .placeholderFont({ size: 20 })
        .fontSize(30)

      TextInput({ placeholder: '密码类型' })
        .type(InputType.Password)
        .fontColor(Color.Blue)
        .placeholderColor(Color.Orange)
        .placeholderFont({ size: 20 })
        .fontSize(30)

      Column() {
        Button('设置光标位置2')
          .onClick(() => {
            focusControl.requestFocus('TextInput1')
            this.changeController.caretPosition(2)
          })

        TextInput({ text: '我是被改变光标位置的输入框', controller: this.changeController })
          .id('TextInput1')
          .fontColor(Color.Blue)
          .placeholderColor(Color.Orange)
          .placeholderFont({ size: 20 })
          .fontSize(30)
      }

      Column() {
        TextInput({ placeholder: '请输入账号' })
          .caretColor(Color.Blue)
          .onChange((value: string) => {
            this.text = value;
          })
        Text(this.text)
      }
      .alignItems(HorizontalAlign.Center)
      .padding(12)
      .backgroundColor(0xE6F2FD)
    }
    .height('100%')
    .width('100%')
  }
}