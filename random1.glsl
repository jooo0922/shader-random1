#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// float random(vec2 st) {
//   return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) *
//     43758.5453123);
// }

// 다음 세 가지의 random 함수를 오버로딩을 사용해서 만들어줄거임
// GLSL에서는 호이스팅 개념이 없기 때문에
// main 함수에서 호출하는 함수는 main함수 앞에 정의하던지, 아니면 main 함수 아래에 정의하더라도
// 이런 식으로 위에 실행하려는 함수를 작성해줘야 제대로 실행이 되나 봄.
float random(float f);
// float random(vec2 f);
// float random(vec3 f);

void main() {
  vec2 coord = gl_FragCoord.xy / u_resolution; // 각 픽셀들 좌표값 정규화
  coord.x *= u_resolution.x / u_resolution.y; // 해상도를 변경해도 도형 왜곡이 없도록 해상도 비율을 곱함

  vec3 col = vec3(random(coord.x));

  gl_FragColor = vec4(col, 1.);
}

float random(float f) {
  /*
    아래 공식은 thebookofshaders.com 랜덤 파트에서 
    sin(), fract() 내장함수로 랜덤값을 구하는 식을 가져온 것.
    
    그냥 1.0을 곱한거는 sin값 그 자체가 들어가기 때문에 별다른 변화가 없음.
    그런데, 여기에 만약 7985.1379 뭐 이런 임의의 큰 값을 넣어주면 랜덤값을 리턴해줌으로써,
    x좌표값이 동일한 픽셀들마다 각각의 랜덤한 색상값을 지정받게 됨.

    거기에 f값 자체에도 임의의 큰 값을 곱해주면
    Frequency 를 더욱 조밀하게 조정된 랜덤값을 리턴해주게 됨.

    이런 식으로 하나의 pseudo random code (즉, 모의 랜덤 코드)를 만드는 것임.

    이렇게 함으로써, y에는 '예측하기 힘든' 그러나 0 ~ 1 사이의 '모의적인' 랜덤값이 들어가게 됨.
    왜 '모의적'이냐면, 이게 실제 랜덤값은 아니기 때문이지.
    추적 가능한 값이지만 좀 복잡하기 때문에 마치 랜덤값처럼 보이는 것일 뿐. 
  */
  float y = fract(sin(f * 712.5568) * 7984.12379);
  return y;
}

/*
  GLSL에서 사용하는 Random 함수는
  실제로 랜덤값을 리턴해주는 것이 아니라,
  
  어떠한 특정 공식에 의해
  '랜덤처럼 보이는' 이미지를 그려내기 위해 만든
  random 함수를 사용하는 것임!
*/

/*
  오버로딩


  같은 함수 이름을 사용하지만,
  매개변수로 들어가는 데이터의 Input type에 따라서
  같은 이름의 함수더라도 여러 가지의 함수들을 정의할 수 있음. -> 이를 '오버로딩'이라고 함.

  이 오버로딩을 사용해서 인풋과 아웃풋 타입이 다른 
  여러 방식의 random() 함수를 만들어 볼 것임.


  그래서, 가장 추천하는 방법은
  지금부터 만들게 될 random, noise 발생 함수들에 대해 
  input type / output type 에 따라 
  각각의 함수들을 저장해놓는 것이 좋음.

  예를 들어, 이번 예제에서 배우는 random 함수는
  vec2 타입을 인자로 받아 float 타입을 리턴해주는 함수를 배우게 될 것이고,
  그에 앞서, float 타입을 인자로 받아서 vec2 타입을 리턴해주는 random 함수도 배우게 될 것임.

  그래서, 이렇게 각 타입별로 다르게 정의된 random() 함수를
  메모장이나 다른 곳에 기록을 해둔 뒤에,
  필요한 상황에서 꺼내쓰는 방식으로 사용하는 것!
*/

/*
  첫 번째 float(인풋) / float(아웃풋) random() 함수 코드 정리
  즉, 각 픽셀들의 x좌표값에 따라서, 랜덤한 숫자를 리턴받아 색깔에 대입시켜주는 함수.
*/