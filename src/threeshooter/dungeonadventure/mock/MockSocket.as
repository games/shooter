package threeshooter.dungeonadventure.mock {
	import flash.events.DataEvent;
	import flash.net.XMLSocket;

	import org.osflash.signals.natives.sets.XMLSocketSignalSet;

	import shooter.Tracer;

	import threeshooter.dungeonadventure.net.ISocket;

	public class MockSocket implements ISocket {

		private var _signals:XMLSocketSignalSet;

		public function MockSocket() {
			_signals = new XMLSocketSignalSet(new XMLSocket());
		}

		public function get signals():XMLSocketSignalSet {
			return _signals;
		}

		public function connect(host:String, port:int):void {
			notify({kind: "auth"});
		}

		public function send(object:*):void {
			Tracer.debug("SEND    >> ", JSON.stringify(object));
			switch (object.kind) {
				case "auth":
					notify({kind: "authsucceed", content: {name: "valorzhong", strength: 10, defense: 10, tenacity: 5, hp: 100, agility: 8}});
					break;
				case "enterdungeon":
					notify({kind: "enterdungeonsucceed", content: {cols: 32, rows: 32, start: {x: 5, y: 5}, end: {x: 18, y: 20}}});
					break;
			}
		}

		private function notify(obj:Object):void {
			_signals.data.dispatch(new DataEvent(DataEvent.DATA, false, false, JSON.stringify(obj)));
		}
	}
}
