import { APP_EXIT_INTERVAL, TIME } from '../common/constants/Constants';
import { RankData } from '../viewmodel/RankData';
import { RankViewModel } from '../viewmodel/RankViewModel';
import promptAction from '@ohos.promptAction';

let rankModel: RankViewModel = new RankViewModel();

@Entry
@Component
struct RankPage {
  @State dataSource1: RankData[] = [];
  @State dataSource2: RankData[] = [];
  //
  @State isSwitchDataSource: boolean = true;
  //
  private clickBackTimeRecord: number = 0;

  aboutToAppear() {
    this.dataSource1 = rankModel.loadRankDataSource1()
    this.dataSource2 = rankModel.loadRankDataSource2()
  }

  onBackPress() {
    if (this.isShowToast()) {
      promptAction.showToast({
        message: $r('app.string.prompt_text'),
        duration: TIME
      })
      this.clickBackTimeRecord = new Date().getTime();
      return true;
    }

    return false;
  }

  isShowToast(): boolean {
    return new Date().getTime() - this.clickBackTimeRecord > APP_EXIT_INTERVAL;
  }


  build(){
    Column(){
      //
      //TitleComponent
    }
  }
}