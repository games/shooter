package shooter
{
	import org.swiftsuspenders.Injector;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Game extends Sprite
	{
		protected var injector:Injector;
		
		public function Game()
		{
			injector = new Injector();
			injector.map(Game).toValue(this);
			initialize();
			startup();
		}
		
		protected function initialize():void{
		}
		
		protected function enableKeyboardHandlers():void{
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		protected function disableKeyboardHandlers():void{
			Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			Starling.current.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		protected function enableTouchHandler():void{
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, touchHandler);
		}
		
		protected function disableTouchHandler():void{
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH, touchHandler);
		}
		
		private function keyDownHandler(e:KeyboardEvent):void {
			trace("keydown:", e);
			handleMessage("keyDown", e);
		}
		
		private function keyUpHandler(e:KeyboardEvent):void {
			trace("keyup:", e);
			handleMessage("keyUp", e);
		}
		
		private function touchHandler(e:TouchEvent):void {
			var touch:Touch = e.getTouch(stage);
			if(touch){
				var method:String = null;
				if(touch.phase == TouchPhase.BEGAN) 
					method = "touchBegan";
				else if(touch.phase == TouchPhase.HOVER)
					method = "touchHover";
				else if(touch.phase == TouchPhase.MOVED)
					method = "touchMoved";
				else if(touch.phase == TouchPhase.STATIONARY)
					method = "touchStationary";
				else if(touch.phase == TouchPhase.ENDED)
					method = "touchEnded";
				handleMessage(method, e);
			}
		}
		
		private function handleMessage(handler:String, ...params):void{
			for(var i:int = numChildren - 1; i >= 0; i--){
				var screen:Screen = getChildAt(i) as Screen;
				if(screen.hasOwnProperty(handler))
					screen[handler].apply(screen, params);
				if(screen.blockMessage)
					break;
			}
		}
		
		protected function startup():void{
		}
		
		public function replace(instanceOrClass:*):void{
			pop();
			push(instanceOrClass);
		}
		
		public function push(instanceOrClass:*):void{
			var instance:Screen = instanceOrClass is Class ? injector.getInstance(instanceOrClass) : instanceOrClass;
			addChild(instance);
			instance.enter();
		}
		
		public function pop():void{
			if(numChildren > 0)
				(removeChildAt(numChildren - 1) as Screen).exit();
		}
	}
}