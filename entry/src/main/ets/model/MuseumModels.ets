export interface Relic {
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

export interface RelicComment {
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

export interface UserUpload {
  id: number
  relicName: string
  location: string
  desc: string
  status: string
  time: string
}

export interface FavoriteGroup {
  id: number
  name: string
  relicIds: number[]
}
