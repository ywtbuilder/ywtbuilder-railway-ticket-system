<script setup>
import { ref, onMounted } from 'vue'
import { fetchPassengerList, fetchAddPassenger, fetchEditPassenger, fetchDeletePassenger } from '@/api'
import Cookies from 'js-cookie'

const passengers = ref([])
const loading = ref(true)
const showModal = ref(false)
const editMode = ref(false)
const saving = ref(false)

const idTypes = [
  { value: 0, label: '身份证' },
  { value: 1, label: '护照' },
  { value: 2, label: '港澳通行证' },
]

const discountTypes = [
  { value: 0, label: '成人票' },
  { value: 1, label: '儿童票' },
  { value: 2, label: '学生票' },
  { value: 3, label: '残军票' },
]

const form = ref({
  id: null,
  realName: '',
  idType: 0,
  idCard: '',
  discountType: 0,
  phone: ''
})

const resetForm = () => {
  form.value = { id: null, realName: '', idType: 0, idCard: '', discountType: 0, phone: '' }
}

const loadPassengers = async () => {
  loading.value = true
  try {
    const username = Cookies.get('username')
    const res = await fetchPassengerList({ username })
    if (res.success) {
      passengers.value = res.data || []
    }
  } catch (e) {
    console.error('Failed to load passengers:', e)
  } finally {
    loading.value = false
  }
}

const openAdd = () => {
  resetForm()
  editMode.value = false
  showModal.value = true
}

const openEdit = (p) => {
  form.value = { ...p }
  editMode.value = true
  showModal.value = true
}

const handleSave = async () => {
  if (!form.value.realName) return
  saving.value = true
  try {
    if (editMode.value) {
      await fetchEditPassenger(form.value)
    } else {
      await fetchAddPassenger(form.value)
    }
    showModal.value = false
    resetForm()
    await loadPassengers()
  } catch (e) {
    console.error('Save failed:', e)
  } finally {
    saving.value = false
  }
}

const handleDelete = async (p) => {
  if (!confirm(`确认删除乘车人「${p.realName}」？`)) return
  try {
    await fetchDeletePassenger({ id: p.id })
    await loadPassengers()
  } catch (e) {
    console.error('Delete failed:', e)
  }
}

onMounted(loadPassengers)
</script>

<template>
  <div class="passengers-page container">
    <div class="page-header animate-fade-in-up">
      <div class="page-header-content">
        <div>
          <h1 class="page-title">乘车人管理</h1>
          <p class="page-subtitle">管理您的常用乘车人信息</p>
        </div>
        <button class="btn btn-primary" @click="openAdd" id="add-passenger-btn">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14"/><path d="M5 12h14"/></svg>
          添加乘车人
        </button>
      </div>
    </div>

    <!-- Loading -->
    <div v-if="loading" class="loading-state">
      <span class="spinner"></span>
    </div>

    <!-- Empty State -->
    <div v-else-if="passengers.length === 0" class="empty-state animate-fade-in-up">
      <div class="empty-icon">
        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
      </div>
      <h3>暂无乘车人</h3>
      <p>添加常用乘车人，购票更便捷</p>
    </div>

    <!-- Passenger Grid -->
    <div v-else class="passenger-grid">
      <div v-for="(p, index) in passengers" :key="p.id" class="passenger-card card card-hover animate-fade-in-up" :style="{ animationDelay: `${index * 60}ms` }">
        <div class="passenger-avatar">
          {{ (p.realName || '?')[0] }}
        </div>
        <div class="passenger-info">
          <h3 class="passenger-name">{{ p.realName }}</h3>
          <p class="passenger-detail">
            {{ idTypes.find(t => t.value === p.idType)?.label || '身份证' }} · {{ p.idCard ? p.idCard.replace(/^(.{4}).*(.{4})$/, '$1****$2') : '-' }}
          </p>
          <p class="passenger-detail" v-if="p.phone">
            {{ p.phone.replace(/^(.{3}).*(.{4})$/, '$1****$2') }}
          </p>
          <span class="badge badge-accent" style="margin-top: 8px">
            {{ discountTypes.find(d => d.value === p.discountType)?.label || '成人票' }}
          </span>
        </div>
        <div class="passenger-actions">
          <button class="btn btn-ghost" @click="openEdit(p)">编辑</button>
          <button class="btn btn-ghost" style="color: var(--c-danger)" @click="handleDelete(p)">删除</button>
        </div>
      </div>
    </div>

    <!-- Modal -->
    <Teleport to="body">
      <div v-if="showModal" class="modal-overlay" @click.self="showModal = false">
        <div class="modal animate-fade-in-up">
          <div class="modal-header">
            <h2 class="modal-title">{{ editMode ? '编辑乘车人' : '添加乘车人' }}</h2>
            <button class="modal-close" @click="showModal = false">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
            </button>
          </div>

          <form @submit.prevent="handleSave" class="modal-form">
            <div class="input-group">
              <label class="input-label">姓名 *</label>
              <input v-model="form.realName" type="text" class="input" placeholder="请输入真实姓名" />
            </div>
            <div class="form-row">
              <div class="input-group">
                <label class="input-label">证件类型</label>
                <select v-model="form.idType" class="select">
                  <option v-for="t in idTypes" :key="t.value" :value="t.value">{{ t.label }}</option>
                </select>
              </div>
              <div class="input-group">
                <label class="input-label">证件号码</label>
                <input v-model="form.idCard" type="text" class="input" placeholder="请输入证件号码" />
              </div>
            </div>
            <div class="form-row">
              <div class="input-group">
                <label class="input-label">票种</label>
                <select v-model="form.discountType" class="select">
                  <option v-for="d in discountTypes" :key="d.value" :value="d.value">{{ d.label }}</option>
                </select>
              </div>
              <div class="input-group">
                <label class="input-label">手机号</label>
                <input v-model="form.phone" type="text" class="input" placeholder="11位手机号" />
              </div>
            </div>
            <div class="modal-actions">
              <button type="button" class="btn btn-secondary" @click="showModal = false">取消</button>
              <button type="submit" class="btn btn-primary" :disabled="saving">
                {{ saving ? '保存中...' : '保存' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<style scoped>
.page-header { margin-bottom: var(--space-xl); }
.page-header-content { display: flex; justify-content: space-between; align-items: flex-start; }
.page-title { font-size: 28px; font-weight: 700; letter-spacing: -0.03em; margin-bottom: var(--space-xs); }
.page-subtitle { font-size: 14px; color: var(--c-text-secondary); }

.loading-state { display: flex; justify-content: center; padding: var(--space-3xl) 0; }
.empty-state { text-align: center; padding: var(--space-3xl) 0; }
.empty-icon {
  display: inline-flex; align-items: center; justify-content: center;
  width: 80px; height: 80px; border-radius: var(--radius-xl);
  background: var(--c-bg-warm); color: var(--c-text-muted); margin-bottom: var(--space-lg);
}
.empty-state h3 { font-size: 18px; font-weight: 600; margin-bottom: var(--space-xs); }
.empty-state p { font-size: 14px; color: var(--c-text-secondary); }

/* Passenger Grid */
.passenger-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
  gap: var(--space-md);
}

.passenger-card {
  display: flex;
  gap: var(--space-md);
  padding: var(--space-lg);
  position: relative;
}

.passenger-avatar {
  width: 48px; height: 48px; border-radius: var(--radius-lg);
  background: var(--c-accent-light); color: var(--c-accent);
  display: flex; align-items: center; justify-content: center;
  font-size: 18px; font-weight: 700; flex-shrink: 0;
}

.passenger-info { flex: 1; min-width: 0; }
.passenger-name { font-size: 16px; font-weight: 600; margin-bottom: 4px; }
.passenger-detail { font-size: 13px; color: var(--c-text-muted); margin-bottom: 2px; font-variant-numeric: tabular-nums; }

.passenger-actions {
  display: flex; flex-direction: column; gap: 4px; flex-shrink: 0;
}

/* Modal */
.modal-overlay {
  position: fixed; inset: 0; background: rgba(26, 24, 20, 0.5);
  backdrop-filter: blur(4px); display: flex; align-items: center;
  justify-content: center; z-index: 1000; padding: var(--space-lg);
}

.modal {
  background: var(--c-bg-card); border-radius: var(--radius-xl);
  padding: var(--space-xl); max-width: 520px; width: 100%;
  box-shadow: var(--shadow-float);
}

.modal-header {
  display: flex; justify-content: space-between; align-items: center;
  margin-bottom: var(--space-xl);
}
.modal-title { font-size: 20px; font-weight: 700; }
.modal-close {
  background: transparent; color: var(--c-text-muted);
  padding: 4px; border-radius: var(--radius-sm);
  transition: all var(--duration-fast);
}
.modal-close:hover { color: var(--c-text-primary); background: var(--c-bg-warm); }

.modal-form { display: flex; flex-direction: column; gap: var(--space-md); }
.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-md); }

.modal-actions {
  display: flex; justify-content: flex-end; gap: var(--space-sm);
  margin-top: var(--space-md); padding-top: var(--space-md); border-top: 1px solid var(--c-border);
}

@media (max-width: 768px) {
  .page-header-content { flex-direction: column; gap: var(--space-md); }
  .passenger-grid { grid-template-columns: 1fr; }
  .form-row { grid-template-columns: 1fr; }
}
</style>
