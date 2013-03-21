package threeshooter.dungeonadventure.net {
	import flash.net.XMLSocket;
	
	import org.osflash.signals.natives.sets.XMLSocketSignalSet;
	
	import shooter.Tracer;

	public class JsonSocket extends XMLSocket implements ISocket {

		private var _signals:XMLSocketSignalSet;

		public function get signals():XMLSocketSignalSet {
			return _signals;
		}

		public function JsonSocket(host:String = null, port:int = 0) {
			super(host, port);
			_signals = new XMLSocketSignalSet(this);
		}

		override public function send(object:*):void {
			var data:String = JSON.stringify(object);
			Tracer.debug("SEND    > ", data);
			super.send(data);
		}

		public function dispose():void {
			if (connected)
				close();
			_signals.removeAll();
		}
	}
}
