extends "res://card_base.gd"


var price: int = 0 # Will be set by donut type
var donut_type: Constants.DonutType = Constants.DonutType.MILK

var current_donut_name: String
var current_donut_texture: Texture2D


func _ready():
  card_type = Constants.CardType.DONUT


func set_donut_type(type: Constants.DonutType):
  donut_type = type
  _setup_donut_data()
  _setup_appearance()


func _setup_donut_data():
  var data = Constants.DONUT_DATA[donut_type]
  current_donut_name = data["name"]
  current_donut_texture = data["texture"]
  price = data["price"]


func _setup_appearance():
  var sprite_node = get_node("Sprite2D")
  if sprite_node:
    sprite_node.texture = current_donut_texture
  
  var label_node = get_node("Label")
  if label_node:
    label_node.text = current_donut_name


func can_overlap_with(other_card: Node) -> bool:
  return false
