package shooter.tilemaps {
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class Pathfinding {

		private static function moveToOpen(node:PathNode, openDict:Dictionary, openList:Array):void {
			openDict[node.x + "," + node.y] = node;
			openList.push(node);
		}

		private static function moveToClose(node:PathNode, closeDict:Dictionary):void {
			closeDict[node.x + "," + node.y] = node;
		}

		private static function manhattan(x:int, y:int, target:Point, cost:int = 10):int {
			return (Math.abs(target.x - x) + Math.abs(target.y - y)) * cost;
		}

		private static function euclidian(x:int, y:int, target:Point, cost:int = 10):int {
			var dx:Number = x - target.x;
			var dy:Number = y - target.y;
			return Math.sqrt(dx * dx + dy * dy) * cost;
		}

		private static function calculateScore(node:PathNode, target:Point, g:int):void {
			node.G = g + node.parent.G;
			node.F = node.G + manhattan(node.x, node.y, target);
		}

		private static function available(x:int, y:int, map:MapData, closeDict:Dictionary):Boolean {
			return !map.blocked(x, y) && closeDict[x + "," + y] == null;
		}
		;

		private static function buildPath(end:PathNode):Array {
			var path:Array = [end];
			while (end.parent) {
				path.push(end.parent);
				end = end.parent;
			}
			return path.reverse();
		}


		/**
		 * Will use BinaryHeap to sort.
		 */
		public static function find(map:MapData, start:Point, target:Point):Array {
			var open:Array = [], close:Array = [], openDict:Dictionary = new Dictionary(), closeDict:Dictionary = new Dictionary();
			moveToOpen(new PathNode(start.x, start.y, 0, manhattan(start.x, start.y, target), 0, null), openDict, open);

			while (open.length > 0) {
				open.sortOn("F", Array.NUMERIC | Array.DESCENDING);
				var curr:PathNode = open.pop();
				moveToClose(curr, closeDict);

				for (var i:int = -1; i < 2; i++) {
					for (var j:int = -1; j < 2; j++) {
						if (i == 0 && j == 0)
							continue;
						var x:int = curr.x + i, y:int = curr.y + j;
						var corner:Boolean = i != 0 && j != 0;
						if (corner && (map.blocked(curr.x, y) || map.blocked(x, curr.y)))
							continue;

						if (x == target.x && y == target.y)
							return buildPath(new PathNode(x, y, 0, 0, 0, curr));

						if (available(x, y, map, closeDict)) {
							var g:int = corner ? 14 : 10;
							var node:PathNode = openDict[x + "," + y];
							if (!node) {
								node = new PathNode(x, y, 0, 0, 0, curr);
								calculateScore(node, target, g);
								moveToOpen(node, openDict, open);
							} else if (node.G > g + curr.G) {
								node.parent = curr;
								calculateScore(node, target, g);
							}
						}
					}
				}
			}
			return [];
		}
	}
}


