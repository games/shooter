package threeshooter.dungeonadventure {
	import flash.geom.Rectangle;

	import shooter.Effect;
	import shooter.tilemaps.LayerDef;
	import shooter.tilemaps.MapData;
	import shooter.tilemaps.TileDef;

	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import threeshooter.dungeonadventure.domain.User;

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

		public static function buildCharacter(user:User, assets:AssetManager):Character {
			var x:int = int(user.avatar % 4) * 3;
			var y:int = int(user.avatar / 2) * 4;
			return new Character(user,
				buildMovieClip("down", assets, "Actor1", x, y, 32),
				buildMovieClip("left", assets, "Actor1", x, y + 1, 32),
				buildMovieClip("right", assets, "Actor1", x, y + 2, 32),
				buildMovieClip("up", assets, "Actor1", x, y + 3, 32));
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

		public static function buildFace(user:User, assets:AssetManager):Image {
			var x:int = user.avatar % 4;
			var y:int = user.avatar / 2;
			return new Image(Texture.fromTexture(assets.getTexture("Actor1Face"),
				new Rectangle(x * 96, y * 96, 96, 96)));
		}

		public static function buildAvatar(user:User, assets:AssetManager):Image {
			var avatarName:String = ["Grappler_m", "Grappler_f",
				"Hero_m", "Hero_f",
				"Delf_f", "Delf_m",
				"Wizard_m", "Wizard_f"][user.avatar];
			return new Image(assets.getTexture(avatarName));
		}

		public static function buildAnimation(assets:AssetManager, name:String, tile:int = 192):Effect {
			var texture:Texture = assets.getTexture(name);
			var x:int = texture.width / tile;
			var y:int = texture.height / tile;
			var textures:Vector.<Texture> = new Vector.<Texture>();
			for (var j:int = 0; j < y; j++) {
				for (var i:int = 0; i < x; i++) {
					var frame:Texture = Texture.fromTexture(texture,
						new Rectangle(i * tile, j * tile, tile, tile));
					textures.push(frame);
				}
			}
			return new Effect(textures, 24);
		}

	}
}
