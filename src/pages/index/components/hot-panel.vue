<script setup lang="ts">
import type { HotItem } from '@/types/home'

// 定义 props 接收数据
defineProps<{
  list: HotItem[]
}>()
</script>

<template>
  <!-- 推荐专区 -->
  <view class="section-title">热门推荐</view>
  <view class="hot">
    <navigator
      class="item"
      v-for="item in list"
      :key="item.id"
      :url="`/pages/hot/hot?type=${item.type}`"
    >
      <view class="title">
        <text class="title-text">{{ item.title }}</text>
        <text class="arrow" aria-hidden="true">›</text>
      </view>
      <text class="title-desc">{{ item.alt }}</text>
      <view class="cards">
        <image
          v-for="src in item.pictures"
          :key="src"
          class="image"
          mode="aspectFit"
          :src="src"
        ></image>
      </view>
    </navigator>
  </view>
</template>

<style lang="scss">
@import '../styles/hot.scss';
</style>
