extends AudioStreamPlayer

# Cada item na lista terá:
# { "hit_time": float, "target_player": int (1 ou 2), "target_pos": Vector2 }
var all_beats: Array[Dictionary] = []
var beats: Array[Dictionary] = []
var bpm: float = 0.0
var sec_per_beat: float = 0.0

var song_position: float = 0.0
var is_playing_song: bool = false
var current_compass: int = 1

# Posições X das barras dos jogadores
const PADDLE_LEFT_X = 50.0
const PADDLE_RIGHT_X = 1230.0


func _ready() -> void:
	load_chart("res://audio/kotr.txt")


func load_chart(file_path: String) -> void:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		print("Erro ao abrir ", file_path)
		return
		
	var content = file.get_as_text()
	var partes = content.split(";")
	
	bpm = float(partes[0])
	sec_per_beat = 60.0 / bpm
	print("BPM: ", bpm, " | Segundos por batida: ", sec_per_beat)
	
	var beat_index = 0
	var next_player = 1 # Começa no Jogador 1 (Esquerda) e depois alterna
	
	for i in range(1, partes.size()):
		var compasso = partes[i].strip_edges()
		if compasso.is_empty():
			continue
			
		var batidas = compasso.split(",")
		for batida in batidas:
			var valor = int(batida)
			var hit_time = beat_index * sec_per_beat
			# Sempre que houver uma nota (1 ou 2), registamos uma batida no Pong
			if valor > 0:
				var target_x = PADDLE_LEFT_X if next_player == 1 else PADDLE_RIGHT_X
				var target_y = randf_range(120.0, 600.0) # Altura que o jogador terá de defender
				
				all_beats.append({
					"hit_time": hit_time,
					"target_player": next_player,
					"target_pos": Vector2(target_x, target_y)
				})

				beats.append({
					"hit_time": hit_time,
					"target_player": next_player,
					"target_pos": Vector2(target_x, target_y)
				})
				
				# Alterna para o outro jogador na batida seguinte!
				next_player = 2 if next_player == 1 else 1
			else:
				all_beats.append({
					"hit_time": hit_time,
					"target_player": 0,
					"target_pos": Vector2(0, 0)
				})

			beat_index += 1
			
	print("Total de batidas sincronizadas no Pong: ", all_beats.size())


func start_music() -> void:
	play()
	is_playing_song = true

func _process(delta: float) -> void:
	if is_playing_song and playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
		current_compass = int(song_position / (sec_per_beat * 4.0))
