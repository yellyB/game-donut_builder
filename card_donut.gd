extends "res://card_base.gd"


var price: int = 0 # Will be set by donut type
var donut_type: Constants.DonutType = Constants.DonutType.MILK

var current_donut_name: String
var current_donut_texture: Texture2D

var is_fresh: bool = true


func _ready():
  card_type = Constants.CardType.DONUT
  $FreshnessTimer.timeout.connect(_on_freshness_timer_timeout)
  $FreshnessTimer.start()


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
  $MenuName.text = current_donut_name


func can_overlap_with(other_card: Node) -> bool:
  return false


func _on_freshness_timer_timeout():
  is_fresh = false
  $FreshLabel.visible = false
  _turnoff_freshness_effect()


func _turnoff_freshness_effect():
  $SparkleEffect.visible = false
  ($Sprite2D.material as ShaderMaterial).set_shader_parameter("active", false)
