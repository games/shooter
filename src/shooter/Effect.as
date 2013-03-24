package shooter {
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Effect extends MovieClip {
		public function Effect(textures:Vector.<Texture>, fps:Number = 12) {
			super(textures, fps);
		}

		override public function play():void {
			addEventListener(Event.COMPLETE, playCompleteHandler);
			Starling.current.juggler.add(this);
			super.play();
		}

		private function playCompleteHandler(e:Event):void {
			removeEventListener(Event.COMPLETE, playCompleteHandler);
			Starling.current.juggler.remove(this);
			this.removeFromParent(true);
		}
	}
}
