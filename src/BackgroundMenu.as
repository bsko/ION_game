package  
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import Playtomic.Leaderboards;
	import Playtomic.PlayerScore;
	/**
	 * ...
	 * @author iam
	 */
	public class BackgroundMenu extends Sprite 
	{
		private var _interface_movie:MovieClip = new interface_mc();
		private var _textFormatNorm:TextFormat = new TextFormat();
		private var _textFormatUnd:TextFormat = new TextFormat();
		
		public function BackgroundMenu() 
		{
			
		}
		
		public function Init():void 
		{
			_textFormatUnd.underline = true;
			
			addChild(_interface_movie);
			_interface_movie.gotoAndStop(1);
			InitLinks();
			
			
			_interface_movie.start_game.addEventListener(MouseEvent.CLICK, onStartGame, false, 0, true);
		}
		
		public function InitLinks():void
		{
			if (!_interface_movie.getChildByName("link")) {
				return;
			}
			
			var tf:TextField;
			var mc:MovieClip = _interface_movie.getChildByName("link") as MovieClip;
			if (mc.numChildren > 0) {
				for (var i:int = 0; i < mc.numChildren; i++) {
					if (mc.getChildAt(i) is TextField) {
						tf = mc.getChildAt(i) as TextField;
						break;
					}
				}
				
				if (!tf) {
					return;
				}
				mc.buttonMode = true;
				tf.mouseEnabled = false;
				mc.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
				mc.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
				mc.addEventListener(MouseEvent.CLICK, onNavigate, false, 0, true);
				//mc.addEventListener(MouseEvent.CLICK, onNavigate, false, 0, true);
			}
		}
		
		private function onNavigate(e:MouseEvent):void 
		{
			App.SoundMngr.playSound("click");
			navigateToURL(new URLRequest("http://job.i-on.ru"));
		}
		
		private function onOut(e:MouseEvent):void 
		{
			if (e.target is MovieClip) {
				if ((e.target as MovieClip).getChildAt(0) is TextField) {
					var tfield:TextField = ((e.target as MovieClip).getChildAt(0) as TextField);
					var tformat:TextFormat = tfield.getTextFormat();
					tformat.underline = false;
					tfield.setTextFormat(tformat);
				}
			}
		}
		
		private function onOver(e:MouseEvent):void 
		{
			if (e.target is MovieClip) {
				if ((e.target as MovieClip).getChildAt(0) is TextField) {
					var tfield:TextField = ((e.target as MovieClip).getChildAt(0) as TextField);
					var tformat:TextFormat = tfield.getTextFormat();
					tformat.underline = true;
					tfield.setTextFormat(tformat);
				}
			}
		}
		
		public function Loose(score:int):void 
		{
			App.SoundMngr.playSound("loose");
			_interface_movie.gotoAndStop("loose");
			InitLinks();
			_interface_movie.score.text = String(score);
			var tformat:TextFormat = _interface_movie.score.getTextFormat();
			tformat.bold = true;
			_interface_movie.score.setTextFormat(tformat);
			//_interface_movie.result.visible = true;
			//_interface_movie.result.addEventListener(MouseEvent.CLICK, onReport, false, 0, true);
			_interface_movie.regame.addEventListener(MouseEvent.CLICK, onStartGame, false, 0, true);
			
			WP_LinkedTextInit();
		}
		
		public function Win(score:int):void 
		{
			App.SoundMngr.playSound("win");
			_interface_movie.gotoAndStop("win");
			InitLinks();
			_interface_movie.score.text = String(score);
			var tformat:TextFormat = _interface_movie.score.getTextFormat();
			tformat.bold = true;
			_interface_movie.score.setTextFormat(tformat);
			
			_interface_movie.result.visible = true;
			_interface_movie.result.addEventListener(MouseEvent.CLICK, onReport, false, 0, true);
			_interface_movie.regame.addEventListener(MouseEvent.CLICK, onStartGame, false, 0, true);
			
			var player_score:PlayerScore = new PlayerScore();
			player_score.Name = InfoReader.Name + " " + InfoReader.LastName;
			player_score.FBUserId = String(InfoReader.UserID);
			player_score.CustomData.pageUrl = InfoReader.LinkToUserPage;
			player_score.Points = App.Total_SCORE;
			Leaderboards.Save(player_score, App.TableName);
			
			WP_LinkedTextInit();
		}
		
		private function WP_LinkedTextInit():void
		{
			var tfield:MovieClip = _interface_movie.linked_text;
			
			if (tfield.getChildAt(0) is TextField) 
			{
				var tf:TextField = tfield.getChildAt(0) as TextField;
				var tformat:TextFormat = tf.getTextFormat();
				tformat.underline = true;
				tf.setTextFormat(tformat);
			}
			
			tfield.buttonMode = true;
			
			tfield.addEventListener(MouseEvent.MOUSE_OVER, onLTOver, false, 0, true);
			tfield.addEventListener(MouseEvent.MOUSE_OUT, onLTOut, false, 0, true);
			tfield.addEventListener(MouseEvent.CLICK, onWPnavigateURL, false, 0, true);
		}
		
		private function onWPnavigateURL(e:MouseEvent):void 
		{
			App.SoundMngr.playSound("click");
			navigateToURL(new URLRequest("http://job.i-on.ru"));
		}
		
		private function onLTOut(e:MouseEvent):void 
		{
			if (e.currentTarget is MovieClip) {
				var mc:MovieClip = e.currentTarget as MovieClip;
				if (mc.getChildAt(0) is TextField) {
					var tfield:TextField = mc.getChildAt(0) as TextField;
					var tformat:TextFormat = tfield.getTextFormat();
					tformat.underline = true;
					tfield.setTextFormat(tformat);
				}
			}
		}
		
		private function onLTOver(e:MouseEvent):void 
		{
			if (e.currentTarget is MovieClip) {
				var mc:MovieClip = e.currentTarget as MovieClip;
				if (mc.getChildAt(0) is TextField) {
					var tfield:TextField = mc.getChildAt(0) as TextField;
					var tformat:TextFormat = tfield.getTextFormat();
					tformat.underline = false;
					tfield.setTextFormat(tformat);
				}
			}
		}
		
		private function onReport(e:MouseEvent):void 
		{
			App.SoundMngr.playSound("click");
			
			var request_params: Object = new Object();
            request_params.api_id = InfoReader.Api_ID;
            request_params.method = 'wall.post';
			request_params.format = 'XML';
            request_params.v = '3.0';
            request_params.owner_id = InfoReader.UserID;
			var text:String = App.APPLICATION_URL + " :  я набрал " + String(App.Total_SCORE) + " очков и меня пригласили в ИОН!";
            request_params.message = text;
			
			App.apiConnection.api("wall.post", { message:text } );
			
			if (e.target is SimpleButton) {
				(e.target as SimpleButton).visible = false;
			}
		}
		
		public function onStartGame(e:MouseEvent):void 
		{
			App.SoundMngr.playSound("click");
			_interface_movie.removeEventListener(MouseEvent.CLICK, onStartGame, false);
			_interface_movie.gotoAndStop(2);
			InitLinks();
			App.root.StartGame();
		}
		
		public function Destroy():void 
		{
			
		}
	}

}