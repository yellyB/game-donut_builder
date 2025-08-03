extends Node


signal time_updated(new_seconds: int)
signal time_finished

var timer_duration: int = 3
var remaining_seconds: int
var _timer: Timer


func _ready() -> void:
  remaining_seconds = timer_duration
  
  _timer = Timer.new()
  _timer.wait_time = 1.0
  _timer.autostart = false
  _timer.one_shot = false
  _timer.timeout.connect(_on_timer_tick)
  add_child(_timer)


func start():
  emit_signal("time_updated", remaining_seconds)
  _timer.start()


func stop():
  _timer.stop()
  remaining_seconds = timer_duration


func _on_timer_tick() -> void:
  remaining_seconds -= 1

  if remaining_seconds < 0:
    remaining_seconds = timer_duration

  emit_signal("time_updated", remaining_seconds)

  if remaining_seconds == 0:
    emit_signal("time_finished")
