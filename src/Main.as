package 
{
	import Events.Restart;
	import Events.WinLooseEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import LeaderBoardsPage.MouseWheel;
	import LeaderBoardsPage.ReportResult;
	import LeaderBoardsPage.ResultsList;
	import Playtomic.Leaderboards;
	import Playtomic.Log;
	import Playtomic.PlayerScore;
	import vk.APIConnection;
	
	/**
	 * ...
	 * @author iam
	 */
	public class Main extends Sprite 
	{
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			Log.View(App.SWF_ID, App.GUID, loaderInfo.loaderURL);
			
			App.root = this;
			App.stage = stage;
			
			var api_id:Number = loaderInfo.parameters.api_id;
			var viewer_id:int = loaderInfo.parameters.viewer_id;
			var secret:String = loaderInfo.parameters.secret;
			var sid:String = loaderInfo.parameters.sid;
			var api_url:String = loaderInfo.parameters.api_url;
			
			//test:
			/*var object:Object = new Object();
			object.api_id = 2450748;
			object.viewer_id = 1483994;
			object.secret = "1b4aaeaa9a";
			object.sid = "9ead6ec85e7098ccd200d580c7dbd6bf99dcd5a31a6ba149c45f5078da3a6e";
			object.api_url = "http://api.vkontakte.ru/api.php";*/
			
			App.apiConnection = new APIConnection(loaderInfo.parameters as Object);
			//App.apiConnection = new APIConnection(object);
			InfoReader.Load(api_id, viewer_id, secret, sid, api_url);
			
			//InfoReader.Load(2450748, 1483994, "1b4aaeaa9a", "9ead6ec85e7098ccd200d580c7dbd6bf99dcd5a31a6ba149c45f5078da3a6e", "http://api.vkontakte.ru/api.php");
			
			App.InitDifficultyLevels();
			
			//test:
			/*var playscore:PlayerScore = new PlayerScore();
			playscore.Name = "Valera Valera";
			playscore.CustomData.pageUrl = "http://vkontakte.ru";
			playscore.FBUserId = String(25635);
			playscore.Points = 379;
			Leaderboards.Save(playscore, App.TableName);*/
		}
		
		public function DataReceived(name:String, lastName:String):void 
		{
			App.userInterface = new Interface();
			App.universe = new Universe();
			App.backgroundMenu = new BackgroundMenu();
			App.SoundMngr.initSounds();
			
			App.UserName = (name == "") ? "name" : name;
			App.UserLastName = (lastName == "") ? "lastname" : lastName;
			
			//adding:
			addChild(App.backgroundMenu);
			//addChild(App.universe);
			//addChild(App.userInterface);
			
			App.universe.x = int((App.WINDOW_WIDTH - App.universe.width) / 2);
			App.universe.y = 150;
			App.userInterface.x = 54;
			App.userInterface.y = 58;
			
			App.backgroundMenu.Init();
			//App.universe.Init();
			//App.userInterface.Init();
		}
		
		public function StartGame():void 
		{
			//PostMessage.post();
			addChild(App.universe);
			addChild(App.userInterface);
			App.universe.Init();
			App.userInterface.Init();
			
			addEventListener(Event.ENTER_FRAME, onUpdateFocus, false, 0, true);
			App.universe.addEventListener(WinLooseEvent.LOOSE, onLoose, false, 0, true);
			App.universe.addEventListener(WinLooseEvent.WIN, onWin, false, 0, true);
			App.userInterface.addEventListener(Restart.RESTART, onRestart, false, 0, true);
		}
		
		private function onRestart(e:Restart):void 
		{
			removeChild(App.universe);
			removeChild(App.userInterface);
			App.universe.Destroy();
			App.userInterface.Destroy();
			addChild(App.universe);
			addChild(App.userInterface);
			App.universe.Init();
			App.userInterface.Init();
		}
		
		private function onWin(e:WinLooseEvent):void 
		{
			removeChild(App.universe);
			removeChild(App.userInterface);
			App.universe.Destroy();
			App.userInterface.Destroy();
			if (App.universe.score > 500) {
				App.backgroundMenu.Win(App.universe.score);
			} else {
				App.backgroundMenu.Loose(App.universe.score);
			}
		}
		
		private function onLoose(e:WinLooseEvent):void 
		{
			removeChild(App.universe);
			removeChild(App.userInterface);
			App.universe.Destroy();
			App.userInterface.Destroy();
			if (App.universe.score > 500) {
				App.backgroundMenu.Win(App.universe.score);
			} else {
				App.backgroundMenu.Loose(App.universe.score);
			}
		}
		
		private function onUpdateFocus(e:Event):void 
		{
			stage.focus = stage;
		}
		
	}
	
}