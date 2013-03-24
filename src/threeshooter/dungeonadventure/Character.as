package threeshooter.dungeonadventure {
	import flash.geom.Point;

	import shooter.Actor;
	import shooter.tilemaps.PathNode;

	import starling.core.Starling;

	import threeshooter.dungeonadventure.domain.User;

	public class Character extends Actor {

		private var user:User;

		public function Character(user:User, ... animations) {
			super(animations);
			this.user = user;
		}

		public function turnTo(direction:String):void {
			switch (direction) {
				case PathNode.EAST:
				case PathNode.NORTHEAST:
				case PathNode.SOUTHEAST:
					play("right");
					break;
				case PathNode.NORTH:
					play("up");
					break;
				case PathNode.SOUTH:
					play("down");
					break;
				case PathNode.SOUTHWEST:
				case PathNode.NORTHWEST:
				case PathNode.WEST:
					play("left");
					break;
			}
		}

		public function move(target:Point, direction:String, onComplete:Function):void {
			turnTo(direction);
			Starling.current.juggler.tween(this, 0.2, {x: target.x - 16, y: target.y - 16, onComplete: onComplete});
		}
	}
}
