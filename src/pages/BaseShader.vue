<script setup>
import {onMounted} from 'vue'
import {OrbitControls} from 'three/addons/controls/OrbitControls.js'
import {createThreeView, THREE} from '../utils/createThreeView'
import baseVertex from '../glsl/shaders/BaseVertex.glsl'
import baseFragment from '../glsl/shaders/BaseFragment.glsl'
import BasicImage from '../assets/00_earth_black_4k.png'

function addSphere(scene, camera) {
  let sphereMesh
  function setup() {
    const geometry = new THREE.IcosahedronGeometry(1, 50)
    const material = new THREE.ShaderMaterial({
      vertexShader: baseVertex,
      fragmentShader: baseFragment,
      transparent: true,
      side: THREE.DoubleSide,
    })
    material.uniforms = {
      uTexture: {
        value: new THREE.TextureLoader().load(BasicImage),
      },
      uCameraPosition: {
        value: camera.position,
      },
    }
    sphereMesh = new THREE.Mesh(geometry, material)
    scene.add(sphereMesh)
  }
  function onAnimate() {}
  return {setup, onAnimate}
}

function addControl(camera, renderer) {
  let controls
  function setup() {
    controls = new OrbitControls(camera, renderer.domElement)
    controls.enableDamping = true
  }
  function onAnimate() {
    controls.update()
  }
  return {
    setup,
    onAnimate,
  }
}

onMounted(() => {
  const threeViewInstance = createThreeView('THREE_BaseShader', 'c_BaseShader', {
    onCreated: (scene, camera, renderer) => {
      const animateCallbacks = []
      /* Sphere */
      const sphere = addSphere(scene, camera)
      sphere.setup()
      animateCallbacks.push(sphere.onAnimate)
      /* Control */
      const controls = addControl(camera, renderer)
      controls.setup()
      animateCallbacks.push(controls.onAnimate)
      return animateCallbacks
    },
    onScene: scene => {
      scene.background = new THREE.Color('#000')
    },
    onCamera: camera => {
      camera.position.z = 3
    },
  })
  threeViewInstance.init()
})
</script>

<template>
  <div id="THREE_BaseShader" class="relative w-full h-full">
    <canvas id="c_BaseShader" class="w-full h-full"></canvas>
  </div>
</template>
