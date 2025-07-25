extends "res://card_base.gd"

var material_type: Constants.MaterialType = Constants.MaterialType.MILK

static var material_data = {
  Constants.MaterialType.MILK: {
    "name": "우유",
    "texture": preload("res://images/card/meterial/card_meterial_milk.png")
  },
  Constants.MaterialType.SUGAR: {
    "name": "설탕",
    "texture": preload("res://images/card/meterial/card_meterial_sugar.png")
  },
  Constants.MaterialType.FLOUR: {
    "name": "밀가루",
    "texture": preload("res://images/card/meterial/card_meterial_flour.png")
  },
  Constants.MaterialType.STRAWBERRY: {
    "name": "딸기",
    "texture": preload("res://images/card/meterial/card_meterial_strawberry.png")
  },
  Constants.MaterialType.CHOCOLATE: {
    "name": "초콜릿",
    "texture": preload("res://images/card/meterial/card_meterial_chocolate.png")
  },
  Constants.MaterialType.MINT: {
    "name": "민트",
    "texture": preload("res://images/card/meterial/card_meterial_mint.png")
  }
}

static func get_all_material_data() -> Dictionary:
  return material_data

var current_material_name: String
var current_material_texture: Texture2D


func _ready():
  card_type = Constants.CardType.MATERIAL


func set_material_type(type: Constants.MaterialType):
  material_type = type
  update_material_data()
  update_appearance()


func update_material_data():
  var data = material_data[material_type]
  current_material_name = data["name"]
  current_material_texture = data["texture"]


func update_appearance():
  var sprite_node = get_node("Sprite2D")
  if sprite_node:
    sprite_node.texture = current_material_texture
  
  var label_node = get_node("Label")
  if label_node:
    label_node.text = current_material_name


func can_overlap_with(other_card: Node) -> bool:
  if other_card.get_card_type() == Constants.CardType.MATERIAL:
    return other_card.material_type == material_type
  return false
