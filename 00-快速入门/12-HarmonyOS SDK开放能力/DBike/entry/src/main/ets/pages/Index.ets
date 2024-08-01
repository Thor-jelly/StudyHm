import { map, mapCommon, MapComponent } from '@kit.MapKit'
import { AsyncCallback } from '@kit.BasicServicesKit'
import { promptAction } from '@kit.ArkUI'
import { abilityAccessCtrl, Permissions } from '@kit.AbilityKit'
import { PermissionsUtils } from '../utils/PermissionsUtils'
import { geoLocationManager } from '@kit.LocationKit'
import { LocationUtils } from '../utils/LocationUtils'
import { scanBarcode, scanCore } from '@kit.ScanKit'
import { JSON } from '@kit.ArkTS'

@Entry
@Component
struct Index {
  mapController?: map.MapComponentController = undefined
  private mapOption?: mapCommon.MapOptions
  private mapCallback?: AsyncCallback<map.MapComponentController>
  private locationPermissions: Array<Permissions> =
    ['ohos.permission.APPROXIMATELY_LOCATION', 'ohos.permission.LOCATION']

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      //调用MapComponent组件初始化地图
      MapComponent({
        mapOptions: this.mapOption,
        mapCallback: this.mapCallback
      }).width('100%').height('100%').offset({ y: -56 })

      //底部扫一扫布局
      Row() {
        //左侧信息布局
        Column({ space: 8 }) {
          Text('扫码用车')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
          Text('附近有3辆单车可用')
            .fontSize(12)
            .fontWeight(FontWeight.Normal)
        }
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Start)

        //右侧扫一扫按钮布局
        Button() {
          Row({ space: 8 }) {
            Image($r('app.media.app_icon'))
              .width(20)
              .height(20)
              .fillColor(Color.White)
            Text('扫一扫')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
          }
        }
        .height(40)
        .type(ButtonType.Capsule)
        .padding({ left: 10, right: 10 })
        .linearGradient({
          angle: 45,
          colors: [[0x49c5ef, 0.3], [0x4caefe, 0.8]]
        })
        .onClick(() => {
          this.startScan()
        })
      }
      .width('100%')
      .height(64)
      .justifyContent(FlexAlign.SpaceBetween)
      .borderRadius({ topLeft: 16, topRight: 16 })
      .backgroundColor(Color.White)
      .padding({ left: 16, right: 16 })
    }.width('100%')
    .height('100%')
  }

  aboutToAppear(): void {
    //地图初始化参数，设置地图中心点坐标及层级
    this.mapOption = {
      position: {
        target: {
          latitude: 39.9,
          longitude: 116.4
        },
        zoom: 15
      }
    }

    //初始化地图回调
    this.mapCallback = async (err, mapController) => {
      console.log("mapCallback error", err)
      if (!err) {
        //获取地图控制器类，用来操作地图
        this.mapController = mapController
        //监听加载完成
        this.mapController?.on('mapLoad', async () => {
          promptAction.showToast({ message: '地图加载完成' })
          //获取是否有定位权限
          const grantStatus = await this.checkPermissions()
          if (!grantStatus) {
            //请求权限
            await PermissionsUtils.reqPermissionsFromUser(this.locationPermissions)
          }
          this.mapController?.setMyLocationEnabled(true)
          this.mapController?.setMyLocationControlsEnabled(true)
        })

        //监听点击我的位置
        this.mapController?.on('myLocationButtonClick', async () => {
          promptAction.showToast({ message: '点击我的位置按钮' })
          this.getMyLocation()
        })
      }
    }
  }

  /**
   * 启用默认扫码界面
   */
  async startScan() {
    console.log('默认扫码界面开始')
    //定义扫码参数options
    const options: scanBarcode.ScanOptions = {
      scanTypes: [scanCore.ScanType.ALL],
      enableMultiMode: true,
      enableAlbum: true
    }

    try {
      const result = await scanBarcode.startScanForResult(getContext(this), options)
      console.log('扫码成功：', JSON.stringify(result))
      promptAction.showToast({ message: '扫码成功' })
    } catch (e) {
      console.log('扫码失败：', e.message)
    }
  }

  /**
   * 检验应用是否被授权定位权限
   */
  async checkPermissions(): Promise<boolean> {
    for (let permission of this.locationPermissions) {
      const grantStatus = PermissionsUtils.checkAccessToken(permission)
      if (grantStatus == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        return true
      }
    }
    return false
  }

  /**
   * 获取当前定位
   */
  async getMyLocation() {
    const location: geoLocationManager.Location | undefined = await LocationUtils.currentLocation()
    if (location === undefined) {
      return
    }
    this.mapController?.setMyLocation(location)
    this.mapController?.animateCamera(map.newLatLng({
      latitude: location.latitude,
      longitude: location.longitude
    }, 15), 200)
  }
}
