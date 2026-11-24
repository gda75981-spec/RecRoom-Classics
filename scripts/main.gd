extends Node3D

var player: CharacterBody3D
var camera: Camera3D
var pitch := 0.0
var yaw := 0.0
var speed := 5.0
var gravity := 18.0

func _ready():
    create_room()
    create_player()
    create_lighting()
    create_title()
    var controls = CanvasLayer.new()
    controls.set_script(load("res://scripts/mobile_controls.gd"))
    add_child(controls)

func make_box(parent: Node3D, size: Vector3, pos: Vector3, color: Color):
    var body = StaticBody3D.new()
    body.position = pos
    parent.add_child(body)
    var mesh = MeshInstance3D.new()
    var shape_mesh = BoxMesh.new()
    shape_mesh.size = size
    mesh.mesh = shape_mesh
    var material = StandardMaterial3D.new()
    material.albedo_color = color
    mesh.material_override = material
    body.add_child(mesh)
    var collision = CollisionShape3D.new()
    var shape = BoxShape3D.new()
    shape.size = size
    collision.shape = shape
    body.add_child(collision)

func create_room():
    make_box(self, Vector3(14, 0.3, 14), Vector3(0, -0.15, 0), Color("#b7a58c"))
    make_box(self, Vector3(14, 5, 0.3), Vector3(0, 2.5, -7), Color("#e5d8c6"))
    make_box(self, Vector3(0.3, 5, 14), Vector3(-7, 2.5, 0), Color("#d8c9b6"))
    make_box(self, Vector3(0.3, 5, 14), Vector3(7, 2.5, 0), Color("#d8c9b6"))
    make_box(self, Vector3(14, 5, 0.3), Vector3(0, 2.5, 7), Color("#e5d8c6"))
    make_box(self, Vector3(14, 0.3, 14), Vector3(0, 5, 0), Color("#eee8df"))
    make_box(self, Vector3(3.5, 0.35, 2.2), Vector3(-3.5, 0.8, -3.5), Color("#567b9c"))
    make_box(self, Vector3(3.5, 0.8, 0.25), Vector3(-3.5, 0.4, -4.5), Color("#80634f"))
    make_box(self, Vector3(1.5, 1.5, 0.8), Vector3(4.5, 0.75, -4.5), Color("#8c6a50"))
    make_box(self, Vector3(2.2, 0.15, 1.2), Vector3(3.8, 1.4, 2.8), Color("#a47c5b"))

func create_player():
    player = CharacterBody3D.new()
    player.position = Vector3(0, 1, 2)
    add_child(player)
    var collision = CollisionShape3D.new()
    var capsule = CapsuleShape3D.new()
    capsule.radius = 0.38
    capsule.height = 1.8
    collision.shape = capsule
    player.add_child(collision)
    var body_mesh = MeshInstance3D.new()
    var capsule_mesh = CapsuleMesh.new()
    capsule_mesh.radius = 0.38
    capsule_mesh.height = 1.8
    body_mesh.mesh = capsule_mesh
    var material = StandardMaterial3D.new()
    material.albedo_color = Color("#4c9bd6")
    body_mesh.material_override = material
    player.add_child(body_mesh)
    camera = Camera3D.new()
    camera.position = Vector3(0, 0.55, 0)
    camera.current = true
    player.add_child(camera)

func create_lighting():
    var sun = DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-45, -30, 0)
    sun.light_energy = 1.1
    add_child(sun)
    var world = WorldEnvironment.new()
    var environment = Environment.new()
    environment.background_mode = Environment.BG_SKY
    environment.sky = Sky.new()
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    environment.ambient_light_color = Color("#b8c9dc")
    environment.ambient_light_energy = 0.65
    world.environment = environment
    add_child(world)

func create_title():
    var ui = CanvasLayer.new()
    var label = Label.new()
    label.text = "REC ROOM CLASSICS  |  DORM ROOM"
    label.position = Vector2(24, 22)
    label.add_theme_font_size_override("font_size", 22)
    ui.add_child(label)
    add_child(ui)

func _physics_process(delta):
    var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    var direction = player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)
    direction = direction.normalized()
    player.velocity.x = direction.x * speed
    player.velocity.z = direction.z * speed
    if not player.is_on_floor():
        player.velocity.y -= gravity * delta
    elif Input.is_action_just_pressed("jump"):
        player.velocity.y = 6.0
    player.move_and_slide()

func _input(event):
    if event is InputEventScreenDrag:
        if event.position.x > get_viewport().get_visible_rect().size.x * 0.35:
            yaw -= event.relative.x * 0.004
            pitch = clamp(pitch - event.relative.y * 0.004, -1.3, 1.3)
            player.rotation.y = yaw
            camera.rotation.x = pitch
