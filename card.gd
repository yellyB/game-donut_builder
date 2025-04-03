extends Area2D


var dragging = false
var offset = Vector2.ZERO


func _input_event(viewport, event, shape_idx):
  if event is InputEventMouseButton:
    if event.button_index == MOUSE_BUTTON_LEFT:
      dragging = event.pressed
      offset = global_position - event.position
  elif event is InputEventScreenTouch:
    if event.pressed:
      dragging = true
      offset = global_position - event.position
    else:
      dragging = false
            

func _input(event):
  if not dragging: return
  if event is InputEventMouseMotion:
    global_position = event.position + offset
  elif event is InputEventScreenDrag:
    global_position = event.position + offset
