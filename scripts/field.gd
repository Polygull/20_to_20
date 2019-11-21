extends Node2D

const GRID_STEP = 32
const GRID_RECT = Rect2(0, 0, 608, 608)
const MOVE_TIME = 0.2
const MAX_TURN_COUNT = 20
const PLAYER_SIDE_OFFSET = Vector2(608, 0)

onready var confetti = preload("res://objects/confetti.tscn")

onready var player_start = $player.position
onready var opponent_start = $opponent.position

var player_turn = false
var turn_count = 1
var player_moves = []
var opponent_moves = []

func _ready():
	randomize()
	$ui/logo.visible = true


func _physics_process(delta):
	if player_turn:
		player_move()


func _input(event):
	
	if event is InputEventKey || event is InputEventMouseButton:
		if $ui/logo.visible:
			$ui/logo.visible = false
			$ui/turn_label.visible = true
			$ui/turn_label.text = str(turn_count)
			$animation_player.play("opponent_intro")
	

# for use with animations/timers
func reload():
	get_tree().reload_current_scene()

func turn_setup():
	if turn_count == MAX_TURN_COUNT:
		$ui/turn_label.visible = false
		$ui/congratulations.visible = true
		$timers/congrats_timer.start()
		$timers/confetti_timer.start()
		
		return
	opponent_moves = []
	player_moves = []
	$player.position = player_start
	$opponent.position = opponent_start
	turn_count += 1
	$ui/turn_label.text = str(turn_count)	
	$animation_player.play("opponent_intro")


func player_move():
	var mov = Vector2()
	
#	4 way movement
	if Input.is_action_just_pressed("up"): mov.y -= 1
	elif Input.is_action_just_pressed("down"): mov.y += 1
	elif Input.is_action_just_pressed("right"): mov.x += 1
	elif Input.is_action_just_pressed("left"): mov.x -= 1
	
	if mov != Vector2.ZERO:
		mov *= GRID_STEP
		player_moves.append(mov)
		player_turn = false
		
		for i in range(0, player_moves.size()):
			if player_moves[i] != opponent_moves[i]:
				$animation_player.play("miss")
				return
		
		do_move($player, mov)
		
	

func opponent_move():
	var mov = Vector2()

	mov.x = randi() % 2
	mov.y = 1 - mov.x
	if randi() % 2 == 1: mov *= -1
	mov *= GRID_STEP
	
	opponent_moves.append(mov)
	
	do_move($opponent, mov)
	

func do_move(object, mov):
	$tween.interpolate_property(object, "position", object.position, object.position + mov, MOVE_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()

func _on_tween_completed(object, key):
	pass
	if object == $opponent:
		if opponent_moves.size() < turn_count:
			$timers/opponent_timer.start()
		else:
			$animation_player.play("player_intro")
	elif object == $player:
		if player_moves.size() < opponent_moves.size():
			player_turn = true
		else:
			$animation_player.play("hit")


func add_confetti():
	var temp_confetti = confetti.instance()
	temp_confetti.position = Vector2(rand_range(0, 1248), -16)
	$confetti.add_child(temp_confetti)
	$timers/confetti_timer.start()
