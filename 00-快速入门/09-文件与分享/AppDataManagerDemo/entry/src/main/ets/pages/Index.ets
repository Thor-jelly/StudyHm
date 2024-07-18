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

      Button('文件写入/读取')
        .margin(20)
        .onClick(() => {
          router.pushUrl({ url: "pages/FilePage" })
        })

      Button('照片保存选取')
        .margin(20)
        .onClick(() => {
          router.pushUrl({ url: "pages/PhotoPage" })
        })
    }.justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}