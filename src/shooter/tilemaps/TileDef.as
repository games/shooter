package shooter.tilemaps {
	import flash.geom.Rectangle;

	public class TileDef {
		public var texture:String;
		public var region:Rectangle;

		public function TileDef(t:String, r:Rectangle) {
			texture = t;
			region = r;
		}
	}
}
