package example {
	import shooter.Camera;
	import shooter.Screen;
	import shooter.tilemaps.MapData;
	import shooter.tilemaps.MapRenderer;
	import shooter.tilemaps.TMXParser;
	import shooter.tilemaps.TileMap;

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

		public function TileMapScreen() {
			super();
			blockMessage = false;
		}

		override public function enter():void {

			assets.addTexture("desert_spacing.png", Texture.fromBitmap(new desertSpacing()));

			var mapdata:MapData = TMXParser.parse(XML(new mapConfig()));

			var tileMap:TileMap = new TileMap(mapdata, new MapRenderer(camera), assets);
			tileMap.build();
			tileMap.x = 100;
			tileMap.y = 100;
			addChild(tileMap);
		}

		public function update(time:Number):void {
		}

	}
}
