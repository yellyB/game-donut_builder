extends "res://card_base.gd"



func _ready():
  card_type = Constants.CardType.MATERIAL
    

func can_overlap_with(other_card: Node) -> bool:
  return true
