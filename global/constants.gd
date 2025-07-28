extends Node


enum CardType { MATERIAL, DONUT, CUSTOMER }
enum MaterialType { MILK, SUGAR, FLOUR, STRAWBERRY, CHOCOLATE, MINT, RAINBOW }
enum DonutType { MILK, STRAWBERRY, CHOCOLATE, MINT }
enum DonutRarity { COMMON, RARE, EPIC }
enum DonutTag { BASIC, SWEET, FRUITY, CHOCOLATE, MINTY, FRESH }

enum CustomerType { WOMAN, MAN }
enum OrderType { DONUT_TYPE, DONUT_TAG }
enum MaterialGrade { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY }

const DONUT_DATA = {
  DonutType.MILK: {
    "name": "우유도넛",
    "texture": preload("res://images/card/donut/card_donut_milk.png"),
    "recipe": [MaterialType.MILK, MaterialType.SUGAR, MaterialType.FLOUR],
    "price": 100,
    "rarity": DonutRarity.COMMON,
    "tags": [DonutTag.BASIC, DonutTag.SWEET]
  },
  DonutType.STRAWBERRY: {
    "name": "딸기도넛",
    "texture": preload("res://images/card/donut/card_donut_strawberry.png"),
    "recipe": [MaterialType.MILK, MaterialType.SUGAR, MaterialType.FLOUR, MaterialType.STRAWBERRY],
    "price": 250,
    "rarity": DonutRarity.COMMON,
    "tags": [DonutTag.FRUITY, DonutTag.SWEET]
  },
  DonutType.CHOCOLATE: {
    "name": "초코도넛",
    "texture": preload("res://images/card/donut/card_donut_chocolate.png"),
    "recipe": [MaterialType.MILK, MaterialType.SUGAR, MaterialType.FLOUR, MaterialType.CHOCOLATE],
    "price": 250,
    "rarity": DonutRarity.COMMON,
    "tags": [DonutTag.CHOCOLATE, DonutTag.SWEET]
  },
  DonutType.MINT: {
    "name": "민트도넛",
    "texture": preload("res://images/card/donut/card_donut_mint.png"),
    "recipe": [MaterialType.MILK, MaterialType.SUGAR, MaterialType.FLOUR, MaterialType.MINT],
    "price": 400,
    "rarity": DonutRarity.RARE,
    "tags": [DonutTag.MINTY, DonutTag.FRESH]
  }
}

const MATERIAL_DATA = {
  MaterialType.MILK: {
    "name": "우유",
    "texture": preload("res://images/card/material/card_material_milk.png"),
    "price": 10,
    "grade": MaterialGrade.COMMON
  },
  MaterialType.SUGAR: {
    "name": "설탕",
    "texture": preload("res://images/card/material/card_material_sugar.png"),
    "price": 10,
    "grade": MaterialGrade.COMMON
  },
  MaterialType.FLOUR: {
    "name": "밀가루",
    "texture": preload("res://images/card/material/card_material_flour.png"),
    "price": 15,
    "grade": MaterialGrade.COMMON
  },
  MaterialType.STRAWBERRY: {
    "name": "딸기",
    "texture": preload("res://images/card/material/card_material_strawberry.png"),
    "price": 30,
    "grade": MaterialGrade.UNCOMMON
  },
  MaterialType.CHOCOLATE: {
    "name": "초콜릿",
    "texture": preload("res://images/card/material/card_material_chocolate.png"),
    "price": 35,
    "grade": MaterialGrade.RARE
  },
  MaterialType.MINT: {
    "name": "민트",
    "texture": preload("res://images/card/material/card_material_mint.png"),
    "price": 50,
    "grade": MaterialGrade.EPIC
  },
  MaterialType.RAINBOW: {
    "name": "무지개",
    "texture": preload("res://images/card/material/card_material_rainbow.png"),
    "price": 40,
    "grade": MaterialGrade.LEGENDARY
  }
}

const CUSTOMER_DATA = {
  CustomerType.WOMAN: {
    "name": "여자 손님",
    "texture": preload("res://images/card_customer.png"),
    "patience": 60,
    "order": null
  },
  CustomerType.MAN: {
    "name": "남자 손님",
    "texture": preload("res://images/card_customer.png"),
    "patience": 50,
    "order": null
  }
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
