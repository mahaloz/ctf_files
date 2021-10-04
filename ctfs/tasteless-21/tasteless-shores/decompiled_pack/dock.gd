tool 
extends Control

signal changeDrawing
signal select_mesh
signal quantity_change
signal range_distance_change
signal rand_rotate
signal min_rand_scale
signal max_rand_scale
signal generate

var mesh_array = []
var selected_node = null
var selected_mesh_node = null
var counter_index = 0
var meshInstance = null
var btn_mesh = preload("btn_mesh.tscn")
var clickAdd:bool = false
var clickRem:bool = false
var drawing:bool = false

var quantity = 1
var range_distance = 1

var preview_provider:EditorResourcePreview = null
var texture_preview = null

func _on_Add_mesh_pressed():
	$FileDialog.show()
	
func _on_Remove_mesh_pressed():
	if selected_node != null:
		remove_mesh_to_gui(selected_node)

func SelectIndexUpdate(node_selected, mesh_node_selected, name):
	selected_node = node_selected
	selected_mesh_node = mesh_node_selected
	emit_signal("select_mesh", selected_mesh_node, name)

func add_mesh_to_gui(meshGui):
	$TabContainer / resource / VBoxContainer / ScrollContainer / MeshContainer.add_child(meshGui)
	mesh_array.append(meshInstance)
	counter_index += 1
	
func remove_mesh_to_gui(node):
	$TabContainer / resource / VBoxContainer / ScrollContainer / MeshContainer.remove_child(node)
	mesh_array.erase(selected_mesh_node)
	selected_mesh_node = null
	selected_node = null
	counter_index -= 1

func Resource_preview_loaded(path, texture, userdata):
	texture_preview = texture

func _on_FileDialog_file_selected(path):
	meshInstance = load(path)
	preview_provider.queue_resource_preview(path, self, "Resource_preview_loaded", null)
	if meshInstance != null:
		var btn_mesh_ins = btn_mesh.instance()
		var name = meshInstance.resource_name
		if name == "":
			name = path.get_file()
			name = name.substr(0, name.length() - name.get_extension().length() - 1)
		btn_mesh_ins.name_mesh = name
		btn_mesh_ins.idx = counter_index
		btn_mesh_ins.mesh_node = meshInstance
		btn_mesh_ins.texture_preview = texture_preview
		btn_mesh_ins.connect("selectedIndex", self, "SelectIndexUpdate")
		add_mesh_to_gui(btn_mesh_ins)
		meshInstance = null
	else :
		print("No mesh selected")


func _on_drawing_pressed():
	drawing = not drawing
	emit_signal("changeDrawing", drawing)

func _on_quantity_slider_value_changed(value):
	$TabContainer / brush / vbx / ScrollContainer / VBoxContainer / vslider_container / quantity_lbl.set_text("Quantity: " + str(value))
	quantity = value
	emit_signal("quantity_change", quantity)

func _on_range_slider_value_changed(value):
	$TabContainer / brush / vbx / ScrollContainer / VBoxContainer / vslider_container2 / range_lbl.set_text("Range Distance: " + str(value))
	range_distance = value
	emit_signal("range_distance_change", range_distance)

func _on_rot_check_toggled(button_pressed):
	emit_signal("rand_rotate", button_pressed)

func _on_min_x_text_changed(new_text):
	emit_signal("min_rand_scale", float(new_text))

func _on_max_x_text_changed(new_text):
	emit_signal("max_rand_scale", float(new_text))
		

func _on_generate_btn_pressed():
	emit_signal("generate")
