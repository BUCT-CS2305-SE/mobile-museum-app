import { Relic } from '../model/MuseumModels'
import { MuseumStore } from '../model/MuseumStore'

@Component
export struct SearchPage {
  @ObjectLink store: MuseumStore

  @Builder
  ModeButton(text: string) {
    Button(text)
      .layoutWeight(1)
      .height(38)
      .backgroundColor(this.store.searchMode === text ? '#1F6F69' : '#FFFFFF')
      .fontColor(this.store.searchMode === text ? Color.White : '#24353A')
      .borderRadius(8)
      .border({ width: 1, color: this.store.searchMode === text ? '#1F6F69' : '#DDE5E7' })
      .margin({ left: 4, right: 4 })
      .onClick(() => {
        this.store.searchMode = text
      })
  }

  @Builder
  ResultCard(item: Relic, similarity: string) {
    Row() {
      Image(item.image)
        .width(86)
        .height(92)
        .objectFit(ImageFit.Cover)
        .borderRadius(8)
        .backgroundColor('#EEF2F2')

      Column() {
        Row() {
          Text(item.name)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2D2F')

          Blank()

          if (similarity !== '') {
            Text(similarity)
              .fontSize(14)
              .fontColor('#A3482F')
          }
        }
        .width('100%')
        .margin({ bottom: 6 })

        Text(item.type + ' · ' + item.dynasty)
          .fontSize(14)
          .fontColor('#6E7C80')
          .margin({ bottom: 6 })

        Text(item.intro)
          .fontSize(14)
          .fontColor('#526467')
          .lineHeight(21)
          .margin({ bottom: 2 })

        Button('查看详情')
          .width('100%')
          .height(32)
          .backgroundColor('#1F6F69')
          .fontColor(Color.White)
          .borderRadius(8)
          .margin({ top: 8 })
          .onClick(() => {
            this.store.currentIndex = 0
            this.store.addHistory(item.id)
          })
      }
      .layoutWeight(1)
      .margin({ left: 12 })
    }
    .width('100%')
    .padding(12)
    .margin({ bottom: 12 })
    .backgroundColor(Color.White)
    .borderRadius(8)
  }

  @Builder
  CategoryCount(text: string, count: number) {
    Text(text + ' ' + count.toString())
      .fontSize(13)
      .fontColor('#1F6F69')
      .padding({ left: 8, right: 8, top: 5, bottom: 5 })
      .backgroundColor('#EEF6F5')
      .borderRadius(6)
      .margin({ right: 8, bottom: 8 })
  }

  @Builder
  TextSearch() {
    Column() {
      TextInput({
        placeholder: '输入名称、朝代、类型或关键词，例如：青铜、明代、纹饰',
        text: this.store.keyword
      })
        .width('100%')
        .height(42)
        .backgroundColor('#F4F7F7')
        .borderRadius(8)
        .padding({ left: 10, right: 10 })
        .margin({ bottom: 12 })
        .onChange((value: string) => {
          this.store.keyword = value
        })

      Text('搜索结果：' + this.store.getSearchList().length + ' 条')
        .fontSize(15)
        .fontColor('#6E7C80')
        .margin({ bottom: 10 })

      Row() {
        this.CategoryCount('玉器', this.store.getSearchTypeCount('玉器'))
        this.CategoryCount('瓷器', this.store.getSearchTypeCount('瓷器'))
        this.CategoryCount('青铜器', this.store.getSearchTypeCount('青铜器'))
        this.CategoryCount('中国画', this.store.getSearchTypeCount('中国画'))
      }
      .width('100%')
      .margin({ bottom: 4 })

      ForEach(this.store.getSearchList(), (item: Relic) => {
        this.ResultCard(item, '')
      }, (item: Relic) => item.id.toString() + this.store.keyword)
    }
    .width('92%')
  }

  @Builder
  ImageSearch() {
    Column() {
      Text('图片上传搜索与实时拍照搜索为前端模拟流程：选择入口后，系统展示按相似度排序的文物结果。')
        .fontSize(15)
        .fontColor('#526467')
        .lineHeight(23)
        .margin({ bottom: 12 })

      Row() {
        Button('从相册选择图片')
          .layoutWeight(1)
          .height(40)
          .backgroundColor('#1F6F69')
          .fontColor(Color.White)
          .borderRadius(8)
          .margin({ right: 8 })
          .onClick(() => {
            this.store.imageSearchDone = true
            this.store.imageSearchMode = '相册图片'
          })

        Button('实时拍照搜索')
          .layoutWeight(1)
          .height(40)
          .backgroundColor('#A3482F')
          .fontColor(Color.White)
          .borderRadius(8)
          .margin({ left: 8 })
          .onClick(() => {
            this.store.imageSearchDone = true
            this.store.imageSearchMode = '实时拍照'
          })
      }
      .width('100%')
      .margin({ bottom: 12 })

      if (this.store.imageSearchDone) {
        Text('已选择：' + this.store.imageSearchMode + '，图像特征提取完成。')
          .fontSize(15)
          .fontColor('#6E7C80')
          .margin({ bottom: 10 })

        ForEach(this.store.getImageSearchList(), (item: Relic) => {
          this.ResultCard(item, '相似度 ' + this.store.getSimilarity(item.id))
        }, (item: Relic) => item.id.toString() + this.store.imageSearchMode)
      } else {
        Text('暂未上传图片')
          .fontSize(15)
          .fontColor('#8A9699')
          .padding(14)
          .backgroundColor(Color.White)
          .borderRadius(8)
      }
    }
    .width('92%')
  }

  @Builder
  VoiceSearch() {
    Column() {
      Text('模拟用户说出搜索内容，系统识别语音并抽取关键词。')
        .fontSize(15)
        .fontColor('#526467')
        .lineHeight(23)
        .margin({ bottom: 12 })

      TextInput({
        placeholder: '例如：帮我找明代瓷器',
        text: this.store.voiceSearchInput
      })
        .width('100%')
        .height(42)
        .backgroundColor('#F4F7F7')
        .borderRadius(8)
        .padding({ left: 10, right: 10 })
        .margin({ bottom: 10 })
        .onChange((value: string) => {
          this.store.voiceSearchInput = value
        })

      Button('模拟语音识别')
        .width('100%')
        .height(40)
        .backgroundColor('#1F6F69')
        .fontColor(Color.White)
        .borderRadius(8)
        .onClick(() => {
          this.store.submitVoiceSearch()
        })

      if (this.store.voiceSearchKeyword === '') {
        Text('暂未进行语音搜索')
          .fontSize(15)
          .fontColor('#8A9699')
          .margin({ top: 14 })
      } else {
        Text('识别关键词：' + this.store.voiceSearchKeyword + '，结果 ' + this.store.getVoiceSearchList().length + ' 条')
          .fontSize(15)
          .fontColor('#6E7C80')
          .margin({ top: 14, bottom: 10 })

        ForEach(this.store.getVoiceSearchList(), (item: Relic) => {
          this.ResultCard(item, '')
        }, (item: Relic) => item.id.toString() + this.store.voiceSearchKeyword)
      }
    }
    .width('92%')
  }

  build() {
    Column() {
      Text('搜索中心')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1F2D2F')
        .margin({ top: 24, bottom: 6 })

      Text('覆盖文本搜索、以图搜图和语音搜索')
        .fontSize(15)
        .fontColor('#6E7C80')
        .margin({ bottom: 16 })

      Row() {
        this.ModeButton('文本搜索')
        this.ModeButton('以图搜图')
        this.ModeButton('语音搜索')
      }
      .width('92%')
      .margin({ bottom: 14 })

      Scroll() {
        Column() {
          if (this.store.searchMode === '文本搜索') {
            this.TextSearch()
          } else if (this.store.searchMode === '以图搜图') {
            this.ImageSearch()
          } else {
            this.VoiceSearch()
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#F6F8FA')
  }
}
