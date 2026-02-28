<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { fetchLogin } from '@/api'
import Cookies from 'js-cookie'

const router = useRouter()
const form = ref({ username: '', password: '' })
const loading = ref(false)
const error = ref('')

const handleLogin = async () => {
  if (!form.value.username || !form.value.password) {
    error.value = '请输入用户名和密码'
    return
  }
  loading.value = true
  error.value = ''
  try {
    const res = await fetchLogin(form.value)
    if (res.success) {
      Cookies.set('username', res.data.username, { expires: 1 })
      Cookies.set('token', res.data.accessToken, { expires: 1 })
      Cookies.set('userId', res.data.userId, { expires: 1 })
      router.push('/search')
    } else {
      error.value = res.message || '登录失败'
    }
  } catch (e) {
    error.value = '网络错误，请稍后重试'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="auth-page">
    <div class="container">
      <div class="auth-layout">
        <!-- Left: Decorative -->
        <div class="auth-visual animate-fade-in-up">
          <div class="visual-card">
            <div class="visual-icon">
              <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/>
                <line x1="4" x2="4" y1="22" y2="15"/>
              </svg>
            </div>
            <h2 class="visual-title">铁路12306</h2>
            <p class="visual-text">精简版 V2 · 一键部署<br/>零中间件依赖 · 现代化架构</p>
            <div class="visual-stats">
              <div class="stat">
                <span class="stat-value">7</span>
                <span class="stat-label">列车车次</span>
              </div>
              <div class="stat">
                <span class="stat-value">11</span>
                <span class="stat-label">覆盖车站</span>
              </div>
              <div class="stat">
                <span class="stat-value">0</span>
                <span class="stat-label">中间件依赖</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Right: Form -->
        <div class="auth-form-wrapper animate-fade-in-up" style="animation-delay: 80ms">
          <div class="auth-form-card">
            <div class="auth-header">
              <h1 class="auth-title">欢迎回来</h1>
              <p class="auth-subtitle">登录您的账号以继续</p>
            </div>

            <div v-if="error" class="auth-error">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" x2="12" y1="8" y2="12"/><line x1="12" x2="12.01" y1="16" y2="16"/></svg>
              {{ error }}
            </div>

            <form @submit.prevent="handleLogin" class="auth-form">
              <div class="input-group">
                <label class="input-label" for="login-username">用户名</label>
                <input
                  id="login-username"
                  v-model="form.username"
                  type="text"
                  class="input"
                  placeholder="请输入用户名"
                  autocomplete="username"
                />
              </div>

              <div class="input-group">
                <label class="input-label" for="login-password">密码</label>
                <input
                  id="login-password"
                  v-model="form.password"
                  type="password"
                  class="input"
                  placeholder="请输入密码"
                  autocomplete="current-password"
                />
              </div>

              <button type="submit" class="btn btn-primary btn-lg auth-submit" :disabled="loading" id="login-submit-btn">
                <span v-if="!loading">登 录</span>
                <span v-else class="search-loading">
                  <span class="spinner" style="width:18px;height:18px;border-width:2px"></span>
                  登录中...
                </span>
              </button>
            </form>

            <div class="auth-footer">
              <span>还没有账号？</span>
              <router-link to="/register">立即注册</router-link>
            </div>

            <div class="auth-demo">
              <p>演示账号：<code>admin</code> / <code>admin123</code></p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.auth-page {
  min-height: calc(100vh - 180px);
  display: flex;
  align-items: center;
}

.auth-layout {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-2xl);
  align-items: center;
  max-width: 1000px;
  margin: 0 auto;
}

/* Visual Side */
.visual-card {
  background: var(--c-bg-dark);
  border-radius: var(--radius-xl);
  padding: var(--space-2xl) var(--space-xl);
  text-align: center;
  color: var(--c-text-inverse);
}

.visual-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 80px;
  height: 80px;
  border-radius: var(--radius-xl);
  background: rgba(196, 93, 53, 0.15);
  color: var(--c-accent);
  margin-bottom: var(--space-lg);
}

.visual-title {
  font-size: 28px;
  font-weight: 700;
  letter-spacing: -0.03em;
  margin-bottom: var(--space-sm);
}

.visual-text {
  font-size: 14px;
  color: rgba(250, 248, 245, 0.5);
  line-height: 1.8;
  margin-bottom: var(--space-xl);
}

.visual-stats {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: var(--space-md);
  border-top: 1px solid rgba(255,255,255,0.08);
  padding-top: var(--space-lg);
}

.stat {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: var(--c-accent);
  font-variant-numeric: tabular-nums;
}

.stat-label {
  font-size: 12px;
  color: rgba(250, 248, 245, 0.4);
}

/* Form Side */
.auth-form-card {
  background: var(--c-bg-card);
  border: 1px solid var(--c-border);
  border-radius: var(--radius-xl);
  padding: var(--space-2xl);
  box-shadow: var(--shadow-lg);
}

.auth-header {
  margin-bottom: var(--space-xl);
}

.auth-title {
  font-size: 24px;
  font-weight: 700;
  letter-spacing: -0.02em;
  margin-bottom: var(--space-xs);
}

.auth-subtitle {
  font-size: 14px;
  color: var(--c-text-secondary);
}

.auth-error {
  display: flex;
  align-items: center;
  gap: var(--space-sm);
  padding: 10px 14px;
  background: #fef2f2;
  border: 1px solid #fecaca;
  border-radius: var(--radius-md);
  color: var(--c-danger);
  font-size: 13px;
  margin-bottom: var(--space-md);
  animation: slideDown var(--duration-normal) var(--ease-out);
}

.auth-form {
  display: flex;
  flex-direction: column;
  gap: var(--space-md);
}

.auth-submit {
  width: 100%;
  margin-top: var(--space-sm);
}

.auth-footer {
  text-align: center;
  margin-top: var(--space-lg);
  font-size: 14px;
  color: var(--c-text-secondary);
}

.auth-footer a {
  font-weight: 500;
  margin-left: var(--space-xs);
}

.auth-demo {
  text-align: center;
  margin-top: var(--space-md);
  padding-top: var(--space-md);
  border-top: 1px solid var(--c-border);
}

.auth-demo p {
  font-size: 12px;
  color: var(--c-text-muted);
}

.auth-demo code {
  background: var(--c-bg-warm);
  padding: 2px 6px;
  border-radius: var(--radius-sm);
  font-size: 12px;
  font-family: var(--font-mono);
  color: var(--c-accent);
}

@media (max-width: 768px) {
  .auth-layout {
    grid-template-columns: 1fr;
    gap: var(--space-lg);
  }
  .auth-visual {
    display: none;
  }
}
</style>
