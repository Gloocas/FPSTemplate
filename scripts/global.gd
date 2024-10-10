extends Node3D
const GAME_TITLE := "Godot Raycast Bullets"

const AIR_FRICTION := 10.0
const FLOOR_SLOPE_MAX_THRESHOLD := deg_to_rad(60)
const FLOOR_FRICTION := 60.0
const GRAVITY := -40.0
const MOUSE_SENSITIVITY := 0.1
const MOUSE_ACCELERATION_X := 10.0
const MOUSE_ACCELERATION_Y := 10.0
const MOUSE_Y_MAX := 70.0
const MOUSE_Y_MIN := -60.0

var _rootNode : Node

#@onready var _scene_bullet := ResourceLoader.load("res://src/Bullet/Bullet.tscn")
#@onready var _scene_bullet_glow := ResourceLoader.load("res://src/BulletGlow/BulletGlow.tscn")
#@onready var _scene_bullet_spark := ResourceLoader.load("res://src/BulletSpark/BulletSpark.tscn")

#func create_bullet(parent : Node, start_pos : Vector3, target_pos : Vector3, bullet_type : Global.BulletType) -> void:
	#var bullet = _scene_bullet.instantiate()
	#parent.add_child(bullet)
	#bullet.global_transform.origin = start_pos
	#safe_look_at(bullet, target_pos)
	#bullet.start(bullet_type)

#func create_bullet_spark(pos : Vector3) -> void:
	#var spark = _scene_bullet_spark.instantiate()
	#Global._root_node.add_child(spark)
	#spark.global_transform.origin = pos

# See Transform::set_look_at for C++
# https://github.com/godotengine/godot/blob/3.4/core/math/transform.cpp#L78
func safe_look_at(spatial : Node3D, target: Vector3) -> void:
	var origin := spatial.global_transform.origin
	var v_z := (origin - target).normalized()

	# Just return if at same position
	if origin == target:
		return

	# Find an up vector that we can rotate around
	var up := Vector3.ZERO
	for entry in [Vector3.UP, Vector3.RIGHT, Vector3.BACK]:
		var v_x : Vector3 = entry.cross(v_z).normalized()
		if v_x.length() != 0:
			up = entry
			break

	# Look at the target
	if up != Vector3.ZERO:
		spatial.look_at(target, up)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
