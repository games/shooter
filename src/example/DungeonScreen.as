package example {
	import flash.geom.Rectangle;
	
	import shooter.Camera;
	import shooter.Inputs;
	import shooter.Screen;
	import shooter.tilemaps.LayerDef;
	import shooter.tilemaps.MapData;
	import shooter.tilemaps.TileDef;
	import shooter.tilemaps.TileMap;
	
	import starling.core.Starling;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.extensions.PDParticleSystem;
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
		[Embed(source = "../../assets/particle.pex", mimeType = "application/octet-stream")]
		private static const BlowUpConfig:Class;
		[Embed(source = "../../assets/particle.png")]
		private static const BlowUpParticle:Class;
		
		private var tileMap:TileMap;
		private var ps:PDParticleSystem;

		public function DungeonScreen() {
			super();
		}

		override public function enter():void {
			
			assets.addTexture("desert_spacing.png", Texture.fromBitmap(new desertSpacing()));
			
			var mapData:MapData = new MapData();
			mapData.layers = new Vector.<LayerDef>();
			var grid:Array = [
				[1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2],
				[2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2],
				[2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2],
				[2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2],
				[2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2],
				[2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2],
				[2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2],
				[2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2],
				[2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2],
				[2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2]
			];
			var layerDef:LayerDef = new LayerDef("dungeon", 20, 12, grid);
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
			
			//particle system
			var config:XML = XML(new BlowUpConfig());
			var texture:Texture = Texture.fromBitmap(new BlowUpParticle());
			ps = new PDParticleSystem(config, texture);
			addChild(ps);
			Starling.juggler.add(ps);
		}
		
		override public function handleTouchBegan(e:TouchEvent):void{
			var touch:Touch = e.getTouch(stage);
			if(touch){
				ps.x = touch.globalX;
				ps.y = touch.globalY;
				ps.start(0.1);
			}
		}
		
		
	}
}
