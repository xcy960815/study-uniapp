<script setup lang="ts">
import { getHomeBannerAPI, getHomeCategoryAPI, getHomeHotAPI } from '@/services/home'
import type { BannerItem, CategoryItem, HotItem } from '@/types/home'
import { onLoad } from '@dcloudio/uni-app'
import { ref } from 'vue'
import CustomNavbar from './components/CustomNavbar.vue'
import CategoryPanel from './components/CategoryPanel.vue'
import HotPanel from './components/HotPanel.vue'
import PageSkeleton from './components/PageSkeleton.vue'
import { useGuessList } from '@/composables'

// 获取轮播图数据
const bannerList = ref<BannerItem[]>([])
const getHomeBannerData = async () => {
  const res = await getHomeBannerAPI()
  bannerList.value = res.result
}

// 获取前台分类数据
const categoryList = ref<CategoryItem[]>([])
const getHomeCategoryData = async () => {
  const res = await getHomeCategoryAPI()
  categoryList.value = res.result
}

// 获取热门推荐数据
const hotList = ref<HotItem[]>([])
const getHomeHotData = async () => {
  const res = await getHomeHotAPI()
  hotList.value = res.result
}

// 是否加载中标记
const isLoading = ref(false)

// 页面加载
onLoad(async () => {
  isLoading.value = true
  await Promise.allSettled([getHomeBannerData(), getHomeCategoryData(), getHomeHotData()])
  isLoading.value = false
})

// 猜你喜欢组合式函数调用
const { guessRef, onScrolltolower } = useGuessList()
// 当前下拉刷新状态
const isTriggered = ref(false)
// 自定义下拉刷新被触发
const onRefresherrefresh = async () => {
  if (isTriggered.value || isLoading.value) return
  // 开始动画
  isTriggered.value = true
  // 加载数据
  // 重置猜你喜欢组件数据
  guessRef.value?.resetData()
  await Promise.allSettled([
    getHomeBannerData(),
    getHomeCategoryData(),
    getHomeHotData(),
    guessRef.value?.getMore(),
  ])
  // 关闭动画
  isTriggered.value = false
}
</script>

<template>
  <view class="home-viewport">
    <!-- 自定义导航栏 -->
    <CustomNavbar />
    <!-- 滚动容器 -->
    <scroll-view
      enable-back-to-top
      refresher-enabled
      @refresherrefresh="onRefresherrefresh"
      :refresher-triggered="isTriggered"
      @scrolltolower="onScrolltolower"
      class="scroll-view"
      scroll-y
    >
      <view class="home-content">
        <PageSkeleton v-if="isLoading" />
        <template v-else>
          <view class="home-lead" :class="{ paired: bannerList.length && categoryList.length }">
            <view v-if="bannerList.length" class="home-banner">
              <XtxSwiper :list="bannerList" />
            </view>
            <CategoryPanel v-if="categoryList.length" :list="categoryList" />
          </view>
          <HotPanel v-if="hotList.length" :list="hotList" />
          <XtxGuess ref="guessRef" storefront />
        </template>
      </view>
    </scroll-view>
  </view>
</template>

<style lang="scss">
page {
  height: 100%;
  overflow: hidden;
  background: #f6f6f0;
}
.home-viewport {
  display: flex;
  flex-direction: column;
  height: 100%;
  background: #f6f6f0;
}
.scroll-view {
  flex: 1;
  min-height: 0;
}
.home-content {
  width: 100%;
  max-width: 1216px;
  margin: auto;
  padding: 14px 14px 20px;
}
.home-lead {
  display: grid;
  gap: 12px;
  align-items: stretch;
}
.home-banner {
  min-width: 0;
  overflow: hidden;
  border-radius: 16px;
  background: #e6ebe3;
}
/* #ifdef H5 */
.home-banner :deep(.carousel) {
  height: auto;
  aspect-ratio: 750 / 280;
}
@media (min-width: 768px) {
  .home-content {
    padding: 24px;
  }
}
@media (min-width: 960px) {
  .home-lead.paired {
    grid-template-columns: minmax(0, 1.8fr) minmax(0, 1fr);
    gap: 18px;
  }
}
/* #endif */
</style>
