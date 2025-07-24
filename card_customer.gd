extends "res://card_base.gd"


signal increase_money(price: int)


func _ready():
  card_type = Constants.CardType.CUSTOMER
    

func can_overlap_with(other_card: Node) -> bool:
  return false
  

func on_drag_ended():
  var overlapped_cards := get_overlapping_cards()
  for other in overlapped_cards:
    if other.has_method("get_card_type") and other.get_card_type() == Constants.CardType.DONUT:
      increase_money.emit(other.price)
      other.queue_free()
      queue_free()

