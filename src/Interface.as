package  
{
	import Events.PauseEvent;
	import Events.Restart;
	import Events.UpdateScore;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import LeaderBoardsPage.CurrentRecords;
	import LeaderBoardsPage.HighScores;
	import LeaderBoardsPage.HighscoresControll;
	
	/**
	 * ...
	 * @author iam
	 */
	
	public class Interface extends Sprite
	{
		public static var IsWathcingMenu:Boolean = false;
		private var _interface_mc:MovieClip = new user_interface_mc();
		private var _O_btn:SimpleButton;
		private var _Q_btn:SimpleButton;
		private var _L_btn:SimpleButton;
		private var _A_btn:SimpleButton;
		private var _sound_mc:MovieClip;
		private var _score_tf:TextField;
		private var _level_tf:TextField;
		private var _lifesMovie:MovieClip;
		private var _newgame_btn:SimpleButton;
		private var _highscores_btn:SimpleButton;
		private var _highscoresOpened:Boolean = false;
		private var _restart_acception:MovieClip = new newgamewindow();
		
		public function Interface() 
		{
			_restart_acception.stop();
			_O_btn = _interface_mc.o_btn;
			_Q_btn = _interface_mc.q_btn;
			_L_btn = _interface_mc.l_btn;
			_A_btn = _interface_mc.a_btn;
			_sound_mc = _interface_mc.snd_btn;
			_sound_mc.buttonMode = true;
			_score_tf = _interface_mc.score;
			_level_tf = _interface_mc.level;
			_lifesMovie = _interface_mc.lifes;
			_interface_mc.mouseEnabled = false;
			this.mouseEnabled = false;
			
			_highscores_btn = _interface_mc.rating_btn;
			_newgame_btn = _interface_mc.new_game_btn;
			
			UpdateSoundBtn();
		}
		
		public function Init():void
		{
			_level_tf.text = "1";
			_lifesMovie.gotoAndStop(3);
			_score_tf.text = "0";
			_interface_mc.name_tf.text = App.UserName;
			addChild(_interface_mc);
			_Q_btn.addEventListener(MouseEvent.CLICK, onQBtn, false, 0, true);
			_O_btn.addEventListener(MouseEvent.CLICK, onOBtn, false, 0, true);
			_L_btn.addEventListener(MouseEvent.CLICK, onLBtn, false, 0, true);
			_A_btn.addEventListener(MouseEvent.CLICK, onABtn, false, 0, true);
			_sound_mc.addEventListener(MouseEvent.CLICK, onChangeSoundMode, false, 0, true);
			App.universe.addEventListener(UpdateScore.UPDATE, onUpdateScore, false, 0, true);
			_highscores_btn.addEventListener(MouseEvent.CLICK, onHighScores, false, 0, true);
			_newgame_btn.addEventListener(MouseEvent.CLICK, onNewGame, false, 0, true);
		}
		
		private function onNewGame(e:MouseEvent):void 
		{
			if (!App.isOnPause) {
				Pause();
			}
			App.SoundMngr.playSound("click");
			IsWathcingMenu = true;
			_restart_acception.gotoAndStop(1);
			_restart_acception.x = 0 - this.x;
			_restart_acception.y = 0 - this.y;
			
			addChild(_restart_acception);
			
			_restart_acception.yes.addEventListener(MouseEvent.CLICK, onRestartGame, false, 0, true);
			_restart_acception.no.addEventListener(MouseEvent.CLICK, onResumeGame, false, 0, true);
		}
		
		private function onResumeGame(e:MouseEvent):void 
		{
			App.SoundMngr.playSound("click");
			if (_highscoresOpened) {
				HighScores.close();
			}
			if (contains(_restart_acception)) {
				removeChild(_restart_acception);
			}
			if (App.isOnPause && !Splash.IsWatchingSplash) {
				Pause();
			}
			IsWathcingMenu = false;
		}
		
		private function onRestartGame(e:MouseEvent):void 
		{
			if (contains(_restart_acception)) {
				removeChild(_restart_acception);
			}
			App.SoundMngr.playSound("click");
			if (App.isOnPause && !Splash.IsWatchingSplash) {
				Pause();
			}
			IsWathcingMenu = false;
			
			dispatchEvent(new Restart(Restart.RESTART));
		}
		
		private function onHighScores(e:MouseEvent):void 
		{
			if (!App.isOnPause) {
				Pause();
			}
			App.SoundMngr.playSound("click");
			IsWathcingMenu = true;
			
			_highscoresOpened = true;
			_restart_acception.gotoAndStop(2);
			_restart_acception.score.text = App.universe.score;
			_restart_acception.x = 0 - this.x;
			_restart_acception.y = 0 - this.y;
			HighscoresControll.initParentMovieClip(_restart_acception);
			HighScores.receive(250, 200, _restart_acception);
			addChild(_restart_acception);
			
			_restart_acception.back_mc.yes.addEventListener(MouseEvent.CLICK, onResumeGame, false, 0, true);
		}
		
		public function Pause():void 
		{
			App.isOnPause = !App.isOnPause;
			if(App.isOnPause) {
				dispatchEvent(new PauseEvent(PauseEvent.PAUSE));
			} else {
				dispatchEvent(new PauseEvent(PauseEvent.UNPAUSE));
			}
		}
		
		public function ChangeLifesCount(arg:int):void 
		{
			if(arg > 0 && arg <= _lifesMovie.totalFrames) {
				_lifesMovie.gotoAndStop(arg);
			}
		}
		
		private function onUpdateScore(e:UpdateScore):void 
		{
			_score_tf.text = String(e.score);
		}
		
		private function onChangeSoundMode(e:MouseEvent):void 
		{
			App.SoundMngr.playSound("click");
			App.SoundMngr.changeSoundsMode();
			App.sound = !App.sound;
			UpdateSoundBtn();
		}
		
		private function onABtn(e:MouseEvent):void 
		{
			App.SoundMngr.playSound("click");
			App.universe.hero.ChangeState(Hero.STATE_BOTTOM_LEFT);
		}
		
		private function onLBtn(e:MouseEvent):void 
		{
			App.SoundMngr.playSound("click");
			App.universe.hero.ChangeState(Hero.STATE_BOTTOM_RIGHT);
		}
		
		private function onOBtn(e:MouseEvent):void 
		{
			App.SoundMngr.playSound("click");
			App.universe.hero.ChangeState(Hero.STATE_UPPER_RIGHT);
		}
		
		private function onQBtn(e:MouseEvent):void 
		{
			App.SoundMngr.playSound("click");
			App.universe.hero.ChangeState(Hero.STATE_UPPER_LEFT);
		}
		
		private function UpdateSoundBtn():void 
		{
			if (App.sound) {
				_sound_mc.gotoAndStop("on");
			} else {
				_sound_mc.gotoAndStop("off");
			}
		}
		
		public function UpdateLevel(arg1:Object):void 
		{
			_level_tf.text = String(arg1);
		}
		
		public function Destroy():void 
		{
			removeChild(_interface_mc);
		}
		
		
		
	}

}