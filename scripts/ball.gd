extends CharacterBody2D
class_name Ball
signal hit_evaluated(player_id: int, target_y: float)


@onready var beep1 = $Beep1
@onready var beep2 = $Beep2


var conductor: AudioStreamPlayer = null
var current_beat_index: int = 0
var active: bool = false

# Dados do segmento atual da bola
var start_pos: Vector2 = Vector2(640, 360)
var target_pos: Vector2 = Vector2.ZERO
var start_time: float = 0.0
var target_time: float = 0.0
var target_player: int = 1

func start_rhythm(p_conductor: AudioStreamPlayer) -> void:
	conductor = p_conductor
	global_position = Vector2(640, 360)
	start_pos = global_position
	start_time = 0.0
	current_beat_index = 0
	
	if conductor.beats.size() > 0:
		var first_beat = conductor.beats[0]
		target_pos = first_beat.target_pos
		target_time = first_beat.hit_time
		target_player = first_beat.target_player
		active = true

func _process(delta: float) -> void:
	if not active or conductor == null:
		return
		
	var current_time = conductor.song_position
	var duration = target_time - start_time
	
	if duration > 0.0:
		# Progresso de 0.0 (saída) a 1.0 (chegada ao alvo)
		var progress = clampf((current_time - start_time) / duration, 0.0, 1.0)
		global_position = start_pos.lerp(target_pos, progress)
		
	# Quando o tempo da música atinge o instante do impacto:
	if current_time >= target_time:
		on_hit_target()

func on_hit_target() -> void:
	hit_evaluated.emit(target_player, target_pos.y)
	
	# Prepara a próxima viagem para o outro jogador!
	current_beat_index += 1
	if current_beat_index < conductor.beats.size():
		start_pos = target_pos
		start_time = target_time
		
		var next_beat = conductor.beats[current_beat_index]
		target_pos = next_beat.target_pos
		target_time = next_beat.hit_time
		target_player = next_beat.target_player
	else:
		active = false
		print("Fim da música!")

func play_beep():
	var beep = [beep1, beep2].pick_random()
	beep.pitch_scale = [0.9, 1.0, 1.1].pick_random()
	beep.play()
