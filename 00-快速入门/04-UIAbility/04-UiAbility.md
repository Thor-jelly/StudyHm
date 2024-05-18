[TOC]

# UIAbility是什么

- `UIAbility` 是HarmonyOS 中一种包含UI界面的应用组件，主要用于与用户进行交互。它也是系统调度的基本单元，为应用提供绘制界面的窗口。

- 一个 UIAbility 组件中可以通过多个页面来实现一个功能模块。

- 每一个 UIAbility 组件实例，都对应一个最近任务列表中的任务。因此，对于开发者而言，可以根据具体的场景选择 **单个** 或者 **多个** UIAbility。



# UIAbility内页面的创建

1. 在 DevEco Studio中创建的UIAbility中，该Ability实例默认会加载Index页面，你可以根据需要将Index页面路径替换为需要的页面路径。
2. 所有创建的页面都需要在`main_pages.json`配置，通过DevEco Studio创建的页面会自动配置。
3. 手动创建的`page`文件到 `entry -> src -> main -> ets -> pages` 目录

![](.\pic\01.png)



# 页面间的跳转和数据传递

- 在HarmonyOs中，页面路由可以在应用程序中实现不同页面之前的跳转和数据传递。
- HarmonyOS提供了`Router`模块，通过不同的url地址，可以方便的进行页面路由，轻松的访问不同的页面。
- Router模块提供了两种跳转模式：
  1. router.pushUrl()：目标页不会替换当前页，而是压入页面栈。这样可以保留当前页的状态，并且可以通过返回键或者调用`router.back()`方法返回到当前页。
  2. router.replaceUrl()：目标页会替换当前页，并销毁当前页。这样可以释放当前页的资源，并且无法返回到当前页。
- 页面栈的**最大容量为32个页面**。如果超过这个限制，可以调用router.clear()方法清空历史页面栈，释放内存空间。

```
//跳转
router.pushUrl({
	//跳转到的url
	url: CommonConstants.HOME_URL,
	//传递的对象：创建一个新的 routerParams 对象，并设置其中的 src 属性为 CommonConstants.HOME_SRC_MSG
	params: new routerParams(CommonConstants.HOME_SRC_MSG)
}).catch((error: Error) => {
	//如果页面跳转失败，使用Logger.info 方法打印错误信息到控制台
	Logger.info("123===", `IndexPage push error ${JSON.stringify(error)}`)
})
```



Router模块提供了两种实例模式，分别是Standard和Single。这两种模式决定了目标url是否会对应多个实例。

- Standard：标准实例模式，也是默认情况下的实例模式。每次调用该方法都会新建一个目标页，并压入栈顶。
- Single：单实例模式。即如果目标页的url在页面栈中已经存在同url页面，则离栈顶最近的同url页面会被移动到栈顶，并重新加载；如果目标页的url在页面栈中不存在同url页面，则按照标准模式跳转。



# UIAbility的生命周期



1. UIAbility的生命周期主要包括四个状态
2. 在不同状态之间转换时，系统会调用相应的生命周期回调函数
3. 合理管理UIAbility的生命周期可以提高应用的性能和用户体验



## 四个状态

![生命周期四个状态](.\pic\02.png)

1. Create：在应用加载过程中，UIAbility 实例创建完成时触发，系统会调用`onCreate()`回调。可以在回调中进行应用初始化操作，例如：变量定义、资源加载等，用于后续的UI界面展示。
2. Foreground：表示 UIAbility 实例进入前台，用户可以与应用进行交互。在进入 Foreground 之前，系统会创建一个`WindowStage`，WindowStage 创建完成后会触发 `onWindowStageCreate()` 回调，可以在该回调中设置 UI 界面加载和订阅 WindowStage 的事件。
3. Background：表示 UIAbility 实例进入后台，用户不可与应用进行交互。当应用从 Foreground 切换到 Background 时，系统会调用 `onBackground()` 回调，可以在该回调中释放资源或者执行其他后台操作。
4. Destroy：表示 UIAbility 实例被销毁，系统会调用 `onDestroy()` 回调，可以在该回调中释放资源或执行其他清理操作。



### Create状态

在应用加载过程中，UIAbility 实例创建完成时触发，系统会调用`onCreate()`回调。可以在回调中进行应用初始化操作，例如：变量定义、资源加载等，用于后续的UI界面展示。

```
export default class EntryAbility extends UIAbility {
	onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
 		// ⻚⾯初始化
  	}
}
```

`Want`是对象间信息传递的载体，可以用于应用组件间的信息传递。`want`的详细介绍请参见信息传递载体`Want`。



### WindowStageCreate 和 WindowStageDestroy 状态

UIAbility 实例创建完成之后，在进入 Foreground 之前，系统会创建一个 WindowStage。WindowStage 创建完成后会进入 onWindowStageCreate() 回调，可以在该回调中设置UI加载、设置WindowStage的事件订阅。

![windowStage事件](.\pic\03.png)



在`onWindowStageCreate()`回调中通过`loadContent()`方法设置应用要加载的页面，并根据需要调用`on('windowStageEvent')`方法订阅`WindowStage`的事件（获焦/失焦、可见/不可见）。

```
 export default class EntryAbility extends UIAbility {
 	//...
 	onWindowStageCreate(windowStage: window.WindowStage): void {
 		// 设置 WindowStage 的事件订阅（获焦/失焦、可⻅/不可⻅）
		try {
 			windowStage.on('windowStageEvent', (data) => {
 				let stageEventType: window.WindowStageEventType = data;
                switch (stageEventType) {
                    case window.WindowStageEventType.SHOWN: // 切到前台
                        Logger.info('windowStage foreground.');
                        break;
                    case window.WindowStageEventType.ACTIVE: // 获焦状态
                        Logger.info('windowStage active.');
                        break;
                    case window.WindowStageEventType.INACTIVE: // 失焦状态
                        Logger.info('windowStage inactive.');
                        break;
                    case window.WindowStageEventType.HIDDEN: // 切到后台
                        Logger.info('windowStage background.');
                        break;
                    default:
                        break;
                }
     		 });
    	} catch (exception) {
     		 Logger.error('Failed to enable the listener for window stage event changes. Cause:' + JSON.stringify(exception));
   		}
   		
    	// 设置 UI 加载
    	windowStage.loadContent('pages/Index', (err, data) => {
      		//...
    	});
  	}
 }
```

`WindowStage`的相关使用参见窗口开发指导。

对应于`onWindowStageCreate()`回调。在 UIAbility 实例销毁之前，则会先进入 `onWindowStageDestroy()`回调，可以在该回调中释放UI资源。

```
export default class EntryAbility extends UIAbility {
	windowStage: window.WindowStage | undefined = undefined
	
	onWindowStageCreate(windowStage: window.WindowStage): void {
		this.windowStage = windowStage;
	}
	
	onWindowStageDestroy() {
		//释放UI资源
	}
}
```



### Foreground 和 Background 状态

`Foreground`和`Background`状态分别在 UIAbility 实例 切换前台 和 切换后台时触发，对应于`onForeground()`回调和`onBackground()`回调。

`onForeground()`回调，在UIAbility的UI可见之前，如UIAbility切换至前台时触发。可以在onForeground()中申请系统需要的资源，或重新申请在`onBackground()`中释放的资源。

`onBackground()`回调，在UIAbility的UI完全不可见之后，如UIAbility切换至后台时触发。可以在onBackground()回调中释放UI不可见时无用的资源，或者在回调中执行较为耗时的操作，例如状态保存等。

例如：

- 应用在使用过程中需要使用用户定位时，并已经获取用户定位权限授权。在UI显示之前，可以在onForeground()回调中开启定位功能，从而获取到当前位置信息。

- 当用户切换到后台状态，可以在onBackground()回调中停止定位功能，以节省系统的资源小号。

```
export default class EntryAbility extends UIAbility {
	onForeground(): void {
		//申请系统需要的资源，或 重新申请在onBackground()中释放的资源
	}
	
	onBackground(): void {
		//释放 UI 不可见时无用的资源，或 在此回调中执行较为耗时的操作
		//例如状态保存等
	}
}
```



### Destroy 状态

Destroy状态在UIAbility实例销毁时触发。可以在`onDestroy()`回调中进行系统资源的释放、数据的保存等操作。

例如：调用`terminateSelf()`方法停止当前`UIAbility`实例，从而完成UIAbility实例的销毁；或 用户使用最近任务列表关闭该`UIAbility`实例，完成UIAbility的销毁。

```
export default class EntryAbility extends UIAbility {
	onDestroy() {
		//系统资源的释放、数据的保存等
	}
}
```



# UIAbility 基本用法

- 指定UIAbility的启动页面
- 获取UIAbility的上下文UIAbilityContext



### 指定启动页面

应用中的UiAbility在启动过程中，需要指定启动页面，否则应用启动后会因为没有默认加载页面而导致白屏。

可以在UIAbility的onWindowStageCreate()回调中，通过WindowStage对象的`loadContent()`方法设置启动页面.

```
export default class EntryAbility extends UIAbility {
 	//...
 	onWindowStageCreate(windowStage: window.WindowStage): void {
 		
    	// 设置 UI 加载
    	windowStage.loadContent('pages/Index', (err, data) => {
      		if(err.code) {
      			//加载失败
      			return;
      		}
      		//加载成功
    	});
  	}
 }
```



### 获取上下文UIAbilityContext

