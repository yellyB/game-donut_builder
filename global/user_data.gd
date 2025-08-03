extends Node

signal game_cleared

const INITIAL_MONEY = 100
const INITIAL_REPUTATION = 0

var money: int = INITIAL_MONEY
var reputation: int = INITIAL_REPUTATION
var clear_reputation: int = 0


func add_money(amount: int):
  money += amount


func set_clear_reputation(value: int):
  clear_reputation = value


func add_reputation(value: int):
  reputation += value
  
  if reputation >= clear_reputation:
    game_cleared.emit()


func reset():
  money = INITIAL_MONEY
  reputation = INITIAL_REPUTATION 