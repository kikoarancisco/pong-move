extends Control

@export var songs: Array[SongData] = []

@onready var song_list = $CenterContainer/VBoxContainer/SongList


func _ready() -> void:
	for song in songs:
		var button := Button.new()
		button.text = "%s — %s" % [song.title, song.artist]
		button.custom_minimum_size = Vector2(400, 50)
		button.add_theme_font_size_override("font_size", 28)
		button.pressed.connect(_on_song_chosen.bind(song))
		song_list.add_child(button)

	if song_list.get_child_count() > 0:
		song_list.get_child(0).grab_focus()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()


func _on_song_chosen(song: SongData) -> void:
	GameState.selected_song = song
	get_tree().change_scene_to_file("res://scenes/game.tscn")
