<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>${ccpVote.voteName}</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var fullUrl = '${fullUrl}';
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '${ccpVote.shareTitle}';
	    	appShareDesc = '${ccpVote.shareDescribe}';
	    	appShareImgUrl = '${ccpVote.shareLogoImg}@400w';
	    	
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
				jsApiList: ['onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
			});
			wx.ready(function () {
				wx.onMenuShareAppMessage({
					title: '${ccpVote.shareTitle}',
					desc: '${ccpVote.shareDescribe}',
					imgUrl: '${ccpVote.shareLogoImg}@400w',
					link: fullUrl
				});
				wx.onMenuShareTimeline({
					title: '${ccpVote.shareTitle}',
					imgUrl: '${ccpVote.shareLogoImg}@400w',
					link: fullUrl
				});
				wx.onMenuShareQQ({
					title: '${ccpVote.shareTitle}',
					desc: '${ccpVote.shareDescribe}',
					imgUrl: '${ccpVote.shareLogoImg}@400w'
				});
				wx.onMenuShareWeibo({
					title: '${ccpVote.shareTitle}',
					desc: '${ccpVote.shareDescribe}',
					imgUrl: '${ccpVote.shareLogoImg}@400w'
				});
				wx.onMenuShareQZone({
					title: '${ccpVote.shareTitle}',
					desc: '${ccpVote.shareDescribe}',
					imgUrl: '${ccpVote.shareLogoImg}@400w'
				});
			});
		}
		
		$(function () {
			navFixed($(".template .tetit"),'touchmove',240);
		    navFixed($(".template .tetit"),'scroll',240);
		    
			$.post("${path}/wechatFunction/getVoteItemList.do",{userId:userId,voteId:'${ccpVote.voteId}',voteItemId:'${ccpVoteItem.voteItemId}',sort:1}, function (data) {
    			if (data.status == 1) {
    				var dom = data.data.list[0];
    				$("#number").text(dom.number);
    				if(dom.isVote == 1){
    					$(".anniu .lan").addClass('old');
					}else{
						$(".anniu .lan").attr("onclick","userVote()");
					}
    				$("#voteCount").text(dom.voteCount);
    			}
			},"json");
		    
		    //动态加载图片
		    var ImgObj = new Image();
			ImgObj.src = '${ccpVoteItem.itemImgUrl}@700w';
			ImgObj.onload = function(){
				if(ImgObj.width/ImgObj.height>560/610){
					var pLeft = (ImgObj.width*(610/ImgObj.height)-560)/2;
					$("#itemImgUrl").css({"height":"610px","position":"absolute","left":"-"+pLeft+"px"});
				}else{
					var pTop = (ImgObj.height*(560/ImgObj.width)-610)/2;
					$("#itemImgUrl").css({"width":"560px","position":"absolute","top":"-"+pTop+"px"});
				}
			}
			
			//关闭图片预览
			$(".imgPreview,.imgPreview>img").click(function() {
				$(".imgPreview").fadeOut("fast");
			})
			
			//分享
			$(".shareBtn").click(function() {
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
			//关注
			$(".keepBtn").on("touchstart", function() {
				$('.div-share').show()
				$("body,html").addClass("bg-notouch")
			})
		});
		
		//投票
		function userVote(){
			if (userId == null || userId == '') {
        		//判断登陆
				publicLogin('${basePath}wechatFunction/voteDetail.do?voteItemId=${ccpVoteItem.voteItemId}');
        	}else{
        		if('${ccpVote.isUserInfo}' == 1){
        			$.post("${path}/wechatFunction/saveUserTicket.do",{voteItemId:'${ccpVoteItem.voteItemId}',userId:userId}, function (data) {
						if (data.data == "投票成功") {
							$(".anniu .lan").addClass('old');
							var voteCount = $("#voteCount").text();
							$("#voteCount").text(eval(voteCount)+1);
						}else{
							dialogAlert('系统提示', data.data);
						}
					}, "json");
        		}else{
        			$.post("${path}/wechatFunction/queryVoteUser.do", {userId: userId}, function (data) {
            			if(data.data.userName==null || data.data.userMobile==null){
            				$("#userName").val(data.userName);
            				$("#userMobile").val(data.userMobile);
            				// 首页
    				        $('.template .photoxx').hide();
    				        // 留资页
    				        $('.template .tecont_wc').show();
            			}else{
            				$.post("${path}/wechatFunction/saveUserTicket.do",{voteItemId:'${ccpVoteItem.voteItemId}',userId:userId}, function (data) {
        						if (data.data == "投票成功") {
        							$(".anniu .lan").addClass('old');
        							var voteCount = $("#voteCount").text();
        							$("#voteCount").text(eval(voteCount)+1);
        						}else{
        							dialogAlert('系统提示', data.data);
        						}
        					}, "json");
            			}
            		}, "json");
        		}
        	}
		}
		
		//保存用户
		function userInfo(){
			if (userId == null || userId == '') {
				//判断登陆
				publicLogin('${basePath}wechatFunction/voteDetail.do?voteItemId=${ccpVoteItem.voteItemId}');
			}else{
				var userName = $("#userName").val();
				if(userName == ""){
			    	dialogAlert('系统提示', '请输入姓名！');
			        return false;
			    }
	    		var userMobile = $("#userMobile").val();
				var telReg = (/^1[34578]\d{9}$/);
				if(userMobile == ""){
			    	dialogAlert('系统提示', '请输入手机号码！');
			        return false;
			    }else if(!userMobile.match(telReg)){
			    	dialogAlert('系统提示', '请正确填写手机号码！');
			        return false;
			    }
				var data = {
					userId:userId,
					userName:userName,
					userMobile:userMobile
				}
				
				
				
				$.post("${path}/wechatFunction/saveVoteUser.do", data, function(data) {
					if (data.status == 1) {
						dialogConfirm('系统提示', "提交成功！",function(){
							// 首页
					        $('.template .photoxx').show();
					        // 留资页
					        $('.template .tecont_wc').hide();
	    				});
					}else {
						dialogAlert('系统提示', "提交失败")
					}
				},"json");
			}
		}
		
		//预览大图
		function showPreview(url){
			$(".imgPreview img").attr("src",url);
			$(".imgPreview").fadeIn("fast");
		}
		
		// 导航固定
	    function navFixed(ele, type, topH) {
	        $(document).on(type, function() {
	            if($(document).scrollTop() > topH) {
	                ele.css('position', 'fixed');
	            } else {
	                ele.css('position', 'static');
	            }
	        });
	    }
		
	</script>
	
	<style>
		* {-webkit-tap-highlight-color: transparent;}
		html,body{font-family:arial,\5FAE\8F6F\96C5\9ED1,\9ED1\4F53,\5b8b\4f53,sans-serif; -webkit-text-size-adjust:none;}
		img {vertical-align: middle;}
		html,body {background-color: #eee;height: 100%; }
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${ccpVote.shareLogoImg}@400w"/></div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
	</div>
	<div class="div-share">
		<div class="share-bg"></div>
		<div class="share">
			<img src="${path}/STATIC/wechat/image/wx-er2.png" />
			<p style="margin-top: 310px;">扫一扫&nbsp;关注文化云</p>
			<p>更多精彩活动、场馆等你发现</p>
			<button type="button" onclick="$('.div-share').hide();$('body,html').removeClass('bg-notouch')">关闭</button>
		</div>
	</div>
	<div class="template">
	    <div class="teban">
	    	<div class="logo"></div>
	        <c:choose>
	    		<c:when test="${not empty ccpVote.coverImgUrl}">
	    			<img src="${ccpVote.coverImgUrl}@750w" width="750" height="250">
	    		</c:when>
	    		<c:otherwise>
	    			<img src="${path}/STATIC/wxStatic/image/vote/defaultImg.jpg" width="750" height="250">
	    		</c:otherwise>
	    	</c:choose>
	        <div class="tebchar">
	            <div class="nc">
	                <p class="w1">${ccpVote.voteTitle}</p>
	                <p class="w2">${ccpVote.voteSecondTitle}</p>
	            </div>
	        </div>
	        <ul class="lccshare clearfix">
	            <li class="shareBtn"><a href="javascript:;">分享</a></li>
	            <li class="keepBtn"><a href="javascript:;">关注</a></li>
	        </ul>
	    </div>
	    <div class="tetit_wc">
	        <ul class="tetit clearfix">
	            <li class="current"><a href="${path}/wechatFunction/voteIndex.do?voteId=${ccpVote.voteId}">投票</a></li>
	            <li><a href="${path}/wechatFunction/voteRule.do?voteId=${ccpVote.voteId}">活动规则</a></li>
	            <li><a href="${path}/wechatFunction/voteRanking.do?voteId=${ccpVote.voteId}">排行榜</a></li>
	        </ul>
	    </div>
	    <!-- 照片详情 -->
	    <div class="photoxx jz700">
	        <div class="nc">
	            <div class="tit">${ccpVoteItem.itemName}</div>
	            <div class="pic">
	                <div style="display:block;width:560px;height:610px;overflow:hidden;position: relative;cursor:pointer;" <c:if test="${empty ccpVoteItem.itemLink}"> onclick="showPreview('${ccpVoteItem.itemImgUrl}@700w');"</c:if>>
	                	<img id="itemImgUrl" src="${ccpVoteItem.itemImgUrl}@700w"
	                	<c:if test="${!empty ccpVoteItem.itemLink}"> onclick="location.href='${ccpVoteItem.itemLink}'"</c:if>>
	                </div>
	                <div class="riqi" id="number"></div>
	                <c:if test="${ccpVote.isAuthorInfo == 2}">
	                	<div class="people clearfix">
		                    <div class="tx"><img src="${ccpVoteItem.authorHeadImgUrl}@100w" width="70" height="70"></div>
		                    <div class="xm">
		                        <div><span>${ccpVoteItem.authorName}</span></div>
		                    </div>
		                </div>
	                </c:if>
	            </div>
	            <div class="anniu clearfix">
	            	<div class="btn lan clearfix">
	                    <span class="tp"><em></em><span id="voteCount"></span></span>
	                    <span>投 票</span>
	                </div>
	                <a class="btn huang shareBtn" href="javascript:;">分享去拉票</a>
	            </div>
	        </div>
	    </div>
	    <div class="tecont_wc" style="display: none;">
	        <div class="tecont">
	            <!-- 留资页 -->
	            <div class="liuzy jz700" style="display: block;">
	                <div class="nc">
	                    <div class="t">#&nbsp;&nbsp;&nbsp;&nbsp;投票&nbsp;&nbsp;&nbsp;&nbsp;#</div>
	                    <div class="fut">请先留下你的个人资料</div>
	                    <div class="xian"></div>
	                    <div class="kuang clearfix">
	                        <div class="lable"><span>姓 名</span></div>
	                        <input class="txt" id="userName" type="text" maxlength="20">
	                    </div>
	                    <div class="kuang clearfix">
	                        <div class="lable"><span>手 机</span></div>
	                        <input class="txt" id="userMobile" type="text" maxlength="20">
	                    </div>
	                    <input class="kuangsub" type="button" value="提   交" onclick="userInfo();">
	                </div>
	            </div>
	        </div>
	    </div>
	</div>
	<!--点击放大图片-->
	<div class="imgPreview" style="display: none;">
		<img src="" />
	</div>
</body>
</html>