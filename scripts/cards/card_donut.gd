extends "res://scripts/cards/card_base.gd"


var price: int = 0 # Will be set by donut type
var donut_menu: Constants.DonutMenu = Constants.DonutMenu.MILK

var current_donut_name: String
var flavor_texture: Texture2D

var is_fresh: bool = true
var grade: Constants.DonutGrade


func _ready():
  card_type = Constants.CardType.DONUT
  $FreshnessTimer.start()


func initialize(type: Constants.DonutMenu):
  donut_menu = type
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
  var data = Constants.DONUT_DATA[donut_menu]
  current_donut_name = data["name"]
  flavor_texture = data["texture"]
  price = data["price"]
  

func _setup_appearance():
  set_core_image(flavor_texture)
  
  $MenuName.text = current_donut_name
  $GradeLabel.text = _get_grade_name(grade)
  
  _setup_border()
  
  # Ensure the material is unique to this instance
  $CoreSprite.material = $CoreSprite.material.duplicate()
  
  # Activate shader only for PRESTIGE grade donuts
  var is_prestige = grade == Constants.DonutGrade.PRESTIGE
  ($CoreSprite.material as ShaderMaterial).set_shader_parameter("active", is_prestige)
  
  _update_freshness_visuals()


func _setup_border():
  var background_sprite = $BackgroundSprite
  var border_panel = $BorderPanel
  if border_panel and background_sprite and background_sprite.texture:
    var texture_size = background_sprite.texture.get_size()
    border_panel.size = texture_size
    border_panel.position = -texture_size / 2
    
    var stylebox = border_panel.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
    match grade:
      Constants.DonutGrade.BASIC:
        stylebox.border_color = Color("#808080")
      Constants.DonutGrade.PREMIUM:
        stylebox.border_color = Color("#ff0000")
      Constants.DonutGrade.PRESTIGE:
        stylebox.border_color = Color("#00ff00")
    border_panel.add_theme_stylebox_override("panel", stylebox)


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
