extends "res://card_base.gd"



func _ready():
  card_type = Constants.CardType.MATERIAL
    

func can_overlap_with(other_card: Node) -> bool:
  if other_card.get_card_type() == Constants.CardType.MATERIAL:
    return true
  else:
    return false
