import { common } from '@kit.AbilityKit'
import { MuseumStore } from '../model/MuseumStore'
import { FavoritePage } from './FavoritePage'
import { HistoryPage } from './HistoryPage'
import { MinePage } from './MinePage'
import { RelicBrowsePage } from './RelicBrowsePage'
import { SearchPage } from './SearchPage'

@Entry
@Component
struct Index {
  @State store: MuseumStore = new MuseumStore()

  aboutToAppear() {
    this.store.initPersistence(getContext(this) as common.UIAbilityContext)
  }

  build() {
    Tabs({ barPosition: BarPosition.End, index: this.store.currentIndex }) {
      TabContent() {
        RelicBrowsePage({ store: this.store })
      }
      .tabBar('文物')

      TabContent() {
        FavoritePage({ store: this.store })
      }
      .tabBar('收藏')

      TabContent() {
        HistoryPage({ store: this.store })
      }
      .tabBar('记录')

      TabContent() {
        SearchPage({ store: this.store })
      }
      .tabBar('搜索')

      TabContent() {
        MinePage({ store: this.store })
      }
      .tabBar('我的')
    }
    .onChange((index: number) => {
      this.store.currentIndex = index
    })
    .width('100%')
    .height('100%')
    .backgroundColor('#F6F8FA')
  }
}
