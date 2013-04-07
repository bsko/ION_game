package  
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	/**
	 * ...
	 * @author iam
	 */
	public class InfoReader 
	{
		public static var Api_ID:Number;
		public static var Viewer_id:int;
		public static var Secret:String;
		public static var Sid:String;
		public static var Api_url:String;
		public static var url_request:URLRequest;
		public static var url_loader:URLLoader;
		
		public static var BirthdayDate:String = "";
		public static var Avatar:String = "";
		public static var Name:String = "";
		public static var LastName:String = "";
		public static var UserID:int = 0;
		public static var LinkToUserPage:String = "";
		
		public static function Load(api_id:Number, viewer_id:int, secret:String, sid:String, api_url:String):void
		{
			if ((viewer_id == 0) || (secret == null) || (sid == null) || (api_url == null)) {
				App.root.DataReceived("MyName", "MyLastName");
				return;
			}
			
			Api_ID = api_id;
			Viewer_id = viewer_id;
			Secret = secret;
			Sid = sid;
			Api_url = api_url;
			
			getProfile(viewer_id);
		}
		
		static private function getProfile(viewer_id:int):void 
		{
			var request_params: Object = new Object();
            request_params.api_id = Api_ID;
            request_params.method = 'getProfiles';
            request_params.format = 'XML';
            request_params.v = '3.0';
            request_params.fields = 'bdate,photo_big';
            request_params.uids = Viewer_id;
			
            var variables:URLVariables = new URLVariables();
            
            for (var j:String in request_params)
            {
                variables[j] = request_params[j];
            }
			
            variables['sid'] = Sid;
            variables['sig'] = generate_signature(request_params);
            url_request = new URLRequest(Api_url);
            url_request.method = URLRequestMethod.POST;
            url_request.data = variables;
			
            url_loader = new URLLoader();
            url_loader.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
            url_loader.load(url_request);
        }
       
        private static function onComplete(event:Event):void
        {
			url_loader.removeEventListener(Event.COMPLETE, onComplete, false);
			
            var response:XML = new XML(url_loader.data);
			
            BirthdayDate = response..bdate;
			Name = response..first_name;
			LastName = response..last_name;
            Avatar = response..photo_big;
			UserID = response..uid;
			LinkToUserPage = "http://vkontakte.ru/id" + UserID;
			
			App.root.DataReceived(Name, LastName);
        }
		
        private static function generate_signature(request_params:Object):String
        {
            var signature:String = '';
            var sorted_array: Array = new Array();
            for (var key:String in request_params)
            {
                sorted_array.push(key + "=" + request_params[key]);
            }
            sorted_array.sort();
			
            for (key in sorted_array)
            {
                signature +=  sorted_array[key];
            }
            signature = Viewer_id + signature + Secret;
			
            return MD4.encrypt(signature);
		}
		
	}

}