extends Area2D


enum CardType { MATERIAL, DONUT, CUSTOMER }

var is_dragging = false
var offset = Vector2.ZERO
var card_type: CardType = CardType.MATERIAL


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
  var overlaps = get_overlapping_areas()
  var top_card: Area2D = null
  var top_z = -INF
  
  for area in overlaps:
    if area == self or not area.is_in_group("cards"):
      continue
    if area.has_method("is_dragging_now") and area.is_dragging_now():
      continue

    if area.z_index > top_z:
      top_z = area.z_index
      top_card = area

  if top_card and top_card.has_method("set_highlight"):
    top_card.set_highlight("overlap")


func set_highlight(type := "overlap"):
  match type:
    "drag":
      modulate = Color(0.6, 0.8, 1.0)
    "overlap":
      modulate = Color(1, 0.6, 0.6) 


func clear_highlight():
  modulate = Color(1, 1, 1)
