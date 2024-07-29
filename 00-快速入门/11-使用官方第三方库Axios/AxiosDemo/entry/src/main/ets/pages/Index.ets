import { HashMap } from '@kit.ArkTS';
import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios';
import json from '@ohos.util.json';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          axios.interceptors.request.use((config: InternalAxiosRequestConfig) => {
            // 对请求数据做点什么
            console.info(JSON.stringify(config))
            return config;
          }, (error: AxiosError) => {
            // 对请求错误做些什么
            return Promise.reject(error);
          });

          type mAny = number | boolean | string | object | null
          let h = new Map<string, mAny>()
          h.set("key", 'v')
          h.set('data', new Map<string, mAny>())
          let dP = h.get('data') as Map<string, mAny>
          dP.set('i', 'iiii')
          let newP = this.mapToObject<string, mAny>(h);
          console.log(JSON.stringify(newP))

          axios.get('https://wanandroid.com/harmony/index/json', { params: newP })
            .then((model: AxiosResponse<mAny>) => {
              console.info('返回数据', model)
              console.info(JSON.stringify(model))
            }).catch((error: AxiosError) => {
            console.info('异常', error)
          })
        })
    }
    .height('100%')
    .width('100%')
  }

  mapToObject<K extends string, V>(map: Map<K, V>): Record<K, V> {
    const obj: Record<K, V> = {} as Record<K, V>
    map.forEach((value, key) => {
      if (value instanceof Map) {
        obj[key] = this.mapToObject(value as Map<K, V>)  as V
      } else {
        obj[key] = value
      }
    })
    return obj
  }
}