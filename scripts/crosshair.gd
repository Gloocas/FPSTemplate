extends CenterContainer

@export var hasDot := false
@export var dotRadius := 1.0
@export var dotColor := Color.WHITE


# Called when the node enters the scene tree for the first time.
func _ready():
	queue_redraw()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _draw():
	draw_circle(Vector2(0,0), dotRadius, dotColor)
