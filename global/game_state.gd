extends Node

signal reputation_goal_changed(new_goal: int)

const STAGE_1_MONEY = 100
var z_counter = 100
var money: int = STAGE_1_MONEY
var current_time: int = 180

var current_round: int = 1
var round_clear_reputation_goal: int = 2

func get_next_z_index() -> int:
  z_counter += 1
  return z_counter

# todo: 스테이지가 증가할 때 z_index 를 초기화하는 함수 추가
  

func add_money(amount: int):
  money += amount


func reset():
  money = STAGE_1_MONEY
  current_round = 1


# todo: 라운드 숫자에 따라 평판 목표치 계산하게 개선
func set_next_round_clear_reputation_goal(value: int):
  round_clear_reputation_goal = value
  reputation_goal_changed.emit(value)
