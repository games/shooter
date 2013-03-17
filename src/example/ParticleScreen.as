package example
{
	import shooter.Screen;
	
	import starling.core.Starling;
	import starling.extensions.ParticleSystem;
	import starling.textures.Texture;

	public class ParticleScreen extends Screen
	{
		public function ParticleScreen()
		{
			super();
		}
		
		override public function enter():void{
			var ps:ParticleSystem = new ParticleSystem(Texture.fromColor(16, 16, 0xff0000), 50);
			addChild(ps);
			
			ps.x = 100;
			ps.y = 100;
			Starling.juggler.add(ps);
		
			ps.emitterX = 20;
			ps.emitterY = 40;
			ps.start();
		
		}
	}
}