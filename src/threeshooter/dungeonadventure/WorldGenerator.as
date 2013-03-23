package threeshooter.dungeonadventure {
	import flash.geom.Rectangle;

	import shooter.tilemaps.LayerDef;
	import shooter.tilemaps.MapData;
	import shooter.tilemaps.TileDef;

	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public class WorldGenerator {
		public static function buildMap(col:int, row:int, tileWidth:int, tileHeight:int, startX:int,
			startY:int, endX:int, endY:int):MapData {
			var mapData:MapData = new MapData();
			mapData.column = col;
			mapData.row = row;
			mapData.layers = new Vector.<LayerDef>();
			var grid:Array = [];
			for (var y:int = 0; y < row; y++) {
				var rows:Array = [];
				for (var x:int = 0; x < col; x++) {
					if (startX == x && startY == y)
						rows.push(2);
					else if (endX == x && endY == y)
						rows.push(3);
					else {
						rows.push(1);
						mapData.blocks[x + "," + y] = true;
					}
				}
				grid[y] = rows;
			}
			mapData.layers.push(new LayerDef("mask", x, y, grid));
			mapData.tileDefs[1] = new TileDef("Inside_A5", new Rectangle(7 * 32, 14 * 32, 32, 32));
			mapData.tileDefs[2] = new TileDef("Inside_A5", new Rectangle(6 * 32, 15 * 32, 32, 32));
			mapData.tileDefs[3] = new TileDef("Inside_A5", new Rectangle(5 * 32, 14 * 32, 32, 32));
			mapData.tileWidth = tileWidth;
			mapData.tileHeight = tileHeight;
			return mapData;
		}

		public static function buildCharacter(assets:AssetManager):Character {
			return new Character(
				buildMovieClip("down", assets, "Actor1", 0, 0, 32),
				buildMovieClip("left", assets, "Actor1", 0, 1, 32),
				buildMovieClip("right", assets, "Actor1", 0, 2, 32),
				buildMovieClip("up", assets, "Actor1", 0, 3, 32));
		}

		private static function buildMovieClip(name:String, assets:AssetManager, texture:String, x:int,
			y:int, tile:int):MovieClip {
			var actorTextures:Vector.<Texture> = new Vector.<Texture>();
			var row:int = y * tile;
			for (var i:int = 0; i < 3; i++) {
				var frame:Texture = Texture.fromTexture(assets.getTexture("Actor1"), new Rectangle((i + x) * tile,
					row, tile, tile));
				actorTextures.push(frame);
			}
			var actor:MovieClip = new MovieClip(actorTextures, 8);
			actor.name = name;
			return actor
		}

	}
}
