extends Node2D

class_name Elevator

enum ELEVATOR_KIND {LEFT, RIGHT}
enum ELEVATOR_COMMANDS {RIGHT, LEFT, UP, DOWN}

@export var elevator_designation : ELEVATOR_KIND
var input_table : Dictionary = {
  ELEVATOR_COMMANDS.RIGHT: "ELEVATOR_RIGHT",
  ELEVATOR_COMMANDS.LEFT: "ELEVATOR_LEFT",
  ELEVATOR_COMMANDS.UP: "ELEVATOR_UP",
  ELEVATOR_COMMANDS.DOWN: "ELEVATOR_DOWN"
}

var left_rooms = [0, 1, 2] # what rooms are on the left
var right_rooms = [4, 5, 6] # what rooms are on the right

var current_floor: int = 0
var dest_floor: int = 0
var min_height = 0
var max_height: int
var elevator_num = elevator_designation
var occupancy: Array[Passenger] = []
var max_occupancy = 1
var is_empty = 1 # may be a redundant flag? thought it may be useful for animations

enum STATE {IDLE, LOADING, MOVING}
var state : STATE = STATE.IDLE

signal left_door_opened(dest_floor)
signal right_door_opened(dest_floor)

func _ready():
  current_floor = 0
  max_height = max(left_rooms.size(), right_rooms.size()) - 1

  var input_prefix: String = "LEFT_" if elevator_designation == ELEVATOR_KIND.LEFT else "RIGHT_"
  for key in input_table:
    input_table[key] = input_prefix + input_table[key]


func _increment_floor(inc: int):
  # if states are tweened then we might need to think about this
  # if state != STATE.IDLE:
  #   return

  # check if we can do anything
  if (dest_floor == min_height and inc < 0) or (dest_floor == max_height and inc > 0):
    print("Elevator ", elevator_designation, " cannot go ", "up" if inc > 0 else "down")
    return

  # apply change to destination floor
  dest_floor += inc

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
      # print("opening left door to room " + str(left_rooms[dest_floor]) + " on elevator " + str(elevator_designation))
      # left_door_opened.emit(left_rooms[dest_floor])

    if Input.is_action_just_pressed(input_table[ELEVATOR_COMMANDS.RIGHT]):
      _open_door(false)
      # print("opening right door to room " + str(right_rooms[dest_floor]) + " on elevator " + str(elevator_designation))
      # right_door_opened.emit(right_rooms[dest_floor])

    # print("destination floor: %s" % str(dest_floor))

  pass
