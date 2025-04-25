extends Node2D

class_name Elevator

enum ELEVATOR_KIND {LEFT, RIGHT}
enum ELEVATOR_COMMANDS {RIGHT, LEFT, UP, DOWN}

const min_height = 0
@export var max_height: int = 0
@export var elevator_designation : ELEVATOR_KIND
var input_table : Dictionary = {
  ELEVATOR_COMMANDS.RIGHT: "ELEVATOR_RIGHT",
  ELEVATOR_COMMANDS.LEFT: "ELEVATOR_LEFT",
  ELEVATOR_COMMANDS.UP: "ELEVATOR_UP",
  ELEVATOR_COMMANDS.DOWN: "ELEVATOR_DOWN"
}

var current_floor: int = 0

var occupancy: Array[Passenger] = []
var max_occupancy = 1
var is_empty = 1 # may be a redundant flag? thought it may be useful for animations

# TODO: Incorporate if implementing tweening
enum STATE {IDLE, LOADING, MOVING}
var state : STATE = STATE.IDLE


func _ready():
  var input_prefix: String = "LEFT_" if elevator_designation == ELEVATOR_KIND.LEFT else "RIGHT_"
  for key in input_table:
    input_table[key] = input_prefix + input_table[key]



func _increment_floor(inc: int):
  # ? consider: if states are tweened then we might need to think about this
  # if state != STATE.IDLE:
  #   return

  # check if we can do anything
  if (current_floor == min_height and inc < 0) or (current_floor == max_height and inc > 0):
    print("Elevator ", elevator_designation, " cannot go ", "up" if inc > 0 else "down")
    return

  # apply change to destination floor
  current_floor += inc

  # animate (negative y direction is up)
  position.y = position.y + -1 * inc * ($TextureRect.texture.get_height() * global_scale.y)


func _open_door(is_open_left: bool):
  print("Elevator ", elevator_designation, " opening, ", "left" if is_open_left else "right")
  # TODO: Change state and load / unload elevator as appropriate


func _process(_delta: float):
  if Input.is_anything_pressed():
    if Input.is_action_just_pressed(input_table[ELEVATOR_COMMANDS.DOWN]):
      _increment_floor(-1)
    if Input.is_action_just_pressed(input_table[ELEVATOR_COMMANDS.UP]):
      _increment_floor(1)
    if Input.is_action_just_pressed(input_table[ELEVATOR_COMMANDS.LEFT]):
      _open_door(true)
    if Input.is_action_just_pressed(input_table[ELEVATOR_COMMANDS.RIGHT]):
      _open_door(false)


# TODO: Likely need a notification handler to accept a new child node
