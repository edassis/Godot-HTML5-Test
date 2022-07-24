extends KinematicBody2D

enum State {IDLE, RUN}

const ACC = 40
const MAXSPEED = 130
const FRICTION = 60

var curState = State.IDLE
var dir := Vector2()
var speed := Vector2()
var isFacingLeft := false

onready var bodyAnimation: Sprite = $BodyAnimation
onready var bodyCollision: CollisionShape2D = $BodyCollision
onready var animationPlayer: AnimationPlayer = $BodyAnimation/AnimationPlayer

# Evento de input demora as vezes, melhor usar polling
# Além disso, dessa forma não consigo fazer combinação de tecla.
#func _unhandled_input(event: InputEvent) -> void:
#	dir = Vector2(0, 0)
#
#	if event.is_action("ui_left") and event.is_pressed():
#		dir.x += -1
#
#	if event.is_action("ui_right") and event.is_pressed():
#		dir.x += 1


func _process(delta: float) -> void:
	# Flip sprite horizontally
	if Input.is_action_pressed("ui_left"):
		isFacingLeft = true
		bodyAnimation.flip_h = true
		bodyAnimation.offset.x = -1 * abs(bodyAnimation.offset.x)
	if Input.is_action_pressed("ui_right"):
		isFacingLeft = false
		bodyAnimation.flip_h = false
		bodyAnimation.offset.x = 1 * abs(bodyAnimation.offset.x)

	# Update animation
	match curState:
		State.IDLE:
			animationPlayer.play("IdleR")
#			if isFacingLeft:
#				animationPlayer.play("IdleL")
#			else:
#				animationPlayer.play("IdleR")
		State.RUN:
			animationPlayer.play("RunR")
#			if isFacingLeft:
#				animationPlayer.play("RunL")
#			else:
#				animationPlayer.play("RunR")


func _physics_process(delta: float) -> void:
	# Calculates directions vector
	dir = Vector2(0, 0)

	if Input.is_action_pressed("ui_left"):
		dir.x += -1
	if Input.is_action_pressed("ui_right"):
		dir.x += 1

	# Process new speed
	if (dir.x):
		speed.x += dir.x * ACC
	elif (abs(speed.x) > FRICTION):
		speed.x -= FRICTION * sign(speed.x)
	else:
		speed.x = 0.0

	speed.x = clamp(speed.x, -MAXSPEED, MAXSPEED)

	# Update state
	if (speed.x):
		curState = State.RUN
	else:
		curState = State.IDLE

	# Applies speed
	speed = move_and_slide(speed, Vector2.UP)
