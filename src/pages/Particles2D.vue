<script setup>
import {onMounted} from 'vue'

/* Canvas */
let container = null
let canvas = null
let context = null
let SCREEN_HEIGHT = 0
let SCREEN_WIDTH = 0
const MAX_SIZE = 500

const initCanvas = () => {
  container = document.querySelector('#Particle2D')
  canvas = document.createElement('canvas')
  context = canvas.getContext('2d')
  SCREEN_HEIGHT = canvas.height = container.clientHeight
  SCREEN_WIDTH = canvas.width = container.clientWidth
  container.appendChild(canvas)
}
const updateCanvasSize = () => {
  if (container && canvas) {
    const {clientHeight, clientWidth} = container
    SCREEN_HEIGHT = canvas.height = clientHeight
    SCREEN_WIDTH = canvas.width = clientWidth
  }
}
const render = time => {
  requestAnimationFrame(render)
  context.fillStyle = `rgba(${240},${240},${240},${0.05})`
  context.fillRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

  particleList.forEach(p => {
    p.update(time)
    p.render(context)
  })

  particleList.push(createParticle(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5, 3))
  while (particleList.length > MAX_SIZE) {
    particleList.shift()
  }
}

/* Particles */
const particleList = []
const createParticle = (x, y, size) => {
  let _x = x
  let _y = y
  let _alpha = 1.0
  let _angle = Math.random() * Math.PI * 2
  let _vel = {
    x: Math.cos(_angle),
    y: Math.sin(_angle),
  }
  function update(time) {
    _x += _vel.x
    _y += _vel.y
    _alpha -= 0.005
  }
  function render(context) {
    context.fillStyle = `rgba(0, 0, 0, ${_alpha})`
    context.beginPath()
    context.arc(_x, _y, size, 0, Math.PI * 2, true)
    context.fill()
  }
  return {update, render}
}

onMounted(() => {
  initCanvas()
  updateCanvasSize()
  window.addEventListener('resize', () => {
    updateCanvasSize()
  })

  render(0)
})
</script>

<template>
  <div id="Particle2D" class="h-full w-full"></div>
</template>
