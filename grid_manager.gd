extends Node2D


@export var grid_rows: int = 4
@export var grid_cols: int = 7
@export var card_scene: PackedScene

const SLOT_SIZE = Vector2(100, 150)
const SLOT_MARGIN_X = 10
const SLOT_MARGIN_Y = 50

var grid_slots = []
var START_POS = Vector2.ZERO


func _ready():
  create_grid()


func create_grid():
  grid_slots.clear()

  var total_width = grid_cols * SLOT_SIZE.x + (grid_cols - 1) * SLOT_MARGIN_X
  var total_height = grid_rows * SLOT_SIZE.y + (grid_rows - 1) * SLOT_MARGIN_Y
  var screen_size = get_viewport_rect().size

  START_POS = Vector2(
    (screen_size.x - total_width) / 2,
    (screen_size.y - total_height) / 2
  )

  for row in range(grid_rows):
    for col in range(grid_cols):
      var slot_pos = START_POS + Vector2(
        col * (SLOT_SIZE.x + SLOT_MARGIN_X),
        row * (SLOT_SIZE.y + SLOT_MARGIN_Y)
      )
      var add_card = row <= 2 and col <= 2  # todo: 아직은 하드코딩으로 카드 생성. 추후 동적 배치로 변경 필요
      var slot = create_slot(slot_pos, add_card)
      grid_slots.append(slot)


func get_card_size(card: Node2D) -> Vector2:
  # 카드가 Sprite2D, TextureRect, Control 등을 자식으로 가질 경우 처리
  for child in card.get_children():
    if child is Sprite2D:
      return child.texture.get_size()
    elif child is TextureRect:
      return child.texture.get_size()
    elif child is Control:
      return child.size
  return Vector2(100, 130)


func create_slot(pos: Vector2, add_card: bool = false) -> Node2D:
  var slot = Node2D.new()
  slot.position = pos
  add_child(slot)

  var bg = Sprite2D.new()
  #var bg = TextureRect.new()
  bg.texture = preload("res://images/card.png")
  
  bg.modulate.a = 0.3
  bg.z_index = -1
  bg.scale = SLOT_SIZE / bg.texture.get_size()
  
  #bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
  #bg.custom_minimum_size = SLOT_SIZE
  #bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
  #bg.modulate = Color(1, 1, 1, 0.3)
  
  slot.add_child(bg)

  if add_card and card_scene:
    var card = card_scene.instantiate()
    card.position = Vector2.ZERO
    var card_size = get_card_size(card)
    
    if card_size.x > 0 and card_size.y > 0:
      var scale_x = SLOT_SIZE.x / card_size.x
      var scale_y = SLOT_SIZE.y / card_size.y
      card.scale = Vector2(scale_x, scale_y)
    
    slot.add_child(card)

  return slot
