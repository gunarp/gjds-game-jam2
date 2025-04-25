extends Node2D

class_name Room

signal passenger_arrived_at_destination

# TODO: turn room_number into @onready ? or @export ??
@export var room_number: int
var queue_ref: CoolQueue

# may want a flag for when a room is being adjusted,
# so we don't have two processes writing to the same queue at once?
enum STATE {IDLE, ADJUSTING}

func _to_string() -> String:
  return "room number: " + str(room_number) + ", " + str(get_child_count())

# init function to set room_number?
func _init(room_num: int, init_passengers: Array):
  print(room_num)
  print(init_passengers)
  room_number = room_num

  queue_ref = CoolQueue.new()
  add_child(queue_ref)

  # !! divergence - cool queue is currently implemented to handle parenting of passenger nodes
  # !! - peter
  for i in range(init_passengers.size()):
    # initialize and attach a passenger child (?)
    # pass in int(init_passengers[i]["dest_room"]), int(init_passengers[i]["sprite_style"])
    print("passing to Passenger dest %d" % int(init_passengers[i]["dest_room"]))
    print("passing to Passenger style %d" % int(init_passengers[i]["sprite_style"]))
    var test_passenger = Passenger.new(int(init_passengers[i]["dest_room"]), int(init_passengers[i]["sprite_style"]))
    add_child(test_passenger)
    

func _ready():
  pass


# not sure if this is relevant to maintaining room queue
func _process(_delta: float) -> void:
  pass


func pop_passenger(direction: Elevator.COMMAND) -> Passenger:
  return queue_ref.pop_passenger(direction)


func push_passenger(direction: Elevator.COMMAND, passenger: Passenger) -> void:
  if passenger.dest_id == room_number:
    passenger.arrived = true
    passenger_arrived_at_destination.emit()

  queue_ref.push_passenger(direction, passenger)


func is_full() -> bool:
  return queue_ref.is_full()

# # checks if the newly arrived person is in the correct room
# # if yes, the person is smote (popped out of the queue (and thus existence))
# # not sure if this is the right location for this function
# func is_complete(passenger: int) -> void:
#   pass
