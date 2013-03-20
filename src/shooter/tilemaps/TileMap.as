package shooter.tilemaps {
	import flash.geom.Point;
	
	import shooter.Camera;
	
	import starling.core.RenderSupport;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.utils.AssetManager;

	public class TileMap extends Sprite {
		public var camera:Camera;
		public var data:MapData;
		public var renderer:MapRenderer;
		public var assets:AssetManager;
		public var tilesLayer:QuadBatch;
		public var itemsLayer:Sprite;
		private var present:Function;

		public function TileMap(camera:Camera, data:MapData, assets:AssetManager, renderer:MapRenderer = null) {
			this.camera = camera;
			this.data = data;
			this.renderer = renderer || new MapRenderer();
			this.assets = assets;
			tilesLayer = new QuadBatch();
			itemsLayer = new Sprite();
			tilesLayer.blendMode = BlendMode.NONE;
			tilesLayer.touchable = false;
			present = build;

			addChild(tilesLayer);
			addChild(itemsLayer);
		}

		public function stagePosToTilePos(x:int, y:int):Point {
			return new Point(int((x + camera.viewport.x) / data.tileWidth), int((y + camera.viewport.y) / data.tileHeight));
		}

		public function blocked(x:int, y:int):Boolean {
			return data.blocked(x, y);
		}

		public function addItem(child:DisplayObject):void {
			itemsLayer.addChild(child);
		}

		private function build():void {
			renderer.draw(data, assets, tilesLayer);
			camera.bounds.setTo(0, 0, tilesLayer.width, tilesLayer.height);
			present = draw;
		}

		private function draw():void {
			x = -camera.viewport.x;
			y = -camera.viewport.y;
			scaleX = scaleY = camera.zoom;
			rotation = camera.rotation;
		}

		override public function render(support:RenderSupport, parentAlpha:Number):void {
			present();
			super.render(support, parentAlpha);
		}
	}
}
