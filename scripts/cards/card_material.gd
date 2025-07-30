extends "res://scripts/cards/card_base.gd"


var material_type: Constants.MaterialType = Constants.MaterialType.MILK
var current_material_name: String
var current_material_texture: Texture2D
var price: int = 0
var grade: Constants.MaterialGrade = Constants.MaterialGrade.COMMON


func _ready():
  card_type = Constants.CardType.MATERIAL


func set_material_type(type: Constants.MaterialType):
  material_type = type
  update_material_data()
  update_appearance()


func update_material_data():
  var data = Constants.MATERIAL_DATA[material_type]
  current_material_name = data["name"]
  current_material_texture = data["texture"]
  price = data["price"]
  grade = data["grade"]


func update_appearance():
  $CoreSprite.texture = current_material_texture

  # var sprite_node = get_node("Sprite2D")
  # if sprite_node:
  #   sprite_node.texture = current_material_texture
  
  var label_node = get_node("Label")
  if label_node:
    label_node.text = current_material_name


func _get_grade_name(grade: Constants.MaterialGrade) -> String:
  match grade:
    Constants.MaterialGrade.COMMON:
      return "일반"
    Constants.MaterialGrade.UNCOMMON:
      return "고급"
    Constants.MaterialGrade.RARE:
      return "희귀"
    Constants.MaterialGrade.EPIC:
      return "전설"
    Constants.MaterialGrade.LEGENDARY:
      return "신화"
    _:
      return "알 수 없음"


func can_overlap_with(other_card: Node) -> bool:
  if other_card.get_card_type() == Constants.CardType.MATERIAL:
    return other_card.material_type == material_type
  return false
