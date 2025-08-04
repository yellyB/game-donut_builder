extends CanvasLayer


signal game_continue

@onready var card_pack_grid = $MarginContainer/VBoxContainer/CardPackContainer
@onready var description_label = $MarginContainer/VBoxContainer/FooterContainer/Description
@onready var money_label = $TopBar/HBoxContainer/MoneyContainer/MoneyLabel
@onready var rep_label = $TopBar/HBoxContainer/RepContainer/RepLabel
@onready var rep_goal_label = $TopBar/HBoxContainer/RepContainer/RepGoalLabel
@onready var craft_list_container = $CraftListContainer
@onready var craft_list_vbox = $CraftListContainer/VBoxContainer
@onready var purchase_button = $MarginContainer/VBoxContainer/FooterContainer/PurchaseButton
@onready var game_over_screen = $GameOverScreen
@onready var game_clear_screen = $GameClearScreen

@export var cardpack_scene: PackedScene

var grid_manager: Node = null  # Main에서 할당
var selected_card_pack_index = -1  # 선택된 카드 팩 인덱스
var card_packs_data = [
  { "image": preload("res://images/card/pack/card_pack_1.png"), "price": 1, "description": "일반 재료 팩: 일반 등급 재료 3개", "grade": Constants.MaterialGrade.COMMON },
  { "image": preload("res://images/card/pack/card_pack_2.png"), "price": 2, "description": "고급 재료 팩: 고급 등급 재료 3개", "grade": Constants.MaterialGrade.UNCOMMON },
  { "image": preload("res://images/card/pack/card_pack_3.png"), "price": 3, "description": "희귀 재료 팩: 희귀 등급 재료 3개", "grade": Constants.MaterialGrade.RARE },
  { "image": preload("res://images/card/pack/card_pack_1.png"), "price": 5, "description": "전설 재료 팩: 전설 등급 재료 3개", "grade": Constants.MaterialGrade.EPIC },
  { "image": preload("res://images/card/pack/card_pack_2.png"), "price": 10, "description": "신화 재료 팩: 신화 등급 재료 3개", "grade": Constants.MaterialGrade.LEGENDARY }
]

#region Godot's built-in functions
func _ready() -> void:
  _add_craft_item_nodes_to_list()
  RoundTimerManager.time_updated.connect(_on_round_time_updated)
  CustomerSpawnTimer.time_updated.connect(_on_customer_spawn_time_updated)
  GameState.reputation_goal_changed.connect(_on_reputation_goal_changed)
  update_money_display()
  update_rep_display()
  
  # 구매 버튼 초기 상태 설정
  purchase_button.disabled = true
  description_label.text = "카드 팩을 선택하세요"
  
  # 동적 카드 팩 레이아웃 설정
  # 컨테이너가 수평으로 확장되도록 설정
  card_pack_grid.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
  
  # GridContainer의 경우 열 수를 카드 수에 맞게 동적으로 설정
  if card_pack_grid is GridContainer:
    card_pack_grid.columns = card_packs_data.size()
  
  for data in card_packs_data:
    var card_pack = cardpack_scene.instantiate()
    card_pack.card_texture = data["image"]
    card_pack.description_text = data["description"]
    card_pack.card_pack_clicked.connect(_on_card_pack_gui_input)
    
    # 각 카드 팩이 컨테이너의 공간을 균등하게 채우도록 설정
    card_pack.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
    
    card_pack_grid.add_child(card_pack)
#endregion


#region Public functions
func initialize(grid_manager_node: Node) -> void:
  grid_manager = grid_manager_node
  rep_goal_label.text = str(GameState.round_clear_reputation_goal)
  _refresh_craft_list()


func update_money_display():
  money_label.text = _format_number_with_commas(UserData.money)


func update_rep_display():
  rep_label.text = str(UserData.reputation)


func update_customer_timer_label(new_time) -> void:
  var timer_label = $CustomerTimerContainer/TimerLabel
  var minutes = new_time / 60
  var seconds = new_time % 60
  timer_label.text = "%02d:%02d" % [minutes, seconds]
  
  
func update_round_timer_label(new_time) -> void:
  var timer_label = $TopBar/HBoxContainer/TimerContainer/TimerLabel
  var minutes = new_time / 60
  var seconds = new_time % 60
  timer_label.text = "%02d:%02d" % [minutes, seconds]
#endregion


#region Signal handlers
func _on_card_pack_gui_input(description) -> void:
  description_label.text = description
  
  # 카드 팩 선택 로직
  for i in range(card_packs_data.size()):
    if card_packs_data[i]["description"] == description:
      selected_card_pack_index = i
      var pack_price = card_packs_data[i]["price"]
      description_label.text = "%s (가격: %d원)" % [description, pack_price]
      purchase_button.disabled = false
      break


func _on_purchase_button_pressed() -> void:
  if selected_card_pack_index == -1:
    return
    
  var pack_price = card_packs_data[selected_card_pack_index]["price"]
  var pack_grade = card_packs_data[selected_card_pack_index]["grade"]
  
  if UserData.money >= pack_price:
    UserData.add_money(-pack_price)
    update_money_display()
    
    # 선택된 등급의 재료 카드 3개 생성
    grid_manager.spawn_material_cards_by_grade(3, pack_grade)
    
    description_label.text = "구매 완료! %s 등급 재료 3개가 추가되었습니다." % _get_grade_name(pack_grade)
    purchase_button.disabled = true
    selected_card_pack_index = -1
  else:
    description_label.text = "돈이 부족합니다!"


func _on_moeny_increase(price: int):
  update_money_display()
  

func _on_rep_increase(rep: int):
  update_rep_display()
  
  
func _on_customer_spawn_time_updated(new_time: int) -> void:
  update_customer_timer_label(new_time)


func _on_round_time_updated(new_time: int) -> void:
  update_round_timer_label(new_time)


func _on_reputation_goal_changed(new_goal: int) -> void:
  rep_goal_label.text = str(new_goal)
  

func _on_button_pressed() -> void:
  grid_manager.spawn_material_card(Constants.MaterialType.MILK)


func _on_button_2_pressed() -> void:
  grid_manager.spawn_all_donut_menus()


func _on_button_3_pressed() -> void:
  grid_manager.spawn_customer_card()


func _on_craft_button_pressed() -> void:
  if craft_list_container.visible:
    craft_list_container.visible = false
  else:
    _refresh_craft_list()
    craft_list_container.visible = true


func show_game_over_screen():
  game_over_screen.visible = true


func show_game_clear_screen():
  game_clear_screen.visible = true


func _on_restart_button_pressed():
  GameState.reset()
  CustomerSpawnTimer.stop()
  get_tree().paused = false
  get_tree().reload_current_scene()


func _on_continue_button_pressed() -> void:
  RoundTimerManager.start()
  get_tree().paused = false
  game_clear_screen.visible = false
  emit_signal("game_continue")


func _on_craft_item_pressed(donut_menu_string: String) -> void:
  var donut_menu_enum = Constants.DonutMenu.get(donut_menu_string)
  
  var current_materials = grid_manager.get_current_material_counts()
  var recipe = Constants.DONUT_DATA[donut_menu_enum]["recipe"]
  if _is_craftable(recipe, current_materials):
    grid_manager.craft_donut(donut_menu_enum)
    _refresh_craft_list()
  else:
    print("Cannot craft %s, not enough materials." % donut_menu_string)
  
  craft_list_container.visible = false
#endregion


#region Helper functions
func _add_craft_item_nodes_to_list() -> void:
  var all_donut_data = Constants.DONUT_DATA
  for donut_menu_enum in all_donut_data:
    var donut_info = all_donut_data[donut_menu_enum]
    var button = Button.new()
    
    button.text = donut_info["name"]
    button.custom_minimum_size = Vector2(0, 80)
    
    var donut_menu_string = Constants.DonutMenu.find_key(donut_menu_enum)
    button.set_meta("donut_menu_string", donut_menu_string)
    button.pressed.connect(_on_craft_item_pressed.bind(donut_menu_string))
    
    craft_list_vbox.add_child(button)


func _get_recipe_text(donut_info: Dictionary, current_materials: Dictionary) -> String:
  var recipe = donut_info["recipe"]
  var recipe_text_parts = []
  var required_materials = {}
  for material_enum in recipe:
    required_materials[material_enum] = required_materials.get(material_enum, 0) + 1
    
  for material_enum in required_materials:
    var material_name = Constants.MATERIAL_DATA[material_enum]["name"]
    var have_count = current_materials.get(material_enum, 0)
    var need_count = required_materials[material_enum]
    recipe_text_parts.append("%s: %d/%d" % [material_name, have_count, need_count])
    
  return "%s\n(%s)" % [donut_info["name"], ", ".join(recipe_text_parts)]


func _refresh_craft_list() -> void:
  var current_materials = grid_manager.get_current_material_counts()
  
  for button in craft_list_vbox.get_children():
    var donut_menu_string = button.get_meta("donut_menu_string")
    var donut_menu_enum = Constants.DonutMenu.get(donut_menu_string)
    var donut_info = Constants.DONUT_DATA[donut_menu_enum]
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


func _format_number_with_commas(number: int) -> String:
  var number_str = str(number)
  var formatted_number = ""
  var count = 0
  
  for i in range(number_str.length() - 1, -1, -1):
    if count > 0 and count % 3 == 0:
      formatted_number = "," + formatted_number
    formatted_number = number_str[i] + formatted_number
    count += 1
  
  return formatted_number
#endregion

