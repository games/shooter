package shooter.tilemaps {
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class MapData {
		public var orientation:String;
		public var column:int;
		public var row:int;
		public var tileWidth:int;
		public var tileHeight:int;
		public var textures:Array;
		public var layers:Vector.<LayerDef>;
		public var objectGroups:Dictionary;
		public var blocks:Dictionary;
		public var tileDefs:Dictionary;

		public function MapData() {
			tileDefs = new Dictionary();
			blocks = new Dictionary();
		}

		public function blocked(x:int, y:int):Boolean {
			if (x < 0 || y < 0 || x > column || y > row)
				return true;
			return blocks[x + "," + y];
		}

		public function getTileById(tileId:int):TileDef {
			if (tileDefs[tileId])
				return tileDefs[tileId];

			var index:int = tileId;
			for each (var texture:Object in textures) {
				if (index <= texture.count) {
					index--;
					var tileInfo:TileDef = new TileDef(texture.source, new Rectangle(int(index % texture.width) * (tileWidth + texture.spacing) + texture.margin, int(index / texture.width) * (tileHeight + texture.spacing) + texture.margin, tileWidth, tileHeight));
					tileDefs[tileId] = tileInfo;
					return tileInfo;
				} else {
					index -= texture.count;
				}
			}
			return null;
		}
	}
}
