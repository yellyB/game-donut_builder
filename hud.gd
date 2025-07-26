extends CanvasLayer

const CardDonut = preload("res://card_donut.gd")
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


func _add_craft_item_nodes_to_list() -> void:
  var all_donut_data = CardDonut.get_all_donut_data()
  for donut_type_enum in all_donut_data:
    var donut_info = all_donut_data[donut_type_enum]
    var button = Button.new()
    button.text = donut_info["name"] # todo: 레시피 정보도 추가
    button.custom_minimum_size = Vector2(0, 80)
    
    var donut_type_string = Constants.DonutType.find_key(donut_type_enum)
    button.pressed.connect(_on_craft_item_pressed.bind(donut_type_string))
    
    craft_list_vbox.add_child(button)


func _on_card_pack_gui_input(description) -> void:
  description_label.text = description


func _on_moeny_increase(price: int):
  GameState.add_money(price)
  update_money_display()
  
  
func _on_time_updated(new_time: int) -> void:
  update_timer_label(new_time)
  

func update_timer_label(new_time) -> void:
  var timer_label = $TopBar/HBoxContainer/TimerContainer/TimerLabel
  var minutes = new_time / 60
  var seconds = new_time % 60
  timer_label.text = "%02d:%02d" % [minutes, seconds]


func update_money_display():
  money_label.text = str(GameState.money)


func _on_button_pressed() -> void:
  grid_manager.spawn_material_cards(Constants.MaterialType.MILK, 1)


func _on_button_2_pressed() -> void:
  grid_manager.spawn_all_donut_types()


func _on_button_3_pressed() -> void:
  grid_manager.spawn_cards("CUSTOMER", 1)
  


func _on_craft_button_pressed() -> void:
  craft_list_container.visible = not craft_list_container.visible


func _on_craft_item_pressed(donut_type: String) -> void:
  craft_list_container.visible = false
  var donut_enum_val = Constants.DonutType.get(donut_type)
  # todo: 실제 제작 로직 추가 (예: grid_manager.craft_item(donut_enum_val))
  print("제작 아이템 클릭됨: ", donut_type, " (", donut_enum_val, ")")


func initialize(grid_manager_node: Node) -> void:
  grid_manager = grid_manager_node
