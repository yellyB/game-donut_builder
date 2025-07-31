extends "res://scripts/cards/card_base.gd"


var core_texture: Texture2D


func _ready():
  card_type = Constants.CardType.SPECIAL 


func initialize(type: Constants.SpecialCardType):
  _setup_appearance()


func _setup_appearance():
  var core_texture = preload("res://images/trash_can.png")
  set_core_image(core_texture)


func can_overlap_with(other_card: Node) -> bool:
  return false


func on_drag_ended():
  var overlapped_cards := get_overlapping_cards()
  for other in overlapped_cards:
    if not other.has_method("get_card_type") or other.get_card_type() == Constants.CardType.CUSTOMER:
      continue
    other.queue_free()
    
