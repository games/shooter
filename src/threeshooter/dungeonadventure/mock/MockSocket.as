package threeshooter.dungeonadventure.mock {
	import flash.events.DataEvent;
	import flash.events.TimerEvent;
	import flash.net.XMLSocket;
	import flash.utils.Timer;

	import org.osflash.signals.natives.sets.XMLSocketSignalSet;

	import shooter.Tracer;
	import shooter.tilemaps.MapData;
	import shooter.tilemaps.TMXParser;
	import shooter.utils.RandomUtils;

	import threeshooter.dungeonadventure.domain.User;
	import threeshooter.dungeonadventure.net.ISocket;

	public class MockSocket implements ISocket {
		private const COLUMN:int = 20;
		private const ROW:int = 20;
		private var _signals:XMLSocketSignalSet;
		private var player:User;

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
			player = new User();
			player.name = "valorzhong";
			player.level = 5;
			player.exp = 100;
			player.avatar = 1;
			player.strength = 1000;
			player.defense = 1500;
			player.tenacity = 5;
			player.hp = 10000;
			player.agility = 9;
			notify({kind: "authsucceed", content: player});
		}

		public function handleentermap(data:*):void {
			notify({kind: "entermapsucceed", content: {col: COLUMN, row: ROW, tile: 32, start: {x: int(Math.random() * COLUMN),
							y: int(Math.random() * ROW)}, end: {x: int(Math.random() * COLUMN), y: int(Math.random() * ROW)}}});
		}

		public function handleopen(data:*):void {
			var types:Array = ["monster", "empty", "item"];
			var t:String = types[int(Math.random() * types.length)];
//			t = "empty";
			notify({kind: "opensucceed", content: {type: t, x: data.x, y: data.y}});
			if (t == "monster") {
				var monster:Object = {name: "simon",
						kind: RandomUtils.take(["Thief_m", "Bat", "Evilking", "Hornet", "Priest"]),
						strength: 2000, defense: 400, tenacity: 5, hp: 3000, agility: 8};
				notify({kind: "enterbattle", content: monster});
				startBattle(monster);
			} else if (t == "item") {
				var item:Object = {name: "gold", value: 100};
				notify({kind: "getitem", content: item});
			}
		}

		private var battleTimer:Timer;

		private function startBattle(monster:Object):void {
			var attacker:Object, defenser:Object;
			if (player.agility > monster.agility) {
				attacker = player;
				defenser = monster;
			} else {
				attacker = monster;
				defenser = player;
			}
			if (battleTimer) {
				battleTimer.stop();
				battleTimer = null;
			}
			battleTimer = new Timer(1500);
			battleTimer.addEventListener(TimerEvent.TIMER, function():void {
				var miss:int = RandomUtils.getInt(10);
				var damage:int = Math.max(1, RandomUtils.getInt((attacker.strength - defenser.defense) * 2,
					(attacker.strength - defenser.defense) / 2));
				if (miss < 3) {
					damage = 0;
				}
				defenser.hp -= damage;
				var skill:String = "Attack" + RandomUtils.getInt(4, 1);
				if (attacker === player)
					notify({kind: "attack", content: {skill: skill, damage: damage}});
				else
					notify({kind: "defense", content: {skill: skill, damage: damage}});
				if (defenser.hp <= 0) {
					battleTimer.stop();
					battleTimer = null;
					if (attacker === player)
						notify({kind: "win", content: {gold: 100, exp: 100}});
					else
						notify({kind: "lose"});
				} else {
					var tmp:Object = attacker;
					attacker = defenser;
					defenser = tmp;
				}
			});
			battleTimer.start();
		}
	}
}
