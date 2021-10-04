extends Control

const Inventory = preload("res://game/ui/inventory.gd")
const CenterNotification = preload("res://game/ui/center_notification.gd")
const WorldLabel = preload("res://game/ui/world_label.gd")

onready  var game_ui = $GameUIas Control

onready  var hint_interact = $GameUI / HintInteractas Label
onready  var inventory = $GameUI / Inventoryas Inventory
onready  var center_notification = $GameUI / CenterNotificationas CenterNotification
onready  var popup_dialog = $GameUI / PopupDialogas PopupDialog
onready  var world_label = $GameUI / WorldLabelas WorldLabel
onready  var target_label = $GameUI / CrossHair / TargetLabelas Label
onready  var respawn_button = $GameUI / RespawnButtonas Button
onready  var minimap = $GameUI / MiniMap
onready  var player_label = $GameUI / PlayerUI / Labelas Label

func _ready():
	inventory.hide()
	ui_mouse()
	game_ui.hide()
	Client.connect("account_login", self, "_on_Client_account_login")
	Client.connect("send_join", self, "_on_Client_send_join")
	respawn_button.hide()

func _on_Client_account_login(name, team):
	player_label.text = name + "\n<" + team + ">"

func _on_Client_send_join():
	game_ui.show()
	game_mouse()
	respawn_button.hide()

func ui_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func game_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func show_note(text):
	center_notification.display(text)

var askCallback = null

func ask(text:String, caller:Object = null, callback:String = ""):
	ui_mouse()
	(popup_dialog.find_node("Label")as Label).text = text
	popup_dialog.popup()
	
	
	
	
	(popup_dialog.find_node("Accept")as Button).hide()

func _on_PopupDialog_popup_hide():
	askCallback = null
	game_mouse()

func _on_Accept_pressed():
	popup_dialog.hide()
	if askCallback != null:
		askCallback[0].call_deferred(askCallback[1])

func interactable(collider):
	if collider != null and collider.has_method("interact"):
		hint_interact.show()
	else :
		hint_interact.hide()

func attackable(text):
	target_label.text = text

func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		if not $GameMenu.is_visible():
			$GameMenu.popup()
			ui_mouse()
		else :
			$GameMenu.hide()

	if event.is_action_pressed("inventory"):
		if inventory.visible:
			inventory.hide()
			game_mouse()
		else :
			inventory.show()
			ui_mouse()

func dead():
	ui_mouse()
	show_note("Player received signal SIGDEAD")
	respawn_button.show()

func _on_RespawnButton_pressed():
	respawn_button.hide()
	$GameMenu.hide()
	Client.start_respawn()

func _on_QuitButton_pressed():
	get_tree().quit(0)

func _on_PVPButton_pressed():
	Client.toggle_pvp()
	$GameMenu.hide()

func _on_GameMenu_popup_hide():
	game_mouse()
