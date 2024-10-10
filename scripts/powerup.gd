extends Node3D

@onready var area = $Area3D

var power = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	power = randi() % 5
	print(power)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body.name == "Player":
		match(power):
			0:
				body.magSize = 1000
				pass
			1:
				body.magSize = 1000
				pass
			2:
				body.magSize = 1000
				pass
			3:
				body.magSize = 1000
				pass
			4:
				body.magSize = 1000
				pass
		self.queue_free()
