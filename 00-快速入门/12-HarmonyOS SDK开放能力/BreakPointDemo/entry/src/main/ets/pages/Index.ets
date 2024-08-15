import { BreakpointType } from '../utils/breakpoint/BreakpointSystem'

@Entry
@Component
struct Index {
  @StorageProp('bp') bp: string = ''

  build() {
    Column() {
      Button(new BreakpointType({
        sm: '小屏幕',
        md: '中屏幕',
        lg: '大屏幕'
      }).getValue(this.bp))
        .fontSize(66)
        .width('100%')
        .height('100%')
        .align(Alignment.Center)
    }
  }
}