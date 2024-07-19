import { notificationManager } from '@kit.NotificationKit'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct Index {
  build() {
    Column({ space: 10 }) {
      Button('发送一个普通文本通知')
        .onClick(() => {
          this.sendNotify('学习鸿蒙通知', '我是学习鸿蒙通知的描述内容。。。。。。')
        })

      Button('更新一个普通文本通知')
        .onClick(() => {
          this.sendNotify('学习鸿蒙通知更新', '我是学习鸿蒙通知更新的描述内容=========')
        })
    }.height('100%')
    .width('100%')
  }

  private async sendNotify(title: string, des: string) {
    try {
      await notificationManager.requestEnableNotification()

      let request: notificationManager.NotificationRequest = {
        id: 100,
        content: {
          notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
          normal: {
            title: title,
            text: des
          }
        }
      }
      await notificationManager.publish(request)
      promptAction.showToast({ message: '发布成功' })
    } catch (e) {
      promptAction.showToast({ message: '发布失败' })
      console.info('发布失败', e)
    }
  }
}
