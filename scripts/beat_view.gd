extends Node2D

var conductor: AudioStreamPlayer = null
var current_beat_index: int = 0
var current_compass: int = 0

@onready var displays: Array = [$B1, $B2, $B3, $B4]

func _ready() -> void:
	for b in displays:
		b.modulate = Color(1.0, 1.0, 1.0, 0.2)

func update_beat_view(p_conductor: AudioStreamPlayer) -> void:
	current_compass = p_conductor.current_compass
	for d in range(displays.size()):
		var i = d + (4 * current_compass)
		if i >= p_conductor.all_beats.size():
			break
		var transparency: float = 0.1
		if p_conductor.all_beats[i].target_player != 0:
			transparency += 0.7
		if p_conductor.all_beats[i].hit_time < p_conductor.song_position:
			transparency += 0.2

		displays[d].modulate = Color(1.0, 1.0, 1.0, transparency)
