import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { display, window } from '@kit.ArkUI';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  private updateBp(pxWidth: number) {
    let bp = '' //当前应用的断点
    let widthVp = pxWidth / display.getDefaultDisplaySync().densityPixels
    if (widthVp < 320) {
      bp = 'xs'
    } else if (widthVp < 600) {
      bp = 'sm'
    } else if (widthVp < 840) {
      bp = 'md'
    } else {
      bp = 'lg'
    }

    //全局存储
    AppStorage.setOrCreate("bp", bp)
  }

  async onWindowStageCreate(windowStage: window.WindowStage) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    //当窗口刚开始启动的时候，设置当前窗口的bp
    let window = await windowStage.getMainWindow()
    this.updateBp(window.getWindowProperties().windowRect.width)
    //当屏幕尺寸发生变化
    window.on('windowSizeChange', (size) => {
      this.updateBp(size.width)
    })


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
