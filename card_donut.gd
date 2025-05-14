extends "res://card_base.gd"


var price:int = 250


func _ready():
  card_type = Constants.CardType.DONUT
    

func can_overlap_with(other_card: Node) -> bool:
  return false
