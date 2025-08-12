extends Control

signal popup_closed

@onready var reputation_goal_label = $CenterContainer/PopupPanel/VBoxContainer/ReputationGoalLabel

func _ready():
  # 팝업이 처음에는 숨겨져 있도록 설정
  visible = false

func show_popup(reputation_goal: int):
  print("팝업 표시 시작")
  # 평판 목표 텍스트 업데이트
  reputation_goal_label.text = "평판 %d 달성하기" % reputation_goal
  
  # 팝업 표시
  visible = true
  print("팝업 visible = true 설정됨")
  
  # 게임 일시정지
  get_tree().paused = true
  print("게임 일시정지됨")

func _on_confirm_button_pressed():
  print("확인 버튼 클릭됨!")
  # 팝업 숨기기
  visible = false
  print("팝업 숨김됨")
  
  # 게임 재개
  get_tree().paused = false
  print("게임 재개됨")
  
  # 팝업이 닫혔음을 알리는 시그널 발생
  popup_closed.emit()
  print("popup_closed 시그널 발생됨")
