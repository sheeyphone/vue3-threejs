uniform float uTime;

varying vec3 vPosition;
varying vec3 vNormal;
varying vec2 vUv;

varying float progress;

void main() {
  vPosition = position;
  vNormal = normal;
  vUv = uv;
  progress = mod(uTime, 1.0);
  gl_Position = projectionMatrix * modelViewMatrix * vec4(vPosition, 1.0);
}
