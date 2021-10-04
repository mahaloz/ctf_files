extends Control

onready  var health_bar = $HealthBaras ProgressBar

func _process(_delta):
	if Client.socket == null:
		return 
	if Client.player == null:
		return 
	
	health_bar.value = Client.player.health
