package shooter.utils {
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.MovieClip;

	public class TweenUtils {
		public static function shake(target:Object):void {
			Starling.current.juggler.removeTweens(target);
			var x:Number = target.x, y:Number = target.y;
			var repeat:int = 2;
			Starling.current.juggler.tween(target, 0.05, {x: x + RandomUtils.getInt(5), y: y + RandomUtils.getInt(5),
					transition: Transitions.EASE_IN_BOUNCE,
					repeatCount: repeat,
					onComplete: function():void {
						Starling.current.juggler.tween(target, 0.05, {x: x, y: y, repeatCount: repeat,
								transition: Transitions.EASE_IN_BOUNCE});
					}});
		}

		public static function flash(target:Object, onComplete:Function = null):void {
			Starling.current.juggler.removeTweens(target);
			var complete:Function = onComplete || function():void {
				Starling.current.juggler.tween(target, 0.3, {alpha: 1, repeatCount: 1});
			};
			Starling.current.juggler.tween(target, 0.3, {alpha: 0,
					repeatCount: 2,
					onComplete: complete});
		}

		public static function hint(target:Object):void {
			Starling.current.juggler.tween(target, 0.2, {scaleX: 1.3, scaleY: 1.3,
					repeatCount: 3,
					onComplete: function():void {
						Starling.current.juggler.tween(target, 0.3, {scaleX: 1, scaleY: 1});
					}});
		}

		public static function miss(target:Object):void {
			Starling.current.juggler.tween(target, 0.2, {x: target.x - 100,
					onComplete: function():void {
						Starling.current.juggler.tween(target, 0.2, {x: target.x + 100, delay: 0.5});
					}});
		}

	}
}
