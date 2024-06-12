import { http } from '@kit.NetworkKit'
import { BusinessError } from '@kit.BasicServicesKit'
import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';

// https://www.lddgo.net/string/random-file-generator 生成任意大小文件
// const url = "https://dldir1.qq.com/qqfile/qq/PCQQ9.7.17/QQ9.7.17.29225.exe"
// https://www.diskgenius.cn/download.php
const URL = "https://s-83.lanzog.com/04251500151009298bb/2023/12/05/be54091afc90aabaffa8273c0eb21f07.zip?st=oGxCURSRs_4hRGWNo6QgEg&e=1714030478&b=BxFaHVBlAjJRNVM0B2JQZFU4Xl1ULVNtUjcKKVUoVj0IKg_c_c&fi=151009298&pid=223-166-100-200&up=2&mp=0&co=0"
const DEFAULT_FILE_NAME = "DiskGen.exe"

@Entry
@Component
struct DownloadPage {
  @State progress: number = 0
  @State downloadUrl: string = URL
  @State downloadFinished: boolean = false

  download(file: fs.File): void {
    let httpRequest = http.createHttp()
    httpRequest.on('headersReceive', (header) => {
      console.info('header: ' + JSON.stringify(header))
    })
    httpRequest.on('dataReceive', (data: ArrayBuffer) => {
      let writeLen: number = fs.writeSync(file.fd, data);
      console.info('write data to file succeed and size is:' + writeLen);
    })
    httpRequest.on('dataReceiveProgress', (info: http.DataReceiveProgressInfo) => {
      this.progress = info.receiveSize / info.totalSize * 100
    })
    httpRequest.on('dataEnd', () => {
      fs.closeSync(file);
      this.downloadFinished = true
      this.progress = 0
      console.info('dataEnd')
    })

    let promise = httpRequest.requestInStream(
      // 请求url地址
      this.downloadUrl,
      {
        // 请求方式
        method: http.RequestMethod.GET,
        // 可选，默认为60s
        connectTimeout: 60000,
        // 可选，默认为60s
        readTimeout: 60000,
        // 可选，默认无此字段
        expectDataType: http.HttpDataType.STRING,
        // 可选，默认为true
        usingCache: true,
        // 可选，默认为1
        priority: 1,
        // 可选，默认值由系统自动指定。
        usingProtocol: http.HttpProtocol.HTTP1_1,
        // 可选，默认为false
        usingProxy: false,
        // 开发者根据自身业务需要添加header字段
        header: {
          'Content-Type': 'application/json'
        }
      })
    promise.then((data) => {
      console.info('Result:' + data)
    }).catch((err: BusinessError) => {
      console.info('error:' + JSON.stringify(err))
    })
  }

  build() {
    Row() {
      Column() {
        TextInput({ text: this.downloadUrl })
          .margin({ bottom: 20 })
        Progress({ value: this.downloadFinished ? 0 : this.progress })
          .margin({ left: 20, right: 20 })
        Button("下载")
          .margin({ top: 10 })
          .onClick(() => {
            this.downloadFinished = false

            const documentSaveOptions = new picker.DocumentSaveOptions(); // 创建文件管理器选项实例
            documentSaveOptions.newFileNames = [DEFAULT_FILE_NAME]; // 保存文件名（可选）
            //documentSaveOptions.fileSuffixChoices = [".exe"]; // 保存文件类型（可选）

            let uris: Array<string> = [];
            const documentViewPicker = new picker.DocumentViewPicker(); // 创建文件选择器实例
            documentViewPicker.save(documentSaveOptions).then((documentSaveResult: Array<string>) => {
              uris = documentSaveResult;
              console.info('documentViewPicker.save to file succeed and uris are:' + uris);

              let file = fs.openSync(documentSaveResult[0], fs.OpenMode.READ_WRITE);
              console.info('file fd: ' + file.fd);

              this.download(file)
            }).catch((err: BusinessError) => {
              console.error(`Invoke documentViewPicker.save failed, code is ${err.code}, message is ${err.message}`);
            })
          })
        Text("下载完成")
          .fontSize(30)
          .backgroundColor(Color.Green)
          .fontColor(Color.White)
          .borderRadius(8)
          .padding(8)
          .margin({ top: 20 })
          .visibility(this.downloadFinished ? Visibility.Visible : Visibility.Hidden)
      }
      .width('100%')
    }
    .height('100%')
  }
}