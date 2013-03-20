package shooter.tilemaps {

	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public class MapRenderer {

		public function MapRenderer() {
		}

		public function draw(data:MapData, assets:AssetManager, tilesLayer:QuadBatch):void {
			tilesLayer.reset();
			for each (var layer:LayerDef in data.layers) {
				var grid:Array = layer.grid;
				for (var row:int = 0; row < grid.length; row++) {
					var rows:Array = grid[row];
					for (var col:int = 0; col < rows.length; col++) {
						var tileId:int = rows[col];
						if (tileId > 0) {
							var tileDef:TileDef = data.getTileById(tileId);
							if (tileDef) {
								var texture:Texture = assets.getTexture(tileDef.texture);
								var tileTexture:Texture = Texture.fromTexture(texture, tileDef.region);
								var img:Image = new Image(tileTexture);
								img.x = col * data.tileWidth;
								img.y = row * data.tileHeight;
								tilesLayer.addImage(img);
							}
						}
					}
				}
			}
		}
	}
}
