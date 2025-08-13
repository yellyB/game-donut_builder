extends Control

signal popup_closed

@onready var reputation_goal_label = $CenterContainer/PopupPanel/VBoxContainer/ReputationGoalLabel


func _ready():
  visible = false


func show_popup(reputation_goal: int):
  reputation_goal_label.text = "평판 %d 달성하기" % reputation_goal
  visible = true
  get_tree().paused = true


func _on_confirm_button_pressed():
  visible = false
  get_tree().paused = false
  popup_closed.emit()
