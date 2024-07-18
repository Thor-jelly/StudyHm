import { fileIo, picker } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct PhotoPage {
  private context = getContext(this) as common.UIAbilityContext

  build() {
    Column() {
      Button('保存本地图片到相册选择位置')
        .fontSize(20)
        .margin(20)
        .fontWeight(FontWeight.Bold)
        .onClick(async () => {
          let options = new picker.PhotoSaveOptions
          options.newFileNames = ['test.jpg'] //保存文件名
          let picker1 = new picker.PhotoViewPicker()
          try {
            let result = await picker1.save(options)
            let file = await fileIo.open(result[0], fileIo.OpenMode.READ_WRITE)
            let buffer = this.context.resourceManager.getMediaContentSync($r('app.media.app_icon').id)
            await fileIo.write(file.fd, buffer.buffer)
          } catch (e) {
            console.error('保存失败：' + JSON.stringify(e))
          }
        })


      Button('获取相册图片uri')
        .fontSize(20)
        .margin(20)
        .fontWeight(FontWeight.Bold)
        .onClick(async () => {
          let photoSelectOptions = new picker.PhotoSelectOptions()
          photoSelectOptions.maxSelectNumber = 1
          let photoPicker = new picker.PhotoViewPicker()
          try {
            let result = await photoPicker.select(photoSelectOptions)
            console.info('选择结果 uri', JSON.stringify(result))
            let uris = result.photoUris
            console.info('选择结果 uri=', uris)
          } catch (e) {
          }
        })
    }
    .width('100%')
  }
}