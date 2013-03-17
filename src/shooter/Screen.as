package shooter
{
	import starling.display.Sprite;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class Screen extends Sprite implements IState {
		
		public var blockMessage:Boolean = true;
	
		public function Screen() {
			super();
		}
		
		public function enter():void{
			
		}
		
		public function exit():void{
			
		}
		
		/*****
		 *  Keyboard Handlers
		 *      handleKeyDown(e:KeyboardEvent):void;
		 * 		handleKeyUp(e:KeyboardEvent):void;
		 *  Touch Handlers
		 * 		handleTouchMoved(e:TouchEvent):void;
		 * 		handleTouchBegan(e:TouchEvent):void;
		 * 		handleTouchHover(e:TouchEvent):void;
		 * 		handleTouchEnded(e:TouchEvent):void;
		 * 		handleTouchStationary(e:TouchEvent):void;
		 *   Update Handler
		 * 		update(time:Number):void;
		 */
		
	}
}