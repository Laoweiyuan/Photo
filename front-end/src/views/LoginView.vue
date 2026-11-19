<script setup lang="ts">
import { ref } from 'vue'
import {
  NButton,
  NConfigProvider,
  NFlex,
  NForm,
  NFormItem,
  NInput,
  useMessage,
  type FormInst,
  type FormRules,
  type GlobalThemeOverrides,
} from 'naive-ui'

interface LoginModel {
  account: string
  password: string
}

const emit = defineEmits<{
  (e: 'success', payload: LoginModel): void
}>()

const message = useMessage()

const formRef = ref<FormInst | null>(null)
const loading = ref(false)

const model = ref<LoginModel>({
  account: '',
  password: '',
})

/** 仅账号做必填校验，密码不做任何校验与提示 */
const rules: FormRules = {
  account: {
    required: true,
    message: '账号不能为空',
    trigger: ['blur', 'input'],
  },
}

/**
 * 输入框定制。注意：naive-ui 把这些变量以行内 style 写在 .n-input 上，
 * 用 CSS 变量覆盖无效，必须走 theme-overrides。
 */
const inputThemeOverrides: GlobalThemeOverrides = {
  Input: {
    heightLarge: '52px', // 加高，上下留白变大
    fontSizeLarge: '15px',
    color: '#eef0f4', // 灰底
    colorHover: '#e8ebf0',
    colorFocus: '#eef0f4', // 聚焦保持灰底
    colorFocusError: '#eef0f4', // 校验错误态聚焦也保持灰底
    border: '1px solid transparent',
    borderHover: '1px solid #d5d9e0',
    borderFocus: '1px solid #1677ff',
    placeholderColor: '#a3a9b2',
  },
}

async function handleLogin() {
  if (loading.value) return

  // 先校验，校验不通过则终止
  try {
    await formRef.value?.validate()
  } catch {
    return
  }

  const { account, password } = model.value
  console.log('登录账号：', account)
  console.log('登录密码：', password)

  loading.value = true
  window.setTimeout(() => {
    loading.value = false
    message.success('登录成功')
    emit('success', { account, password })
  }, 1000)
}

function handleAgreement(type: 'user' | 'privacy') {
  message.info(type === 'user' ? '查看用户协议' : '查看隐私政策')
}

function handleForgot() {
  message.info('忘记密码')
}

function handleRegister() {
  message.info('立即注册')
}
</script>

<template>
  <div class="login-page">
    <div class="login-panel">
      <div class="logo">Photo</div>

      <n-config-provider :theme-overrides="inputThemeOverrides">
        <n-form
          ref="formRef"
          :model="model"
          :rules="rules"
          :show-label="false"
          size="large"
          class="login-form"
          @keyup.enter="handleLogin"
        >
          <n-form-item path="account" class="account-item">
            <n-input
              v-model:value="model.account"
              placeholder="请输入账号"
              clearable
              round
            />
          </n-form-item>

          <n-form-item path="password" :show-feedback="false" class="password-item">
            <n-input
              v-model:value="model.password"
              type="password"
              placeholder="请输入密码"
              show-password-on="click"
              round
            />
          </n-form-item>
        </n-form>
      </n-config-provider>

      <p class="agreement">
        <span>注册登录即代表已阅读并同意我们的</span>
        <a class="agree-link" @click="handleAgreement('user')">用户协议</a>
        <span>与</span>
        <a class="agree-link" @click="handleAgreement('privacy')">隐私政策</a>
      </p>

      <n-flex justify="space-between" align="center" class="action-row">
        <n-button text @click="handleForgot">忘记密码</n-button>
        <n-button text type="primary" @click="handleRegister">立即注册</n-button>
      </n-flex>

      <n-button
        type="primary"
        size="large"
        block
        :loading="loading"
        @click="handleLogin"
	round
      >
        登 录
      </n-button>
    </div>
  </div>
</template>

<style scoped>
.login-page {
  /* 整页纯色背景，改这一处即可换色 */
  --login-bg: #fff;

  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  padding: 24px;
  background-color: var(--login-bg);
}

/* 无卡片浮层，表单直接铺在背景上 */
.login-panel {
  width: 400px;
  max-width: 100%;
}

.logo {
  margin-bottom: 26px;
  font-size: 32px;
  font-weight: 700;
  line-height: 1.2;
  letter-spacing: 1px;
  text-align: center;
  color: #1677ff;
}

/* 压制反馈区预留高度，校验文案才会紧贴输入框 */
.login-form :deep(.n-form-item) {
  margin-bottom: 0;
  --n-feedback-height: 0px;
  --n-feedback-padding: 5px 0 0;
  --n-feedback-font-size: 12px;
}

.account-item {
  margin-bottom: 10px;
}

.agreement {
  margin: 12px 0 18px;
  font-size: 12px;
  line-height: 1.7;
  text-align: left;
  color: #9aa0a6;
}

.agree-link {
  margin: 0 2px;
  color: #1677ff;
  cursor: pointer;
  text-decoration: none;
}

.agree-link:hover {
  text-decoration: underline;
}

.action-row {
  margin-bottom: 18px;
  font-size: 13px;
}
</style>
