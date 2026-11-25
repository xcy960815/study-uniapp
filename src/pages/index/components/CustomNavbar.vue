<script setup lang="ts">
const { safeAreaInsets } = uni.getSystemInfoSync()
</script>

<template>
  <view class="masthead" :style="{ paddingTop: (safeAreaInsets?.top || 0) + 'px' }">
    <view class="masthead-inner">
      <view class="brand">
        <image class="wordmark" mode="aspectFit" src="@/static/images/logo.png" />
        <text class="tagline">新鲜 · 亲民 · 快捷</text>
      </view>
      <!-- #ifndef MP-WEIXIN -->
      <navigator class="cart-link" open-type="switchTab" url="/pages/cart/cart">
        <uni-icons type="cart" size="19" color="#fff" />
        <text>购物车</text>
      </navigator>
      <!-- #endif -->
    </view>
  </view>
</template>

<style lang="scss">
.masthead {
  background: #194b40;
  color: #fff;
}
.masthead-inner {
  box-sizing: border-box;
  max-width: 1216px;
  margin: 0 auto;
  height: 58px;
  padding: 0 16px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.brand,
.cart-link {
  display: flex;
  align-items: center;
}
.wordmark {
  width: 85px;
  height: 25px;
}
.tagline {
  margin-left: 12px;
  padding-left: 12px;
  border-left: 1px solid #77998d;
  color: #e3efe9;
  font-size: 12px;
}
.cart-link {
  min-height: 44px;
  font-size: 13px;
  text {
    margin-left: 6px;
  }
}
/* #ifdef H5 */
@media (min-width: 768px) {
  .masthead-inner {
    height: 72px;
    padding: 0 24px;
  }
  .wordmark {
    width: 100px;
    height: 30px;
  }
}
/* #endif */
</style>
