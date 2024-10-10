extends Node3D

@onready var playerScene = preload("res://scenes/player.tscn")
@onready var mapScene = preload("res://scenes/1v1map.tscn")
@onready var powerupScene = preload("res://scenes/powerup.tscn")

func _init() -> void:
	Global._rootNode = self

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var map = mapScene.instantiate()
	var player = playerScene.instantiate()
	Global._rootNode.add_child(map)
	Global._rootNode.add_child(player)
	


func _input(_event) -> void:
	if Input.is_action_just_pressed("Quit"):
		self.get_tree().quit()
	elif Input.is_action_just_released("ToggleFullScreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			


func _process(delta):
	pass #for spawning powerups
