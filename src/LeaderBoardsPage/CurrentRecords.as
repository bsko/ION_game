package LeaderBoardsPage 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import Playtomic.PlayerScore;
	/**
	 * ...
	 * @author iam
	 */
	public class CurrentRecords extends Sprite
	{
		public static const SCORE_X:int = 250;
		private var _parent:DisplayObjectContainer;
		private var _scores:Array;
		private var _textformat:TextFormat = new TextFormat(); 
		private var _underlindedtextformat:TextFormat = new TextFormat();
		private var _scoresLayer:Sprite = new Sprite();
		
		public function CurrentRecords() 
		{
			addChild(_scoresLayer);
			_textformat.bold = true;
			_textformat.color = 0xFFFFFF;
			_textformat.size = 18;
			_textformat.underline = false;
			_underlindedtextformat.bold = true;
			_underlindedtextformat.color = 0xFFFFFF;
			_underlindedtextformat.size = 18;
			_underlindedtextformat.underline = true;
		}
		
		public function Init(parent:DisplayObjectContainer, scores:Array, xcoord:int, ycoord:int):void 
		{
			var currentscore:int = (App.universe.score == 0) ? App.Total_SCORE : App.universe.score;
			
			this.x = xcoord;
			this.y = ycoord;
			_parent = parent;
			_scores = scores;
			
			var length:int = scores.length;
			var heroPosition:int = length + 1;
			var _isInFirstFive:Boolean = false;
			var _isHerosScoreDrawn:Boolean = false;
			for (var i:int = 0; i < length; i++) {
				var object:PlayerScore = scores[i];
				if (currentscore > object.Points) {
					heroPosition = i;
					break;
				}
			}
			if (heroPosition > 5) {
				_isInFirstFive = false;
			} else {
			_isInFirstFive = true;
			}
			
			var currentY:int = 0;
			
			if (_isInFirstFive) {
				var clength:int = (length >= 10) ? 10 : length;
				for (i = 0; i < clength; i++) {
					if (i == heroPosition && !_isHerosScoreDrawn) {
						DrawHeroScore(currentscore, i, currentY);
						_isHerosScoreDrawn = true;
						i--;
						currentY += 20;
						continue;
					}
					object = scores[i];
					var pos:int = (_isHerosScoreDrawn) ? (i + 1) : i;
					DrawUserScore(object, pos, currentY);
					currentY += 20;
				}
			} else {
				clength = (length >= 5) ? 5 : length;
				for (i = 0; i < clength; i++) {
					object = scores[i];
					DrawUserScore(object,i, currentY);
					currentY += 20;
				}
				
				currentY += 20;
				
				DrawHeroScore(currentscore, heroPosition, currentY);
			}
			
			_parent.addChild(this);
		}
		
		private function DrawUserScore(object:PlayerScore, i:int, currentY:int):void
		{
			var name:String = object.Name;
			var link:String = object.CustomData.pageUrl;
			if (link == null) { link = "localhost"; }
			var tf:TextField = new TextField();
			tf.text = String(i + 1) + ". " + name;
			tf.setTextFormat(_textformat);
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.mouseEnabled = false;
			var dropshadow:DropShadowFilter = new DropShadowFilter(1, 45, 0x0B3201);
			tf.filters = [dropshadow];
			var sprite:Sprite = new Sprite();
			sprite.x = 0;
			sprite.y = currentY;
			sprite.buttonMode = true;
			sprite.addChild(tf);
			sprite.name = link;
			sprite.addEventListener(MouseEvent.CLICK, onNavigate, false, 0, true);
			sprite.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
			sprite.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
			_scoresLayer.addChild(sprite);
			var tf2:TextField = new TextField();
			tf2.text = String(object.Points);
			tf2.y = currentY;
			tf2.x = SCORE_X;
			tf2.setTextFormat(_textformat);
			tf2.autoSize = TextFieldAutoSize.LEFT;
			tf2.selectable = false;
			tf2.filters = [dropshadow];
			_scoresLayer.addChild(tf2);
		}
		
		private function DrawHeroScore(score:int,i:int, currentY:int):void
		{
			var name:String = InfoReader.Name;
			var link:String = InfoReader.LinkToUserPage;
			if (link == null) { link = "localhost"; }
			var tf:TextField = new TextField();
			tf.text = String(i + 1) + ". " + name;
			tf.setTextFormat(_textformat);
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.mouseEnabled = false;
			var dropshadow:DropShadowFilter = new DropShadowFilter(1, 45, 0x0B3201);
			tf.filters = [dropshadow];
			var sprite:Sprite = new Sprite();
			sprite.x = 0;
			sprite.y = currentY;
			sprite.buttonMode = true;
			sprite.addChild(tf);
			sprite.name = link;
			sprite.addEventListener(MouseEvent.CLICK, onNavigate, false, 0, true);
			sprite.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
			sprite.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
			_scoresLayer.addChild(sprite);
			var tf2:TextField = new TextField();
			tf2.text = String(score);
			tf2.y = currentY;
			tf2.x = SCORE_X;
			tf2.setTextFormat(_textformat);
			tf2.autoSize = TextFieldAutoSize.LEFT;
			tf2.selectable = false;
			tf2.filters = [dropshadow];
			_scoresLayer.addChild(tf2);
		}
		
		private function onOut(e:MouseEvent):void 
		{
			var tf:TextField = (e.target as Sprite).getChildAt(0) as TextField;
			tf.setTextFormat(_textformat);
		}
		
		private function onOver(e:MouseEvent):void 
		{
			var tf:TextField = (e.target as Sprite).getChildAt(0) as TextField;
			tf.setTextFormat(_underlindedtextformat);
		}
		
		private function onNavigate(e:MouseEvent):void 
		{
			navigateToURL(new URLRequest((e.target as Sprite).name));
		}
		
		public function Destroy():void 
		{
			var sprite:Sprite;
			var length:int = _scoresLayer.numChildren;
			for (var i:int = 0; i < length; i++) {
				if (_scoresLayer.getChildAt(i) is Sprite) {
					sprite = _scoresLayer.getChildAt(i) as Sprite;
					sprite.removeEventListener(MouseEvent.CLICK, onNavigate, false);
					sprite.removeEventListener(MouseEvent.MOUSE_OVER, onOver, false);
					sprite.removeEventListener(MouseEvent.MOUSE_OUT, onOut, false);
					_scoresLayer.removeChild(sprite);
					i--;
					length--;
				}
			}
			
			if (_parent) {
				if (_parent.contains(this)) {
					_parent.removeChild(this);
				}
			}
		}
	}
}