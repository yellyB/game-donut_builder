extends "res://card_base.gd"

static var donut_data = {
  Constants.DonutType.MILK: {
    "name": "우유도넛",
    "texture": preload("res://images/card/donut/card_donut_milk.png"),
    "recipe": [Constants.MaterialType.MILK, Constants.MaterialType.SUGAR, Constants.MaterialType.FLOUR]
  },
  Constants.DonutType.STRAWBERRY: {
    "name": "딸기도넛",
    "texture": preload("res://images/card/donut/card_donut_strawberry.png"),
    "recipe": [Constants.MaterialType.MILK, Constants.MaterialType.SUGAR, Constants.MaterialType.FLOUR, Constants.MaterialType.STRAWBERRY]
  },
  Constants.DonutType.CHOCOLATE: {
    "name": "초코도넛",
    "texture": preload("res://images/card/donut/card_donut_chocolate.png"),
    "recipe": [Constants.MaterialType.MILK, Constants.MaterialType.SUGAR, Constants.MaterialType.FLOUR, Constants.MaterialType.CHOCOLATE]
  },
  Constants.DonutType.MINT: {
    "name": "민트도넛",
    "texture": preload("res://images/card/donut/card_donut_mint.png"),
    "recipe": [Constants.MaterialType.MILK, Constants.MaterialType.SUGAR, Constants.MaterialType.FLOUR, Constants.MaterialType.MINT]
  }
}

static func get_all_donut_data() -> Dictionary:
  return donut_data

var price: int = 250
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
  var data = donut_data[donut_type]
  current_donut_name = data["name"]
  current_donut_texture = data["texture"]


func _setup_appearance():
  var sprite_node = get_node("Sprite2D")
  if sprite_node:
    sprite_node.texture = current_donut_texture
  
  var label_node = get_node("Label")
  if label_node:
    label_node.text = current_donut_name


func can_overlap_with(other_card: Node) -> bool:
  return false
