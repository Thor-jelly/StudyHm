import router from '@ohos.router'

@Entry
@Component
struct Index {
  build() {
    Column() {
      Button('数据库')
        .margin(20)
        .onClick(() => {
          router.pushUrl({ url: "pages/SqlPage" })
        })
      Button('Preferences使用')
        .margin(20)
        .onClick(() => {
          router.pushUrl({ url: "pages/PreferencesPage" })
        })
    }.justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}