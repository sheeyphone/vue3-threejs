import {createRouter, createWebHashHistory} from 'vue-router'

const routes = [
  {
    name: 'BaseScene',
    title: 'Base scene',
    path: '/',
    component: () => import('../pages/BaseScene.vue'),
  },
  {
    name: 'BaseShader',
    title: 'Base shader',
    path: '/BaseShader',
    component: () => import('../pages/BaseShader.vue'),
  },
  {
    name: 'Particles2D',
    title: 'Particles 2D',
    path: '/Particles2D',
    component: () => import('../pages/Particles2D.vue'),
  },
  {
    name: 'EarthView',
    title: 'Earth View',
    path: '/EarthView',
    component: () => import('../pages/EarthView.vue'),
  },
  {
    name: 'RadarPlane',
    title: 'Radar Plane',
    path: '/RadarPlane',
    component: () => import('../pages/RadarPlane.vue'),
  },
]
const router = createRouter({
  history: createWebHashHistory(),
  routes,
})

export {router, routes}
