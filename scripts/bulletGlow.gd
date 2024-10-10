extends MeshInstance3D
class_name BulletGlow

var _points : Array[Vector3] = []
var _prevPos := Vector3.ZERO
var _isParentBulletDestroyed := false

@onready var _immediateMesh : ImmediateMesh = self.mesh

func update(parentPos : Vector3) -> void:
	# Add another point if it moved far enough
	var distance := _prevPos.distance_to(parentPos)
	if distance > 0.1:
		_prevPos = parentPos

		# Save position as local space
		_points.append(parentPos - self.global_transform.origin)

		if _points.size() > 6:
			_points.pop_front()

func _physics_process(_delta : float) -> void:
	# If the bullet is destroyed, delete the points
	if _isParentBulletDestroyed:
		if not _points.is_empty():
			_points.pop_front()
		else:
			self.queue_free()

func _process(_delta : float) -> void:
	if not _immediateMesh: return
	if _points.size() < 2: return

	# Draw the line
	_immediateMesh.clear_surfaces()
	_immediateMesh.surface_begin(Mesh.PRIMITIVE_LINES)
	for i in _points.size():
		if i + 1 < _points.size():
			var a := _points[i]
			var b := _points[i + 1]
			_immediateMesh.surface_add_vertex(a)
			_immediateMesh.surface_add_vertex(b)
	_immediateMesh.surface_end()

func start(parentPos : Vector3) -> void:
	_points.append(parentPos - self.global_transform.origin)
