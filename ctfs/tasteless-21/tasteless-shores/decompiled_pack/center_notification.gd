extends Control

onready  var label = find_node("Label")as Label
onready  var anim = $AnimationPlayeras AnimationPlayer
onready  var timer = $Timeras Timer

func _ready():
	_on_Timer_timeout()

func display(text:String, timeout = 5):
	label.text = text
	anim.play("fade")
	timer.start(timeout)

func _on_Timer_timeout():
	anim.play_backwards("fade")
