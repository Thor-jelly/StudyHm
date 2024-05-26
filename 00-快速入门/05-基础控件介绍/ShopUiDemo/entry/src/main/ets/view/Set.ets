import ItemData from '../mode/ItemData'
import mainViewModel from '../viewmodel/MainViewModel'

@Preview
@Component
export default struct MySet {
  @Builder
  settingCell(item: ItemData) {
    Row() {
      Row({ space: 12 }) {
        Image(item.img)
          .width(22)
          .height(22)
        Text(item.title)
          .fontSize(16)
      }

      if (item.others === undefined) {
        Image($r('app.media.right_grey'))
          .width(12)
          .height(24)
      } else {
        Toggle({ type: ToggleType.Switch, isOn: false })
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .padding({ left: 8, right: 22 })
  }

  build() {


    Scroll() {
      Column({ space: 10 }) {
        Column() {
          Text('我的')
            .fontWeight(FontWeight.Medium)
            .fontSize(24)
            .margin({ top: 12 })
            .padding({ left: 12 })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        // .backgroundColor(Color.Red)


        Row() {
          Image($r('app.media.account'))
            .width(48)
            .height(48)
          Column() {
            Text('ddw')
              .fontSize(20)
            Text('745661590@qq.com')
              .fontSize(12)
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 24 })
        }
        .margin({ top: 24 })
        .alignItems(VerticalAlign.Center)
        .width('100%')
        .height(96)
        .backgroundColor(Color.White)
        .padding({ left: 24 })
        .borderRadius(16)

        List() {
          ForEach(mainViewModel.getSettingListData(), (item: ItemData) => {
            ListItem() {
              this.settingCell(item)
            }
            .height(48)
          }, (item: ItemData, index: number) => index.toString())
        }
        .scrollBar(BarState.Off)
        .backgroundColor(Color.White)
        .width('100%')
        .divider({
          strokeWidth: 0.5,
          color: Color.Grey,
          startMargin: 42,
          endMargin: 24
        })
        .borderRadius(16)
        .padding({ top: 4, bottom: 4 })

        Blank()

        Button('退出', { type: ButtonType.Capsule })
          .width('90%')
          .height(40)
          .fontSize(16)
          .fontColor('#FA2A2D')
          .fontWeight(FontWeight.Medium)
          .backgroundColor('#E5E8EA')
          .margin({ bottom: 55 })
      }
      .width('100%')
      // .backgroundColor(Color.Green)
      // .justifyContent(FlexAlign.Start)
      // .alignItems(HorizontalAlign.Start)
    }.height('100%')
    .align(Alignment.Top)
    .width('100%')
    // .backgroundColor(Color.Pink)
  }
}