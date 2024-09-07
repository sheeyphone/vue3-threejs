// attribute
// uniform
uniform sampler2D uTexture;
uniform float uDirection;

varying vec3 vPosition;
varying vec3 vNormal;
varying vec2 vUv;

void main() {
  vPosition = position;
  vNormal = normal;
  vUv = uv;

  vec4 texColor = texture2D(uTexture, vUv);
  vec3 newPosition = position;
  newPosition.z = uDirection * (newPosition.z + texColor.r * 0.005 + texColor.g * 0.005 + texColor.a * 0.005);
  gl_Position = projectionMatrix * modelViewMatrix * vec4(newPosition, 1.0);
}

/* 
As you can see GLSL has more surprises. 
The GPU has hardware accelerated angle, trigonometric and exponential functions. 
Some of those functions are: sin(), cos(), tan(), asin(), acos(), atan(), pow(), exp(), log(), sqrt(), abs(), sign(), floor(), ceil(), fract(), mod(), min(), max() and clamp().
 */

