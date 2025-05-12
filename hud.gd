extends CanvasLayer

@onready var card_pack_grid = $MarginContainer/VBoxContainer/CardPackContainer
@onready var description_label = $MarginContainer/VBoxContainer/FooterContainer/Description
@onready var money_label = $TopBar/HBoxContainer/MoneyContainer/MoneyLabel
@export var cardpack_scene: PackedScene
@export var remaining_seconds := 60
var grid_manager: Node = null  # Main에서 할당
var card_data = [
  { "image": preload("res://images/card_pack_1.png"), "price": 1000, "description": "첫 번째 카드 설명: 123 123 123" },
  { "image": preload("res://images/card_pack_2.png"), "price": 3000, "description": "두 번째 카드 설명: 라라라 라라라랄" },
  { "image": preload("res://images/card_pack_3.png"), "price": 8000, "description": "세 번째 카드 설명: There is no harm." }
]


func _ready() -> void:
  update_money_display()
  update_timer_label()
  for data in card_data:
    var card_pack = cardpack_scene.instantiate()
    card_pack.card_texture = data["image"]
    card_pack.description_text = data["description"]
    card_pack.card_pack_clicked.connect(_on_card_pack_gui_input)
    card_pack_grid.add_child(card_pack)


func _on_card_pack_gui_input(description) -> void:
  description_label.text = description


func _on_countdown_timer_timeout() -> void:
  var countdown_timer: Timer = $TopBar/HBoxContainer/TimerContainer/CountdownTimer
  remaining_seconds -= 1
  if remaining_seconds < 0:
    countdown_timer.stop()
    remaining_seconds = 0
    on_timer_finished()
  update_timer_label()


func _on_moeny_increase():
  GameState.add_money(1)
  update_money_display()
  

func on_timer_finished() -> void:
  # todo: 타이머 종료 시 이벤트 작성
  print('타이머 종료됨')
  pass


func update_timer_label() -> void:
  var timer_label = $TopBar/HBoxContainer/TimerContainer/TimerLabel
  var minutes = remaining_seconds / 60
  var seconds = remaining_seconds % 60
  timer_label.text = "%02d:%02d" % [minutes, seconds]


func update_money_display():
  money_label.text = str(GameState.money)


func _on_button_pressed() -> void:
  grid_manager.spawn_cards("MATERIAL")


func _on_button_2_pressed() -> void:
  grid_manager.spawn_cards("DONUT")


func _on_button_3_pressed() -> void:
  grid_manager.spawn_cards("CUSTOMER")


func initialize(grid_manager_node: Node) -> void:
  grid_manager = grid_manager_node
