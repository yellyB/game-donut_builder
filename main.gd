extends Node


func _ready():
  $GridManager.initialize($HUD)
  $HUD.initialize($GridManager)


# 테스트용: 키보드 입력으로 재료 카드 생성
func _input(event):
  if event is InputEventKey and event.pressed:
    match event.keycode:
      KEY_1:
        $GridManager.spawn_material_cards(Constants.MaterialType.MILK, 1)
        print("우유 카드 생성됨")
      KEY_2:
        $GridManager.spawn_material_cards(Constants.MaterialType.SUGAR, 1)
        print("설탕 카드 생성됨")
      KEY_3:
        $GridManager.spawn_material_cards(Constants.MaterialType.FLOUR, 1)
        print("밀가루 카드 생성됨")
      KEY_4:
        $GridManager.spawn_material_cards(Constants.MaterialType.STRAWBERRY, 1)
        print("딸기 카드 생성됨")
      KEY_5:
        $GridManager.spawn_material_cards(Constants.MaterialType.CHOCOLATE, 1)
        print("초콜릿 카드 생성됨")
      KEY_6:
        $GridManager.spawn_material_cards(Constants.MaterialType.MINT, 1)
        print("민트 카드 생성됨")
