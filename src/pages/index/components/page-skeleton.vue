<template>
  <view class="skeleton" aria-label="首页加载中">
    <view class="lead">
      <view class="banner"></view>
      <view class="categories"></view>
    </view>
    <view class="heading"></view>
    <view class="cards">
      <view v-for="n in 4" :key="n" class="card"></view>
    </view>
  </view>
</template>

<style lang="scss">
.lead,
.cards {
  display: grid;
  gap: 12px;
}
.banner,
.categories,
.heading,
.card {
  border-radius: 14px;
  background: #e6eae3;
}
.banner {
  aspect-ratio: 750 / 280;
}
.categories {
  min-height: 160px;
}
.heading {
  width: 5em;
  height: 20px;
  margin: 24px 0 12px;
}
.cards {
  grid-template-columns: repeat(2, minmax(0, 1fr));
}
.card {
  aspect-ratio: 1.3;
}
/* #ifdef H5 */
@media (min-width: 768px) {
  .cards {
    grid-template-columns: repeat(4, minmax(0, 1fr));
  }
}
@media (min-width: 960px) {
  .lead {
    grid-template-columns: minmax(0, 1.8fr) minmax(0, 1fr);
    gap: 18px;
  }
}
/* #endif */
</style>
