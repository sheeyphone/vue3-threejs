import * as three from 'three'

export const THREE = three

export const createThreeView = (containerId, canvasId, {onCreated, onScene, onCamera, onRenderer, onAll}) => {
  const DPR = window.devicePixelRatio
  let container, canvas, scene, camera, renderer
  let WIDTH, HEIGHT
  let animateListeners = []
  function init() {
    __initContainer()
    __initThree(onScene, onCamera, onRenderer)
    __initEvents()
    __animate()
    /* Callback */
    if (onCreated) {
      const animateCallbacks = onCreated(scene, camera, renderer)
      if (animateCallbacks) animateListeners = animateCallbacks
    }
  }
  function __initContainer() {
    container = document.getElementById(containerId)
    canvas = document.getElementById(canvasId)
    WIDTH = canvas.width = container.clientWidth
    HEIGHT = canvas.height = container.clientHeight
  }
  function __initThree(onScene, onCamera) {
    scene = new THREE.Scene()
    if (onScene) onScene(scene)
    camera = new THREE.PerspectiveCamera(75, WIDTH / HEIGHT, 0.01, 1000)
    if (onCamera) onCamera(camera)
    renderer = new THREE.WebGLRenderer({antialias: true, alpha: true, canvas})
    if (onRenderer) onRenderer(renderer)
    /* All */
    if (onAll) onAll({scene, camera, renderer})
  }
  function __initEvents() {
    __updateSceneSize()
    window.addEventListener('resize', () => {
      __updateSceneSize()
    })
  }
  function __updateSceneSize() {
    if (container && canvas) {
      WIDTH = canvas.width = container.clientWidth
      HEIGHT = canvas.height = container.clientHeight
    }
    if (renderer) {
      renderer.setSize(WIDTH, HEIGHT)
      renderer.setPixelRatio(DPR)
    }
    if (camera) {
      camera.aspect = WIDTH / HEIGHT
      camera.updateProjectionMatrix()
    }
  }
  function __animate(time) {
    requestAnimationFrame(__animate)
    animateListeners.forEach(listener => {
      listener(time)
    })
    renderer.render(scene, camera)
  }
  return {
    init,
  }
}
