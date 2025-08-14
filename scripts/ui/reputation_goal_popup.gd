extends Control

signal popup_closed

@onready var reputation_goal_label = $CenterContainer/PopupPanel/VBoxContainer/ReputationGoalLabel

var hud: Node = null


func _ready():
  visible = false


func initialize(hud_node: Node) -> void:
  hud = hud_node


func show_popup(reputation_goal: int):
  reputation_goal_label.text = "평판 %d 달성하기" % reputation_goal
  visible = true
  get_tree().paused = true
  
  if hud:
    var margin_container = hud.get_node("MarginContainer")
    if margin_container:
      margin_container.process_mode = Node.PROCESS_MODE_ALWAYS


func _on_confirm_button_pressed():
  visible = false
  get_tree().paused = false
  
  if hud:
    var margin_container = hud.get_node("MarginContainer")
    if margin_container:
      margin_container.process_mode = Node.PROCESS_MODE_INHERIT
  
  popup_closed.emit()
