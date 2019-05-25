<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.sun3d.why.util.PropertiesReadUtils" %>
<%
	String path = request.getContextPath();
	request.setAttribute("path", path);
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	String staticurl = PropertiesReadUtils.getInstance().getPropValueByKey("staticServerUrl","http://127.0.0.1:8080/") ;
%>
<input type="hidden" name="staticImgServerUrl" id="staticImgServerUrl" value="<%=staticurl%>">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta http-equiv="content-type" content="text/html; charset=UTF-8" >
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<link rel="shortcut icon" href="${path}/STATIC/image/favicon.ico" type="image/x-icon" mce_href="${path}/STATIC/image/favicon.ico">
<link href="${path}/STATIC/image/favicon.ico" rel="icon" type="image/x-icon" mce_href="${path}/STATIC/image/favicon.ico">
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/reset-index.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/ui-dialog.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-user.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/index_new.css"/>
<!--[if lte IE 8]>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-ie.css"/>
<![endif]-->
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/frontpage.css">
<script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/jquery.SuperSlide.2.1.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/culture.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/page.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/location.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/frontBp/culture.js"></script>

<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/frontpage.css">
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/bpNormalize.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/bpCulture.css"/>
<%--注册时临时时间控件--%>
<script type="text/javascript" src="${path}/STATIC/js/DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/jquery.alerts.js"></script>
<!--移动端版本兼容 -->
<script type="text/javascript">
	var phoneWidth =  parseInt(window.screen.width);
	var phoneScale = phoneWidth/1200;
	var ua = navigator.userAgent;            //浏览器类型
	if (/Android (\d+\.\d+)/.test(ua)){      //判断是否是安卓系统
		var version = parseFloat(RegExp.$1); //安卓系统的版本号
		if(version>2.3){
			document.write('<meta name="viewport" content="width=1200, minimum-scale = '+phoneScale+', maximum-scale = '+(phoneScale+1)+', target-densitydpi=device-dpi">');
		}else{
			document.write('<meta name="viewport" content="width=1200, target-densitydpi=device-dpi">');
		}
	} else {
		document.write('<meta name="viewport" content="width=1200, user-scalable=yes, target-densitydpi=device-dpi">');
	}
    //图片撑满居中
    (function (a) {
        var b = {"boxWidth": 0, "boxHeight": 0};
        a.fn.extend({
            "picFullCentered": function (c) {
                var d = a.extend({}, b, c);
                this.each(function () {
                    if (d.boxWidth && d.boxHeight) {
                        var g = a(this);
                        var f = d.boxWidth / d.boxHeight;
                        var e = new Image();
                        e.onload = function () {
                            var i = e.width;
                            var h = e.height;
                            if (i / h >= f) {
                                var l = (d.boxHeight * i) / h;
                                var k = (l - d.boxWidth) / 2 * (-1);
                                g.css({"width": "auto", "height": "100%", "position": "absolute", "top": "0", "left": k})
                            } else {
                                var j = (d.boxWidth * h) / i;
                                var m = (j - d.boxHeight) / 2 * (-1);
                                g.css({"width": "100%", "height": "auto", "position": "absolute", "top": m, "left": "0"})
                            }
                        };
                        e.src = g.attr("src")
                    }
                });
                return this
            }
        })
    })(jQuery);
</script>
<!--移动端版本兼容 end -->
