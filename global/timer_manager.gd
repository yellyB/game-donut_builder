extends Node


signal time_updated(new_seconds: int)
signal time_finished

var timer_duration: int = 3
var remaining_seconds: int
var _timer: Timer


func _ready() -> void:
  # todo: 시작부터 바로 hud에 남은시간 표시되게 개선. 현재는 00:00부터 시작함 
  remaining_seconds = timer_duration
  
  _timer = Timer.new()
  _timer.wait_time = 1.0
  _timer.autostart = true
  _timer.one_shot = false
  _timer.timeout.connect(_on_timer_tick)
  add_child(_timer)


func _on_timer_tick() -> void:
  remaining_seconds -= 1
  emit_signal("time_updated", remaining_seconds)

  if remaining_seconds <= 0:
    _timer.stop()
    remaining_seconds = 0
    emit_signal("time_finished")
    _restart_timer()


func _restart_timer() -> void:
  remaining_seconds = timer_duration
  emit_signal("time_updated", remaining_seconds)
  _timer.start()
