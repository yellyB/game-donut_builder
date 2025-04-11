extends Area2D


func get_size() -> Vector2:
	var sprite = $Sprite2D
	if sprite and sprite.texture:
		return sprite.texture.get_size() * sprite.scale
	return Vector2(100, 130) # fallback 값
