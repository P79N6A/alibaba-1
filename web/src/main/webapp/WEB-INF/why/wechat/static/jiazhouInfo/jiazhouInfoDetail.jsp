<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·古韵嘉州</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	<script>	
	var jiazhouInfoId = '${jiazhouInfoId}';
	//分享是否隐藏
    if(window.injs){
    	//分享文案
    	appShareTitle = '${jiazhouInfo.shareTitle}';
    	appShareDesc = '${jiazhouInfo.shareSummary}';
    	appShareImgUrl = '${jiazhouInfo.shareIconUrl}';
    	
		injs.setAppShareButtonStatus(true);
	}
	
	//判断是否是微信浏览器打开
	if (is_weixin()) {
		//通过config接口注入权限验证配置
		wx.config({
			debug: false,
			appId: '${sign.appId}',
			timestamp: '${sign.timestamp}',
			nonceStr: '${sign.nonceStr}',
			signature: '${sign.signature}',
			jsApiList: ['previewImage','onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
		});
		wx.ready(function () {
			wx.onMenuShareAppMessage({
				title: '${jiazhouInfo.shareTitle}',
				desc: '${jiazhouInfo.shareSummary}',
				imgUrl: '${jiazhouInfo.shareIconUrl}'
			});
			wx.onMenuShareTimeline({
				title: "${jiazhouInfo.shareTitle}",
				desc: '${jiazhouInfo.shareSummary}',
				imgUrl: '${jiazhouInfo.shareIconUrl}'
			});
			wx.onMenuShareQQ({
				title: "${jiazhouInfo.shareTitle}",
				desc: '${jiazhouInfo.shareSummary}',
				imgUrl: '${jiazhouInfo.shareIconUrl}'
			});
			wx.onMenuShareWeibo({
				title: "${jiazhouInfo.shareTitle}",
				desc: '${jiazhouInfo.shareSummary}',
				imgUrl: '${jiazhouInfo.shareIconUrl}'
			});
			wx.onMenuShareQZone({
				title: "${jiazhouInfo.shareTitle}",
				desc: '${jiazhouInfo.shareSummary}',
				imgUrl: '${jiazhouInfo.shareIconUrl}'
			});
		});
	}
	
		$(function(){			
			$.post("${path}/wechatStatic/getCcpJiazhouInfoDetail.do",{jiazhouInfoId:jiazhouInfoId,userId:userId}, function (data) {	
				 if (data.status == 200) {					 
					 var time = data.data.jiazhouInfoCreateTime;	
					 time = time.substring(0,10).replace('-','.').replace('-','.');
					 var str ='<div class="jzDetailTitle">'+data.data.jiazhouInfoTitle+'</div>';
					     str +='<div class="jzDetailUserInfo clearfix">';
					     str +='<div>'+time+'</div>';
					     str +='<div>作者：<span>'+data.data.authorName+'</span></div>';
					     str +='<div>来源：<span>'+data.data.publisherName+'</span></div>';
					     str +='</div><ul class="jzDetailTag clearfix">';
					     var jiazhouInfoTagsHtml = "";					     
					     if (data.data.jiazhouInfoTags != null && data.data.jiazhouInfoTags.length != 0) {
					    	     var jiazhouInfoTags=data.data.jiazhouInfoTags.split(",");
			                    $.each(jiazhouInfoTags, function (i, jiazhouInfoTag) {
			                    	if(jiazhouInfoTag){
			                    		 str +='<li>'+jiazhouInfoTag+'</li>';
			                    	}			                       
			                    });
			                }
					     str +='</ul><div class="clearfix jzUserBtn">';
					     str +='<div class="jzShareBtn" id="jzShare">分享</div>';
					     str +='<div class="jzLoveBtn" id="jzLove" onclick="addWantGo();">'+data.data.jiazhouInfoIsWant+'</div></div>';				    
					 $("#jzDetailHead").append(str);
					 $("#jzDetailContent").append(data.data.jiazhouInfoContent);	
					 formatStyle('jzDetailContent');
					 //是否点赞
					 if (data.data.jiazhouInfoTF == 1) {							 						 
						 $("#jzLove").addClass("jzLoveBtnOn");
	                    }
				 }				 
				
				//分享
				$(".jzShareBtn").click(function() {
					if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
						dialogAlert('系统提示', '请用微信浏览器打开分享！');
					}else{
						$("html,body").addClass("bg-notouch");
						$(".background-fx").css("display", "block")
					}
				})
				$(".background-fx").click(function() {
					$("html,body").removeClass("bg-notouch");
					$(".background-fx").css("display", "none")
				})				
			},"json");								
		});
						
		//富文本格式修改
        function formatStyle(id) {
            var $cont = $("#" + id);
            $cont.find("img").each(function () {
                var $this = $(this);
                $this.css({"max-width": "710px"});
            });
            $cont.find("p,font").each(function () {
                var $this = $(this);
                $this.css({
                    "font-size": "24px",
                    "line-height": "44px",
                    "color": "#7C7C7C",
                    "font-family": "Microsoft YaHei"
                });
            });
            $cont.find("span").each(function () {
                var $this = $(this);
                $this.css({
                	"font-size": "24px",
                    "line-height": "44px",
                    "font-family": "Microsoft YaHei"
                });
            });
            $cont.find("a").each(function () {
                var $this = $(this);
                $this.css({
                	"text-decoration": "underline",
                	"color": "#7C7C7C"
                });
            });
            var str = $cont.html();
            str.replace(/<span>/g, "").replace(/<\/span>/g, "");
            $cont.html(str);
        }
		
    	//点赞
        function addWantGo() {
             if (userId == null || userId == '') {
            	//判断登陆
	        	publicLogin("${basePath}wechatStatic/jiazhouInfoDetail.do?jiazhouInfoId="+jiazhouInfoId);
            }else{ 
            	$.post("${path}/wechatUser/addUserWantgo.do", {
            		relateId: jiazhouInfoId,
                    userId: userId,
                    type: 6
                }, function (data) {
                    if (data.status == 0) {
                    	$("#jzLove").addClass("jzLoveBtnOn");
    					var num = $("#jzLove").text();
    					$("#jzLove").text(eval(num)+1);
                    } else if (data.status == 14111) {
                        $.post("${path}/wechatUser/deleteUserWantgo.do", {
                        	relateId: jiazhouInfoId,
                            userId: userId
                        }, function (data) {
                            if (data.status == 0) {
                            	$("#jzLove").removeClass("jzLoveBtnOn");
            					var num = $("#jzLove").text();
            					$("#jzLove").text(eval(num-1));
                            }
                        }, "json");
                    }
                }, "json");
             } 
        }
		
	</script>
</head>	
<body>
    <!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${jiazhouInfo.shareIconUrl}"/></div>
   	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
	</div>
		<div class="jiazhouImfoMain">
			<div class="jzDetail">
				<div class="jzDetailHead" id="jzDetailHead"></div>
				<div class="jzDetailContent" id="jzDetailContent"></div>
			</div>
		</div>
	</body>	
</html>