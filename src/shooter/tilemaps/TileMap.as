package shooter.tilemaps {
	import starling.core.RenderSupport;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.utils.AssetManager;

	public class TileMap extends Sprite {
		private var data:MapData;
		private var renderer:MapRenderer;
		private var assets:AssetManager;

		public function TileMap(data:MapData, renderer:MapRenderer, assets:AssetManager) {
			this.data = data;
			this.renderer = renderer;
			this.assets = assets;
		}

		public function build():void {
			renderer.draw(this, data, assets);
		}
	}
}
