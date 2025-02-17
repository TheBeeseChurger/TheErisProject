extends Node2D

@onready var player: CharacterBody2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_kill_floor_entered(body: Node2D) -> void:
	if body != player:
		return
	
	get_tree().call_deferred("reload_current_scene")
