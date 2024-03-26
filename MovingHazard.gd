extends AnimatableBody3D

@export var destination: Vector3 = Vector3.ZERO
@export var duration: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", global_position + destination, duration)
	tween.tween_property(self, "global_position", global_position, duration)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



# Janky version:
#func move_hazard(target_position: Vector3) -> void:
	#var tween = create_tween()
	#tween.tween_property(self, "global_position", target_position, duration)
	#tween.tween_callback(func(): return_to_start(global_position - destination))
#
#func return_to_start(start_position: Vector3) -> void:
	#var tween = create_tween()
	#tween.tween_property(self, "global_position", start_position, duration)
	#tween.tween_callback(func(): move_hazard(start_position + destination))
