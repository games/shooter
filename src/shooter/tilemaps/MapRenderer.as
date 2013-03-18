package shooter.tilemaps {

	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public class MapRenderer {

		public function MapRenderer() {
		}

		public function draw(tileMap:TileMap):void {
			var data:MapData = tileMap.data;
			var assets:AssetManager = tileMap.assets;
			
			tileMap.removeChildren();
			tileMap.blendMode = BlendMode.NONE;
			tileMap.touchable = false;
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
				tileMap.addChild(layerCanvas);
			}
			tileMap.flatten();
		}
	}
}
