package LeaderBoardsPage 
{
	import flash.accessibility.AccessibilityProperties;
	import flash.display.ActionScriptVersion;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import Playtomic.Leaderboards;
	import Playtomic.PlayerScore;
	/**
	 * ...
	 * @author iam
	 */
	public class ResultsList extends Sprite
	{
		public static const WIDTH:int = 300;
		public static const HEIGHT:int = 250;
		public static const SCORE_X:int = 250;
		
		private var _mask:Sprite;
		private var _scoresLayer:Sprite = new Sprite();
		private var _parent:DisplayObjectContainer;
		private var _scores:Array;
		private var _textformat:TextFormat = new TextFormat(); 
		private var _underlindedtextformat:TextFormat = new TextFormat();
		
		public function ResultsList() 
		{
			_mask = new Sprite();
			_mask.graphics.beginFill(0x000000, 1);
			_mask.graphics.drawRect(0, 0, WIDTH, HEIGHT);
			_mask.graphics.endFill();
			
			addChild(_scoresLayer);
			_scoresLayer.mask = _mask;
			
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
			_mask.x = xcoord;
			_mask.y = ycoord; 
			this.x = xcoord;
			this.y = ycoord;
			
			_parent = parent;
			_scores = scores;
			
			var length:int = scores.length;
			var currentY:int = 0;
			
			for (var i:int = 0; i < length; i++) {
				var object:PlayerScore = scores[i];
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
				
				currentY += 20;
			}
			
			_parent.addChild(this);
			
			MouseWheel.capture();
			App.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
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
		
		private function onMouseWheel(e:MouseEvent):void 
		{
			var delta:int = e.delta *= 2;
			
			if (delta > 0) {
				if (_scoresLayer.y > -1 * delta) {
					_scoresLayer.y = 0;
				} else {
					_scoresLayer.y += e.delta;
				}
			} else if (e.delta < 0) {
				if (_scoresLayer.height < _mask.height) {
					_scoresLayer.y = 0;
				} else if ((_scoresLayer.y + delta) < (_mask.height - _scoresLayer.height)) {
					_scoresLayer.y = _mask.height - _scoresLayer.height;
				} else {
					_scoresLayer.y += e.delta;
				}
			}
		}
		
		public function Destroy():void 
		{
			MouseWheel.release();
			App.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false);
			
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