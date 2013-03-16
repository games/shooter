package example
{
	import shooter.Screen;
	import starling.display.Quad;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class ScreenTop extends Screen
	{
		private var quad:DisplayObject;
		public function ScreenTop()
		{
			super();
			blockMessage = false;
		}
		
		override public function enter():void{
			quad = addChild(new Quad(20, 20, 0x00ffff)) as Quad;
		}
		
		override public function touchMoved(e:TouchEvent):void{
			var touch:Touch = e.getTouch(stage);
			quad.x = touch.globalX + 20;
			quad.y = touch.globalY + 20;
		}
	}
}