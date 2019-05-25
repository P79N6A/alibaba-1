<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <!-- <title>馆藏详情</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/bar-ui.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/css.css"/>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/wechat.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/swipe.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wx/js/wxcommon.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/soundmanager2-nodebug.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/bar-ui.js"></script>
    <script src="${path}/STATIC/js/avalon.js"></script>
    
    <script type="text/javascript">
        var dataForm = avalon.define({
            $id: "dataForm",
            antiqueSpectfication: "",
            antiqueRemark: "",
            antiqueImgUrl: "",
            antiqueName: "",
            antiqueTime: "",
            antiqueId: "",
            venueName: ""
        });

        var antiqueId = '${antiqueId}';
        //朝代搜索
        $(function () {
            $.post("${path}/wechatAntique/antiqueAppDetail.do", {
                antiqueId: antiqueId,
            }, function (data) {
                if (data.status == 0) {
                    dataForm.antiqueSpectfication = data.data[0].antiqueSpectfication;
                    dataForm.antiqueRemark = data.data[0].antiqueRemark;
                    dataForm.antiqueImgUrl = data.data[0].antiqueImgUrl;
                    dataForm.antiqueName = data.data[0].antiqueName;
                    dataForm.antiqueTime = data.data[0].antiqueTime;
                    dataForm.antiqueId = data.data[0].antiqueId;
                    dataForm.venueName = data.data[0].venueName;
                    if (data.data[0].antiqueVoiceUrl.length > 0) {
//                        	$("#venueVoiceDiv").show();
                        document.getElementById("div").style.display="";
                        $("#venueVoice").attr("data-href", data.data[0].antiqueVoiceUrl);
                    }
                }

            }, "json").success(function () {
                formatStyle("antiqueMemo");
            })
        });

        //富文本格式修改
        function formatStyle(id) {
            var $cont = $("#" + id);
            $cont.find("img").each(function () {
            	var $this = $(this);
                var oldHeight = $this.height();
                var oldWidth = $this.width();
                var newHeigth = 690*oldHeight/oldWidth;
                $this.removeAttr("style").attr({"width": "690px"});
                $this.removeAttr("style").attr({"height": newHeigth+"px"});
            });
            $cont.find("p,span").each(function () {
                var $this = $(this);
                $this.css({
                    "font-size": "24px",
                    "color": "#7C7C7C",
                    "line-height": "44px",
                    "font-family": "Microsoft YaHei"
                });
            });
            var str = $cont.html();
            str.replace(/<span>/g, "").replace(/<\/span>/g, "");
            $cont.html(str);
        }

    </script>

</head>
<body class="body">
	<div class="content" ms-controller="dataForm">
		<span style="position:absolute;top: 30px;left: 30px;">
			<a><img src="${path}/STATIC/wechat/image/arrow2.png" width="74px" height="74px" onclick="history.go(-1);"/></a>
		</span>
	    <div class="collect_banner">
	        <img ms-src="{{antiqueImgUrl}}" width="750" height="500">
	    </div>
	    <div class="collect_list">
	        <div class="top_list">
	            <p><strong>{{antiqueName}}</strong></p>
	            <p>时间：{{antiqueTime}}</p>
	            <p>规格：{{antiqueSpectfication}}</p>
	            <p>藏馆：{{venueName}}</p>
	        </div>
	        <div class="bottom_list" id="antiqueMemo">
	            {{antiqueRemark|html}}
	        </div>
	        <div class="related_video venue_audio" id="div"style="display: none" >
	            <h1>语音导览</h1>
	            <div class="sm2-bar-ui compact full-width">
	                <div class="bd sm2-main-controls">
	                    <div class="sm2-inline-element sm2-inline-status">
	                        <div class="sm2-playlist">
	                            <div class="sm2-playlist-target">
	                                <ul class="sm2-playlist-bd">
	                                    <li id="venueVoice" data-href="">
	                                    </li>
	                                </ul>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
	</div>
</body>
</html>