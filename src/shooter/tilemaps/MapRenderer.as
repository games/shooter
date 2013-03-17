package shooter.tilemaps {
	import shooter.Camera;
	
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.display.Sprite;

	public class MapRenderer {
		private var camera:Camera;

		public function MapRenderer(camera:Camera) {
			this.camera = camera;
		}

		public function draw(container:Sprite, data:MapData, assets:AssetManager):void {
			container.removeChildren();
			for each (var layer:Object in data.layers) {
				var layerCanvas:QuadBatch = new QuadBatch();
				var grid:Array = layer.grid;
				for (var row:int = 0; row < grid.length; row++) {
					var rows:Array = grid[row];
					for (var col:int = 0; col < rows.length; col++) {
						var tileId:int = rows[col];
						if (tileId > 0) {
							var tileInfo:Object = data.getTileById(tileId);
							var texture:Texture = assets.getTexture(tileInfo.texture);
							var tileTexture:Texture = Texture.fromTexture(texture, tileInfo.region);
							var img:Image = new Image(tileTexture);
							img.x = col * data.tileWidth;
							img.y = row * data.tileHeight;
							layerCanvas.addImage(img);
						}
					}
				}
				layerCanvas.touchable = false;
				container.addChild(layerCanvas);
			}
			container.flatten();
		}
	}
}
