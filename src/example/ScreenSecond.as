package example
{
	import shooter.Screen;
	import starling.display.Quad;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class ScreenSecond extends Screen
	{
		private var quad:DisplayObject;
		public function ScreenSecond()
		{
			super();
			blockMessage = true;
		}
		
		override public function enter():void{
			quad = addChild(new Quad(20, 20, 0x0000ff)) as Quad;
		}
		
		override public function handleTouchMoved(e:TouchEvent):void{
			var touch:Touch = e.getTouch(stage);
			quad.x = touch.globalX + 10;
			quad.y = touch.globalY + 10;
		}
	}
}