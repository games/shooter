package
{
	import example.MyGame;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import starling.core.Starling;
	
	[SWF(width="640", height="480", frameRate="60", backgroundColor="#ffffff")]
	public class Shooter extends Sprite
	{
		public function Shooter()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			var star:Starling = new Starling(MyGame, stage);
			star.showStats = true;
			star.start();
		}
	}
}