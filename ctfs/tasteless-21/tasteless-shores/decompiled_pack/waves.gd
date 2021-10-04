extends MeshInstance

export  var player:NodePath
var tracked:Spatial




func _ready():
	
	tracked = get_parent()


func _physics_process(_delta):
	
	var dx = fmod(tracked.global_transform.origin.x, 2 * PI)
	var dz = fmod(tracked.global_transform.origin.z, 2 * PI)
	global_transform.origin.x = tracked.global_transform.origin.x - dx
	global_transform.origin.z = tracked.global_transform.origin.z - dz
	global_transform.origin.y = 0
	global_transform.basis = Basis.IDENTITY
	
