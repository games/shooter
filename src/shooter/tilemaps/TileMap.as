package shooter.tilemaps {
	import flash.geom.Point;

	import shooter.Camera;

	import starling.core.RenderSupport;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.utils.AssetManager;

	public class TileMap extends Sprite {
		public var camera:Camera;
		public var data:MapData;
		public var renderer:MapRenderer;
		public var assets:AssetManager;
		public var builded:Boolean;

		public function TileMap(camera:Camera, data:MapData, renderer:MapRenderer, assets:AssetManager) {
			this.camera = camera;
			this.data = data;
			this.renderer = renderer;
			this.assets = assets;
			builded = false;
		}

		public function stagePosToTilePos(x:int, y:int):Point {
			return new Point(int((x + camera.viewport.x) / data.tileWidth), int((y + camera.viewport.y) / data.tileHeight));
		}

		public function blocked(x:int, y:int):Boolean {
			return data.blocked(x, y);
		}

		override public function render(support:RenderSupport, parentAlpha:Number):void {
			if (!builded) {
				renderer.draw(this);
				camera.bounds.setTo(x, y, width, height);
				builded = true;
			}
			x = -camera.viewport.x;
			y = -camera.viewport.y;
			scaleX = scaleY = camera.zoom;
			rotation = camera.rotation;
			super.render(support, parentAlpha);
		}
	}
}
