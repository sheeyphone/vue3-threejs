<script setup>
import {useRoute} from 'vue-router'
import simplebar from 'simplebar-vue'
import {routes} from './routers'

const route = useRoute()
const isCurrentRoute = name => {
  return route.name === name
}
</script>

<template>
  <div class="flex w-full h-full">
    <div class="w-[200px] relative h-full border-r border-gray-200">
      <simplebar class="w-full h-full">
        <div class="select-none">
          <router-link v-for="(item, i) in routes" :key="i" :to="{name: item.name}">
            <div
              class="px-2 font-bold py-1 cursor-pointer hover:opacity-60"
              :class="{'text-cyan-700': isCurrentRoute(item.name)}"
            >
              {{ item.title }}
            </div>
          </router-link>
        </div>
      </simplebar>
    </div>
    <div class="flex-1 shrink-0 bg-gray-100">
      <router-view></router-view>
    </div>
  </div>
</template>
