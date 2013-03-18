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
		public var layers:Array;
		public var objectGroups:Dictionary;
		public var blocks:Dictionary;

		private var tileInfoCache:Dictionary;

		public function MapData() {
			tileInfoCache = new Dictionary();
		}

		public function initialize():void {
			var blocks:Dictionary = new Dictionary();
			var width:int = column * tileWidth;
			var height:int = row * tileHeight;
			for each (var group:Object in objectGroups) {
				var type:String = group.properties["type"];
				if (type == "collision") {
					for each (var data:Object in group.data) {
						var startX:int = data.x / tileWidth;
						var startY:int = data.y / tileHeight;
						var endX:int = (data.x + data.width) / tileWidth;
						var endY:int = (data.y + data.height) / tileHeight;
						for (var i:int = startX; i <= endX; i++) {
							for (var j:int = startY; j <= endY; j++)
								blocks[i + "," + j] = true;
						}
					}
				}
			}
			this.blocks = blocks;
		}

		public function blocked(x:int, y:int):Boolean {
			return blocks[x + "," + y];
		}

		public function getTileById(tileId:int):Object {
			if (tileInfoCache[tileId])
				return tileInfoCache[tileId];

			var index:int = tileId;
			for each (var texture:Object in textures) {
				if (index <= texture.count) {
					index--;
					var tileInfo:Object = {texture: texture.source, region: new Rectangle(int(index % texture.width) * (tileWidth + texture.spacing) + texture.margin, int(index / texture.width) * (tileHeight + texture.spacing) + texture.margin, tileWidth, tileHeight)};
					tileInfoCache[tileId] = tileInfo;
					return tileInfo;
				} else {
					index -= texture.count;
				}
			}
			return null;
		}
	}
}
