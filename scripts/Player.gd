extends CharacterBody3D
@export var Speed := 0.0
@export var TopSpeed := 9.0
@export var CrouchSpeed := TopSpeed/2
@export var SprintSpeed := TopSpeed * 1.5
@export var JVelocity := 9.0
@export var mSensex := -0.001
@export var mSensey := -0.001

@export var bulletInitialV := 100.0
@export var bulletsPerShot := 1
@export var bulletGravity := 9.8		
@export var bulletSpread := 0.0
@export var bulletBounces := 0
@export var magSize := 3
@export var reloadTime := 3.0
@export var baseDamage := 10.0
@export var bounceDamage := baseDamage
@export var health := 100.0


var ammoCount := magSize
var bulletsExplode := false
var bulletsPoison := false
var shooting := false
var crouching := false
var SpeedIncrement := 0.4
var canWallJump := false
var chainedJumps := 1
var crouchScale := 1.0

var curDirection := Vector3.ZERO
const dirIncrement := 0.15

@onready var collisionShape := $CollisionShape3D2
@onready var collisionMesh := $CollisionShape3D2/MeshInstance3D
@onready var rightCast := $RightCast
@onready var rightCast2 := $RightCast2
@onready var leftCast := $LeftCast
@onready var leftCast2 := $LeftCast2
@onready var frontCast := $FrontCast
@onready var frontCast2 := $FrontCast2
@onready var backCast := $BackCast
@onready var backCast2 := $BackCast2
@onready var camera := $Camera
@onready var bulletSpawn := $Camera/BulletSpawn

@onready var bullet := preload("res://scenes/bullet.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _input(event):
	if event is InputEventMouseMotion:
		#old "working" code, move bulletspawn under player to function (had bug where rotation affected speed)
		#rotate(Vector3.UP, event.relative.x * mSensex)
		#rotate_object_local(Vector3.RIGHT, event.relative.y * mSensey)
		
		#better version, bullets currently don't have correct rotation
		rotate(Vector3.UP, event.relative.x * mSensex)
		camera.rotate(Vector3.RIGHT, event.relative.y * mSensey)
		
		

func _physics_process(delta):
	#print(str(bulletSpawn.global_rotation) + str(bulletSpawn.global_transform))
	
	if Input.is_action_just_pressed("Escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if is_colliding():
		canWallJump = true
	else:
		canWallJump = false
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_pressed("Crouch"):
		crouchScale = move_toward(crouchScale, 0.5, 0.05)
		collisionShape.scale = Vector3(1,crouchScale,1)
		collisionMesh.scale = Vector3(1,crouchScale,1)
		crouching = true
	else:
		crouchScale = move_toward(crouchScale, 1, 0.05)
		collisionShape.scale = Vector3(1,crouchScale,1)
		collisionMesh.scale = Vector3(1,crouchScale,1)
		crouching = false
	


	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		chainedJumps = 1
		velocity.y = JVelocity
	elif Input.is_action_just_pressed("Jump") and canWallJump and chainedJumps < 4:
		velocity.y = JVelocity
		chainedJumps += 1
		
	
	if velocity.y < 0:
		velocity.y *= 1.02
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and Input.is_action_pressed("Sprint"):
		Speed = move_toward(Speed, SprintSpeed, SpeedIncrement)
		curDirection = curDirection.move_toward(direction, dirIncrement)
		velocity.x = curDirection.x * Speed
		velocity.z = curDirection.z * Speed
		#velocity.x = direction.x * Speed
		#velocity.z = direction.z * Speed
	elif direction and crouching:
		Speed = move_toward(Speed, CrouchSpeed, SpeedIncrement)
		curDirection = curDirection.move_toward(direction, dirIncrement)
		velocity.x = curDirection.x * Speed
		velocity.z = curDirection.z * Speed
	elif direction:
		Speed = move_toward(Speed, TopSpeed, SpeedIncrement)
		curDirection = curDirection.move_toward(direction, dirIncrement)
		velocity.x = curDirection.x * Speed
		velocity.z = curDirection.z * Speed
		#velocity.x = direction.x * Speed
		#velocity.z = direction.z * Speed
	else:
		curDirection = curDirection.move_toward(Vector3.ZERO, dirIncrement)
		velocity.x = move_toward(velocity.x, 0, SpeedIncrement)
		velocity.z = move_toward(velocity.z, 0, SpeedIncrement)
		
		
	if Input.is_action_just_pressed("LeftClick"):
		spawn_bullet()
	
	if Speed > 9:
		SpeedIncrement = Speed / 50
	else:
		SpeedIncrement = 0.4
	move_and_slide()
	
	



func reload():
	await get_tree().create_timer(reloadTime).timeout
	ammoCount = magSize

func spawn_bullet():
	if not shooting:
		shooting = true
		if ammoCount == 0:
			await reload()
			shooting = false
		else:
			ammoCount -= 1
			for n in range(bulletsPerShot):
				var newBullet = bullet.instantiate()
				newBullet.bulletGravity = bulletGravity
				newBullet.bulletBounces = bulletBounces
				newBullet.bulletsExplode = bulletsExplode
				newBullet.bulletInitialV = bulletInitialV
				newBullet.bulletDamage = baseDamage
				newBullet._player = self
				newBullet._bulletSpawn = bulletSpawn
				add_sibling(newBullet)
				newBullet.transform = bulletSpawn.global_transform
				await get_tree().create_timer(.01).timeout
			shooting = false

func is_colliding():
	return rightCast.is_colliding() or leftCast.is_colliding() or frontCast.is_colliding() or backCast.is_colliding() or rightCast2.is_colliding() or leftCast2.is_colliding() or frontCast2.is_colliding() or backCast2.is_colliding()


