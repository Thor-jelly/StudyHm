import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { pushService } from '@kit.PushKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { notificationManager } from '@kit.NotificationKit';

export default class EntryAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    try {
      const pushToken = await pushService.getToken()
      //上报Push Token
      console.log('上报Push Token：', pushToken)
      this.requestNotification()
    } catch (error) {
      const e: BusinessError = error as BusinessError;
      console.error("获取Push Token 失败：", JSON.stringify(e));
    }
  }

  /**
   * 请求通知授权
   */
  private async requestNotification() {
    console.log('请求通知授权 requestNotification')
    try {
      const notificationEnabled = await notificationManager.isNotificationEnabled()
      console.log('请求通知授权是否授权：', notificationEnabled)
      if (!notificationEnabled) {
        //未授权，请求通知授权
        await notificationManager.requestEnableNotification()
      }
    } catch (error) {
      const e: BusinessError = error as BusinessError
      console.error("requestNotification 失败：", JSON.stringify(e));
    }
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
