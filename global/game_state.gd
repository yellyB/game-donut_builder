extends Node


const STAGE_1_MONEY = 100
var z_counter = 100
var money: int = STAGE_1_MONEY
var current_time: int = 180


func get_next_z_index() -> int:
  z_counter += 1
  return z_counter

  
  
# todo: 스테이지가 증가할 때 z_index 를 초기화하는 함수 추가


func add_money(amount: int):
  money += amount


func reset():
  money = STAGE_1_MONEY
