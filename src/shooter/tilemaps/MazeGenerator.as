package shooter.tilemaps {
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import shooter.utils.RandomUtils;

	public class MazeGenerator {
		public static function build(col:int, row:int, startX:int = 0, startY:int = 0):Array {
			var map:Array = [];
			for (var y:int = 0; y < row; y++) {
				var rows:Array = [];
				for (var x:int = 0; x < col; x++) {
					rows[x] = 1;
				}
				map.push(rows);
			}

			var path:Array = [];
			var curr:Point = new Point(startX, startY);
			addToPath(null, curr, map, path);
			while (curr) {
				var node:Point = findNode(curr, path, map, col, row);
				if (node) {
					addToPath(curr, node, map, path);
					curr = node;
				} else if (path.length > 1) {
					path.pop();
					curr = path[path.length - 1];
					if (curr.x == startX && curr.y == startY)
						curr = null;
				} else {
					curr = null
				}
			}
			return map;
		}

		private static function addToPath(last:Object, node:Object, map:Array, path:Array):void {
			path.push(node);
			map[node.y][node.x] = 2;
			if (last) {
				if (last.x == node.x)
					map[last.x][int((last.y + node.y) / 2)] = 2;
				else
					map[int((last.x + node.x) / 2)][last.y] = 2;
			}
		}

		private static function findNode(curr:Object, path:Array, map:Array, column:int, row:int):Point {
			var nears:Array = [];
			walkable(nears, curr.x - 2, curr.y, column, row, map);
			walkable(nears, curr.x + 2, curr.y, column, row, map);
			walkable(nears, curr.x, curr.y - 2, column, row, map);
			walkable(nears, curr.x, curr.y + 2, column, row, map);
			return RandomUtils.take(nears);
		}

		private static function walkable(nodes:Array, x:int, y:int, column:int, row:int, map:Array):void {
			var pos:Point = new Point(x, y);
			if (inMap(pos, column, row) && map[pos.y][pos.x] == 1)
				nodes.push(pos);
		}

		private static function inMap(pos:Point, col:int, row:int):Boolean {
			return pos.x >= 0 && pos.y >= 0 && pos.x < col && pos.y < row;
		}
	}
}
