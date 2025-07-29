extends "res://card_base.gd"


var price: int = 0 # Will be set by donut type
var donut_type: Constants.DonutType = Constants.DonutType.MILK

var current_donut_name: String
var current_donut_texture: Texture2D

var is_fresh: bool = true
var grade: Constants.DonutGrade


func _ready():
  card_type = Constants.CardType.DONUT
  $FreshnessTimer.start()


func set_donut_type(type: Constants.DonutType):
  donut_type = type
  _set_random_grade()
  _setup_donut_data()
  _setup_appearance()


func _set_random_grade():
  var rand = randf()
  if rand < 0.3:
    grade = Constants.DonutGrade.BASIC
  elif rand < 0.5:
    grade = Constants.DonutGrade.PREMIUM
  else:
    grade = Constants.DonutGrade.PRESTIGE


func _setup_donut_data():
  var data = Constants.DONUT_DATA[donut_type]
  current_donut_name = data["name"]
  current_donut_texture = data["texture"]
  price = data["price"]


func _setup_appearance():
  var sprite_node = get_node("Sprite2D")
  if sprite_node:
    sprite_node.texture = current_donut_texture
  $MenuName.text = current_donut_name
  $GradeLabel.text = _get_grade_name(grade)
  
  # Ensure the material is unique to this instance
  $Sprite2D.material = $Sprite2D.material.duplicate()
  
  # Activate shader only for PRESTIGE grade donuts
  var is_prestige = grade == Constants.DonutGrade.PRESTIGE
  ($Sprite2D.material as ShaderMaterial).set_shader_parameter("active", is_prestige)
  
  _update_freshness_visuals()


func can_overlap_with(other_card: Node) -> bool:
  return false


func _on_freshness_timer_timeout():
  is_fresh = false
  _update_freshness_visuals()


func _update_freshness_visuals():
  $FreshLabel.visible = is_fresh
  $SparkleEffect.emitting = is_fresh


func _get_grade_name(grade: Constants.DonutGrade) -> String:
  match grade:
    Constants.DonutGrade.BASIC:
      return "기본"
    Constants.DonutGrade.PREMIUM:
      return "고급"
    Constants.DonutGrade.PRESTIGE:
      return "명품"
    _:
      assert(true, "Unknown grade: " + str(grade))
      return "알 수 없음"
