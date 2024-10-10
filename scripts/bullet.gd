extends Node3D

@export var bulletGravity := 9.8
@export var bulletBounces := 0
@export var bulletSpread := 0.0
@export var bulletInitialV := 100.0
@export var bulletDamage := 0.0
var bulletsExplode := false
var bulletsPoison := false

var _player : CharacterBody3D
var _bulletSpawn: Node3D
var _mass := -1.0
var _maxDistance := 100.0
var _glow = null
var _velocity : Vector3
var _speed : float
var _gravityVelocity := 0.0
var _totalDistance :=  0.0

@onready var _glowScene := preload("res://scenes/bulletGlow.tscn")
@onready var _ray := $RayCast3D

const MIN_BOUNCE_DISTANCE := 0.1
const MIN_RAYCAST_DISTANCE := 0.05


# Called when the node enters the scene tree for the first time.
func _ready():
	_glow = _glowScene.instantiate()
	Global._rootNode.add_child(_glow)
	start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var is_destroyed := false
	_glow.update(self.global_transform.origin)

	# Move the bullet
	var distance = _velocity.length() * delta
	self.transform.origin -= _velocity * delta
	# Gravity
	_gravityVelocity = clampf(_gravityVelocity + bulletGravity * delta, 0, 9.8)
	self.transform.origin.y -= _gravityVelocity

	# Change the ray start position to the bullets's previous position
	# NOTE: The ray is backwards, so if it is hitting multiple targets, we
	# get the target closest to the bullet start position.
	# Also make the ray at least the min length
	if distance > MIN_RAYCAST_DISTANCE:
		_ray.target_position.z = -distance
		_ray.transform.origin.z = distance
	else:
		_ray.target_position.z = -MIN_RAYCAST_DISTANCE
		_ray.transform.origin.z = MIN_RAYCAST_DISTANCE
	# Check if hit something
	_ray.force_raycast_update()
	if _ray.is_colliding():
		print(bulletBounces)
		if bulletBounces == 0:
			self.queue_free()
			_glow._isParentBulletDestroyed = true
		bulletBounces -= 1
		var collider = _ray.get_collider()
		print("Bullet hit %s" % [collider.name])
		if collider.name == "Player":
			collider.health -= bulletDamage
		# Move the bullet back to the position of the collision
		self.global_transform.origin = _ray.get_collision_point()

		# Ricochet the bullet if it is hitting steel or concrete
	
		# Remove 20% of the speed
		#print(_speed)
		#_speed = clampf(_speed - _speed * 0.20, 0.0, 10000.0)
		_velocity = self.transform.basis.z * bulletInitialV

		# Reset gravity
		_gravityVelocity = 0.0

		# Bounce
		var norm = _ray.get_collision_normal()
		_velocity = _velocity.bounce(norm)
		Global.safe_look_at(self, self.global_transform.origin - _velocity)

		# Move away from collision location to avoid still touching it,
		# or raycast tail still touching it
		self.transform.origin -= self.transform.basis.z * MIN_BOUNCE_DISTANCE
		

	# Update glow
	_glow.update(self.global_transform.origin)

	## Delete the bullet if it is slow
	if distance < 0.05:
		print("TOO SLOW")
		is_destroyed = true

	 #Delete the bullet if it has gone its max distance
	_totalDistance += distance
	#print(_totalDistance)
	if _totalDistance > _maxDistance:
		print("TOTAL DISTANCE MET")
		is_destroyed = true

	if is_destroyed:
		self.queue_free()
		_glow._isParentBulletDestroyed = true

func start() -> void:
	_velocity = _bulletSpawn.global_transform.basis.z * bulletInitialV
	
	
