package threeshooter.dungeonadventure {
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.data.ListCollection;

	import shooter.Game;
	import shooter.Screen;
	import shooter.Tracer;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	import threeshooter.dungeonadventure.domain.User;
	import threeshooter.dungeonadventure.net.ISocket;

	public class LobbyScreen extends Screen {

		[Inject]
		public var user:User;
		[Inject]
		public var game:Game;
		[Inject]
		public var socket:ISocket;
		[Inject]
		public var assets:AssetManager;

		private var list:List;
		private var players:Sprite;
		private var joinButton:Button;

		public function LobbyScreen() {
			super();
		}

		override public function enter():void {
			list = new List();
			list.x = 10;
			list.y = 10;
			list.width = 420;
			list.height = 620;
			list.itemRendererProperties.labelField = "name";
			list.itemRendererProperties.iconSourceField = "avatar";
			list.addEventListener(Event.CHANGE, listChangedHandler);
			addChild(list);

			var homeButton:Button = new Button();
			homeButton.label = "Home";
			homeButton.x = 440;
			homeButton.y = 10;
			homeButton.setSize(90, 30);
			homeButton.addEventListener(Event.TRIGGERED, function():void {
				game.replace(HomeScreen);
			});
			addChild(homeButton);

			var createButton:Button = new Button();
			createButton.label = "招募冒险者";
			createButton.x = 540;
			createButton.y = 10;
			createButton.setSize(90, 30);
			createButton.addEventListener(Event.TRIGGERED, function():void {
				game.replace(DungeonScreen);
			});
			addChild(createButton);

			joinButton = new Button();
			joinButton.label = "加入";
			joinButton.x = 440;
			joinButton.setSize(90, 30);
			joinButton.visible = false;
			addChild(joinButton);

			players = new Sprite();
			players.x = 440;
			players.y = 60;
			addChild(players);

			socket.send({kind: "enterlobby", scene: 1});
		}

		private function listChangedHandler(e:Event):void {
			var team:Object = list.selectedItem;
			socket.send({kind: "teaminfo", id: team.id, password: "123abc"});
		}

		public function handleTeams(content:Object):void {
			var data:Array = [];
			for each (var team:Object in content) {
				data.push({name: team.name, avatar: WorldGenerator.getFaceTexture(team.avatar, assets)});
			}

			list.dataProvider = new ListCollection(content);
		}

		public function handleTeaminfo(content:Object):void {
			players.removeChildren();
			for (var i:int = 0; i < content.length; i++) {
				var player:Object = content[i];
				var img:Image = new Image(WorldGenerator.getFaceTexture(player.avatar, assets));
				img.x = int(i % 2) * 100;
				img.y = int(i / 2) * 130;
				players.addChild(img);

				var label:TextField = new TextField(95, 20, player.name);
				label.x = img.x;
				label.y = img.y + img.height;
				label.color = 0xffffff;
				players.addChild(label);
			}
			joinButton.visible = true;
			joinButton.y = players.y + players.height + 10;
		}
	}
}
