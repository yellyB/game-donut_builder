extends Node


func _ready():
  $GridManager.initialize($HUD)
  $HUD.initialize($GridManager)
  
