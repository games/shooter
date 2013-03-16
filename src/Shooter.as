package
{
	import example.MyGame;
	
	import flash.display.Sprite;
	
	import starling.core.Starling;
	
	public class Shooter extends Sprite
	{
		public function Shooter()
		{
			var star:Starling = new Starling(MyGame, stage);
			star.start();
		}
	}
}