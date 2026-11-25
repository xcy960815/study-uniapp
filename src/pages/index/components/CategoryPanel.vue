<script setup lang="ts">
import type { CategoryItem } from '@/types/home'
import { useCategoryStore } from '@/stores/modules/category'

const categoryStore = useCategoryStore()
defineProps<{
  list: CategoryItem[]
}>()
</script>

<template>
  <view class="category-panel">
    <view class="category-heading">
      <text class="section-title">商品分类</text>
      <navigator open-type="switchTab" url="/pages/category/category" class="all-link"
        >全部分类 ›</navigator
      >
    </view>
    <view class="category">
      <navigator
        class="category-item"
        hover-class="none"
        open-type="switchTab"
        url="/pages/category/category"
        @tap="categoryStore.selectedId = item.id"
        v-for="item in list"
        :key="item.id"
      >
        <image class="icon" :src="item.icon"></image>
        <text class="text">{{ item.name }}</text>
      </navigator>
    </view>
  </view>
</template>

<style lang="scss">
@import '../styles/category.scss';
</style>
