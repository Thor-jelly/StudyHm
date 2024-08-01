import { abilityAccessCtrl, bundleManager, common, PermissionRequestResult, Permissions } from '@kit.AbilityKit'

const context = getContext(this) as common.UIAbilityContext

export class PermissionsUtils {
  /**
   * 检查是否授权
   */
  static checkAccessToken(permission: Permissions): abilityAccessCtrl.GrantStatus {
    const atManager = abilityAccessCtrl.createAtManager()
    let grantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED
    let tokenId = 0
    try {
      //获取app包相关信息
      const bundleInfo =
        bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
      const appInfo = bundleInfo.appInfo
      tokenId = appInfo.accessTokenId
      grantStatus = atManager.checkAccessTokenSync(tokenId, permission)
    } catch (e) {
      console.error(`PermissionsUtils checkAccessToken 失败。原因：${JSON.stringify(e)}`)
    }
    return grantStatus
  }

  /**
   * 动态申请权限
   */
  static async reqPermissionsFromUser(permissions: Permissions[]): Promise<number[]> {
    const atManager = abilityAccessCtrl.createAtManager()
    let result: PermissionRequestResult = { permissions: [], authResults: [] }
    try {
      result = await atManager.requestPermissionsFromUser(context, permissions)
    } catch (e) {
      console.error(`PermissionsUtils reqPermissionsFromUser 失败。原因：${JSON.stringify(e)}`)
    }

    console.log("reqPermissionsFromUser", JSON.stringify(result))
    return result.authResults
  }
}