<script setup>
import { ref, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import Cookies from 'js-cookie'
import { fetchLogout } from '@/api'

const router = useRouter()
const route = useRoute()

const username = ref(Cookies.get('username') || '')
const isLoggedIn = computed(() => !!Cookies.get('token'))
const mobileMenuOpen = ref(false)

const navItems = [
  { label: '车票查询', path: '/search', icon: 'search', requiresAuth: false },
  { label: '我的订单', path: '/orders', icon: 'orders', requiresAuth: true },
  { label: '乘车人', path: '/passengers', icon: 'users', requiresAuth: true },
  { label: '个人信息', path: '/profile', icon: 'user', requiresAuth: true },
]

const visibleNavItems = computed(() =>
  navItems.filter(item => !item.requiresAuth || isLoggedIn.value)
)

const handleLogout = async () => {
  await fetchLogout()
  Cookies.remove('username')
  Cookies.remove('token')
  Cookies.remove('userId')
  username.value = ''
  router.push('/login')
}

// Watch for login state changes
router.afterEach(() => {
  username.value = Cookies.get('username') || ''
})
</script>

<template>
  <div id="railway-app">
    <!-- Navigation -->
    <nav class="nav">
      <div class="nav-inner container">
        <!-- Logo -->
        <router-link to="/" class="nav-logo">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
            <path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/>
            <line x1="4" x2="4" y1="22" y2="15"/>
          </svg>
          <span class="nav-logo-text">铁路<strong>12306</strong></span>
        </router-link>

        <!-- Desktop Nav -->
        <div class="nav-links">
          <router-link
            v-for="item in visibleNavItems"
            :key="item.path"
            :to="item.path"
            class="nav-link"
            :class="{ 'nav-link-active': route.path === item.path }"
          >
            {{ item.label }}
          </router-link>
        </div>

        <!-- Auth Area -->
        <div class="nav-auth">
          <template v-if="isLoggedIn">
            <span class="nav-user">{{ username }}</span>
            <button class="btn btn-ghost" @click="handleLogout">退出</button>
          </template>
          <template v-else>
            <router-link to="/login" class="btn btn-ghost">登录</router-link>
            <router-link to="/register" class="btn btn-primary">注册</router-link>
          </template>
        </div>

        <!-- Mobile Toggle -->
        <button class="nav-mobile-toggle" @click="mobileMenuOpen = !mobileMenuOpen">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <line x1="3" y1="6" x2="21" y2="6"/>
            <line x1="3" y1="12" x2="21" y2="12"/>
            <line x1="3" y1="18" x2="21" y2="18"/>
          </svg>
        </button>
      </div>

      <!-- Mobile Menu -->
      <div class="nav-mobile" v-if="mobileMenuOpen" @click="mobileMenuOpen = false">
        <router-link
          v-for="item in visibleNavItems"
          :key="item.path"
          :to="item.path"
          class="nav-mobile-link"
        >
          {{ item.label }}
        </router-link>
      </div>
    </nav>

    <!-- Main Content -->
    <main class="main-content">
      <router-view v-slot="{ Component }">
        <transition name="page" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
    </main>

    <!-- Footer -->
    <footer class="footer">
      <div class="container">
        <div class="footer-inner">
          <p class="footer-brand">铁路12306 V2</p>
          <p class="footer-text">仅供学习交流使用，非官方服务</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<style scoped>
/* -- Navigation -- */
.nav {
  position: sticky;
  top: 0;
  z-index: 100;
  background: var(--c-bg-nav);
  backdrop-filter: blur(16px) saturate(180%);
  -webkit-backdrop-filter: blur(16px) saturate(180%);
  border-bottom: 1px solid rgba(255,255,255,0.06);
}

.nav-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 60px;
  gap: var(--space-lg);
}

.nav-logo {
  display: flex;
  align-items: center;
  gap: var(--space-sm);
  color: var(--c-text-inverse);
  font-size: 16px;
  letter-spacing: -0.02em;
  flex-shrink: 0;
}

.nav-logo-text {
  font-weight: 300;
}
.nav-logo-text strong {
  font-weight: 700;
  color: var(--c-accent);
}

.nav-links {
  display: flex;
  align-items: center;
  gap: var(--space-xs);
}

.nav-link {
  padding: 6px 16px;
  border-radius: var(--radius-md);
  font-size: 14px;
  font-weight: 400;
  color: rgba(250, 248, 245, 0.6);
  transition: all var(--duration-fast) var(--ease-out);
  white-space: nowrap;
}

.nav-link:hover {
  color: var(--c-text-inverse);
  background: rgba(255,255,255,0.08);
}

.nav-link-active {
  color: var(--c-text-inverse) !important;
  background: rgba(255,255,255,0.1);
  font-weight: 500;
}

.nav-auth {
  display: flex;
  align-items: center;
  gap: var(--space-sm);
  flex-shrink: 0;
}

.nav-user {
  font-size: 13px;
  color: rgba(250, 248, 245, 0.7);
  padding: 0 var(--space-sm);
}

.nav-auth .btn-ghost {
  color: rgba(250, 248, 245, 0.7);
  font-size: 13px;
}
.nav-auth .btn-ghost:hover {
  color: var(--c-text-inverse);
  background: rgba(255,255,255,0.08);
}

.nav-auth .btn-primary {
  font-size: 13px;
  padding: 7px 18px;
}

.nav-mobile-toggle {
  display: none;
  background: transparent;
  color: var(--c-text-inverse);
  padding: 4px;
}

.nav-mobile {
  display: none;
  padding: var(--space-md) var(--space-lg);
  border-top: 1px solid rgba(255,255,255,0.06);
  animation: slideDown var(--duration-normal) var(--ease-out);
}

.nav-mobile-link {
  display: block;
  padding: 10px 0;
  color: rgba(250, 248, 245, 0.7);
  font-size: 15px;
  border-bottom: 1px solid rgba(255,255,255,0.04);
}

/* -- Main Content -- */
.main-content {
  min-height: calc(100vh - 60px - 80px);
  padding: var(--space-2xl) 0;
}

/* -- Footer -- */
.footer {
  border-top: 1px solid var(--c-border);
  padding: var(--space-lg) 0;
}

.footer-inner {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.footer-brand {
  font-size: 13px;
  font-weight: 600;
  color: var(--c-text-secondary);
}

.footer-text {
  font-size: 12px;
  color: var(--c-text-muted);
}

/* -- Page Transition -- */
.page-enter-active {
  animation: fadeInUp var(--duration-slow) var(--ease-out);
}
.page-leave-active {
  animation: fadeIn var(--duration-fast) var(--ease-out) reverse;
}

/* -- Responsive -- */
@media (max-width: 768px) {
  .nav-links, .nav-auth { display: none; }
  .nav-mobile-toggle { display: block; }
  .nav-mobile { display: block; }
  .main-content { padding: var(--space-lg) 0; }
}
</style>
