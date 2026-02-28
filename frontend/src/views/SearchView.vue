<script setup>
import { ref, onMounted, computed } from 'vue'
import { fetchStationAll, fetchTicketSearch, fetchTrainStation } from '@/api'
import dayjs from 'dayjs'

const stations = ref([])
const fromStation = ref('')
const toStation = ref('')
const departureDate = ref(dayjs().format('YYYY-MM-DD'))
const loading = ref(false)
const hasSearched = ref(false)
const searchResult = ref(null)
const expandedTrain = ref(null)
const trainStops = ref([])
const loadingStops = ref(false)

// Seat type labels
const seatTypeLabels = {
  0: '商务座',
  1: '一等座',
  2: '二等座',
  3: '动卧',
  4: '高级软卧',
  5: '软卧',
  6: '硬卧',
  7: '软座',
  8: '硬座',
  9: '无座',
  13: '其他'
}

const trainTypeLabels = {
  0: '高铁',
  1: '动车',
  2: '普通'
}

const trainTypeColors = {
  0: '#c45d35',
  1: '#3d6f8b',
  2: '#6b6459'
}

// Format price (分 -> 元)
const formatPrice = (price) => {
  return (price / 100).toFixed(1)
}

onMounted(async () => {
  try {
    const res = await fetchStationAll()
    if (res.success) {
      stations.value = res.data
    }
  } catch (e) {
    console.error('Failed to load stations:', e)
  }
})

const swapStations = () => {
  const temp = fromStation.value
  fromStation.value = toStation.value
  toStation.value = temp
}

const handleSearch = async () => {
  if (!fromStation.value || !toStation.value) return
  loading.value = true
  hasSearched.value = true
  expandedTrain.value = null
  try {
    const res = await fetchTicketSearch({
      fromStation: fromStation.value,
      toStation: toStation.value,
      departureDate: departureDate.value
    })
    if (res.success) {
      searchResult.value = res.data
    }
  } catch (e) {
    console.error('Search failed:', e)
  } finally {
    loading.value = false
  }
}

const toggleTrainStops = async (trainId) => {
  if (expandedTrain.value === trainId) {
    expandedTrain.value = null
    return
  }
  expandedTrain.value = trainId
  loadingStops.value = true
  try {
    const res = await fetchTrainStation({ trainId })
    if (res.success) {
      trainStops.value = res.data
    }
  } catch (e) {
    console.error('Failed to load stops:', e)
  } finally {
    loadingStops.value = false
  }
}

const trainList = computed(() => searchResult.value?.trainList || [])
</script>

<template>
  <div class="search-page">
    <!-- Hero Section -->
    <section class="hero">
      <div class="container">
        <div class="hero-content animate-fade-in-up">
          <h1 class="hero-title">
            旅途，<br/>从这里出发
          </h1>
          <p class="hero-subtitle">查询车次、对比票价，轻松规划每一次出行</p>
        </div>

        <!-- Search Card -->
        <div class="search-card animate-fade-in-up" style="animation-delay: 100ms">
          <div class="search-form">
            <!-- From Station -->
            <div class="search-field">
              <label class="search-label">出发地</label>
              <select v-model="fromStation" class="search-select" id="from-station-select">
                <option value="" disabled>选择出发城市</option>
                <option v-for="s in stations" :key="s.code" :value="s.code">
                  {{ s.name }}
                </option>
              </select>
            </div>

            <!-- Swap Button -->
            <button class="swap-btn" @click="swapStations" title="交换出发到达" id="swap-stations-btn">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="m7 16-4-4 4-4"/>
                <path d="M3 12h18"/>
                <path d="m17 8 4 4-4 4"/>
              </svg>
            </button>

            <!-- To Station -->
            <div class="search-field">
              <label class="search-label">目的地</label>
              <select v-model="toStation" class="search-select" id="to-station-select">
                <option value="" disabled>选择到达城市</option>
                <option v-for="s in stations" :key="s.code" :value="s.code">
                  {{ s.name }}
                </option>
              </select>
            </div>

            <!-- Date -->
            <div class="search-field">
              <label class="search-label">出发日期</label>
              <input type="date" v-model="departureDate" class="search-input" id="departure-date-input" />
            </div>

            <!-- Search Button -->
            <button class="btn btn-primary btn-lg search-btn" @click="handleSearch" :disabled="loading" id="search-submit-btn">
              <span v-if="!loading">查询车票</span>
              <span v-else class="search-loading">
                <span class="spinner" style="width:18px;height:18px;border-width:2px"></span>
                查询中...
              </span>
            </button>
          </div>
        </div>
      </div>
    </section>

    <!-- Results Section -->
    <section class="results container" v-if="hasSearched">
      <div class="results-header animate-fade-in-up">
        <h2 class="results-title">
          <span v-if="trainList.length > 0">
            找到 <strong>{{ trainList.length }}</strong> 趟列车
          </span>
          <span v-else-if="!loading">暂无符合条件的列车</span>
        </h2>
      </div>

      <!-- Train Cards -->
      <div class="train-list">
        <div
          v-for="(train, index) in trainList"
          :key="train.trainId"
          class="train-card card animate-fade-in-up"
          :style="{ animationDelay: `${index * 60}ms` }"
        >
          <div class="train-card-main">
            <!-- Train Number & Type -->
            <div class="train-info">
              <div class="train-number-row">
                <span class="train-number">{{ train.trainNumber }}</span>
                <span class="train-type-badge" :style="{ background: trainTypeColors[train.trainType] }">
                  {{ trainTypeLabels[train.trainType] || '其他' }}
                </span>
              </div>
              <button class="stops-toggle" @click="toggleTrainStops(train.trainId)">
                {{ expandedTrain === train.trainId ? '收起经停' : '查看经停' }}
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" :style="{ transform: expandedTrain === train.trainId ? 'rotate(180deg)' : '' }">
                  <path d="m6 9 6 6 6-6"/>
                </svg>
              </button>
            </div>

            <!-- Time Info -->
            <div class="train-time">
              <div class="time-block">
                <span class="time-value">{{ train.departureTime }}</span>
                <span class="time-station">{{ train.departure }}</span>
              </div>

              <div class="duration-line">
                <div class="duration-track">
                  <div class="duration-dot start"></div>
                  <div class="duration-bar"></div>
                  <div class="duration-dot end"></div>
                </div>
                <span class="duration-text">{{ train.duration }}</span>
              </div>

              <div class="time-block">
                <span class="time-value">{{ train.arrivalTime }}</span>
                <span class="time-station">{{ train.arrival }}</span>
              </div>
            </div>

            <!-- Seat Classes -->
            <div class="train-seats">
              <div v-for="seat in train.seatClassList" :key="seat.type" class="seat-item">
                <span class="seat-name">{{ seatTypeLabels[seat.type] || '其他' }}</span>
                <span class="seat-price">¥{{ formatPrice(seat.price) }}</span>
                <span class="seat-count" :class="{ 'seat-low': seat.quantity < 20 }">
                  {{ seat.quantity > 0 ? seat.quantity + '张' : '无票' }}
                </span>
              </div>
            </div>
          </div>

          <!-- Expanded Stops -->
          <div class="train-stops" v-if="expandedTrain === train.trainId">
            <div v-if="loadingStops" class="stops-loading">
              <span class="spinner"></span>
            </div>
            <div v-else class="stops-timeline">
              <div v-for="(stop, i) in trainStops" :key="i" class="stop-item">
                <div class="stop-seq">{{ stop.sequence }}</div>
                <div class="stop-dot" :class="{ 'stop-dot-first': i === 0, 'stop-dot-last': i === trainStops.length - 1 }"></div>
                <div class="stop-connector" v-if="i < trainStops.length - 1"></div>
                <div class="stop-info">
                  <span class="stop-name">{{ stop.departure }}</span>
                  <span class="stop-time">到 {{ stop.arrivalTime }} · 发 {{ stop.departureTime }}</span>
                  <span class="stop-stay" v-if="stop.stopoverTime !== '-' && stop.stopoverTime !== '0分'">停{{ stop.stopoverTime }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Empty State when not searched -->
    <section class="empty-state container" v-if="!hasSearched">
      <div class="features animate-fade-in-up" style="animation-delay: 200ms">
        <div class="feature-card">
          <div class="feature-icon">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>
          </div>
          <h3>实时查询</h3>
          <p>查看最新车次时刻与余票信息</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M12 20h9"/><path d="M16.376 3.622a1 1 0 0 1 3.002 3.002L7.368 18.635a2 2 0 0 1-.855.506l-2.872.838a.5.5 0 0 1-.62-.62l.838-2.872a2 2 0 0 1 .506-.854z"/></svg>
          </div>
          <h3>便捷管理</h3>
          <p>轻松添加乘车人、管理订单</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
          </div>
          <h3>精简体验</h3>
          <p>V2 架构，极速响应，一键部署</p>
        </div>
      </div>
    </section>
  </div>
</template>

<style scoped>
/* -- Hero -- */
.hero {
  background: linear-gradient(135deg, var(--c-bg-warm) 0%, var(--c-bg) 100%);
  padding: var(--space-3xl) 0 var(--space-2xl);
  margin-top: -48px;
  padding-top: calc(var(--space-3xl) + 48px);
}

.hero-content {
  text-align: center;
  margin-bottom: var(--space-xl);
}

.hero-title {
  font-size: clamp(32px, 5vw, 48px);
  font-weight: 700;
  line-height: 1.15;
  letter-spacing: -0.035em;
  color: var(--c-text-primary);
  margin-bottom: var(--space-md);
}

.hero-subtitle {
  font-size: 16px;
  color: var(--c-text-secondary);
  font-weight: 400;
}

/* -- Search Card -- */
.search-card {
  background: var(--c-bg-card);
  border: 1px solid var(--c-border);
  border-radius: var(--radius-xl);
  padding: var(--space-lg) var(--space-xl);
  box-shadow: var(--shadow-xl);
  max-width: 900px;
  margin: 0 auto;
}

.search-form {
  display: flex;
  align-items: flex-end;
  gap: var(--space-md);
}

.search-field {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.search-label {
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: var(--c-text-muted);
}

.search-select,
.search-input {
  padding: 12px 16px;
  border: 1.5px solid var(--c-border);
  border-radius: var(--radius-md);
  font-size: 15px;
  font-weight: 500;
  color: var(--c-text-primary);
  background: var(--c-bg);
  transition: all var(--duration-fast) var(--ease-out);
  appearance: none;
}

.search-select {
  background: var(--c-bg) url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%236b6459' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='m6 9 6 6 6-6'/%3E%3C/svg%3E") no-repeat right 14px center;
  padding-right: 36px;
  cursor: pointer;
}

.search-select:focus,
.search-input:focus {
  border-color: var(--c-accent);
  box-shadow: 0 0 0 3px var(--c-accent-light);
  outline: none;
}

.swap-btn {
  flex-shrink: 0;
  width: 44px;
  height: 44px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: var(--radius-full);
  background: var(--c-bg-warm);
  color: var(--c-text-secondary);
  border: 1.5px solid var(--c-border);
  transition: all var(--duration-normal) var(--ease-out);
  margin-bottom: 1px;
}

.swap-btn:hover {
  background: var(--c-accent-light);
  color: var(--c-accent);
  border-color: var(--c-accent);
  transform: rotate(180deg);
}

.search-btn {
  flex-shrink: 0;
  min-width: 130px;
  height: 44px;
}

.search-loading {
  display: flex;
  align-items: center;
  gap: var(--space-sm);
}

/* -- Results -- */
.results {
  margin-top: var(--space-xl);
}

.results-header {
  margin-bottom: var(--space-lg);
}

.results-title {
  font-size: 18px;
  font-weight: 400;
  color: var(--c-text-secondary);
}

.results-title strong {
  color: var(--c-accent);
  font-weight: 700;
}

/* -- Train Card -- */
.train-list {
  display: flex;
  flex-direction: column;
  gap: var(--space-md);
}

.train-card {
  border: 1px solid var(--c-border);
  border-radius: var(--radius-lg);
  overflow: hidden;
  transition: all var(--duration-normal) var(--ease-out);
}

.train-card:hover {
  border-color: var(--c-border-hover);
  box-shadow: var(--shadow-md);
}

.train-card-main {
  display: grid;
  grid-template-columns: 140px 1fr auto;
  gap: var(--space-lg);
  padding: var(--space-lg) var(--space-xl);
  align-items: center;
}

/* Train Info Column */
.train-info {
  display: flex;
  flex-direction: column;
  gap: var(--space-sm);
}

.train-number-row {
  display: flex;
  align-items: center;
  gap: var(--space-sm);
}

.train-number {
  font-size: 20px;
  font-weight: 700;
  letter-spacing: -0.02em;
  color: var(--c-text-primary);
}

.train-type-badge {
  padding: 2px 8px;
  border-radius: var(--radius-full);
  font-size: 11px;
  font-weight: 600;
  color: white;
  letter-spacing: 0.02em;
}

.stops-toggle {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-size: 12px;
  color: var(--c-text-muted);
  background: transparent;
  padding: 4px 0;
  transition: color var(--duration-fast);
}
.stops-toggle:hover {
  color: var(--c-accent);
}
.stops-toggle svg {
  transition: transform var(--duration-fast);
}

/* Time Column */
.train-time {
  display: flex;
  align-items: center;
  gap: var(--space-lg);
}

.time-block {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2px;
  min-width: 70px;
}

.time-value {
  font-size: 24px;
  font-weight: 700;
  letter-spacing: -0.03em;
  font-variant-numeric: tabular-nums;
}

.time-station {
  font-size: 13px;
  color: var(--c-text-secondary);
}

/* Duration Line */
.duration-line {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  min-width: 100px;
}

.duration-track {
  display: flex;
  align-items: center;
  width: 100%;
  position: relative;
}

.duration-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: var(--c-accent);
  flex-shrink: 0;
  z-index: 1;
}

.duration-dot.start {
  background: var(--c-accent);
}

.duration-dot.end {
  background: var(--c-success);
}

.duration-bar {
  flex: 1;
  height: 2px;
  background: linear-gradient(90deg, var(--c-accent), var(--c-success));
  margin: 0 -1px;
}

.duration-text {
  font-size: 12px;
  color: var(--c-text-muted);
  font-variant-numeric: tabular-nums;
}

/* Seat Classes Column */
.train-seats {
  display: flex;
  gap: var(--space-lg);
}

.seat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2px;
  min-width: 60px;
}

.seat-name {
  font-size: 12px;
  color: var(--c-text-muted);
}

.seat-price {
  font-size: 16px;
  font-weight: 700;
  color: var(--c-accent);
  font-variant-numeric: tabular-nums;
}

.seat-count {
  font-size: 11px;
  color: var(--c-success);
  font-weight: 500;
}

.seat-low {
  color: var(--c-warning);
}

/* -- Train Stops -- */
.train-stops {
  border-top: 1px solid var(--c-border);
  padding: var(--space-lg) var(--space-xl);
  background: var(--c-bg-warm);
  animation: slideDown var(--duration-normal) var(--ease-out);
}

.stops-loading {
  display: flex;
  justify-content: center;
  padding: var(--space-md);
}

.stops-timeline {
  display: flex;
  flex-wrap: wrap;
  gap: var(--space-md) var(--space-xl);
}

.stop-item {
  display: flex;
  align-items: center;
  gap: var(--space-sm);
  position: relative;
}

.stop-seq {
  font-size: 11px;
  font-weight: 600;
  color: var(--c-text-muted);
  width: 20px;
  text-align: center;
}

.stop-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  border: 2px solid var(--c-border-hover);
  background: var(--c-bg-card);
  flex-shrink: 0;
}

.stop-dot-first {
  background: var(--c-accent);
  border-color: var(--c-accent);
}

.stop-dot-last {
  background: var(--c-success);
  border-color: var(--c-success);
}

.stop-info {
  display: flex;
  flex-direction: column;
  gap: 1px;
}

.stop-name {
  font-size: 13px;
  font-weight: 600;
}

.stop-time {
  font-size: 11px;
  color: var(--c-text-muted);
  font-variant-numeric: tabular-nums;
}

.stop-stay {
  font-size: 11px;
  color: var(--c-info);
}

/* -- Features -- */
.features {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: var(--space-lg);
  margin-top: var(--space-xl);
}

.feature-card {
  text-align: center;
  padding: var(--space-xl) var(--space-lg);
  border: 1px solid var(--c-border);
  border-radius: var(--radius-lg);
  background: var(--c-bg-card);
  transition: all var(--duration-normal) var(--ease-out);
}

.feature-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-md);
  border-color: var(--c-border-hover);
}

.feature-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 56px;
  height: 56px;
  border-radius: var(--radius-lg);
  background: var(--c-accent-light);
  color: var(--c-accent);
  margin-bottom: var(--space-md);
}

.feature-card h3 {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: var(--space-xs);
}

.feature-card p {
  font-size: 13px;
  color: var(--c-text-secondary);
  line-height: 1.6;
}

/* -- Responsive -- */
@media (max-width: 768px) {
  .search-form {
    flex-direction: column;
    align-items: stretch;
  }
  .swap-btn {
    align-self: center;
    transform: rotate(90deg);
  }
  .swap-btn:hover {
    transform: rotate(270deg);
  }
  .search-btn {
    width: 100%;
  }
  .train-card-main {
    grid-template-columns: 1fr;
    gap: var(--space-md);
  }
  .train-seats {
    flex-wrap: wrap;
  }
  .features {
    grid-template-columns: 1fr;
  }
}
</style>
