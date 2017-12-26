package com.genesismedia.page {
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import com.adobe.serialization.json.JSON;

	public class Page {
		private static const DOMAIN_CHECK:String = 'function(){' +
			'try {' +
			'if (top.location == undefined || top.location.href == undefined) {' +
			'return false;' +
			'} else {' +
			'return true;' +
			'};' +
			'} catch(e) {' +
			'return false;' +
			'}' +
			'return true;' +
			'}';

			private static const URL_CHECK:String = 'function(){' +
				'var sameDomain = (function() {' +
				'try {' +
				'if (top.location == undefined || top.location.href == undefined) {' +
				'return false;' +
				'} else {' +
				'return true;' +
				'};' +
				'} catch (e) {' +
				'return false;' +
				'}' +
				'return true;' +
				'})();' +

				'var winNode = window;' +
				'if (sameDomain === true){' +
				'winNode = top;' +
				'}else{' +
				'while (winNode.parent && winNode.parent != winNode) {' +
				'var parentNode = winNode.parent;' +
				'try {' +
				'var url = parentNode.location.href;' +
				'winNode = parentNode;' +
				'} catch (e) {' +
				'break;' +
				'}' +
				'}' +
				'}' +

				'var winHref = winNode.location.href;' +
				'var winHost = winNode.location.host;' +
				'if (!sameDomain && !!winNode.document.referrer){' +
				'var l = document.createElement("a");' +
				'l.href = winHref = winNode.document.referrer;' +
				'if (l.host && l.host.length > 0) {' +
				'winHost = l.host;' +
				'}' +
				'}' +

				'return {' +
				'"url": winHref,' +
				'"href": winNode.location.href,' +
				'"referrer": winNode.document.referrer,' +
				'"title": winNode.document.title,' +
				'"host": winHost' +
				'}' +
				'}';

		private static const DOMAIN_HOST:String = 'function(href){' +
			'var l = document.createElement("a");' +
			'l.href = href;' +
			'return l.host;' +
			'}';

		private var _url:String;
		private var _title:String;
		private var _referrer:String;
		private var _topReferrer:String;
		private var _host:String;
		private var _protocol:String = "http:";
		private var _sameDomain:Boolean = true;
		private var _userAgent:Object = new UserAgent().detect();

		public function Page() {
			if (ExternalInterface.available) {
				try {
					var urlObject:Object = ExternalInterface.call(URL_CHECK);
					_url = urlObject.url;
					_referrer = urlObject.referrer;
					_title = urlObject.title;
					_host = urlObject.host;

					Security.allowDomain(_url);
					_protocol = ExternalInterface.call("function() { return location.protocol; }");
					_sameDomain = ExternalInterface.call(DOMAIN_CHECK);
				} catch (e:Error) {
				}
			}

			if (_sameDomain === false && _referrer && _referrer.length > 0) {
				_url = _referrer;
				Security.allowDomain(_url);

				var refHost:String = getUrlHost(_referrer);

				if (refHost && refHost.length > 0){
					_host = refHost;
				}
			}

			if (_sameDomain){
				_topReferrer = ExternalInterface.call("function() { return top.document.referrer; }");
			}
		}

		private function getUrlHost(url):String{
			if (ExternalInterface.available) {
				try {
					return ExternalInterface.call(DOMAIN_HOST, url);
				} catch (e:Error) {
				}
			}

			return "";
		}

		public function get title():String {
			return _title;
		}

		public function get url():String {
			return _url;
		}

		public function get referrer():String {
			return _referrer;
		}

		public function get topReferrer():String {
			return _topReferrer;
		}

		public function get host():String {
			return _host;
		}

		public function get protocol():String
		{
			return _protocol;
		}

		public function get sameDomain():Boolean
		{
			return _sameDomain;
		}

		public function get userAgent():Object
		{
			return _userAgent;
		}
	}
}
