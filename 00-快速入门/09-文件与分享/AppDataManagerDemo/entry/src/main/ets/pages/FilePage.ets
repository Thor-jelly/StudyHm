import { common, Want, wantConstant } from '@kit.AbilityKit'
import { fileIo, fileUri, picker } from '@kit.CoreFileKit'
import { buffer } from '@kit.ArkTS'
import { uniformTypeDescriptor } from '@kit.ArkData'
import { systemShare } from '@kit.ShareKit'
import { promptAction } from '@kit.ArkUI'
import { BusinessError } from '@kit.BasicServicesKit'

@Entry
@Component
struct FilePage {
  private context = getContext(this) as common.UIAbilityContext
  private filesDir = this.context.filesDir

  build() {
    Column() {
      Button('写文件')
        .fontSize(20)
        .margin(20)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          //文件路径
          let filePath = this.filesDir + '/testW.text'
          //用文件路径，创建一个文件流。w+：覆盖式读写，无论文件存在与否。
          let fileStream = fileIo.createStream(filePath, 'w+')
          fileStream.then((stream: fileIo.Stream) => {
            stream.writeSync('我在写文件')
            stream.closeSync()
            console.info(`写文件成功：我在写文件`)
          }).catch((e: Error) => {
            console.info(`写文件报异常：${e}`)
          })
        })

      Button('读文件')
        .fontSize(20)
        .margin(20)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          //文件路径
          let filePath = this.filesDir + '/testW.text'
          //获取文件状态
          let fileStat = fileIo.statSync(filePath)
          //文件大小
          let fileSize = fileStat.size
          //设置一个读取缓冲区，大小与文件大小一致
          let fileBuf = new ArrayBuffer(fileSize)
          //根据文件路径打开流
          let fileStream = fileIo.createStreamSync(filePath, 'r+')
          //读取信息到缓存区，同步方法
          fileStream.readSync(fileBuf)
          //文件读取到缓存区后，再转未通用buffer类型（二进制）
          let con = buffer.from(fileBuf)
          //buffer二进制数据，转换为字符串类型
          let res = con.toString()
          //关闭文件流
          fileStream.close()
          console.info(`读取到的文件内容：${res}`)
        })

      Button('分享文件')
        .fontSize(20)
        .margin(20)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          //文件路径
          let filePath = this.filesDir + '/testW.text'
          //将文件转换成uri
          let uri = fileUri.getUriFromPath(filePath)
          let utd = ''
          if (canIUse('SystemCapability.DistributedDataManager.UDMF.Core')) {
            utd = uniformTypeDescriptor.UniformDataType.PLAIN_TEXT
          }
          console.info(`utd：${utd}`)
          let data = new systemShare.SharedData({
            utd: utd,
            uri: uri
          })
          // let data: systemShare.SharedData = new systemShare.SharedData({
          //   utd: uniformTypeDescriptor.UniformDataType.PLAIN_TEXT,
          //   content: 'Hello HarmonyOS'
          // })
          let ctrl = new systemShare.ShareController(data)
          ctrl.show(this.context, {
            //选用一种预览
            previewMode: systemShare.SharePreviewMode.DETAIL,
            //选用一种选择模式，例如单选
            selectionMode: systemShare.SelectionMode.SINGLE
          })
        })

      Button('分享文件')
        .fontSize(20)
        .margin(20)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          //文件路径
          let filePath = this.filesDir + '/testW.text'
          //将文件转换成uri
          let uri = fileUri.getUriFromPath(filePath)
          let want: Want = {
            //配置被分享文件的读写全县，例如对被分享应用进行读写授权
            flags: wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION | wantConstant.Flags.FLAG_AUTH_WRITE_URI_PERMISSION,
            //配置分享应用的隐式拉起规则
            action: 'ohos.wan.action.sendData',
            uri: uri,
            type: 'text/plain'
          }
          this.context.startAbility(want)
            .then(() => {
              promptAction.showToast({ message: '分享成功' })
            }).catch((e: BusinessError) => {
            console.info(`分享失败：${e.code}，原因：${e.message}`)
            promptAction.showToast({ message: `分享失败：${e.code}，原因：${e.message}`, duration: 5000 })
          })
        })

      Button('保存到用户选择路径')
        .fontSize(20)
        .margin(20)
        .fontWeight(FontWeight.Bold)
        .onClick(async () => {
          try {
            let options = new picker.DocumentSaveOptions()
            options.newFileNames = ['test123.txt']
            let picker1 = new picker.DocumentViewPicker()
            let result = await picker1.save(options)
            //打开文件，读写模式
            let file = fileIo.openSync(result[0], fileIo.OpenMode.READ_WRITE)
            //写入内容
            fileIo.writeSync(file.fd, "保存到用户选择路径====写入内容")
            console.info('保存成功， uri: ' + JSON.stringify(result))
          } catch (error) {
            console.error('保存错误：' + JSON.stringify(error));
          }
        })

      Button('读取用户选择路径文件')
        .fontSize(20)
        .margin(20)
        .fontWeight(FontWeight.Bold)
        .onClick(async () => {
          try {
            let options = new picker.DocumentSelectOptions()
            let documentPicker = new picker.DocumentViewPicker()
            let result = await documentPicker.select(options)
            let file = fileIo.openSync(result[0], fileIo.OpenMode.READ_WRITE)
            let buf = new ArrayBuffer(fileIo.statSync(file.fd).size)
            fileIo.readSync(file.fd, buf)
            let con = buffer.from(buf, 0)
            console.error(`读取内容： ${con}`);
            //return Promise.resolve(con.toString())
          } catch (err) {
            console.error('读取失败： ' + JSON.stringify(err));
          }
          //return Promise.reject()
        })
    }
    .width('100%')
  }
}