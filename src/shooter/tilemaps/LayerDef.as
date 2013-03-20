package shooter.tilemaps {

	public class LayerDef {

		public var name:String;
		public var width:int;
		public var height:int;
		public var grid:Array;

		public function LayerDef(n:String, w:int, h:int, g:Array) {
			name = n;
			width = w;
			height = h;
			grid = g;
		}
	}
}
