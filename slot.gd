extends Area2D


func get_size() -> Vector2:
	var sprite = $Sprite2D
	if sprite and sprite.texture:
		return sprite.texture.get_size() * sprite.scale
	return Vector2(100, 130) # fallback 값


func get_overlap_area(card: Area2D) -> float:
	if not card or not card.has_method("get_rect"):
		return 0.0

	var card_rect = card.get_rect()
	var my_rect = get_global_rect()

	var overlap_rect = card_rect.intersection(my_rect)
	if overlap_rect:
		return overlap_rect.size.x * overlap_rect.size.y
	return 0.0


func get_global_rect() -> Rect2:
	var size = get_size()
	return Rect2(global_position - size / 2, size)
