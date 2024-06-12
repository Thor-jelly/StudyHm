import { http } from '@kit.NetworkKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { image } from '@kit.ImageKit';

const URL = "https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png"

@Entry
@Component
struct DownloadPage2 {
  @State progress: number = 0
  @State downloadUrl: string = URL
  @State downloadFinished: boolean = false
  @State pixelMap?: PixelMap = undefined
  imageBuffer: ArrayBuffer = new ArrayBuffer(0)

  download(): void {
    let httpRequest = http.createHttp()
    httpRequest.on('headersReceive', (header) => {
      console.info('header: ' + JSON.stringify(header))
    })
    httpRequest.on('dataReceive', (data: ArrayBuffer) => {
      this.imageBuffer = concatenateArrayBuffers(this.imageBuffer, data)
      let writeLen: number = this.imageBuffer.byteLength
      console.info('write data to file succeed and size is:' + writeLen);
    })
    httpRequest.on('dataReceiveProgress', (info: http.DataReceiveProgressInfo) => {
      this.progress = info.receiveSize / info.totalSize * 100
    })
    httpRequest.on('dataEnd', () => {
      this.downloadFinished = true
      this.progress = 0
      let imageSource: image.ImageSource = image.createImageSource(this.imageBuffer);
      imageSource.createPixelMap().then((pixelMap: PixelMap) => {
        this.pixelMap = pixelMap
      })
      console.info('dataEnd')

      this.imageBuffer
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
        Image(this.pixelMap)
          .width(100)
          .height(100)
          .objectFit(ImageFit.Contain)
        Button("下载")
          .margin({ top: 10 })
          .onClick(() => {
            this.downloadFinished = false
            this.download()
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

function concatenateArrayBuffers(buffer1: ArrayBuffer, buffer2: ArrayBuffer): ArrayBuffer {
  const totalLength = buffer1.byteLength + buffer2.byteLength;
  const result = new ArrayBuffer(totalLength);
  const resultView = new Uint8Array(result);

  resultView.set(new Uint8Array(buffer1), 0);
  resultView.set(new Uint8Array(buffer2), buffer1.byteLength);

  return result;
}