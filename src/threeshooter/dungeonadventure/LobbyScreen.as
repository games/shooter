package threeshooter.dungeonadventure {
	import shooter.Screen;
	import shooter.Tracer;

	import threeshooter.dungeonadventure.domain.User;

	public class LobbyScreen extends Screen {

		[Inject]
		public var user:User;

		public function LobbyScreen() {
			super();
		}

		override public function enter():void {

		}
	}
}
