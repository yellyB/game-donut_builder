extends Node


enum CardType { MATERIAL, DONUT, CUSTOMER, SPECIAL }
enum MaterialType { MILK, SUGAR, FLOUR, STRAWBERRY, CHOCOLATE, MINT, RAINBOW }
enum DonutMenu { MILK, STRAWBERRY, CHOCOLATE, MINT }
enum DonutRarity { COMMON, RARE, EPIC }
enum DonutTag { BASIC, SWEET, FRUITY, CHOCOLATE, MINTY, FRESH }
enum CustomerType { WOMAN, MAN }
enum OrderType { DONUT_MENU, DONUT_TAG }
enum MaterialGrade { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY }
enum DonutGrade { BASIC, PREMIUM, PRESTIGE }
enum SpecialCardType { TRASHCAN }


const DONUT_DATA = {
  DonutMenu.MILK: {
    "name": "우유도넛",
    "texture": preload("res://images/card/donut/milk.png"),
    "recipe": [MaterialType.MILK, MaterialType.SUGAR, MaterialType.FLOUR],
    "price": 100,
    "tags": [DonutTag.BASIC, DonutTag.SWEET]
  },
  DonutMenu.STRAWBERRY: {
    "name": "딸기도넛",
    "texture": preload("res://images/card/donut/strawberry.png"),
    "recipe": [MaterialType.MILK, MaterialType.SUGAR, MaterialType.FLOUR, MaterialType.STRAWBERRY],
    "price": 250,
    "tags": [DonutTag.FRUITY, DonutTag.SWEET]
  },
  DonutMenu.CHOCOLATE: {
    "name": "초코도넛",
    "texture": preload("res://images/card/donut/chocolate.png"),
    "recipe": [MaterialType.MILK, MaterialType.SUGAR, MaterialType.FLOUR, MaterialType.CHOCOLATE],
    "price": 250,
    "tags": [DonutTag.CHOCOLATE, DonutTag.SWEET]
  },
  DonutMenu.MINT: {
    "name": "민트도넛",
    "texture": preload("res://images/card/donut/mint.png"),
    "recipe": [MaterialType.MILK, MaterialType.SUGAR, MaterialType.FLOUR, MaterialType.MINT],
    "price": 400,
    "tags": [DonutTag.MINTY, DonutTag.FRESH]
  }
}

const MATERIAL_DATA = {
  MaterialType.MILK: {
    "name": "우유",
    "texture": preload("res://images/card/material/milk.png"),
    "price": 10,
    "grade": MaterialGrade.COMMON
  },
  MaterialType.SUGAR: {
    "name": "설탕",
    "texture": preload("res://images/card/material/sugar.png"),
    "price": 10,
    "grade": MaterialGrade.COMMON
  },
  MaterialType.FLOUR: {
    "name": "밀가루",
    "texture": preload("res://images/card/material/flour.png"),
    "price": 15,
    "grade": MaterialGrade.COMMON
  },
  MaterialType.STRAWBERRY: {
    "name": "딸기",
    "texture": preload("res://images/card/material/strawberry.png"),
    "price": 30,
    "grade": MaterialGrade.UNCOMMON
  },
  MaterialType.CHOCOLATE: {
    "name": "초콜릿",
    "texture": preload("res://images/card/material/chocolate.png"),
    "price": 35,
    "grade": MaterialGrade.RARE
  },
  MaterialType.MINT: {
    "name": "민트",
    "texture": preload("res://images/card/material/mint.png"),
    "price": 50,
    "grade": MaterialGrade.EPIC
  },
  MaterialType.RAINBOW: {
    "name": "무지개",
    "texture": preload("res://images/card/material/rainbow.png"),
    "price": 40,
    "grade": MaterialGrade.LEGENDARY
  }
}

const CUSTOMER_DATA = {
  CustomerType.WOMAN: {
    "name": "여자 손님",
    "texture": preload("res://images/card/customer/woman.png"),
    "patience": 6,  # 테스트를 위해 인내심 1/10으로 낮춤
    "order": null
  },
  CustomerType.MAN: {
    "name": "남자 손님",
    "texture": preload("res://images/card/customer/man.png"),
    "patience": 5,
    "order": null
  }
}
