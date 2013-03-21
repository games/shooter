package threeshooter.dungeonadventure {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import shooter.Camera;
	import shooter.Screen;
	import shooter.tilemaps.LayerDef;
	import shooter.tilemaps.MapData;
	import shooter.tilemaps.TileDef;
	import shooter.tilemaps.TileMap;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	import threeshooter.dungeonadventure.domain.User;
	import threeshooter.dungeonadventure.net.ISocket;

	public class DungeonScreen extends Screen {

		[Inject]
		public var user:User;
		[Inject]
		public var socket:ISocket;
		[Inject]
		public var assets:AssetManager;
		[Inject]
		public var camera:Camera;
		[Embed(source = "../../../assets/Actor1.png")]
		public static const actorClass:Class;
		[Embed(source = "../../../assets/desert_spacing.png")]
		public static const desertSpacing:Class;
		[Embed(source = "../../../assets/particle.pex", mimeType = "application/octet-stream")]
		private static const BlowUpConfig:Class;
		[Embed(source = "../../../assets/particle.png")]
		private static const BlowUpParticle:Class;

		private var tileMap:TileMap;
		private var ps:PDParticleSystem;
		private var actor:MovieClip;

		public function DungeonScreen() {
			super();
		}

		override public function enter():void {
			socket.send({kind: "enterdungeon"});
		}

		public function handleEnterdungeonsucceed(content:Object):void {
			assets.addTexture("Actor1", Texture.fromBitmap(new actorClass()));
			assets.addTexture("desert_spacing", Texture.fromBitmap(new desertSpacing()));

			var mapData:MapData = new MapData();
			mapData.layers = new Vector.<LayerDef>();

			var grid:Array = [];
			for (var row:int = 0; row < content.row; row++) {
				var rows:Array = [];
				for (var col:int = 0; col < content.col; col++) {
					if ((content.start.x == row && content.start.y == col) || (content.end.x == row && content.end.y == col))
						rows.push(2);
					else {
						rows.push(1);
						mapData.blocks[col + "," + row] = true;
					}
				}
				grid[row] = rows;
			}

			mapData.layers.push(new LayerDef("dungeon", content.col, content.row, grid));

			mapData.tileDefs[1] = new TileDef("desert_spacing", new Rectangle(34, 34, 32, 32));
			mapData.tileDefs[2] = new TileDef("desert_spacing", new Rectangle(166, 100, 32, 32));
			mapData.tileWidth = 32;
			mapData.tileHeight = 32;

			tileMap = new TileMap(camera, mapData, assets);
			addChild(tileMap);

			//particle system
			var config:XML = XML(new BlowUpConfig());
			var texture:Texture = Texture.fromBitmap(new BlowUpParticle());
			ps = new PDParticleSystem(config, texture);
			addChild(ps);
			Starling.juggler.add(ps);
			
			var actorTextures:Vector.<Texture> = new Vector.<Texture>();
			for(var i:int = 0; i < 3; i++){
				var frame1:Texture = Texture.fromTexture(assets.getTexture("Actor1"), new Rectangle(i * 32, 0, 32, 32));
				actorTextures.push(frame1);
			}
			
			actor = new MovieClip(actorTextures, 8);
			var pos:Point = tileMap.tilePosToStagePos(content.start.x, content.start.y);
			actor.x = pos.x - 16;
			actor.y = pos.y - 16;
			tileMap.addItem(actor);
			Starling.juggler.add(actor);
		}

		override public function handleTouchBegan(e:TouchEvent):void {
			var touch:Touch = e.getTouch(stage);
			if (touch) {
				var pos:Point = tileMap.stagePosToTilePos(touch.globalX, touch.globalY);
				socket.send({kind: "open", x: pos.x, y: pos.y});
			}
		}

		public function handleOpensucceed(content:Object):void {
			var pos:Point = tileMap.tilePosToStagePos(content.x, content.y);
			ps.x = pos.x;
			ps.y = pos.y;
			ps.start(0.1);
			tileMap.data.blocks[content.x + "," + content.y] = false;
			tileMap.replace(content.x, content.y, 2);
		}
	}
}
