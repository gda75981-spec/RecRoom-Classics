extends Control

var touch_id := -1
var direction := Vector2.ZERO
var radius := 75.0

func _ready():
    custom_minimum_size = Vector2(180, 180)
    mouse_filter = Control.MOUSE_FILTER_STOP

func _draw():
    draw_circle(Vector2(90, 90), radius, Color(0.2, 0.2, 0.2, 0.45))
    draw_arc(Vector2(90, 90), radius, 0, TAU, 48, Color(1, 1, 1, 0.65), 3)
    draw_circle(Vector2(90, 90) + direction * 45, 31, Color(0.85, 0.9, 1, 0.8))

func _gui_input(event):
    if event is InputEventScreenTouch:
        if event.pressed and touch_id == -1:
            touch_id = event.index
            update_direction(event.position)
        elif not event.pressed and event.index == touch_id:
            release_joystick()

    elif event is InputEventScreenDrag and event.index == touch_id:
        update_direction(event.position)

func update_direction(pos: Vector2):
    var center = Vector2(90, 90)
    direction = (pos - center).limit_length(1.0)
    Input.action_press("move_left", max(0.0, -direction.x))
    Input.action_press("move_right", max(0.0, direction.x))
    Input.action_press("move_forward", max(0.0, -direction.y))
    Input.action_press("move_backward", max(0.0, direction.y))
    queue_redraw()

func release_joystick():
    touch_id = -1
    direction = Vector2.ZERO
    for action in ["move_left", "move_right", "move_forward", "move_backward"]:
        Input.action_release(action)
    queue_redraw()
