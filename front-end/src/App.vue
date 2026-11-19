<script setup lang="ts">
import { ref } from 'vue'
import { dateZhCN, lightTheme, NConfigProvider, NMessageProvider, zhCN } from 'naive-ui'
import type { GlobalThemeOverrides } from 'naive-ui'
import AdminLayout from '@/layouts/AdminLayout.vue'
import LoginView from '@/views/LoginView.vue'

/** 是否已登录：未接入路由，先做登录页与主框架的切换 */
const loggedIn = ref(false)

const themeOverrides: GlobalThemeOverrides = {
  common: {
    primaryColor: '#1677ff',
    primaryColorHover: '#4096ff',
    primaryColorPressed: '#0958d9',
    primaryColorSuppl: '#4096ff',
    borderRadius: '6px',
    borderRadiusSmall: '4px',
  },
  Menu: {
    itemHeight: '42px',
    borderRadius: '6px',
  },
  Layout: {
    color: '#f7f8fa',
    siderColor: '#ffffff',
  },
}
</script>

<template>
  <n-config-provider
    :theme="lightTheme"
    :theme-overrides="themeOverrides"
    :locale="zhCN"
    :date-locale="dateZhCN"
  >
    <n-message-provider>
      <login-view v-if="!loggedIn" @success="loggedIn = true" />
      <admin-layout v-else @logout="loggedIn = false" />
    </n-message-provider>
  </n-config-provider>
</template>
