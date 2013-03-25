package threeshooter.dungeonadventure {
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import shooter.Effect;
	import shooter.Game;
	import shooter.Screen;
	import shooter.utils.RandomUtils;
	import shooter.utils.TweenUtils;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.utils.AssetManager;
	
	import threeshooter.dungeonadventure.domain.User;

	public class BattleScreen extends Screen {

		[Inject]
		public var assets:AssetManager;
		[Inject]
		public var game:Game;

		public var user:User;
		public var monsterDef:Object;
		public var hud:HUD;

		private var monster:Image;
		private var player:Image;
		private var messages:Sprite;
		private var backgroundMusic:SoundChannel;
		private var attackSound:SoundChannel;
		private var missSound:SoundChannel;

		public function BattleScreen() {
			super();
		}

		override public function enter():void {
			monster = new Image(assets.getTexture(monsterDef.kind));
			monster.x = Starling.current.viewPort.width >> 1;
			monster.y = 150;
			monster.pivotX = monster.width >> 1;
			monster.pivotY = monster.height >> 1;
			addChild(monster);

			player = WorldGenerator.buildAvatar(user, assets);
			player.x = Starling.current.viewPort.width >> 1;
			player.y = Starling.current.viewPort.height - player.height - 30;
			player.pivotX = player.width >> 1;
			player.pivotY = player.height >> 1;
			addChild(player);

			messages = new Sprite();
			addChild(messages);
		}

		override public function focus():void {
			backgroundMusic = assets.playSound("Battle1");
			var transform:SoundTransform = backgroundMusic.soundTransform;
			transform.volume = 0.5;
			backgroundMusic.soundTransform = transform;
		}

		override public function unfocus():void {
			backgroundMusic.stop();
			backgroundMusic = null;
		}

		private function showMessage(message:String, y:int, color:uint = 0xff0000, complete:Function = null):void {
			var label:TextField = new TextField(640, 48, message);
			label.x = (Starling.current.viewPort.width - label.width) >> 1;
			label.y = y;
			label.color = color;
			label.fontSize = 24;
			label.bold = true;
			label.filter = BlurFilter.createDropShadow(2, 0.785, 0, 1, 0, 1);
			messages.addChild(label);
			Starling.current.juggler.tween(label, 1.5, {y: label.y - 100, onComplete: function():void {
				Starling.current.juggler.tween(label, 0.5, {y: label.y - 30, alpha: 0, onComplete: function():void {
					messages.removeChild(label);
					if (complete != null)
						complete();
				}});
			}});
		}

		private function showAttachEffect(skill:String, x:int, y:int):void {
			var effect:Effect = WorldGenerator.buildAnimation(assets, skill);
			effect.x = x - effect.width / 2;
			effect.y = y - effect.height / 2;
			effect.play();
			addChild(effect);
		}

		private function playMiss():void {
			if (missSound)
				missSound.stop();
			missSound = assets.playSound("Miss", 0, 1);
		}
		
		private function playHit():void{
			if (attackSound)
				attackSound.stop();
			attackSound = assets.playSound("Attack1", 0, 1);
		}

		public function handleAttack(content:Object):void {
			showAttachEffect(content.skill, monster.x, monster.y);
			if (content.damage > 0) {
				TweenUtils.flash(monster);
				showMessage("- " + content.damage, monster.y, 0xff0000);
				playHit();
			} else {
				TweenUtils.miss(monster);
				showMessage("MISS!", monster.y, 0x00cc00);
				playMiss();
			}
		}

		public function handleDefense(content:Object):void {
			showAttachEffect(content.skill, player.x, player.y);
			user.hp -= content.damage;
			if (content.damage > 0) {
				TweenUtils.shake(hud);
				TweenUtils.flash(player);
				showMessage("- " + content.damage, player.y, 0xff0000);
				playHit();
			} else {
				TweenUtils.miss(player);
				showMessage("MISS!", player.y, 0x00cc00);
				playMiss();
			}
		}

		public function handleWin(reward:Object):void {
			TweenUtils.flash(monster, function():void {
				showMessage("WIN!! " + reward.gold + "G, " + reward.exp + " EXP!", player.y, 0x00cc00,
					game.pop);
			});
		}

		public function handleLose():void {
			messages.removeChildren();
			showMessage("YOU LOSE!!", player.y, 0xff0000);
			TweenUtils.flash(player, game.pop);
		}
	}
}
