extends Node2D

class_name Elevator

enum KIND {LEFT, RIGHT}
enum COMMAND {RIGHT, LEFT, UP, DOWN}

const min_height = 0
@export var max_height: int = 0
@export var kind : KIND
var input_table : Dictionary = {
  COMMAND.RIGHT: "ELEVATOR_RIGHT",
  COMMAND.LEFT: "ELEVATOR_LEFT",
  COMMAND.UP: "ELEVATOR_UP",
  COMMAND.DOWN: "ELEVATOR_DOWN"
}

var current_floor: int = 0

# For nearly all cases this will end up staying at one
# ! This probably doesn't need to exist. Number of occupants
# ! can be derived from the number of children nodes of type Passenger
var num_occupants = 0
var max_occupants = 1

# TODO: Incorporate if implementing tweening
enum STATE {IDLE, LOADING, MOVING}
var state : STATE = STATE.IDLE


#region temp
var temp_passenger: Passenger
#endregion

func _init() -> void:
  temp_passenger = Passenger.new(4, 0)
  add_child(temp_passenger)
  num_occupants += 1


func _ready():
  var input_prefix: String = "LEFT_" if kind == KIND.LEFT else "RIGHT_"
  for key in input_table:
    input_table[key] = input_prefix + input_table[key]


var open_handler: Callable
func register_opened_handler(handler: Callable):
  open_handler = handler


#region input handling
func _increment_floor(inc: int):
  # ? consider: if states are tweened then we might need to think about this
  # if state != STATE.IDLE:
  #   return

  # check if we can do anything
  if (current_floor == min_height and inc < 0) or (current_floor == max_height and inc > 0):
    # print("Elevator ", kind, " cannot go ", "up" if inc > 0 else "down")
    return

  # apply change to destination floor
  current_floor += inc

  # animate (negative y direction is up)
  position.y = position.y + -1 * inc * ($TextureRect.texture.get_size().y * scale.y)


func _pop_passenger() -> Passenger:
  if num_occupants == 0:
    return null

  var children = get_children()
  for child in children:
    if child is Passenger:
      remove_child(child)
      num_occupants -= 1
      return child

  return null


func _push_passenger(p: Passenger) -> void:
  add_child(p)
  # p.show()
  num_occupants += 1


func _open_door(open_direction: COMMAND):
  # TODO: state change considerations
  if open_handler.is_valid():
    var occupant = _pop_passenger()

    var open_result : Passenger = open_handler.call(kind, open_direction, current_floor, occupant)
    if open_result != null:
      _push_passenger(open_result)

    print("Elevator ", kind, " open_result = ", open_result)
    print("=========")


func _process_inputs():
  if Input.is_anything_pressed():
    if Input.is_action_just_pressed(input_table[COMMAND.DOWN]):
      _increment_floor(-1)
    if Input.is_action_just_pressed(input_table[COMMAND.UP]):
      _increment_floor(1)
    if Input.is_action_just_pressed(input_table[COMMAND.LEFT]):
      _open_door(COMMAND.LEFT)
    if Input.is_action_just_pressed(input_table[COMMAND.RIGHT]):
      _open_door(COMMAND.RIGHT)
#endregion


func _process(_delta: float):
  _process_inputs()

# TODO: Likely need a notification handler to accept a new child node
