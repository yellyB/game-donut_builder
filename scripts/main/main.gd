extends Node

@onready var grid_manager = $GridManager
@onready var hud = $HUD
@onready var start_screen = $StartScreen
@onready var trash_can = $TrashCan


func _ready():
  grid_manager.visible = false
  hud.visible = false
  trash_can.visible = false
  start_screen.visible = true


func _on_start_button_pressed():
  game_start()


func game_start():
  grid_manager.visible = true
  hud.visible = true
  trash_can.visible = true
  start_screen.visible = false
  
  grid_manager.initialize(hud)
  hud.initialize(grid_manager)
  TimerManager.start()
  

# 테스트용: 키보드 입력으로 재료 카드 생성
func _input(event):
  if event.is_action_pressed("ui_accept") and start_screen.visible:
    game_start()

  if event is InputEventKey and event.pressed:
    match event.keycode:
      KEY_1:
        $GridManager.spawn_material_cards(Constants.MaterialType.MILK)
        print("우유 카드 생성됨")
      KEY_2:
        $GridManager.spawn_material_cards(Constants.MaterialType.SUGAR)
        print("설탕 카드 생성됨")
      KEY_3:
        $GridManager.spawn_material_cards(Constants.MaterialType.FLOUR)
        print("밀가루 카드 생성됨")
      KEY_4:
        $GridManager.spawn_material_cards(Constants.MaterialType.STRAWBERRY)
        print("딸기 카드 생성됨")
      KEY_5:
        $GridManager.spawn_material_cards(Constants.MaterialType.CHOCOLATE)
        print("초콜릿 카드 생성됨")
      KEY_6:
        $GridManager.spawn_material_cards(Constants.MaterialType.MINT)
        print("민트 카드 생성됨")
