part of libstreet;


class Platform implements Comparable {
	Point start, end;
	String id;
	bool itemPerm = true, ceiling = false;
	Rectangle bounds;

	Platform(Map platformLine, Map layer, int groundY) {
		id = platformLine['id'];
		ceiling = platformLine['platform_pc_perm'] == 1;

		(platformLine['endpoints'] as List).forEach((Map endpoint) {
			if(endpoint["name"] == "start") {
				start = new Point(endpoint["x"], endpoint["y"] + groundY);
				if(layer['name'] == 'middleground')
					start = new Point(endpoint["x"] + layer['w'] ~/ 2, endpoint["y"] + layer['h'] + groundY);
			}
			if(endpoint["name"] == "end") {
				end = new Point(endpoint["x"], endpoint["y"] + groundY);
				if(layer['name'] == 'middleground')
					end = new Point(endpoint["x"] + layer['w'] ~/ 2, endpoint["y"] + layer['h'] + groundY);
			}
		});

		int width = end.x - start.x;
		int height = end.y - start.y;
		bounds = new Rectangle(start.x,start.y,width,height);
	}

	@override
	String toString() {
		return "(${start.x},${start.y})->(${end.x},${end.y}) ceiling=$ceiling";
	}

	@override
	int compareTo(Platform other) {
		return other.start.y - start.y;
	}
}


class Ladder
{
	String id;
	int x,y,width,height;
	Rectangle bounds;

	Ladder(Map ladder, Map layer, int groundY)
	{
		width = ladder['w'];
		height = ladder['h'];
		x = ladder['x'] + layer['w'] ~/ 2 - width ~/ 2;
		y = ladder['y'] + layer['h'] - height + groundY;
		id = ladder['id'];

		bounds = new Rectangle(x, y, width, height);
	}
}


class Wall {
	String id;
	int x, y, width, height;
	Rectangle bounds;

	Wall(Map wall, Map layer, int groundY) {
		width = wall['w'];

		height = wall['h'];
		x = wall['x'] + layer['w'] ~/ 2 - width ~/ 2;
		y = wall['y'] + layer['h'] + groundY;
		id = wall['id'];

		bounds = new Rectangle(x, y, width, height);
	}

	@override
	toString() => "wall $id: " + bounds.toString();
}
