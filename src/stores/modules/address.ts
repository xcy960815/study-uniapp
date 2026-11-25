import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useAddressStore = defineStore('address', () => {
  const selectedAddressId = ref<string>()
  return { selectedAddressId }
})
