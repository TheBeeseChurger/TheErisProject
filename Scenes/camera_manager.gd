extends Camera2D

const SPEED = 400.0

@onready var player = $"../Player"

@export var player_x_offset: float = -100.0
@export var player_y_offset: float = -250.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x = move_toward(position.x, player.position.x + (player_x_offset), SPEED * delta)
	position.y = move_toward(position.y, player.position.y + (player_y_offset), SPEED * delta)
