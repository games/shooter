package threeshooter.dungeonadventure {
	import feathers.controls.ProgressBar;

	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.filters.BlurFilter;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.AssetManager;
	import starling.utils.HAlign;

	import threeshooter.dungeonadventure.domain.User;

	public class HUD extends Sprite {

		private var user:User;
		private var face:Image;
		private var hpProgress:ProgressBar;

		public function HUD(user:User, assets:AssetManager) {
			super();
			this.user = user;

			face = WorldGenerator.buildFace(user, assets);
			face.x = 10;
			face.y = 10;
			face.scaleX = face.scaleY = 0.5;
			face.filter = BlurFilter.createDropShadow(2, 0.785, 0, 1, 0, 1);
			addChild(face);

			var level:TextField = new TextField(48, 10, "LEVEL " + user.level,
				BitmapFont.MINI, BitmapFont.NATIVE_SIZE, 0xffffff);
			level.x = face.x + face.width + 10;
			level.y = 10;
			level.color = 0xffffff;
			level.autoScale = true;
			level.hAlign = HAlign.LEFT;
			level.filter = BlurFilter.createDropShadow(2, 0.785, 0, 1, 0, 1);
			addChild(level);

			var hp:TextField = new TextField(48, 10, "HP",
				BitmapFont.MINI, BitmapFont.NATIVE_SIZE, 0xffffff);
			hp.x = face.x + face.width + 10;
			hp.y = level.y + level.height;
			hp.color = 0xffffff;
			hp.autoScale = true;
			hp.hAlign = HAlign.LEFT;
			hp.filter = BlurFilter.createDropShadow(2, 0.785, 0, 1, 0, 1);
			addChild(hp);

			hpProgress = new ProgressBar();
			hpProgress.x = hp.x + 20;
			hpProgress.y = hp.y + hp.height / 2 - 3;
			hpProgress.minimum = 0;
			hpProgress.maximum = user.hp;
			hpProgress.filter = BlurFilter.createDropShadow(2, 0.785, 0, 1, 0, 1);
			addChild(hpProgress);
		}

		override public function render(support:RenderSupport, parentAlpha:Number):void {
			super.render(support, parentAlpha);
			hpProgress.value = user.hp;
		}
	}
}
