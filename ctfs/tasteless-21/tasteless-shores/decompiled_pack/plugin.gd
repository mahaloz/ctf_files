tool 
extends EditorPlugin

var dock = preload("dock/dock.tscn").instance()



var mesh_selected:Mesh = null
var mesh_name:String = ""
var multimesh_array = []

var drawing:bool = false
var quantity = 1
var range_distance = 1
var rand_rotate:bool = false
var min_rand_scale:float = 1.0
var max_rand_scale:float = 1.0
var collision:bool = false

func _enter_tree():
	dock.connect("changeDrawing", self, "enable_drawing")
	dock.connect("select_mesh", self, "mesh_selected")
	dock.connect("quantity_change", self, "quantity_changed")
	dock.connect("range_distance_change", self, "distance_changed")
	dock.connect("rand_rotate", self, "rand_rotate")
	dock.connect("min_rand_scale", self, "min_rand_scale")
	dock.connect("max_rand_scale", self, "max_rand_scale")
	dock.connect("generate", self, "generate")
	dock.preview_provider = get_editor_interface().get_resource_previewer()
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT, dock)

func rand_rotate(value):
	rand_rotate = value

func min_rand_scale(value):
	min_rand_scale = value

func max_rand_scale(value):
	max_rand_scale = value

func distance_changed(dis):
	range_distance = dis

func quantity_changed(qt):
	quantity = qt

func enable_drawing(value):
	drawing = value

func mesh_selected(mesh_ins, name):
	mesh_selected = mesh_ins
	mesh_name = name

func forward_spatial_gui_input(camera, event):
	var cur_editor_scene = get_tree().edited_scene_root
	var captured_event:bool = false
	if event is InputEventMouseButton and drawing:
		if event.is_pressed() and event.button_index == BUTTON_LEFT and not event.is_echo():
			captured_event = true
			var space_state = get_viewport().world.direct_space_state

			var mmname = "multimesh_" + mesh_name

			var multimesh = cur_editor_scene.get_node(mmname)
			if multimesh == null:
				multimesh = MultiMeshInstance.new()
				multimesh.name = mmname
				multimesh.multimesh = MultiMesh.new()
				multimesh.multimesh.mesh = mesh_selected
				
				multimesh.multimesh.transform_format = MultiMesh.TRANSFORM_3D
				
				cur_editor_scene.add_child(multimesh)
				multimesh.set_owner(cur_editor_scene)

			
			var from = camera.project_ray_origin(event.position)
			
			var to = from + camera.project_ray_normal(event.position) * 1000
			var result = space_state.intersect_ray(from, to)

			if result.has("position"):
				for i in quantity:
					var randScale = rand_range(min_rand_scale, max_rand_scale)
					var transf = Transform(Basis(), Vector3.ZERO).scaled(Vector3(randScale, randScale, randScale))
					if rand_rotate:
						transf = transf.rotated(Vector3.UP, deg2rad(rand_range(0, 360)))
					
					var mm = MeshInstance.new()
					mm.mesh = mesh_selected
					mm.transform = transf
					mm.transform.origin = result.position
					mm.name = mesh_name

					multimesh.add_child(mm)
					mm.set_owner(cur_editor_scene)
	return captured_event


func edit(object):
	if object:
		set_physics_process(true)
	else :
		set_physics_process(false)
	return object


func handles(object):
	return object

func _exit_tree():
	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT, dock)
	dock.free()

func generate():
	var mmname = "multimesh_" + mesh_name
	var multimesh = get_tree().edited_scene_root.get_node(mmname)
	if multimesh == null:
		return 
	
	multimesh.multimesh.instance_count = multimesh.get_child_count()
	multimesh.multimesh.mesh = mesh_selected
	for i in multimesh.multimesh.instance_count:
		var transf = multimesh.get_children()[i].transform
		multimesh.get_children()[i].queue_free()
		multimesh.multimesh.set_instance_transform(i, transf)
