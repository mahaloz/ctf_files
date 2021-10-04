extends MeshInstance

signal water_entered
signal water_exited

func _ready():
	
	
	pass

func _on_WaterArea_body_entered(body:Node):
	
	
	if body.has_method("_on_Water_water_entered"):
		body._on_Water_water_entered()

func _on_WaterArea_body_exited(body:Node):
	
	
	if body.has_method("_on_Water_water_exited"):
		body._on_Water_water_exited()
