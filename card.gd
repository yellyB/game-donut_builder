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
  
  for card in get_tree().get_nodes_in_group("cards"):
    if card.has_method("clear_highlight"):
      card.clear_highlight()


func _end_drag(pos: Vector2):
  is_dragging = false
  monitoring = true
  call_deferred("check_overlap")
  
  # todo: 1초 뒤 카드 하이라이트 제거
  
  
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
  for area in overlaps:
    var is_valid = area != self and area.is_in_group("cards") and (not area.has_method("is_dragging_now") or not area.is_dragging_now())
    if is_valid:
      print("겹침 감지! -> ", area.name)
      if area.has_method("highlight"):
        area.highlight()


func highlight():
  modulate = Color(1, 0.6, 0.6)


func clear_highlight():
  modulate = Color(1, 1, 1)
