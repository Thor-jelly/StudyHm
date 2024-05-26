@Entry
@Component
struct ListPage {
  @State message: string = 'Hello World'
  private list = ['1', '2', '3', '4', '6']

  build() {
    Column() {
      List({ space: 10 }) {
        ForEach(this.list, (item: string) => {
          ListItem() {
            Text(item)
          }.backgroundColor(Color.Orange)
          .width('100%')
        }, (item: string) => item)
      }.divider({ strokeWidth: '5', color: Color.Pink })
      .backgroundColor(Color.Red)

      Divider().height(30)

      Grid() {
        ForEach(this.list, (oItem: string) => {
          ForEach(this.list, (item: string) => {
            GridItem() {
              Text(item)
                .width('100%')
            }.backgroundColor(Color.Orange)
          }, (item: string) => item)
        }, (item: string) => item)
      }.backgroundColor(Color.Pink)
      //.rowsTemplate('1fr 1fr')
      .columnsTemplate('1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
    }
    .height('100%')
    .width('100%')
  }
}