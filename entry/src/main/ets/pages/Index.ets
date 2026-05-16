interface Relic {
  id: number
  name: string
  dynasty: string
  type: string
  hot: number
  intro: string
  image: Resource
  liked: boolean
  collected: boolean
}
interface RelicComment {
  id: number
  relicId: number
  user: string
  content: string
  status: string
  time: string
  parentId: number
  replyToUser: string
  likeCount: number
}
interface UserUpload {
  id: number
  relicName: string
  location: string
  desc: string
  status: string
  time: string
}
interface FavoriteGroup {
  id: number
  name: string
  relicIds: number[]
}

@Entry
@Component
struct Index {
  @State keyword: string = ''
  @State currentIndex: number = 0
  @State selectedRelicId: number = 0
  @State selectedType: string = '全部'
  @State sortMode: string = '默认'
  @State commentInput: string = ''
  @State replyInput: string = ''
  @State replyTargetId: number = 0
  @State isGuidePlaying: boolean = false
  @State guideSpeed: string = '1.0x'
  @State guideProgress: number = 0
  @State isVideoPlaying: boolean = false
  @State videoProgress: number = 0
  @State detailImageIndex: number = 0
  @State imageZoomed: boolean = false
  @State voiceQuestion: string = ''
  @State voiceAnswer: string = ''
  @State username: string = '博物馆访客'
  @State userRole: string = '普通用户'
  @State account: string = '未登录'
  @State phone: string = '13387115555'
  @State email: string = '1872138949@qq.com'
  @State privacyVisible: boolean = true
  @State isLoggedIn: boolean = false
  @State loginMode: string = '登录'
  @State loginAccount: string = ''
  @State loginPassword: string = ''
  @State uploadCount: number = 0
  @State uploadRelicName: string = ''
  @State uploadLocation: string = ''
  @State uploadDesc: string = ''
  @State uploadList: UserUpload[] = []
  @State imageSearchDone: boolean = false
  @State imageSearchMode: string = ''
  @State searchMode: string = '文本搜索'
  @State voiceSearchInput: string = ''
  @State voiceSearchKeyword: string = ''
  @State historyIds: number[] = []
  @State likedIds: number[] = []
  @State collectedIds: number[] = []
  @State likedCommentIds: number[] = []
  @State selectedFavoriteGroup: string = '全部收藏'
  @State targetFavoriteGroup: string = '默认分组'
  @State favoriteGroupInput: string = ''
  @State favoriteGroups: FavoriteGroup[] = [
    {
      id: 1,
      name: '默认分组',
      relicIds: []
    }
  ]
  @State comments: RelicComment[] = [
    {
      id: 1,
      relicId: 2,
      user: '博物馆讲解员',
      content: '青花瓷的蓝色纹样很适合用来演示“名称、朝代、类型”三个检索入口。',
      status: '已通过',
      time: '10分钟前',
      parentId: 0,
      replyToUser: '',
      likeCount: 2
    },
    {
      id: 2,
      relicId: 2,
      user: '游客小陈',
      content: '这个瓶子的颜色很清爽，详情页图片放大后更容易看纹饰。',
      status: '已通过',
      time: '5分钟前',
      parentId: 1,
      replyToUser: '博物馆讲解员',
      likeCount: 0
    }
  ]
  @State auditVersion: number = 0
  @State relics: Relic[] = [
    {
      id: 1,
      name: '青玉兽面纹饰',
      dynasty: '清代',
      type: '玉器',
      hot: 98,
      intro: '该文物造型精美，纹饰细腻，体现了古代玉器雕刻工艺。',
      image: $r('app.media.yuqi'),
      liked: false,
      collected: false
    },
    {
      id: 2,
      name: '青花瓷瓶',
      dynasty: '明代',
      type: '瓷器',
      hot: 92,
      intro: '青花瓷以白地蓝花为主要特征，是中国瓷器中的代表性品类。',
      image: $r('app.media.ciqi'),
      liked: false,
      collected: false
    },
    {
      id: 3,
      name: '青铜鼎',
      dynasty: '商代',
      type: '青铜器',
      hot: 88,
      intro: '青铜鼎是商周时期重要礼器，体现了古代青铜铸造工艺。',
      image: $r('app.media.qingtong'),
      liked: false,
      collected: false
    },
    {
      id: 4,
      name: '山水画卷',
      dynasty: '宋代',
      type: '中国画',
      hot: 76,
      intro: '中国山水画注重意境表达，体现古代文人的自然审美。',
      image: $r('app.media.shanshui'),
      liked: false,
      collected: false
    }
  ]

  getDynastyOrder(dynasty: string): number {
    if (dynasty === '商代') {
      return 1
    }
    if (dynasty === '汉代') {
      return 2
    }
    if (dynasty === '唐代') {
      return 3
    }
    if (dynasty === '宋代') {
      return 4
    }
    if (dynasty === '元代') {
      return 5
    }
    if (dynasty === '明代') {
      return 6
    }
    if (dynasty === '清代') {
      return 7
    }
    return 999
  }

  getBrowseList(): Relic[] {
    let list: Relic[] = []

    for (let i = 0; i < this.relics.length; i++) {
      let item = this.relics[i]

      if (this.selectedType === '全部' || item.type === this.selectedType) {
        list.push(item)
      }
    }

    if (this.sortMode === '热度降序') {
      list.sort((a: Relic, b: Relic) => {
        return b.hot - a.hot
      })
    }

    if (this.sortMode === '热度升序') {
      list.sort((a: Relic, b: Relic) => {
        return a.hot - b.hot
      })
    }

    if (this.sortMode === '年代从早到晚') {
      list.sort((a: Relic, b: Relic) => {
        return this.getDynastyOrder(a.dynasty) - this.getDynastyOrder(b.dynasty)
      })
    }

    if (this.sortMode === '年代从晚到早') {
      list.sort((a: Relic, b: Relic) => {
        return this.getDynastyOrder(b.dynasty) - this.getDynastyOrder(a.dynasty)
      })
    }

    return list
  }

  getSearchList(): Relic[] {
    if (this.keyword.trim() === '') {
      return this.relics
    }

    return this.relics.filter((item: Relic) => {
      return item.name.includes(this.keyword) ||
        item.dynasty.includes(this.keyword) ||
        item.type.includes(this.keyword) ||
        item.intro.includes(this.keyword)
    })
  }

  getSearchTypeCount(type: string): number {
    let count = 0
    let list = this.getSearchList()

    for (let i = 0; i < list.length; i++) {
      if (list[i].type === type) {
        count++
      }
    }

    return count
  }

  getVoiceSearchList(): Relic[] {
    if (this.voiceSearchKeyword.trim() === '') {
      return []
    }

    return this.relics.filter((item: Relic) => {
      return item.name.includes(this.voiceSearchKeyword) ||
        item.dynasty.includes(this.voiceSearchKeyword) ||
        item.type.includes(this.voiceSearchKeyword) ||
        item.intro.includes(this.voiceSearchKeyword)
    })
  }

  submitVoiceSearch() {
    if (this.voiceSearchInput.trim() === '') {
      return
    }

    let text = this.voiceSearchInput

    if (text.includes('青铜')) {
      this.voiceSearchKeyword = '青铜'
    } else if (text.includes('瓷')) {
      this.voiceSearchKeyword = '瓷器'
    } else if (text.includes('玉')) {
      this.voiceSearchKeyword = '玉器'
    } else if (text.includes('画')) {
      this.voiceSearchKeyword = '中国画'
    } else if (text.includes('明')) {
      this.voiceSearchKeyword = '明代'
    } else if (text.includes('清')) {
      this.voiceSearchKeyword = '清代'
    } else {
      this.voiceSearchKeyword = text
    }
  }

  getImageSearchList(): Relic[] {
    let ids: number[] = [1, 2, 4, 3]
    let result: Relic[] = []

    for (let i = 0; i < ids.length; i++) {
      for (let j = 0; j < this.relics.length; j++) {
        if (this.relics[j].id === ids[i]) {
          result.push(this.relics[j])
        }
      }
    }

    return result
  }

  getSimilarity(id: number): string {
    if (id === 1) {
      return '96%'
    }
    if (id === 2) {
      return '89%'
    }
    if (id === 4) {
      return '82%'
    }
    if (id === 3) {
      return '76%'
    }
    return '60%'
  }

  getCurrentComments(): RelicComment[] {
    return this.comments.filter((item: RelicComment) => {
      return item.relicId === this.selectedRelicId && item.status === '已通过' && item.parentId === 0
    })
  }

  getReplies(parentId: number): RelicComment[] {
    return this.comments.filter((item: RelicComment) => {
      return item.relicId === this.selectedRelicId && item.status === '已通过' && item.parentId === parentId
    })
  }

  getPendingComments(): RelicComment[] {
    return this.comments.filter((item: RelicComment) => {
      return item.status === '待审核'
    })
  }

  getPendingUploads(): UserUpload[] {
    return this.uploadList.filter((item: UserUpload) => {
      return item.status === '待审核'
    })
  }

  getApprovedUploads(): UserUpload[] {
    return this.uploadList.filter((item: UserUpload) => {
      return item.status === '已通过'
    })
  }

  addComment() {
    if (!this.isLoggedIn) {
      this.currentIndex = 4
      return
    }

    if (this.commentInput.trim() === '') {
      return
    }

    let newComment: RelicComment = {
      id: this.comments.length + 1,
      relicId: this.selectedRelicId,
      user: this.username,
      content: this.commentInput,
      status: '待审核',
      time: '刚刚',
      parentId: 0,
      replyToUser: '',
      likeCount: 0
    }

    this.comments = [newComment, ...this.comments]
    this.commentInput = ''
  }

  startReply(commentId: number) {
    if (!this.isLoggedIn) {
      this.currentIndex = 4
      return
    }

    this.replyTargetId = commentId
    this.replyInput = ''
  }

  addReply(parent: RelicComment) {
    if (!this.isLoggedIn) {
      this.currentIndex = 4
      return
    }

    if (this.replyInput.trim() === '') {
      return
    }

    let newComment: RelicComment = {
      id: this.comments.length + 1,
      relicId: parent.relicId,
      user: this.username,
      content: this.replyInput,
      status: '待审核',
      time: '刚刚',
      parentId: parent.id,
      replyToUser: parent.user,
      likeCount: 0
    }

    this.comments = [newComment, ...this.comments]
    this.replyInput = ''
    this.replyTargetId = 0
  }

  isCommentLiked(id: number): boolean {
    return this.likedCommentIds.includes(id)
  }

  toggleCommentLike(id: number) {
    if (!this.isLoggedIn) {
      this.currentIndex = 4
      return
    }

    let liked = this.likedCommentIds.includes(id)
    let newComments: RelicComment[] = []

    for (let i = 0; i < this.comments.length; i++) {
      let item = this.comments[i]

      if (item.id === id) {
        newComments.push({
          id: item.id,
          relicId: item.relicId,
          user: item.user,
          content: item.content,
          status: item.status,
          time: item.time,
          parentId: item.parentId,
          replyToUser: item.replyToUser,
          likeCount: liked ? item.likeCount - 1 : item.likeCount + 1
        })
      } else {
        newComments.push(item)
      }
    }

    this.comments = newComments

    if (liked) {
      this.likedCommentIds = this.likedCommentIds.filter((itemId: number) => itemId !== id)
    } else {
      this.likedCommentIds = [...this.likedCommentIds, id]
    }

    this.auditVersion++
  }

  toggleGuidePlay() {
    this.isGuidePlaying = !this.isGuidePlaying
    if (this.isGuidePlaying && this.guideProgress === 100) {
      this.guideProgress = 0
    }
  }

  changeGuideProgress(step: number) {
    let nextProgress = this.guideProgress + step

    if (nextProgress < 0) {
      nextProgress = 0
    }

    if (nextProgress > 100) {
      nextProgress = 100
    }

    this.guideProgress = nextProgress

    if (this.guideProgress === 100) {
      this.isGuidePlaying = false
    }
  }

  getGuideProgressText(): string {
    return this.guideProgress.toString() + '%'
  }

  toggleVideoPlay() {
    this.isVideoPlaying = !this.isVideoPlaying
    if (this.isVideoPlaying && this.videoProgress === 100) {
      this.videoProgress = 0
    }
  }

  changeVideoProgress(step: number) {
    let nextProgress = this.videoProgress + step

    if (nextProgress < 0) {
      nextProgress = 0
    }

    if (nextProgress > 100) {
      nextProgress = 100
    }

    this.videoProgress = nextProgress

    if (this.videoProgress === 100) {
      this.isVideoPlaying = false
    }
  }

  getVideoProgressText(): string {
    return this.videoProgress.toString() + '%'
  }

  previousDetailImage() {
    if (this.detailImageIndex === 0) {
      this.detailImageIndex = 2
    } else {
      this.detailImageIndex--
    }
  }

  nextDetailImage() {
    if (this.detailImageIndex === 2) {
      this.detailImageIndex = 0
    } else {
      this.detailImageIndex++
    }
  }

  getDetailImageCaption(): string {
    if (this.detailImageIndex === 0) {
      return '高清全图'
    }
    if (this.detailImageIndex === 1) {
      return '纹饰细节'
    }
    return '展柜视角'
  }

  submitVoiceQuestion() {
    if (this.voiceQuestion.trim() === '') {
      return
    }

    let relic = this.getSelectedRelic()

    if (this.voiceQuestion.includes('年代') || this.voiceQuestion.includes('朝代')) {
      this.voiceAnswer = '该文物的年代是' + relic.dynasty + '。'
    } else if (this.voiceQuestion.includes('分类') || this.voiceQuestion.includes('类型')) {
      this.voiceAnswer = '该文物属于' + relic.type + '类别。'
    } else if (this.voiceQuestion.includes('热度')) {
      this.voiceAnswer = '该文物当前热度为' + relic.hot + '。'
    } else {
      this.voiceAnswer = '关于“' + relic.name + '”，系统回答：' + relic.intro
    }
  }

  handleLoginOrRegister() {
    if (this.loginAccount.trim() === '' || this.loginPassword.trim() === '') {
      return
    }

    let inputAccount = this.loginAccount.trim()
    let lowerAccount = inputAccount.toLowerCase()

    this.account = inputAccount
    this.phone = inputAccount
    this.email = '未绑定'

    if (this.loginMode === '登录' &&
      (lowerAccount === 'admin' || lowerAccount === 'audit' || inputAccount.includes('审核'))) {
      this.userRole = '审核员'
      this.username = '内容审核员'
      this.phone = '内部账号'
      this.email = 'audit@museum.local'
    } else if (this.loginMode === '注册') {
      this.userRole = '普通用户'
      this.username = '新注册用户'
    } else {
      this.userRole = '普通用户'
      if (this.username === '内容审核员') {
        this.username = '博物馆访客'
      }
    }

    this.isLoggedIn = true
    this.loginPassword = ''
  }

  logout() {
    this.isLoggedIn = false
    this.userRole = '普通用户'
    this.username = '博物馆访客'
    this.account = '未登录'
    this.loginPassword = ''
  }

  addUserUpload() {
    if (this.uploadRelicName.trim() === '' || this.uploadLocation.trim() === '' || this.uploadDesc.trim() === '') {
      return
    }

    let newUpload: UserUpload = {
      id: this.uploadList.length + 1,
      relicName: this.uploadRelicName,
      location: this.uploadLocation,
      desc: this.uploadDesc,
      status: '待审核',
      time: '刚刚'
    }

    this.uploadList = [newUpload, ...this.uploadList]
    this.uploadCount = this.uploadList.length

    this.uploadRelicName = ''
    this.uploadLocation = ''
    this.uploadDesc = ''
  }

  setCommentStatus(id: number, status: string) {
    let newComments: RelicComment[] = []

    for (let i = 0; i < this.comments.length; i++) {
      let item = this.comments[i]

      if (item.id === id) {
        newComments.push({
          id: item.id,
          relicId: item.relicId,
          user: item.user,
          content: item.content,
          status: status,
          time: item.time,
          parentId: item.parentId,
          replyToUser: item.replyToUser,
          likeCount: item.likeCount
        })
      } else {
        newComments.push(item)
      }
    }

    this.comments = newComments
    this.auditVersion++
  }

  setUploadStatus(id: number, status: string) {
    let newUploadList: UserUpload[] = []

    for (let i = 0; i < this.uploadList.length; i++) {
      let item = this.uploadList[i]

      if (item.id === id) {
        newUploadList.push({
          id: item.id,
          relicName: item.relicName,
          location: item.location,
          desc: item.desc,
          status: status,
          time: item.time
        })
      } else {
        newUploadList.push(item)
      }
    }

    this.uploadList = newUploadList
    this.auditVersion++
  }

  getSelectedRelic(): Relic {
    for (let i = 0; i < this.relics.length; i++) {
      if (this.relics[i].id === this.selectedRelicId) {
        return this.relics[i]
      }
    }

    return this.relics[0]
  }

  getFavoriteList(): Relic[] {
    return this.relics.filter((item: Relic) => {
      return this.likedIds.includes(item.id) || this.collectedIds.includes(item.id)
    })
  }

  getLikedList(): Relic[] {
    return this.relics.filter((item: Relic) => {
      return this.likedIds.includes(item.id)
    })
  }

  getFavoriteGroupList(): Relic[] {
    if (this.selectedFavoriteGroup === '全部收藏') {
      return this.getFavoriteList()
    }

    if (this.selectedFavoriteGroup === '点赞记录') {
      return this.getLikedList()
    }

    let result: Relic[] = []
    let groupRelicIds: number[] = []

    for (let i = 0; i < this.favoriteGroups.length; i++) {
      if (this.favoriteGroups[i].name === this.selectedFavoriteGroup) {
        groupRelicIds = this.favoriteGroups[i].relicIds
      }
    }

    for (let i = 0; i < groupRelicIds.length; i++) {
      for (let j = 0; j < this.relics.length; j++) {
        if (this.relics[j].id === groupRelicIds[i]) {
          result.push(this.relics[j])
        }
      }
    }

    return result
  }

  getFavoriteGroupCount(name: string): number {
    if (name === '全部收藏') {
      return this.getFavoriteList().length
    }

    if (name === '点赞记录') {
      return this.getLikedList().length
    }

    for (let i = 0; i < this.favoriteGroups.length; i++) {
      if (this.favoriteGroups[i].name === name) {
        return this.favoriteGroups[i].relicIds.length
      }
    }

    return 0
  }

  setFavoriteGroup(name: string) {
    this.selectedFavoriteGroup = name

    if (name !== '全部收藏' && name !== '点赞记录') {
      this.targetFavoriteGroup = name
    }
  }

  createFavoriteGroup() {
    let name = this.favoriteGroupInput.trim()

    if (name === '') {
      return
    }

    let exist = false

    for (let i = 0; i < this.favoriteGroups.length; i++) {
      if (this.favoriteGroups[i].name === name) {
        exist = true
      }
    }

    if (!exist) {
      let newGroup: FavoriteGroup = {
        id: this.favoriteGroups.length + 1,
        name: name,
        relicIds: []
      }
      this.favoriteGroups = [...this.favoriteGroups, newGroup]
    }

    this.selectedFavoriteGroup = name
    this.targetFavoriteGroup = name
    this.favoriteGroupInput = ''
  }

  addToFavoriteGroup(id: number) {
    let newGroups: FavoriteGroup[] = []

    for (let i = 0; i < this.favoriteGroups.length; i++) {
      let group = this.favoriteGroups[i]

      if (group.name === this.targetFavoriteGroup && !group.relicIds.includes(id)) {
        newGroups.push({
          id: group.id,
          name: group.name,
          relicIds: [...group.relicIds, id]
        })
      } else {
        newGroups.push(group)
      }
    }

    this.favoriteGroups = newGroups
  }

  removeFromFavoriteGroups(id: number) {
    let newGroups: FavoriteGroup[] = []

    for (let i = 0; i < this.favoriteGroups.length; i++) {
      let group = this.favoriteGroups[i]
      newGroups.push({
        id: group.id,
        name: group.name,
        relicIds: group.relicIds.filter((itemId: number) => itemId !== id)
      })
    }

    this.favoriteGroups = newGroups
  }

  getHistoryList(): Relic[] {
    let result: Relic[] = []

    for (let i = 0; i < this.historyIds.length; i++) {
      let id = this.historyIds[i]
      for (let j = 0; j < this.relics.length; j++) {
        if (this.relics[j].id === id) {
          result.push(this.relics[j])
        }
      }
    }

    return result
  }

  isLiked(id: number): boolean {
    return this.likedIds.includes(id)
  }

  toggleLike(id: number) {
    if (!this.isLoggedIn) {
      this.currentIndex = 4
      return
    }

    let liked = this.likedIds.includes(id)

    if (liked) {
      this.likedIds = this.likedIds.filter((itemId: number) => itemId !== id)
    } else {
      this.likedIds = [...this.likedIds, id]
    }

    let newRelics: Relic[] = []

    for (let i = 0; i < this.relics.length; i++) {
      let item = this.relics[i]
      let nextHot = item.hot

      if (item.id === id) {
        if (liked && nextHot > 0) {
          nextHot--
        }

        if (!liked) {
          nextHot++
        }

        newRelics.push({
          id: item.id,
          name: item.name,
          dynasty: item.dynasty,
          type: item.type,
          hot: nextHot,
          intro: item.intro,
          image: item.image,
          liked: !liked,
          collected: item.collected
        })
      } else {
        newRelics.push(item)
      }
    }

    this.relics = newRelics
    this.auditVersion++
  }

  isCollected(id: number): boolean {
    return this.collectedIds.includes(id)
  }

  toggleCollect(id: number) {
    if (!this.isLoggedIn) {
      this.currentIndex = 4
      return
    }

    let collected = this.collectedIds.includes(id)

    if (collected) {
      this.collectedIds = this.collectedIds.filter((itemId: number) => itemId !== id)
      this.removeFromFavoriteGroups(id)
    } else {
      this.collectedIds = [...this.collectedIds, id]
      this.addToFavoriteGroup(id)
    }

    let newRelics: Relic[] = []

    for (let i = 0; i < this.relics.length; i++) {
      let item = this.relics[i]

      if (item.id === id) {
        newRelics.push({
          id: item.id,
          name: item.name,
          dynasty: item.dynasty,
          type: item.type,
          hot: item.hot,
          intro: item.intro,
          image: item.image,
          liked: item.liked,
          collected: !collected
        })
      } else {
        newRelics.push(item)
      }
    }

    this.relics = newRelics
    this.auditVersion++
  }

  addHistory(id: number) {
    let newHistory: number[] = []

    newHistory.push(id)

    for (let i = 0; i < this.historyIds.length; i++) {
      if (this.historyIds[i] !== id) {
        newHistory.push(this.historyIds[i])
      }
    }

    this.historyIds = newHistory
    this.selectedRelicId = id
    this.detailImageIndex = 0
    this.imageZoomed = false
    this.guideProgress = 0
    this.isGuidePlaying = false
    this.videoProgress = 0
    this.isVideoPlaying = false
    this.voiceQuestion = ''
    this.voiceAnswer = ''
  }

  @Builder
  DetailPage() {
    Column() {
      Row() {
        Text('← 返回列表')
          .fontSize(18)
          .fontColor('#1677FF')
          .onClick(() => {
            this.selectedRelicId = 0
          })

        Blank()

        Text('文物详情')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .width('90%')
      .margin({ top: 24, bottom: 12 })

      Scroll() {
        Column() {
          Column() {
            Image(this.getSelectedRelic().image)
              .width('100%')
              .height(this.imageZoomed ? 330 : 220)
              .borderRadius(16)
              .objectFit(this.imageZoomed ? ImageFit.Contain : ImageFit.Cover)
              .backgroundColor('#F2F4F8')
              .margin({ bottom: 10 })

            Row() {
              Button('上一张')
                .layoutWeight(1)
                .height(34)
                .margin({ right: 6 })
                .onClick(() => {
                  this.previousDetailImage()
                })

              Button(this.getDetailImageCaption())
                .layoutWeight(1)
                .height(34)
                .margin({ left: 6, right: 6 })
                .backgroundColor('#F5F6FA')
                .fontColor('#333333')

              Button('下一张')
                .layoutWeight(1)
                .height(34)
                .margin({ left: 6 })
                .onClick(() => {
                  this.nextDetailImage()
                })
            }
            .margin({ bottom: 8 })

            Button(this.imageZoomed ? '退出放大查看' : '放大查看图片')
              .width('100%')
              .height(38)
              .backgroundColor(this.imageZoomed ? '#1677FF' : '#F5F6FA')
              .fontColor(this.imageZoomed ? Color.White : '#333333')
              .margin({ bottom: 18 })
              .onClick(() => {
                this.imageZoomed = !this.imageZoomed
              })

            Text(this.getSelectedRelic().name)
              .fontSize(28)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 12 })

            Text('分类：' + this.getSelectedRelic().type)
              .fontSize(18)
              .fontColor('#666666')
              .margin({ bottom: 8 })

            Text('年代：' + this.getSelectedRelic().dynasty)
              .fontSize(18)
              .fontColor('#666666')
              .margin({ bottom: 8 })

            Text('热度：' + this.getSelectedRelic().hot)
              .fontSize(18)
              .fontColor('#CC6600')
              .margin({ bottom: 16 })

            Text('文物介绍')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 10 })

            Text(this.getSelectedRelic().intro)
              .fontSize(17)
              .lineHeight(30)
              .margin({ bottom: 24 })

            Row() {
              Button(this.isLiked(this.getSelectedRelic().id) ? '已点赞' : '点赞')
                .layoutWeight(1)
                .margin({ right: 8 })
                .onClick(() => {
                  this.toggleLike(this.getSelectedRelic().id)
                })

              Button(this.isCollected(this.getSelectedRelic().id) ? '已收藏' : '收藏')
                .layoutWeight(1)
                .margin({ left: 8 })
                .onClick(() => {
                  this.toggleCollect(this.getSelectedRelic().id)
                })
            }

            Text(this.isCollected(this.getSelectedRelic().id) ? '已加入收藏分组：' + this.targetFavoriteGroup : '收藏时将加入分组：' + this.targetFavoriteGroup)
              .fontSize(14)
              .fontColor('#666666')
              .margin({ top: 10 })

            Text('语音导览')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 24, bottom: 12 })

            Button(this.isGuidePlaying ? '暂停语音讲解' : '播放语音讲解')
              .width('100%')
              .height(46)
              .onClick(() => {
                this.toggleGuidePlay()
              })

            Text(this.isGuidePlaying ? '当前状态：正在播放，倍速：' + this.guideSpeed : '当前状态：未播放')
              .fontSize(15)
              .fontColor('#666666')
              .margin({ top: 10, bottom: 12 })

            Row() {
              Button('0.75x')
                .width(70)
                .height(34)
                .backgroundColor(this.guideSpeed === '0.75x' ? '#1677FF' : '#F5F6FA')
                .fontColor(this.guideSpeed === '0.75x' ? Color.White : '#333333')
                .onClick(() => {
                  this.guideSpeed = '0.75x'
                })

              Button('1.0x')
                .width(70)
                .height(34)
                .margin({ left: 6 })
                .backgroundColor(this.guideSpeed === '1.0x' ? '#1677FF' : '#F5F6FA')
                .fontColor(this.guideSpeed === '1.0x' ? Color.White : '#333333')
                .onClick(() => {
                  this.guideSpeed = '1.0x'
                })

              Button('1.5x')
                .width(70)
                .height(34)
                .margin({ left: 6 })
                .backgroundColor(this.guideSpeed === '1.5x' ? '#1677FF' : '#F5F6FA')
                .fontColor(this.guideSpeed === '1.5x' ? Color.White : '#333333')
                .onClick(() => {
                  this.guideSpeed = '1.5x'
                })

              Button('2.0x')
                .width(70)
                .height(34)
                .margin({ left: 6 })
                .backgroundColor(this.guideSpeed === '2.0x' ? '#1677FF' : '#F5F6FA')
                .fontColor(this.guideSpeed === '2.0x' ? Color.White : '#333333')
                .onClick(() => {
                  this.guideSpeed = '2.0x'
                })
            }
            .margin({ bottom: 18 })

            Text('讲解进度：' + this.getGuideProgressText())
              .fontSize(15)
              .fontColor('#666666')
              .margin({ bottom: 8 })

            Row() {
              Button('-10%')
                .layoutWeight(1)
                .height(34)
                .margin({ right: 6 })
                .onClick(() => {
                  this.changeGuideProgress(-10)
                })

              Button('+10%')
                .layoutWeight(1)
                .height(34)
                .margin({ left: 6 })
                .onClick(() => {
                  this.changeGuideProgress(10)
                })
            }
            .margin({ bottom: 18 })

            Text('视频讲解')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 8, bottom: 12 })

            Column() {
              Text(this.isVideoPlaying ? '视频讲解播放中' : '视频讲解未播放')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .margin({ bottom: 8 })

              Text('进度：' + this.getVideoProgressText())
                .fontSize(15)
                .fontColor('#E8EDF5')
            }
            .width('100%')
            .height(150)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .backgroundColor('#2F3A4A')
            .borderRadius(14)
            .margin({ bottom: 12 })

            Row() {
              Button(this.isVideoPlaying ? '暂停视频' : '播放视频')
                .layoutWeight(1)
                .height(38)
                .margin({ right: 6 })
                .onClick(() => {
                  this.toggleVideoPlay()
                })

              Button('-15%')
                .width(70)
                .height(38)
                .margin({ left: 6, right: 6 })
                .backgroundColor('#F5F6FA')
                .fontColor('#333333')
                .onClick(() => {
                  this.changeVideoProgress(-15)
                })

              Button('+15%')
                .width(70)
                .height(38)
                .margin({ left: 6 })
                .backgroundColor('#F5F6FA')
                .fontColor('#333333')
                .onClick(() => {
                  this.changeVideoProgress(15)
                })
            }
            .margin({ bottom: 18 })

            Text('语音问答')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 8, bottom: 12 })

            TextInput({
              placeholder: '模拟语音提问，例如：这个文物是什么年代的？',
              text: this.voiceQuestion
            })
              .width('100%')
              .height(46)
              .backgroundColor('#F5F6FA')
              .borderRadius(12)
              .padding({ left: 12, right: 12 })
              .onChange((value: string) => {
                this.voiceQuestion = value
              })

            Button('模拟语音提问')
              .width('100%')
              .height(44)
              .margin({ top: 12, bottom: 12 })
              .onClick(() => {
                this.submitVoiceQuestion()
              })

            if (this.voiceAnswer !== '') {
              Text('系统回答：' + this.voiceAnswer)
                .fontSize(16)
                .lineHeight(24)
                .fontColor('#333333')
                .padding(12)
                .backgroundColor('#F5F6FA')
                .borderRadius(12)
                .margin({ bottom: 12 })
            }

            Text('留言评论')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 24, bottom: 12 })

            TextInput({
              placeholder: this.isLoggedIn ? '请输入你对该文物的评论' : '请先登录后再发表评论',
              text: this.commentInput
            })
              .width('100%')
              .height(46)
              .backgroundColor('#F5F6FA')
              .borderRadius(12)
              .padding({ left: 12, right: 12 })
              .onChange((value: string) => {
                this.commentInput = value
              })

            Button(this.isLoggedIn ? '提交评论' : '去登录后评论')
              .width('100%')
              .height(44)
              .margin({ top: 12, bottom: 16 })
              .onClick(() => {
                this.addComment()
              })

            if (this.getCurrentComments().length === 0) {
              Text('暂无评论，快来发表第一条评论吧')
                .fontSize(15)
                .fontColor('#888888')
                .margin({ top: 8, bottom: 20 })
            } else {
              ForEach(this.getCurrentComments(), (item: RelicComment) => {
                Column() {
                  Row() {
                    Text(item.user)
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)

                    Blank()

                    Text(item.status)
                      .fontSize(14)
                      .fontColor('#CC6600')
                  }
                  .width('100%')

                  Text(item.content)
                    .fontSize(16)
                    .lineHeight(24)
                    .margin({ top: 8 })

                  Row() {
                    Text(item.time)
                      .fontSize(13)
                      .fontColor('#999999')

                    Blank()

                    Button(this.isCommentLiked(item.id) ? '已赞 ' + item.likeCount : '点赞 ' + item.likeCount)
                      .height(30)
                      .margin({ right: 6 })
                      .onClick(() => {
                        this.toggleCommentLike(item.id)
                      })

                    Button(this.replyTargetId === item.id ? '取消回复' : '回复')
                      .height(30)
                      .onClick(() => {
                        if (this.replyTargetId === item.id) {
                          this.replyTargetId = 0
                          this.replyInput = ''
                        } else {
                          this.startReply(item.id)
                        }
                      })
                  }
                  .width('100%')
                  .margin({ top: 8 })

                  if (this.replyTargetId === item.id) {
                    TextInput({
                      placeholder: '回复 ' + item.user + '，提交后需审核',
                      text: this.replyInput
                    })
                      .width('100%')
                      .height(40)
                      .backgroundColor(Color.White)
                      .borderRadius(10)
                      .padding({ left: 10, right: 10 })
                      .margin({ top: 8, bottom: 8 })
                      .onChange((value: string) => {
                        this.replyInput = value
                      })

                    Button('提交回复')
                      .width('100%')
                      .height(36)
                      .margin({ bottom: 8 })
                      .onClick(() => {
                        this.addReply(item)
                      })
                  }

                  ForEach(this.getReplies(item.id), (reply: RelicComment) => {
                    Column() {
                      Text(reply.user + ' 回复 ' + reply.replyToUser)
                        .fontSize(14)
                        .fontWeight(FontWeight.Bold)
                        .fontColor('#1677FF')
                        .margin({ bottom: 4 })

                      Text(reply.content)
                        .fontSize(14)
                        .lineHeight(22)

                      Text(reply.time)
                        .fontSize(12)
                        .fontColor('#999999')
                        .margin({ top: 4 })
                    }
                    .width('100%')
                    .padding(10)
                    .margin({ top: 8 })
                    .backgroundColor(Color.White)
                    .borderRadius(10)
                  }, (reply: RelicComment) => reply.id.toString() + reply.status + this.auditVersion.toString())
                }
                .width('100%')
                .padding(12)
                .margin({ bottom: 10 })
                .backgroundColor('#F5F6FA')
                .borderRadius(12)
              }, (item: RelicComment) => item.id.toString() + item.status + this.auditVersion.toString())
            }
          }
          .width('90%')
          .padding(20)
          .backgroundColor(Color.White)
          .borderRadius(18)
          .shadow({ radius: 8, color: '#22000000', offsetX: 0, offsetY: 2 })
          .margin({ bottom: 30 })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F6FA')
  }

  @Builder
  ImageSearchCard(item: Relic) {
    Row() {
      Image(item.image)
        .width(90)
        .height(90)
        .borderRadius(12)
        .objectFit(ImageFit.Cover)
        .margin({ right: 12 })

      Column() {
        Text(item.name)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 6 })

        Text(item.dynasty + ' · ' + item.type)
          .fontSize(15)
          .fontColor('#666666')
          .margin({ bottom: 6 })

        Text('相似度：' + this.getSimilarity(item.id))
          .fontSize(16)
          .fontColor('#CC6600')
          .margin({ bottom: 8 })

        Button('查看详情')
          .height(34)
          .onClick(() => {
            this.addHistory(item.id)
            this.currentIndex = 0
          })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('90%')
    .padding(14)
    .margin({ bottom: 12 })
    .backgroundColor(Color.White)
    .borderRadius(16)
    .shadow({ radius: 6, color: '#22000000', offsetX: 0, offsetY: 2 })
  }

  @Builder
  RelicCard(item: Relic) {
    Column() {
      Image(item.image)
        .width('100%')
        .height(160)
        .borderRadius(14)
        .objectFit(ImageFit.Cover)
        .margin({ bottom: 14 })

      Text(item.name)
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 8 })

      Text('分类：' + item.type)
        .fontSize(16)
        .fontColor('#666666')

      Text('年代：' + item.dynasty)
        .fontSize(16)
        .fontColor('#666666')
        .margin({ top: 4 })

      Text('热度：' + item.hot)
        .fontSize(16)
        .fontColor('#CC6600')
        .margin({ top: 4 })

      Text('简介：' + item.intro)
        .fontSize(15)
        .lineHeight(24)
        .margin({ top: 12 })

      Row() {
        Button(this.isLiked(item.id) ? '已点赞' : '点赞')
          .layoutWeight(1)
          .margin({ right: 6 })
          .onClick(() => {
            this.toggleLike(item.id)
          })

        Button(this.isCollected(item.id) ? '已收藏' : '收藏')
          .layoutWeight(1)
          .margin({ left: 6, right: 6 })
          .onClick(() => {
            this.toggleCollect(item.id)
          })

        Button('查看')
          .layoutWeight(1)
          .margin({ left: 6 })
          .onClick(() => {
            this.addHistory(item.id)
          })
      }
      .margin({ top: 20 })
    }
    .width('90%')
    .padding(18)
    .margin({ bottom: 16 })
    .backgroundColor(Color.White)
    .borderRadius(16)
    .shadow({ radius: 8, color: '#22000000', offsetX: 0, offsetY: 2 })
  }

  @Builder
  RelicBrowsePage() {
    if (this.selectedRelicId !== 0) {
      this.DetailPage()
    } else {
      Column() {
        Scroll() {
          Column() {
            Text('文物浏览')
              .fontSize(28)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 24, bottom: 8 })

            Text('掌上博物馆')
              .fontSize(18)
              .fontColor('#666666')
              .margin({ bottom: 14 })

            Row() {
              Button('全部')
                .width(60)
                .height(36)
                .backgroundColor(this.selectedType === '全部' ? '#1677FF' : '#FFFFFF')
                .fontColor(this.selectedType === '全部' ? Color.White : '#333333')
                .onClick(() => {
                  this.selectedType = '全部'
                })

              Button('玉器')
                .width(60)
                .height(36)
                .margin({ left: 6 })
                .backgroundColor(this.selectedType === '玉器' ? '#1677FF' : '#FFFFFF')
                .fontColor(this.selectedType === '玉器' ? Color.White : '#333333')
                .onClick(() => {
                  this.selectedType = '玉器'
                })

              Button('瓷器')
                .width(60)
                .height(36)
                .margin({ left: 6 })
                .backgroundColor(this.selectedType === '瓷器' ? '#1677FF' : '#FFFFFF')
                .fontColor(this.selectedType === '瓷器' ? Color.White : '#333333')
                .onClick(() => {
                  this.selectedType = '瓷器'
                })

              Button('青铜器')
                .width(75)
                .height(36)
                .margin({ left: 6 })
                .backgroundColor(this.selectedType === '青铜器' ? '#1677FF' : '#FFFFFF')
                .fontColor(this.selectedType === '青铜器' ? Color.White : '#333333')
                .onClick(() => {
                  this.selectedType = '青铜器'
                })
            }
            .width('94%')
            .margin({ bottom: 10 })

            Row() {
              Button('中国画')
                .width(75)
                .height(36)
                .backgroundColor(this.selectedType === '中国画' ? '#1677FF' : '#FFFFFF')
                .fontColor(this.selectedType === '中国画' ? Color.White : '#333333')
                .onClick(() => {
                  this.selectedType = '中国画'
                })

              Button('默认')
                .width(75)
                .height(36)
                .margin({ left: 6 })
                .backgroundColor(this.sortMode === '默认' ? '#1677FF' : '#FFFFFF')
                .fontColor(this.sortMode === '默认' ? Color.White : '#333333')
                .onClick(() => {
                  this.sortMode = '默认'
                })

              Button('热度降序')
                .width(95)
                .height(36)
                .margin({ left: 6 })
                .backgroundColor(this.sortMode === '热度降序' ? '#1677FF' : '#FFFFFF')
                .fontColor(this.sortMode === '热度降序' ? Color.White : '#333333')
                .onClick(() => {
                  this.sortMode = '热度降序'
                })

              Button('热度升序')
                .width(95)
                .height(36)
                .margin({ left: 6 })
                .backgroundColor(this.sortMode === '热度升序' ? '#1677FF' : '#FFFFFF')
                .fontColor(this.sortMode === '热度升序' ? Color.White : '#333333')
                .onClick(() => {
                  this.sortMode = '热度升序'
                })
            }
            .width('94%')
            .margin({ bottom: 10 })

            Row() {
              Button('早到晚')
                .width(95)
                .height(36)
                .backgroundColor(this.sortMode === '年代从早到晚' ? '#1677FF' : '#FFFFFF')
                .fontColor(this.sortMode === '年代从早到晚' ? Color.White : '#333333')
                .onClick(() => {
                  this.sortMode = '年代从早到晚'
                })

              Button('晚到早')
                .width(95)
                .height(36)
                .margin({ left: 8 })
                .backgroundColor(this.sortMode === '年代从晚到早' ? '#1677FF' : '#FFFFFF')
                .fontColor(this.sortMode === '年代从晚到早' ? Color.White : '#333333')
                .onClick(() => {
                  this.sortMode = '年代从晚到早'
                })
            }
            .width('94%')
            .margin({ bottom: 12 })

            Text('当前分类：' + this.selectedType + '，排序：' + this.sortMode + '，共 ' + this.getBrowseList().length + ' 件')
              .fontSize(15)
              .fontColor('#666666')
              .margin({ bottom: 12 })

            ForEach(this.getBrowseList(), (item: Relic) => {
              this.RelicCard(item)
            }, (item: Relic) => item.id.toString() + item.hot.toString() + this.auditVersion.toString())
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
        }
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F6FA')
    }
  }

  @Builder
  FavoritePage() {
    Column() {
      Text('点赞收藏')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 24, bottom: 20 })

      if (!this.isLoggedIn) {
        Column() {
          Text('请先登录后查看收藏')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 80, bottom: 16 })

          Text('登录后可以查看你点赞和收藏过的文物。')
            .fontSize(16)
            .fontColor('#888888')
            .margin({ bottom: 24 })

          Button('去登录')
            .width('70%')
            .height(46)
            .onClick(() => {
              this.currentIndex = 4
            })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      } else {
        Scroll() {
          Column() {
            Column() {
              Text('收藏夹分组管理')
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 12 })

              Text('当前收藏默认加入：' + this.targetFavoriteGroup)
                .fontSize(15)
                .fontColor('#666666')
                .margin({ bottom: 12 })

              Row() {
                TextInput({
                  placeholder: '新建分组名称，例如：课程展示',
                  text: this.favoriteGroupInput
                })
                  .layoutWeight(1)
                  .height(42)
                  .backgroundColor('#F5F6FA')
                  .borderRadius(10)
                  .padding({ left: 10, right: 10 })
                  .margin({ right: 8 })
                  .onChange((value: string) => {
                    this.favoriteGroupInput = value
                  })

                Button('新建')
                  .width(76)
                  .height(42)
                  .onClick(() => {
                    this.createFavoriteGroup()
                  })
              }
              .margin({ bottom: 12 })

              Row() {
                Button('全部 ' + this.getFavoriteGroupCount('全部收藏'))
                  .height(36)
                  .layoutWeight(1)
                  .margin({ right: 6 })
                  .backgroundColor(this.selectedFavoriteGroup === '全部收藏' ? '#1677FF' : '#F5F6FA')
                  .fontColor(this.selectedFavoriteGroup === '全部收藏' ? Color.White : '#333333')
                  .onClick(() => {
                    this.setFavoriteGroup('全部收藏')
                  })

                Button('点赞 ' + this.getFavoriteGroupCount('点赞记录'))
                  .height(36)
                  .layoutWeight(1)
                  .margin({ left: 6 })
                  .backgroundColor(this.selectedFavoriteGroup === '点赞记录' ? '#1677FF' : '#F5F6FA')
                  .fontColor(this.selectedFavoriteGroup === '点赞记录' ? Color.White : '#333333')
                  .onClick(() => {
                    this.setFavoriteGroup('点赞记录')
                  })
              }
              .margin({ bottom: 10 })

              ForEach(this.favoriteGroups, (group: FavoriteGroup) => {
                Button(group.name + ' ' + this.getFavoriteGroupCount(group.name))
                  .width('100%')
                  .height(36)
                  .margin({ bottom: 8 })
                  .backgroundColor(this.selectedFavoriteGroup === group.name ? '#1677FF' : '#F5F6FA')
                  .fontColor(this.selectedFavoriteGroup === group.name ? Color.White : '#333333')
                  .onClick(() => {
                    this.setFavoriteGroup(group.name)
                  })
              }, (group: FavoriteGroup) => group.id.toString() + group.name)
            }
            .width('90%')
            .padding(18)
            .backgroundColor(Color.White)
            .borderRadius(16)
            .margin({ bottom: 16 })

            if (this.getFavoriteGroupList().length === 0) {
              Text('当前分组暂无文物')
                .fontSize(18)
                .fontColor('#888888')
                .margin({ top: 30, bottom: 30 })
            } else {
              Text('当前分组：' + this.selectedFavoriteGroup)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 12 })

              ForEach(this.getFavoriteGroupList(), (item: Relic) => {
                this.RelicCard(item)
              }, (item: Relic) => item.id.toString() + item.hot.toString() + this.auditVersion.toString())
            }
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
        }
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F6FA')
  }

  @Builder
  HistoryPage() {
    Column() {
      Text('浏览记录')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 24, bottom: 20 })

      if (this.getHistoryList().length === 0) {
        Text('暂无浏览记录')
          .fontSize(18)
          .fontColor('#888888')
          .margin({ top: 40 })
      } else {
        Scroll() {
          Column() {
            ForEach(this.getHistoryList(), (item: Relic) => {
              this.RelicCard(item)
            }, (item: Relic) => item.id.toString() + item.hot.toString() + this.auditVersion.toString())
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
        }
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F6FA')
  }

  @Builder
  SearchPage() {
    Column() {
      Text('搜索中心')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 24, bottom: 16 })

      Row() {
        Button('文本搜索')
          .layoutWeight(1)
          .height(42)
          .margin({ right: 5 })
          .backgroundColor(this.searchMode === '文本搜索' ? '#1677FF' : '#FFFFFF')
          .fontColor(this.searchMode === '文本搜索' ? Color.White : '#333333')
          .onClick(() => {
            this.searchMode = '文本搜索'
          })

        Button('以图搜图')
          .layoutWeight(1)
          .height(42)
          .margin({ left: 5, right: 5 })
          .backgroundColor(this.searchMode === '以图搜图' ? '#1677FF' : '#FFFFFF')
          .fontColor(this.searchMode === '以图搜图' ? Color.White : '#333333')
          .onClick(() => {
            this.searchMode = '以图搜图'
          })

        Button('语音搜索')
          .layoutWeight(1)
          .height(42)
          .margin({ left: 5 })
          .backgroundColor(this.searchMode === '语音搜索' ? '#1677FF' : '#FFFFFF')
          .fontColor(this.searchMode === '语音搜索' ? Color.White : '#333333')
          .onClick(() => {
            this.searchMode = '语音搜索'
          })
      }
      .width('90%')
      .margin({ bottom: 16 })

      Scroll() {
        Column() {
          if (this.searchMode === '文本搜索') {
            Column() {
              Text('文本搜索')
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 12 })

              TextInput({
                placeholder: '请输入文物名称、朝代、类型或关键词',
                text: this.keyword
              })
                .width('100%')
                .height(46)
                .backgroundColor('#F5F6FA')
                .borderRadius(12)
                .padding({ left: 12, right: 12 })
                .margin({ bottom: 14 })
                .onChange((value: string) => {
                  this.keyword = value
                })

              if (this.keyword.trim() === '') {
                Text('请输入关键词开始搜索，例如：青铜、明代、玉器、山水')
                  .fontSize(16)
                  .fontColor('#888888')
                  .lineHeight(24)
                  .margin({ top: 30, bottom: 30 })
              } else {
                Text('搜索结果：' + this.getSearchList().length + ' 条')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .margin({ bottom: 12 })

                Row() {
                  Text('玉器 ' + this.getSearchTypeCount('玉器'))
                    .fontSize(14)
                    .fontColor('#1677FF')
                    .padding(8)
                    .backgroundColor('#EEF5FF')
                    .borderRadius(8)
                    .margin({ right: 6 })

                  Text('瓷器 ' + this.getSearchTypeCount('瓷器'))
                    .fontSize(14)
                    .fontColor('#1677FF')
                    .padding(8)
                    .backgroundColor('#EEF5FF')
                    .borderRadius(8)
                    .margin({ right: 6 })

                  Text('青铜器 ' + this.getSearchTypeCount('青铜器'))
                    .fontSize(14)
                    .fontColor('#1677FF')
                    .padding(8)
                    .backgroundColor('#EEF5FF')
                    .borderRadius(8)
                    .margin({ right: 6 })

                  Text('中国画 ' + this.getSearchTypeCount('中国画'))
                    .fontSize(14)
                    .fontColor('#1677FF')
                    .padding(8)
                    .backgroundColor('#EEF5FF')
                    .borderRadius(8)
                }
                .margin({ bottom: 14 })

                ForEach(this.getSearchList(), (item: Relic) => {
                  this.RelicCard(item)
                }, (item: Relic) => item.id.toString() + item.hot.toString() + this.auditVersion.toString())
              }
            }
            .width('90%')
            .padding(18)
            .backgroundColor(Color.White)
            .borderRadius(18)
            .margin({ bottom: 30 })
          } else if (this.searchMode === '以图搜图') {
            Column() {
              Text('以图搜图')
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 12 })

              Text('上传文物图片或实时拍照后，系统会模拟提取图像特征，并返回相似文物列表。')
                .fontSize(15)
                .fontColor('#666666')
                .lineHeight(24)
                .margin({ bottom: 16 })

              Row() {
                Button('从相册选择图片')
                  .layoutWeight(1)
                  .height(44)
                  .margin({ right: 6 })
                  .onClick(() => {
                    this.imageSearchDone = true
                    this.imageSearchMode = '相册图片'
                  })

                Button('实时拍照搜索')
                  .layoutWeight(1)
                  .height(44)
                  .margin({ left: 6 })
                  .onClick(() => {
                    this.imageSearchDone = true
                    this.imageSearchMode = '实时拍照'
                  })
              }
              .margin({ bottom: 16 })

              if (this.imageSearchDone) {
                Text('已选择：' + this.imageSearchMode)
                  .fontSize(16)
                  .fontColor('#1677FF')
                  .margin({ bottom: 8 })

                Text('图像特征提取完成，按相似度排序如下：')
                  .fontSize(15)
                  .fontColor('#666666')
                  .margin({ bottom: 12 })

                ForEach(this.getImageSearchList(), (item: Relic) => {
                  this.ImageSearchCard(item)
                }, (item: Relic) => item.id.toString() + item.hot.toString() + this.auditVersion.toString())
              } else {
                Text('暂未上传图片')
                  .fontSize(17)
                  .fontColor('#999999')
                  .margin({ top: 40, bottom: 40 })
              }
            }
            .width('90%')
            .padding(18)
            .backgroundColor(Color.White)
            .borderRadius(18)
            .margin({ bottom: 30 })
          } else {
            Column() {
              Text('语音搜索')
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 12 })

              Text('模拟用户说出搜索内容，系统识别语音并提取关键词进行文物检索。')
                .fontSize(15)
                .fontColor('#666666')
                .lineHeight(24)
                .margin({ bottom: 16 })

              TextInput({
                placeholder: '模拟语音内容，例如：帮我查找青铜器',
                text: this.voiceSearchInput
              })
                .width('100%')
                .height(46)
                .backgroundColor('#F5F6FA')
                .borderRadius(12)
                .padding({ left: 12, right: 12 })
                .margin({ bottom: 12 })
                .onChange((value: string) => {
                  this.voiceSearchInput = value
                })

              Button('模拟语音识别')
                .width('100%')
                .height(44)
                .margin({ bottom: 16 })
                .onClick(() => {
                  this.submitVoiceSearch()
                })

              if (this.voiceSearchKeyword === '') {
                Text('暂未进行语音搜索')
                  .fontSize(16)
                  .fontColor('#999999')
                  .margin({ top: 30, bottom: 30 })
              } else {
                Text('识别关键词：' + this.voiceSearchKeyword)
                  .fontSize(16)
                  .fontColor('#1677FF')
                  .margin({ bottom: 12 })

                Text('搜索结果：' + this.getVoiceSearchList().length + ' 条')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .margin({ bottom: 12 })

                ForEach(this.getVoiceSearchList(), (item: Relic) => {
                  this.RelicCard(item)
                }, (item: Relic) => item.id.toString() + item.hot.toString() + this.auditVersion.toString())
              }
            }
            .width('90%')
            .padding(18)
            .backgroundColor(Color.White)
            .borderRadius(18)
            .margin({ bottom: 30 })
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F6FA')
  }

  @Builder
  UserCenterPage() {
    Column() {
      Text('用户个人信息管理')
        .fontSize(26)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 24, bottom: 20 })

      Scroll() {
        Column() {
          Column() {
            Text('个人主页')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 16 })

            Text('账号：' + this.account)
              .fontSize(18)
              .margin({ bottom: 10 })

            Text('昵称：' + this.username)
              .fontSize(18)
              .margin({ bottom: 10 })

            Text('身份：' + this.userRole)
              .fontSize(18)
              .fontColor(this.userRole === '审核员' ? '#CC6600' : '#1677FF')
              .margin({ bottom: 10 })

            Text('手机号：' + this.phone)
              .fontSize(18)
              .margin({ bottom: 10 })

            Text('邮箱：' + this.email)
              .fontSize(18)
              .margin({ bottom: 10 })

            Text('隐私状态：' + (this.privacyVisible ? '公开' : '仅自己可见'))
              .fontSize(18)
              .fontColor(this.privacyVisible ? '#1677FF' : '#CC6600')
              .margin({ bottom: 10 })
          }
          .width('90%')
          .padding(18)
          .backgroundColor(Color.White)
          .borderRadius(16)
          .margin({ bottom: 16 })

          Column() {
            Text('修改个人信息')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 16 })

            TextInput({
              placeholder: '请输入昵称',
              text: this.username
            })
              .width('100%')
              .height(44)
              .backgroundColor('#F5F6FA')
              .borderRadius(12)
              .padding({ left: 12, right: 12 })
              .margin({ bottom: 12 })
              .onChange((value: string) => {
                this.username = value
              })

            TextInput({
              placeholder: '请输入手机号',
              text: this.phone
            })
              .width('100%')
              .height(44)
              .backgroundColor('#F5F6FA')
              .borderRadius(12)
              .padding({ left: 12, right: 12 })
              .margin({ bottom: 12 })
              .onChange((value: string) => {
                this.phone = value
              })

            TextInput({
              placeholder: '请输入邮箱',
              text: this.email
            })
              .width('100%')
              .height(44)
              .backgroundColor('#F5F6FA')
              .borderRadius(12)
              .padding({ left: 12, right: 12 })
              .margin({ bottom: 12 })
              .onChange((value: string) => {
                this.email = value
              })

            Button(this.privacyVisible ? '切换为仅自己可见' : '切换为公开')
              .width('100%')
              .height(44)
              .onClick(() => {
                this.privacyVisible = !this.privacyVisible
              })
          }
          .width('90%')
          .padding(18)
          .backgroundColor(Color.White)
          .borderRadius(16)
          .margin({ bottom: 16 })

          Column() {
            Text('我的数据')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 16 })

            Text('我的收藏数量：' + this.collectedIds.length)
              .fontSize(18)
              .margin({ bottom: 10 })

            Text('我的点赞数量：' + this.likedIds.length)
              .fontSize(18)
              .margin({ bottom: 10 })

            Text('评论点赞数量：' + this.likedCommentIds.length)
              .fontSize(18)
              .margin({ bottom: 10 })

            Text('浏览记录数量：' + this.historyIds.length)
              .fontSize(18)
              .margin({ bottom: 10 })

            Text('上传内容数量：' + this.uploadCount)
              .fontSize(18)
              .margin({ bottom: 10 })
          }
          .width('90%')
          .padding(18)
          .backgroundColor(Color.White)
          .borderRadius(16)
          .margin({ bottom: 16 })

          if (this.userRole === '审核员') {
            Column() {
              Text('审核中心')
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 16 })

            Text('评论审核')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 12 })

            if (this.getPendingComments().length === 0) {
              Text('暂无评论需要审核')
                .fontSize(16)
                .fontColor('#999999')
                .margin({ bottom: 12 })
            } else {
              ForEach(this.getPendingComments(), (item: RelicComment) => {
                Column() {
                  Row() {
                    Text(item.user)
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)

                    Blank()

                    Text(item.status)
                      .fontSize(14)
                      .fontColor(item.status === '待审核' ? '#CC6600' : '#1677FF')
                  }
                  .width('100%')

                  Text('评论内容：' + item.content)
                    .fontSize(15)
                    .lineHeight(22)
                    .margin({ top: 8, bottom: 10 })

                  if (item.parentId !== 0) {
                    Text('回复对象：' + item.replyToUser)
                      .fontSize(14)
                      .fontColor('#666666')
                      .margin({ bottom: 10 })
                  }

                  Row() {
                    Button('通过')
                      .layoutWeight(1)
                      .height(36)
                      .margin({ right: 6 })
                      .onClick(() => {
                        this.setCommentStatus(item.id, '已通过')
                      })

                    Button('驳回')
                      .layoutWeight(1)
                      .height(36)
                      .margin({ left: 6 })
                      .backgroundColor('#FF4D4F')
                      .fontColor(Color.White)
                      .onClick(() => {
                        this.setCommentStatus(item.id, '已驳回')
                      })
                  }
                }
                .width('100%')
                .padding(12)
                .margin({ bottom: 10 })
                .backgroundColor('#F5F6FA')
                .borderRadius(12)
              }, (item: RelicComment) => item.id.toString())
            }

            Text('上传内容审核')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 18, bottom: 12 })

            if (this.getPendingUploads().length === 0) {
              Text('暂无上传内容需要审核')
                .fontSize(16)
                .fontColor('#999999')
                .margin({ bottom: 12 })
            } else {
              ForEach(this.getPendingUploads(), (item: UserUpload) => {
                Column() {
                  Row() {
                    Text(item.relicName)
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)

                    Blank()

                    Text(item.status)
                      .fontSize(14)
                      .fontColor(item.status === '待审核' ? '#CC6600' : '#1677FF')
                  }
                  .width('100%')

                  Text('拍摄地点：' + item.location)
                    .fontSize(15)
                    .fontColor('#666666')
                    .margin({ top: 8 })

                  Text('说明：' + item.desc)
                    .fontSize(15)
                    .lineHeight(22)
                    .margin({ top: 6, bottom: 10 })

                  Row() {
                    Button('通过')
                      .layoutWeight(1)
                      .height(36)
                      .margin({ right: 6 })
                      .onClick(() => {
                        this.setUploadStatus(item.id, '已通过')
                      })

                    Button('驳回')
                      .layoutWeight(1)
                      .height(36)
                      .margin({ left: 6 })
                      .backgroundColor('#FF4D4F')
                      .fontColor(Color.White)
                      .onClick(() => {
                        this.setUploadStatus(item.id, '已驳回')
                      })
                  }
                }
                .width('100%')
                .padding(12)
                .margin({ bottom: 10 })
                .backgroundColor('#F5F6FA')
                .borderRadius(12)
              }, (item: UserUpload) => item.id.toString() + item.status + this.auditVersion.toString())
            }
            }
            .width('90%')
            .padding(18)
            .backgroundColor(Color.White)
            .borderRadius(16)
            .margin({ bottom: 16 })
          } else {
            Column() {
              Text('审核中心')
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 12 })

              Text('当前身份为普通用户，不能审核评论或上传内容。演示审核流程时，请退出后使用账号 admin 登录。')
                .fontSize(16)
                .fontColor('#666666')
                .lineHeight(24)
            }
            .width('90%')
            .padding(18)
            .backgroundColor(Color.White)
            .borderRadius(16)
            .margin({ bottom: 16 })
          }

          Column() {
            Text('用户上传照片')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 16 })

            Text('当前为前端模拟上传：填写文物名称、拍摄地点和说明后，生成一条待审核记录。')
              .fontSize(15)
              .fontColor('#666666')
              .lineHeight(24)
              .margin({ bottom: 12 })

            TextInput({
              placeholder: '关联文物名称，例如：青花瓷瓶',
              text: this.uploadRelicName
            })
              .width('100%')
              .height(44)
              .backgroundColor('#F5F6FA')
              .borderRadius(12)
              .padding({ left: 12, right: 12 })
              .margin({ bottom: 12 })
              .onChange((value: string) => {
                this.uploadRelicName = value
              })

            TextInput({
              placeholder: '拍摄地点，例如：故宫博物院',
              text: this.uploadLocation
            })
              .width('100%')
              .height(44)
              .backgroundColor('#F5F6FA')
              .borderRadius(12)
              .padding({ left: 12, right: 12 })
              .margin({ bottom: 12 })
              .onChange((value: string) => {
                this.uploadLocation = value
              })

            TextInput({
              placeholder: '简短说明，例如：参观时拍摄的展品照片',
              text: this.uploadDesc
            })
              .width('100%')
              .height(44)
              .backgroundColor('#F5F6FA')
              .borderRadius(12)
              .padding({ left: 12, right: 12 })
              .margin({ bottom: 12 })
              .onChange((value: string) => {
                this.uploadDesc = value
              })

            Button('提交上传')
              .width('100%')
              .height(44)
              .margin({ bottom: 16 })
              .onClick(() => {
                this.addUserUpload()
              })

            Text('我的上传记录')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 12 })

            if (this.uploadList.length === 0) {
              Text('暂无上传记录')
                .fontSize(16)
                .fontColor('#999999')
                .margin({ bottom: 8 })
            } else {
              ForEach(this.uploadList, (item: UserUpload) => {
                Column() {
                  Row() {
                    Text(item.relicName)
                      .fontSize(18)
                      .fontWeight(FontWeight.Bold)

                    Blank()

                    Text(item.status)
                      .fontSize(14)
                      .fontColor('#CC6600')
                  }
                  .width('100%')

                  Text('拍摄地点：' + item.location)
                    .fontSize(15)
                    .fontColor('#666666')
                    .margin({ top: 8 })

                  Text('说明：' + item.desc)
                    .fontSize(15)
                    .lineHeight(22)
                    .margin({ top: 6 })

                  Text(item.time)
                    .fontSize(13)
                    .fontColor('#999999')
                    .margin({ top: 6 })
                }
                .width('100%')
                .padding(12)
                .margin({ bottom: 10 })
                .backgroundColor('#F5F6FA')
                .borderRadius(12)
              }, (item: UserUpload) => item.id.toString() + item.status + this.auditVersion.toString())
            }

            Text('公开展示照片')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 18, bottom: 12 })

            if (this.getApprovedUploads().length === 0) {
              Text('审核通过后将在这里公开展示')
                .fontSize(16)
                .fontColor('#999999')
                .margin({ bottom: 8 })
            } else {
              ForEach(this.getApprovedUploads(), (item: UserUpload) => {
                Column() {
                  Text(item.relicName)
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .margin({ bottom: 6 })

                  Text('拍摄地点：' + item.location)
                    .fontSize(15)
                    .fontColor('#666666')
                    .margin({ bottom: 6 })

                  Text(item.desc)
                    .fontSize(15)
                    .lineHeight(22)
                }
                .width('100%')
                .padding(12)
                .margin({ bottom: 10 })
                .backgroundColor('#EEF5FF')
                .borderRadius(12)
              }, (item: UserUpload) => item.id.toString() + item.status + this.auditVersion.toString())
            }
          }
          .width('90%')
          .padding(18)
          .backgroundColor(Color.White)
          .borderRadius(16)
          .margin({ bottom: 16 })

          Button('重置密码')
            .width('90%')
            .height(46)
            .margin({ bottom: 30 })

          Button('退出登录')
            .width('90%')
            .height(46)
            .backgroundColor('#FF4D4F')
            .fontColor(Color.White)
            .margin({ bottom: 30 })
            .onClick(() => {
              this.logout()
            })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F6FA')
  }

  @Builder
  LoginPage() {
    Column() {
      Text('掌上博物馆')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 50, bottom: 10 })

      Text('用户登录 / 注册')
        .fontSize(18)
        .fontColor('#666666')
        .margin({ bottom: 30 })

      Row() {
        Button('登录')
          .layoutWeight(1)
          .height(42)
          .margin({ right: 8 })
          .backgroundColor(this.loginMode === '登录' ? '#1677FF' : '#FFFFFF')
          .fontColor(this.loginMode === '登录' ? Color.White : '#333333')
          .onClick(() => {
            this.loginMode = '登录'
          })

        Button('注册')
          .layoutWeight(1)
          .height(42)
          .margin({ left: 8 })
          .backgroundColor(this.loginMode === '注册' ? '#1677FF' : '#FFFFFF')
          .fontColor(this.loginMode === '注册' ? Color.White : '#333333')
          .onClick(() => {
            this.loginMode = '注册'
          })
      }
      .width('85%')
      .margin({ bottom: 24 })

      Column() {
        Text(this.loginMode === '登录' ? '账号登录' : '新用户注册')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 18 })

        TextInput({
          placeholder: '普通用户输入手机号，审核员输入 admin',
          text: this.loginAccount
        })
          .width('100%')
          .height(46)
          .backgroundColor('#F5F6FA')
          .borderRadius(12)
          .padding({ left: 12, right: 12 })
          .margin({ bottom: 14 })
          .onChange((value: string) => {
            this.loginAccount = value
          })

        TextInput({
          placeholder: '请输入密码',
          text: this.loginPassword
        })
          .type(InputType.Password)
          .width('100%')
          .height(46)
          .backgroundColor('#F5F6FA')
          .borderRadius(12)
          .padding({ left: 12, right: 12 })
          .margin({ bottom: 18 })
          .onChange((value: string) => {
            this.loginPassword = value
          })

        Button(this.loginMode)
          .width('100%')
          .height(46)
          .onClick(() => {
            this.handleLoginOrRegister()
          })

        Text(this.loginMode === '登录'
          ? '普通用户：任意手机号；审核员：admin / audit'
          : '注册后将自动进入个人主页')
          .fontSize(14)
          .fontColor('#999999')
          .margin({ top: 14 })
      }
      .width('85%')
      .padding(20)
      .backgroundColor(Color.White)
      .borderRadius(18)
      .shadow({ radius: 8, color: '#22000000', offsetX: 0, offsetY: 2 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F6FA')
  }

  @Builder
  MinePage() {
    if (this.isLoggedIn) {
      this.UserCenterPage()
    } else {
      this.LoginPage()
    }
  }

  build() {
    Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
      TabContent() {
        this.RelicBrowsePage()
      }
      .tabBar('文物')

      TabContent() {
        this.FavoritePage()
      }
      .tabBar('收藏')

      TabContent() {
        this.HistoryPage()
      }
      .tabBar('记录')

      TabContent() {
        this.SearchPage()
      }
      .tabBar('搜索')

      TabContent() {
        this.MinePage()
      }
      .tabBar('我的')
    }
    .onChange((index: number) => {
      this.currentIndex = index
    })
    .width('100%')
    .height('100%')
  }
}
