<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>${info.informationTitle}</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
	</link>
	<style type="text/css">
	html,body {height: 100%;background: #f4f4f4;}
	.videoAllContent img{max-width:710px!important;}
	</style>
	
	<script type="text/javascript">
	
	var informationId='${info.informationId}';
    var informationModuleId = '${info.informationModuleId}'
    //分享文案
    appShareTitle = '新鲜资讯，一手播报，快来围观最全线上信息资源！';
    if(informationModuleId == 'bd59ef49bc46450392c8b03e37e15207') {
        appShareTitle = '我在文化湖南·锦绣潇湘服务云上发现了一个特别好玩的地方！' ;
    } else if(informationModuleId == '7f86231d89be49a89746b201b06b8288') {
        appShareTitle = '文化湖南·锦绣潇湘服务云推荐的相当韵味哦！';
    }
	if(sessionStorage.getItem("shopPath")){
		appShareDesc = sessionStorage.getItem("shopTitle") + "·${info.informationTitle}";
	}else{
		appShareDesc = "${info.informationTitle}";
	}
	appShareImgUrl = getIndexImgUrl(getImgUrl('${info.informationIconUrl}'), "_750_500")
	
	//分享是否隐藏
    if(window.injs){
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
				title: appShareTitle,
				desc: appShareDesc,
				imgUrl: appShareImgUrl
			});
			wx.onMenuShareTimeline({
				title: appShareTitle,
				imgUrl: appShareImgUrl
			});
			wx.onMenuShareQQ({
				title: appShareTitle,
				desc: appShareDesc,
				imgUrl: appShareImgUrl
			});
			wx.onMenuShareWeibo({
				title: appShareTitle,
				desc: appShareDesc,
				imgUrl: appShareImgUrl
			});
			wx.onMenuShareQZone({
				title: appShareTitle,
				desc: appShareDesc,
				imgUrl: appShareImgUrl
			});
		});
	}
	
	$(function () {
	
		loadComment();
		
		var shareImg=$("#shareImg").attr("data");
		
		var imgUrl=getIndexImgUrl(getImgUrl(shareImg),"_730_375");
		
		$("#shareImg").attr("src",imgUrl);
		
		if (userId ) {
			
		    $.post("${path}/wechatInformation/queryInformationUserInfo.do", {userId:userId,informationId:informationId}, function (data) {
		    	
		    	var userIsWant = data.userIsWant;
		    	var userIsCollect = data.userIsCollect;
		    	
		    	if(userIsWant== 1){
		    		$(".dz").addClass("cur")
		    	}
		    	
		    	if(userIsCollect == 1){
		    		$(".sc").addClass("cur")
		    	}
		    	
		    }, "json");
		}
		
	})
	
	//更多评论
        function moreComment() {
            window.location.href = "${path}/wechat/preWcCommentList.do?moldId=" + informationId + "&type=12";
        }
	
	  //评论列表
        function loadComment() {
            var data = {
                moldId: informationId,
                type: 12,
                pageIndex: 0,
                pageNum: 10
            };
            $.post("${path}/wechat/weChatComment.do", data, function (data) {
                if (data.status == 0) {
                	if(data.data.length>0){
                		$("#commentLi").show();
                	}
                    $.each(data.data, function (i, dom) {
                        var commentImgUrlHtml = "";
                        if (dom.commentImgUrl.length != 0) {
                            var commentImgUrls = dom.commentImgUrl.substring(0, dom.commentImgUrl.length - 1).split(",");
                            $.each(commentImgUrls, function (i, commentImgUrl) {
                            	var smallCommentImgUrl = "";
                            	if(commentImgUrl.indexOf(".aliyuncs.com/")>-1){
                            		smallCommentImgUrl = commentImgUrl+"@300w";
                            	}else{
                            		smallCommentImgUrl = getIndexImgUrl(commentImgUrl, "_150_150");
                            	}
                                commentImgUrlHtml += "<p>&nbsp;</p<p><img src='" + smallCommentImgUrl + "' onclick='previewImage(\"" + commentImgUrl + "\",\""+dom.commentImgUrl+"\");'></p>"
                            });
                        }
                        var userHeadImgUrl = '';
                        if (dom.userHeadImgUrl.indexOf("http") == -1) {
                            userHeadImgUrl = '../STATIC/wx/image/sh_user_header_icon.png';
                        } else if (dom.userHeadImgUrl.indexOf("/front/") != -1) {
                            userHeadImgUrl = getIndexImgUrl(dom.userHeadImgUrl, "_300_300");
                        } else {
                            userHeadImgUrl = dom.userHeadImgUrl;
                        }
                        
                        $("#commentList").append("<li class='clearfix'>" +
														"<div class='toux'>" +
															"<img src='" + userHeadImgUrl + "' width='65' height='65' onerror='imgNoFind();'/>" +
														"</div>" +
																"<div class='char'>" +
																	"<div class='tit'>"+dom.commentUserNickName+"</div>" +
																	"<div class='time'>"+dom.commentTime.replace("-",".").replace("-",".")+"</div>" +
																	"<div class='cont'>" +
																		"<p>" + dom.commentRemark + "</p>" +
																		 commentImgUrlHtml + 
																	"</div>" +
																"</div>" +
													"</li>");
                    });
                    imgStyleFormat('commentImgHtml','commentImgUrlHtml');
                }
            }, "json");
        }
	
	  //添加评论
    function addComment() {
        if (userId == null || userId == '') {
            publicLogin('${basePath}wechatInformation/informationDetail.do?informationId=' + informationId);

        } else {
            var status = '${sessionScope.terminalUser.commentStatus}';
            if (status == 2) {
                dialogAlert("评论提示", "您的账户已被禁止评论，没有评论权限");
            } else {
                window.location.href = "${path}/wechat/preAddWcComment.do?moldId=" + informationId + "&type=12";
            }
        }
    }
	  
    //点赞（我想去）
    function addWantGo(ele) {
        if (userId == null || userId == '') {
            publicLogin('${basePath}wechatInformation/informationDetail.do?informationId=' + informationId);
            return;
        }
        
        var $this = $(ele);

        $.post("${path}/wechatUser/addUserWantgo.do", {
        	relateId: informationId,
            userId: userId,
            type: 12
        }, function (data) {
            if (data.status == 0) {
            	$this.hasClass('cur') ? $this.removeClass('cur') : $this.addClass('cur');
            } else if (data.status == 14111) {
                $.post("${path}/wechatUser/deleteUserWantgo.do", {
                	relateId: informationId,
                    userId: userId
                }, function (data) {
                	$this.hasClass('cur') ? $this.removeClass('cur') : $this.addClass('cur');
                }, "json");
            }
        }, "json");
		
    }
    
	//收藏
    function collectBut(ele){
		
    	  var $this = $(ele);
  		
        if (userId == null || userId == '') {
            publicLogin('${basePath}wechatInformation/informationDetail.do?informationId=' + informationId);
            return;
        }
        if ($this.hasClass('cur')) {
            $.post("${path}/wechat/wcDelCollect.do", {
            	relateId: informationId,
                userId: userId,
                type: 7
            }, function (data) {
                if (data.status == 0) {
                	$this.hasClass('cur') ? $this.removeClass('cur') : $this.addClass('cur');
                    dialogAlert("收藏提示", "已取消收藏");
                }
            }, "json");
        } else {
            $.post("${path}/wechat/wcCollect.do", {
            	relateId: informationId,
                userId: userId,
                type: 7
            }, function (data) {
                if (data.status == 0) {
                	$this.hasClass('cur') ? $this.removeClass('cur') : $this.addClass('cur');
                    dialogAlert("收藏提示", "收藏成功");
                }
            }, "json");
        }
    }
	</script>
	
</head>
	
	<body>
	<div style="display: none;"><img id="shareImg" data="${info.informationIconUrl }" src=""/></div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index:1">
			<img src="${path}/STATIC/wxStatic/image/fx-bg.png" style="width: 100%;height: 100%;" />
		</div>
	<div class="zMain">
	
	<div class="videoAllShip">
		<!-- <div class="fm"><img src="${info.informationIconUrl }@750w"><span></span></div> -->
		<video class="sp" controls="controls"   src='${info.videoUrl }' poster='${info.videoIconUrl }' ></video>
	</div>
	<div class="picAllHead">
		<div class="tit">${info.informationTitle }</div>
		<div class="char clearfix">
			<div class="fl"><fmt:formatDate value="${info.informationCreateTime}" pattern="yyyy-MM-dd" /></div>
			<div class="fl">作者：${info.authorName }</div>
			<div class="fl">来源：${info.publisherName }</div>
		</div>
		<div class="picLable clearfix">
		<c:if test="${not empty fn:split(info.informationTags, ',')[0]}"><span>${fn:split(info.informationTags, ",")[0] }</span></c:if>
		<c:if test="${not empty fn:split(info.informationTags, ',')[1]}"><span>${fn:split(info.informationTags, ",")[1]}</span></c:if>
		<c:if test="${not empty fn:split(info.informationTags, ',')[2]}"><span>${fn:split(info.informationTags, ",")[2]}</span></c:if>
		</div>
	</div>
	<div class="videoAllContent">
	
	${info.informationContent }
	</div>

	<div class="zCommentTitle" id="commentLi"  style="display: none;">
		<div>共<span>${info.commentCount }</span>条评论</div>
	</div>
	<ul class="zCommentList commentImgHtml" id="commentList">
      
    </ul>
	<div class="zFooterWc">
		<div class="zFooter clearfix">
			<div class="txtDiv fl clearfix" onclick="addComment();"><span></span><input type="text" placeholder="发表评论 ..." readonly /></div>
			<div class="iconDiv fl clearfix">
				<div class="icon pl" onclick="moreComment();">
				<c:if test="${info.commentCount >0}">
					<span class="sl">${info.commentCount }</span>
				</c:if>
				</div>
				<div class="icon dz <c:if test="${info.userIsWant==1 }">cur</c:if>" onclick="addWantGo(this)"></div>
				<div class="icon sc <c:if test="${info.userIsCollect==1 }">cur</c:if>" onclick="collectBut(this)"></div>
				<div class="icon fx footmenu-button4"></div>
			</div>
		</div>
	</div>
</div>
</body>
	<script>
	function dzscFun(ele) {
		var $this = $(ele);
		$this.hasClass('cur') ? $this.removeClass('cur') : $this.addClass('cur');
	}
	$(function () {
		
		$(".footmenu-button4").click(function() {
			if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
				dialogAlert('系统提示', '请用微信浏览器打开分享！');
			}else{
				$("html,body").addClass("bg-notouch");
				$(".background-fx").css("display", "block")
			}
		});
		$(".background-fx").click(function() {
			$("html,body").removeClass("bg-notouch");
			$(".background-fx").css("display", "none")
		})
	});
   
</script>
</html>
	