package shooter.tilemaps
{
	import flash.utils.Dictionary;
	
	/**
	 * Parse data from xml(TMX).
	 */
	public class TMXParser
	{
		public static function parse(tmx:XML):MapData{
			var mapData:MapData = new MapData();
			mapData.orientation = String(tmx.@orientation);
			mapData.column = int(tmx.@width);
			mapData.row = int(tmx.@height);
			mapData.tileWidth = int(tmx.@tilewidth);
			mapData.tileHeight = int(tmx.@tileheight);
			mapData.textures = [];
			for each(var t:XML in tmx.tileset){
				var textureDef:Object = {
					source: String(t.image.@source), 
					imageWidth: int(t.image.@width), imageHeight: int(t.image.@height),
					spacing: int(t.@spacing), margin: int(t.@margin)
				};
				textureDef.width = (textureDef.imageWidth - textureDef.margin) / (mapData.tileWidth + textureDef.spacing);
				textureDef.height = (textureDef.imageHeight - textureDef.margin) / (mapData.tileHeight + textureDef.spacing);
				textureDef.count = int(textureDef.width * textureDef.height);
				mapData.textures.push(textureDef);
			}
			mapData.layers = [];
			for each(var l:XML in tmx.layer){
				var layer:Object = {
					name: String(l.@name),
					width: int(l.@width), height: int(l.@height)
				};
				var grid:Array = [];
				for(var row:int = 0; row < layer.height; row++){
					var rows:Array = [];
					for(var col:int = 0; col < layer.width; col++){
						rows.push(int(l.data.tile[row * layer.width + col].@gid)); 
					}
					grid[row] = rows;
				}
				layer.grid = grid;
				mapData.layers.push(layer);
			}
			mapData.objectGroups = new Dictionary();
			for each(var g:XML in tmx.objectgroup){
				var objectGroup:Object = {properties: new Dictionary(), data:[]};
				for each(var o:XML in g.object){
					var obj:Object = {
						name: String(o.@name), type: String(o.@type), 
						x: int(o.@x), y: int(o.@y),
						width: int(o.@width), height: int(o.@height)
					};
					if(o.polygon[0])
						obj.points = String(o.polygon[0].@polygon)
					else if(o.polyline[0])
						obj.points = String(o.polyline[0].@polygon)
					objectGroup.data.push(obj);
				}
				for each(var p:XML in g.properties.property)
					objectGroup.properties[String(p.@name)] = String(p.@value);
				mapData.objectGroups[String(g.@name)] = objectGroup;
			}
			
			//initialize collision.
			var blocks:Dictionary = new Dictionary();
			var width:int = mapData.column * mapData.tileWidth;
			var height:int = row * mapData.tileHeight;
			for each (var group:Object in mapData.objectGroups) {
				var type:String = group.properties["type"];
				if (type == "collision") {
					for each (var data:Object in group.data) {
						var startX:int = data.x / mapData.tileWidth;
						var startY:int = data.y / mapData.tileHeight;
						var endX:int = (data.x + data.width) / mapData.tileWidth;
						var endY:int = (data.y + data.height) / mapData.tileHeight;
						for (var i:int = startX; i <= endX; i++) {
							for (var j:int = startY; j <= endY; j++)
								blocks[i + "," + j] = true;
						}
					}
				}
			}
			mapData.blocks = blocks;
			return mapData;
		}
	}
}