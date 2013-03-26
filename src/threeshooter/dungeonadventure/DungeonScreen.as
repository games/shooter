package threeshooter.dungeonadventure {
	import flash.geom.Point;
	import flash.media.SoundChannel;

	import org.swiftsuspenders.Injector;

	import shooter.Camera;
	import shooter.Game;
	import shooter.Screen;
	import shooter.Tracer;
	import shooter.tilemaps.MapData;
	import shooter.tilemaps.PathNode;
	import shooter.tilemaps.Pathfinding;
	import shooter.tilemaps.TileMap;

	import starling.core.Starling;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.extensions.PDParticleSystem;
	import starling.extensions.SpotlightFilter;
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
		[Inject]
		public var game:Game;
		[Inject]
		public var injector:Injector;

		[Embed(source = "../../../assets/particle.pex", mimeType = "application/octet-stream")]
		private static const BlowUpConfig:Class;
		[Embed(source = "../../../assets/particle.png")]
		private static const BlowUpParticle:Class;

		private var tileMap:TileMap;
		private var ps:PDParticleSystem;
		private var player:Character;
		private var hud:HUD;
		private var backgroundMusic:SoundChannel;

		public function DungeonScreen() {
			super();
		}

		override public function enter():void {
			socket.send({kind: "entermap", players: 3, theme: 1, level: 5});
		}

		override public function focus():void {
			backgroundMusic = assets.playSound("Dungeon1");
		}

		override public function unfocus():void {
			backgroundMusic.stop();
			backgroundMusic = null;
		}

		public function handleEntermapsucceed(content:Object):void {
			var mapData:MapData = WorldGenerator.buildMap(
				content.col, content.row, content.tile, content.tile,
				content.start.x, content.start.y,
				content.end.x, content.end.y);
			tileMap = new TileMap(camera, mapData, assets);
			addChild(tileMap);

			//particle system
			var config:XML = XML(new BlowUpConfig());
			var texture:Texture = Texture.fromBitmap(new BlowUpParticle());
			ps = new PDParticleSystem(config, texture);
			addChild(ps);
			Starling.juggler.add(ps);

			player = WorldGenerator.buildCharacter(user, assets);
			player.stop();
			var pos:Point = tileMap.tilePosToStagePos(content.start.x, content.start.y);
			player.x = pos.x - 16;
			player.y = pos.y - 16;
			tileMap.addItem(player);
			Starling.juggler.add(player);

			hud = new HUD(user, assets);
			addChild(hud);

		}

		override public function handleTouchBegan(e:TouchEvent):void {
			var touch:Touch = e.getTouch(stage);
			if (touch) {
				var pos:Point = tileMap.stagePosToTilePos(touch.globalX, touch.globalY);
				var start:Point = tileMap.stagePosToTilePos(player.x, player.y);
				var path:Array = Pathfinding.find(tileMap.data, start, pos);
				if (!tileMap.blocked(pos.x, pos.y)) {
					moveActor(path);
				} else {
					tileMap.data.blocks[pos.x + "," + pos.y] = false;
					if (path.length > 0) {
						socket.send({kind: "open", x: pos.x, y: pos.y});
					} else {
						Tracer.debug("You can't go to there.");
						tileMap.data.blocks[pos.x + "," + pos.y] = true;
					}
				}
			}
		}

		public function handleOpensucceed(content:Object):void {
			var pos:Point = tileMap.tilePosToStagePos(content.x, content.y);
			ps.x = pos.x;
			ps.y = pos.y;
			ps.start(0.1);
			tileMap.data.blocks[content.x + "," + content.y] = false;
			tileMap.replace(content.x, content.y, 2);

			var start:Point = tileMap.stagePosToTilePos(player.x, player.y);
			var path:Array = Pathfinding.find(tileMap.data, start, new Point(content.x, content.y));
			moveActor(path);
		}

		public function handleEnterbattle(content:Object):void {
			var battle:BattleScreen = new BattleScreen();
			injector.injectInto(battle);
			battle.monsterDef = content;
			battle.user = user;
			battle.hud = hud;
			game.push(battle);
		}

		private function moveActor(path:Array):void {
			Starling.current.juggler.removeTweens(player);
			var target:PathNode = path.shift();
			if (target == null) {
				player.stop();
				return;
			}
			var p:Point = tileMap.tilePosToStagePos(target.x, target.y);
			player.move(p, target.direction, function():void {
				moveActor(path);
			});
		}
	}
}
