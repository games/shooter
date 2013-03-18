package shooter.tilemaps {
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class Pathfinding {

		public static function find(map:MapData, start:Point, target:Point):Array {

			var open:Array = [], close:Array = [], openDict:Dictionary = new Dictionary(), closeDict:Dictionary = new Dictionary();

			var h:Function = function(x:int, y:int):int {
				return (Math.abs(target.x - x) + Math.abs(target.y - y)) * 10;
			};

			var s:Object = {x: start.x, y: start.y, parent: null, G: 0, F: 0};
			s.F = s.H = h(start.x, start.y);
			open.push(s);

			var end:Object = null;
			while (open.length > 0) {
				open.sortOn("F", Array.NUMERIC | Array.DESCENDING);
				var curr:Object = open.pop();
				close.push(curr);
				closeDict[curr.x + "," + curr.y] = curr;

				for (var i:int = -1; i < 2; i++) {
					for (var j:int = -1; j < 2; j++) {
						if (i == 0 && j == 0)
							continue;

						var x:int = curr.x + i, y:int = curr.y + j;
						var key:String = x + "," + y;
						var gForCurrToNode:int = 10;
						//corner
						if (i != 0 && j != 0) {
							gForCurrToNode = 14;
							if (map.blocked(curr.x, y) || map.blocked(x, curr.y))
								continue;
						}

						if (x == target.x && y == target.y)
							return buildPath({x: x, y: y, parent: curr});

						if (!map.blocked(x, y) && closeDict[key] == null) {
							var node:Object = openDict[key];
							if (!node) {
								node = {x: x, y: y, parent: curr};
								node.G = gForCurrToNode + curr.G;
								node.H = h(node.x, node.y);
								node.F = node.G + node.H;
								openDict[key] = node;
								open.push(node);
							} else if (node.G > gForCurrToNode + curr.G) {
								node.parent = curr;
								node.G = gForCurrToNode + curr.G;
								node.H = h(node.x, node.y);
								node.F = node.G + node.H;
							}
						}
					}
				}
			}
			return [];
		}

		private static function buildPath(end:Object):Array {
			var path:Array = [end];
			while (end.parent) {
				path.push(end.parent);
				end = end.parent;
			}
			return path.reverse();
		}

	}
}


