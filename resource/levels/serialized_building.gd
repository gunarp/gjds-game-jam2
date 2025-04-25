extends Resource

class_name SerializedBuilding

@export var rooms: Dictionary[int, SerializedRoom]

func _init(_rooms = {} as Dictionary[int, SerializedRoom]) -> void:
  rooms = _rooms
