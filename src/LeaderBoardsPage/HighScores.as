package LeaderBoardsPage 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import Playtomic.Leaderboards;
	/**
	 * ...
	 * @author iam
	 */
	public class HighScores 
	{
		
		private static var Parent:DisplayObjectContainer;
		private static var Xc:int;
		private static var Yc:int;
		private static var rl:ResultsList;
		private static var cr:CurrentRecords;
		
		public static function receive(x:int, y:int, parent:DisplayObjectContainer):void 
		{
			Parent = parent;
			var OptionsObject:Object = new Object();
			OptionsObject.global = true;
			OptionsObject.highest = true;
			OptionsObject.mode = "alltime";
			OptionsObject.page = 1;
			OptionsObject.perpage = 500;
			Xc = x;
			Yc = y;
			Leaderboards.List(App.TableName, onCallBackScores, OptionsObject);
		}
		
		static public function onCallBackScores(scores:Array, numscores:int, response:Object):void 
		{
			if (response.Success) {
				rl = new ResultsList();
				cr = new CurrentRecords();
				rl.Init(Parent, scores, Xc, Yc);
				cr.Init(Parent, scores, Xc, Yc);
				HighscoresControll.init(rl as Sprite, cr as Sprite);
				
			} else {
				//TODO
			}
		}
		
		public static function close():void 
		{
			if (rl) { 
				rl.Destroy();
			}
			if (cr) {
				cr.Destroy();
			}
		}
	}

}