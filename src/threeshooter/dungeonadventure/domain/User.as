package threeshooter.dungeonadventure.domain {

	public class User {
		public var name:String;
		public var hp:int;
		public var strength:int;
		public var defense:int;
		public var tenacity:int;
		public var agility:int;

		public static function parse(json:Object):User {
			var user:User = new User();
			for (var pro:String in json) {
				user[pro] = json[pro];
			}
			return user;
		}
	}
}
