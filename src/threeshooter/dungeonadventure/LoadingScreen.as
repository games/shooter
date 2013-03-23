package threeshooter.dungeonadventure {
	import org.swiftsuspenders.Injector;

	import shooter.Game;
	import shooter.Screen;
	import shooter.Tracer;

	import starling.core.Starling;
	import starling.utils.AssetManager;

	import threeshooter.dungeonadventure.domain.User;
	import threeshooter.dungeonadventure.net.ISocket;
	import threeshooter.dungeonadventure.net.JsonSocket;

	public class LoadingScreen extends Screen {

		[Inject]
		public var injector:Injector;
		[Inject]
		public var game:Game;
		[Inject]
		public var socket:ISocket;
		[Inject]
		public var assets:AssetManager;

		public function LoadingScreen() {
			super();
		}

		override public function enter():void {
			assets.enqueue("assets/Actor1.png", "assets/Inside_A4.png", "assets/Inside_A5.png", "assets/Inside_B.png", "particle.pex", "particle.png");
			assets.loadQueue(progressHandler);
		}

		private function progressHandler(ratio:Number):void {
			if (ratio == 1)
				startup();
		}

		private function startup():void {
			socket.signals.connect.addOnce(function():void {
				handleAuth();
			});
			socket.connect(Config.HOST, Config.PORT);
		}

		public function handleAuth():void {
			var token:String = Starling.current.nativeStage.loaderInfo.parameters.token || "token1";
			socket.send({kind: "auth", token: token});
		}

		public function handleAuthsucceed(content:Object):void {
			injector.map(User).toValue(User.parse(content));
			game.replace(DungeonScreen);
		}

		public function handleAuthfail():void {
			Tracer.debug("Auth fail");
		}
	}
}
