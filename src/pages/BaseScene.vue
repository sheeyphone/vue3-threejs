<script setup>
import {THREE} from '../utils/createThreeView'
import {ref, computed, onMounted, onUnmounted} from 'vue'

/* Window size */
const windowSize = ref({
  h: 0,
  w: 0,
})
const getRenderDOM = () => {
  return document.getElementById('THREE_BaseScene')
}
const updateSceneSize = () => {
  const THREE_DOM = getRenderDOM()
  if (THREE_DOM) {
    const {clientHeight, clientWidth} = THREE_DOM
    windowSize.value.h = clientHeight
    windowSize.value.w = clientWidth
    if (canvas) {
      canvas.height = clientHeight
      canvas.width = clientWidth
    }
  }
}

/* Threejs basic props */
let scene
let canvas
let renderer
const updateRender = () => {
  if (renderer && camera && scene && resizeRendererToDisplaySize(renderer)) {
    const canvas = renderer.domElement
    camera.aspect = canvas.clientWidth / canvas.clientHeight
    camera.updateProjectionMatrix()
  }
  if (renderer && camera && scene) {
    renderer.render(scene, camera)
  }
}
const resizeRendererToDisplaySize = renderer => {
  const canvas = renderer.domElement
  const pixelRatio = window.devicePixelRatio
  const width = Math.floor(canvas.clientWidth * pixelRatio)
  const height = Math.floor(canvas.clientHeight * pixelRatio)
  const needResize = canvas.width !== width || canvas.height !== height
  if (needResize) {
    renderer.setSize(width, height, false)
  }
  return needResize
}

/* Camera */
let camera
const fov = 75
const aspect = computed(() => {
  if (windowSize.value.w === 0 || windowSize.value.h === 0) return 1
  else return windowSize.value.w / windowSize.value.h
})
const near = 0.1
const far = 50

/* Cube */
const boxWidth = 1
const boxHeight = 1
const boxDepth = 1
// const geometryCube = new THREE.BoxGeometry(boxWidth, boxHeight, boxDepth)
const geometryCube = new THREE.TorusGeometry(1, 0.5, 16, 32)
const materialCube = createMaterial()
const cube = new THREE.Mesh(geometryCube, materialCube)

/* Blue line */
const points = []
points.push(new THREE.Vector3(-2, 0, 0))
points.push(new THREE.Vector3(0, 2, 0))
points.push(new THREE.Vector3(2, 0, 0))
const geometryBlueLine = new THREE.BufferGeometry().setFromPoints(points)
const materialBlueLine = new THREE.LineBasicMaterial({color: 0x0000ff})
const line = new THREE.Line(geometryBlueLine, materialBlueLine)

/* Ease functions */
const objects = []
const spread = 2
function addObject(x, y, obj) {
  obj.position.x = x * spread
  obj.position.y = y * spread

  scene.add(obj)
  objects.push(obj)
}
function createMaterial() {
  const material = new THREE.MeshPhongMaterial({
    side: THREE.DoubleSide,
  })

  const hue = Math.random()
  const saturation = 1
  const luminance = 0.5
  material.color.setHSL(hue, saturation, luminance)

  return material
}
function addSolidGeometry(x, y, geometry) {
  const mesh = new THREE.Mesh(geometry, createMaterial())
  addObject(x, y, mesh)
}
const updateObjects = time => {
  time *= 0.001
  objects.forEach(obj => {
    obj.rotation.x = time
    obj.rotation.y = time
  })
}

/* Light */
const color = 0xffffff
const intensity = 5
const light = new THREE.DirectionalLight(color, intensity)

const animate = time => {
  updateObjects(time)
  updateRender()
}

const init = () => {
  updateSceneSize()
  window.addEventListener('resize', () => {
    updateSceneSize()
  })

  scene = new THREE.Scene()
  // scene.background = new THREE.Color(0xffffff)

  cube.position.set(0, 0, 0)
  scene.add(cube)
  line.position.set(3, 0, 0)
  scene.add(line)
  light.position.set(-1, 2, 4)
  scene.add(light)

  addSolidGeometry(1, 3, new THREE.BoxGeometry(5, 5, 2))

  canvas = document.querySelector('#c_BaseScene')
  renderer = new THREE.WebGLRenderer({antialias: true, alpha: true, canvas})
  renderer.setAnimationLoop(animate)
  renderer.setClearAlpha(0.0)

  camera = new THREE.PerspectiveCamera(fov, aspect, near, far)
  camera.aspect = canvas.clientWidth / canvas.clientHeight
  camera.updateProjectionMatrix()
  camera.position.set(0, 0, 20)
  camera.lookAt(0, 0, 0)
}
const end = () => {}

onMounted(() => {
  init()
})
onUnmounted(() => {
  end()
})
</script>

<template>
  <div id="THREE_BaseScene" class="relative w-full h-full">
    <canvas id="c_BaseScene" class="w-full h-full"></canvas>
  </div>
</template>
