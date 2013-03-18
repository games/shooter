package example {
	import flash.geom.Point;
	import flash.ui.Keyboard;

	import shooter.Camera;
	import shooter.Inputs;
	import shooter.Screen;
	import shooter.tilemaps.MapData;
	import shooter.tilemaps.MapRenderer;
	import shooter.tilemaps.Pathfinding;
	import shooter.tilemaps.TMXParser;
	import shooter.tilemaps.TileMap;

	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public class TileMapScreen extends Screen {

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

		public function TileMapScreen() {
			super();
			blockMessage = false;
		}

		override public function enter():void {
			assets.addTexture("desert_spacing.png", Texture.fromBitmap(new desertSpacing()));
			var mapdata:MapData = TMXParser.parse(XML(new mapConfig()));

			tileMap = new TileMap(camera, mapdata, new MapRenderer(), assets);
			addChild(tileMap);



			road = new Sprite();
			addChild(road);

			start = new Point(5, 5);
		}

		private var road:Sprite;
		private var start:Point;

		public function handleTouchBegan(e:TouchEvent):void {
			var touch:Touch = e.getTouch(stage);
			if (touch) {
				var pos:Point = tileMap.stagePosToTilePos(touch.globalX, touch.globalY);
				if (!tileMap.blocked(pos.x, pos.y)) {
					var path:Array = Pathfinding.find(tileMap.data, start, pos);
					road.removeChildren();
					var i:int = 0;
					for each (var node:Object in path) {
						var s:Sprite = new Sprite();
						var quad:Quad = new Quad(32, 32, 0xff0000);
						s.x = node.x * 32;
						s.y = node.y * 32;
						s.addChild(quad);
						var t:TextField = new TextField(32, 20, i.toString());
						s.addChild(t);
						i++;
						road.addChild(s);
					}
					start = pos;
				}
			}
		}

		public function update(time:Number):void {
			var speed:Number = 5;
			var cx:Number = 0;
			var cy:Number = 0;
			if (inputs.pressed(Keyboard.UP))
				cy = -speed;
			else if (inputs.pressed(Keyboard.DOWN))
				cy = speed;
			else if (inputs.pressed(Keyboard.LEFT))
				cx = -speed;
			else if (inputs.pressed(Keyboard.RIGHT))
				cx = speed;
			camera.move(cx, cy);
		}

	}
}
