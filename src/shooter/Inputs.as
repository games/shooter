package shooter {
	import flash.utils.Dictionary;

	public class Inputs {
		private var keys:Dictionary;

		public function Inputs() {
			keys = new Dictionary();
		}

		public function press(key:uint):void {
			keys[key] = true;
		}

		public function release(key:uint):void {
			keys[key] = false;
		}

		public function pressed(key:uint):Boolean {
			return keys[key];
		}

	}
}
