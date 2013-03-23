package threeshooter.dungeonadventure.mock {
	import flash.events.DataEvent;
	import flash.net.XMLSocket;

	import org.osflash.signals.natives.sets.XMLSocketSignalSet;

	import shooter.Tracer;
	import shooter.tilemaps.MapData;
	import shooter.tilemaps.TMXParser;

	import threeshooter.dungeonadventure.net.ISocket;

	public class MockSocket implements ISocket {
		private const COLUMN:int = 20;
		private const ROW:int = 20;
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
			this["handle" + object.kind](object);
		}

		private function notify(obj:Object):void {
			_signals.data.dispatch(new DataEvent(DataEvent.DATA, false, false, JSON.stringify(obj)));
		}

		public function handleauth(object:*):void {
			notify({kind: "authsucceed", content: {name: "valorzhong", strength: 10, defense: 10, tenacity: 5, hp: 100, agility: 8}});
		}

		public function handleentermap(data:*):void {
			notify({kind: "entermapsucceed", content: {col: COLUMN, row: ROW, tile: 32, start: {x: int(Math.random() * COLUMN), y: int(Math.random() * ROW)}, end: {x: int(Math.random() * COLUMN), y: int(Math.random() * ROW)}}});
		}

		public function handleopen(data:*):void {
			var types:Array = ["monster", "empty", "item"];
			var t:String = types[int(Math.random() * types.length)];
			notify({kind: "opensucceed", content: {type: t, x: data.x, y: data.y, data: {name: "simon", strength: 10, defense: 10, tenacity: 5, hp: 5, agility: 8}}});
		}
	}
}
