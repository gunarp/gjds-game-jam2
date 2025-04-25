extends Node

class_name Room

# TODO: turn room_number into @onready ? or @export ??
@export var room_number: int
var floor_number = 0 # not sure about this part yet.
var queue: Array[Passenger] = []
var cool_queue: CoolQueue
var max_size = 10

# may want a flag for when a room is being adjusted,
# so we don't have two processes writing to the same queue at once?
enum STATE {IDLE, ADJUSTING}

func _to_string() -> String:
  return "Room " + str(room_number) + ": " + str(queue)

# init function to set room_number?
func _init(room_num: int):
  room_number = room_num

func _ready():
  pass

# not sure if this is relevant to maintaining room queue
func _process(delta: float) -> void:
  pass

# TODO: top of queue goes off into the elevator
func release_passenger() -> void: #maybe a type of Passenger?
  pass

# TODO: gain from elevator and put into back of queue
func gain_passenger():
  pass

# checks if the newly arrived person is in the correct room
# if yes, the person is smote (popped out of the queue (and thus existence))
# not sure if this is the right location for this function
func is_complete(passenger: int) -> void:
  pass

func _on_elevator_left_door_opened(dest_floor: int) -> void:
  print("room noticed elevator left door opened!")
  if dest_floor == room_number:
    print("yay! time to move people around in room %s" % str(room_number))
  else:
    print("ignorning elevator calls")

func _on_elevator_right_door_opened(dest_floor: int) -> void:
  print("room noticed elevator right door opened!")
  if dest_floor == room_number:
    print("yay! time to move people around in room %s" % str(room_number))
  else:
    print("ignorning elevator calls")
