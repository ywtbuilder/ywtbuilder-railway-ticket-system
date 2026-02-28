<script setup>
import { ref, onMounted } from 'vue'
import { fetchUserInfo, fetchUserUpdate } from '@/api'
import Cookies from 'js-cookie'

const user = ref(null)
const loading = ref(true)
const editing = ref(false)
const saving = ref(false)
const success = ref(false)

const form = ref({
  realName: '',
  phone: '',
  mail: '',
  address: '',
  idType: 0,
  idCard: ''
})

const idTypes = [
  { value: 0, label: '身份证' },
  { value: 1, label: '护照' },
  { value: 2, label: '港澳通行证' },
]

const loadUser = async () => {
  loading.value = true
  try {
    const username = Cookies.get('username')
    const res = await fetchUserInfo({ username })
    if (res.success) {
      user.value = res.data
      form.value = {
        realName: res.data.realName || '',
        phone: res.data.phone || '',
        mail: res.data.mail || '',
        address: res.data.address || '',
        idType: res.data.idType || 0,
        idCard: res.data.idCard || ''
      }
    }
  } catch (e) {
    console.error('Failed to load user:', e)
  } finally {
    loading.value = false
  }
}

const handleSave = async () => {
  saving.value = true
  try {
    const res = await fetchUserUpdate(form.value)
    if (res.success) {
      editing.value = false
      success.value = true
      setTimeout(() => success.value = false, 3000)
      await loadUser()
    }
  } catch (e) {
    console.error('Save failed:', e)
  } finally {
    saving.value = false
  }
}

const cancelEdit = () => {
  editing.value = false
  if (user.value) {
    form.value = {
      realName: user.value.realName || '',
      phone: user.value.phone || '',
      mail: user.value.mail || '',
      address: user.value.address || '',
      idType: user.value.idType || 0,
      idCard: user.value.idCard || ''
    }
  }
}

onMounted(loadUser)
</script>

<template>
  <div class="profile-page container">
    <div class="page-header animate-fade-in-up">
      <h1 class="page-title">个人信息</h1>
      <p class="page-subtitle">查看和编辑您的账户信息</p>
    </div>

    <!-- Toast -->
    <div v-if="success" class="toast toast-success">✓ 信息更新成功</div>

    <!-- Loading -->
    <div v-if="loading" class="loading-state">
      <span class="spinner"></span>
    </div>

    <div v-else class="profile-content animate-fade-in-up" style="animation-delay: 80ms">
      <!-- Profile Header Card -->
      <div class="profile-header-card card">
        <div class="profile-avatar">
          {{ (user?.realName || user?.username || '?')[0] }}
        </div>
        <div class="profile-header-info">
          <h2 class="profile-name">{{ user?.realName || user?.username }}</h2>
          <p class="profile-username">@{{ user?.username }}</p>
        </div>
        <button v-if="!editing" class="btn btn-secondary" @click="editing = true" id="edit-profile-btn">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"/><path d="M16.376 3.622a1 1 0 0 1 3.002 3.002L7.368 18.635a2 2 0 0 1-.855.506l-2.872.838a.5.5 0 0 1-.62-.62l.838-2.872a2 2 0 0 1 .506-.854z"/></svg>
          编辑
        </button>
      </div>

      <!-- Profile Details -->
      <div class="profile-form card">
        <h3 class="section-title">基本信息</h3>

        <div class="profile-grid">
          <div class="input-group">
            <label class="input-label">真实姓名</label>
            <input v-if="editing" v-model="form.realName" class="input" />
            <div v-else class="field-value">{{ user?.realName || '-' }}</div>
          </div>

          <div class="input-group">
            <label class="input-label">证件类型</label>
            <select v-if="editing" v-model="form.idType" class="select">
              <option v-for="t in idTypes" :key="t.value" :value="t.value">{{ t.label }}</option>
            </select>
            <div v-else class="field-value">{{ idTypes.find(t => t.value === user?.idType)?.label || '-' }}</div>
          </div>

          <div class="input-group">
            <label class="input-label">证件号码</label>
            <input v-if="editing" v-model="form.idCard" class="input" />
            <div v-else class="field-value">
              {{ user?.idCard ? user.idCard.replace(/^(.{4}).*(.{4})$/, '$1****$2') : '-' }}
            </div>
          </div>

          <div class="input-group">
            <label class="input-label">手机号</label>
            <input v-if="editing" v-model="form.phone" class="input" />
            <div v-else class="field-value">
              {{ user?.phone ? user.phone.replace(/^(.{3}).*(.{4})$/, '$1****$2') : '-' }}
            </div>
          </div>

          <div class="input-group">
            <label class="input-label">邮箱</label>
            <input v-if="editing" v-model="form.mail" class="input" type="email" />
            <div v-else class="field-value">{{ user?.mail || '-' }}</div>
          </div>

          <div class="input-group">
            <label class="input-label">地址</label>
            <input v-if="editing" v-model="form.address" class="input" />
            <div v-else class="field-value">{{ user?.address || '-' }}</div>
          </div>
        </div>

        <div v-if="editing" class="form-actions">
          <button class="btn btn-secondary" @click="cancelEdit">取消</button>
          <button class="btn btn-primary" @click="handleSave" :disabled="saving">
            {{ saving ? '保存中...' : '保存修改' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.page-header { margin-bottom: var(--space-xl); }
.page-title { font-size: 28px; font-weight: 700; letter-spacing: -0.03em; margin-bottom: var(--space-xs); }
.page-subtitle { font-size: 14px; color: var(--c-text-secondary); }

.loading-state { display: flex; justify-content: center; padding: var(--space-3xl) 0; }

.profile-content {
  max-width: 700px;
  display: flex;
  flex-direction: column;
  gap: var(--space-lg);
}

/* Header Card */
.profile-header-card {
  display: flex;
  align-items: center;
  gap: var(--space-lg);
  padding: var(--space-xl);
}

.profile-avatar {
  width: 64px; height: 64px; border-radius: var(--radius-xl);
  background: linear-gradient(135deg, var(--c-accent), var(--c-accent-hover));
  color: white; display: flex; align-items: center; justify-content: center;
  font-size: 24px; font-weight: 700; flex-shrink: 0;
}

.profile-header-info { flex: 1; }
.profile-name { font-size: 20px; font-weight: 700; margin-bottom: 2px; }
.profile-username { font-size: 14px; color: var(--c-text-muted); }

/* Form Card */
.profile-form { padding: var(--space-xl); }

.section-title {
  font-size: 16px; font-weight: 600; margin-bottom: var(--space-lg);
  padding-bottom: var(--space-md); border-bottom: 1px solid var(--c-border);
}

.profile-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-lg) var(--space-xl);
}

.field-value {
  padding: 10px 0;
  font-size: 15px;
  color: var(--c-text-primary);
  font-weight: 500;
}

.form-actions {
  display: flex; justify-content: flex-end; gap: var(--space-sm);
  margin-top: var(--space-xl); padding-top: var(--space-lg); border-top: 1px solid var(--c-border);
}

@media (max-width: 768px) {
  .profile-grid { grid-template-columns: 1fr; }
  .profile-header-card { flex-direction: column; text-align: center; }
}
</style>
