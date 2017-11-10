var com_genesismedia_utils_DOCUMENT_INFO = function() {
        var sameDomain = (function() {
            try {
                if (top.location == undefined || top.location.href == undefined) {
                    return false;
                } else {
                    return true;
                };
            } catch (e) {
                return false;
            }
            return true;
        })();

        var winNode = window;
        if (sameDomain === true){
          winNode = top;
        }else{
          while (winNode.parent && winNode.parent != winNode) {
              var parentNode = winNode.parent;
              try {
                  var url = parentNode.location.href;
                  if (url !== ""){
                    winNode = parentNode;
                  }else{
                    break;
                  }
              } catch (e) {
                  break;
              }
          }
        }

        var winHref = winNode.location.href;
        var winHost = winNode.location.host;
        if (!sameDomain && !!winNode.document.referrer){
          var l = document.createElement("a");
          l.href = winHref = winNode.document.referrer;

          if (l.host && l.host.length > 0) {
              winHost = l.host;
          }
        }
        return {
        	//URL in browser window
            "url": winNode.location.href,
            //same as URL
            "href": winHref,
            //referrer to URL
            "referrer": winNode.document.referrer,
            //title of browser page
            "title": winNode.document.title,
            //host(domain) of browser page
            "host": winHost
        }
    }();