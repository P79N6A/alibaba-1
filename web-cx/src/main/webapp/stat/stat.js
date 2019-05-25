(function(global)
{
    //modify:2016-4-28
    //version:1.5
    //author:fishbird
    var se = new Array();
    var se_kw = new Array();
    se[0] = 'google';   se_kw[0] = 'q';
    se[1] = 'baidu';    se_kw[1] = 'wd';
    se[2] = 'baidu';    se_kw[2] = 'word';
    se[3] = 'soso';      se_kw[3] = 'w';
    se[4] = 'sogou';     se_kw[4] = 'query';
    se[5] = 'bing';      se_kw[5] = 'q';
    se[6] = 'yahoo';     se_kw[6] = 'p';
    se[7] = 'qihoo';     se_kw[7] = 'kw';
    se[8] = 'so';     se_kw[8] = 'q';
    se[9] = '360';    se_kw[9] = 'q';
    var doc = document;
    var up = new Array();
    var upv = new Array();
    var statHost = 'http://www.wenhuayun.cn/stat/';
    var domain = 'wenhuayun.cn';
    var cookiename_guid = "WHY_STAT_GUID";
    var p;
    var brower = new Array();
    var GUID = getGUID();
    var allowClickCount = false;
    var site = '';
    var mapno = '';
    var stype = '';
    var skey1 = '';
    var skey2 = '';

    pv('');
    function praseReferUrlEx()
    {
        var ref = getReferrer();
        var ru, i;
        if((i = ref.indexOf("://")) < 0)
            return "";
        parseUrlPara(ref);
        var ru = ref.substring(i + 3, ref.length);
        if ((i = ru.indexOf("/")) > - 1)
        {
            ru = ru.substring(0, i);
        }
        var url = '';
        for(var i = 0; i < se.length; i ++ )
        {
            if(ru.indexOf("."+se[i]+".") > - 1)
            {
                for(var j = 0; j < up.length; j ++ )
                {
                    if(up[j] == se_kw[i])
                    {
                        //upv[j] = encodeURIComponent(encodeURIComponent(upv[j]));
                        url = statHost + 'stat_ref.jsp?' + p + '&se=' + se[i] + '&kw=' + upv[j] + '&ref=' + ref +"&r="+Math.random();;
                        SendRequest(url);
                        return;
                    }
                }
            }

        }
    }

    function praseReferUrl()
    {
        return;
    }

    function parsePosition()
    {
        var u = location.href;
        var p = u.indexOf('?g_f=');
        var t = 5;
        if(p < 0)
        {
            p = u.indexOf('&g_f=');
            if(p<0)
            {
                p = u.indexOf('?g_from=');
                t=8;
            }
            if(p<0)
            {
                p = u.indexOf('&g_from=');
                t=8;
            }

        }
        if(p > 0)
        {
            u = u.substring(p + t);
            p = u.indexOf('&');
            if(p >= 0)
            {//推广代码在中间忽略掉
                u ="";
            }
            p = u.indexOf('#');
            if(p >= 0)
            {
                u = u.substring(0, p);
            }
        }
        else
        {
            u = "";
        }

        return u;
    }

    function parseUrlPara(u)
    {
        var i;
        if((i = u.indexOf("?")) == - 1)
            return "";
        var pi = 0, s;
        var p = u.substring(i + 1, u.length);
        while(p.length > 0)
        {
            if(p.indexOf("~") == - 1)
            {
                up[pi] = p.substring(0, p.indexOf("="));
                upv[pi] = p.substring(p.indexOf("=") + 1, p.length);
                break;
            }
            s = p.substring(0, p.indexOf("~"));
            up[pi] = s.substring(0, s.indexOf("="));
            upv[pi] = s.substring(s.indexOf("=") + 1, s.length);
            p = p.substring(p.indexOf("~") + 1, p.length);
            pi ++ ;
        }


    }

    function pv(para)
    {
        var p = para;
        splitPara(p);
        var platform = getPlatform();
        var ref = getReferrer();
        var stype = getFileName();
        var key1 = getkeyParam();
        var u = handleLink(location.href);
        if(p.length > 0)
            p = p+"&";
        var url = statHost + "stat.jsp?"+p+"platform="+platform+"&stype="+stype+"&skey1="+key1+"&userid=" + getUserId() + "&sfrom=" + parsePosition() + "&GUID=" + GUID + "&ostype=" + getOS() + "&mobile=" + getCookiesByName("usermobile") + "&localurl="+u+"&ref=" + ref+"&r="+Math.random();;
        //SendRequest(url);
        SendRequestByImg(url);
        //praseReferUrlEx();

    }

    function getPlatform()
    {
        var u = location.href;
        if(u.indexOf("://m.wenhuayun.cn/") > 0)
        {
            return "wap";
        }
        if(u.indexOf("://www.wenhuayun.cn/") > 0)
        {
            return "pc";
        }
        if(u.indexOf("://ct.wenhuayun.cn/") > 0)
        {
          return "pcct";
        }

        return "pc";
    }



    function getkeyParam()
    {
        var u = location.href;
        var regx=/\w+Id\=\w+/g;
        var rs=u.match(regx);
        if(rs == null)
        {
            return '';
        }
        var len = rs.length;
        if(len >= 0)
        {
            var f = rs[len - 1];
            if(f.indexOf("userId") == 0)
                f = rs[0];
            var idx = f.indexOf("=");
            if(idx >= 1)
            {

                return f.substring(idx + 1);
            }
        }
        return '';
    }


    function getFileName()
    {
        var u = location.href;
        var regx=/\/\w+\.\w+/g;
        var rs=u.match(regx);
        if(rs == null)
        {
            return '';
        }
        var len = rs.length;
        if(len >= 2)
        {
            var f = rs[1];
            var idx = f.indexOf(".");
            if(idx >= 1)
            {

                return f.substring(1,idx);
            }
        }
        return '';
    }



    function splitPara(para)
    {
        var p = para;
        var ci = 5;
        var type = '';
        while(p.indexOf("&") > 0 && ci > 0)
        {
            ci--;
            var s = p.substring(0, p.indexOf("&"));

            var n = s.substring(0, s.indexOf("="));
            var v = s.substring(s.indexOf("=") + 1, s.length);
            if(n == 'site')
                site = v;
            else if(n=='smapno')
                mapno=v;
            else if(n=='skey1')
                skey1=v;
            else if(n=='skey1')
                skey2=v;
            else if(n == 'stype')
                stype = v;
            else if(n == 'type')
                type = v;
            p = p.substring(p.indexOf("&") + 1, p.length);
        }
        if(site != '' && type != '')
            stype = type+'_'+stype;

    }

    function pve(para)
    {
        pv(para);
        //p = para;
        //var url = statHost + "stat.jsp?" + para + "&GUID=" + GUID + "&userid=" + getUserId() + "&ref=" + getReferrer() +"&r="+Math.random();;
        //SendRequestByImg(url);
    }


    function SendRequest(url)
    {
        document.write("<script src='"+url+"'></script>");
        //document.write("<img border=0 width=1 height=1 src='"+url+"'/>");

    }

    function SendRequestByImg(url)
    {
        var i = new Image(1, 1);
        i.src = url;
        i.onload = function()
        {
            rv();
        }
        ;
    }

    function rv()
    {
        return;
    }

    function getCookiesByName(name)
    {
        var arrStr = doc.cookie.split(";");
        var tmp;
        for(var i = 0; i < arrStr.length; i ++ )
        {
            arrStr[i] = arrStr[i].replace(" ", "")
            tmp = arrStr[i].split("=");
            if(tmp[0] == name)
            {
                return tmp[1];
            }
        }
        return '';
    }

    function getUserId()
    {

        var uid = getCookiesByName('userid');
        if (uid.length > 0)
        {
            try
            {
                return uid - 13698;
            }
            catch(e)
            {
                return '';
            }
        }
        return '';

    }

    function getGUID()
    {
        var gid = getCookiesByName(cookiename_guid);
        if(gid == "" ||  gid.length < 3)
        {
            //gid = getDateStr()+''+generateMixed(16);
            //gid = getDateStr()+''+Math.round(Math.random() * 99999999);
            //gid += '' + Math.round(Math.random() * 99999999);
            gid = generateMixed();
            setCookies(cookiename_guid, gid);
            //firstVistor(gid);
        }
        return gid;
    }

    function getSiteName()
    {
        var u = location.href;
        if(u.indexOf("http://") >=0)
        {
            u = u.substring(7,u.length);
        }
        return   u.substring(0,u.indexOf("."));

    }

    function firstVistor(gid)
    {
        // 第一次访问，记录客户端信息
        BrowserInfo();
        var url = statHost + "firstvistor.jsp?GUID=" + gid + "&";
        url += "bType=" +  brower[0]  + "&";
        url += "bVersion=" +  brower[1] + "&";
        url += "bJava=" + brower[2] + "&";
        url += "bFlash=" + brower[3] + "&";
        url += "bOS=" + brower[4] + "&";
        url += "bScr=" + brower[5] + "&";
        url += "bColor=" + brower[6] + "&";
        url += "bHl=" + brower[7] + "&";
        //url += "bPlugin=" + brower[8]+ "&";
        //url += "sou=" + getSiteName()+ "&";
        url += "page=" +  location.href+ "&";
        url += "cookieEnable=" + brower[9]+ "&";
        //url += "prepage=" + doc.referrer.replace(/\&/g, "~");
        SendRequestByImg(url);


    }


    function setCookies(strNam, strValue)
    {
        var expiration = new Date((new Date()).getTime() + 31536000000).toGMTString();
        // 365d * 24h * 60m * 60s * 1000ms
        document.cookie = strNam + "=" + escape(strValue) + ";domain="+domain+";expires=" + expiration + ";path=/";
        //

    }


    function BrowserInfo()
    {
        // 客户端信息
        brower[0] = navigator.appName;
        brower[1] = navigator.appVersion;
        brower[2] = navigator.javaEnabled() ? 1 : - 1;
        brower[3] = getFlash();
        brower[4] = navigator.userAgent;
        if (self.screen)
        {
            sr = screen.width + "x" + screen.height;
            sc = screen.colorDepth + "-bit";
        }
        else if (self.java)
        {
            var j = java.awt.Toolkit.getDefaultToolkit();
            var s = j.getScreenSize();
            sr = s.width + "x" + s.height;
        }
        brower[5] = sr;
        brower[6] = sc;
        brower[7] = navigator.language;
        brower[8] = '';//getPlugin();
        brower[9] =  navigator.cookieEnabled ? 1 : - 1;
    }


    // --------------------------- 得操作系统 ---------------------------
    function getOS()
    {

        var ua = navigator.userAgent.toLowerCase();
        var keywords,OsType;
        keywords = ["windows phone","symbian","blackberry","iphone","iph os","ipod", "ipad","android","windows nt","macintosh","ubuntu","linux","ios","windows"];
        OsType =   ["Windows Phone","Symbian","Blackberry","iPhone","iPhone","iPod", "iPad","Android","Windows",   "Macintosh","Ubuntu","Linux","IOS","Windows"];
        for (var i=0;i<keywords.length;i++)
        {
            var item = keywords[i];
            if (ua.indexOf(item) > -1 )
            {
                if(OsType[i] == "Linux" && ua.match(/applewebkit.*mobile.*/))
                {

                    return "Android";
                }
                else
                {
                    return OsType[i];
                }

            }
        }
        return ua.substring(0,50);
    }

    // 获得插件
    function getPlugin()
    {
        var plugin = "";
        var ua = navigator.userAgent.split(";");
        if(ua.length < 4)
            return "";
        for(var i = 4; i < ua.length; i ++ )
        {
            plugin += ua[i] + ",";
        }
        return plugin.substring(0, plugin.length - 2);
    }

    function getFlash()
    {
        var f = "-1", n = navigator;
        if (n.plugins && n.plugins.length)
        {
            for (var ii = 0; ii < n.plugins.length; ii ++ )
            {
                if (n.plugins[ii].name.indexOf('Shockwave Flash') != - 1)
                {
                    f = n.plugins[ii].description.split('Shockwave Flash ')[1];
                    break;
                }
            }
        }
        else if (window.ActiveXObject)
        {
            for (var ii = 10; ii >= 2; ii -- )
            {
                try
                {
                    var fl = eval("new ActiveXObject('ShockwaveFlash.ShockwaveFlash."+ii+"');");
                    if (fl)
                    {
                        f = ii + '.0';
                        break;

                    }
                }
                catch(e)
                {
                }
            }
        }
        if(f == "-1")
            return f;
        else
            return f.substring(0, f.indexOf(".") + 2);
    }



    function StatisticsByClick(site,stype,pos,hele,mapno,skey1,skey2)
    {
        if (typeof(skey1) == "undefined")
            skey1 = '';
        if (typeof(skey2) == "undefined")
            skey2 = '';
        var lhref = hele.href;
        if (typeof(lhref) == "undefined")
        {
            //lhref = '';
            //if(hele.indexOf("http://") >=0 )
            lhref = hele;
        }


        var ltitle = getLinkContent(hele);
        var u = handleLink(location.href);
        lhref = handleLink(lhref);
        var ref = doc.referrer;
        //var url = statHost + "stat.jsp?site=operation&mapno="+mapno+"&skey1="+skey1+"&skey2="+skey2+"&rsite="+site+"&stype="+stype+"&pos="+pos+"&ltitle="+ltitle+"&url="+lhref.replace(/\&/g, "~")+"&userid=" + getUserId() + "&sfrom=" + parsePosition() + "&GUID=" + GUID + "&mobile=" + getCookiesByName("usermobile") + "&ref=" + ref.replace(/\&/g, "~")+"&localurl="+u;
        var url = statHost + "stat.jsp?site=operation&mapno="+mapno+"&skey1="+skey1+"&skey2="+skey2+"&rsite="+site+"&stype="+stype+"&pos="+pos+"&ltitle="+ltitle+"&url="+lhref+"&userid=" + getUserId() + "&sfrom=" + parsePosition() + "&GUID=" + GUID + "&ostype=" + getOS() + "&mobile=" + getCookiesByName("usermobile") + "&ref=&localurl="+u+"&r="+Math.random();
        SendRequestByImg(url);

    }

    function getLinkContent(hele)
    {//获取a元素的内容

        var ltitle = hele.innerHTML;
        if (typeof(ltitle) == "undefined")
            ltitle = '';
        ltitle =  ltitle.toLowerCase();
        if(ltitle.indexOf("<img") >= 0)
            ltitle = ltitle.replace(/(.*)src=['"]*([^'"]*)['"]*(.*)/g, "$2");

        return handleLink(ltitle);


    }


    function getReferrer()
    {
        var referrer = document.referrer;
        if (!referrer)
        {
            try
            {
                if (window.opener)
                {
                    // IE下如果跨域则抛出权限异常
                    // Safari和Chrome下window.opener.location没有任何属性
                    referrer = window.opener.location.href;
                }
            }
            catch (e) {}
        }
        return  handleLink(referrer);
    }

    function setAllowClickStatBak()
    {

    }

    function setAllowClickStat()
    {//监听页面上的a标签
        if (typeof window.addEventListener != 'undefined')
        {
            document.addEventListener("click",function (event) { clickEvent(event);},false);
        }
        else
        {
            document.attachEvent("onclick",function (event) { clickEvent(event);});
        }
    }

    function clickEvent(e)
    {
        var targ;
        if (!e) var e = window.event;
        targ =  e.target ||  e.srcElement;
        /*
         if (e.target)
         targ = e.target;
         else if (e.srcElement)
         targ = e.srcElement;
         */
        if (targ.nodeType == 3) // defeat Safari bug
            targ = targ.parentNode;

        if(targ = isAElement(targ))
        {
            var ll;
            try
            {
                ll = decodeURI(targ.href);
            }
            catch (e)
            {
                ll = targ.href;
            }
            var tname = targ.tagName;
            var title = getLinkContent(targ);
            var para = 'site='+site+'&smapno='+mapno+'&stype='+stype+'&skey1='+skey1+'&skey2='+skey2+'&title='+title+'&eleidx=&link='+handleLink(encodeURI(ll))+'&localurl='+handleLink(location.href);
            var url = statHost + "clickcount.jsp?" + para + "&userid=" + getUserId() + "&sfrom=" + parsePosition() + "&GUID=" + GUID + "&ostype=" + getOS() + "&mobile=" + getCookiesByName("usermobile") + "&ref=" + getReferrer() +"&r="+Math.random();;
            SendRequestByImg(url);

        }
    }


    function isAElement(ele)
    {
        if(ele.tagName.toLowerCase() == 'a')
            return ele;
        if(ele.parentNode.tagName.toLowerCase() == 'a')
            return ele.parentNode;
        return null;
    }


    function guid()
    {
        var s = [];
        var hexDigits = "0123456789abcdef";
        for (var i = 0; i < 36; i++) {
            s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
        }
        s[14] = "4";  // bits 12-15 of the time_hi_and_version field to 0010
        s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1);  // bits 6-7 of the clock_seq_hi_and_reserved to 01
        s[8] = s[13] = s[18] = s[23] = "-";

        var uuid = s.join("");
        return uuid;
    }


    function generateMixed()
    {
        return guid();
//      var chars = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
//
//       var res = "";
//       for(var i = 0; i < n ; i ++)
//       {
//          var id = Math.ceil(Math.random()*35);
//          res += chars[id];
//       }
//       return res;
    }





    function handleLink(link)
    {
        if(link.length == 0)
            return '';
        return link.replace(/\&/g, "~").replace(/\#/g, "!!");
    }

    global.pv = pv;
    global.praseReferUrl = praseReferUrl;
    global.StatisticsByClick = StatisticsByClick;
    global.pve = pve;
    global.setAllowClickStat = setAllowClickStat;



}(window));