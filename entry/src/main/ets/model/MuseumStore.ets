import { common } from '@kit.AbilityKit'
import { preferences } from '@kit.ArkData'
import { FavoriteGroup, Relic, RelicComment, UserUpload } from './MuseumModels'

interface MuseumStorageState {
  username: string
  userRole: string
  account: string
  phone: string
  email: string
  privacyVisible: boolean
  isLoggedIn: boolean
  uploadCount: number
  uploadList: UserUpload[]
  historyIds: number[]
  likedIds: number[]
  collectedIds: number[]
  likedCommentIds: number[]
  selectedFavoriteGroup: string
  targetFavoriteGroup: string
  favoriteGroups: FavoriteGroup[]
  comments: RelicComment[]
  relicHotValues: number[]
  auditVersion: number
}

@Observed
export class MuseumStore {
  private dataPreferences: preferences.Preferences | null = null
  private readonly storageKey: string = 'museum_state'

  keyword: string = ''
  currentIndex: number = 0
  selectedRelicId: number = 0
  selectedType: string = '全部'
  sortMode: string = '默认'
  commentInput: string = ''
  replyInput: string = ''
  replyTargetId: number = 0
  isGuidePlaying: boolean = false
  guideSpeed: string = '1.0x'
  guideProgress: number = 0
  isVideoPlaying: boolean = false
  videoProgress: number = 0
  detailImageIndex: number = 0
  imageZoomed: boolean = false
  voiceQuestion: string = ''
  voiceAnswer: string = ''
  username: string = '博物馆访客'
  userRole: string = '普通用户'
  account: string = '未登录'
  phone: string = '13387115555'
  email: string = '1872138949@qq.com'
  privacyVisible: boolean = true
  isLoggedIn: boolean = false
  loginMode: string = '登录'
  loginAccount: string = ''
  loginPassword: string = ''
  uploadCount: number = 0
  uploadRelicName: string = ''
  uploadLocation: string = ''
  uploadDesc: string = ''
  uploadList: UserUpload[] = []
  imageSearchDone: boolean = false
  imageSearchMode: string = ''
  searchMode: string = '文本搜索'
  voiceSearchInput: string = ''
  voiceSearchKeyword: string = ''
  historyIds: number[] = []
  likedIds: number[] = []
  collectedIds: number[] = []
  likedCommentIds: number[] = []
  selectedFavoriteGroup: string = '全部收藏'
  targetFavoriteGroup: string = '默认分组'
  favoriteGroupInput: string = ''
  auditVersion: number = 0
  storageStatus: string = '本地存储未初始化'

  favoriteGroups: FavoriteGroup[] = [
    {
      id: 1,
      name: '默认分组',
      relicIds: []
    }
  ]

  comments: RelicComment[] = [
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
      content: '这个瓷器的款识和釉色很清楚，详情页图片放大后更容易观察纹饰。',
      status: '已通过',
      time: '5分钟前',
      parentId: 1,
      replyToUser: '博物馆讲解员',
      likeCount: 0
    }
  ]

  relics: Relic[] = [
    {
      id: 1,
      name: '青玉兽面纹饰',
      dynasty: '清代',
      type: '玉器',
      hot: 98,
      intro: '该文物以青玉琢制，轮廓厚重，局部保留兽面纹样。页面展示中把材质、纹饰和用途作为知识点，适合演示高清图、收藏和语音问答。',
      image: $r('app.media.yuqi'),
      liked: false,
      collected: false
    },
    {
      id: 2,
      name: '青花瓷洗',
      dynasty: '明代',
      type: '瓷器',
      hot: 92,
      intro: '青花瓷以白地蓝花为主要特征，纹样疏密有致。系统支持按名称、朝代、类型和简介全文检索，方便用户快速定位同类文物。',
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
      intro: '青铜鼎是商周时期重要礼器，器身纹饰体现了成熟的青铜铸造工艺。详情页中提供模拟音频、视频讲解和问答入口。',
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
      intro: '山水画重视笔墨层次与意境表达，画面强调山水空间和文人审美。应用中可通过以图搜图返回相似文物列表。',
      image: $r('app.media.shanshui'),
      liked: false,
      collected: false
    }
  ]

  initPersistence(context: common.UIAbilityContext) {
    if (this.dataPreferences !== null) {
      return
    }

    try {
      this.dataPreferences = preferences.getPreferencesSync(context, { name: 'mobile_museum_store' })
      let saved = this.dataPreferences.getSync(this.storageKey, '') as string

      if (saved !== '') {
        this.restoreLocalState(saved)
        this.storageStatus = '已从本地恢复数据'
      } else {
        this.storageStatus = '本地暂无历史数据'
      }
    } catch (error) {
      this.storageStatus = '本地存储初始化失败'
    }
  }

  createStorageState(): MuseumStorageState {
    return {
      username: this.username,
      userRole: this.userRole,
      account: this.account,
      phone: this.phone,
      email: this.email,
      privacyVisible: this.privacyVisible,
      isLoggedIn: this.isLoggedIn,
      uploadCount: this.uploadCount,
      uploadList: this.uploadList,
      historyIds: this.historyIds,
      likedIds: this.likedIds,
      collectedIds: this.collectedIds,
      likedCommentIds: this.likedCommentIds,
      selectedFavoriteGroup: this.selectedFavoriteGroup,
      targetFavoriteGroup: this.targetFavoriteGroup,
      favoriteGroups: this.favoriteGroups,
      comments: this.comments,
      relicHotValues: this.getRelicHotValues(),
      auditVersion: this.auditVersion
    }
  }

  restoreLocalState(saved: string) {
    try {
      let state = JSON.parse(saved) as MuseumStorageState
      this.username = state.username
      this.userRole = state.userRole
      this.account = state.account
      this.phone = state.phone
      this.email = state.email
      this.privacyVisible = state.privacyVisible
      this.isLoggedIn = state.isLoggedIn
      this.uploadCount = state.uploadCount
      this.uploadList = state.uploadList
      this.historyIds = state.historyIds
      this.likedIds = state.likedIds
      this.collectedIds = state.collectedIds
      this.likedCommentIds = state.likedCommentIds
      this.selectedFavoriteGroup = state.selectedFavoriteGroup
      this.targetFavoriteGroup = state.targetFavoriteGroup
      this.favoriteGroups = state.favoriteGroups
      this.comments = state.comments
      this.auditVersion = state.auditVersion
      this.restoreRelicHotValues(state.relicHotValues)
      this.syncRelicFlags()
    } catch (error) {
      this.storageStatus = '本地数据解析失败，已使用默认数据'
    }
  }

  persistLocalState() {
    if (this.dataPreferences === null) {
      this.storageStatus = '本地存储未初始化'
      return
    }

    try {
      this.dataPreferences.putSync(this.storageKey, JSON.stringify(this.createStorageState()))
      this.dataPreferences.flush()
      this.storageStatus = '本地数据已保存'
    } catch (error) {
      this.storageStatus = '本地数据保存失败'
    }
  }

  syncRelicFlags() {
    let newRelics: Relic[] = []

    for (let i = 0; i < this.relics.length; i++) {
      let item = this.relics[i]
      newRelics.push({
        id: item.id,
        name: item.name,
        dynasty: item.dynasty,
        type: item.type,
        hot: item.hot,
        intro: item.intro,
        image: item.image,
        liked: this.likedIds.includes(item.id),
        collected: this.collectedIds.includes(item.id)
      })
    }

    this.relics = newRelics
  }

  getRelicHotValues(): number[] {
    let values: number[] = []

    for (let i = 0; i < this.relics.length; i++) {
      values.push(this.relics[i].hot)
    }

    return values
  }

  restoreRelicHotValues(values: number[] | undefined) {
    if (values === undefined || values.length !== this.relics.length) {
      return
    }

    let newRelics: Relic[] = []

    for (let i = 0; i < this.relics.length; i++) {
      let item = this.relics[i]
      newRelics.push({
        id: item.id,
        name: item.name,
        dynasty: item.dynasty,
        type: item.type,
        hot: values[i],
        intro: item.intro,
        image: item.image,
        liked: item.liked,
        collected: item.collected
      })
    }

    this.relics = newRelics
  }

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
      list.sort((a: Relic, b: Relic) => b.hot - a.hot)
    }
    if (this.sortMode === '热度升序') {
      list.sort((a: Relic, b: Relic) => a.hot - b.hot)
    }
    if (this.sortMode === '年代从早到晚') {
      list.sort((a: Relic, b: Relic) => this.getDynastyOrder(a.dynasty) - this.getDynastyOrder(b.dynasty))
    }
    if (this.sortMode === '年代从晚到早') {
      list.sort((a: Relic, b: Relic) => this.getDynastyOrder(b.dynasty) - this.getDynastyOrder(a.dynasty))
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
    return this.comments.filter((item: RelicComment) => item.status === '待审核')
  }

  getPendingUploads(): UserUpload[] {
    return this.uploadList.filter((item: UserUpload) => item.status === '待审核')
  }

  getApprovedUploads(): UserUpload[] {
    return this.uploadList.filter((item: UserUpload) => item.status === '已通过')
  }

  getSelectedRelic(): Relic {
    for (let i = 0; i < this.relics.length; i++) {
      if (this.relics[i].id === this.selectedRelicId) {
        return this.relics[i]
      }
    }
    return this.relics[0]
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
    this.persistLocalState()
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
    this.persistLocalState()
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
    this.persistLocalState()
  }

  setFavoriteGroup(name: string) {
    this.selectedFavoriteGroup = name
    if (name !== '全部收藏' && name !== '点赞记录') {
      this.targetFavoriteGroup = name
    }
    this.auditVersion++
    this.persistLocalState()
  }

  createFavoriteGroup() {
    let name = this.favoriteGroupInput.trim()

    if (name === '') {
      name = '新收藏夹' + (this.favoriteGroups.length + 1).toString()
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
    this.auditVersion++
    this.persistLocalState()
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

  getFavoriteList(): Relic[] {
    return this.relics.filter((item: Relic) => {
      return this.likedIds.includes(item.id) || this.collectedIds.includes(item.id)
    })
  }

  getLikedList(): Relic[] {
    return this.relics.filter((item: Relic) => this.likedIds.includes(item.id))
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
    this.persistLocalState()
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
    this.persistLocalState()
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
    this.persistLocalState()
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

  getGuideStatusText(): string {
    if (this.isGuidePlaying) {
      return '正在播放文字讲解 · 当前倍速 ' + this.guideSpeed
    }
    if (this.guideProgress === 0) {
      return '尚未开始播放，可点击播放语音讲解查看同步字幕'
    }
    if (this.guideProgress === 100) {
      return '讲解已结束，可再次点击播放重新开始'
    }
    return '讲解已暂停 · 已播放 ' + this.getGuideProgressText()
  }

  getGuideSubtitle(): string {
    let relic = this.getSelectedRelic()

    if (this.guideProgress < 35) {
      return '现在为您介绍的是' + relic.name + '，它属于' + relic.type + '，年代为' + relic.dynasty + '。'
    }
    if (this.guideProgress < 70) {
      return '请重点观察它的材质、纹饰和造型细节，这些信息能够帮助我们理解当时的工艺水平。'
    }
    return '这件文物的展示价值不仅在于外观，也在于它背后的历史语境和文化审美。'
  }

  getGuideScript(): string {
    let relic = this.getSelectedRelic()
    return '欢迎来到掌上博物馆。' + relic.name + '是本次导览的重点文物之一。' +
      '它的分类是' + relic.type + '，年代为' + relic.dynasty + '，当前热度为' + relic.hot.toString() + '。' +
      relic.intro + '在参观时，建议先观察整体造型，再放大图片查看局部纹饰，最后结合文物介绍理解它的历史价值。'
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
    this.persistLocalState()
  }

  logout() {
    this.isLoggedIn = false
    this.userRole = '普通用户'
    this.username = '博物馆访客'
    this.account = '未登录'
    this.loginPassword = ''
    this.persistLocalState()
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
    this.persistLocalState()
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
    this.persistLocalState()
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
    this.persistLocalState()
  }
}
