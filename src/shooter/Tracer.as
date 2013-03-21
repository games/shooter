package shooter {

	public class Tracer {
		public static var DEBUG:Boolean = true;

		public static function debug(... params):void {
			if (DEBUG)
				trace.apply(null, [now() + "] "].concat(params));
		}

		public static function now():String {
			var n:Date = new Date();
			return n.getHours() + ":" + n.getMinutes() + ":" + n.getSeconds() + ":" + n.getMilliseconds();
		}
	}
}
