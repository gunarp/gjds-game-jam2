extends Node

class_name Room

# TODO: turn room_number into @onready ? or @export ??
@export var room_number: int
var cool_queue: CoolQueue

# may want a flag for when a room is being adjusted,
# so we don't have two processes writing to the same queue at once?
enum STATE {IDLE, ADJUSTING}

# init function to set room_number?
func _init(room_num: int):
  room_number = room_num

func _ready():
  pass

# not sure if this is relevant to maintaining room queue
func _process(_delta: float) -> void:
  pass

# TODO: top of queue goes off into the elevator
func pop_passenger() -> Passenger: #maybe a type of Passenger?
  return null

# TODO: gain from elevator and put into back of queue
func push_passenger(passenger: Passenger) -> void:
  # When passenger arrives, check destination of passenger
  # if passenger desitnation is this room, set passenger to arrived
  # and send a signal out to level_state that an arrival happened
  pass

func is_full() -> bool:
  return cool_queue.is_full()

# # checks if the newly arrived person is in the correct room
# # if yes, the person is smote (popped out of the queue (and thus existence))
# # not sure if this is the right location for this function
# func is_complete(passenger: int) -> void:
#   pass

