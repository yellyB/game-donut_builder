extends Control


signal card_pack_clicked(description: String)

@export var description_text: String = "기본 설명"
@export var card_texture: Texture2D
@onready var texture_rect = $TextureRect


func _ready() -> void:
  if card_texture:
    texture_rect.texture = card_texture


func _on_gui_input(event: InputEvent) -> void:
  if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
    card_pack_clicked.emit(description_text)
