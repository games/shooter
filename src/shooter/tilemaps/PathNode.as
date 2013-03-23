package shooter.tilemaps {

	public class PathNode {

		public static const UNKNOW:String = "";
		public static const EAST:String = "e";
		public static const SOUTH:String = "s";
		public static const WEST:String = "w";
		public static const NORTH:String = "n";
		public static const NORTHEAST:String = "ne";
		public static const SOUTHEAST:String = "se";
		public static const SOUTHWEST:String = "sw";
		public static const NORTHWEST:String = "nw";

		public var x:int;
		public var y:int;
		public var G:int;
		public var F:int;
		public var H:int;
		public var parent:PathNode;

		public function PathNode(x:int, y:int, G:int, F:int, H:int, parent:PathNode) {
			this.x = x;
			this.y = y;
			this.G = G;
			this.F = F;
			this.H = H;
			this.parent = parent;
		}

		public function get direction():String {
			if (parent == null)
				return UNKNOW;
			var i:int = x - parent.x;
			var j:int = y - parent.y;
			if (i < 0) {
				if (j < 0)
					return PathNode.NORTHWEST;
				else if (j == 0)
					return PathNode.WEST;
				else
					return PathNode.SOUTHWEST;
			} else if (i == 0) {
				if (j < 0)
					return PathNode.NORTH;
				else
					return PathNode.SOUTH;
			} else {
				if (j < 0)
					return PathNode.NORTHEAST;
				else if (j == 0)
					return PathNode.EAST;
				else
					return PathNode.SOUTHEAST;
			}
		}
	}
}
