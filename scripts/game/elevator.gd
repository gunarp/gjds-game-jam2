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

const closed_door_texture = preload("uid://b7lp0m626b0wo") as CompressedTexture2D
const open_door_texture = preload("uid://d25nyvwsybslm") as CompressedTexture2D

# For nearly all cases this will end up staying at one
var max_occupants = 1

var queue_ref: CoolQueue

# TODO: Incorporate if implementing tweening
enum STATE {IDLE, LOADING, MOVING}
var state : STATE = STATE.IDLE


func _init() -> void:
  queue_ref = CoolQueue.new(1)
  add_child(queue_ref)


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
    return

  # apply change to destination floor
  current_floor += inc

  # animate (negative y direction is up)
  position.y = position.y + -1 * inc * ($TextureRect.texture.get_size().y)


func _pop_passenger() -> Passenger:
  return queue_ref.pop_passenger(COMMAND.LEFT)


func _push_passenger(p: Passenger) -> void:
  queue_ref.push_passenger(COMMAND.LEFT, p)
  p.z_index = self.z_index + 1
  p.position.x = $TextureRect.texture.get_size().x / 2.0


func _open_door(open_direction: COMMAND):
  # TODO: state change considerations
  if open_handler.is_valid():
    var occupant = _pop_passenger()
    if occupant != null:
      $Ding.play()

    var open_result : Passenger = open_handler.call(kind, open_direction, current_floor, occupant)
    if open_result != null:
      _push_passenger(open_result)
      $Ding.play()

    # print("Elevator ", kind, " open_result = ", open_result)
    # print("=========")

    if queue_ref.is_full():
      $TextureRect.texture = open_door_texture
    else:
      $TextureRect.texture = closed_door_texture


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
