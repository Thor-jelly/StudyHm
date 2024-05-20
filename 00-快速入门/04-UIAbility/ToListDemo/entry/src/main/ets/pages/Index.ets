import { ToDoItem } from '../view/ToDoItem'

@Entry
@Component
struct Index {
  private toDoList: Array<string> = ['晨练', '做早餐', '学习', '上班', '睡觉']

  build() {
    //标题 代办
    //item view
    Column({ space: 30 }) {
      Text('待办')
        .fontSize(28)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Start)


      List({ space: 10 }) {
        ForEach(this.toDoList, (item: string) => {
          ToDoItem({ text: item })
        }, (item: string) => item)

        // LazyForEach(this.toDoList, (item: string) => {
        //
        // }, (item: string) => item)
      }
    }.padding(20)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor(Color.Gray)
    .width('100%')
    .height('100%')
  }
}