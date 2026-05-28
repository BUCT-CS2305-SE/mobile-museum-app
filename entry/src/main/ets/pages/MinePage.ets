import { RelicComment, UserUpload } from '../model/MuseumModels'
import { MuseumStore } from '../model/MuseumStore'

@Component
export struct MinePage {
  @ObjectLink store: MuseumStore

  @Builder
  StatItem(label: string, value: string) {
    Column() {
      Text(value)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1F6F69')
        .margin({ bottom: 4 })

      Text(label)
        .fontSize(13)
        .fontColor('#6E7C80')
    }
    .layoutWeight(1)
    .height(68)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#F4F7F7')
    .borderRadius(8)
    .margin({ left: 4, right: 4 })
  }

  @Builder
  PanelTitle(title: string) {
    Text(title)
      .fontSize(21)
      .fontWeight(FontWeight.Bold)
      .fontColor('#1F2D2F')
      .margin({ bottom: 12 })
  }

  @Builder
  LoginPage() {
    Column() {
      Text('掌上博物馆')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1F2D2F')
        .margin({ top: 54, bottom: 8 })

      Text('用户登录 / 注册')
        .fontSize(16)
        .fontColor('#6E7C80')
        .margin({ bottom: 28 })

      Column() {
        Row() {
          Button('登录')
            .layoutWeight(1)
            .height(40)
            .backgroundColor(this.store.loginMode === '登录' ? '#1F6F69' : '#F4F7F7')
            .fontColor(this.store.loginMode === '登录' ? Color.White : '#24353A')
            .borderRadius(8)
            .margin({ right: 8 })
            .onClick(() => {
              this.store.loginMode = '登录'
            })

          Button('注册')
            .layoutWeight(1)
            .height(40)
            .backgroundColor(this.store.loginMode === '注册' ? '#1F6F69' : '#F4F7F7')
            .fontColor(this.store.loginMode === '注册' ? Color.White : '#24353A')
            .borderRadius(8)
            .margin({ left: 8 })
            .onClick(() => {
              this.store.loginMode = '注册'
            })
        }
        .width('100%')
        .margin({ bottom: 16 })

        TextInput({
          placeholder: '普通用户输入手机号；审核员输入 admin',
          text: this.store.loginAccount
        })
          .width('100%')
          .height(44)
          .backgroundColor('#F4F7F7')
          .borderRadius(8)
          .padding({ left: 10, right: 10 })
          .margin({ bottom: 12 })
          .onChange((value: string) => {
            this.store.loginAccount = value
          })

        TextInput({
          placeholder: '请输入密码',
          text: this.store.loginPassword
        })
          .type(InputType.Password)
          .width('100%')
          .height(44)
          .backgroundColor('#F4F7F7')
          .borderRadius(8)
          .padding({ left: 10, right: 10 })
          .margin({ bottom: 14 })
          .onChange((value: string) => {
            this.store.loginPassword = value
          })

        Button(this.store.loginMode)
          .width('100%')
          .height(42)
          .backgroundColor('#1F6F69')
          .fontColor(Color.White)
          .borderRadius(8)
          .onClick(() => {
            this.store.handleLoginOrRegister()
          })

        Text(this.store.loginMode === '登录' ? '演示账号：admin 可进入审核员模式' : '注册后自动进入个人主页')
          .fontSize(13)
          .fontColor('#8A9699')
          .margin({ top: 12 })
      }
      .width('86%')
      .padding(18)
      .backgroundColor(Color.White)
      .borderRadius(8)
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#F6F8FA')
  }

  @Builder
  AuditComment(item: RelicComment) {
    Column() {
      Row() {
        Text(item.user)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2D2F')

        Blank()

        Text(item.status)
          .fontSize(13)
          .fontColor('#A3482F')
      }
      .width('100%')

      Text(item.content)
        .fontSize(15)
        .fontColor('#526467')
        .lineHeight(22)
        .margin({ top: 8, bottom: 10 })

      Row() {
        Button('通过')
          .layoutWeight(1)
          .height(34)
          .backgroundColor('#1F6F69')
          .fontColor(Color.White)
          .borderRadius(8)
          .margin({ right: 6 })
          .onClick(() => {
            this.store.setCommentStatus(item.id, '已通过')
          })

        Button('驳回')
          .layoutWeight(1)
          .height(34)
          .backgroundColor('#A3482F')
          .fontColor(Color.White)
          .borderRadius(8)
          .margin({ left: 6 })
          .onClick(() => {
            this.store.setCommentStatus(item.id, '已驳回')
          })
      }
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#F7F9F9')
    .borderRadius(8)
    .margin({ bottom: 10 })
  }

  @Builder
  AuditUpload(item: UserUpload) {
    Column() {
      Row() {
        Text(item.relicName)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2D2F')

        Blank()

        Text(item.status)
          .fontSize(13)
          .fontColor('#A3482F')
      }
      .width('100%')

      Text('拍摄地点：' + item.location)
        .fontSize(14)
        .fontColor('#6E7C80')
        .margin({ top: 8 })

      Text('说明：' + item.desc)
        .fontSize(15)
        .fontColor('#526467')
        .lineHeight(22)
        .margin({ top: 6, bottom: 10 })

      Row() {
        Button('通过')
          .layoutWeight(1)
          .height(34)
          .backgroundColor('#1F6F69')
          .fontColor(Color.White)
          .borderRadius(8)
          .margin({ right: 6 })
          .onClick(() => {
            this.store.setUploadStatus(item.id, '已通过')
          })

        Button('驳回')
          .layoutWeight(1)
          .height(34)
          .backgroundColor('#A3482F')
          .fontColor(Color.White)
          .borderRadius(8)
          .margin({ left: 6 })
          .onClick(() => {
            this.store.setUploadStatus(item.id, '已驳回')
          })
      }
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#F7F9F9')
    .borderRadius(8)
    .margin({ bottom: 10 })
  }

  @Builder
  UploadRecord(item: UserUpload) {
    Column() {
      Row() {
        Text(item.relicName)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2D2F')

        Blank()

        Text(item.status)
          .fontSize(13)
          .fontColor(item.status === '已通过' ? '#1F6F69' : '#A3482F')
      }
      .width('100%')

      Row() {
        Image($r('app.media.ciqi'))
          .width(82)
          .height(82)
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
          .backgroundColor('#EEF2F2')

        Column() {
          Text('模拟上传照片')
            .fontSize(13)
            .fontColor('#1F6F69')
            .margin({ bottom: 6 })

          Text('拍摄地点：' + item.location)
            .fontSize(14)
            .fontColor('#6E7C80')
            .margin({ bottom: 6 })

          Text(item.desc)
            .fontSize(15)
            .fontColor('#526467')
            .lineHeight(22)
        }
        .layoutWeight(1)
        .margin({ left: 12 })
      }
      .width('100%')
      .margin({ top: 10 })
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#F7F9F9')
    .borderRadius(8)
    .margin({ bottom: 10 })
  }

  @Builder
  UserCenter() {
    Scroll() {
      Column() {
        Text('用户个人信息管理')
          .fontSize(27)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2D2F')
          .margin({ top: 24, bottom: 14 })

        Column() {
          this.PanelTitle('个人主页')

          Text('账号：' + this.store.account)
            .fontSize(16)
            .fontColor('#526467')
            .margin({ bottom: 8 })

          Text('昵称：' + this.store.username)
            .fontSize(16)
            .fontColor('#526467')
            .margin({ bottom: 8 })

          Text('身份：' + this.store.userRole)
            .fontSize(16)
            .fontColor(this.store.userRole === '审核员' ? '#A3482F' : '#1F6F69')
            .margin({ bottom: 8 })

          Text('手机号：' + this.store.phone)
            .fontSize(16)
            .fontColor('#526467')
            .margin({ bottom: 8 })

          Text('邮箱：' + this.store.email)
            .fontSize(16)
            .fontColor('#526467')
            .margin({ bottom: 8 })

          Text('隐私状态：' + (this.store.privacyVisible ? '公开' : '仅自己可见'))
            .fontSize(16)
            .fontColor(this.store.privacyVisible ? '#1F6F69' : '#A3482F')
        }
        .width('92%')
        .padding(14)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .margin({ bottom: 12 })

        Row() {
          this.StatItem('收藏', this.store.collectedIds.length.toString())
          this.StatItem('点赞', this.store.likedIds.length.toString())
          this.StatItem('浏览', this.store.historyIds.length.toString())
          this.StatItem('上传', this.store.uploadCount.toString())
        }
        .width('92%')
        .margin({ bottom: 12 })

        Column() {
          this.PanelTitle('本地数据')

          Text(this.store.storageStatus)
            .fontSize(15)
            .fontColor('#526467')
            .margin({ bottom: 10 })

          Button('立即保存本地数据')
            .width('100%')
            .height(40)
            .backgroundColor('#1F6F69')
            .fontColor(Color.White)
            .borderRadius(8)
            .onClick(() => {
              this.store.persistLocalState()
            })
        }
        .width('92%')
        .padding(14)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .margin({ bottom: 12 })

        Column() {
          this.PanelTitle('修改个人信息')

          TextInput({
            placeholder: '请输入昵称',
            text: this.store.username
          })
            .width('100%')
            .height(42)
            .backgroundColor('#F4F7F7')
            .borderRadius(8)
            .padding({ left: 10, right: 10 })
            .margin({ bottom: 10 })
            .onChange((value: string) => {
              this.store.username = value
              this.store.persistLocalState()
            })

          TextInput({
            placeholder: '请输入手机号',
            text: this.store.phone
          })
            .width('100%')
            .height(42)
            .backgroundColor('#F4F7F7')
            .borderRadius(8)
            .padding({ left: 10, right: 10 })
            .margin({ bottom: 10 })
            .onChange((value: string) => {
              this.store.phone = value
              this.store.persistLocalState()
            })

          TextInput({
            placeholder: '请输入邮箱',
            text: this.store.email
          })
            .width('100%')
            .height(42)
            .backgroundColor('#F4F7F7')
            .borderRadius(8)
            .padding({ left: 10, right: 10 })
            .margin({ bottom: 10 })
            .onChange((value: string) => {
              this.store.email = value
              this.store.persistLocalState()
            })

          Button(this.store.privacyVisible ? '切换为仅自己可见' : '切换为公开')
            .width('100%')
            .height(40)
            .backgroundColor('#1F6F69')
            .fontColor(Color.White)
            .borderRadius(8)
            .onClick(() => {
              this.store.privacyVisible = !this.store.privacyVisible
              this.store.persistLocalState()
            })
        }
        .width('92%')
        .padding(14)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .margin({ bottom: 12 })

        Column() {
          this.PanelTitle('用户上传照片')

          TextInput({
            placeholder: '关联文物名称，例如：青花瓷洗',
            text: this.store.uploadRelicName
          })
            .width('100%')
            .height(42)
            .backgroundColor('#F4F7F7')
            .borderRadius(8)
            .padding({ left: 10, right: 10 })
            .margin({ bottom: 10 })
            .onChange((value: string) => {
              this.store.uploadRelicName = value
            })

          TextInput({
            placeholder: '拍摄地点，例如：故宫博物院',
            text: this.store.uploadLocation
          })
            .width('100%')
            .height(42)
            .backgroundColor('#F4F7F7')
            .borderRadius(8)
            .padding({ left: 10, right: 10 })
            .margin({ bottom: 10 })
            .onChange((value: string) => {
              this.store.uploadLocation = value
            })

          TextInput({
            placeholder: '简短说明',
            text: this.store.uploadDesc
          })
            .width('100%')
            .height(42)
            .backgroundColor('#F4F7F7')
            .borderRadius(8)
            .padding({ left: 10, right: 10 })
            .margin({ bottom: 10 })
            .onChange((value: string) => {
              this.store.uploadDesc = value
            })

          Button('提交上传')
            .width('100%')
            .height(40)
            .backgroundColor('#1F6F69')
            .fontColor(Color.White)
            .borderRadius(8)
            .margin({ bottom: 14 })
            .onClick(() => {
              this.store.addUserUpload()
            })

          Text('我的上传记录')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2D2F')
            .margin({ bottom: 10 })

          if (this.store.uploadList.length === 0) {
            Text('暂无上传记录')
              .fontSize(15)
              .fontColor('#8A9699')
          } else {
            ForEach(this.store.uploadList, (item: UserUpload) => {
              this.UploadRecord(item)
            }, (item: UserUpload) => item.id.toString() + item.status + this.store.auditVersion.toString())
          }

          Text('公开展示照片')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2D2F')
            .margin({ top: 12, bottom: 10 })

          if (this.store.getApprovedUploads().length === 0) {
            Text('审核通过后将在这里公开展示')
              .fontSize(15)
              .fontColor('#8A9699')
          } else {
            ForEach(this.store.getApprovedUploads(), (item: UserUpload) => {
              this.UploadRecord(item)
            }, (item: UserUpload) => item.id.toString() + item.status + this.store.auditVersion.toString())
          }
        }
        .width('92%')
        .padding(14)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .margin({ bottom: 12 })

        Column() {
          this.PanelTitle('审核中心')

          if (this.store.userRole !== '审核员') {
            Text('当前身份为普通用户，不能审核评论或上传内容。演示审核流程时，请退出后使用账号 admin 登录。')
              .fontSize(15)
              .fontColor('#526467')
              .lineHeight(23)
          } else {
            Text('评论审核')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2D2F')
              .margin({ bottom: 10 })

            if (this.store.getPendingComments().length === 0) {
              Text('暂无评论需要审核')
                .fontSize(15)
                .fontColor('#8A9699')
                .margin({ bottom: 12 })
            } else {
              ForEach(this.store.getPendingComments(), (item: RelicComment) => {
                this.AuditComment(item)
              }, (item: RelicComment) => item.id.toString() + this.store.auditVersion.toString())
            }

            Text('上传内容审核')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2D2F')
              .margin({ top: 12, bottom: 10 })

            if (this.store.getPendingUploads().length === 0) {
              Text('暂无上传内容需要审核')
                .fontSize(15)
                .fontColor('#8A9699')
            } else {
              ForEach(this.store.getPendingUploads(), (item: UserUpload) => {
                this.AuditUpload(item)
              }, (item: UserUpload) => item.id.toString() + item.status + this.store.auditVersion.toString())
            }
          }
        }
        .width('92%')
        .padding(14)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .margin({ bottom: 12 })

        Button('退出登录')
          .width('92%')
          .height(42)
          .backgroundColor('#A3482F')
          .fontColor(Color.White)
          .borderRadius(8)
          .margin({ bottom: 26 })
          .onClick(() => {
            this.store.logout()
          })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
    }
    .layoutWeight(1)
  }

  build() {
    if (this.store.isLoggedIn) {
      this.UserCenter()
    } else {
      this.LoginPage()
    }
  }
}
