import { geoLocationManager } from '@kit.LocationKit';

export class LocationUtils {
  /**
   * 获取当前位置
   */
  static async currentLocation(): Promise<geoLocationManager.Location | undefined> {
    const request: geoLocationManager.SingleLocationRequest = {
      'locatingPriority': geoLocationManager.LocatingPriority.PRIORITY_LOCATING_SPEED,
      'locatingTimeoutMs': 10000
    }
    let location: geoLocationManager.Location | undefined = undefined
    try {
      location = await geoLocationManager.getCurrentLocation(request)
      console.error(`LocationUtils currentLocation 成功。获取到数据：${JSON.stringify(location)}`)
    } catch (e) {
      console.error(`LocationUtils currentLocation 失败。原因：${JSON.stringify(e)}`)
    }
    return location
  }
}