import { Relic, RelicComment } from '../model/MuseumModels'
import { MuseumStore } from '../model/MuseumStore'

@Component
export struct RelicBrowsePage {
  @ObjectLink store: MuseumStore

  @Builder
  Pill(text: string, selected: boolean, action: () => void) {
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
  InfoTag(text: string, color: string) {
    Text(text)
      .fontSize(13)
      .fontColor(color)
      .padding({ left: 8, right: 8, top: 4, bottom: 4 })
      .backgroundColor('#F4F7F7')
      .borderRadius(6)
  }

  @Builder
  CardAction(text: string, bgColor: string, textColor: string, left: number, right: number, action: () => void) {
    Text(text)
      .layoutWeight(1)
      .height(38)
      .fontSize(14)
      .fontWeight(FontWeight.Medium)
      .fontColor(textColor)
      .textAlign(TextAlign.Center)
      .backgroundColor(bgColor)
      .borderRadius(8)
      .margin({ left: left, right: right })
      .onClick(action)
  }

  @Builder
  ProgressBar(progress: number, color: string, bottom: number) {
    Row() {
      Text('')
        .width(progress.toString() + '%')
        .height('100%')
        .backgroundColor(color)
        .borderRadius(4)
    }
    .width('100%')
    .height(8)
    .backgroundColor('#E3EAEB')
    .borderRadius(4)
    .margin({ bottom: bottom })
  }

  @Builder
  RelicCard(item: Relic) {
    Row() {
      Image(item.image)
        .width(104)
        .height(118)
        .objectFit(ImageFit.Cover)
        .borderRadius(8)
        .backgroundColor('#EEF2F2')

      Column() {
        Row() {
          Text(item.name)
            .fontSize(19)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2D2F')

          Blank()

          Text(item.hot.toString())
            .fontSize(15)
            .fontColor('#A3482F')
        }
        .width('100%')
        .margin({ bottom: 8 })

        Row() {
          this.InfoTag(item.type, '#1F6F69')
          Text(item.dynasty)
            .fontSize(13)
            .fontColor('#6E7C80')
            .margin({ left: 8 })
        }
        .margin({ bottom: 8 })

        Text(item.intro)
          .fontSize(14)
          .fontColor('#526467')
          .lineHeight(21)
          .margin({ bottom: 2 })

        Row() {
          this.CardAction(
            this.store.isLiked(item.id) ? '已赞' : '点赞',
            this.store.isLiked(item.id) ? '#A3482F' : '#F4F7F7',
            this.store.isLiked(item.id) ? '#FFFFFF' : '#24353A',
            0,
            5,
            () => {
              this.store.toggleLike(item.id)
            }
          )

          this.CardAction(
            this.store.isCollected(item.id) ? '已藏' : '收藏',
            this.store.isCollected(item.id) ? '#B08A45' : '#F4F7F7',
            this.store.isCollected(item.id) ? '#FFFFFF' : '#24353A',
            5,
            5,
            () => {
              this.store.toggleCollect(item.id)
            }
          )

          this.CardAction('查看', '#1F6F69', '#FFFFFF', 5, 0, () => {
            this.store.addHistory(item.id)
          })
        }
        .width('100%')
        .margin({ top: 10 })
      }
      .layoutWeight(1)
      .margin({ left: 14 })
    }
    .width('92%')
    .padding(12)
    .margin({ bottom: 12 })
    .backgroundColor(Color.White)
    .borderRadius(8)
  }

  @Builder
  DetailSection(title: string) {
    Text(title)
      .fontSize(21)
      .fontWeight(FontWeight.Bold)
      .fontColor('#1F2D2F')
      .margin({ top: 20, bottom: 10 })
  }

  @Builder
  CommentBlock(item: RelicComment) {
    Column() {
      Row() {
        Text(item.user)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2D2F')

        Blank()

        Text(item.time)
          .fontSize(13)
          .fontColor('#8A9699')
      }
      .width('100%')

      Text(item.content)
        .fontSize(15)
        .fontColor('#526467')
        .lineHeight(22)
        .margin({ top: 8, bottom: 10 })

      Row() {
        Button(this.store.isCommentLiked(item.id) ? '已赞 ' + item.likeCount : '点赞 ' + item.likeCount)
          .height(32)
          .backgroundColor(this.store.isCommentLiked(item.id) ? '#A3482F' : '#F4F7F7')
          .fontColor(this.store.isCommentLiked(item.id) ? Color.White : '#24353A')
          .borderRadius(8)
          .onClick(() => {
            this.store.toggleCommentLike(item.id)
          })

        Button(this.store.replyTargetId === item.id ? '取消回复' : '回复')
          .height(32)
          .backgroundColor('#F4F7F7')
          .fontColor('#24353A')
          .borderRadius(8)
          .margin({ left: 10 })
          .onClick(() => {
            if (this.store.replyTargetId === item.id) {
              this.store.replyTargetId = 0
            } else {
              this.store.startReply(item.id)
            }
          })
      }
      .width('100%')

      if (this.store.replyTargetId === item.id) {
        Row() {
          TextInput({
            placeholder: '回复 ' + item.user,
            text: this.store.replyInput
          })
            .layoutWeight(1)
            .height(40)
            .backgroundColor('#F4F7F7')
            .borderRadius(8)
            .padding({ left: 10, right: 10 })
            .onChange((value: string) => {
              this.store.replyInput = value
            })

          Button('提交')
            .height(40)
            .width(72)
            .backgroundColor('#1F6F69')
            .fontColor(Color.White)
            .borderRadius(8)
            .margin({ left: 8 })
            .onClick(() => {
              this.store.addReply(item)
            })
        }
        .width('100%')
        .margin({ top: 10 })
      }

      ForEach(this.store.getReplies(item.id), (reply: RelicComment) => {
        Column() {
          Text(reply.user + ' 回复 ' + reply.replyToUser)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F6F69')
            .margin({ bottom: 4 })

          Text(reply.content)
            .fontSize(14)
            .fontColor('#526467')
            .lineHeight(21)
        }
        .width('100%')
        .padding(10)
        .margin({ top: 10 })
        .backgroundColor('#F7F9F9')
        .borderRadius(8)
      }, (reply: RelicComment) => reply.id.toString() + this.store.auditVersion.toString())
    }
    .width('100%')
    .padding(12)
    .margin({ bottom: 10 })
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
  }

  @Builder
  DetailPage() {
    Column() {
      Row() {
        Text('返回')
          .fontSize(17)
          .fontColor('#1F6F69')
          .onClick(() => {
            this.store.selectedRelicId = 0
          })

        Blank()

        Text('文物详情')
          .fontSize(19)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2D2F')
      }
      .width('92%')
      .margin({ top: 22, bottom: 12 })

      Scroll() {
        Column() {
          Image(this.store.getSelectedRelic().image)
            .width('92%')
            .height(this.store.imageZoomed ? 330 : 230)
            .objectFit(this.store.imageZoomed ? ImageFit.Contain : ImageFit.Cover)
            .borderRadius(8)
            .backgroundColor('#EEF2F2')
            .margin({ bottom: 10 })

          Row() {
            Button('上一张')
              .layoutWeight(1)
              .height(34)
              .backgroundColor('#F4F7F7')
              .fontColor('#24353A')
              .borderRadius(8)
              .margin({ right: 6 })
              .onClick(() => {
                this.store.previousDetailImage()
              })

            Button(this.store.getDetailImageCaption())
              .layoutWeight(1)
              .height(34)
              .backgroundColor('#FFFFFF')
              .fontColor('#1F6F69')
              .borderRadius(8)
              .border({ width: 1, color: '#DDE5E7' })
              .margin({ left: 6, right: 6 })

            Button('下一张')
              .layoutWeight(1)
              .height(34)
              .backgroundColor('#F4F7F7')
              .fontColor('#24353A')
              .borderRadius(8)
              .margin({ left: 6 })
              .onClick(() => {
                this.store.nextDetailImage()
              })
          }
          .width('92%')
          .margin({ bottom: 8 })

          Button(this.store.imageZoomed ? '退出放大查看' : '放大查看图片')
            .width('92%')
            .height(38)
            .backgroundColor(this.store.imageZoomed ? '#1F6F69' : '#FFFFFF')
            .fontColor(this.store.imageZoomed ? Color.White : '#24353A')
            .borderRadius(8)
            .border({ width: 1, color: '#DDE5E7' })
            .onClick(() => {
              this.store.imageZoomed = !this.store.imageZoomed
            })

          Column() {
            Text(this.store.getSelectedRelic().name)
              .fontSize(27)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2D2F')
              .margin({ bottom: 12 })

            Row() {
              this.InfoTag(this.store.getSelectedRelic().type, '#1F6F69')
              Text(this.store.getSelectedRelic().dynasty)
                .fontSize(14)
                .fontColor('#6E7C80')
                .margin({ left: 8 })
              Text('热度 ' + this.store.getSelectedRelic().hot)
                .fontSize(14)
                .fontColor('#A3482F')
                .margin({ left: 8 })
            }
            .margin({ bottom: 14 })

            Text(this.store.getSelectedRelic().intro)
              .fontSize(16)
              .fontColor('#526467')
              .lineHeight(28)

            Row() {
              Button(this.store.isLiked(this.store.getSelectedRelic().id) ? '已点赞' : '点赞')
                .layoutWeight(1)
                .height(40)
                .backgroundColor(this.store.isLiked(this.store.getSelectedRelic().id) ? '#A3482F' : '#F4F7F7')
                .fontColor(this.store.isLiked(this.store.getSelectedRelic().id) ? Color.White : '#24353A')
                .borderRadius(8)
                .margin({ right: 8 })
                .onClick(() => {
                  this.store.toggleLike(this.store.getSelectedRelic().id)
                })

              Button(this.store.isCollected(this.store.getSelectedRelic().id) ? '已收藏' : '收藏')
                .layoutWeight(1)
                .height(40)
                .backgroundColor(this.store.isCollected(this.store.getSelectedRelic().id) ? '#B08A45' : '#F4F7F7')
                .fontColor(this.store.isCollected(this.store.getSelectedRelic().id) ? Color.White : '#24353A')
                .borderRadius(8)
                .margin({ left: 8 })
                .onClick(() => {
                  this.store.toggleCollect(this.store.getSelectedRelic().id)
                })
            }
            .width('100%')
            .margin({ top: 18 })

            Text(this.store.isCollected(this.store.getSelectedRelic().id) ? '已加入收藏分组：' + this.store.targetFavoriteGroup : '收藏时将加入分组：' + this.store.targetFavoriteGroup)
              .fontSize(13)
              .fontColor('#6E7C80')
              .margin({ top: 8 })
          }
          .width('92%')
          .padding(14)
          .backgroundColor(Color.White)
          .borderRadius(8)
          .margin({ top: 12 })

          Column() {
            this.DetailSection('语音导览')

            Button(this.store.isGuidePlaying ? '暂停语音讲解' : '播放语音讲解')
              .width('100%')
              .height(40)
              .backgroundColor('#1F6F69')
              .fontColor(Color.White)
              .borderRadius(8)
              .onClick(() => {
                this.store.toggleGuidePlay()
              })

            Row() {
              this.Pill('0.75x', this.store.guideSpeed === '0.75x', () => {
                this.store.guideSpeed = '0.75x'
              })
              this.Pill('1.0x', this.store.guideSpeed === '1.0x', () => {
                this.store.guideSpeed = '1.0x'
              })
              this.Pill('1.5x', this.store.guideSpeed === '1.5x', () => {
                this.store.guideSpeed = '1.5x'
              })
              this.Pill('2.0x', this.store.guideSpeed === '2.0x', () => {
                this.store.guideSpeed = '2.0x'
              })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ top: 12, bottom: 10 })

            Text('讲解进度：' + this.store.getGuideProgressText())
              .fontSize(15)
              .fontColor('#526467')
              .margin({ bottom: 8 })

            this.ProgressBar(this.store.guideProgress, '#1F6F69', 12)

            Column() {
              Text(this.store.getGuideStatusText())
                .fontSize(14)
                .fontColor(this.store.isGuidePlaying ? '#1F6F69' : '#6E7C80')
                .margin({ bottom: 8 })

              Text('实时字幕')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1F2D2F')
                .margin({ bottom: 6 })

              Text(this.store.getGuideSubtitle())
                .fontSize(15)
                .fontColor('#526467')
                .lineHeight(23)
                .margin({ bottom: 10 })

              Text('完整讲解稿')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1F2D2F')
                .margin({ bottom: 6 })

              Text(this.store.getGuideScript())
                .fontSize(14)
                .fontColor('#526467')
                .lineHeight(22)
            }
            .width('100%')
            .padding(12)
            .backgroundColor('#F7F9F9')
            .borderRadius(8)
            .margin({ bottom: 12 })

            Row() {
              Button('-10%')
                .layoutWeight(1)
                .height(36)
                .backgroundColor('#F4F7F7')
                .fontColor('#24353A')
                .borderRadius(8)
                .margin({ right: 8 })
                .onClick(() => {
                  this.store.changeGuideProgress(-10)
                })

              Button('+10%')
                .layoutWeight(1)
                .height(36)
                .backgroundColor('#F4F7F7')
                .fontColor('#24353A')
                .borderRadius(8)
                .margin({ left: 8 })
                .onClick(() => {
                  this.store.changeGuideProgress(10)
                })
            }

            this.DetailSection('视频讲解')

            Text(this.store.isVideoPlaying ? '视频讲解播放中' : '视频讲解未播放')
              .fontSize(15)
              .fontColor('#526467')
              .margin({ bottom: 6 })

            Text('进度：' + this.store.getVideoProgressText())
              .fontSize(15)
              .fontColor('#526467')
              .margin({ bottom: 10 })

            this.ProgressBar(this.store.videoProgress, '#A3482F', 12)

            Row() {
              Button(this.store.isVideoPlaying ? '暂停视频' : '播放视频')
                .layoutWeight(1)
                .height(38)
                .backgroundColor('#1F6F69')
                .fontColor(Color.White)
                .borderRadius(8)
                .margin({ right: 8 })
                .onClick(() => {
                  this.store.toggleVideoPlay()
                })

              Button('-15%')
                .width(72)
                .height(38)
                .backgroundColor('#F4F7F7')
                .fontColor('#24353A')
                .borderRadius(8)
                .margin({ right: 8 })
                .onClick(() => {
                  this.store.changeVideoProgress(-15)
                })

              Button('+15%')
                .width(72)
                .height(38)
                .backgroundColor('#F4F7F7')
                .fontColor('#24353A')
                .borderRadius(8)
                .onClick(() => {
                  this.store.changeVideoProgress(15)
                })
            }

            this.DetailSection('语音问答')

            TextInput({
              placeholder: '例如：这件文物是什么朝代？',
              text: this.store.voiceQuestion
            })
              .width('100%')
              .height(42)
              .backgroundColor('#F4F7F7')
              .borderRadius(8)
              .padding({ left: 10, right: 10 })
              .onChange((value: string) => {
                this.store.voiceQuestion = value
              })

            Button('模拟语音提问')
              .width('100%')
              .height(40)
              .backgroundColor('#1F6F69')
              .fontColor(Color.White)
              .borderRadius(8)
              .margin({ top: 10 })
              .onClick(() => {
                this.store.submitVoiceQuestion()
              })

            if (this.store.voiceAnswer !== '') {
              Text(this.store.voiceAnswer)
                .width('100%')
                .fontSize(15)
                .fontColor('#526467')
                .lineHeight(23)
                .padding(10)
                .margin({ top: 10 })
                .backgroundColor('#F7F9F9')
                .borderRadius(8)
            }
          }
          .width('92%')
          .padding({ left: 14, right: 14, bottom: 16 })
          .backgroundColor(Color.White)
          .borderRadius(8)
          .margin({ top: 12 })

          Column() {
            this.DetailSection('留言评论')

            TextInput({
              placeholder: this.store.isLoggedIn ? '写下你的看法，提交后进入审核' : '登录后可发表评论',
              text: this.store.commentInput
            })
              .width('100%')
              .height(42)
              .backgroundColor('#F4F7F7')
              .borderRadius(8)
              .padding({ left: 10, right: 10 })
              .onChange((value: string) => {
                this.store.commentInput = value
              })

            Button(this.store.isLoggedIn ? '提交评论' : '去登录后评论')
              .width('100%')
              .height(40)
              .backgroundColor('#1F6F69')
              .fontColor(Color.White)
              .borderRadius(8)
              .margin({ top: 10, bottom: 12 })
              .onClick(() => {
                this.store.addComment()
              })

            if (this.store.getCurrentComments().length === 0) {
              Text('暂无已通过评论。提交后可用审核员账号 admin 审核显示。')
                .fontSize(15)
                .fontColor('#8A9699')
                .lineHeight(22)
            } else {
              ForEach(this.store.getCurrentComments(), (item: RelicComment) => {
                this.CommentBlock(item)
              }, (item: RelicComment) => item.id.toString() + this.store.auditVersion.toString())
            }
          }
          .width('92%')
          .padding({ left: 14, right: 14, bottom: 16 })
          .backgroundColor(Color.White)
          .borderRadius(8)
          .margin({ top: 12, bottom: 26 })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6F8FA')
  }

  build() {
    if (this.store.selectedRelicId !== 0) {
      this.DetailPage()
    } else {
      Column() {
        Scroll() {
          Column() {
            Text('文物浏览')
              .fontSize(28)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2D2F')
              .margin({ top: 24, bottom: 6 })

            Text('按类型、热度和年代浏览馆藏精品')
              .fontSize(16)
              .fontColor('#6E7C80')
              .margin({ bottom: 16 })

            Row() {
              this.Pill('全部', this.store.selectedType === '全部', () => {
                this.store.selectedType = '全部'
              })
              this.Pill('玉器', this.store.selectedType === '玉器', () => {
                this.store.selectedType = '玉器'
              })
              this.Pill('瓷器', this.store.selectedType === '瓷器', () => {
                this.store.selectedType = '瓷器'
              })
              this.Pill('青铜器', this.store.selectedType === '青铜器', () => {
                this.store.selectedType = '青铜器'
              })
            }
            .width('92%')
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ bottom: 10 })

            Row() {
              this.Pill('中国画', this.store.selectedType === '中国画', () => {
                this.store.selectedType = '中国画'
              })
              this.Pill('默认', this.store.sortMode === '默认', () => {
                this.store.sortMode = '默认'
              })
              this.Pill('热度降序', this.store.sortMode === '热度降序', () => {
                this.store.sortMode = '热度降序'
              })
            }
            .width('92%')
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ bottom: 10 })

            Row() {
              this.Pill('热度升序', this.store.sortMode === '热度升序', () => {
                this.store.sortMode = '热度升序'
              })
              this.Pill('年代早到晚', this.store.sortMode === '年代从早到晚', () => {
                this.store.sortMode = '年代从早到晚'
              })
              this.Pill('年代晚到早', this.store.sortMode === '年代从晚到早', () => {
                this.store.sortMode = '年代从晚到早'
              })
            }
            .width('92%')
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ bottom: 14 })

            Text('当前分类：' + this.store.selectedType + '，排序：' + this.store.sortMode + '，共 ' + this.store.getBrowseList().length + ' 件')
              .fontSize(14)
              .fontColor('#6E7C80')
              .width('92%')
              .margin({ bottom: 12 })

            ForEach(this.store.getBrowseList(), (item: Relic) => {
              this.RelicCard(item)
            }, (item: Relic) => item.id.toString() + item.hot.toString() + this.store.auditVersion.toString())
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
        }
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F6F8FA')
    }
  }
}
