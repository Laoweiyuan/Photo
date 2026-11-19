<script setup lang="ts">
import { computed, h, ref, type Component } from 'vue'
import {
  NAvatar,
  NCard,
  NDivider,
  NDropdown,
  NIcon,
  NLayout,
  NLayoutSider,
  NMenu,
  useMessage,
  type DropdownOption,
  type MenuOption,
} from 'naive-ui'
import {
  AlbumsOutline,
  CameraOutline,
  ChevronDownOutline,
  CopyOutline,
  ImagesOutline,
  LogOutOutline,
  PersonOutline,
  SettingsOutline,
  TimeOutline,
} from '@vicons/ionicons5'

const message = useMessage()

const emit = defineEmits<{
  (e: 'logout'): void
}>()

/** 侧边栏折叠状态 */
const collapsed = ref(false)
/** 当前选中菜单，无路由，仅维护选中态 */
const activeKey = ref<string>('library')

const renderIcon = (icon: Component) => () => h(NIcon, null, { default: () => h(icon) })

const menuOptions: MenuOption[] = [
  { label: '照片库', key: 'library', icon: renderIcon(ImagesOutline) },
  { label: '重复检测', key: 'duplicate', icon: renderIcon(CopyOutline) },
  { label: '分组整理', key: 'group', icon: renderIcon(AlbumsOutline) },
  { label: '操作记录', key: 'history', icon: renderIcon(TimeOutline) },
  { label: '设置', key: 'settings', icon: renderIcon(SettingsOutline) },
]

const activeLabel = computed<string>(() => {
  const current = menuOptions.find((item) => item.key === activeKey.value)
  return typeof current?.label === 'string' ? current.label : '照片库'
})

const userMenuOptions: DropdownOption[] = [
  { label: '个人资料', key: 'profile', icon: renderIcon(PersonOutline) },
  { label: '设置', key: 'settings', icon: renderIcon(SettingsOutline) },
  { label: '退出登录', key: 'logout', icon: renderIcon(LogOutOutline) },
]

/** 展开时向上弹出，折叠时右侧弹出 */
const dropdownPlacement = computed(() => (collapsed.value ? 'right-start' : 'top-start'))

function handleUserSelect(key: string) {
  if (key === 'logout') {
    emit('logout')
    return
  }
  const label = userMenuOptions.find((item) => item.key === key)?.label
  message.info(`点击了「${label}」`)
}
</script>

<template>
  <n-layout has-sider class="app-shell">
    <n-layout-sider
      bordered
      collapse-mode="width"
      :width="240"
      :collapsed-width="64"
      :collapsed="collapsed"
      :native-scrollbar="false"
      show-trigger="arrow-circle"
      class="app-sider"
      :content-style="{ height: '100%', overflow: 'hidden', backgroundColor: '#ffffff' }"
      @collapse="collapsed = true"
      @expand="collapsed = false"
    >
      <div class="sider-inner">
        <!-- 系统标题 -->
        <div class="brand" :class="{ 'is-collapsed': collapsed }">
          <n-icon size="26" color="#1677ff"><CameraOutline /></n-icon>
          <span v-if="!collapsed" class="brand-title">Photo</span>
        </div>

        <!-- 菜单 -->
        <div class="sider-body">
          <n-menu
            v-model:value="activeKey"
            :options="menuOptions"
            :collapsed="collapsed"
            :collapsed-width="64"
            :collapsed-icon-size="22"
            :icon-size="20"
          />
        </div>

        <!-- 用户入口 -->
        <div class="sider-footer">
          <n-divider class="user-divider" />
          <n-dropdown
            trigger="click"
            :placement="dropdownPlacement"
            :options="userMenuOptions"
            @select="handleUserSelect"
          >
            <div class="user-entry" :class="{ 'is-collapsed': collapsed }" role="button" tabindex="0">
              <n-avatar round :size="34" src="/avatar.svg" />
              <template v-if="!collapsed">
                <span class="user-name">张三</span>
                <n-icon class="user-arrow" :size="16"><ChevronDownOutline /></n-icon>
              </template>
            </div>
          </n-dropdown>
        </div>
      </div>
    </n-layout-sider>

    <!-- 主内容区 -->
    <n-layout class="main-layout" content-style="padding: 24px; box-sizing: border-box;">
      <n-card :title="activeLabel" :bordered="false" class="content-card">
        <div class="placeholder">
          <p class="placeholder-title">内容占位</p>
          <p class="placeholder-desc">「{{ activeLabel }}」页面尚未接入，此处为占位卡片。</p>
        </div>
      </n-card>
    </n-layout>
  </n-layout>
</template>

<style scoped>
.app-shell {
  height: 100vh;
}

.app-sider {
  background-color: #ffffff;
}

.sider-inner {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background-color: #ffffff;
}

.brand {
  display: flex;
  align-items: center;
  gap: 10px;
  height: 64px;
  padding: 0 22px;
  flex-shrink: 0;
  overflow: hidden;
  white-space: nowrap;
}

.brand.is-collapsed {
  padding: 0;
  justify-content: center;
}

.brand-title {
  font-size: 19px;
  font-weight: 600;
  letter-spacing: 0.4px;
  color: #1f2225;
}

.sider-body {
  flex: 1 1 auto;
  min-height: 0;
  overflow-y: auto;
  overflow-x: hidden;
}

.sider-footer {
  flex-shrink: 0;
  padding: 0 8px 14px;
}

.user-divider {
  margin: 0 4px 10px;
}

.user-entry {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 7px 10px;
  border-radius: 6px;
  cursor: pointer;
  outline: none;
  transition: background-color 0.2s ease;
}

.user-entry:hover,
.user-entry:focus-visible {
  background-color: rgba(0, 0, 0, 0.05);
}

.user-entry.is-collapsed {
  justify-content: center;
  padding: 7px 0;
}

.user-name {
  font-size: 14px;
  font-weight: 500;
  color: #1f2225;
  white-space: nowrap;
}

.user-arrow {
  margin-left: auto;
  color: #9aa0a6;
}

.main-layout {
  background-color: #f7f8fa;
}

.content-card {
  border-radius: 6px;
}

.placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 6px;
  min-height: 320px;
  border: 1px dashed #dcdfe6;
  border-radius: 6px;
  color: #909399;
}

.placeholder-title {
  margin: 0;
  font-size: 14px;
  font-weight: 500;
  color: #606266;
}

.placeholder-desc {
  margin: 0;
  font-size: 13px;
}
</style>
