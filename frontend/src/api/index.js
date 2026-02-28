import axios from 'axios'
import Cookies from 'js-cookie'

const http = axios.create({
    timeout: 15000
})

http.interceptors.request.use(config => {
    const token = Cookies.get('token')
    if (token) {
        config.headers['Authorization'] = token
    }
    return config
})

http.interceptors.response.use(
    response => response,
    error => {
        console.error('Request failed:', error)
        return Promise.reject(error)
    }
)

// === User APIs ===
export const fetchLogin = async (body) => {
    const { data } = await http.post('/api/user-service/v1/login', body)
    if (data.data?.accessToken) {
        http.defaults.headers.common['Authorization'] = data.data.accessToken
    }
    return data
}

export const fetchRegister = async (body) => {
    const { data } = await http.post('/api/user-service/register', body)
    return data
}

export const fetchUserInfo = async (params) => {
    const { data } = await http.get('/api/user-service/query', { params })
    return data
}

export const fetchUserUpdate = async (body) => {
    const { data } = await http.post('/api/user-service/update', body)
    return data
}

export const fetchLogout = async () => {
    const { data } = await http.get('/api/user-service/logout')
    http.defaults.headers.common['Authorization'] = null
    return data
}

// === Ticket APIs ===
export const fetchStationAll = async () => {
    const { data } = await http.get('/api/ticket-service/station/all')
    return data
}

export const fetchTicketSearch = async (params) => {
    const { data } = await http.get('/api/ticket-service/ticket/query', { params })
    return data
}

export const fetchTrainStation = async (params) => {
    const { data } = await http.get('/api/ticket-service/train-station/query', { params })
    return data
}

export const fetchBuyTicket = async (body) => {
    const { data } = await http.post('/api/ticket-service/ticket/purchase/v2', body)
    return data
}

export const fetchCancelTicket = async (body) => {
    const { data } = await http.post('/api/ticket-service/ticket/cancel', body)
    return data
}

// === Passenger APIs ===
export const fetchPassengerList = async (params) => {
    const { data } = await http.get('/api/user-service/passenger/query', { params })
    return data
}

export const fetchAddPassenger = async (body) => {
    const { data } = await http.post('/api/user-service/passenger/save', body)
    return data
}

export const fetchEditPassenger = async (body) => {
    const { data } = await http.post('/api/user-service/passenger/update', body)
    return data
}

export const fetchDeletePassenger = async (body) => {
    const { data } = await http.post('/api/user-service/passenger/remove', body)
    return data
}

// === Order APIs ===
export const fetchOrderBySn = async (params) => {
    const { data } = await http.get('/api/order-service/order/ticket/query', { params })
    return data
}

export const fetchTicketList = async (params) => {
    const { data } = await http.get('/api/order-service/order/ticket/page', { params })
    return data
}

export const fetchMyTicket = async (params) => {
    const { data } = await http.get('/api/order-service/order/ticket/self/page', { params })
    return data
}

// === Pay APIs ===
export const fetchPay = async (body) => {
    const { data } = await http.post('/api/pay-service/pay/create', body)
    return data
}

export const fetchOrderStatus = async (params) => {
    const { data } = await http.get('/api/pay-service/pay/query/order-sn', { params })
    return data
}
