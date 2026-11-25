<script setup lang="ts">
import type { BannerItem } from '@/types/home'
import { useCategoryStore } from '@/stores/modules/category'
import { ref } from 'vue'

const activeIndex = ref(0)
const categoryStore = useCategoryStore()
const openBanner = (banner: BannerItem) => {
  const categoryId = banner.hrefUrl?.match(/^\/category\/(\d+)$/)?.[1]
  if (categoryId) {
    categoryStore.selectedId = categoryId
    uni.switchTab({ url: '/pages/category/category' })
  }
}

// 当 swiper 下标发生变化时触发
const onChange: UniHelper.SwiperOnChange = (ev) => {
  activeIndex.value = ev.detail.current
}
// 定义 props 接收
defineProps<{
  list: BannerItem[]
}>()
</script>

<template>
  <view class="carousel">
    <swiper
      :current="activeIndex"
      :circular="list.length > 1"
      :autoplay="false"
      :interval="3000"
      @change="onChange"
    >
      <swiper-item v-for="item in list" :key="item.id">
        <view class="navigator" @tap="openBanner(item)">
          <image mode="aspectFill" class="image" :src="item.imgUrl"></image>
        </view>
      </swiper-item>
    </swiper>
    <!-- 指示点 -->
    <view v-if="list.length > 1" class="indicator">
      <text
        v-for="(item, index) in list"
        :key="item.id"
        class="dot"
        :class="{ active: index === activeIndex }"
        @tap="activeIndex = index"
      ></text>
    </view>
  </view>
</template>

<style lang="scss">
@import './styles/XtxSwiper.scss';
</style>
