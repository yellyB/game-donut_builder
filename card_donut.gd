extends "res://card_base.gd"


signal card_clicked


func _ready():
  card_type = "DONUT"
    

func can_overlap_with(other_card: Node) -> bool:
  return false


# todo: 도넛을 손님 카드에 충돌 시 다음 동작 수행하도록 수
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
  if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
    card_clicked.emit()
