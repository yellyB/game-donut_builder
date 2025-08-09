extends Node

@onready var grid_manager = $GridManager
@onready var hud = $HUD
@onready var start_screen = $StartScreen


func _ready():
  grid_manager.visible = false
  hud.visible = false
  start_screen.visible = true
  RoundTimerManager.time_finished.connect(_on_round_timer_timeout)


func _on_start_button_pressed():
  game_start()


func game_start():
  reset_game_state()
  
  grid_manager.visible = true
  hud.visible = true
  start_screen.visible = false
  
  grid_manager.main = self
  grid_manager.initialize(hud)
  hud.initialize(grid_manager)
  CustomerSpawnTimer.start()
  RoundTimerManager.start()
  
  $GridManager.spawn_special_card(Constants.SpecialCardType.TRASHCAN)


func reset_game_state():
  # 게임 일시정지 해제
  # get_tree().paused = false
  randomize()
  GameState.reset()
  UserData.reset()
  CustomerSpawnTimer.reset()
  RoundTimerManager.reset()
  GameState.set_next_round_clear_reputation_goal(2)
  hud.update_money_display()
  hud.update_rep_display()


# 테스트용: 키보드 입력으로 재료 카드 생성
func _input(event):
  if event.is_action_pressed("ui_accept") and start_screen.visible:
    game_start()

  if event is InputEventKey and event.pressed:
    match event.keycode:
      KEY_1:
        $GridManager.spawn_material_card(Constants.MaterialType.MILK)
        print("우유 카드 생성됨")
      KEY_2:
        $GridManager.spawn_material_card(Constants.MaterialType.SUGAR)
        print("설탕 카드 생성됨")
      KEY_3:
        $GridManager.spawn_material_card(Constants.MaterialType.FLOUR)
        print("밀가루 카드 생성됨")
      KEY_4:
        $GridManager.spawn_material_card(Constants.MaterialType.STRAWBERRY)
        print("딸기 카드 생성됨")
      KEY_5:
        $GridManager.spawn_material_card(Constants.MaterialType.CHOCOLATE)
        print("초콜릿 카드 생성됨")
      KEY_6:
        $GridManager.spawn_material_card(Constants.MaterialType.MINT)
        print("민트 카드 생성됨")


func _on_round_timer_timeout():
  game_over()


func game_over():
  print("GAME OVER!")
  hud.show_game_over_screen()
  get_tree().paused = true


func _on_round_cleared():
  hud.show_game_clear_screen()
  get_tree().paused = true
  CustomerSpawnTimer.stop()
  RoundTimerManager.stop()


func _on_hud_game_continue() -> void:
  get_tree().paused = false
  GameState.set_next_round_clear_reputation_goal(GameState.round_clear_reputation_goal + 2)
  CustomerSpawnTimer.start()
  RoundTimerManager.start()
  

func _on_rep_increase(value: int):
  # 평판이 음수가 되면 게임 오버. 이 케이스로 게임 오버 시, 평판 망한 엔딩 노출.
  if UserData.reputation < 0:
    game_over()
    return
    
  # 평판이 목표치에 도달하면 라운드 클리어
  if UserData.reputation >= GameState.round_clear_reputation_goal:
    _on_round_cleared()
