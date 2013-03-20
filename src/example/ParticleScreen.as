package example {
	import shooter.Screen;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.extensions.PDParticleSystem;
	import starling.extensions.ParticleSystem;
	import starling.textures.Texture;

	public class ParticleScreen extends Screen {

		[Embed(source = "../../assets/particle.pex", mimeType = "application/octet-stream")]
		private static const BlowUpConfig:Class;

		[Embed(source = "../../assets/particle.png")]
		private static const BlowUpParticle:Class;

		public function ParticleScreen() {
			super();
		}
		
		private var ps:PDParticleSystem;

		override public function enter():void {
			var config:XML = XML(new BlowUpConfig());
			var texture:Texture = Texture.fromBitmap(new BlowUpParticle());
			
			ps = new PDParticleSystem(config, texture);
			addChild(ps);

			ps.x = 320;
			ps.y = 240;
			ps.emitterX = 0;
			ps.emitterY = 0;
			
			ps.startSize = 0;
			
			Starling.juggler.add(ps);
			
			ps.addEventListener(Event.COMPLETE, function():void{
//				ps.x = Starling.current.viewPort.width * Math.random();
//				ps.y = Starling.current.viewPort.height * Math.random();
				ps.start(0.1);
			});
			
			ps.start(0.1);
		}
		
		override public function update(elapse:Number):void{
			
		}
		
		override public function handleTouchBegan(e:TouchEvent):void {
			var touch:Touch = e.getTouch(stage);
			if (touch) {
				ps.x = touch.globalX;
				ps.y = touch.globalY;
				ps.start(0.1);
			}
		}
	}
}
