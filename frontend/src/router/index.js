import { createRouter, createWebHistory } from 'vue-router'
import Cookies from 'js-cookie'

const routes = [
    {
        path: '/',
        redirect: '/search'
    },
    {
        path: '/search',
        name: 'search',
        component: () => import('@/views/SearchView.vue'),
        meta: { requiresAuth: false, title: '车票查询' }
    },
    {
        path: '/login',
        name: 'login',
        component: () => import('@/views/LoginView.vue'),
        meta: { requiresAuth: false, title: '登录' }
    },
    {
        path: '/register',
        name: 'register',
        component: () => import('@/views/RegisterView.vue'),
        meta: { requiresAuth: false, title: '注册' }
    },
    {
        path: '/orders',
        name: 'orders',
        component: () => import('@/views/OrdersView.vue'),
        meta: { requiresAuth: true, title: '我的订单' }
    },
    {
        path: '/passengers',
        name: 'passengers',
        component: () => import('@/views/PassengersView.vue'),
        meta: { requiresAuth: true, title: '乘车人管理' }
    },
    {
        path: '/profile',
        name: 'profile',
        component: () => import('@/views/ProfileView.vue'),
        meta: { requiresAuth: true, title: '个人信息' }
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

router.beforeEach((to) => {
    if (to.meta?.requiresAuth && (!Cookies.get('username') || !Cookies.get('token'))) {
        return { name: 'login' }
    }
})

export default router
