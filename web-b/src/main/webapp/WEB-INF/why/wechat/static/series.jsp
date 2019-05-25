<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
    request.setAttribute("basePath", basePath);
    String error = request.getParameter("error");
    request.setAttribute("error", error);
%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"/>
	<meta name="format-detection" content="telephone=no"/>
	<meta name="apple-mobile-web-app-capable" content="yes"/>
	<meta name="apple-mobile-web-app-status-bar-style" content="black"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/normalize.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/ui-dialog.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/swiper-3.3.1.min.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/animate.min.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script type="text/javascript" src="${path}/STATIC/wxStatic/js/jquery-2.1.4.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/dialog-min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wxStatic/js/swiper-3.3.1.jquery.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wxStatic/js/swiper.animate1.0.2.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wxStatic/js/gridify.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/wechat-util.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/jweixin-1.0.0.js"></script>
	<script src="${path}/STATIC/js/common.js"></script>
	<title>文化云·六一活动</title>
	
	<script type="text/javascript">
		var phoneWidth = parseInt(window.screen.width);
		var phoneScale = phoneWidth / 750;
		var ua = navigator.userAgent; //浏览器类型
		if (/Android (\d+\.\d+)/.test(ua)) { //判断是否是安卓系统
			var version = parseFloat(RegExp.$1); //安卓系统的版本号
			if (version > 2.3) {
				document.write('<meta name="viewport" content="width=750,user-scalable=no, minimum-scale = ' + phoneScale + ', maximum-scale = ' + (phoneScale) + ', target-densitydpi=device-dpi">');
			} else {
				document.write('<meta name="viewport" content="width=750,user-scalable=no, target-densitydpi=device-dpi">');
			}
		} else {
			document.write('<meta name="viewport" content="width=750,user-scalable=no, target-densitydpi=device-dpi">');
		}
	</script>
	
	<script>
		var userId = '${sessionScope.terminalUser.userId}';
		var series_url = '${url}';	//本页相对路径
		var error = '${error}';
		var startIndex = 0;		//页数
		
		//判断是否是微信浏览器打开
		if (is_weixin()) {
			//通过config接口注入权限验证配置
			wx.config({
				debug: false,
				appId: '${sign.appId}',
				timestamp: '${sign.timestamp}',
				nonceStr: '${sign.nonceStr}',
				signature: '${sign.signature}',
				jsApiList: ['onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone','chooseImage','uploadImage','previewImage']
			});
			wx.ready(function () {
				wx.onMenuShareAppMessage({
					title: "六一大招一大波好玩的免费亲子活动正在靠近...",
					desc: '顶级音乐剧、亲子嘉年华、秀一波你跟娃之间的恩爱，无论你是长不大的老小孩，还是拖着娃的麻辣父母，都会在这里找到无穷乐趣。',
					link: '${basePath}/wxUser/silentInvoke.do?type=' + series_url,
					imgUrl: '${basePath}/STATIC/wxStatic/image/61.jpg'
				});
				wx.onMenuShareTimeline({
					title: "六一大招一大波好玩的免费亲子活动正在靠近...",
					imgUrl: '${basePath}/STATIC/wxStatic/image/61.jpg',
					link: '${basePath}/wxUser/silentInvoke.do?type=' + series_url
				});
				wx.onMenuShareQQ({
					title: "六一大招一大波好玩的免费亲子活动正在靠近...",
					desc: '顶级音乐剧、亲子嘉年华、秀一波你跟娃之间的恩爱，无论你是长不大的老小孩，还是拖着娃的麻辣父母，都会在这里找到无穷乐趣。',
					imgUrl: '${basePath}/STATIC/wxStatic/image/61.jpg'
				});
				wx.onMenuShareWeibo({
					title: "六一大招一大波好玩的免费亲子活动正在靠近...",
					desc: '顶级音乐剧、亲子嘉年华、秀一波你跟娃之间的恩爱，无论你是长不大的老小孩，还是拖着娃的麻辣父母，都会在这里找到无穷乐趣。',
					imgUrl: '${basePath}/STATIC/wxStatic/image/61.jpg'
				});
				wx.onMenuShareQZone({
					title: "六一大招一大波好玩的免费亲子活动正在靠近...",
					desc: '顶级音乐剧、亲子嘉年华、秀一波你跟娃之间的恩爱，无论你是长不大的老小孩，还是拖着娃的麻辣父母，都会在这里找到无穷乐趣。',
					imgUrl: '${basePath}/STATIC/wxStatic/image/61.jpg'
				});
			});
		}
		
		$(function () {
			if(error=="loginFail"){
				dialogAlert('登录失败', '请重试或通过其他方式登录！');
			}
			
			loadImg(0,20);		//瀑布流加载
			
          	//分享
			$(".header-button2").click(function() {
				if (!is_weixin()) {
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
			$(".header-button1").on("touchstart", function() {
				$('.div-share').show()
				$("body,html").addClass("bg-notouch")
			})
            
		});
		
		//加载系列图片
		function loadImg(index, pagesize){
			var data = {
                	userId: userId,
                    pageIndex: index,
                    pageNum: pagesize
                };
			$.post("${path}/wechatStatic/seriesImgList.do", data, function (data) {
				if(data!=null){
					if(index==0){
						$(".grid").html("");
						$("#seriesImgDetail").html("");
            		}
					$.each(data, function (i, dom) {
						var userHeadImgUrl = '';
						dom.userHeadImgUrl = dom.userHeadImgUrl==null?'':dom.userHeadImgUrl;
						if(dom.userHeadImgUrl.indexOf("http")==-1&&dom.userHeadImgUrl!=''){
							dom.userHeadImgUrl = getImgUrl(dom.userHeadImgUrl);
						}
                        if (dom.userHeadImgUrl.indexOf("http") == -1) {
                            userHeadImgUrl = '../STATIC/wx/image/sh_user_header_icon.png';
                        } else if (dom.userHeadImgUrl.indexOf("/front/") != -1) {
                        	var smallUrl = getIndexImgUrl(dom.userHeadImgUrl, "_72_72");
                            var bigUrl = getIndexImgUrl(dom.userHeadImgUrl, "_300_300");
                        	var ImgObj = new Image();
                            ImgObj.src = smallUrl;
                            if (ImgObj.fileSize > 0 || (ImgObj.width > 0 && ImgObj.height > 0)) {
                                userHeadImgUrl = smallUrl;
                            } else {
                                userHeadImgUrl = bigUrl;
                            }
                        } else {
                            userHeadImgUrl = dom.userHeadImgUrl;
                        }
                        var userName = dom.userName==null?"匿名":dom.userName;
						var smallImg = getImgUrl(getIndexImgUrl(dom.imgUrl, "_360_360"));
						if (index==0&&i==0&&userId==dom.userId) {
							$(".grid").append("<div id="+dom.userId+" class='pb'>" +
												"<div class='del'><img src='${path}/STATIC/wechat/image/mobile_close.png'></div>" +
												"<img class='smallImgClass' src="+smallImg+" width='360'>" +
												"<div class='user-bg'>" +
													"<img src='"+userHeadImgUrl+"' onerror='imgNoFind();' width='41' height='41'/>" +
													"<p>"+userName+"</p>" +
													"<div style='clear: both;'></div>" +
												"</div>" +
											  "</div>");
						}else{
							$(".grid").append("<div id="+dom.userId+" class='pb'>" +
												"<img class='smallImgClass' src="+smallImg+" width='360'>" +
												"<div class='user-bg'>" +
													"<img src='"+userHeadImgUrl+"' onerror='imgNoFind();' width='41' height='41'/>" +
													"<p>"+userName+"</p>" +
													"<div style='clear: both;'></div>" +
												"</div>" +
											  "</div>");
						}
						
						$("#seriesImgDetail").append("<div class='swiper-slide'>" +
														"<img src='"+getImgUrl(dom.imgUrl)+"'/>" +
														"<div class='upload-user'>" +
															"<img src='"+userHeadImgUrl+"' onerror='imgNoFind();' width='65' height='65'/>" +
															"<p class='upload-user-p1'>"+userName+"</p>" +
															"<p class='upload-user-p2'>"+dom.createTime.substring(0,10).replace("-",".").replace("-",".")+"上传</p>" +
															"<div style='clear: both;'></div>" +
														"</div>" +
													"</div>");
					});
					
					//swiper-container2的初始化
					$(".pb-on").css("display", "block")
					var mySwiper2 = new Swiper('.swiper-container2', {
						pagination: '.swiper-pagination',
						paginationType: "fraction",
						slidesPerView: 1,
						spaceBetween: 20,
						freeMode: false
					})
					$(".pb-on").css("display", "none")
					
					//瀑布流初始化
					var options = {
						srcNode: '.pb', // grid items (class, node)
						margin: '10px', // margin in pixel, default: 0px
						width: '360px', // grid item width in pixel, default: 220px
						max_width: '', // dynamic gird item width if specified, (pixel)
						resizable: true, // re-layout if window resize
						transition: 'all 0.5s ease' // support transition for CSS3, default: all 0.5s ease
					}
					$('.grid').gridify(options);
					
					//点击图片放大swiper初始化
					$(".pb .smallImgClass").click(function() {
						var pb_this = $(this).parent().index()
						mySwiper2.slideTo(pb_this);
						$(".header").fadeOut("fast");
						$(".pb-on").fadeIn("fast");
						$(".swiper-container2 .swiper-slide").click(function() {
							$(".pb-on").fadeOut("fast");
							$(".header").fadeIn("fast");
						})
					});
					
					//删除事件
					$(".pb .del").click(function(){
						dialogAlertFn('系统提示', '确认删除这张图片？');
					})
				}
			}, "json");
		}
		
		//删除图片
		function deleImg(){
			$(".del-img").hide();
			$.post("${path}/wechatStatic/seriesImgDel.do", {userId:userId}, function (data) {
				if(data=="success"){
						dialogAlert('系统提示', '删除成功！');
						startIndex = 0;
						loadImg(startIndex,20);
						setTimeout(function () { 
							$("html,body").animate({scrollTop:$("#ruleDiv").offset().top-100},500);
			       		},200);
				}else{
					dialogAlert('系统提示', '删除失败！');
				}
			}, "json");
		}
		
		//上传头像
		function uploadImg(){
			
			//判断是否是微信浏览器打开
	        if (!is_weixin()) {
	            dialogAlert('系统提示', '请用微信浏览器打开！');
	            return;
	        }
			
	        if (userId ==null || userId == '') {
	            window.location.href = "${path}/muser/login.do?type=${path}/wechatStatic/series.do";
	            return;
	        }
			
			if($(".grid div:eq(0)").attr("id")==userId){
				dialogAlert('系统提示', '每位用户只可上传一张图片！');
				return;
			}
			
			wx.chooseImage({
				count: 1,	// 默认9
		    	sizeType: ['compressed'],	// 指定是原图还是压缩图，默认二者都有
			    success: function (res) {
			        var localIds = res.localIds; // 返回选定照片的本地ID列表，localId可以作为img标签的src属性显示图片
			        wx.uploadImage({
			            localId: localIds[0], // 需要上传的图片的本地ID，由chooseImage接口获得
			            isShowProgressTips: 1, // 默认为1，显示进度提示
			            success: function (res) {
			                var serverId = res.serverId; // 返回图片的服务器端ID
			                $.post("${path}/wechat/wcUpload.do",{mediaId:serverId,userId:userId,uploadType:1}, function(data) {
			                	if(data!=1){
			                		$.post("${path}/wechatStatic/seriesSaveImg.do",{userId:userId,url:data}, function(data) {
			            				if(data=="200"){
			            					dialogAlert('系统提示', '上传成功！');
			            					startIndex = 0;
											loadImg(startIndex,20);
											setTimeout(function () { 
												$("html,body").animate({scrollTop:$("#ruleDiv").offset().top-100},500);
								       		},200);
			            				}
			                		},"json");
			                	}else{
			                		dialogAlert('系统提示', '上传失败！');
			                	}
			                },"json");
			            }
			        });
			    }
			});
		}
		
      	//弹出框
    	function dialogAlertFn(title, content) {
    		$(".main").prepend(
    			"<div class='del-img'>" +
    			"<div class = 'aimg-bg2'>" +
    			"</div>" +
    			"<div class = 'del-img2'>" +
    			"<p class='del-img2-p1'>" + title + "</p>" +
    			"<p class='del-img2-p2'>" + content + "</p>" +
    			"</div>" +
    			"<div class='del-button'>" +
    			"<div class='del-button1' onclick='deleImg();'>确定</div>" +
    			"<div class='del-button2' onclick='$(\".del-img\").hide()'>取消</div>" +
    			"<div style='clear: both;'></div>" +
    			"</div>" +
    			"</div>"
    		)
        }
	</script>
</head>

<body>
	<div class="main">
		<!-- 方便分享自动抓取 -->
		<div style="display: none;"><img src="${path}/STATIC/wxStatic/image/61.jpg"/></div>
		<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
			<img src="${path}/STATIC/wxStatic/image/fx-bg.png" style="width: 100%;height: 100%;" />
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
		<div class="header">
			<div class="header-logo">
				<img src="${path}/STATIC/wxStatic/image/logo2.png" />
			</div>
			<div class="header-button1">
				<img src="${path}/STATIC/wxStatic/image/keep2.png" />
			</div>
			<div class="header-button2">
				<img src="${path}/STATIC/wxStatic/image/share2.png" />
			</div>
			<div style="clear: both;"></div>
		</div>
		<div class="content">
			<div class="content-top">
				<img src="${path}/STATIC/wxStatic/image/top.jpg" />
				<div class="content-top-title1">
					<p>什么样的孩子最快乐</p>
					<div class="content-top-title2">
						<p>你好“六&bull;一”</p>
					</div>
					<div class="border-line-left"></div>
					<div class="border-line-right"></div>
					<div class="content-top-title3">
						<p>云叔永远三岁</p>
					</div>
				</div>
			</div>
			<div class="sw-title">
				<p>&mdash;&nbsp;顶级音乐剧&nbsp;&mdash;</p>
			</div>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<a href="http://www.wenhuayun.cn/wechatActivity/preActivityDetail.do?activityId=3d29c2c7f1254b01a8405a6bbed4d849">
							<img src="${path}/STATIC/wxStatic/image/Cinderella.jpg" />
							<div class="a-p">
								<p class="p1">5.29草坪音乐会 |儿童剧《灰姑娘》</p>
								<p class="p2">上海城市草坪音乐广场</p>
								<p class="p3">5月29日 10:00-12:00</p>
								<div class="a-p-bt">参与</div>
							</div>
							<div class="aimg-top">
								<div class="aimg-bg"></div>
								<div class="aimg-font">
									<p>免费</p>
								</div>
							</div>
						</a>
					</div>
					<div class="swiper-slide">
						<a href="http://www.wenhuayun.cn/wechatActivity/preActivityDetail.do?activityId=5aa8dafcfc58423ab91db0ca564e9c40">
							<img src="${path}/STATIC/wxStatic/image/a1-1.jpg" width="530" height="340"/>
							<div class="a-p">
								<p class="p1">法国光影偶剧《爱做梦的西多妮》</p>
								<p class="p2">南桥镇社区文化活动中心</p>
								<p class="p3">6月1日 14:00-15:00</p>
								<div class="a-p-bt">参与</div>
							</div>
							<div class="aimg-top">
								<div class="aimg-bg"></div>
								<div class="aimg-font">
									<p>免费</p>
								</div>
							</div>
						</a>
					</div>
					<div class="swiper-slide">
						<a href="http://www.wenhuayun.cn/wechatActivity/preActivityDetail.do?activityId=ab1d3e4981b84cb5be0ad6e2b6a9e610">
							<img src="${path}/STATIC/wxStatic/image/a1-2.jpg" width="530" height="340"/>
							<div class="a-p">
								<p class="p1">魔幻儿童剧《小屁孩的烦恼》</p>
								<p class="p2">梅陇文化馆</p>
								<p class="p3">5月29日 19:15-20:30</p>
								<div class="a-p-bt">参与</div>
							</div>
							<div class="aimg-top">
								<div class="aimg-bg"></div>
								<div class="aimg-font">
									<p>免费</p>
								</div>
							</div>
						</a>
					</div>
					<div class="swiper-slide">
						<a href="http://mp.weixin.qq.com/s?__biz=MzA5NTQ1MDM2Mg==&mid=504208379&idx=1&sn=a43a8872df3412ab8b4232630637916e&scene=0&previewkey=ocUu6jTo%2BkLy3BvUYcGXXsNS9bJajjJKzz%2F0By7ITJA%3D&from=singlemessage&isappinstalled=0#wechat_redirect">
							<img src="${path}/STATIC/wxStatic/image/a1-3.jpg" width="530" height="340"/>
							<div class="a-p">
								<p class="p1">抢票资格 开心麻花剧《三只小猪》</p>
								<p class="p2">虹桥当代艺术剧院</p>
								<p class="p3">6月1日 14:00-15:30</p>
								<div class="a-p-bt">参与</div>
							</div>
							<div class="aimg-top">
								<div class="aimg-bg"></div>
								<div class="aimg-font">
									<p>免费</p>
								</div>
							</div>
						</a>
					</div>
				</div>
			</div>
			<div class="sw-title">
				<p>&mdash;&nbsp;萌娃出演&nbsp;&mdash;</p>
			</div>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<a href="http://www.wenhuayun.cn/wechatActivity/preActivityDetail.do?activityId=14613bbf90ae40538fd6a98bf613f5fd">
							<img src="${path}/STATIC/wxStatic/image/a2-1.jpg" width="530" height="340"/>
							<div class="a-p">
								<p class="p1">叮当Hello | 六一猴娃睦邻演出</p>
								<p class="p2">长白街道社区文化中心</p>
								<p class="p3">5月27日 9:00-11:00</p>
								<div class="a-p-bt">参与</div>
							</div>
							<div class="aimg-top">
								<div class="aimg-bg"></div>
								<div class="aimg-font">
									<p>免费</p>
								</div>
							</div>
						</a>
					</div>
					<div class="swiper-slide">
						<a href="http://www.wenhuayun.cn/wechatActivity/preActivityDetail.do?activityId=5f78ecc4de8747628d68b86df2091414">
							<img src="${path}/STATIC/wxStatic/image/a2-2.jpg" width="530" height="340"/>
							<div class="a-p">
								<p class="p1">飞扬的旋律 | 六一大联欢</p>
								<p class="p2">五角场下沉式广场</p>
								<p class="p3">5月31日 14:30-16:30</p>
								<div class="a-p-bt">参与</div>
							</div>
							<div class="aimg-top">
								<div class="aimg-bg"></div>
								<div class="aimg-font">
									<p>免费</p>
								</div>
							</div>
						</a>
					</div>
					<div class="swiper-slide">
						<a href="http://www.wenhuayun.cn/wechatActivity/preActivityDetail.do?activityId=8db75ffbe1fb4e8ab6f75afc136ca07f">
							<img src="${path}/STATIC/wxStatic/image/a2-3.jpg" width="530" height="340"/>
							<div class="a-p">
								<p class="p1">六一特辑 | 儿童音乐会</p>
								<p class="p2">长宁民俗文化中心</p>
								<p class="p3">6月1日 13:30-15:00</p>
								<div class="a-p-bt">参与</div>
							</div>
							<div class="aimg-top">
								<div class="aimg-bg"></div>
								<div class="aimg-font">
									<p>免费</p>
								</div>
							</div>
						</a>
					</div>
					<div class="swiper-slide">
						<a href="http://www.wenhuayun.cn/wechatActivity/preActivityDetail.do?activityId=67b88e61820a4c23ba6515ffba6933c5">
							<img src="${path}/STATIC/wxStatic/image/a2-4.jpg" width="530" height="340"/>
							<div class="a-p">
								<p class="p1">童年童梦七彩秀，儿童节专场演出</p>
								<p class="p2">五里桥社区文化活动中心</p>
								<p class="p3">5月28日 14:00-15:30</p>
								<div class="a-p-bt">参与</div>
							</div>
							<div class="aimg-top">
								<div class="aimg-bg"></div>
								<div class="aimg-font">
									<p>免费</p>
								</div>
							</div>
						</a>
					</div>
					<div class="swiper-slide">
						<a href="http://www.wenhuayun.cn/wechatActivity/preActivityDetail.do?activityId=65ddf49a694c43fcb371b6a1d3612b5c">
							<img src="${path}/STATIC/wxStatic/image/a2-5.jpg" width="530" height="340"/>
							<div class="a-p">
								<p class="p1">儿童画作品 | 我的世界你不懂</p>
								<p class="p2">群众艺术馆1楼</p>
								<p class="p3">5月23日-6月8日 9:00-17:00</p>
								<div class="a-p-bt">参与</div>
							</div>
							<div class="aimg-top">
								<div class="aimg-bg"></div>
								<div class="aimg-font">
									<p>免费</p>
								</div>
							</div>
						</a>
					</div>
				</div>
			</div>
			<div class="sw-title">
				<p>&mdash;&nbsp;创意狂欢&nbsp;&mdash;</p>
			</div>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<a href="http://www.wenhuayun.cn/wechatActivity/preActivityDetail.do?activityId=c97b9285c3ed4497b2d6f158ea98859a">
							<img src="${path}/STATIC/wxStatic/image/a3-1.jpg" width="530" height="340"/>
							<div class="a-p">
								<p class="p1">快乐的向日葵，幼儿创意美术活动</p>
								<p class="p2">普陀区少年儿童图书馆</p>
								<p class="p3">5月28日 10:00-11:00</p>
								<div class="a-p-bt">参与</div>
							</div>
							<div class="aimg-top">
								<div class="aimg-bg"></div>
								<div class="aimg-font">
									<p>免费</p>
								</div>
							</div>
						</a>
					</div>
					<div class="swiper-slide">
						<a href="http://www.wenhuayun.cn/wechatActivity/preActivityDetail.do?activityId=c7445da8a9f846d3b78e0301b59c692f">
							<img src="${path}/STATIC/wxStatic/image/a3-2.jpg" width="530" height="340"/>
							<div class="a-p">
								<p class="p1">六一亲子嘉年华</p>
								<p class="p2">浦东新区高桥镇</p>
								<p class="p3">5月28日 14:00-16:30</p>
								<div class="a-p-bt">参与</div>
							</div>
							<div class="aimg-top">
								<div class="aimg-bg"></div>
								<div class="aimg-font">
									<p>免费</p>
								</div>
							</div>
						</a>
					</div>
					<div class="swiper-slide">
						<a href="http://www.wenhuayun.cn/wechatActivity/preActivityDetail.do?activityId=be2541d62e21461295d77072a8ec8f88">
							<img src="${path}/STATIC/wxStatic/image/a3-3.jpg" width="530" height="340"/>
							<div class="a-p">
								<p class="p1">美丽梦想 东方起航</p>
								<p class="p2">陆家嘴金融城文化中心</p>
								<p class="p3">5月29日 9:00-11:30</p>
								<div class="a-p-bt">参与</div>
							</div>
							<div class="aimg-top">
								<div class="aimg-bg"></div>
								<div class="aimg-font">
									<p>免费</p>
								</div>
							</div>
						</a>
					</div>
					<div class="swiper-slide">
						<a href="http://www.wenhuayun.cn/wechatActivity/preActivityDetail.do?activityId=13eb58cc2daf4848b82530b2bd039791">
							<img src="${path}/STATIC/wxStatic/image/a3-4.jpg" width="530" height="340"/>
							<div class="a-p">
								<p class="p1">玩嗨六一 | 浦江小朋友准备好了吗？</p>
								<p class="p2">浦江城市生活广场</p>
								<p class="p3">5月29日 13:30-15:30</p>
								<div class="a-p-bt">参与</div>
							</div>
							<div class="aimg-top">
								<div class="aimg-bg"></div>
								<div class="aimg-font">
									<p>免费</p>
								</div>
							</div>
						</a>
					</div>
					<div class="swiper-slide">
						<a href="http://www.wenhuayun.cn/wechatActivity/preActivityDetail.do?activityId=e822534c9f464d4cb4126de860ee2841">
							<img src="${path}/STATIC/wxStatic/image/a3-5.jpg" width="530" height="340"/>
							<div class="a-p">
								<p class="p1">声音档案 | 亲子共读，温馨记录</p>
								<p class="p2">松江区图书馆</p>
								<p class="p3">5月9日-5月30日 8:30-20:00</p>
								<div class="a-p-bt">参与</div>
							</div>
							<div class="aimg-top">
								<div class="aimg-bg"></div>
								<div class="aimg-font">
									<p>免费</p>
								</div>
							</div>
						</a>
					</div>
				</div>
			</div>
			<a href="http://www.wenhuayun.cn/information/preInfo.do?informationId=14743790608a46aa9a3b83567399da60">
				<div class="rule" id="ruleDiv">
					<p>有一种潮流叫做秀“娃” 晒出萌娃最可爱的瞬间  ></p>
				</div>
			</a>
			<div class="grid"></div>
			<div class="pb-on">
				<div class="swiper-container2">
					<div class="swiper-wrapper" id="seriesImgDetail"></div>
					<!--分页器-->
					<div class="swiper-pagination"></div>
				</div>
			</div>
		</div>
		<div class="tk-pic" onclick="uploadImg();">
			<img src="${path}/STATIC/wxStatic/image/photo.png" />
		</div>
	</div>

	<script type="text/javascript">
		$(document).ready(function() {
			//顶部菜单显示隐藏
			$(window).scroll(function() {
				if ($(document).scrollTop() > 100) {
					$(".header").css("top", "0px")
				} else {
					$(".header").css("top", "-100px")
				}
			})
			
			//滑屏分页
	        $(window).on("scroll", function () {
	            var scrollTop = $(document).scrollTop();
	            var pageHeight = $(document).height();
	            var winHeight = $(window).height();
	            if (scrollTop >= (pageHeight - winHeight)-30) {
	           		startIndex += 20;
	           		var index = startIndex;
	           		setTimeout(function () { 
	           			loadImg(index, 20);
	           		},300);
	            }
	        });
		});
		
		//swiper初始化
		var mySwiper = new Swiper('.swiper-container', {
			slidesPerView: 1.4,
			paginationClickable: true,
			spaceBetween: 20,
			freeMode: false
		})
			
	</script>
	
	<!-- 导入统计文件 -->
	<script type="text/javascript" src="${path}/stat/stat.js"></script>
	<%@include file="/WEB-INF/why/wechat/wechat_statistics.jsp"%>
</body>
</html>