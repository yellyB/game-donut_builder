extends Node


#@onready var hud = $HUD
#@onready var grid_manager = $GridManager


func _ready():
  $GridManager.initialize($HUD)
  
