extends Node


var z_counter = 100

func get_next_z_index() -> int:
  z_counter += 1
  return z_counter
  
  
# todo: 스테이지가 증가할 때 z_index 를 초기화하는 함수 추가
