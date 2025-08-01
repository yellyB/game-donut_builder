extends "res://scripts/cards/card_base.gd"


signal increase_money(price: int)

var order_type: Constants.OrderType
var order_menu
var patience: int
var is_showing_wrong_order_effect = false


func _ready():
  card_type = Constants.CardType.CUSTOMER
  var customer_types = Constants.CUSTOMER_DATA.keys()
  var customer_type = customer_types[randi() % customer_types.size()]
  var customer_data = Constants.CUSTOMER_DATA[customer_type]

  patience = customer_data["patience"]
  set_core_image(customer_data["texture"])
  setup_order()
  $PatienceLabel.text = str(patience)
  $PatienceTimer.connect("timeout", self._on_patience_timer_timeout)


func setup_order():
  var is_specific_donut_request = randf() < 0.5
  if is_specific_donut_request:
    order_by_menu()
  else:
    order_by_property()


func can_overlap_with(_other_card: Node) -> bool:
  return false


func on_drag_ended():
  var overlapped_cards := get_overlapping_cards()
  for other in overlapped_cards:
    if not other.has_method("get_card_type") or other.get_card_type() != Constants.CardType.DONUT:
      continue

    var order_fulfilled = is_order_fulfilled(other.donut_menu)
    
    if order_fulfilled:
      var money_to_receive = calc_money_to_receive(other)
      increase_money.emit(money_to_receive)
      other.queue_free()
      queue_free()
    else:
      show_wrong_order_effect()


func show_wrong_order_effect():
  if is_showing_wrong_order_effect:
    return
    
  is_showing_wrong_order_effect = true
  
  # 빨간색 깜박임 효과
  var tween = create_tween()
  tween.set_loops(3)
  tween.tween_property(self, "modulate", Color.RED, 0.1)
  tween.tween_property(self, "modulate", Color.WHITE, 0.1)
  
  # 좌우 흔들림 효과
  var shake_tween = create_tween()
  shake_tween.set_loops(3)
  shake_tween.tween_property(self, "position:x", position.x + 10, 0.05)
  shake_tween.tween_property(self, "position:x", position.x - 10, 0.05)
  shake_tween.tween_property(self, "position:x", position.x, 0.05)
  
  # 효과 완료 후 상태 초기화
  await tween.finished
  is_showing_wrong_order_effect = false


func _on_patience_timer_timeout():
  patience -= 1
  $PatienceLabel.text = str(patience)
  if patience <= 0:
    # todo: 패널티 추가
    queue_free()


func order_by_menu():
  order_type = Constants.OrderType.DONUT_MENU
  var donut_menu = Constants.DonutMenu.values()
  order_menu = donut_menu[randi() % donut_menu.size()]
  var donut_name = Constants.DONUT_DATA[order_menu]["name"]
  $OrderedMenu.text = donut_name
  

func order_by_property():
  order_type = Constants.OrderType.DONUT_TAG
  var donut_tags = Constants.DonutTag.values()
  order_menu = donut_tags[randi() % donut_tags.size()]
  var tag_name = Constants.DonutTag.keys()[order_menu].capitalize()
  $OrderedMenu.text = tag_name + " 도넛!"


func is_order_fulfilled(other_donut_menu) -> bool:
  if order_type == Constants.OrderType.DONUT_MENU:
    if other_donut_menu == order_menu:
      return true
  elif order_type == Constants.OrderType.DONUT_TAG:
    var donut_data = Constants.DONUT_DATA[other_donut_menu]
    if donut_data["tags"].has(order_menu):
      return true
  return false


func calc_money_to_receive(other) -> int:
  assert(other.get_card_type() == Constants.CardType.DONUT, "손님이 받는 건 도넛이어야 한다.")

  var menu_price = other.price
  var fresh_bonus = 0
  var grade_bonus = 0
  if other.is_fresh:
    fresh_bonus = 5  # todo: 신선 도넛일때 추가금 얼마 붙을지? 고민 필요
  if other.grade == Constants.DonutGrade.PREMIUM:
    grade_bonus = 15  # todo: 고급 도넛일때 추가금 얼마 붙을지?
  if other.grade == Constants.DonutGrade.PRESTIGE:
    grade_bonus = 50  # todo: 명품 도넛일때 추가금 얼마 붙을지?
  return menu_price + fresh_bonus + grade_bonus
