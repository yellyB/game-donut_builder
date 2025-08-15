extends Control

signal popup_closed

@onready var reputation_goal_label = $CenterContainer/PopupPanel/VBoxContainer/ReputationGoalLabel
@onready var round_label = $CenterContainer/PopupPanel/VBoxContainer/RoundLabel

var hud: Node = null


func _ready():
  visible = false


func initialize(hud_node: Node) -> void:
  hud = hud_node


func show_popup(reputation_goal: int):
  reputation_goal_label.text = "평판 %d 달성하기" % reputation_goal
  round_label.text = "라운드 %d" % GameState.get_current_round()
  visible = true
  get_tree().paused = true
  
  if hud:
    var card_pack_container = hud.get_node("MarginContainer/VBoxContainer/CardPackContainer")
    if card_pack_container:
      card_pack_container.process_mode = Node.PROCESS_MODE_ALWAYS
    
    var top_bar = hud.get_node("TopBar")
    if top_bar:
      top_bar.modulate = Color(0.5, 0.5, 0.5, 1.0)
    
    var customer_timer_container = hud.get_node("CustomerTimerContainer")
    if customer_timer_container:
      customer_timer_container.modulate = Color(0.5, 0.5, 0.5, 1.0)


func _on_confirm_button_pressed():
  visible = false
  get_tree().paused = false
  
  if hud:
    var card_pack_container = hud.get_node("MarginContainer/VBoxContainer/CardPackContainer")
    if card_pack_container:
      card_pack_container.process_mode = Node.PROCESS_MODE_INHERIT
    
    var top_bar = hud.get_node("TopBar")
    if top_bar:
      top_bar.modulate = Color.WHITE
    
    var customer_timer_container = hud.get_node("CustomerTimerContainer")
    if customer_timer_container:
      customer_timer_container.modulate = Color.WHITE
  
  popup_closed.emit()
