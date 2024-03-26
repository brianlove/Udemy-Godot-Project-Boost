extends RigidBody3D

## How much vertical force to apply when moving.
@export_range(750.0, 5000.0) var thrust: float = 1000.0

## How much rotational force to apply when orienting the rocket.
@export var torque_thrust: float = 100.0

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var booster_particles_right: GPUParticles3D = $BoosterParticlesRight
@onready var booster_particles_left: GPUParticles3D = $BoosterParticlesLeft
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles

var is_transitioning: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
		booster_particles.emitting = true
		if not rocket_audio.playing:
			rocket_audio.play()
	else:
		booster_particles.emitting = false
		rocket_audio.stop()

	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
		booster_particles_right.emitting = true
	else:
		booster_particles_right.emitting = false

	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))
		booster_particles_left.emitting = true
	else:
		booster_particles_left.emitting = false


func _on_body_entered(body: Node) -> void:
	if not is_transitioning:
		var groups = body.get_groups()
		if "Hazard" in groups:
			crash_sequence()
		elif "Goal" in groups:
			complete_level(body.file_path)


func complete_level(next_level_file) -> void:
	print("You win!")
	success_audio.play()
	success_particles.emitting = true

	set_process(false)
	is_transitioning = true

	var tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(func(): get_tree().change_scene_to_file(next_level_file))
	# Alternative callback:
	#tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_file))


func crash_sequence() -> void:
	print("Boom!")
	explosion_audio.play()
	explosion_particles.emitting = true

	is_transitioning = true
	# Disable the `_process()` function to remove user control of the rocket
	set_process(false)

	var tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(get_tree().reload_current_scene)
