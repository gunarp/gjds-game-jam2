
class_name LevelGenerator

const visual_data = {
  "max_x": 320,
  "max_y": 180,
  "side_margin": 9,
  "floor_margin": 4,
  "room_width": 78,
  "room_height": 50,
  "elevator_width": 35
}


static func generate_level(level_id: int) -> Dictionary:
  var dest_bank = [3, 3, 3, 3, 3, 3, 3, 3, 3]
  var banned_ids = []
  var distribution = [40, 30, 15, 5]
  var rng = RandomNumberGenerator.new()

  if level_id == 3:
    banned_ids = [1, 8]
    distribution = [30, 35, 20, 5]

  for id in banned_ids:
    dest_bank[id] = 0

  var buildings = []
  for b_id in range(3):
    var b_info = {}
    for f_id in range(3):
      var floor_name = "floor_" + str(f_id)
      var room_id = (3 * b_id) + f_id

      if room_id in banned_ids:
        room_id = -1

      b_info[floor_name] = {
        "room_id": room_id,
        "max_size": 3,
        "initial_passengers": []
      }

      if room_id == -1:
        continue

      var passengers = []
      var num_passengers = rng.rand_weighted(distribution)
      for i in range(num_passengers):
        var dest_room = rng.randi_range(0, 8)
        var accepted = false

        while not accepted:
          if room_id == dest_room:
            dest_room = rng.randi_range(0, 8)
            continue

          if dest_bank[dest_room] > 0:
            dest_bank[dest_room] -= 1
            accepted = true
          else:
            dest_bank = rng.randi_range(0, 8)

        passengers.push_back({
          "dest_room": dest_room,
          "sprite_style": rng.randi_range(0, 5)
        })

      b_info[floor_name]["initial_passengers"] = passengers
    buildings.push_back(b_info)

  return {
    "visual_data": visual_data,
    "buildings": buildings
  }