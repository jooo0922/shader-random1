#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main() {
  vec2 coord = gl_FragCoord.xy / u_resolution;

  float rnd;

  gl_FragColor = vec4(vec3(rnd), 1.);
}