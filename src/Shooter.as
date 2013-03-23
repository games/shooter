package {
	import example.MyGame;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.Security;

	import starling.core.Starling;

	import threeshooter.dungeonadventure.DungeonAdventure;

	[SWF(width = "640", height = "640", frameRate = "60", backgroundColor = "#000000")]
	public class Shooter extends Sprite {
		public function Shooter() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			var star:Starling = new Starling(DungeonAdventure, stage);
			star.showStats = true;
			star.start();
		}
	}
}
