import Home from '../view/Home';
import MySet from '../view/Set';

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();

  // 自定义tab样式
  @Builder
  TabBuilder(title: string, index: number, s: Resource, n: Resource) {
    Column() {
      Image(this.currentIndex == index ? s : n)
        .width(25)
        .height(25)

      Text(title)
        .margin({ top: 5 })
        .fontSize(12)
        .fontColor(this.currentIndex === index ? '#1698CE' : '6B6B6B')
    }.justifyContent(FlexAlign.Center)
    .height(56)
    .width('100%')
    .onClick(() => {
      this.currentIndex = index
      this.tabsController.changeIndex(index)
    })
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
      TabContent() {
        //主界面
        Home()
      }.padding({ left: 12, right: 12 })
      .backgroundColor('#F1F3F5')
      .tabBar(this.TabBuilder('首页', 0, $r('app.media.ic_home_selected'), $r('app.media.ic_home')))

      TabContent() {
        MySet()
      }
      .padding({ left: 12, right: 12 })
      .backgroundColor('#F1F3F5')
      .tabBar(this.TabBuilder('我的', 1, $r('app.media.ic_mine_selected'), $r('app.media.ic_mine')))
    }
    .width('100%')
    .backgroundColor(Color.White)
    .barHeight(56)
    .barMode(BarMode.Fixed)
    .onChange((index: number) => {
      this.currentIndex = index
    })
  }
}