extends Spatial

var attackRate = 2.0;
var lastAttackTime = 0

var rabbit:Vector3

func name()->String:
	return "Conch"

func _init():
	rabbit = Vector3(rand_range( - 100, 100), rand_range( - 100, 100), rand_range( - 100, 100))
	

const rabbit_distance = 0.1

func use(collider, from):
	if OS.get_ticks_msec() - lastAttackTime < attackRate * 1000:
		return false
	lastAttackTime = OS.get_ticks_msec()

	Server.conch(from, from.global_transform.origin.distance_to(rabbit))
	if from.global_transform.origin.distance_to(rabbit) < rabbit_distance:
		Server.spawn_chest(from, "FLAG_CONCH", rabbit)

	return true

static func conch(distance, player):
	var x = player.global_transform.origin.x
	var y = player.global_transform.origin.y 
	var z = player.global_transform.origin.z
	
	var notif = String(distance) + ": (" + String(x) + "," + String(y) + "," + String(z) + ")"
	Ui.show_note(notif)
