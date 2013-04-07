package  
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	/**
	 * ...
	 * @author iam
	 */
	public class PostMessage 
	{
		private static var url_loader:URLLoader;
		private static var url_request:URLRequest;
		
		
		public static function post():void
		{
			var request_params: Object = new Object();
            request_params.api_id = InfoReader.Api_ID;
            request_params.method = 'wall.post';
			request_params.format = 'XML';
            request_params.v = '3.0';
            request_params.owner_id = InfoReader.UserID;
            request_params.message = "ПРЕВЕД МЕДВЕД ЧО";
			
            var variables:URLVariables = new URLVariables();
            
            for (var j:String in request_params)
            {
                variables[j] = request_params[j];
            }
			
            variables['sid'] = InfoReader.Sid;
            variables['sig'] = generate_signature(request_params);
            url_request = new URLRequest(InfoReader.Api_url);
            url_request.method = URLRequestMethod.POST;
            url_request.data = variables;
			
            url_loader = new URLLoader();
            url_loader.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
            url_loader.load(url_request);
		}
		
		static private function onComplete(e:Event):void 
		{
			var response:XML = new XML(url_loader.data);
			trace(response);
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
            signature = InfoReader.Viewer_id + signature + InfoReader.Secret;
			
            return MD4.encrypt(signature);
		}
	}

}