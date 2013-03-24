package {
	import example.MyGame;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.Security;
	
	import mx.utils.StringUtil;
	
	import starling.core.Starling;
	
	import threeshooter.dungeonadventure.DungeonAdventure;

	[SWF(width = "640", height = "640", frameRate = "60", backgroundColor = "#000000")]
	public class Shooter extends Sprite {
		public function Shooter() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			var star:Starling = new Starling(DungeonAdventure, stage);
			star.showStats = true;
			star.showStatsAt("right");
			star.start();

//			var s:String = "Angel.png	Demon.png	Grappler_f.png	Orc.png		Succubus.png Assassin.png	Dragon.png	Grappler_m.png	Paladin_f.png	Swordman.pngAsura.png	Earthspirit.png	Hero_f.png	Paladin_m.png	Thief_f.png Bandit.png	Evilgod.png	Hero_m.png	Plant.png	Thief_m.png Bat.png		Evilking.png	Hornet.png	Priest.png	Vampire.png 		Behemoth.png	Fairy.png	Icelady.png	Puppet.png	Warrior_f.png Captain.png	Fanatic.png	Ifrit.png	Rat.png		Warrior_m.png Chimera.png	Firespirit.png	Imp.png		Rogue.png	Waterspirit.png Cleric_f.png	Gargoyle.png	Jellyfish.png	Sahagin.png	Werewolf.png Cleric_m.png	Garuda.png	Kerberos.png	Scorpion.png	Willowisp.png Cockatrice.png	Gayzer.png	Lamia.png	Skeleton.png	Windspirit.png Death.png	Ghost.png	Mimic.png	Snake.png	Wizard_m.png Delf_f.png	God.png		Minotaur.png	Soldier.png	Zombie.png Delf_m.png	Goddess.png	Ogre.png	Spider.png";
//
//			var ss:Array = s.split(".png");
//			var a:Array = [];
//			for each (var sss:String in ss) {
//				a.push("\"" + StringUtil.trim(sss) + "\"");
//			}
//			trace(a);

		}
	}
}
