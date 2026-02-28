<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { fetchRegister } from '@/api'

const router = useRouter()
const loading = ref(false)
const error = ref('')
const success = ref(false)

const form = ref({
  username: '',
  password: '',
  confirmPassword: '',
  realName: '',
  idType: 0,
  idCard: '',
  phone: '',
  mail: ''
})

const idTypes = [
  { value: 0, label: '身份证' },
  { value: 1, label: '护照' },
  { value: 2, label: '港澳通行证' },
]

const handleRegister = async () => {
  if (!form.value.username || !form.value.password) {
    error.value = '请填写用户名和密码'
    return
  }
  if (form.value.password !== form.value.confirmPassword) {
    error.value = '两次密码输入不一致'
    return
  }
  if (form.value.password.length < 6) {
    error.value = '密码长度不能少于6位'
    return
  }

  loading.value = true
  error.value = ''
  try {
    const { confirmPassword, ...body } = form.value
    const res = await fetchRegister(body)
    if (res.success) {
      success.value = true
      setTimeout(() => router.push('/login'), 2000)
    } else {
      error.value = res.message || '注册失败'
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
      <div class="register-wrapper animate-fade-in-up">
        <div class="auth-form-card">
          <div class="auth-header">
            <h1 class="auth-title">创建账号</h1>
            <p class="auth-subtitle">注册后即可查询并购买车票</p>
          </div>

          <!-- Success State -->
          <div v-if="success" class="register-success">
            <div class="success-icon">
              <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><path d="m9 11 3 3L22 4"/></svg>
            </div>
            <h3>注册成功!</h3>
            <p>正在跳转至登录页面...</p>
          </div>

          <!-- Form -->
          <template v-else>
            <div v-if="error" class="auth-error">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" x2="12" y1="8" y2="12"/><line x1="12" x2="12.01" y1="16" y2="16"/></svg>
              {{ error }}
            </div>

            <form @submit.prevent="handleRegister" class="auth-form">
              <div class="form-row">
                <div class="input-group">
                  <label class="input-label" for="reg-username">用户名 *</label>
                  <input id="reg-username" v-model="form.username" type="text" class="input" placeholder="请输入用户名" />
                </div>
                <div class="input-group">
                  <label class="input-label" for="reg-realname">真实姓名</label>
                  <input id="reg-realname" v-model="form.realName" type="text" class="input" placeholder="请输入真实姓名" />
                </div>
              </div>

              <div class="form-row">
                <div class="input-group">
                  <label class="input-label" for="reg-password">密码 *</label>
                  <input id="reg-password" v-model="form.password" type="password" class="input" placeholder="至少6位" />
                </div>
                <div class="input-group">
                  <label class="input-label" for="reg-confirm-password">确认密码 *</label>
                  <input id="reg-confirm-password" v-model="form.confirmPassword" type="password" class="input" placeholder="再次输入密码" />
                </div>
              </div>

              <div class="form-row">
                <div class="input-group">
                  <label class="input-label" for="reg-id-type">证件类型</label>
                  <select id="reg-id-type" v-model="form.idType" class="select">
                    <option v-for="t in idTypes" :key="t.value" :value="t.value">{{ t.label }}</option>
                  </select>
                </div>
                <div class="input-group">
                  <label class="input-label" for="reg-id-card">证件号码</label>
                  <input id="reg-id-card" v-model="form.idCard" type="text" class="input" placeholder="请输入证件号码" />
                </div>
              </div>

              <div class="form-row">
                <div class="input-group">
                  <label class="input-label" for="reg-phone">手机号</label>
                  <input id="reg-phone" v-model="form.phone" type="text" class="input" placeholder="11位手机号" />
                </div>
                <div class="input-group">
                  <label class="input-label" for="reg-mail">邮箱</label>
                  <input id="reg-mail" v-model="form.mail" type="email" class="input" placeholder="example@mail.com" />
                </div>
              </div>

              <button type="submit" class="btn btn-primary btn-lg auth-submit" :disabled="loading" id="register-submit-btn">
                <span v-if="!loading">注 册</span>
                <span v-else>注册中...</span>
              </button>
            </form>

            <div class="auth-footer">
              <span>已有账号？</span>
              <router-link to="/login">立即登录</router-link>
            </div>
          </template>
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
  padding: var(--space-xl) 0;
}

.register-wrapper {
  max-width: 600px;
  margin: 0 auto;
}

.auth-form-card {
  background: var(--c-bg-card);
  border: 1px solid var(--c-border);
  border-radius: var(--radius-xl);
  padding: var(--space-2xl);
  box-shadow: var(--shadow-lg);
}

.auth-header { margin-bottom: var(--space-xl); }
.auth-title { font-size: 24px; font-weight: 700; letter-spacing: -0.02em; margin-bottom: var(--space-xs); }
.auth-subtitle { font-size: 14px; color: var(--c-text-secondary); }

.auth-error {
  display: flex; align-items: center; gap: var(--space-sm);
  padding: 10px 14px; background: #fef2f2; border: 1px solid #fecaca;
  border-radius: var(--radius-md); color: var(--c-danger); font-size: 13px;
  margin-bottom: var(--space-md); animation: slideDown var(--duration-normal) var(--ease-out);
}

.auth-form { display: flex; flex-direction: column; gap: var(--space-md); }

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-md);
}

.auth-submit { width: 100%; margin-top: var(--space-sm); }

.auth-footer {
  text-align: center; margin-top: var(--space-lg);
  font-size: 14px; color: var(--c-text-secondary);
}
.auth-footer a { font-weight: 500; margin-left: var(--space-xs); }

.register-success {
  text-align: center; padding: var(--space-2xl) 0;
  animation: fadeInUp var(--duration-slow) var(--ease-out);
}
.success-icon {
  display: inline-flex; align-items: center; justify-content: center;
  width: 80px; height: 80px; border-radius: 50%;
  background: #d4edda; color: var(--c-success); margin-bottom: var(--space-lg);
}
.register-success h3 { font-size: 20px; font-weight: 700; margin-bottom: var(--space-sm); }
.register-success p { font-size: 14px; color: var(--c-text-secondary); }

@media (max-width: 768px) {
  .form-row { grid-template-columns: 1fr; }
}
</style>
