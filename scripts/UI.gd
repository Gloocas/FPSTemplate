extends Control

@onready var speedLabel = $Speed
@onready var ammoLabel = $Ammo
@onready var healthLabel = $Health
@onready var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player == null:
		player = Global._rootNode.get_node("Player")
	else:
		var playerSpeed = player.velocity.length()
		var playerAmmo = player.ammoCount
		var playerCap = player.magSize
		var playerHealth = player.health
		healthLabel.text = str(playerHealth)
		speedLabel.text = "Speed: " + str(playerSpeed)
		ammoLabel.text = str(playerAmmo) + "/" + str(playerCap)
