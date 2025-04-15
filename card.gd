extends Area2D


enum CardType { MATERIAL, DONUT, CUSTOMER }

var is_dragging = false
var offset = Vector2.ZERO
var card_type: CardType = CardType.MATERIAL
var grid_manager: Node = null


func _ready():
  add_to_group("cards")
  monitoring = true
  set_deferred("monitorable", true)


func _start_drag(pos: Vector2):
  is_dragging = true
  offset = global_position - pos
  monitoring = false
  set_highlight("drag")
  
  set_z_as_relative(false)
  z_index = GameState.get_next_z_index()
  
  for card in get_tree().get_nodes_in_group("cards"):
    if card != self and card.has_method("clear_highlight"):
      card.clear_highlight()


func _end_drag(pos: Vector2):
  is_dragging = false
  monitoring = true
  call_deferred("check_overlap")
  clear_highlight()
  
  if grid_manager:
    grid_manager.move_card_to_best_slot(self)
  
  
func _input_event(viewport, event, shape_idx):
  if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT) \
      or event is InputEventScreenTouch:
    if event.pressed:
      _start_drag(event.position)
    else:
      _end_drag(event.position)
          

func _process(delta):
  if is_dragging:
    global_position = get_global_mouse_position() + offset
    
    
func is_dragging_now() -> bool:
  return is_dragging
  

func check_overlap():
  var max_overlap = 0.0
  var best_slot: Node = null

  for area in get_tree().get_nodes_in_group("slots"):
    if not area.has_method("get_overlap_area"):
      continue

    var overlap = area.get_overlap_area(self)
    if overlap > max_overlap:
      max_overlap = overlap
      best_slot = area
      
  if best_slot:
    global_position = best_slot.global_position


func set_highlight(type := "overlap"):
  match type:
    "drag":
      modulate = Color(0.6, 0.8, 1.0)
    "overlap":
      modulate = Color(1, 0.6, 0.6) 


func clear_highlight():
  modulate = Color(1, 1, 1)
  

func get_rect() -> Rect2:
  var size = Vector2.ZERO
  for child in get_children():
    if child is Sprite2D:
      size = child.texture.get_size() * scale
      break
  return Rect2(global_position - size / 2, size)
  
  
func get_card_type() -> CardType:
  return card_type


func can_overlap_with(other_card: Node) -> bool:
  if not other_card.has_method("get_card_type"):
    return false
    
  var other_type = other_card.get_card_type()

  match card_type:
    CardType.MATERIAL:
      return false
    CardType.CUSTOMER:
      return other_type == CardType.DONUT
    CardType.DONUT:
      return other_type == CardType.CUSTOMER
      
  return false


func set_grid_manager(manager: Node):
  grid_manager = manager
