import { Relic } from '../model/MuseumModels'
import { MuseumStore } from '../model/MuseumStore'

@Component
export struct HistoryPage {
  @ObjectLink store: MuseumStore

  @Builder
  HistoryCard(item: Relic, index: number) {
    Row() {
      Text((index + 1).toString())
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .width(34)
        .height(34)
        .textAlign(TextAlign.Center)
        .backgroundColor('#1F6F69')
        .borderRadius(8)

      Image(item.image)
        .width(82)
        .height(86)
        .objectFit(ImageFit.Cover)
        .borderRadius(8)
        .backgroundColor('#EEF2F2')
        .margin({ left: 12 })

      Column() {
        Text(item.name)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2D2F')
          .margin({ bottom: 6 })

        Text(item.type + ' · ' + item.dynasty)
          .fontSize(14)
          .fontColor('#6E7C80')
          .margin({ bottom: 6 })

        Text('最近浏览，点击可继续查看详情')
          .fontSize(13)
          .fontColor('#8A9699')
      }
      .layoutWeight(1)
      .margin({ left: 12 })
    }
    .width('92%')
    .padding(12)
    .margin({ bottom: 12 })
    .backgroundColor(Color.White)
    .borderRadius(8)
    .onClick(() => {
      this.store.currentIndex = 0
      this.store.addHistory(item.id)
    })
  }

  build() {
    Column() {
      Text('浏览记录')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1F2D2F')
        .margin({ top: 24, bottom: 6 })

      Text('按最近访问顺序保存，方便继续导览')
        .fontSize(15)
        .fontColor('#6E7C80')
        .margin({ bottom: 16 })

      if (this.store.getHistoryList().length === 0) {
        Column() {
          Text('暂无浏览记录')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2D2F')
            .margin({ top: 90, bottom: 12 })

          Text('进入文物详情后，系统会自动记录浏览轨迹。')
            .fontSize(15)
            .fontColor('#6E7C80')
            .margin({ bottom: 24 })

          Button('去浏览文物')
            .width('70%')
            .height(42)
            .backgroundColor('#1F6F69')
            .fontColor(Color.White)
            .borderRadius(8)
            .onClick(() => {
              this.store.currentIndex = 0
            })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      } else {
        Scroll() {
          Column() {
            ForEach(this.store.getHistoryList(), (item: Relic, index: number) => {
              this.HistoryCard(item, index)
            }, (item: Relic) => item.id.toString())
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
        }
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#F6F8FA')
  }
}
