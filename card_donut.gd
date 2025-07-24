extends "res://card_base.gd"

var price: int = 250
var donut_type: Constants.DonutType = Constants.DonutType.MILK

var donut_data = {
  Constants.DonutType.MILK: {
    "name": "우유도넛",
    "texture": preload("res://images/card_donut.png")
  },
  Constants.DonutType.STRAWBERRY: {
    "name": "딸기도넛",
    "texture": preload("res://images/card_donut.png")
  },
  Constants.DonutType.CHOCOLATE: {
    "name": "초코도넛",
    "texture": preload("res://images/card_donut.png")
  }
}

var current_donut_name: String
var current_donut_texture: Texture2D


func _ready():
  card_type = Constants.CardType.DONUT


func set_donut_type(type: Constants.DonutType):
  donut_type = type
  update_donut_data()
  update_appearance()


func update_donut_data():
  var data = donut_data[donut_type]
  current_donut_name = data["name"]
  current_donut_texture = data["texture"]


func update_appearance():
  var sprite_node = get_node("Sprite2D")
  if sprite_node:
    sprite_node.texture = current_donut_texture
  
  var label_node = get_node("Label")
  if label_node:
    label_node.text = current_donut_name


func can_overlap_with(other_card: Node) -> bool:
  return false
