// 타입 변환 유틸리티 함수
Map<String, dynamic> castMap(Map<dynamic, dynamic> map) {
  var newMap = <String, dynamic>{};
  map.forEach((key, value) {
    newMap[key.toString()] = value;
  });
  return newMap;
}
