extends "res://card_base.gd"


signal increase_money(price: int)

var order_type: Constants.OrderType
var order_value
var patience: int


func _ready():
  card_type = Constants.CardType.CUSTOMER
  var customer_types = Constants.CUSTOMER_DATA.keys()
  var customer_type = customer_types[randi() % customer_types.size()]
  patience = Constants.CUSTOMER_DATA[customer_type]["patience"]
  $PatienceLabel.text = str(patience)
  setup_order()
  $PatienceTimer.connect("timeout", self._on_patience_timer_timeout)


func setup_order():
  var is_specific_donut_request = randf() < 0.5
  if is_specific_donut_request:
    order_type = Constants.OrderType.DONUT_TYPE
    var donut_types = Constants.DonutType.values()
    order_value = donut_types[randi() % donut_types.size()]
    
    var donut_name = Constants.DONUT_DATA[order_value]["name"]
    $Property.text = donut_name
  else:
    order_type = Constants.OrderType.DONUT_TAG
    var donut_tags = Constants.DonutTag.values()
    order_value = donut_tags[randi() % donut_tags.size()]
    
    var tag_name = Constants.DonutTag.keys()[order_value].capitalize()
    $Property.text = tag_name + " 도넛!"


func can_overlap_with(_other_card: Node) -> bool:
  return false


func on_drag_ended():
  var overlapped_cards := get_overlapping_cards()
  for other in overlapped_cards:
    if not other.has_method("get_card_type") or other.get_card_type() != Constants.CardType.DONUT:
      continue

    var order_fulfilled = false
    if order_type == Constants.OrderType.DONUT_TYPE:
      if other.donut_type == order_value:
        order_fulfilled = true
    elif order_type == Constants.OrderType.DONUT_TAG:
      var donut_data = Constants.DONUT_DATA[other.donut_type]
      if donut_data["tags"].has(order_value):
        order_fulfilled = true

    if order_fulfilled:
      increase_money.emit(other.price)
      other.queue_free()
      queue_free()
      return


func _on_patience_timer_timeout():
  patience -= 1
  $PatienceLabel.text = str(patience)
  if patience <= 0:
    # todo: 패널티 추가
    queue_free()