<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <!-- <title>用户中心</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>

    <script type="text/javascript">
        var userId = '${sessionScope.terminalUser.userId}';

        $(function () {
            //判断是否是微信浏览器打开
            if (is_weixin()) {
                //通过config接口注入权限验证配置
                wx.config({
                    debug: false,
                    appId: '${sign.appId}',
                    timestamp: '${sign.timestamp}',
                    nonceStr: '${sign.nonceStr}',
                    signature: '${sign.signature}',
                    jsApiList: ['previewImage']
                });
            }
            
            loadUser();
            
          	//底部菜单
			$(document).on("touchmove", function() {
				$(".footer").hide()
			}).on("touchend", function() {
				$(".footer").show()
			})
			$(".footer-menu-button").click(function() {
				if ($(".footer-menu-list").offset().left == 25) {
					$(".footer-menu-list").animate({
						"left": "630px",
					},200);
				} else {
					$(".footer-menu-list").animate({
						"left": "0px",
					},200);
				}
			})
        });

        function loadUser() {
        	if (userId == null || userId == '') {
                $("#userCenterDiv").html("<img src='${path}/STATIC/wechat/image/个人中心bg.jpg'/>" +
							    		 "<div style='position: absolute;top: 110px;left: 235px;'>" +
											"<p style='font-size: 40px;text-align: center;color: #fff;margin-bottom: 80px;'>欢迎来到文化云</p>" +
											"<a><img src='${path}/STATIC/wechat/image/登录注册.png' onclick='window.location.href=\"${path}/muser/login.do?type=${path}/wechatUser/preTerminalUser.do\"'/></a>" +
										 "</div>");
            }else{
            	$.post("${path}/wechatUser/queryTerminalUserById.do", {userId: userId}, function (data) {
                    if (data.status == 0) {
                        var user = data.data[0];
                        var userHeadImgHtml = '';
                        if (user.userHeadImgUrl.indexOf("http") == -1) {
                        	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png' width='212' height='212' ontouchstart='previewImage(\"" + user.userHeadImgUrl + "\");'/>";
                        } else if (user.userHeadImgUrl.indexOf("/front/") != -1) {
                        	var smallUrl = getIndexImgUrl(user.userHeadImgUrl, "_150_150");
                            var bigUrl = getIndexImgUrl(user.userHeadImgUrl, "_300_300");
                            var ImgObj = new Image();
                            ImgObj.src = smallUrl;
                            if (ImgObj.fileSize > 0 || (ImgObj.width > 0 && ImgObj.height > 0)) {
                            	userHeadImgHtml = "<img src='" + smallUrl + "' width='212' height='212' ontouchstart='previewImage(\"" + user.userHeadImgUrl + "\");' onerror='imgNoFind();'/>";
                            } else {
                            	userHeadImgHtml = "<img src='" + bigUrl + "' width='212' height='212' ontouchstart='previewImage(\"" + user.userHeadImgUrl + "\");' onerror='imgNoFind();'/>";
                            }
                        } else {
                        	userHeadImgHtml = "<img src='" + user.userHeadImgUrl + "' width='212' height='212' ontouchstart='previewImage(\"" + user.userHeadImgUrl + "\");' onerror='imgNoFind();'/>";
                        }
                        var userCity = (user.userCity!=''?user.userCity.split(',')[1]:'上海市')+'&nbsp;';
                        var userArea = user.userArea!=''?user.userArea.split(',')[1]+'&nbsp;':'';
                        var userSex = "男";
                        if(user.userSex==1){
                        	userSex = "男";
        				}else if(user.userSex==2){
        					userSex = "女";
        				}
                        var userInfoHtml = userCity + userArea + userSex;
                        $("#userCenterDiv").html("<img src='${path}/STATIC/wechat/image/个人中心bg.jpg'/>" +
				                				 "<span style='position: absolute;top: 29px;left: 170px;font-size: 30px;color: #fff;width: 400px;text-align: center;'>"+user.userName+"</span>" +
				                				 "<p style='width: 750px;text-align: center;position: absolute;top: 70px;font-size: 24px;color: #fff;'>"+userInfoHtml+"</p>" +
				                				 "<span style='position: absolute;top: 25px;right: 40px;font-size: 30px;color: #fff;'>" +
				                					"<img src='${path}/STATIC/wechat/image/icon_信息.png' onclick='window.location.href=\"${path}/wechatUser/preMobileMessage.do\"'/>" +
				                				 "</span>" +
				                				 "<div class='personal-head-img'><div class='personal-hi'></div>"+userHeadImgHtml+"</div>");
                        $("#myPoint").html(user.userIntegral+"&nbsp;分");
                        if(user.userType==2){
                        	$("#myAuth").html("已认证");
                        }else if(user.userType==3){
                        	$("#myAuth").html("认证中");
                        }else if(user.userType==4){
                        	$("#myAuth").html("认证不通过");
                        }else{
                        	$("#myAuth").html("未提交");
                        }
                        if(user.teamUserSize>0){
                        	$("#myAuthTeam").html("已认证");
                        }else{
                        	$("#myAuthTeam").html("未提交");
                        }
                    }
                }, "json");
            }
        }

        //图片预览
        function previewImage(url) {
            wx.previewImage({
                current: url, // 当前显示图片的http链接
                urls: [url]
            });
        }
        
      	//跳转到我的活动
        function preOrderList() {
            if (userId == null || userId == '') {
                window.location.href = '${path}/muser/login.do?type=${path}/wechatActivity/wcOrderList.do';
                return;
            }
            window.location.href = '${path}/wechatActivity/wcOrderList.do';
        }
      	
      	//跳转到我的收藏
        function preMyCollect() {
            if (userId == null || userId == '') {
                window.location.href = '${path}/muser/login.do?type=${path}/wechatUser/myCollect.do';
                return;
            }
            window.location.href='${path}/wechatUser/myCollect.do'
        }
      	
      	//跳转到我的评论
        function preMyComment() {
            if (userId == null || userId == '') {
                window.location.href = '${path}/muser/login.do?type=${path}/wechatUser/myComment.do';
                return;
            }
            window.location.href='${path}/wechatUser/myComment.do'
        }

      	//跳转到日历
        function preCalendar(){
        	if (is_weixin()) {
        		window.location.href = '${path}/wxUser/silentInvoke.do?type=${path}/wechatActivity/preActivityCalendar.do';
        	}else{
        		window.location.href = '${path}/wechatActivity/preActivityCalendar.do';
        	}
        }
      	
     	// 跳转到实名认证
     	function userAuth(){
     		if (userId == null || userId == '') {
                window.location.href = '${path}/muser/login.do?type=${path}/wechatUser/auth.do';
                return;
            }
        	window.location.href="${path}/wechatUser/auth.do";
     	}
     	
     	// 跳转到资质认证
     	function userAuthTeam(){
     		if (userId == null || userId == '') {
                window.location.href = '${path}/muser/login.do?type=${path}/wechatRoom/authTeamUser.do';
                return;
            }
        	window.location.href="${path}/wechatRoom/authTeamUser.do";
     	}
      	
      	//跳转到设置
        function preUserSetting(){
        	if (userId == null || userId == '') {
                window.location.href = '${path}/muser/login.do?type=${path}/wechatUser/preUserSetting.do';
                return;
            }
        	window.location.href="${path}/wechatUser/preUserSetting.do";
        }
      	
      	// 跳转到我的积分
     	function userIntegral(){
     		if (userId == null || userId == '') {
                window.location.href = '${path}/muser/login.do?type=${path}/wechatUser/userIntegral.do';
                return;
            }
        	window.location.href="${path}/wechatUser/userIntegral.do";
     	}
    </script>

	<style>
		.menu-me {background: url(${path}/STATIC/wechat/image/menu-icon01.png) no-repeat -430px center;;}
	</style>
</head>
<body>
	<div class="main">
		<div class="header"></div>
		<div class="content padding-bottom0">
			<div id="userCenterDiv"></div>
			<div class="login-top">
				<ul>
					<li class="border-right1" onclick="preOrderList();">
						<img src="${path}/STATIC/wechat/image/login-icon-1.jpg" />
						<p>我的订单</p>
					</li>
					<li class="border-right1" onclick="preMyCollect();">
						<img src="${path}/STATIC/wechat/image/login-icon-2.jpg" />
						<p>我的收藏</p>
					</li>
					<li onclick="preMyComment();">
						<img src="${path}/STATIC/wechat/image/login-icon-3.jpg" />
						<p>我的评论</p>
					</li>
					<div style="clear: both;"></div>
				</ul>
			</div>
			<div class="login-p1">
				<ul>
					<li class="border-bottom" onclick="userIntegral();">
						<div class="login-list" >
							<p class="f-left">我的积分</p>
							<p class="f-right c999" style="margin-right:80px" id="myPoint"></p>
							<div style = "clear:both"></div>
						</div>
					</li>
				</ul>
			</div>
			<div class="login-p1">
				<ul>
					<li class="border-bottom" onclick="userAuth();">
						<div class="login-list">
							<p class="f-left">实名认证</p>
							<p class="f-right c999" style="margin-right:80px" id="myAuth"></p>
							<div style = "clear:both"></div>
						</div>
					</li>
					<li class="border-bottom" onclick="userAuthTeam();">
						<div class="login-list">
							<p class="f-left">资质认证</p>
							<p class="f-right c999" style="margin-right:80px" id="myAuthTeam"></p>
							<div style = "clear:both"></div>
						</div>
					</li>
				</ul>
			</div>
			<div class="login-p2">
				<ul>
					<li class="border-bottom" onclick="preUserSetting();">
						<div class="login-list">
							<p>设置</p>
						</div>
					</li>
					<li class="border-bottom" onclick="window.location.href='${path}/wechatUser/preFeedBack.do'">
						<div class="login-list">
							<p>帮助与反馈</p>
							<div style="clear: both;"></div>
						</div>
					</li>
					<li onclick="window.location.href='${path}/wechatUser/preCulture.do'">
						<div class="login-list">
							<p>关于文化云</p>
							<div style="clear: both;"></div>
						</div>
					</li>
				</ul>
			</div>
		</div>
		<div class="footer" style="background-color: transparent;bottom: 40px;border:none;">
			<div class="footer-menu">
				<div class="footer-menu-list">
					<ul>
						<li><a href="${path}/wechat/index.do"><div class="menu-home"></div><p>首页</p></a></li>
						<li><a href="${path}/wechatActivity/preMap.do"><div class="menu-near"></div><p>附近</p></a></li>
						<li><a href="javascript:preCalendar();"><div class="menu-data"></div><p>日历</p></a></li>
						<li><a href="${path}/wechatVenue/venueIndex.do"><div class="menu-venue"></div><p>场馆</p></a></li>
						<li><a><div class="menu-me"></div><p class="c7279a0">我</p></a></li>
						<div style="clear: both;"></div>
					</ul>
				</div>
			</div>
			<div class="footer-menu-button">
				<img src="${path}/STATIC/wechat/image/menu-button.png" />
			</div>
		</div>
	</div>
</body>
</html>