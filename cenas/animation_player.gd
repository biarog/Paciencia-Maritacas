extends AnimationPlayer
func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
	play("pulsar")
