package threeshooter.dungeonadventure {
	import org.swiftsuspenders.Injector;

	import shooter.Game;
	import shooter.Screen;
	import shooter.Tracer;

	import starling.core.Starling;

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

		public function LoadingScreen() {
			super();
		}

		override public function enter():void {
			socket.connect("192.168.0.100", 1234);
		}

		public function handleAuth():void {
			var token:String = Starling.current.nativeStage.loaderInfo.parameters.token || "token1";
			socket.send({kind: "auth", token: token});
		}

		public function handleAuthsucceed(content:Object):void {
			injector.map(User).toValue(User.parse(content));
			game.replace(LobbyScreen);
		}

		public function handleAuthfail():void {
			Tracer.debug("Auth fail");
		}
	}
}
