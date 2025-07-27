extends Node


enum CardType { MATERIAL, DONUT, CUSTOMER }
enum MaterialType { MILK, SUGAR, FLOUR, STRAWBERRY, CHOCOLATE, MINT }
enum DonutType { MILK, STRAWBERRY, CHOCOLATE, MINT }
enum DonutRarity { COMMON, RARE, EPIC }
enum DonutTag { BASIC, SWEET, FRUITY, CHOCOLATE, MINTY, FRESH }

const DONUT_DATA = {
  DonutType.MILK: {
    "name": "우유도넛",
    "texture": preload("res://images/card/donut/card_donut_milk.png"),
    "recipe": [MaterialType.MILK, MaterialType.SUGAR, MaterialType.FLOUR],
    "price": 100,
    "rarity": DonutRarity.COMMON,
    "shelf_life": 60,
    "tags": [DonutTag.BASIC, DonutTag.SWEET]
  },
  DonutType.STRAWBERRY: {
    "name": "딸기도넛",
    "texture": preload("res://images/card/donut/card_donut_strawberry.png"),
    "recipe": [MaterialType.MILK, MaterialType.SUGAR, MaterialType.FLOUR, MaterialType.STRAWBERRY],
    "price": 250,
    "rarity": DonutRarity.COMMON,
    "shelf_life": 45,
    "tags": [DonutTag.FRUITY, DonutTag.SWEET]
  },
  DonutType.CHOCOLATE: {
    "name": "초코도넛",
    "texture": preload("res://images/card/donut/card_donut_chocolate.png"),
    "recipe": [MaterialType.MILK, MaterialType.SUGAR, MaterialType.FLOUR, MaterialType.CHOCOLATE],
    "price": 250,
    "rarity": DonutRarity.COMMON,
    "shelf_life": 50,
    "tags": [DonutTag.CHOCOLATE, DonutTag.SWEET]
  },
  DonutType.MINT: {
    "name": "민트도넛",
    "texture": preload("res://images/card/donut/card_donut_mint.png"),
    "recipe": [MaterialType.MILK, MaterialType.SUGAR, MaterialType.FLOUR, MaterialType.MINT],
    "price": 400,
    "rarity": DonutRarity.RARE,
    "shelf_life": 40,
    "tags": [DonutTag.MINTY, DonutTag.FRESH]
  }
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
