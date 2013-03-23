package threeshooter.dungeonadventure {
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import shooter.Camera;
	import shooter.Screen;
	import shooter.Tracer;
	import shooter.tilemaps.LayerDef;
	import shooter.tilemaps.MapData;
	import shooter.tilemaps.PathNode;
	import shooter.tilemaps.Pathfinding;
	import shooter.tilemaps.TileDef;
	import shooter.tilemaps.TileMap;

	import starling.animation.Tween;
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

		[Embed(source = "../../../assets/particle.pex", mimeType = "application/octet-stream")]
		private static const BlowUpConfig:Class;
		[Embed(source = "../../../assets/particle.png")]
		private static const BlowUpParticle:Class;

		private var tileMap:TileMap;
		private var ps:PDParticleSystem;
		private var actor:Actor;

		public function DungeonScreen() {
			super();
		}

		override public function enter():void {
			socket.send({kind: "entermap", map: 10});
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

			actor = WorldGenerator.buildActor(assets);
			actor.stop();
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
				var start:Point = tileMap.stagePosToTilePos(actor.x, actor.y);
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

			var start:Point = tileMap.stagePosToTilePos(actor.x, actor.y);
			var path:Array = Pathfinding.find(tileMap.data, start, new Point(content.x, content.y));
			moveActor(path);
		}

		private function moveActor(path:Array):void {
			Starling.current.juggler.removeTweens(actor);
			var target:PathNode = path.shift();
			if (target == null) {
				actor.stop();
				return;
			}
			switch (target.direction) {
				case PathNode.EAST:
				case PathNode.NORTHEAST:
				case PathNode.SOUTHEAST:
					actor.play("right");
					break;
				case PathNode.NORTH:
					actor.play("up");
					break;
				case PathNode.SOUTH:
					actor.play("down");
					break;
				case PathNode.SOUTHWEST:
				case PathNode.NORTHWEST:
				case PathNode.WEST:
					actor.play("left");
					break;
			}
			var p:Point = tileMap.tilePosToStagePos(target.x, target.y);
			Starling.current.juggler.tween(actor, 0.2, {x: p.x - 16, y: p.y - 16, onComplete: function():void {
				moveActor(path);
			}});
		}
	}
}
