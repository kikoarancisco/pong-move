extends CharacterBody2D
class_name Ball

@onready var beep1 = $Beep1
@onready var beep2 = $Beep2


@export var speed_increase_per_bounce = 20
var active = false
const  START_SPEED = 500
var speed = START_SPEED
var move_dir = Vector2(-1,randf_range(-1.0,1.0))



func _physics_process(delta: float) -> void:
	if(!active):
		return
	velocity = move_dir * speed
	
	var collided = move_and_slide()
	
	if collided:
		move_dir.y *= -1 
		play_beep()


func bounce_from_paddle(paddle_y_pos, paddle_height):
	var new_move_dir = (global_position.y-paddle_y_pos) / (paddle_height *0.5)
	move_dir.y = new_move_dir
	move_dir.x *=-1
	speed +=speed_increase_per_bounce
	play_beep()

func reset(reset_pos):
	global_position = reset_pos
	speed = START_SPEED
	move_dir.x = [-1,1].pick_random()
	move_dir.y = randf_range(-1.0,1.0)
	active = false

func play_beep():
	var beep = [beep1,beep2].pick_random()
	beep.pitch_scale = [0.8,1.0,1,2].pick_random()
	beep.play()
