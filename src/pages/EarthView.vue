<script setup>
import {onMounted} from 'vue'
import * as THREE from 'three'
import {OrbitControls} from 'three/addons/controls/OrbitControls.js'
import {createThreeView} from '../utils/createThreeView'
import {getFresnelMat} from '../utils/getFresnelMat'

function getCartesianCoordinates(lat, lon) {
  const latRad = (lat * Math.PI) / 180
  const lonRad = (lon * Math.PI) / 180
  const y = Math.sin(latRad)
  const x = Math.cos(latRad) * -Math.cos(lonRad)
  const z = Math.cos(latRad) * Math.sin(lonRad)
  return {x, y, z}
}

function addEarthGroup(scene) {
  let earthGroup, earthMesh, lightsMesh, glowMesh, sunLight, testMesh

  const loader = new THREE.TextureLoader()
  const detail = 16
  const geometry = new THREE.IcosahedronGeometry(1, detail)

  function setup() {
    sunLight = __addLight()
    earthGroup = __addEarthGroup()
    earthMesh = __addEarth(earthGroup)
    lightsMesh = __addLightMesh(earthGroup)
    glowMesh = __addGlow(earthGroup)
    testMesh = __test(earthGroup)
  }
  function __test(earthGroup) {
    const pt1 = getCartesianCoordinates(23, 113)
    const pt2 = getCartesianCoordinates(38, 123)
    const curveSize = 1.2
    const curve = new THREE.QuadraticBezierCurve3(
      new THREE.Vector3(pt1.x, pt1.y, pt1.z),
      new THREE.Vector3(
        ((pt1.x + pt2.x) / 2) * curveSize,
        ((pt1.y + pt2.y) / 2) * curveSize,
        ((pt1.z + pt2.z) / 2) * curveSize,
      ),
      new THREE.Vector3(pt2.x, pt2.y, pt2.z),
    )
    const points = curve.getPoints(50)
    const geometry = new THREE.BufferGeometry().setFromPoints(points)
    const material = new THREE.LineBasicMaterial({color: 0xff0000})
    const curveObject = new THREE.Line(geometry, material)
    earthGroup.add(curveObject)
    return curveObject
  }
  function onAnimate() {
    // earthMesh.rotation.y += 0.002
    // lightsMesh.rotation.y += 0.002
    // glowMesh.rotation.y += 0.002
    // testMesh.rotation.y += 0.002
  }
  function __addEarthGroup() {
    const earthGroup = new THREE.Group()
    // earthGroup.rotation.z = (-23.4 * Math.PI) / 180
    // earthGroup.add(new THREE.AxesHelper(3))
    scene.add(earthGroup)
    return earthGroup
  }
  function __addEarth(earthGroup) {
    const material = new THREE.MeshPhongMaterial({
      map: loader.load('./earth/textures/00_earthmap4k.jpg'),
      specularMap: loader.load('./earth/textures/02_earthspec1k.jpg'),
      bumpMap: loader.load('./earth/textures/01_earthbump1k.jpg'),
      bumpScale: 0.04,
    })
    const earthMesh = new THREE.Mesh(geometry, material)
    earthGroup.add(earthMesh)
    return earthMesh
  }
  function __addLightMesh(earthGroup) {
    const lightsMat = new THREE.MeshBasicMaterial({
      map: loader.load('./earth/textures/03_earthlights1k.jpg'),
      blending: THREE.AdditiveBlending,
    })
    const lightsMesh = new THREE.Mesh(geometry, lightsMat)
    lightsMesh.scale.setScalar(1.002)
    earthGroup.add(lightsMesh)
    return lightsMesh
  }
  function __addGlow(earthGroup) {
    const fresnelMat = getFresnelMat()
    const glowMesh = new THREE.Mesh(geometry, fresnelMat)
    glowMesh.scale.setScalar(1.01)
    earthGroup.add(glowMesh)
    return glowMesh
  }
  function __addLight() {
    const sunLight = new THREE.DirectionalLight(0xffffff, 2.0)
    sunLight.position.set(-2, 0.5, 1.5)
    scene.add(sunLight)
    return sunLight
  }
  return {
    setup,
    onAnimate,
  }
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
  const threeViewInstance = createThreeView('THREE_EarthView', 'c_EarthView', {
    onCreated: (scene, camera, renderer) => {
      const animateCallbacks = []
      /* Earth */
      const earthGroup = addEarthGroup(scene, camera)
      earthGroup.setup()
      animateCallbacks.push(earthGroup.onAnimate)
      /* Control */
      const controls = addControl(camera, renderer)
      controls.setup()
      animateCallbacks.push(controls.onAnimate)
      return animateCallbacks
    },
    onScene: scene => {
      scene.background = new THREE.Color(0x000000)
    },
    onCamera: camera => {
      camera.position.z = 4
    },
    onRenderer: renderer => {
      renderer.toneMapping = THREE.ACESFilmicToneMapping
      renderer.outputColorSpace = THREE.LinearSRGBColorSpace
    },
    onAll: ({camera, renderer}) => {
      const controls = new OrbitControls(camera, renderer.domElement)
      controls.update()
    },
  })
  threeViewInstance.init()
})
</script>

<template>
  <div id="THREE_EarthView" class="relative w-full h-full">
    <canvas id="c_EarthView" class="w-full h-full"></canvas>
  </div>
</template>
