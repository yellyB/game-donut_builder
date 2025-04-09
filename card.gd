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
  z_index = 999
  
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
  var max_overlap = 0.0
  var most_overlapped_card: Area2D = null
  
  for area in overlaps:
    if area == self or not area.is_in_group("cards"):
      continue
    if area.has_method("is_dragging_now") and area.is_dragging_now():
      continue

    # 겹친 영역 계산
    var overlap_rect = get_overlap_rect(self, area)
    var overlap_area = overlap_rect.size.x * overlap_rect.size.y

    if overlap_area > max_overlap:
      max_overlap = overlap_area
      most_overlapped_card = area

  if most_overlapped_card and most_overlapped_card.has_method("set_highlight"):
    most_overlapped_card.set_highlight("overlap")


func get_overlap_rect(a: Area2D, b: Area2D) -> Rect2:
  var a_rect = a.get_global_rect()
  var b_rect = b.get_global_rect()
  return a_rect.intersection(b_rect)
  
  
func get_global_rect() -> Rect2:
  var sprite = get_node_or_null("Sprite2D")
  if sprite and sprite.texture:
    var size = sprite.texture.get_size() * sprite.scale
    var top_left = global_position - (size * 0.5)
    return Rect2(top_left, size)
  return Rect2(global_position, Vector2(100, 130))  # fallback 사이즈
    

func set_highlight(type := "overlap"):
  match type:
    "drag":
      modulate = Color(0.6, 0.8, 1.0)
    "overlap":
      modulate = Color(1, 0.6, 0.6) 


func clear_highlight():
  modulate = Color(1, 1, 1)
