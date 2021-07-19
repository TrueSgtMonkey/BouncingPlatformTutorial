extends KinematicBody

export (Vector3) var bounce = Vector3(0, 5, 0)
export (Vector3) var moveAmount = Vector3(0, 2.5, 0)
export (float) var resetTime = 1.0

var bodies := []
var move := false
var stop := false
var moveTimer := Timer.new()
var stopTimer := Timer.new()
var speed : float
var velocity : Vector3
var origPosition : Vector3
var endPosition : Vector3

func _ready():
	add_child(moveTimer)
	add_child(stopTimer)
	moveTimer.wait_time = resetTime
	stopTimer.wait_time = resetTime
	moveTimer.one_shot = true
	stopTimer.one_shot = true
	moveTimer.connect("timeout", self, "move")
	stopTimer.connect("timeout", self, "stop")
	
	origPosition = global_transform.origin
	endPosition = global_transform.origin + moveAmount
	speed = (endPosition - origPosition).length() / resetTime
	velocity = (endPosition - origPosition).normalized() * speed

func _physics_process(delta):
	for body in bodies:
		if body.has_method("setVelocity"):
			body.setVelocity(bounce)
	if move:
		global_transform.origin += velocity * delta
	if stop:
		global_transform.origin -= velocity * delta
		
func move():
	move = false
	global_transform.origin = endPosition
	stop = true
	stopTimer.start()
	
func stop():
	stop = false
	global_transform.origin = origPosition

func _on_Area_body_entered(body):
	if !(body is StaticBody) && !(body in bodies):
		if !move && !stop:
			move = true
			moveTimer.start()
		bodies.append(body)

func _on_Area_body_exited(body):
	if !(body is StaticBody) && body in bodies:
		bodies.erase(body)
