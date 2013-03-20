package example {
	import flash.geom.Point;
	
	import shooter.Camera;
	import shooter.Inputs;
	import shooter.Screen;
	import shooter.tilemaps.MapData;
	import shooter.tilemaps.MapRenderer;
	import shooter.tilemaps.Pathfinding;
	import shooter.tilemaps.TMXParser;
	import shooter.tilemaps.TileMap;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public class PathfindingScreen extends Screen {

		[Embed(source = "../../assets/desert_spacing.png")]
		public static const desertSpacing:Class;

		[Embed(source = "../../assets/desert.tmx", mimeType = "application/octet-stream")]
		private static var mapConfig:Class;

		[Inject]
		public var camera:Camera;

		[Inject]
		public var assets:AssetManager;

		[Inject]
		public var inputs:Inputs;

		private var tileMap:TileMap;

		public function PathfindingScreen() {
			super();
		}
		
		private var road:Sprite;
		private var start:Point;

		override public function enter():void {
			assets.addTexture("desert_spacing.png", Texture.fromBitmap(new desertSpacing()));
			var mapdata:MapData = TMXParser.parse(XML(new mapConfig()));

			tileMap = new TileMap(camera, mapdata, assets);
			addChild(tileMap);

			road = new Sprite();
			addChild(road);
			road.addChild(makeNode(5, 5, 0));

			start = new Point(5, 5);
		}

		override public function handleTouchBegan(e:TouchEvent):void {
			var touch:Touch = e.getTouch(stage);
			if (touch) {
				var pos:Point = tileMap.stagePosToTilePos(touch.globalX, touch.globalY);
				if (!tileMap.blocked(pos.x, pos.y)) {
					var path:Array = Pathfinding.find(tileMap.data, start, pos);
					road.removeChildren();
					path.forEach(function(node:Object, i:int, arr:Array):void{
						road.addChild(makeNode(node.x, node.y, i));
					});
					start = pos;
				}
			}
		}
		
		private function makeNode(x:int, y:int, i:int):Sprite{
			var s:Sprite = new Sprite();
			var quad:Quad = new Quad(32, 32, 0xff0000);
			s.x = x * 32;
			s.y = y * 32;
			s.addChild(quad);
			var t:TextField = new TextField(32, 20, i.toString());
			s.addChild(t);
			return s;
		}
	}
}
