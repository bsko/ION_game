package LeaderBoardsPage 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import Playtomic.Leaderboards;
	import Playtomic.PlayerScore;
	/**
	 * ...
	 * @author iam
	 */
	public class ReportResult extends Sprite
	{
		
		private var _repResult_mc:MovieClip = new reportResultMC();
		private var _parent:DisplayObjectContainer;
		private var _yourScore:TextField;
		private var _name:TextField;
		private var _submitBtn:SimpleButton;
		private var _score:int;
		private var _link:String;
		private var _sName:String;
		private var _htmlName:String;
		private var _userID:int;
		
		public function ReportResult()
		{
			addChild(_repResult_mc);
			_yourScore = _repResult_mc.score_field;
			_name = _repResult_mc.name_field;
			_submitBtn = _repResult_mc.submit_btn;
			_yourScore.selectable = false;
			_submitBtn.visible = true;
		}
		
		public function Init(parent:DisplayObjectContainer, score:int, name:String, link:String, id:int):void
		{
			_score = score;
			_parent = parent;
			_yourScore.text = "Your score: " + String(score);
			_sName = name;
			_userID = id;
			_link = link;
			_htmlName = link;
			_name.text = _sName;
			
			if(_score != App.LastSavedScore) {
				_submitBtn.addEventListener(MouseEvent.CLICK, onAplyResult, false, 0, true);
			} else {
				_submitBtn.visible = false;
			}
			
			_parent.addChild(this);
		}
		
		private function onAplyResult(e:MouseEvent):void 
		{
			if(_score != App.LastSavedScore) {
				var simple_score:PlayerScore = new PlayerScore();
				simple_score.Name = _sName;
				simple_score.FBUserId = _userID;
				simple_score.CustomData.pageUrl = _htmlName;
				simple_score.Points = _score;
				Leaderboards.Save(simple_score, App.TableName);
				App.LastSavedScore = _score;
				_submitBtn.visible = false;
			}
		}
		
		public function Destroy():void
		{
			if (_parent) {
				if (_parent.contains(this)) {
					_parent.removeChild(this);
				}
			}
		}
	}

}