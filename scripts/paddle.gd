extends Area2D

@export var is_player_one = false

var up_input = "paddle_up"
var down_input = "paddle_down"
const MAX_VELOCITY = 10.0
var velocity = 0.0
var acceleration = 100.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_player_one == false:
		up_input += "_2"
		down_input += "_2"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move_dir = 0.0
	move_dir = Input.get_axis(up_input,down_input)
	velocity += move_dir * acceleration * delta
	if move_dir ==0:
		velocity = move_toward(velocity,0.0,2.0)
	velocity = clampf(velocity,-MAX_VELOCITY,MAX_VELOCITY)
	global_position.y+=velocity
	global_position.y = clampf(global_position.y, 50, get_window().size.y-50)


func _on_body_entered(body: Node2D) -> void:
	if body is Ball:
		body.bounce_from_paddle(global_position.y,100)
