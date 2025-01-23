extends CharacterBody2D


const SPEED = 200.0
const SWD_MAX_SPEED = 450.0
const SPEC_MAX_SPEED = 100.0
const MAX_SPEED = 400.0
const G_DRAG = 100.0
const S_DRAG = 20.0
const A_DRAG = 4.0
const JUMP_VELOCITY = -500.0

@onready var sprite = $AnimatedSprite2D
@onready var human_shape = $CollisionShape2D
@onready var sword_shape = $CollisionShape2D2

var has_double_jump = false
var is_sword = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Transform") and is_sword:
		is_sword = false
		
		sword_shape.disabled = true
		human_shape.disabled = false
		
		sprite.play("default")
	elif Input.is_action_just_pressed("Transform"):
		is_sword = true
		
		human_shape.disabled = true
		sword_shape.disabled = false
		
		sprite.play("swd_default")

func _physics_process(delta: float) -> void:
	if is_sword:
		sword_process(delta)
		return
	
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

func sword_process(_delta: float) -> void:
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = (direction * SPEED) + velocity.x
		if abs(velocity.x) > SWD_MAX_SPEED:
			velocity.x = SWD_MAX_SPEED * sign(velocity.x)
	else:
		velocity.x = move_toward(velocity.x, 0, S_DRAG)
	
	direction = Input.get_axis("Jump", "Down")
	if direction:
		velocity.y = (direction * SPEED) + velocity.y
		if abs(velocity.y) > SWD_MAX_SPEED:
			velocity.y = SWD_MAX_SPEED * sign(velocity.y)
	else:
		velocity.y = move_toward(velocity.y, 0, S_DRAG)
	
	move_and_slide()
