<script setup>
import { ref, onMounted } from 'vue'
import { fetchMyTicket } from '@/api'
import Cookies from 'js-cookie'
import dayjs from 'dayjs'

const orders = ref([])
const loading = ref(true)
const currentPage = ref(1)
const total = ref(0)
const pageSize = 10

const statusLabels = {
  0: '待支付',
  10: '已支付',
  20: '已进站',
  30: '待退票',
  40: '已退票',
  50: '已改签',
  60: '已取消'
}

const statusColors = {
  0: 'badge-warning',
  10: 'badge-success',
  20: 'badge-success',
  30: 'badge-accent',
  40: 'badge-accent',
  50: 'badge-accent',
  60: 'badge-accent'
}

const loadOrders = async () => {
  loading.value = true
  try {
    const res = await fetchMyTicket({
      current: currentPage.value,
      size: pageSize
    })
    if (res.success) {
      orders.value = res.data?.records || []
      total.value = res.data?.total || 0
    }
  } catch (e) {
    console.error('Failed to load orders:', e)
  } finally {
    loading.value = false
  }
}

const formatDate = (date) => {
  if (!date) return '-'
  return dayjs(date).format('YYYY-MM-DD HH:mm')
}

const formatShortDate = (date) => {
  if (!date) return '-'
  return dayjs(date).format('MM-DD HH:mm')
}

onMounted(loadOrders)
</script>

<template>
  <div class="orders-page container">
    <div class="page-header animate-fade-in-up">
      <h1 class="page-title">我的订单</h1>
      <p class="page-subtitle">查看购票记录与订单状态</p>
    </div>

    <!-- Loading -->
    <div v-if="loading" class="loading-state">
      <span class="spinner"></span>
      <p>加载中...</p>
    </div>

    <!-- Empty State -->
    <div v-else-if="orders.length === 0" class="empty-state animate-fade-in-up">
      <div class="empty-icon">
        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8Z"/><path d="M14 2v6h6"/><path d="M12 18v-6"/><path d="m9 15 3 3 3-3"/></svg>
      </div>
      <h3>暂无订单</h3>
      <p>购买车票后，订单将会出现在这里</p>
      <router-link to="/search" class="btn btn-primary" style="margin-top: 16px">去查询车票</router-link>
    </div>

    <!-- Order List -->
    <div v-else class="order-list">
      <div v-for="(order, index) in orders" :key="order.id" class="order-card card animate-fade-in-up" :style="{ animationDelay: `${index * 60}ms` }">
        <div class="order-header">
          <div class="order-meta">
            <span class="order-sn">{{ order.orderSn }}</span>
            <span :class="['badge', statusColors[order.status] || 'badge-accent']">
              {{ statusLabels[order.status] || '未知' }}
            </span>
          </div>
          <span class="order-time">下单 {{ formatDate(order.orderTime || order.createTime) }}</span>
        </div>

        <div class="order-body">
          <div class="order-train">
            <span class="order-train-number">{{ order.trainNumber }}</span>
          </div>
          <div class="order-route">
            <div class="route-station">
              <span class="route-name">{{ order.departure }}</span>
              <span class="route-time">{{ formatShortDate(order.departureTime) }}</span>
            </div>
            <div class="route-arrow">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>
            </div>
            <div class="route-station">
              <span class="route-name">{{ order.arrival }}</span>
              <span class="route-time">{{ formatShortDate(order.arrivalTime) }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.page-header { margin-bottom: var(--space-xl); }
.page-title { font-size: 28px; font-weight: 700; letter-spacing: -0.03em; margin-bottom: var(--space-xs); }
.page-subtitle { font-size: 14px; color: var(--c-text-secondary); }

.loading-state {
  display: flex; flex-direction: column; align-items: center;
  gap: var(--space-md); padding: var(--space-3xl) 0; color: var(--c-text-muted);
}

.empty-state {
  text-align: center; padding: var(--space-3xl) 0;
}
.empty-icon {
  display: inline-flex; align-items: center; justify-content: center;
  width: 80px; height: 80px; border-radius: var(--radius-xl);
  background: var(--c-bg-warm); color: var(--c-text-muted); margin-bottom: var(--space-lg);
}
.empty-state h3 { font-size: 18px; font-weight: 600; margin-bottom: var(--space-xs); }
.empty-state p { font-size: 14px; color: var(--c-text-secondary); }

.order-list { display: flex; flex-direction: column; gap: var(--space-md); }

.order-card { border: 1px solid var(--c-border); border-radius: var(--radius-lg); padding: var(--space-lg); transition: all var(--duration-normal) var(--ease-out); }
.order-card:hover { border-color: var(--c-border-hover); box-shadow: var(--shadow-sm); }

.order-header {
  display: flex; justify-content: space-between; align-items: center;
  margin-bottom: var(--space-md); padding-bottom: var(--space-md); border-bottom: 1px solid var(--c-border);
}
.order-meta { display: flex; align-items: center; gap: var(--space-sm); }
.order-sn { font-size: 13px; font-family: var(--font-mono); color: var(--c-text-secondary); }
.order-time { font-size: 12px; color: var(--c-text-muted); }

.order-body { display: flex; align-items: center; gap: var(--space-xl); }
.order-train-number { font-size: 18px; font-weight: 700; color: var(--c-text-primary); }

.order-route { display: flex; align-items: center; gap: var(--space-lg); }
.route-station { display: flex; flex-direction: column; gap: 2px; }
.route-name { font-size: 15px; font-weight: 600; }
.route-time { font-size: 12px; color: var(--c-text-muted); font-variant-numeric: tabular-nums; }
.route-arrow { color: var(--c-text-muted); }

@media (max-width: 768px) {
  .order-header { flex-direction: column; align-items: flex-start; gap: var(--space-sm); }
  .order-body { flex-direction: column; align-items: flex-start; gap: var(--space-md); }
}
</style>
