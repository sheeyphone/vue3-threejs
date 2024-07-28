// precision mediump float;
uniform sampler2D uTexture;

varying vec3 vPosition;
varying vec3 vNormal;
varying vec2 vUv;

void main() {
  vec3 viewDirection = normalize(cameraPosition - vPosition);
  float fresnel = 1.0 - dot(viewDirection, vNormal);

  const vec3 DESATURATE = vec3(0.2126, 0.7152, 0.0722);
  vec4 texture = texture2D(uTexture, vUv);
  float finalColor = dot(texture.xyz, DESATURATE);

  gl_FragColor = vec4(vec3(finalColor), 1.0);
}
