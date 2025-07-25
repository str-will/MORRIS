extends CharacterBody3D

@onready var camera = $head/Camera3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _physics_process(delta: float) -> void:
	# Aplica gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Pulo
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Entrada do jogador
	var input_dir := Input.get_vector("left", "right", "forward", "backward")

	if input_dir.length() > 0:
		# Vetores da câmera — direção horizontal (sem inclinação vertical)
		var cam_forward = camera.global_transform.basis.z
		var cam_right = camera.global_transform.basis.x

		# Remove a componente vertical para manter no plano XZ
		cam_forward.y = 0
		cam_right.y = 0
		cam_forward = cam_forward.normalized()
		cam_right = cam_right.normalized()

		# Calcula direção final com base na orientação da câmera
		var direction = (cam_forward * input_dir.y + cam_right * input_dir.x).normalized()

		# Aplica velocidade na direção do movimento
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		# Desaceleração suave
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Move o personagem
	move_and_slide()
