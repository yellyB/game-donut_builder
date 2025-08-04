extends Node

const INITIAL_MONEY = 100
const INITIAL_REPUTATION = 0

var money: int = INITIAL_MONEY
var reputation: int = INITIAL_REPUTATION


func add_money(amount: int):
  money += amount


func add_reputation(value: int):
  reputation += value


func reset():
  money = INITIAL_MONEY
  reputation = INITIAL_REPUTATION 
