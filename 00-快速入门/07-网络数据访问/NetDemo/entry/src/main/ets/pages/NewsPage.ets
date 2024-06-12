import http from '@ohos.net.http'

class Item {
  title?: string
  imgsrc?: string
}

@Entry
@Component
struct NewsPage {
  @State showList: Item[] = []

  aboutToAppear() {
    console.log("aboutToAppear=================")
    let request = http.createHttp()
    request.on('headersReceive', (header) => {
      console.log(`接收到的请求头=${JSON.stringify(header)}`)
    })
    let url = "https://v2.alapi.cn/api/new/toutiao?token=qlVquQZPYSeaCi6u"
    let promise = request.request(
      url,
      {
        //请求方式
        method: http.RequestMethod.GET,
        connectTimeout: 60000,
        readTimeout: 60000,
        expectDataType: http.HttpDataType.STRING,
        usingProtocol: http.HttpProtocol.HTTP2,
        header: {
          'Content-Type': 'application/json'
        }
      }
    )

    promise.then((data) => {
      console.log(`========success:${JSON.stringify(data)}`)
      if (data.responseCode === http.ResponseCode.OK) {
        this.showList = JSON.parse(data.result as string)['data']
      }
    }).catch((error) => {
      console.log(`========error:${JSON.stringify(error)}`)
    })
  }

  aboutToDisappear() {
    console.log("aboutToDisappear=================")
  }

  build() {
    Column() {
      List() {
        ForEach(this.showList, (item, index) => {
          ListItem() {
            Row() {
              Text(item.title)
                .margin({ right: 20 })
                .layoutWeight(1)
              Image(item.imgsrc)
                .height(80)
            }
          }.padding(20)
          .height(100)
        }, (item: Item) => item.title)
      }
    }
    .width('100%')
  }
}