package example
{
	import flash.events.MouseEvent;
	
	import shooter.Game;
	import shooter.Screen;
	
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class ScreenThree extends Screen
	{
		[Inject]
		public var game:Game;
		
		private var quad:Quad;
		
		public function ScreenThree() {
			super();
		}
		
		override public function enter():void{
			quad = addChild(new Quad(20, 20, 0xff0000)) as Quad;
		}
		
		override public function touchMoved(e:TouchEvent):void{
			var touch:Touch = e.getTouch(stage);
			quad.x = touch.globalX;
			quad.y = touch.globalY;
		}
	}
}