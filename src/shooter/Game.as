package shooter {
	import org.swiftsuspenders.Injector;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.errors.AbstractMethodError;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.utils.AssetManager;

	public class Game extends Sprite implements IAnimatable {
		protected var injector:Injector;
		private var camera:Camera;

		public function Game() {
			injector = new Injector();
			injector.map(Injector).toValue(injector);
			injector.map(Game).toValue(this);
			injector.map(AssetManager).asSingleton();
			injector.map(Camera).asSingleton();
			injector.map(Inputs).asSingleton();

			camera = injector.getInstance(Camera);

			initialize();
			startup();
			enableUpdate();
		}

		protected function initialize():void {
		}

		protected function startup():void {
			throw new AbstractMethodError("'startup' needs to be implemented in subclass");
		}

		protected function enableUpdate():void {
			Starling.current.juggler.add(this);
		}
		
		protected function disableUpdate():void {
			Starling.current.juggler.remove(this);
		}

		protected function enableKeyboardHandlers():void {
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}

		protected function disableKeyboardHandlers():void {
			Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			Starling.current.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}

		protected function enableTouchHandler():void {
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, touchHandler);
		}

		protected function disableTouchHandler():void {
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH, touchHandler);
		}

		private function keyDownHandler(e:KeyboardEvent):void {
			(injector.getInstance(Inputs) as Inputs).press(e.keyCode);
		}

		private function keyUpHandler(e:KeyboardEvent):void {
			(injector.getInstance(Inputs) as Inputs).release(e.keyCode);
		}

		private function touchHandler(e:TouchEvent):void {
			var touch:Touch = e.getTouch(stage);
			if (touch)
				broadcastMessage("handleTouch" + touch.phase.charAt(0).toUpperCase() + touch.phase.substr(1), e);

		}

		public function broadcastMessage(handler:String, ... params):void {
			for (var i:int = numChildren - 1; i >= 0; i--) {
				var screen:Screen = getChildAt(i) as Screen;
				if (screen.hasOwnProperty(handler))
					screen[handler].apply(screen, params);
				if (screen.blockMessage)
					break;
			}
		}

		public function replace(instanceOrClass:*):void {
			pop();
			push(instanceOrClass);
		}

		public function push(instanceOrClass:*):void {
			var instance:Screen = instanceOrClass is Class ? injector.getInstance(instanceOrClass) : instanceOrClass;
			addChild(instance);
			instance.enter();
		}

		public function pop():Boolean {
			if (numChildren > 0) {
				(removeChildAt(numChildren - 1) as Screen).exit();
				return true;
			}
			return false;
		}

		public function advanceTime(time:Number):void {
			camera.update(time);
			broadcastMessage("update", time);
		}
	}
}
