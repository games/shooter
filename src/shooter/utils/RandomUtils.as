package shooter.utils {

	public class RandomUtils {
		public static function take(arr:Array, count:int = 1):* {
			if (count == 1)
				return getRandomItem(arr);
			var r:Array = [];
			for (var i:int = 0; i < count; i++)
				r.push(getRandomItem(arr))
			return r;
		}

		private static function getRandomItem(arr:Array):* {
			return arr[int(Math.random() * arr.length)];
		}

		public static function getInt(max:int, min:int = 0):int {
			return min + int(Math.random() * (max - min));
		}
	}
}
