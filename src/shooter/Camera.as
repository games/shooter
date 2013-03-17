package shooter {
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.Starling;
	import starling.display.Stage;

	public class Camera {
		public var zoom:Number;
		public var position:Point;
		public var rotation:Number;
		public var size:Point;

		private var _bounds:Rectangle;

		public function Camera() {
			var stage:Stage = Starling.current.stage;
			zoom = 1.0;
			position = new Point(stage.width * 0.5, stage.height * 0.5);
			size = new Point(stage.width, stage.height);
			rotation = 1.0;
			adjust();
		}

		public function get bounds():Rectangle {
			return _bounds;
		}

		public function adjust():void {
			_bounds = new Rectangle(size.x * 0.5 - position.x, size.y * 0.5 - position.y);
		}
	}
}
