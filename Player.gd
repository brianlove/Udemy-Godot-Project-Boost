extends RigidBody3D

## How much vertical force to apply when moving.
@export_range(750.0, 5000.0) var thrust: float = 1000.0

## How much rotational force to apply when orienting the rocket.
@export var torque_thrust: float = 100.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)

	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
	elif Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))


func _on_body_entered(body: Node) -> void:
	var groups = body.get_groups()
	if "Hazard" in groups:
		crash_sequence()
	elif "Goal" in groups:
		complete_level(body.file_path)


func complete_level(next_level_file) -> void:
	print("You win!")
	get_tree().change_scene_to_file(next_level_file)


func crash_sequence() -> void:
	print("Boom!")
	get_tree().reload_current_scene()
