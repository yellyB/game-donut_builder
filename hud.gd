extends CanvasLayer

const CardMaterial = preload("res://card_meterial.gd")
@onready var card_pack_grid = $MarginContainer/VBoxContainer/CardPackContainer
@onready var description_label = $MarginContainer/VBoxContainer/FooterContainer/Description
@onready var money_label = $TopBar/HBoxContainer/MoneyContainer/MoneyLabel
@onready var craft_list_container = $CraftListContainer
@onready var craft_list_vbox = $CraftListContainer/VBoxContainer
@export var cardpack_scene: PackedScene
var grid_manager: Node = null  # Main에서 할당
var card_data = [
  { "image": preload("res://images/card_pack_1.png"), "price": 1000, "description": "첫 번째 카드 설명: 123 123 123" },
  { "image": preload("res://images/card_pack_2.png"), "price": 3000, "description": "두 번째 카드 설명: 라라라 라라라랄" },
  { "image": preload("res://images/card_pack_3.png"), "price": 8000, "description": "세 번째 카드 설명: There is no harm." }
]


#region Godot's built-in functions
func _ready() -> void:
  _add_craft_item_nodes_to_list()
  TimerManager.time_updated.connect(_on_time_updated)
  update_money_display()
  for data in card_data:
    var card_pack = cardpack_scene.instantiate()
    card_pack.card_texture = data["image"]
    card_pack.description_text = data["description"]
    card_pack.card_pack_clicked.connect(_on_card_pack_gui_input)
    card_pack_grid.add_child(card_pack)
#endregion


#region Public functions
func initialize(grid_manager_node: Node) -> void:
  grid_manager = grid_manager_node
  _refresh_craft_list()


func update_money_display():
  money_label.text = str(GameState.money)


func update_timer_label(new_time) -> void:
  var timer_label = $TopBar/HBoxContainer/TimerContainer/TimerLabel
  var minutes = new_time / 60
  var seconds = new_time % 60
  timer_label.text = "%02d:%02d" % [minutes, seconds]
#endregion


#region Signal handlers
func _on_card_pack_gui_input(description) -> void:
  description_label.text = description


func _on_moeny_increase(price: int):
  GameState.add_money(price)
  update_money_display()
  
  
func _on_time_updated(new_time: int) -> void:
  update_timer_label(new_time)


func _on_button_pressed() -> void:
  grid_manager.spawn_material_cards(Constants.MaterialType.MILK, 1)


func _on_button_2_pressed() -> void:
  grid_manager.spawn_all_donut_types()


func _on_button_3_pressed() -> void:
  grid_manager.spawn_cards("CUSTOMER", 1)


func _on_craft_button_pressed() -> void:
  if craft_list_container.visible:
    craft_list_container.visible = false
  else:
    _refresh_craft_list()
    craft_list_container.visible = true


func _on_craft_item_pressed(donut_type_string: String) -> void:
  var donut_type_enum = Constants.DonutType.get(donut_type_string)
  
  var current_materials = grid_manager.get_current_material_counts()
  var recipe = Constants.DONUT_DATA[donut_type_enum]["recipe"]
  if _is_craftable(recipe, current_materials):
    grid_manager.craft_donut(donut_type_enum)
    _refresh_craft_list()
  else:
    print("Cannot craft %s, not enough materials." % donut_type_string)
  
  craft_list_container.visible = false
#endregion


#region Helper functions
func _add_craft_item_nodes_to_list() -> void:
  var all_donut_data = Constants.DONUT_DATA
  for donut_type_enum in all_donut_data:
    var donut_info = all_donut_data[donut_type_enum]
    var button = Button.new()
    
    button.text = donut_info["name"]
    button.custom_minimum_size = Vector2(0, 80)
    
    var donut_type_string = Constants.DonutType.find_key(donut_type_enum)
    button.set_meta("donut_type_string", donut_type_string)
    button.pressed.connect(_on_craft_item_pressed.bind(donut_type_string))
    
    craft_list_vbox.add_child(button)


func _get_recipe_text(donut_info: Dictionary, current_materials: Dictionary) -> String:
  var recipe = donut_info["recipe"]
  var recipe_text_parts = []
  var required_materials = {}
  for material_enum in recipe:
    required_materials[material_enum] = required_materials.get(material_enum, 0) + 1
    
  for material_enum in required_materials:
    var material_name = CardMaterial.get_all_material_data()[material_enum]["name"]
    var have_count = current_materials.get(material_enum, 0)
    var need_count = required_materials[material_enum]
    recipe_text_parts.append("%s: %d/%d" % [material_name, have_count, need_count])
    
  return "%s\n(%s)" % [donut_info["name"], ", ".join(recipe_text_parts)]


func _refresh_craft_list() -> void:
  var current_materials = grid_manager.get_current_material_counts()
  
  for button in craft_list_vbox.get_children():
    var donut_type_string = button.get_meta("donut_type_string")
    var donut_type_enum = Constants.DonutType.get(donut_type_string)
    var donut_info = Constants.DONUT_DATA[donut_type_enum]
    var recipe = donut_info["recipe"]
    
    button.text = _get_recipe_text(donut_info, current_materials)
    
    var can_craft = _is_craftable(recipe, current_materials)
    button.disabled = not can_craft


func _is_craftable(recipe: Array, available_materials: Dictionary) -> bool:
  var required = {}
  # 레시피에 필요한 재료 개수 카운트
  for material in recipe:
    required[material] = required.get(material, 0) + 1
  
  # 필요한 재료가 충분히 있는지 확인
  for material in required:
    if available_materials.get(material, 0) < required[material]:
      return false
      
  return true
#endregion
