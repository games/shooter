package threeshooter.dungeonadventure {
	import feathers.controls.Button;
	
	import shooter.Game;
	import shooter.Screen;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.utils.AssetManager;
	
	import threeshooter.dungeonadventure.domain.User;

	public class HomeScreen extends Screen {

		[Inject]
		public var assets:AssetManager;
		[Inject]
		public var game:Game;
		[Inject]
		public var user:User;

		public function HomeScreen() {
			super();
		}

		override public function enter():void {

			var floor:Image = new Image(assets.getTexture("Grassland"));
			floor.x = (Starling.current.viewPort.width - floor.width) >> 1;
			floor.y = (Starling.current.viewPort.height - floor.height) >> 1;
			addChild(floor);

			var bg:Image = new Image(assets.getTexture("Forest1"));
			bg.x = floor.x;
			bg.y = floor.y;
			addChild(bg);

			var avatar:Image = WorldGenerator.buildAvatar(user, assets);
			avatar.x = (Starling.current.viewPort.width - avatar.width) >> 1;
			avatar.y = (Starling.current.viewPort.height - avatar.height) >> 1;
			addChild(avatar);

			var enterGrasslands:Button = new Button();
			enterGrasslands.setSize(100, 30);
			enterGrasslands.label = "Enter Grasslands";
			enterGrasslands.x = floor.x;
			enterGrasslands.y = floor.y + floor.height + 10;
			enterGrasslands.addEventListener(Event.TRIGGERED, enterGrasslandsHandler);
			addChild(enterGrasslands);
		}

		private function enterGrasslandsHandler(e:Event):void {
			game.replace(LobbyScreen);
		}
	}
}
