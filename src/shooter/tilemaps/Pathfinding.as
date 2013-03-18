package shooter.tilemaps {
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class Pathfinding {

		public static function find(map:MapData, start:Point, target:Point):Array {

			var open:Array = [], close:Array = [], openDict:Dictionary = new Dictionary(), closeDict:Dictionary = new Dictionary();

			var moveToOpen:Function = function(node:Object):void {
				openDict[node.x + "," + node.y] = node;
				open.push(node);
			};

			var moveToClose:Function = function(node:Object):void {
				close.push(node);
				closeDict[node.x + "," + node.y] = node;
			};

			var manhattan:Function = function(x:int, y:int, cost:int = 10):int {
				return (Math.abs(target.x - x) + Math.abs(target.y - y)) * cost;
			};
			
			var euclidian:Function = function(x:int, y:int, cost:int = 10):int{
				var dx:Number = x - target.x;
				var dy:Number = y - target.y;
				return Math.sqrt( dx * dx + dy * dy ) * cost;
			};
				
			var heuristic:Function = manhattan;

			var calculateScore:Function = function(node:Object, g:int):void {
				node.G = g + node.parent.G;
				node.F = node.G + heuristic(node.x, node.y);
			};

			var available:Function = function(x:int, y:int):Boolean {
				return !map.blocked(x, y) && closeDict[x + "," + y] == null;
			};

			var buildPath:Function = function(end:Object):Array {
				var path:Array = [end];
				while (end.parent) {
					path.push(end.parent);
					end = end.parent;
				}
				return path.reverse();
			}


			moveToOpen({x: start.x, y: start.y, parent: null, G: 0, F: heuristic(start.x, start.y)});

			var c:int =0;
			while (open.length > 0) {
				open.sortOn("F", Array.NUMERIC | Array.DESCENDING);
				var curr:Object = open.pop();
				moveToClose(curr);

				for (var i:int = -1; i < 2; i++) {
					for (var j:int = -1; j < 2; j++) {
						if (i == 0 && j == 0)
							continue;
						var x:int = curr.x + i, y:int = curr.y + j;
						trace("test:", x, y, ++c);
						var g:int = 10;
						//corner
						if (i != 0 && j != 0) {
							if (map.blocked(curr.x, y) || map.blocked(x, curr.y))
								continue;
							g = 14;
						}

						if (x == target.x && y == target.y)
							return buildPath({x: x, y: y, parent: curr});

						if (available(x, y)) {
							var node:Object = openDict[x + "," + y];
							if (!node) {
								node = {x: x, y: y, parent: curr};
								calculateScore(node, g);
								moveToOpen(node);
							} else if (node.G > g + curr.G) {
								node.parent = curr;
								calculateScore(node, g);
							}
						}
					}
				}
			}
			return [];
		}
	}
}


