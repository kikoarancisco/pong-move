extends Node2D

@onready var ball = $Ball
@onready var conductor = $Conductor
@onready var detector_left = $DetectorLeft
@onready var detector_right = $DetectorRight
@onready var hud = $CanvasLayer/HUD
@onready var ball_out_sound = $BallOutSound
@onready var camera = $Camera2D
@onready var paddle_one = $PaddleOne
@onready var paddle_two = $PaddleTwo
@onready var beat_view = $BeatView


var score = Vector2i.ZERO
@export var final_score = 11
@export var default_song: SongData

func _draw() -> void:
	draw_dashed_line(Vector2(640, 0), Vector2(640, 730), Color.WHITE, 8, 12, false)

func _ready() -> void:
	ball.hit_evaluated.connect(_on_ball_hit_evaluated)
	var song: SongData = GameState.selected_song if GameState.selected_song else default_song
	if song == null:
		push_error("No song selected and no default_song set!")
		return

	conductor.setup(song)
	conductor.finished.connect(_on_song_finished)
	start_game()
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

	beat_view.update_beat_view(conductor)
	

func start_game():
	conductor.start_music()
	ball.start_rhythm(conductor)

func shake_screen() -> void:
	var tween = create_tween()
	# Puxa a câmara entre -8 e +8 píxeis aleatoriamente
	camera.offset = Vector2(randf_range(-8.0, 8.0), randf_range(-8.0, 8.0))
	# Faz a câmara voltar suavemente a zero em 0.15 segundos
	tween.tween_property(camera, "offset", Vector2.ZERO, 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_ball_hit_evaluated(target_player: int, target_y: float) -> void:
	var paddle = paddle_one if target_player == 1 else paddle_two
	var paddle_y = paddle.global_position.y
	
	if abs(paddle_y - target_y) < 60:
		ball.play_beep()
	else:
		# 1. Quem falhou concede ponto ao adversário
		if target_player == 1:
			score.y += 1
		else:
			score.x += 1
		# 2. Reações ao golo
		hud.set_new_score(score)
		ball_out_sound.play()
		shake_screen()

func _on_song_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
