<script setup>
import {onMounted} from 'vue'
import {OrbitControls} from 'three/addons/controls/OrbitControls.js'
import {createThreeView, THREE} from '../utils/createThreeView'
import baseVertex from '../glsl/shaders/radar/vertex.glsl'
import baseFragment from '../glsl/shaders/radar/fragment.glsl'

function addRadarPlane(scene) {
  let radarPlaneUp, radarPlaneDown, radarBox
  function setup() {
    // radarPlaneUp = __addPlane({
    //   isUp: true,
    //   textureUrl: 'radar/radar_color.png',
    // })
    // radarPlaneDown = __addPlane({
    //   isUp: false,
    //   textureUrl: 'radar/radar_color_mirrow.png',
    // })
    // radarBox = __addBox({textureUpUrl: 'radar/radar_color.png', textureDownUrl: 'radar/radar_color_mirrow.png'})
    __addRadar()
    const axesHelper = new THREE.AxesHelper(2)
    scene.add(axesHelper)
  }
  function onAnimate() {}
  function __addPlane({isUp, textureUrl}) {
    const geometry = new THREE.PlaneGeometry(2, 2, 512, 512)
    const texture = new THREE.TextureLoader().load(textureUrl)
    const material = new THREE.ShaderMaterial({
      // side: THREE.DoubleSide,
      transparent: true,
      vertexShader: baseVertex,
      fragmentShader: baseFragment,
      uniforms: {
        uTexture: {
          value: texture,
        },
      },
    })
    const plane = new THREE.Mesh(geometry, material)

    if (isUp) {
      plane.rotation.x = 1.0 * Math.PI
    }
    scene.add(plane)
    return plane
  }
  function __addBox({textureUpUrl, textureDownUrl}) {
    const makeMaterial = (texture, direction) => {
      return new THREE.ShaderMaterial({
        transparent: true,
        vertexShader: baseVertex,
        fragmentShader: baseFragment,
        uniforms: {
          uTexture: {
            value: texture,
          },
          uDirection: {
            value: direction,
          },
        },
      })
    }
    const makePlainMaterial = () => {
      return new THREE.MeshBasicMaterial({color: 0x000000, side: THREE.DoubleSide, transparent: true})
    }
    const geometry = new THREE.BoxGeometry(1, 1, 0.0001, 128, 128, 1)
    const textureUp = new THREE.TextureLoader().load(textureUpUrl)
    const textureDown = new THREE.TextureLoader().load(textureDownUrl)
    const materials = [
      makePlainMaterial(),
      makePlainMaterial(),
      makePlainMaterial(),
      makePlainMaterial(),
      makeMaterial(textureUp, 1),
      makeMaterial(textureDown, -1),
    ]
    const boxMesh = new THREE.Mesh(geometry, materials)
    scene.add(boxMesh)
    return boxMesh
  }
  function __addRadar() {
    const createPath = () => {
      const path = new THREE.Path()
      const numPoints = 32 // 路径上的点的数量
      const maxRadius = 0.8 // 最大半径
      const minRadius = 0.5 // 最小半径
      const smoothness = 0.5 // 曲线平滑度
      // 生成随机点并连接成封闭路径
      path.moveTo(maxRadius, 0)
      for (let i = 1; i <= numPoints; i++) {
        const angle = (i / numPoints) * Math.PI * 2
        const radius = THREE.MathUtils.lerp(minRadius, maxRadius, Math.random())
        const x = radius * Math.cos(angle)
        const y = radius * Math.sin(angle)
        const cp1X = x * (1 - smoothness)
        const cp1Y = y * (1 - smoothness)
        const cp2X = x * (1 + smoothness)
        const cp2Y = y * (1 + smoothness)
        path.bezierCurveTo(cp1X, cp1Y, cp2X, cp2Y, x, y)
      }
      path.closePath()
      // 将 Path 转换为 Shape 对象
      const shape = new THREE.Shape(path.getPoints())
      return shape
    }

    const shape = createPath()
    const extrudeSettings = {
      depth: 1, // 挤压深度
      bevelEnabled: true, // 启用倒角
      bevelThickness: 2.5, // 倒角厚度
      bevelSize: 3, // 倒角大小
    }

    const geometry = new THREE.ExtrudeGeometry(shape, extrudeSettings)
    const material = new THREE.MeshBasicMaterial({color: 0x00ff00, wireframe: false})
    const mesh = new THREE.Mesh(geometry, material)
    scene.add(mesh)
    return mesh
  }
  return {
    setup,
    onAnimate,
  }
}

onMounted(() => {
  const threeViewInstance = createThreeView('THREE_RadarPlane', 'c_RadarPlane', {
    onCreated: (scene, camera, renderer) => {
      const animateCallbacks = []
      /* Radar */
      const radarPlane = addRadarPlane(scene)
      radarPlane.setup()
      animateCallbacks.push(radarPlane.onAnimate)
      return animateCallbacks
    },
    onScene: scene => {
      scene.background = new THREE.Color(0xffffff)
    },
    onCamera: camera => {
      camera.position.z = 10
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
  <div id="THREE_RadarPlane" class="relative w-full h-full">
    <canvas id="c_RadarPlane" class="w-full h-full"></canvas>
  </div>
</template>
