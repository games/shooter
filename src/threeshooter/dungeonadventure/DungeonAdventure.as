package threeshooter.dungeonadventure {
	import feathers.themes.AeonDesktopTheme;

	import flash.events.DataEvent;
	import flash.events.IOErrorEvent;
	import flash.system.Security;

	import shooter.Game;
	import shooter.Tracer;

	import threeshooter.dungeonadventure.mock.MockSocket;
	import threeshooter.dungeonadventure.net.ISocket;
	import threeshooter.dungeonadventure.net.JsonSocket;

	public class DungeonAdventure extends Game {

		private const MOCK:Boolean = true;

		override protected function initialize():void {
			injector.map(LoadingScreen);
			injector.map(LobbyScreen);
			injector.map(DungeonScreen);
			injector.map(ISocket).toValue(newSocket());

			enableTouchHandler();

			new AeonDesktopTheme(stage);
		}

		override protected function startup():void {
			Tracer.debug("startup..");
			Security.loadPolicyFile("xmlsocket://" + Config.HOST + ":" + Config.POLICY_PORT);
			replace(LoadingScreen);
		}

		private function newSocket():ISocket {
			var socket:ISocket = MOCK ? new MockSocket() : new JsonSocket();
			socket.signals.ioError.add(socketIoErrorHandler);
			socket.signals.data.add(socketDataHandler);
			return socket;
		}

		private function socketIoErrorHandler(e:IOErrorEvent):void {
			Tracer.debug("SOCKET IO ERROR");
		}

		private function socketDataHandler(e:DataEvent):void {
			Tracer.debug("MESSAGE >> ", e.data);
			var msg:Object = JSON.parse(e.data);
			var handler:String = "handle" + msg.kind.substr(0, 1).toUpperCase() + msg.kind.substr(1);
			msg.content ? broadcastMessage(handler, msg.content) : broadcastMessage(handler);
		}
	}
}
