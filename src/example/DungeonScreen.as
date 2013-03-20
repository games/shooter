package example {
	import flash.geom.Rectangle;
	
	import shooter.Camera;
	import shooter.Inputs;
	import shooter.Screen;
	import shooter.tilemaps.LayerDef;
	import shooter.tilemaps.MapData;
	import shooter.tilemaps.TileDef;
	import shooter.tilemaps.TileMap;
	
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public class DungeonScreen extends Screen {

		[Inject]
		public var camera:Camera;

		[Inject]
		public var assets:AssetManager;

		[Inject]
		public var inputs:Inputs;

		[Embed(source = "../../assets/desert_spacing.png")]
		public static const desertSpacing:Class;
		
		private var tileMap:TileMap;

		public function DungeonScreen() {
			super();
		}

		override public function enter():void {
			
			assets.addTexture("desert_spacing.png", Texture.fromBitmap(new desertSpacing()));
			
			var mapData:MapData = new MapData();
			mapData.layers = new Vector.<LayerDef>();
			var grid:Array = [
				[1, 1, 2, 2, 2],
				[2, 1, 2, 2, 2],
				[2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2],
				[2, 2, 2, 1, 2]
			];
			var layerDef:LayerDef = new LayerDef("dungeon", 5, 5, grid);
			mapData.layers.push(layerDef);
			
			mapData.tileDefs[1] = new TileDef("desert_spacing.png", new Rectangle(34, 34, 32, 32));
			mapData.tileDefs[2] = new TileDef("desert_spacing.png", new Rectangle(166, 100, 32, 32));
			mapData.tileWidth = 32;
			mapData.tileHeight = 32;
			
			mapData.blocks["0,0"] = true;
			mapData.blocks["1,0"] = true;
			mapData.blocks["1,1"] = true;
			mapData.blocks["3,4"] = true;
			
			tileMap = new TileMap(camera, mapData, assets);
			addChild(tileMap);
		}
	}
}
