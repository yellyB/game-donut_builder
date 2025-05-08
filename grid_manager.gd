extends Node2D


const SLOT_MARGIN_X = 10
const SLOT_MARGIN_Y = 50

@export var grid_rows: int = 4
@export var grid_cols: int = 7
@export var card_scene_meterial: PackedScene
@export var card_scene_donut: PackedScene
@export var card_scene_customer: PackedScene
@export var slot_scene: PackedScene
var hud: Node = null  # Main에서 할당
var slot_size = Vector2(100, 150)  # todo: 아래에서 설정되기 때문에 아무값이나 넣어둠. 나중엔 제대로 된 값으로 수정필요
var grid_slots = []
var START_POS = Vector2.ZERO
var card_counter: int = 0


func _ready():
  set_slot_size_from_scene()


func set_slot_size_from_scene():
  var temp_slot = slot_scene.instantiate()
  if temp_slot.has_method("get_size"):
    slot_size = temp_slot.get_size()
  temp_slot.queue_free()


func create_grid():
  grid_slots.clear()

  var total_width = grid_cols * slot_size.x + (grid_cols - 1) * SLOT_MARGIN_X
  var total_height = grid_rows * slot_size.y + (grid_rows - 1) * SLOT_MARGIN_Y
  var screen_size = get_viewport_rect().size

  START_POS = Vector2(
    (screen_size.x - total_width) / 2,
    (screen_size.y - total_height) / 2
  )

  for row in range(grid_rows):
    for col in range(grid_cols):
      var slot_pos = START_POS + Vector2(
        col * (slot_size.x + SLOT_MARGIN_X),
        row * (slot_size.y + SLOT_MARGIN_Y)
      )
      var add_card = row <= 2 and col <= 2  # todo: 아직은 하드코딩으로 카드 생성. 추후 동적 배치로 변경 필요
      var slot = create_slot(slot_pos, add_card)
      grid_slots.append(slot)


func get_card_size(card: Node2D) -> Vector2:
  for child in card.get_children():
    if child is Sprite2D:
      return child.texture.get_size()
    elif child is TextureRect:
      return child.texture.get_size()
    elif child is Control:
      return child.size
  return Vector2(100, 130)


func create_slot(pos: Vector2, add_card: bool = false) -> Node2D:
  var slot = slot_scene.instantiate()
  slot.position = pos
  add_child(slot)

  if add_card:
    var card = create_card_for_slot("DONUT")
    if card:
      slot.add_child(card)

  return slot
  
  
func move_card_to_best_slot(card: Node2D):
  var card_rect = Rect2(card.global_position - (slot_size / 2), slot_size)
  var best_slot: Node2D = null
  var max_overlap = -1.0
  var current_slot = card.get_parent()

  for slot in grid_slots:
    if slot == current_slot:
      continue
    var slot_rect = Rect2(slot.global_position - (slot_size / 2), slot_size)
    var overlap = card_rect.intersection(slot_rect)

    if overlap and overlap.size.length() > 0:
      var overlap_area = overlap.size.x * overlap.size.y
      var overlapping_cards = []

      for child in slot.get_children():
        if child == card:
          continue
        if child.is_in_group("cards"):
          overlapping_cards.append(child)

      var can_place = true
      
      for existing_card in overlapping_cards:
        if not card.has_method("can_overlap_with") or not card.can_overlap_with(existing_card):
          can_place = false
          break

      if not can_place:
        print("슬롯에 카드가 있어서 못놓음:", slot.name)
        continue
        
      if can_place and overlap_area > max_overlap:
        max_overlap = overlap_area
        best_slot = slot

  if best_slot != null:
    card.get_parent().remove_child(card)
    best_slot.add_child(card)
    card.global_position = best_slot.global_position
  else:
    print("🔄 적절한 슬롯이 없어서 제자리 복귀!")
    if current_slot:
      card.global_position = current_slot.global_position


## NOTE:: hud를 연결해주는 main의 _ready 보다 grid_manager의 ready가 먼저 실행되어버려서 순서 제어용 처리를 추가.
func initialize(hud_node: Node) -> void:
  hud = hud_node
  create_initial_slots()


func create_initial_slots():
  create_grid()
    

func spawn_cards(card_type: String, count: int = 2) -> void:
  var created = 0
  for slot in grid_slots:
    var has_card := false
    for child in slot.get_children():
      if child.is_in_group("cards"):
        has_card = true
        break

    if not has_card:
      var card = create_card_for_slot(card_type)
      if card:
        slot.add_child(card)
        created += 1
        if created >= count:
          break


func create_card_for_slot(card_type: String) -> Node2D:
  var card: Node2D
  match card_type:
    "DONUT":
      card = card_scene_donut.instantiate()
    "MATERIAL":
      card = card_scene_meterial.instantiate()
    "CUSTOMER":
      card = card_scene_customer.instantiate()
    _:
      return null

  card.set_grid_manager(self)
  card.position = Vector2.ZERO
  card.connect("card_clicked", Callable(hud, "_on_card_clicked"))

  var card_size = get_card_size(card)
  if card_size.x > 0 and card_size.y > 0:
    var scale_x = slot_size.x / card_size.x
    var scale_y = slot_size.y / card_size.y
    card.scale = Vector2(scale_x, scale_y)

  # for debugg - todo: 추후 삭제필요
  var label = card.get_node("Label")
  if label and label is Label:
    label.text = str(card_counter)
    card_counter += 1

  return card
