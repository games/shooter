package threeshooter.dungeonadventure.net {
	import org.osflash.signals.natives.sets.XMLSocketSignalSet;


	public interface ISocket {
		function get signals():XMLSocketSignalSet;
		function connect(host:String, port:int):void;
		function send(object:*):void;
	}
}
