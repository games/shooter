package example {
	import flash.geom.Rectangle;

	import shooter.Camera;
	import shooter.Inputs;
	import shooter.Screen;
	import shooter.tilemaps.LayerDef;
	import shooter.tilemaps.MapData;
	import shooter.tilemaps.MazeGenerator;
	import shooter.tilemaps.TileDef;
	import shooter.tilemaps.TileMap;

	import starling.core.Starling;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public class MazeScreen extends Screen {

		[Inject]
		public var camera:Camera;

		[Inject]
		public var assets:AssetManager;

		[Inject]
		public var inputs:Inputs;

		[Embed(source = "../../assets/desert_spacing.png")]
		public static const desertSpacing:Class;

		private var tileMap:TileMap;

		public function MazeScreen() {
			super();
		}

		override public function enter():void {
			assets.addTexture("desert_spacing.png", Texture.fromBitmap(new desertSpacing()));
			buildMaze();
		}

		private function buildMaze():void {
			if (tileMap)
				removeChild(tileMap);

			var mapData:MapData = new MapData();
			mapData.layers = new Vector.<LayerDef>();
			var grid:Array = MazeGenerator.build(19, 19);
			var layerDef:LayerDef = new LayerDef("dungeon", 20, 12, grid);
			mapData.layers.push(layerDef);

			mapData.tileDefs[1] = new TileDef("desert_spacing.png", new Rectangle(34, 34, 32, 32));
			mapData.tileDefs[2] = new TileDef("desert_spacing.png", new Rectangle(166, 100, 32, 32));
			mapData.tileWidth = 32;
			mapData.tileHeight = 32;

			tileMap = new TileMap(camera, mapData, assets);
			addChild(tileMap);
		}

		override public function handleTouchBegan(e:TouchEvent):void {
			buildMaze();
		}


	}
}
