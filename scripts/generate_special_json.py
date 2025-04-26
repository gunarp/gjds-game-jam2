import random
import json

visual_data = {
    "max_x": 320,
    "max_y": 180,
    "side_margin": 9,
    "floor_margin": 4,
    "room_width": 78,
    "room_height": 50,
    "elevator_width": 35
}


destination_bank = [3 for i in range(9)]

def random_passenger(starting_room):
    # add constraints for how many people can be in each room
    dest_room = random.randint(0, 8)
    accepted = False

    while not accepted:
        if starting_room == dest_room:
            dest_room = random.randint(0, 8)
            continue

        if (destination_bank[dest_room] > 0):
            destination_bank[dest_room] -= 1
            accepted = True
        else:
            dest_room = random.randint(0, 8)

    return [dest_room, random.randint(0, 5)]


if __name__ == "__main__":
    buildings = []

    banned_room_ids = [1, 8]
    for id in banned_room_ids:
        destination_bank[id] = 0

    for i in range(3):
        building_info = dict()
        for j in range(3):
            floor_name = "floor_" + str(j)
            room_id = (3 * i) + j
            max_size = 3

            if room_id in banned_room_ids:
                room_id = -1

            building_info[floor_name] = {
                "room_id": room_id,
                "max_size": 3,
                "initial_passengers": []
            }

            if room_id == -1:
                continue

            # random number of passengers
            passengers = []
            sample_list = [0, 1, 2, 3]
            weights = [30, 40, 25, 5]
            num_passengers = random.choices(sample_list, weights)[0]
            for _ in range(num_passengers):
                passengers.append(random_passenger(room_id))


            for p in passengers:
                building_info[floor_name]["initial_passengers"].append(
                    {
                        "dest_room": p[0],
                        "sprite_style": p[1]
                    }
                )

        buildings.append(building_info)

    ret = {}
    ret["visual_data"] = visual_data
    ret["buildings"] = buildings
    print(json.dumps(ret, indent=2))