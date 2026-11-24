extends CanvasLayer

const Joystick = preload("res://scripts/joystick.gd")

func _ready():
    var root = Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    root.mouse_filter = Control.MOUSE_FILTER_PASS
    add_child(root)

    var stick = Joystick.new()
    stick.anchor_left = 0
    stick.anchor_top = 1
    stick.anchor_right = 0
    stick.anchor_bottom = 1
    stick.offset_left = 25
    stick.offset_top = -205
    stick.offset_right = 205
    stick.offset_bottom = -25
    root.add_child(stick)

    var jump = Button.new()
    jump.text = "JUMP"
    jump.custom_minimum_size = Vector2(105, 75)
    jump.anchor_left = 1
    jump.anchor_top = 1
    jump.anchor_right = 1
    jump.anchor_bottom = 1
    jump.offset_left = -135
    jump.offset_top = -115
    jump.offset_right = -30
    jump.offset_bottom = -40
    root.add_child(jump)

    jump.button_down.connect(func(): Input.action_press("jump"))
    jump.button_up.connect(func(): Input.action_release("jump"))
