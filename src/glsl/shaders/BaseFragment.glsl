// precision mediump float;
uniform sampler2D uTexture;
uniform vec3 uCameraPosition;

varying vec3 vPosition;
varying vec3 vNormal;
varying vec2 vUv;
varying vec3 vWorldPosition;

void main() {
  vec3 viewDirection = normalize(cameraPosition - vPosition);
  float fresnel = 1.0 - dot(viewDirection, vNormal);

  const vec3 DESATURATE = vec3(0.2126, 0.7152, 0.0722);
  vec4 texture = texture2D(uTexture, vUv);
  float finalColor = dot(texture.xyz, DESATURATE);

  float distance = length(cameraPosition - vWorldPosition);
  float brightnessFactor = 1.0 / (0.5 + distance * 0.2);

  if (texture.r < 0.9 && texture.g < 0.9 && texture.b < 0.9) {
    gl_FragColor = vec4(vec3(brightnessFactor), 1.0);
  } else {
    discard;
  }
  // gl_FragColor = vec4(vec3(finalColor), 1.0);
}
