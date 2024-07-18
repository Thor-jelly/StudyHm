import preferences from '@ohos.data.preferences'

@Entry
@Component
struct PreferencesPage {
  private context = getContext(this)
  private preference = preferences.getPreferences(this.context, 'PreferencesDemo')

  build() {
    Column() {
      Button('put数据')
        .fontSize(20)
        .margin(20)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          this.preference.then(async (p) => {
            await p.put('key', 'value')
            await p.flush()
            console.info("preference put成功")
          }).catch((e: Error) => {

          })
        })

      Button('get数据')
        .fontSize(20)
        .margin(20)
        .fontWeight(FontWeight.Bold)
        .onClick(async () => {
          let p = await this.preference
          let str = await p.get('key', 'defValue')
          console.info(`preference get到数据${str}`)
        })

      Button('del数据')
        .fontSize(20)
        .margin(20)
        .fontWeight(FontWeight.Bold)
        .onClick(async () => {
          let p = await this.preference
          await p.delete('key')
          await p.flush() //此处一定要flush，要不然不能永久序列化到本地
          console.info('preference del数据成功')
        })

      Button('clear 清空缓存')
        .fontSize(20)
        .margin(20)
        .fontWeight(FontWeight.Bold)
        .onClick(async () => {
          let p = await this.preference
          await p.clear()
          await p.flush() //此处一定要flush，要不然不能永久序列化到本地
          console.info('preference clear数据成功')
        })
    }
    .width('100%')
  }
}