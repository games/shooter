package shooter.tilemaps {
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class MapData {
		public var orientation:String;
		public var width:int;
		public var height:int;
		public var tileWidth:int;
		public var tileHeight:int;
		public var textures:Array;
		public var layers:Array;
		public var objectGroups:Dictionary;

		public function MapData() {

		}

		public function getTileById(tileId:int):Object {
			var index:int = tileId;
			for each (var texture:Object in textures) {
				if (index <= texture.count) {
					index--;
					return {texture: texture.source, 
						region: new Rectangle(int(index % texture.width) * (tileWidth + texture.spacing) + texture.margin, 
												int(index / texture.width) * (tileHeight + texture.spacing) + texture.margin, 
												tileWidth, tileHeight)};
				} else {
					index -= texture.count;
				}
			}
			return null;
		}
	}
}
