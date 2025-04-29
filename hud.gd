extends CanvasLayer


@onready var card_pack_grid = $MarginContainer/VBoxContainer/CardPackContainer
@onready var label = $MarginContainer/VBoxContainer/HBoxContainer2/Description
@export var cardpack_scene: PackedScene

var card_data = [
  { "image": preload("res://images/card_pack_1.png"), "price": 1000, "description": "첫 번째 카드 설명: 123 123 123" },
  { "image": preload("res://images/card_pack_2.png"), "price": 3000, "description": "두 번째 카드 설명: 라라라 라라라랄" },
  { "image": preload("res://images/card_pack_3.png"), "price": 8000, "description": "세 번째 카드 설명: There is no harm." }
]


func _ready() -> void:
  for data in card_data:
    var card_pack = cardpack_scene.instantiate()
    card_pack.card_texture = data["image"]
    card_pack.description_text = data["description"]
    card_pack.card_pack_clicked.connect(_on_card_pack_gui_input)
    card_pack_grid.add_child(card_pack)


func _on_card_pack_gui_input(description) -> void:
  label.text = description
