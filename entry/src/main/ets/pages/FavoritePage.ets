import { FavoriteGroup, Relic } from '../model/MuseumModels'
import { MuseumStore } from '../model/MuseumStore'

@Component
export struct FavoritePage {
  @ObjectLink store: MuseumStore

  @Builder
  GroupButton(text: string, selected: boolean, action: () => void) {
    Button(text)
      .height(34)
      .padding({ left: 12, right: 12 })
      .backgroundColor(selected ? '#1F6F69' : '#FFFFFF')
      .fontColor(selected ? Color.White : '#24353A')
      .borderRadius(8)
      .border({ width: 1, color: selected ? '#1F6F69' : '#DDE5E7' })
      .onClick(action)
  }

  @Builder
  RelicMiniCard(item: Relic) {
    Row() {
      Image(item.image)
        .width(88)
        .height(96)
        .objectFit(ImageFit.Cover)
        .borderRadius(8)
        .backgroundColor('#EEF2F2')

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

        Text('热度 ' + item.hot)
          .fontSize(14)
          .fontColor('#A3482F')

        Row() {
          Button(this.store.isLiked(item.id) ? '取消点赞' : '点赞')
            .layoutWeight(1)
            .height(32)
            .backgroundColor('#F4F7F7')
            .fontColor('#24353A')
            .borderRadius(8)
            .margin({ right: 6 })
            .onClick(() => {
              this.store.toggleLike(item.id)
            })

          Button(this.store.isCollected(item.id) ? '取消收藏' : '收藏')
            .layoutWeight(1)
            .height(32)
            .backgroundColor('#F4F7F7')
            .fontColor('#24353A')
            .borderRadius(8)
            .margin({ left: 6 })
            .onClick(() => {
              this.store.toggleCollect(item.id)
            })
        }
        .width('100%')
        .margin({ top: 10 })
      }
      .layoutWeight(1)
      .margin({ left: 12 })
    }
    .width('92%')
    .padding(12)
    .margin({ bottom: 12 })
    .backgroundColor(Color.White)
    .borderRadius(8)
  }

  build() {
    Column() {
      Text('点赞收藏')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1F2D2F')
        .margin({ top: 24, bottom: 6 })

      Text('收藏夹支持分组管理，便于按主题整理馆藏')
        .fontSize(15)
        .fontColor('#6E7C80')
        .margin({ bottom: 16 })

      if (!this.store.isLoggedIn) {
        Column() {
          Text('请先登录后查看收藏')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2D2F')
            .margin({ top: 80, bottom: 12 })

          Text('登录后可以查看点赞、收藏和分组数据。')
            .fontSize(15)
            .fontColor('#6E7C80')
            .margin({ bottom: 24 })

          Button('去登录')
            .width('70%')
            .height(42)
            .backgroundColor('#1F6F69')
            .fontColor(Color.White)
            .borderRadius(8)
            .onClick(() => {
              this.store.currentIndex = 4
            })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      } else {
        Column() {
          Row() {
            TextInput({
              placeholder: '新建收藏夹，例如：重点讲解',
              text: this.store.favoriteGroupInput
            })
              .layoutWeight(1)
              .height(40)
              .backgroundColor('#F4F7F7')
              .borderRadius(8)
              .padding({ left: 10, right: 10 })
              .onChange((value: string) => {
                this.store.favoriteGroupInput = value
              })

            Button('新建')
              .width(76)
              .height(40)
              .backgroundColor('#1F6F69')
              .fontColor(Color.White)
              .borderRadius(8)
              .margin({ left: 10 })
              .onClick(() => {
                this.store.createFavoriteGroup()
              })
          }
          .width('100%')
          .margin({ bottom: 12 })

          Text('当前收藏默认加入：' + this.store.targetFavoriteGroup)
            .fontSize(14)
            .fontColor('#6E7C80')
            .margin({ bottom: 12 })

          Text('收藏夹数量：' + this.store.favoriteGroups.length.toString())
            .fontSize(14)
            .fontColor('#1F6F69')
            .margin({ bottom: 12 })

          Row() {
            this.GroupButton('全部 ' + this.store.getFavoriteGroupCount('全部收藏'), this.store.selectedFavoriteGroup === '全部收藏', () => {
              this.store.setFavoriteGroup('全部收藏')
            })
            this.GroupButton('点赞 ' + this.store.getFavoriteGroupCount('点赞记录'), this.store.selectedFavoriteGroup === '点赞记录', () => {
              this.store.setFavoriteGroup('点赞记录')
            })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ bottom: 10 })

          ForEach(this.store.favoriteGroups, (group: FavoriteGroup) => {
            this.GroupButton(group.name + ' ' + this.store.getFavoriteGroupCount(group.name), this.store.selectedFavoriteGroup === group.name, () => {
              this.store.setFavoriteGroup(group.name)
            })
          }, (group: FavoriteGroup) => group.id.toString() + group.name + group.relicIds.length.toString() + this.store.auditVersion.toString())
        }
        .width('92%')
        .padding(14)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .margin({ bottom: 14 })

        if (this.store.getFavoriteGroupList().length === 0) {
          Text('当前分组暂无文物。可以回到“文物”页点赞或收藏。')
            .width('92%')
            .fontSize(15)
            .fontColor('#8A9699')
            .lineHeight(22)
            .padding(14)
            .backgroundColor(Color.White)
            .borderRadius(8)
        } else {
          Text('当前分组：' + this.store.selectedFavoriteGroup)
            .width('92%')
            .fontSize(15)
            .fontColor('#6E7C80')
            .margin({ bottom: 10 })

          Scroll() {
            Column() {
              ForEach(this.store.getFavoriteGroupList(), (item: Relic) => {
                this.RelicMiniCard(item)
              }, (item: Relic) => item.id.toString() + this.store.auditVersion.toString())
            }
            .width('100%')
            .alignItems(HorizontalAlign.Center)
          }
          .layoutWeight(1)
        }
      }
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#F6F8FA')
  }
}
