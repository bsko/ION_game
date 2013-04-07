package LeaderBoardsPage 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.engine.JustificationStyle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author iam
	 */
	public class HighscoresControll 
	{
		public static const MODE_ALL_RECS:int = 301;
		public static const MODE_CURRENT_REC:int = 302;
		
		public static var MC:MovieClip;
		public static var AllRecsMC:Sprite;
		public static var CurRecMC:Sprite;
		public static var MODE:int = MODE_ALL_RECS;
		
		private static var All_Recs_Btn:MovieClip;
		private static var Cur_Recs_Btn:MovieClip;
		
		public static function initParentMovieClip(mc:MovieClip):void
		{
			MC = mc;
			
			All_Recs_Btn = MC.allrecs;
			All_Recs_Btn.visible = false;
			All_Recs_Btn.buttonMode = true;
			Cur_Recs_Btn = MC.currec;
			Cur_Recs_Btn.visible = false;
			Cur_Recs_Btn.buttonMode = true;
		}
		
		public static function init(allRecsMC:Sprite, curRecMC:Sprite):void
		{
			MODE = MODE_CURRENT_REC;
			
			MC.gotoAndStop(2);
			
			AllRecsMC = allRecsMC;
			CurRecMC = curRecMC;
			AllRecsMC.visible = false;
			CurRecMC.visible = true;
			
			start();
		}
		
		public static function start():void
		{
			All_Recs_Btn.visible = true;
			All_Recs_Btn.buttonMode = true;
			All_Recs_Btn.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
			All_Recs_Btn.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
			All_Recs_Btn.addEventListener(MouseEvent.CLICK, onAllRecs, false, 0, true);
			Cur_Recs_Btn.visible = true;
			Cur_Recs_Btn.buttonMode = true;
			Cur_Recs_Btn.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
			Cur_Recs_Btn.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
			Cur_Recs_Btn.addEventListener(MouseEvent.CLICK, onCurRec, false, 0, true);
		}
		
		static private function onCurRec(e:MouseEvent):void 
		{
			MODE = MODE_ALL_RECS;
			AllRecsMC.visible = false;
			CurRecMC.visible = true;
		}
		
		static private function onAllRecs(e:MouseEvent):void 
		{
			MODE = MODE_ALL_RECS;
			CurRecMC.visible = false;
			AllRecsMC.visible = true;
		}
		
		static private function onOut(e:MouseEvent):void 
		{
			if (e.currentTarget is MovieClip) {
				var mc:MovieClip = e.currentTarget as MovieClip;
				if (mc.getChildAt(0) is TextField) {
					var tf:TextField = mc.getChildAt(0) as TextField;
					var tformat:TextFormat = tf.getTextFormat();
					tformat.underline = false;
					tf.setTextFormat(tformat);
				}
			}
		}
		
		static private function onOver(e:MouseEvent):void 
		{
			if (e.currentTarget is MovieClip) {
				var mc:MovieClip = e.currentTarget as MovieClip;
				if (mc.getChildAt(0) is TextField) {
					var tf:TextField = mc.getChildAt(0) as TextField;
					var tformat:TextFormat = tf.getTextFormat();
					tformat.underline = true;
					tf.setTextFormat(tformat);
				}
			}
		}
		
		public static function Destroy():void
		{
			
		}
	}

}