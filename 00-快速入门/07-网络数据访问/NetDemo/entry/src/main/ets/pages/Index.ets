import router from '@ohos.router'

@Entry
@Component
struct Index {
  build() {
    Row() {
      Column() {
        Button('http请求')
          .margin(20)
          .onClick(() => {
            router.pushUrl({ url: "pages/NewsPage" })
          })

        Button('http流式请求文件')
          .margin(20)
          .onClick(() => {
            router.pushUrl({ url: "pages/DownloadPage" })
          })

        Button('http流式请求图片')
          .margin(20)
          .onClick(() => {
            router.pushUrl({ url: "pages/DownloadPage2" })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}