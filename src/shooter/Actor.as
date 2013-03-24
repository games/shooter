package shooter {
	import flash.utils.Dictionary;

	import starling.animation.IAnimatable;
	import starling.display.MovieClip;
	import starling.display.Sprite;

	public class Actor extends Sprite implements IAnimatable {

		private var animations:Dictionary;
		private var current:MovieClip;

		public function Actor(animations:Array) {
			this.animations = new Dictionary();
			for each (var animation:MovieClip in animations)
				this.animations[animation.name] = animation;
			current = animations[0];
			addChild(current);
		}

		public function play(name:String):void {
			if (name && name != current.name) {
				current.stop();
				removeChild(current);
				current = animations[name];
				addChild(current);
				current.play();
			}
		}

		public function advanceTime(time:Number):void {
			current.advanceTime(time);
		}

		public function stop():void {
			current.stop();
		}

		public function get isPlaying():Boolean {
			return current.isPlaying;
		}
	}
}
