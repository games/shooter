package threeshooter.dungeonadventure {
	import feathers.controls.ProgressBar;
	
	import org.swiftsuspenders.Injector;
	
	import shooter.Game;
	import shooter.Screen;
	import shooter.Tracer;
	
	import starling.core.Starling;
	import starling.utils.AssetManager;
	
	import threeshooter.dungeonadventure.domain.User;
	import threeshooter.dungeonadventure.net.ISocket;

	public class LoadingScreen extends Screen {

		[Inject]
		public var injector:Injector;
		[Inject]
		public var game:Game;
		[Inject]
		public var socket:ISocket;
		[Inject]
		public var assets:AssetManager;

		private var progressBar:ProgressBar;

		public function LoadingScreen() {
			super();
		}

		override public function enter():void {
			progressBar = new ProgressBar();
			addChild(progressBar);
			progressBar.width = 200;
			progressBar.x = (Starling.current.viewPort.width - progressBar.width) >> 1;
			progressBar.y = Starling.current.viewPort.height >> 1;

			assets.enqueue(
				"assets/charactors/Actor1.png",
				"assets/faces/Actor1Face.png",
				"assets/Inside_A4.png", "assets/Inside_A5.png", "assets/Inside_B.png",
				"assets/battlebacks/Cobblestones2.png", "assets/battlebacks/DirtCave.png",
				"assets/battlebacks/Grassland.png", "assets/battlebacks/Mine.png",
				"assets/monsters/Thief_m.png",
				"assets/monsters/Bat.png",
				"assets/monsters/Evilking.png",
				"assets/monsters/Hornet.png",
				"assets/monsters/Priest.png",
				"assets/animations/Attack1.png",
				"assets/animations/Attack2.png",
				"assets/animations/Attack3.png",
				"assets/sounds/Dungeon1.mp3",
				"assets/sounds/Attack1.mp3",
				"assets/sounds/Battle1.mp3",
				"assets/sounds/Miss.mp3");
			assets.loadQueue(progressHandler);
		}

		private function progressHandler(ratio:Number):void {
			progressBar.value = ratio;
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
