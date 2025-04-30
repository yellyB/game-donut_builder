extends CanvasLayer


@onready var card_pack_grid = $MarginContainer/VBoxContainer/CardPackContainer
@onready var label = $MarginContainer/VBoxContainer/FooterContainer/Description
@export var cardpack_scene: PackedScene
@export var remaining_seconds := 300 # 5분
var card_data = [
  { "image": preload("res://images/card_pack_1.png"), "price": 1000, "description": "첫 번째 카드 설명: 123 123 123" },
  { "image": preload("res://images/card_pack_2.png"), "price": 3000, "description": "두 번째 카드 설명: 라라라 라라라랄" },
  { "image": preload("res://images/card_pack_3.png"), "price": 8000, "description": "세 번째 카드 설명: There is no harm." }
]


func _ready() -> void:
  update_timer_label()
  for data in card_data:
    var card_pack = cardpack_scene.instantiate()
    card_pack.card_texture = data["image"]
    card_pack.description_text = data["description"]
    card_pack.card_pack_clicked.connect(_on_card_pack_gui_input)
    card_pack_grid.add_child(card_pack)


func _on_card_pack_gui_input(description) -> void:
  label.text = description


func _on_countdown_timer_timeout() -> void:
  var countdown_timer: Timer = $TopBar/HBoxContainer/TimerContainer/CountdownTimer
  remaining_seconds -= 1
  if remaining_seconds < 0:
    countdown_timer.stop()
    remaining_seconds = 0
    on_timer_finished()
  update_timer_label()


func on_timer_finished() -> void:
  # todo: 타이머 종료 시 이벤트 작성
  pass


func update_timer_label() -> void:
  var timer_label = $TopBar/HBoxContainer/TimerContainer/TimerLabel
  var minutes = remaining_seconds / 60
  var seconds = remaining_seconds % 60
  timer_label.text = "%02d:%02d" % [minutes, seconds]
