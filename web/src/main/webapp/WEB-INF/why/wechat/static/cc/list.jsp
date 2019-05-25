<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>互联网+公共文化服务主题研讨会</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/cc/css/style.css?v=3131777"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '互联网+公共文化服务主题研讨会';
	    	appShareDesc = '11月19日-21日';
	    	appShareImgUrl = '${basePath}/STATIC/wx/image/share_120.png';
	    	appShareLink = '${basePath}/cc/index.do';
	    	
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
					title: "互联网+公共文化服务主题研讨会",
					desc: '11月19日-21日',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
					link: '${basePath}/cc/index.do'
				});
				wx.onMenuShareTimeline({
					title: "互联网+公共文化服务主题研讨会",
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
					link: '${basePath}/cc/index.do'
				});
				wx.onMenuShareQQ({
					title: "互联网+公共文化服务主题研讨会",
					desc: '11月19日-21日',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
					link: '${basePath}/cc/index.do'
				});
				wx.onMenuShareWeibo({
					title: "互联网+公共文化服务主题研讨会",
					desc: '11月19日-21日',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
					link: '${basePath}/cc/index.do'
				});
				wx.onMenuShareQZone({
					title: "互联网+公共文化服务主题研讨会",
					desc: '11月19日-21日',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
					link: '${basePath}/cc/index.do'
				});
			});
		}
		
		$(function () {
			
			//加载评论
			loadComment();
			
			//显示输入弹窗
			$("#ccUserInputShow").click(function(e){
				if (userId == null || userId == '') {
		    		//判断登陆
		        	publicLogin('${basePath}cc/list.do');
		    	}else{
		    		e.stopPropagation();
					$("#ccUserInput").show();
		    	}
			})
			
			//隐藏输入弹窗
			$("#ccUserInput").click(function(){
				$(this).hide();
				$("#userComment").val("");
			})
			
			//输入弹窗冒泡事件
			$(".ccUserInputDiv input,.ccUserInputDiv div").click(function(e){
				e.stopPropagation();
			})
			
			$(".ccMenu>div>ul>li").click(function() {
				$(".ccMenu>div>ul>li").removeClass("menuBtnOn")
				$(this).addClass("menuBtnOn")
				$(".ccMenuList>ul>li").hide()
				$(".ccMenuList>ul>li").eq($(this).index()).show()
			})
			
			//菜单顶部固定
			$(document).on('scroll', function() {
				if($(document).scrollTop() > 250) {
					$("#topMenu").css('position', 'fixed')
				} else {
					$("#topMenu").css('position', 'relative')
				}
			})

			//下拉菜单
			$(".meetingBtn").click(function() {
				if($(this).hasClass('out')) {
					$(".meetingBtn").find('img').removeClass('rotate')
					$(".meetingBtn").removeClass('out')
					$(".meetingBtn").next('div').slideUp()
				} else {
					$(".out").next('div').slideUp()
					$(".meetingBtn").find('img').removeClass('rotate')
					$(".meetingBtn").removeClass('out')
					$(this).find('img').addClass('rotate')
					$(this).addClass('out')
					$(this).next('div').slideDown()

				}
			})

			//会议新闻宽度
			$(".news>ul").css('width', $(".news>ul>li").length * 382);
			
			$(".news ul li").click(function() {
				$(document).attr("title",$(this).find("p").text());
				
				$(".ccMain").hide()
				$(".ccDetailMain").eq($(this).index()).show()
				$('body,html').animate({
					scrollTop: 0
				}, 0);
			})
			
			// 会议内容 --> 信息查询
			function setStopPropagation(evt) {
				var e = evt || window.event;
				if(typeof e.stopPropagation == 'function') {
					e.stopPropagation();
				} else {
					e.cancelBubble = true;
				}	
			}
			$('.hynr .hy_2 a').bind('click', function (evt) {
				setStopPropagation(evt);
				$('.hynr .nrxial').stop().slideToggle(200);
			});
			$('html , body').bind('click', function () {
				$('.hynr .nrxial').stop().slideUp(200);
			});			
			
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
			
			
			
			$(".background-fx2").click(function() {
				$("html,body").removeClass("bg-notouch");
				$(".background-fx2").css("display", "none")
			})
		});
		
		function downloadFile(link){
				if (!is_weixin()) {
					window.location.href = link;
				}else{
					$("html,body").addClass("bg-notouch");
					$(".background-fx2").css("display", "block");
				};
		}
		
		//签到
		function toSign(){
			if (userId == null || userId == '') {
	    		//判断登陆
	        	publicLogin('${basePath}cc/sign.do');
	    	}else{
	            window.location.href = '${path}/cc/sign.do';
	    	}
		}
		
		//头像
		function getUserHeadImgHtml(userHeadImgUrl){
			var userHeadImgHtml = '';
			if(userHeadImgUrl){
                if(userHeadImgUrl.indexOf("http") == -1){
                	userHeadImgUrl = getImgUrl(userHeadImgUrl);
                }
            }else{
            	userHeadImgUrl = '';
            }
			if (userHeadImgUrl.indexOf("http") == -1) {
            	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png' width='64' height='64'/>";
            } else if (userHeadImgUrl.indexOf("/front/") != -1) {
                var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
                userHeadImgHtml = "<img src='" + imgUrl + "' onerror='imgNoFind();' width='64' height='64'/>";
            } else {
            	userHeadImgHtml = "<img src='" + userHeadImgUrl + "' onerror='imgNoFind();' width='64' height='64'/>";
            }
			return userHeadImgHtml;
		}
		
		//评论列表
		function loadComment(){
			$.post("${path}/cc/getAllCcComment.do",function (data) {
				$("#commentList").html("");
				$.each(data, function (i, dom) {
					var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
					$("#commentList").append("<div class='xianchd clearfix'>" +
												"<div class='xchd_l'>"+userHeadImgHtml+"</div>" +
												"<div class='xchd_r'>" +
													"<div class='name'>"+dom.userName+"</div>" +
													"<div class='time'>"+dom.createTime.substring(5,16)+"</div>" +
													"<p>"+dom.commentRemark+"</p>" +
												"</div>" +
											 "</div>");
				});
    		},"json");
		}
		
		//评论
		function userComment(){
			if (userId == null || userId == '') {
	    		//判断登陆
	        	publicLogin('${basePath}cc/list.do');
	    	}else{
	    		var userComment = $("#userComment").val();
	    		if(userComment == ""){
			    	dialogAlert('系统提示', '请输入评论！');
			        return false;
			    }
				var data = {
					commentRemark:userComment,
					userId:userId
				}
	    		$.post("${path}/cc/saveComment.do",data, function (data) {
	    			if(data == "200"){
	    				dialogConfirm('系统提示', "评论成功！",function(){
	    					$("#ccUserInput").hide();
	    					$("#userComment").val("");
	    					//加载评论
	    					loadComment();
	    				});
	    			}else if(data == "500"){
	    				dialogAlert('系统提示', "评论失败！");
	    			}
	    		},"json");
	    	}
		}
	</script>
	
	<style>
		a{color: #666666;}
		.skyzhuanqu {text-align: center;margin-bottom: 40px;}
		.numList {padding-left: 60px;}		
		.numList>li {list-style: decimal;font-size: 40px;}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wx/image/share_120.png"/></div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
	</div>
	<div class="background-fx2" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/cc/image/toSafari.png" style="width: 100%;height: 100%;" />
	</div>
	<div class="ccMain" style="overflow: hidden;">
		<div>
			<img src="${path}/STATIC/cc/image/banner.png" />
		</div>
		<div class="ccMenu" style="height: 71px;">
				<div id="topMenu" style="position: relative;left: 0;right: 0;top: 0;background-color: #fff;overflow: hidden;padding: 0 20px;overflow-x: scroll;overflow-y: hidden;height:71px;-webkit-overflow-scrolling : touch;">
					<ul style="width: 900px;">
						<li class="menuBtnOn">会议指南</li>
						<li>日程安排</li>
						<li>资料共享</li>
						<li onclick="location='http://www.1meeting.cn/mobile/customactive/&id=3481'">会议直播</li>
						<li>互联体验</li>
						<li>服务保障</li>

						<div style="clear:both ;"></div>
					</ul>
				</div>
			</div>
		<div class="ccMenuList">
			<ul>
				<li style="display: block;padding-top: 30px;">
					<div style="border-bottom: 15px solid #f5f5f5;">
						<div class="ccUpDetail">
							<div class="meetingBtn">
								<span style="float: left;">参会要求</span>
								<img style="float: right;margin-right: 20px;" src="${path}/STATIC/cc/image/arrow.png" />
								<div style="clear: both;"></div>
							</div>
							<div class="meetingFont">
								<ul class="numList">
									<li>请各位代表提前熟悉本指南，了解整个活动的安排；</li>
									<li>请佩戴统一印发的嘉宾证、代表证、媒体证、工作证等相应证卡参会；</li>
									<li>请提前15分钟到达指定活动现场参加活动；</li>
									<li>请将手机和平板电脑关闭或置于静音状态；</li>
									<li>活动全过程提倡无烟，所有活动现场均为无烟场所，请勿吸烟；</li>
									<li>请随时关注会务组有关活动和会务的临时通知；</li>
									<li>未经主办方同意，任何机构和个人请勿在活动现场自行组织其他集体活动或发放自带资料；</li>
									<li>会议将开设大会微信服务号，分享本次会议拍摄的视频、会议资料，共享期为1个月；</li>
									<li>本次会议将开设网络直播通道，可在线参与互动；</li>
									<li>有任何需要帮助的，请与会务组联络。</li>
								</ul>
							</div>
						</div>
						<div class="ccUpDetail">
							<div class="meetingBtn">
								<span style="float: left;">报到及离会</span>
								<img style="float: right;margin-right: 20px;" src="${path}/STATIC/cc/image/arrow.png" />
								<div style="clear: both;"></div>
							</div>
							<div class="meetingFont">
								<ul class="numList">
									<li>报到地点：<br />上海市嘉定区博乐南路125号蓝宫大饭店; 上海市嘉定区清河路150号迎园饭店。</li>
									<li>报到时间：2016年11月9日8:30至22:30。在此时间段之后报到的代表，请直接至蓝宫大饭店或迎园饭店的大堂补办报到手续。报到时，请领取会务证卡和相关会务资料。</li>
									<li>离会时间：2016年11月11日下午。各参会代表自行至蓝宫大饭店或迎园饭店大堂前台退房卡，办理退房手续。</li>
								</ul>
							</div>
						</div>
						<div class="ccUpDetail">
							<div class="meetingBtn">
								<span style="float: left;">住宿安排</span>
								<img style="float: right;margin-right: 20px;" src="${path}/STATIC/cc/image/arrow.png" />
								<div style="clear: both;"></div>
							</div>
							<div class="meetingFont">
								<ul class="numList">
									<li>大会代表指定入住上海市嘉定区蓝宫大饭店或迎园饭店，住宿费由会务组承担。</li>
									<li>办理住宿手续时间：<br />11月9日8:30至17:30<br />11月10日8:30至17:30</li>
									<li>非指定酒店住宿的代表，自行承担住宿费并安排交通工具，请熟悉大会日程安排和交通路线，准时参加各项活动。</li>
									<li>请妥善保管好自己的现金和贵重行李物品。</li>
								</ul>
							</div>
						</div>
						<div class="ccUpDetail">
							<div class="meetingBtn">
								<span style="float: left;">会务接待</span>
								<img style="float: right;margin-right: 20px;" src="${path}/STATIC/cc/image/arrow.png" />
								<div style="clear: both;"></div>
							</div>
							<div class="meetingFont">
								<ul class="numList">
									<li>会务组联系人<br />上海市嘉定区文化广播影视管理局办公室副主任陶雪飞，手机号：13611909989。<br />上海创图网络科技股份有限公司市场部经理高玲，手机号：18821217088。</li>
									<li>接待组联系人<br />上海市嘉定区文化广播影视管理局办公室主任陆健，手机号：13601825882。</li>
								</ul>
							</div>
						</div>
						<div class="ccUpDetail">
							<div class="meetingBtn">
								<span style="float: left;">就餐安排</span>
								<img style="float: right;margin-right: 20px;" src="${path}/STATIC/cc/image/arrow.png" />
								<div style="clear: both;"></div>
							</div>
							<div class="meetingFont">
								<p>11月9日17:00至11月11日13：30期间，参会代表凭会务证卡，在蓝宫大饭店中餐厅就餐。</p>
								<p>就餐时间：早餐6:00-8:00；中餐11:30-13:00；晚餐17:00-19:00。</p>
							</div>
						</div>
						<div class="ccUpDetail">
							<div class="meetingBtn">
								<span style="float: left;">交通安排</span>
								<img style="float: right;margin-right: 20px;" src="${path}/STATIC/cc/image/arrow.png" />
								<div style="clear: both;"></div>
							</div>
							<div class="meetingFont">
								<p>会务组安排专车，负责参会人员机场至住宿地，以及往返饭店和活动现场。</p>
								<p>联系人：上海市嘉定区文化广播影视管理局办公室主任 陆健，手机号：13601825882；上海创图网络科技股份有限公司高玲，手机号：18821217088。</p>
							</div>
						</div>
						<div class="ccUpDetail">
							<div class="meetingBtn" style="border: none;">
								<span style="float: left;">防灾应急</span>
								<img style="float: right;margin-right: 20px;" src="${path}/STATIC/cc/image/arrow.png" />
								<div style="clear: both;"></div>
							</div>
							<div class="meetingFont">
								<p>会场和饭店应急疏散方案，参见现场公示。</p>
							</div>
						</div>
					</div>
					<div style="padding: 30px 20px 10px;">
						<div style="font-size: 30px;color: #262626;border-bottom: 1px solid #ccc;padding-bottom: 20px;">
							<span>背景新闻</span>
						</div>
						<div class="news" style="overflow-x: scroll;-webkit-overflow-scrolling : touch;margin-top: 20px;">
							<ul>
								<li>
									<img src="${path}/STATIC/cc/image/news4.jpg" width="360" height="230" />
									<p>主题区域文化联动活动</p>
								</li>
								<li>
									<img src="${path}/STATIC/cc/image/news1.jpg" width="360" height="230" />
									<p>文化嘉定云,让市民与文化更亲密</p>
								</li>
								<li>
									<img src="${path}/STATIC/cc/image/p1.jpg" width="360" height="230" />
									<p style="">“文化云”让公共文化服务更智能</p>
								</li>
								<li>
									<img src="${path}/STATIC/cc/image/p2.jpg" width="360" height="230" />
									<p style="">上海市民文化节推出公共文化“云”</p>
								</li>
								<li>
									<img src="${path}/STATIC/cc/image/p4.jpg" width="360" height="230" />
									<p>上海嘉定有了文化淘宝</p>
								</li>
								<li>
									<img src="${path}/STATIC/cc/image/p3.jpg" width="360" height="230" />
									<p>我们的幸福指数提高了</p>
								</li>
								
								<div style="clear: both;"></div>
							</ul>
						</div>
					</div>
					<div style="padding: 30px 20px 10px;">
						<div style="font-size: 30px;color: #262626;border-bottom: 1px solid #ccc;padding-bottom: 20px;">
							<span>现场互动</span>
						</div>
						<div id="commentList"></div>
					</div>
					<div class="hynr_wc">
						<div class="hynr clearfix">
							<div class="hy_1">
								<a id="ccUserInputShow" href="javascript:;"><img src="${path}/STATIC/cc/image/pic10.png" />评论</a>
								<a href="javascript:;" class="shareBtn"><img src="${path}/STATIC/cc/image/pic12.png" />分享</a>
							</div>
							<div class="hy_2">
								<a href="javascript:;">信息查询</a>
							</div>
							<div class="nrxial">
								<div class="xianc clearfox">
									<div class="item" style="margin:0 70px" onclick="$('#setmap').show()">
										<div class="nc">
											<img src="${path}/STATIC/cc/image/pic13.png" />
											<p>会场座位</p>
										</div>
									</div>
									<div class="item" style="margin:0 70px">
										<div class="nc" onclick="location.href = '${path}/cc/sign.do'">
											<img src="${path}/STATIC/cc/image/pic14.png" />
											<p>参观跟车号</p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="ccUserInput" id="ccUserInput">
						<div class="ccUserInputDiv">
							<input id="userComment" type="text" maxlength="500"/>
							<div class="ccUserInputBtn" onclick="userComment();">发布</div>
							<div style="clear: both;"></div>
						</div>
					</div>
				</li>
				<li>
					<div class="ccItinerary">
						<%-- <div>
							<img src="${path}/STATIC/cc/image/pic4.jpg" />
						</div> --%>
						<div class="tabDiv">
							<table width="695" style="text-align: center;">
								<tbody>
									<tr style="color: #fff;">
										<td rowspan="2" width="120" style="vertical-align: middle;background-color: #00b0ec;"><strong>日期</strong></td>
										<td colspan="2" style="background-color: #00b0ec;"><strong>具体安排</strong></td>
										<td rowspan="2" style="vertical-align: middle;background-color: #00b0ec;"><strong>地点</strong></td>
									</tr>
									<tr style="color: #fff;">
										<td style="vertical-align: middle;background-color: #00b0ec;"><strong>时间</strong></td>
										<td style="background-color: #00b0ec;"><strong>内容</strong></td>
									</tr>
									<tr>
										<td style="vertical-align: middle;">
											<p align="center">11月9日 </p>
											<p>（星期三）</p>
										</td>
										<td style="vertical-align: middle;">全天</td>
										<td style="vertical-align: middle;"><strong>报到</strong></td>
										<td style="vertical-align: middle;">
											<p align="middle">蓝宫大饭店、迎园饭店</p>
										</td>
									</tr>
									<tr>
										<td rowspan="2" style="vertical-align: middle;">
											<p align="center">11月10日 </p>
											<p>（星期四）</p>
										</td>
										<td style="vertical-align: middle;">8:30-11:00</td>
										<td>
											<p align="left"><strong>“互联网+公共文化服务”经验交流会： </strong><br /> 1、领导致词 <br /> 2、文化部领导讲话 <br /> 3、交流发言 <br /> 4、专家点评</p>
											</td>
										<td style="vertical-align: middle;">
											<p align="middle">上海蓝宫大饭店<br />多功能厅</p>
										</td>
									</tr>
									<tr>
										<td style="vertical-align: middle;">13:00-17:00</td>
										<td>
											<p align="left"><strong>现场观摩：（与会人员分三批交叉进行）</strong></p>
											<p align="left">1、上海市嘉定区菊园新区社区文化活动中心 </p>
											<p align="left">2、上海市嘉定区图书馆（嘉定区文化馆）</p>
											<p align="left">3、“文化上海云”技术支持中心</p>
										</td>
										<td style="vertical-align: middle;">
											<p align="middle">上海市嘉定<br />区和静安区</p>
										</td>
									</tr>
									<tr>
										<td rowspan="2" style="vertical-align: middle;">
											<p align="center">11月11日 </p>
											<p>（星期五）</p>
										</td>
										<td style="vertical-align: middle;">9:00-11:30</td>
										<td>
											<p align="left"><strong>“互联网+公共文化服务”专题研讨会 </strong> </p>
											<p align="left">1、专题报告</p>
											<p align="left">2、专家观点</p>
										</td>
										<td style="vertical-align: middle;">
											<p align="middle">蓝宫大饭店<br />多功能厅</p>
										</td>
									</tr>
									<tr>
										<td style="vertical-align: middle;">13:30-16:30</td>
										<td style="vertical-align: middle;"><strong>离会</strong></td>
										<td>&nbsp;</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</li>
				<li>
					<div class="ccData">
						<ul>
							<li>
								<div>
									<div class="tabTitle">推进公共数字文化建设工作</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/word.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料1</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="location.href='${path}/STATIC/cc/18.html'">查看</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							<li>
								<div>
									<div class="tabTitle">文化云端生活在嘉定</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/word.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料2</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="location.href='${path}/STATIC/cc/1.html'">查看</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							<li>
								<div>
									<div class="tabTitle">浙江省嘉兴市交流材料</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/word.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料3</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="location.href='${path}/STATIC/cc/2.html'">查看</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							<li>
								<div>
									<div class="tabTitle">山东省东营市交流材料</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/word.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料4</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="location.href='${path}/STATIC/cc/3.html'">查看</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							<li>
								<div>
									<div class="tabTitle">四川省成都市交流材料</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/word.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料5</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="location.href='${path}/STATIC/cc/4.html'">查看</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							<li>
								<div>
									<div class="tabTitle">河北省秦皇岛市交流材料</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/word.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料6</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="location.href='${path}/STATIC/cc/5.html'">查看</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							<li>
								<div>
									<div class="tabTitle">安徽省马鞍山市文化馆</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/word.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料7</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="location.href='${path}/STATIC/cc/6.html'">查看</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							<li>
								<div>
									<div class="tabTitle">青海省格尔木市人民政府</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/word.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料8</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="location.href='${path}/STATIC/cc/7.html'">查看</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							<li>
								<div>
									<div class="tabTitle">山东省烟台市文化广电新闻出版局</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/word.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料9</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="location.href='${path}/STATIC/cc/8.html'">查看</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							<li>
								<div>
									<div class="tabTitle">云南省楚雄州图书馆</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/word.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料10</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="location.href='${path}/STATIC/cc/9.html'">查看</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							<li>
								<div>
									<div class="tabTitle">广东省佛山市图书馆</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/word.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料11</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="location.href='${path}/STATIC/cc/10.html'">查看</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
								
							<li>
								<div>
									<div class="tabTitle">辽宁省盘锦市文化广电局</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/word.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料12</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="location.href='${path}/STATIC/cc/11.html'">查看</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							<li>
								<div>
									<div class="tabTitle">山西省晋中市文化局</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/word.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料13</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="location.href='${path}/STATIC/cc/12.html'">查看</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							<li>
								<div>
									<div class="tabTitle">陕西省铜川市文化广电新闻出版局</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/word.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料14</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="location.href='${path}/STATIC/cc/13.html'">查看</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							<li>
								<div>
									<div class="tabTitle">安康市江津区文化委员会</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/word.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料15</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="location.href='${path}/STATIC/cc/14.html'">查看</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							<li>
								<div>
									<div class="tabTitle">云南省曲靖市文化体育局</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/word.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料16</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="location.href='${path}/STATIC/cc/15.html'">查看</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>	
							<li>
								<div>
									<div class="tabTitle">天津市滨海新区文化广播电视局</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/word.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料17</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="location.href='${path}/STATIC/cc/16.html'">查看</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							<li>
								<div>
									<div class="tabTitle">文化嘉定云大会交流</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/ppt.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料18</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="downloadFile('http://oss-cn-hangzhou.aliyuncs.com/culturecloud/video/20161111134719RsXXtjyftGr5Owtc2EYs20ROluSrms.pptx')">下载</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							<li>
								<div>
									<div class="tabTitle">互联网＋公共文化服务-山东东营暂定稿</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/ppt.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料19</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="downloadFile('http://oss-cn-hangzhou.aliyuncs.com/culturecloud/video/2016111113492052KYHZvc988jfF7Dvr3af7SQ65DDEd.pptx')">下载</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							<li>
								<div>
									<div class="tabTitle">互联网+公共文化服务-成都市文广新局</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/ppt.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料20</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="downloadFile('http://oss-cn-hangzhou.aliyuncs.com/culturecloud/video/20161111134946jj893U560Tv062rAMgeyDW9pOmwiaG.ppt')">下载</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							<li>
								<div>
									<div class="tabTitle">嘉兴在上海嘉定“互联网+公共文化服务”经验交流会</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/ppt.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月10日会议资料21</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="downloadFile('http://oss-cn-hangzhou.aliyuncs.com/culturecloud/video/20161111134811jiWj5y9f89DWtmitNqNou27V6FRpaE.pptx')">下载</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							
							
							<li>
								<div>
									<div class="tabTitle">戴剑飚：连接改变未来</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/ppt.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月11日会议资料1</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="downloadFile('http://culturecloud.oss-cn-hangzhou.aliyuncs.com/vod/%E8%BF%9E%E6%8E%A5%E6%94%B9%E5%8F%98%E6%9C%AA%E6%9D%A5%EF%BC%88%E6%88%B4%E5%89%91%E9%A3%9A%EF%BC%89-new.pptx')">下载</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							
							<li>
								<div>
									<div class="tabTitle">“文化云”项目负责人专题报告</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/word.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月11日会议资料2</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="location.href='${path}/STATIC/cc/20.html'">查看</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							<li>
								<div>
									<div class="tabTitle">数字文化公共服务</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/pdf.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月11日会议资料3</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="downloadFile('http://culturecloud.oss-cn-hangzhou.aliyuncs.com/vod/%E6%95%B0%E5%AD%97%E6%96%87%E5%8C%96%E5%85%AC%E5%85%B1%E6%9C%8D%E5%8A%A1.pdf')">下载</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							<li>
								<div>
									<div class="tabTitle">回应需求与有效供给</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/word.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月11日会议资料4</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="location.href='${path}/STATIC/cc/19.html'">查看</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
							
							<li>
								<div>
									<div class="tabTitle">文化嘉定云专业交流</div>
									<div>
										<div class="ccDataImg">
											<img src="${path}/STATIC/cc/image/ppt.png" />
										</div>
										<div class="ccDataDetail">
											<div class="ccDataTitle">
												<p>11月11日会议资料5</p>
											</div>
											<div class="ccDataBtn">
												<!-- <div class="share">分享</div> -->
												<div class="download" onclick="downloadFile('http://oss-cn-hangzhou.aliyuncs.com/culturecloud/video/20161110154417tB56qMF9aELrLNdqq82RdgzwjivIg.pptx')">下载</div>
												<div style="clear: both;"></div>
											</div>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>
							</li>
						</ul>
					</div>
				</li>
				<li></li>
				<li>
					<div class="actShowList">
						<div onclick="location='http://fxswjr.demo.xiaoi.com/robot-jdwgj-wx/culture!list.action?openid=oMlottx8i1jRf6K5Hv4AYf8Nhmo8&from=singlemessage&isappinstalled=0'">
							<img src="${path}/STATIC/cc/image/pic1.jpg" />
							<div class="actShowListTitle">文化嘉定云</div>
						</div>
						<div onclick="location='http://hs.hb.wenhuayun.cn/wechat/index.do'">
							<img src="${path}/STATIC/cc/image/pic3.jpg" />
							<div class="actShowListTitle">文化上海云</div>
						</div>
					</div>
				</li>
				<li>
					<img src="${path}/STATIC/cc/image/call.png" style="display: block;margin: 50px auto 0;" border="0" usemap="#Map" />
					<map name="Map" id="Map"><area shape="rect" coords="99,181,429,225" onclick="window.location = 'tel:' + 13601825882;" />
						<area shape="rect" coords="104,383,420,429" onclick="window.location = 'tel:' + 18821217088" />
						<area shape="rect" coords="103,583,417,640" onclick="window.location = 'tel:' + 18917701226" />
					</map>
				</li>
			</ul>
		</div>
	</div>
	
	<div class="ccDetailMain" id="ccDetailMain4" style="display: none;height: 100%;width: 100%;margin: auto;background-color: #fff;">
			<div class="backBtn" onclick="$(document).attr('title','互联网+公共文化服务主题研讨会');$('.ccDetailMain').hide();$('.ccMain').show()" style="font-size: 30px;color: #fff;padding: 10px;border: 1px solid #575B5F;border-radius: 10px;background: rgba(160,160,160, 0.5);">返回</div>
			<div class="ccTop">
				<img src="${path}/STATIC/cc/image/news4.jpg" width="750" />
				<p>国家公共文化服务体系示范区“互联网+公共文化服务”主题区域文化联动活动在上海嘉定举办</p>
			</div>
			<div class="ccDetail">
				<p>2016年11月9日至11日，由文化部公共文化司、上海市文化广播影视管理局、上海市嘉定区人民政府主办，上海市嘉定区文化广播影视管理局、上海创图网络科技股份有限公司承办的国家公共文化服务体系示范区“互联网+公共文化服务”主题区域文化联动活动在上海市嘉定区举办。 此次活动是文化部组织示范区创建城市“互学、互评、互促”的一项重要内容，旨在总结交流各示范区创建城市在公共数字文化建设方面的典型做法和经验，研讨“互联网+公共文化服务”的具体措施，推进各示范区创建城市公共数字文化建设工作。</p>
				<br />
				<p>活动期间，组织召开了“互联网+公共文化服务”经验交流会和专题研讨会，上海市嘉定区、浙江省嘉兴市、山东省东营市、四川省成都市等国家公共文化服务体系示范区创建城市代表分别介绍了本地推进公共数字文化建设的具体做法，上海市图书馆、嘉定区文化广播影视管理局相关负责同志以及“文化上海云”建设项目负责人作了专题报告，国家公共文化服务体系建设专家委员会专家进行了点评，与会人员围绕活动主题进行了深入研讨。全体参会人员考察了上海市嘉定区图书馆、菊园新区社区文化活动中心、“文化上海云”技术支持中心，实地了解“文化上海云”、“文化嘉定云”的建设和运行情况。</p>
				<br />
				<p>近年来,各地在创建国家公共文化服务体系示范区过程中,高度重视公共数字文化建设,探索形成了一系列各具特色的做法和经验。上海市嘉定区汇聚整合全区公共文化资源，建成了“文化嘉定云”，形成了“网上书房－数字展馆－文化菜单－场馆预订－精品资源”五大板块和综合性“文化分享圈”的“5+1”大服务格局。“文化嘉定云”有效推动公共文化服务实现了 “三个转变”，即从政府单向提供服务到群众自主服务的转变，从简单实体文化数据化工作到智能文化服务的转变，从大而全的文化信息搜罗到关注群体收获、个性化服务定制的转变。浙江省嘉兴市着眼公共文化服务模式创新，运用“互联网+”思维，建成“文化有约”服务平台，嵌入大数据采集和分析处理，精准对接群众文化需求，有效促进了群众参与，提升了公共文化服务效能。山东省东营市着力推进数字文化广场建设，实现了文化广场免费网络覆盖、公共文化远程辅导培训、数字文化资源互联互通，显著提升了基层公共文化设施服务效能。四川省成都市充分利用互联网技术，推进公共文化服务内容创新、服务模式优化。</p>
				<br />
				<p>文化部公共文化司要求各示范区创建城市牢牢把握现代信息技术发展为公共文化建设带来的重要机遇，切实把公共数字文化建设摆上构建现代公共文化服务体系的重要位置，建立健全公共数字文化建设工作机制，深入实施重大公共数字文化工程，不断深化工作交流与合作，加快推进公共数字文化建设。</p>
				<br />
				<p>文化部公共文化司、文化部全国公共文化发展中心相关负责同志，国家公共文化服务体系建设专家委员会专家和各省（自治区、直辖市）文化厅（局）、国家公共文化服务体系示范区创建城市文化局相关同志共150余人参加此次交流活动。</p>
			</div>
		</div>
	
	
	<div class="ccDetailMain" id="ccDetailMain4" style="display: none;height: 100%;width: 100%;margin: auto;background-color: #fff;">
		<div class="backBtn" onclick="$(document).attr('title','互联网+公共文化服务主题研讨会');$('.ccDetailMain').hide();$('.ccMain').show()" style="font-size: 30px;color: #fff;padding: 10px;border: 1px solid #575B5F;border-radius: 10px;background: rgba(160,160,160, 0.5);">返回</div>
		<div class="ccTop">
			<img src="${path}/STATIC/cc/image/news1.jpg" width="750" />
			<p>文化嘉定云,让市民与文化更亲密</p>
		</div>
		<div class="ccDetail">
			<img src="${path}/STATIC/cc/image/news2.jpg" style="display: block;margin: auto;width: 670px;" /><br />
			<img src="${path}/STATIC/cc/image/news3.jpg" style="display: block;margin: auto;width: 670px;" /><br />
			<p>国家文化部“互联网+公共文化服务”主题区域联动活动将于11月9日-11日在嘉定启动。本此活动旨在加强示范区创建城市间的公共文化建设互动交流，总结、提炼各省各地在公共文化服务数字化建设方面的优秀经验和特色， 全面扎实推进国家公共文化服务体系示范区创建工作。</p>
			<br />
			<p>“文化嘉定云”是什么？“文化嘉定云” 是一个信息平台， 通过 “文化嘉定云” 可以打破文化信息的不对称， 文化资源将真正掌握在市民手里， 市民通过 “文化嘉定云” 可以像购物一样， 实现文化产品或服务的选择和消费。目前，“文化嘉定云” 整合了全区所有的公共文化资源， 方便老百姓浏览文化信息、 预定文化活动门票以及预约使用全区公共文化场馆， 让市民足不出户即可分享全区的公共文化资源。</p>
			<br />
			<p style="font-weight: bold;"> 开辟公共文化数字服务阵地</p>
			<br />
			<p>在跨越三年的公共文化数字化建设探索中，“文化嘉定云” 经历了三个转变： 从政府单向提供服务到引导群众自主服务转型； 从数字文化需求机制的分享者向供需平衡的协调者转型； 从追求规模的数字文化资源库建设到关注个性的文化信息服务平台建设转型。在实践中，“文化嘉定云” 以七大服务开辟了一块公共文化的数字服务阵地， 让参与、 享受文化活动成为百姓 “开门第八件事”。</p>
			<br />
			<p>文化活动</p>
			<br />
			<p>信息不对等是公共文化服务均等化之路的绊脚石： 一面是市民、 特别是年轻人对于参与文化活动的需求和渴望， 另一面大量优质公共文化服务不为市民所知造成服务人群狭窄。</p>
			<br />
			<p>嘉定充分利用 “文化嘉定云”， 一网收罗全区区镇两级精彩文化活动，并针对开发网上预约票务模块， 市民参加活动只需通过网络预约， 活动当天直接到现场终端机自助取票即可。该功能最大程度给予市民参与文化活动的便利性和公正性， 激发了市民参与文化活动的热情。</p>
			<br />
			<p>文化众筹</p>
			<br />
			<p>嘉定将 “众筹” 的概念引入公共文化领域， 给民间文化活动发起者提供一个平台， 让他们通过网络向群众征询意见、 募集资金， 以支持文化活动的开办。文化众筹是嘉定依靠群众自身力量办公共文化的一次大胆尝试， 也是嘉定公共文化服务走向社会化的重要路径之一， 为文化类企业、 非政府组织、 群文团队、 甚至个人的社会力量参建公共文化搭建平台， 以此推动全区公共文化服务能力的提量升级。</p>
			<br />
			<p>文化社团</p>
			<br />
			<p>在文化社团中， 普通市民可以轻松建立文化团队， 并进行团队成员招募、 发起文化活动等， 由此引导市民自主开展文化活动， 政府则可退居幕后专心提供服务。同时， 嘉定还设立了文化志愿者专区， 为基层公共文化单位与文化志愿者之间的双向选择搭建桥梁， 促进文化志愿者资源库的形成。</p>
			<br />
			<p>网上书房</p>
			<br />
			<p>为了更加方便市民使用嘉定区图书馆的专业数据库查询服务， 嘉定将中国知网、 万方数据、 维普期刊、 库克音乐等14种国内主流权威信息资源数据库搬上 “文化嘉定云” 平台， 市民通过读者证号一次性绑定， 便可在家中轻松查阅3000余万篇文献资料、200万册中外文电子图书、 110万条数据库信息、 30000部文学作品原声录音、 12000种电子期刊、 13万集教学教辅课件、 8万套教育资源在线试卷、30万首音乐曲目等资源， 成为嘉定市民自我学习的重要平台。</p>
			<br />
			<p>发现故事</p>
			<br />
			<p>一个城市化快速推进、 常住人口近160万的新城， 需要什么样的公共文化服务体系来支撑？在嘉定460多平方公里的土地上， 有限的公共资源如何 “摊” 到各位市民头上， 满足每个人的文化生活需求？用数字化打破时间和地域限制， 无疑开辟了一条新的服务途径。“文化嘉定云” 汇聚、 整合区内地方文献、展览演出、 讲座培训、 原创纪录片资料等公共文化服务资源， 形成具有区域特色的公共数字文化数据库。工作时间冲突的讲座培训， 没领到预约券的心仪演出， 市民只要登录“文化嘉定云” 网站或APP， 便可随时重温形式多样的文化活动。</p>
			<br />
			<p>数字展馆</p>
			<br />
			<p>嘉定拥有嘉定孔庙、 法华塔、 嘉定博物馆、 韩天衡美术馆等诸多历史文化景点， 同时也积聚了大量嘉定竹刻、 名家篆印等文物。嘉定利用虚拟3D技术， 将这些城市的瑰宝真实呈现于网络中， 一方面为市民线上体验公共文化场馆、“零距离”观赏、 把玩文物字画等提供便捷， 另一方面也让市民更加了解全区各大公共文化场所， 使其再添活力， 各文化场馆的知晓率和流通量都较之以往有了大幅提升。</p>
			<br />
			<p style="font-weight: bold;">大数据促进公共文化服务格局</p>
			<br />
			<p>“文化嘉定云” 运行以来， 对于政府、 文化事业单位和市民均产生了巨大影响， 促进了嘉定公共文化服务的标准化、 均等化、 社会化， 使得嘉定公共文化服务能级有了大幅提升。</p>
			<br />
			<p>加速政府改革步伐</p>
			<br />
			<p>“文化嘉定云” 打通了区级之间、区镇两级各个文化单位的公共文化服务， 不仅方便市民最大程度获取文化服务， 也打破了以往各自为战的壁垒，使得全区公共文化服务形成了 “资源整合优化、 服务一口对外” 的姿态， 大幅提升了服务效能。“文化嘉定云” 通过网络环境向市民提供开放、 透明的公共文化服务， 政府不再对资源进行直接配置， 建立起透明规范的公共文化资源供给机制。</p>
			<br />
			<p>倒逼文化单位管理方式变革</p>
			<br />
			<p>在 “文化嘉定云” 上线之前， 嘉定区各文化事业单位侧重点各有不同，特别是在街镇层面上， 各街镇文体中心依据群众基础形成了不同的服务风格， 有的侧重群文创作、 有的侧重图书推广、 有的将重心放在志愿者团队建设上。这种方式虽然让各地充分展现“地域特色”， 但也给文化事业单位的绩效评估带来难度， 个别单位提供的公共服务其实以单位领导偏好为中心， 并非源自公众的需求， 服务质量难以保证。</p>
			<br />
			<p>“文化嘉定云” 将各文化事业单位</p>
			<br />
			<p>提供的文化服务统一晒到网上， 数量、质量服务优劣一目了然， 从宣传文案到活动结果全程展现， 使公共文化服务在对比下形成了竞争性， 最重要的是， 它使服务效果的评判标准统一到唯一一个： 即百姓的选择。</p>
			<br />
			<p>培养市民有序的文化生活方式</p>
			<br />
			<p>普通市民既是公共文化建设的服务对象， 又是公共文化建设的主要力量。市民参加各类文化活动的积极性是城市综合素质的重要指标之一。而 “文化嘉定云” 不仅促进市民积极参建公共文化， 更加促进这方水土文化领域公序良俗的完善。</p>
			<br />
			<p>“文化嘉定云” 将参加文化活动的主动权交给市民， 使过去的 “要我参加” 变成现在的 “我要参加”， 让市民对公共资源更加珍惜。</p>
			<br />
			<p>针对公共文化普遍存在的迟到、 公共场所使用不当等行为， 文化嘉定云以黑名单和积分制度进行制约， 一定程度上促成市民遵守文化场馆和公共场所的行为礼仪。</p>
			<br />
			<p>“文化嘉定云” 实行 “半实名制”， 即线上实名订票， 线下不记名入场， 且支持亲眷好友 “赠票” 功能。项目运行过程中， 同期开展了“我为爸妈订戏票” 等活动， 促进市民亲缘邻里关系。</p>
			<br />
			<p style="font-weight: bold;">吸纳社会力量搭建文化生活开放式平台</p>
			<br />
			<p>“文化嘉定云” 运作三年来， 共发布文化活动预订信息近3000场， 提供演出、 讲座、 展览等活动视频回顾以及精品纪录片500余部， 拥有注册会员6万余名， 近三个月来， 平均日访问量达34万次。</p>
			<br />
			<p>以文化嘉定云平台为核心， 嘉定将继续探索如何利用信息技术， 整合各种社会力量进一步提升嘉定文化活力和公共文化服务能级。</p>
			<br />
			<p>在管理方面， 将面向群文团队开发独立、 个性、 自主的宣传与互动版块， 形成以文化骨干为中心的文化自媒体群落， 营造市民主动参与、 自我服务的良性生态。</p>
			<br />
			<p>在内容方面， 将通过 “文化众筹”等开源性服务模式， 吸引更多社会群体主动参与公共文化， 开展以 “文化圈” 为单位的特色文化体验服务。</p>
			<br />
			<p>在体验方面， 将利用成熟公共网络服务平台， 进一步扩散品牌影响力，为不同年龄段的市民拓展更多服务渠道， 方便百姓自由选用最称心的文化生活 “智慧应用”。</p>
			<br />
			<p>借创建国家公共文化服务体系示范区的东风， 嘉定将继续悉心经营这块 “云集文化” 的试验田， 并本着开放、人本的精神， 以信息技术为市民提供更加公平均衡、 精细高效、 贴心满意的现代式公共文化服务。</p>
		</div>
	</div>
	
	<div class="ccDetailMain" id="ccDetailMain1" style="display: none;height: 100%;width: 100%;margin: auto;background-color: #fff;">
			<div class="backBtn" onclick="$(document).attr('title','互联网+公共文化服务主题研讨会');$('.ccDetailMain').hide();$('.ccMain').show()" style="font-size: 30px;color: #fff;padding: 10px;border: 1px solid #575B5F;border-radius: 10px;background: rgba(160,160,160, 0.5);">返回</div>
			<div class="ccTop">
				<img src="${path}/STATIC/cc/image/p1.jpg" width="750" />
				<p>“文化云”汇聚单位场馆　让公共文化服务更智能</p>
			</div>
			<div class="ccDetail">
				<p style="text-indent:2em;" class="ccDetailFont">7月26日，2016“对话张江”全媒体访谈活动举行第五场，本期对话嘉宾为上海创图网络科技股份有限公司董事长李欣。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">新华网上海7月26日电（记者高少华）上海创图网络科技股份有限公司总裁李欣今日参加“对话张江”全媒体访谈时表示，文化产业正迎来发展“风口”，今年3月份上线的“文化上海云”目前已汇聚本地超过一万家文化机构、单位，通过整合线上线下文化活动信息为用户提供便捷的文化生活服务，接下来公司还将加快拓展全国步伐，打造大数据技术驱动的“文化淘宝”。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">自2014年12月正式上线以来，“文化嘉定云”平台聚合起嘉定区内文化馆、图书馆、博物馆、美术馆的众多服务资源，有效解决了以往公共文化活动信息不对称、设施资源利用率不高的问题。上线至今，其用户量已达到6万人左右。从“大而全”演变为“小而精”，以百姓需求为导向、服务功能不断完善的“文化嘉定云”，让这里的居民切实感受到了“互联网+文化”的种种福利。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">创图是上海市著名商标，上海市的明星企业，在2010年上海世博会期间，曾凭借领先的3DVR技术成为“网上世博会”国内唯一的核心技术提供商，创造了“永不落幕的网上世博会”，引发各界关注。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">“网上世博会”让创图公司在业内声名鹊起，从一家幕后技术团队一下子走到了台前。世博会后，李欣在考虑公司发展道路时觉得，既然能够把世博会几百个国家级的文化场馆搬到互联网上去，那能不能借助已有优势，把全国的文化场馆都搬到互联网上去？这样可以让更多人来访问和体验。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">于是在2013年，创图提出“文化云”建设构想，并和上海市文广局沟通，希望把“网上世博会”模式在上海进行尝试，把上海市所有的博物馆、图书馆、文化馆、活动中心等都陆续搬到互联网上。该模式先是选择在嘉定进行示范，打造了全国第一个数字公共文化平台“嘉定文化云”。在经过“嘉定文化云”的探索和示范后，2016年，包含16个区县和226家社区文体中心的“文化上海云”全面上线运营。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">“文化上海云”的上线和运行，让本市所有的公共文化服务离老百姓更加接近。在此之前，上海市拥有大量的公共文化场地、设施以及活动演出、培训、展览等，但是老百姓对于那些分散、孤立的社会资源并不了解。随着“文化上海云”的上线，解决了用户知道的难题，会有很多老百姓、用户、愿意积极参与相关公共文化活动。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">除了解决信息不对称问题，“文化上海云”同时整合全上海的文化系统资源，使这些文化单位有了自主协调权，像网上开店一样，拥有自己的空间，而且大家也积极上传各自活动信息。目前文化上海云每月有6000-8000场活动，每月服务60-80万人次，一年下来预计可以服务一千万人次。正是在此基础上，创图希望在公共文化服务领域构建一个淘宝模式------“文化淘宝”。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">据李欣介绍，“文化上海云”所提供的公共文化内容和资源，其实以前不是没有，每一个文化馆、图书馆都有自己的网站还有自己的微信公众号，有的还有自己的手机APP，但是各家单位都是只有自己的内容，而且很多东西重复，数据也不连通。文化上海云则是把数据实现互连，把全上海的文化活动、文化资源、文化设施、文化服务等一网打尽，使老百姓通过这个平台可以全部看到。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">近年来上海市积极推进智慧城市建设，“文化上海云”也成为上海智慧城市建设中的一部分。根据上海智慧城市三年行动计划，将通过“文化上海云”把整个上海文化服务、文化生活进行智慧化的管理和服务，老百姓则可以通过这个平台去享受公共文化服务和公益活动等。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">李欣表示，“文化上海云”可视为是政府引进社会力量来参与公共文化服务，引进创图参与上海“互联网＋公共服务”的建设。而依托大数据技术和海量的用户行为分析，安康文化云还能够提供更为精准的文化供需服务。比如根据不同地域、不同时段的用户需求变化，平台可以为其推送不同的文化服务信息。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">自2003年研究生毕业到上海创业，李欣在创业道路上迄今已坚持打拼十余年。针对当前双创热潮，回顾一路走来的创业历程，李欣表示，公司一定要拥有自己的核心技术，每年要投入更多钱在研发上，这样才能使企业在成长过程中，越来越具有核心竞争力和国际竞争力，否则一定会被别人取代。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">2016“对话张江”全媒体访谈活动由上海市张江高新区管委会、中国经济信息社、新华网、上海证券报共同主办；恒丰银行上海分行联合主办。东方网、第一财经频道、东方财经·浦东频道、东方广播中心、第一财经广播、上海东方明珠移动电视为媒体支持。</p><br />
				<p style="text-align: right;">来源：新华社</p>
				<p>2016-07-26 18:42:32</p>
			</div>
		</div>

		<div class="ccDetailMain" id="ccDetailMain2" style="display: none;height: 100%;width: 100%;margin: auto;background-color: #fff;">
			<div class="backBtn" onclick="$(document).attr('title','互联网+公共文化服务主题研讨会');$('.ccDetailMain').hide();$('.ccMain').show()" style="font-size: 30px;color: #fff;padding: 10px;border: 1px solid #575B5F;border-radius: 10px;background: rgba(160,160,160, 0.5);">返回</div>
			<div class="ccTop">
				<img src="${path}/STATIC/cc/image/p2.jpg" width="750" />
				<p>上海市民文化节推出公共文化“云”</p>
			</div>
			<div class="ccDetail">
				<p style="text-indent:2em;" class="ccDetailFont">本报上海3月27日电 （记者曹玲娟）26日，2016年上海市民文化节启动，近千项文化活动在广场、绿地、商圈、地铁等公共场所展开。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">当天，作为全国第一“朵”省级公共文化云的“文化上海云”正式上线。上海780多家市级、区县、街道乡镇三级的文化馆、图书馆、展览馆、美术馆、文化服务中心正式通过互联网整合在一起。了解公共文化场所，预约一场活动，建立兴趣小组……通过手机APP，市民可以定制专属的文化生活。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">　中老年是公共文化的重要服务对象，不善使用电脑、手机的老年人怎么办？据介绍，有的社区一边积极为老年人做培训，一边推出帮家里老年人订票活动，甚至还带动了不少子女陪父母来看戏。上海市文广局副局长王小明说：“建设现代公共文化服务体系，要实现服务手段和方式的现代化，实现文化与科技的融合。”</p><br />
				<p style="text-align: right;">来源：人民日报</p>
				<p>2016-03-28</p>
			</div>
		</div>
		
		<div class="ccDetailMain" id="ccDetailMain3" style="display: none;height: 100%;width: 100%;margin: auto;background-color: #fff;">
			<div class="backBtn" onclick="$(document).attr('title','互联网+公共文化服务主题研讨会');$('.ccDetailMain').hide();$('.ccMain').show()" style="font-size: 30px;color: #fff;padding: 10px;border: 1px solid #575B5F;border-radius: 10px;background: rgba(160,160,160, 0.5);">返回</div>
			<div class="ccTop">
				<img src="${path}/STATIC/cc/image/p4.jpg" width="750" />
				<p>上海嘉定有了文化淘宝</p>
			</div>
			<div class="ccDetail">
				<p style="text-indent:2em;" class="ccDetailFont">
最近，上海市嘉定区的不少市民，手机上增加了一个叫文化嘉定云的软件，只需轻轻一点，就能从这个公共文化服务平台上了解到区内各类文化活动信息。各类高大上的演出票和讲座票，只要出手快，就能轻松搞定。
</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">自2014年12月正式上线以来，文化嘉定云平台聚合起嘉定区内文化馆、图书馆、博物馆、美术馆服务资源，解决了公共文化活动信息不对称、设施资源利用率不高等问题，形成具有区域特色的公共文化服务资源数据库。目前，区、镇两级各类文体活动平均每月挂上文化嘉定云的数量达150场次。</p><br />
				<p class="ccDetailTitle">【用者说】</p>
				<p class="ccDetailTitle">它改变了我们的家庭生活</p>
				<p style="text-indent:2em;" class="ccDetailFont">市民庄敏：单位订了《嘉定报》，我最开始就是在这上面了解到有个文化嘉定云的。于是我就试着在手机上下了个文化嘉定云APP，没想到，它改变了我们的家庭生活。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">我们家以前很少参加文化活动，偶尔看场电影。现在我们通过文化嘉定云订了好多场演出的票，一个月起码要去看一次戏。我还总在同事当中宣传文化嘉定云，鼓励大家去下载，结果我身边的朋友现在都用上了。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">记得当时抢到的第一张票，是沪剧《挑山女人》，当时就觉得唱得特别好，后来才知道这部戏获了好多奖。前两年抢票没现在这么紧张，我连着看了两遍。父母喜欢看锡剧，我和妹妹就陪父母去看了《珍珠塔》。夜里看完戏，一家人从戏院走出来，感觉特别好。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">现在这个文化嘉定云已经走进了我们的日常生活，基本上天天都要刷一下，看看有什么新内容。一旦发布了好的演出信息，我就马上联系妹妹，大家一起抢票。其实，这也增进了家庭和睦，让我们有更多时间陪老人。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">我感觉，现在嘉定的公共文化设施漂亮，里面演的戏也好，发生了很大的变化，用文化嘉定云预订演出也很方便，真的是今非昔比。</p><br />
				<p class="ccDetailTitle">【办者说】</p>
				<p class="ccDetailTitle">用互联网踢开信息不对称的绊脚石</p>
				<p style="text-indent:2em;" class="ccDetailFont">区文化馆馆长李辉：我做群众文化工作已经16年。这些年来，真的可以用遽变来形容。16年前，我刚刚进到文化馆当群文老师，那时文化馆一年就做几个主题活动，最多每年再创排几个小节目就可以了，非常轻松。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">轻松是轻松，却没有成就感。以前安排一场文化活动，几乎由文化单位一手操办，组织节目、定个时间，再邀请好观众，端茶倒水送礼品，为吸引人气煞费苦心，却还常常是剃头挑子一头热。很多观众大老远地组织过来，不是来看节目的，他们领了小毛巾、小牙膏，也不知道台上有什么节目，只要不感兴趣，中途就走了，到了结束时，剩不下几个人。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">我们一直希望找到一种方式把活动真正搞起来，真正得到老百姓的喜爱。于是，大家就去调研，问题主要出在哪里。调研下来发现，还是信息不对称。很多市民特别是年轻人渴望参加文化活动，却无法及时获取信息，一些热门的公共文化活动，领票又不方便。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">我们的转变，主要就体现在文化嘉定云，通过这个信息平台的搭建，让信息对称起来，而不是根据自己的感觉配置节目。通过平台，群众可以在第一时间获得信息，所有的演出、培训等活动，全部免费供应，群众可根据自己的口味来挑选各种菜式。这跟以前相比是翻天覆地的变化。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">现在跟以前最大的不同，就是我们办活动再也不用考虑其它问题。只要努力把活动尽量组织得完美精良，自然就会一票难求。只要你提供的是真正好的演出，对老百姓胃口的，售票基本都是秒杀状态。比如我们的美术工笔画培训，20个学员的名额放出来一两分钟内就被抢光了。前几天在嘉定演的音乐剧《魔豆》，两场足足1000张票，可是没抢到票的还有一大把，有观众在平台上留言说，连续两天没抢到，太凶残了。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">我们平台上还有吐槽区域，有什么意见都可以提。现在很多人都在这里交流，提出各种好的意见和建议。比如，我们就根据这些意见，研究出了黑名单制：一年超过3次没有来现场领票入场的人，后台就会记录在案，今年就不能抢票了，因为他们浪费了公共资源。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">我们现在的工作状态早就饱和了。从礼拜一到礼拜五都要组织策划很多新活动，大量的演出又是在晚上和周末，基本就是5加2、白加黑的节奏，但我们很开心。百姓都说，我们嘉定有了这么个文化平台，真正能在家门口看到自己喜欢的东西。</p><br />
				<p class="ccDetailTitle">【管者说】</p>
				<p class="ccDetailTitle">互联网+文化倒逼公共服务改革</p>
				<p style="text-indent:2em;" class="ccDetailFont">区文广局副局长姚强：上海市嘉定区，土地面积460多平方公里，包括一个城市化快速推进、常住人口超过156万的嘉定新城。有限的公共资源如何摊到各位市民头上？用数字化打破时间和地域限制，无疑能开辟一条新途径。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">对我们文化部门而言，文化嘉定云更重要的影响，是对公共文化服务改革的倒逼。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">首先，文化嘉定云使得公共文化设施能在网上开放预订，开放团队自主注册，引导市民自主开展文化活动，政府得以退居幕后，专心提供服务。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">文化嘉定云使我们的公共文化服务形成资源整合优化、服务一口对外的姿态，不仅方便了市民，也打破了以往不同单位各自为战的壁垒。将各种文化服务统一晒到网上，数量多少、质量服务优劣一目了然，公共文化服务也有了一个统一竞争的平台。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">事实上，为了配合数字服务工作，嘉定区各文化单位已形成了较为统一的公共文化服务标准化流程，包括：至少提前两周确定方案、活动前一周发布预告和领票信息、提前取得文化资源网络发布权、活动当天进行数字化录制、活动结束后一周内上传文化资源网络版。可以说，这套标准化流程，就是倒逼形成的，群众在吐槽区的反馈，逼得我们想得更多、更完善。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">我们还依托文化嘉定云，首创公共文化设施场馆预订综合服务平台。在提高了各文化场所利用率的同时，推动公共文化供给方式以群众需求为导向，使市民真正成为文化服务的主人。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">不怕你笑话，我们也算是把自己给革命了。现在我们如果想借文化中心的多功能厅开个会，有时会被告知场地早有预约，只好自己想办法换场地。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">不几年来，文化嘉定云经历了3个转变：从政府单向提供服务到引导群众自主服务；从简单的实体文化数据化工作到依托信息技术的智能文化服务；从场面好看大而全的文化信息搜罗，到关注群体收获、个性化服务定制。总的来说，就是从大而全演变为小而精，以市民需求为导向、功能不断改善，要让市民真正感受到互联网+文化带来的种种福利。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">当然，还是有不足。后台跟踪数据显示，市民在文化嘉定云上平均停留时间是8分钟。因为大家的目的很明确，就是浏览活动预告、预订场馆及演出票、浏览数字图书馆等。所以我们下一步的工作重点，就是努力打破8分钟魔咒，增加平台与市民的黏性，把文化嘉定云真正塑造成一个文化淘宝。</p><br />
				<p style="text-align: right;">来源：人民日报</p>
				<p>2016-9-2</p>
			</div>
		</div>

		<div class="ccDetailMain" id="ccDetailMain4" style="display: none;height: 100%;width: 100%;margin: auto;background-color: #fff;">
			<div class="backBtn" onclick="$(document).attr('title','互联网+公共文化服务主题研讨会');$('.ccDetailMain').hide();$('.ccMain').show()" style="font-size: 30px;color: #fff;padding: 10px;border: 1px solid #575B5F;border-radius: 10px;background: rgba(160,160,160, 0.5);">返回</div>
			<div class="ccTop">
				<img src="${path}/STATIC/cc/image/p3.jpg" width="750" />
				<p>我们的幸福指数提高了</p>
			</div>
			<div class="ccDetail">
				<p style="text-indent:2em;" class="ccDetailFont">“文化嘉定云”平台形成了“文化菜单——网上书房——数字展馆——场馆预订——精品资源”五大板块和一个综合性的“文化分享圈”，百姓登录后可尽享“互联网+文化”带来的种种文化福利。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">“我一直想带女儿看音乐剧《魔豆》，可是抢票的人实在太多，第一天没成功，今天总算顺利抢到了！”家住上海嘉定菊园新区的王女士激动地表示。现在的她，一直用手机上的“文化嘉定云”软件，方便抢“高大上”的演出票。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">自2014年12月正式上线以来，“文化嘉定云”平台聚合起嘉定区内文化馆、图书馆、博物馆、美术馆的众多服务资源，有效解决了以往公共文化活动信息不对称、设施资源利用率不高的问题。上线至今，其用户量已达到6万人左右。从“大而全”演变为“小而精”，以百姓需求为导向、服务功能不断完善的“文化嘉定云”，让这里的居民切实感受到了“互联网+文化”的种种福利。</p><br />
				<p class="ccDetailTitle">“互联网+文化”给百姓带来福利</p>
				<p style="text-indent:2em;" class="ccDetailFont">家住嘉定镇的康红霞是一位年轻的妈妈，孩子在上幼儿园中班。她跟其他几位家长组织了一个“家委会”，每周轮流带孩子们开展活动。找合适的场地是一件伤脑筋的事，有一天，康红霞得知户外活动那天要下雨，顿时一筹莫展，不知该去哪里。有朋友告诉她，嘉定区有预订公共文化场馆的福利，她便用手机上“文化嘉定云”试了一下，果然非常方便。安亭镇的小李是一名初中生，跟几名志同道合的朋友每周都要聚在一起学国学，以前苦于没有固定场所，一群人只好打一枪换一个地方。得知通过“文化嘉定云”可以预借场馆，他们就用“云端”里的服务解决活动场地问题了。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">与之相对应，嘉定区文广局还在网上开放了文化团队自主登记注册的窗口，最大程度地降低市民组建文化团队的门槛。功能开放一年来，已有245支文化团队通过网络平台注册组建，并顺利预约场馆开展各种文化活动，有效提升了各公共文化场馆的吸引力和影响力，受到居民的普遍欢迎。</p><br />
				<p class="ccDetailTitle">数字化建设惠及百姓文化生活</p>
				<p style="text-indent:2em;" class="ccDetailFont">钱小姐比较喜欢看演出。经同事推荐，她下载了“文化嘉定云”的APP软件。“大家告诉我，上面有不少高质量的文化演出，注册好就可以抢票。”在尝过几次甜头之后，她现在已成了“文化嘉定云”的忠实粉丝，时不时就会刷一下屏，看看有没有什么新的演出信息，有时还会帮自己的父母抢票：“现在能带爸爸妈妈一起去看演出，陪伴家人的时间更多了，感觉我家的幸福指数提高了不少。”</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">70多岁的李老伯是一位丧偶老人，儿子成家后在外居住。他虽然偶尔也会去社区参加文化活动，不过还是感到有些孤寂。知道“文化嘉定云”上可以抢票的信息，他就让儿子帮他用手机抢票，然后跟自己的邻居一起去看戏，业余生活一下子丰富起来。现在，只要每次去看演出，他都自豪地跟别人说：“这是我儿子帮我抢的票哦！”“文化嘉定云”拉近了他们父子的感情距离。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">嘉定区文化馆馆长李辉表示，以前安排一场文化活动，都由政府部门关门操办，组织节目、预定时间，再邀请观众，等人到了，端茶倒水送礼品，为吸引人气可谓煞费苦心，却还常常是“剃头挑子一头热”。很多观众大老远地赶来，其实不是真心来看节目的，领了小毛巾小牙膏，中途就带着礼品走了。等到演出结束时，剧场里剩不下几个人。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">“局面的改变就在‘文化嘉定云’上线之后，通过这个信息平台的搭建，群众可以在第一时间获得相关信息，所有的演出、培训等活动，群众可以根据自己的口味挑选。”李辉介绍，“现在跟以前最大的不同，就是我们办活动再也不用考虑居民来不来。只要你提供的演出对老百姓胃口，开票基本都是秒杀状态。比如前几天在嘉定演的音乐剧《魔豆》，演出两场足有1000张票，却有超出三倍的观众来抢票。”</p><br />
				<p class="ccDetailTitle">“网上书房”照样享受专业文献</p>
				<p style="text-indent:2em;" class="ccDetailFont">“文化嘉定云”的另一大特色就是资源共享。嘉定区文化馆、图书馆的专业数据库资源一直深受读者欢迎，每逢周末、寒暑假，馆内便有大量学生、学者前来查询。中国知网、万方数据、维普期刊、库克音乐等14种国内主流权威信息资源数据库，现在都搬上了“文化嘉定云”平台。市民只需凭读者证号即可简单注册登录。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">嘉定图书馆以前会为企事业单位提供一些课题服务，比如对方把要写论文的关键词告诉图书馆，工作人员就据此为他们查找资料。“不过通过关键词得出的信息还需要进行大量筛选，往往双方都耗时耗力。如今可以自己在家查阅资料，实现‘点对点’地精准服务，节约了大量时间成本。”嘉定图书馆副馆长黄莺介绍，“我们这个服务在国内已有一定知名度，不少外地朋友来我们这里参观，回去之前就要求办一张我们的读者证，以便远距离也能查阅各种资料。”</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">此外，加强版的“文化嘉定云”不断降低门槛，把更多权益向公众开放，借助社会化力量丰富平台内容。以一位在育儿方面有专业知识的妈妈为例，若她愿意分享经验，就可以在“文化嘉定云”上提出举办讲座的申请和预订场馆，经后台审核通过后，就能如期举办。按照嘉定区文广局的说法，官方将提供更为便捷的平台“土壤”，培育志趣相投的市民自发形成各类文化社团，不断丰富社会公共文化活动。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">市民对文体活动的“胃口”越来越大，欣赏水平越来越高，如何用同样的财政资金，购买更多市民喜闻乐见的文体活动？在推进国家公共文化服务体系示范区建设过程中，嘉定区还将尝试“文化众筹”。也就是说，未来若推出某项文化活动，有关部门将事先在“文化嘉定云”发布信息，感兴趣的市民可以报价提供赞助，待支持率达到一定比例，有关部门再补上剩余的资金缺口购买该活动。“如此既能紧贴市民文化需求，也不至于‘叫好不叫座’，造成文化资源的浪费。”嘉定区文广局负责人这样表示。从前期发放600余份问卷调查中获悉，九成以上居民对这种“文化众筹”表示认可。</p><br />
				<p style="text-indent:2em;" class="ccDetailFont">未来五年，嘉定区将重点推进国家公共文化服务体系示范区建设，实现公共文化数字化的有效覆盖。目前，区、镇两级各类文体活动平均每月挂上“文化嘉定云”的数量已达150场次。不少市民反映，丰富多彩的文化活动充实了他们的业余生活。</p><br />
				<p style="text-align: right;">《中国文化报》</p>
				<p>2016-9-13</p>
			</div>
		</div>
		
		
		
		<img id="setmap" src="${path}/STATIC/cc/image/setmap.jpg" onclick="$(this).hide()" style="display: none;width: 100%;height: 100%;position: fixed;left: 0;right: 0;top: 0;bottom: 0;margin: auto;z-index: 100;" />
</body>
</html>