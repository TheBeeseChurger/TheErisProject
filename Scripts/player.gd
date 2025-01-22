extends CharacterBody2D


const SPEED = 200.0
const SPEC_MAX_SPEED = 100.0
const MAX_SPEED = 400.0
const G_DRAG = 100.0
const A_DRAG = 4.0
const JUMP_VELOCITY = -500.0

var has_double_jump = false

func _physics_process(delta: float) -> void:
	# Add the gravity and reset double jump.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		has_double_jump = true

	# Get the input direction and handle the movement/deceleration and drag.
	var direction := Input.get_axis("Left", "Right")
	if direction and (is_on_floor() or (Input.is_action_just_pressed("Jump") and has_double_jump)):
		#Input and on floor or in double jump start
		velocity.x = (direction * SPEED) + velocity.x
		if abs(velocity.x) > MAX_SPEED and not Input.is_action_pressed("Down"):
			velocity.x = MAX_SPEED * sign(velocity.x)
		elif abs(velocity.x) > SPEC_MAX_SPEED and Input.is_action_pressed("Down"):
			velocity.x = SPEC_MAX_SPEED * sign(velocity.x)
	elif is_on_floor():
		#On floor and no input
		velocity.x = move_toward(velocity.x, 0, G_DRAG)
	elif direction:
		velocity.x = (direction * (SPEED / 5)) + velocity.x
		if abs(velocity.x) > MAX_SPEED and not Input.is_action_pressed("Down"):
			velocity.x = MAX_SPEED * sign(velocity.x)
		elif abs(velocity.x) > SPEC_MAX_SPEED  and Input.is_action_pressed("Down"):
			velocity.x = SPEC_MAX_SPEED * sign(velocity.x)
	else:
		#In air and no input
		velocity.x = move_toward(velocity.x, 0, A_DRAG)

	# Handle jump and double jump.
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or has_double_jump) and not Input.is_action_pressed("Down"):
		if not is_on_floor():
			has_double_jump = false
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("Jump") and (is_on_floor() or has_double_jump):
		if not is_on_floor():
			has_double_jump = false
		velocity.y = JUMP_VELOCITY / 8

	move_and_slide()
