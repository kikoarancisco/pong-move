extends Node2D
@onready var ball = $Ball
@onready var detector_left = $DetectorLeft
@onready var detector_right = $DetectorRight
@onready var start_delay =$StartDelay
@onready var hud = $CanvasLayer/HUD
@onready var ball_out_sound = $BallOutSound

var score = Vector2i.ZERO
@export var final_score = 11

func _draw() -> void:
	
	draw_dashed_line(Vector2(640,0),Vector2(640,730),Color.WHITE,8,12,false)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detector_left.ball_out.connect(_on_detector_ball_out)
	detector_right.ball_out.connect(_on_detector_ball_out)
	reset_game()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func reset_game():
	score = Vector2i.ZERO
	hud.reset_score()
	reset_round()

func reset_round():
	var reset_pos = Vector2(1280,720)/2
	ball.reset(reset_pos)
	start_delay.start()
	await start_delay.timeout
	ball.active=true


func _on_detector_ball_out(is_left):
	if is_left:
		score.y+=1
	else:
		score.x+=1
	ball_out_sound.play()
	hud.set_new_score(score)
	if score.x >= final_score || score.y >= final_score:
		reset_game()
	else:
		reset_round()
	
