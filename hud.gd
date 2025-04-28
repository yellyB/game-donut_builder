extends CanvasLayer


@onready var hbox = $MarginContainer/VBoxContainer/HBoxContainer
@onready var label = $MarginContainer/VBoxContainer/HBoxContainer2/Description
@export var cardpack_scene: PackedScene

var card_data = [
  { "image": preload("res://images/card_pack_1.png"), "description": "첫 번째 카드 설명: 123 123 123" },
  { "image": preload("res://images/card_pack_2.png"), "description": "두 번째 카드 설명: 라라라 라라라랄" },
  { "image": preload("res://images/card_pack_3.png"), "description": "세 번째 카드 설명: There is no harm." }
]


func _ready() -> void:
  for data in card_data:
    var card_pack = cardpack_scene.instantiate()
    card_pack.card_texture = data["image"]
    card_pack.description_text = data["description"]
    card_pack.card_pack_clicked.connect(_on_card_pack_gui_input)
    hbox.add_child(card_pack)


func _on_card_pack_gui_input(description) -> void:
  label.text = description
