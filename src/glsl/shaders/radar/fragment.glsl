// precision mediump float;

uniform sampler2D uTexture;

varying vec3 vPosition;
varying vec3 vNormal;
varying vec2 vUv;

void main() {
  vec4 texColor = texture2D(uTexture, vUv);
  vec4 texColorCopy = texColor;
  texColor.r = texColor.r + 0.1;
  texColor.a = step(0.5, texColor.a);
  if (texColorCopy.a > 0.0) {
    texColor.a = 1.0;
  }
  gl_FragColor = texColor;
}
