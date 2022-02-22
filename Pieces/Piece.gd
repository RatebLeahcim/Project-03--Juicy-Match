extends Node2D

export (String) var color
var is_matched
var is_counted
var selected = false
var target_position = Vector2(0,0)
var default_modulate = Color(1,1,1,1)
var highlight = Color(1,0.8,0,1)

var Effects = null
var dying = false
var Explosion = preload("res://Explosion.tscn")
var sound_1 = null
var sound_2 = null

var Coin = preload("res://Coin.tscn")

func _ready():
	default_modulate = modulate
	$Select.texture = $Sprite.texture
	$Select.scale = $Sprite.scale

func _physics_process(_delta):
	if dying:
		queue_free()
	if selected:
		$Select.show()
		$Selected.emitting = true
	else:
		$Select.hide()
		$Selected.emitting = false

func move_piece(change):
	target_position = position + change
	position = target_position
	if sound_2 == null:
		sound_2 = get_node_or_null("/root/Game/2")
	if sound_2 != null:
		sound_2.play()

func die():
	dying = true;
	if sound_1 == null:
		sound_1 = get_node_or_null("/root/Game/1")
	if sound_1 != null:
		sound_1.play()
	if Effects == null:
		Effects = get_node_or_null("/root/Game/Effects")
	if Effects != null:
		get_parent().remove_child(self)
		Effects.add_child(self)
		$Timer.wait_time = 0.5 + (randf() / 10.0)
		$Timer.start()
		$Falling.emitting = true
	if Effects == null:
		Effects = get_node_or_null("/root/Game/Effects")
	if Effects != null:
		var coin = Coin.instance()
		coin.position = target_position
		Effects.add_child(coin)


func _on_Timer_timeout():
	if Effects == null:
		Effects = get_node_or_null("/root/Game/Effects")
	if Effects != null:
		var explosion = Explosion.instance()
		explosion.position = position
		Effects.add_child(explosion)
	dying = true;
