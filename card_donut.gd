extends "res://card_base.gd"


func _ready():
  card_type = Constants.CardType.DONUT
    

func can_overlap_with(other_card: Node) -> bool:
  return false
