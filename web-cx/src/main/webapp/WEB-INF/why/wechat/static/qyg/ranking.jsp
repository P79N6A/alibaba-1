<%@ page language="java" pageEncoding="UTF-8" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>公共文化配送产品大赛</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css">
<style type="text/css">
html,body{height: 100%; background-color: #3c1d4c;}
</style>
<script type="text/javascript">
   var noVote = '${noVote}';	//1：不可投票
   var tab = '${tab}';
   var entrySubject = '${entrySubject}';
   var startIndex = 0;		//页数
   
 //弹窗的打开和关闭
   function popUps(windowEle, action, callback) {
        // windowEle:弹窗元素；action表示行为，可以是show或者hide；callback回调函数；
        if(action == 'show') {
            $('.pszxDoorFc').show();
            windowEle.show();
            $('.pszxDoorFc').on('touchmove', function () {
                return false;
            });
        } else {
            $('.pszxDoorFc').hide();
            windowEle.hide();
        }
        if(callback) {
            callback();
        }
    }
   
	//分享是否隐藏
	if(window.injs){
		//分享文案
		appShareTitle = '给喜欢的产品设计投票，为公共文化添上浓墨重彩的一笔';
		appShareDesc = '2016年上海市民文化节公共文化配送产品设计大赛市民投票活动';
		appShareImgUrl = '${basePath}/STATIC/wxStatic/image/pszx/shareIcon.jpg';
		
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
				title: "给喜欢的产品设计投票，为公共文化添上浓墨重彩的一笔",
				desc: '2016年上海市民文化节公共文化配送产品设计大赛市民投票活动',
				link: '${basePath}wechatQyg/toRanking.do?tab='+tab,
				imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon.jpg'
			});
			wx.onMenuShareTimeline({
				title: "给喜欢的产品设计投票，为公共文化添上浓墨重彩的一笔",
				imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon.jpg',
				link: '${basePath}wechatQyg/toRanking.do?tab='+tab
			});
			wx.onMenuShareQQ({
				title: "给喜欢的产品设计投票，为公共文化添上浓墨重彩的一笔",
				desc: '2016年上海市民文化节公共文化配送产品设计大赛市民投票活动',
				imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon.jpg'
			});
			wx.onMenuShareWeibo({
				title: "给喜欢的产品设计投票，为公共文化添上浓墨重彩的一笔",
				desc: '2016年上海市民文化节公共文化配送产品设计大赛市民投票活动',
				imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon.jpg'
			});
			wx.onMenuShareQZone({
				title: "给喜欢的产品设计投票，为公共文化添上浓墨重彩的一笔",
				desc: '展演名单已公布，点击进入…',
				imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon.jpg'
			});
		});
	}

	$(function(){
		
		// 分享事件绑定
		//分享
	 	$("#culture").click(function() {
			/* if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
				dialogAlert('系统提示', '请用微信浏览器打开分享！');
			}else{ */
				$("html,body").addClass("bg-notouch");
				$(".background-fx").css("display", "block")
			/* } */
		})
		
		$('.background-fx').click(function () {
			$(this).hide();
		});
		
		//分享
		$(".share-button").click(function() {
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
		$(".keep-button").on("touchstart", function() {
			$('.div-share').show()
			$("body,html").addClass("bg-notouch")
		})
		
		// 关闭你弹窗
       $('.pszxDoor .close').bind('click', function () {
           popUps($(this).parents('.pszxDoor'),'hide');
       });
		
		loadDcList(0,20);
	})
	
	var p=0;
//滑屏分页
 $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 80)) {
           		setTimeout(function () { 
           			if(p==0){
           				startIndex += 20;
                  		var index = startIndex;
                  		loadDcList(index,20);
           			}
           		},800);
            }
        });       
	//加载剧评列表
		function loadDcList(index, pagesize){
			p=1;
			var data = {
					userId:userId,
					entrySubject:entrySubject,
					firstResult: index,
	               	rows: pagesize,
					reviewType:7
	            };
			$.post("${path}/wechatQyg/queryQyglist.do",data, function (data) {
				
				if(data.length<10){
					$("#loadingVoteItemDiv").html("");
		    	}
				else{
					p=0;
				}
				
				$.each(data, function (i, dom) {
					var ImgObj = new Image();
					ImgObj.src = dom.posterImg+"@150w";
					ImgObj.onload = function(){
						if(ImgObj.width/ImgObj.height>140/195){
							$("img[entryId="+dom.entryId+"]").css("height","197px");
						}else{
							$("img[entryId="+dom.entryId+"]").css("width","140px");
						}
					}
					/* var videoActivityCenter = "";
					if(dom.videoActivityCenter.lastIndexOf("文化活动中心")>0){
						videoActivityCenter = dom.videoActivityCenter.substring(0,dom.videoActivityCenter.lastIndexOf("文化活动中心"));
					}else{
						videoActivityCenter = dom.videoActivityCenter;
					} */
					 var voteHtml = "";
					 if(dom.isVote == 1){
						voteHtml = "current";
					 }
					
					var declarationCategory=dom.declarationCategory;
					
					if(declarationCategory==undefined || declarationCategory=='' ||declarationCategory== null){
						$(".pszxRankUl").append("<li entryId='"+dom.entryId+"' class='clearfix'>"+
								"<div class='d2'>"+
								  "<div class='pic'>"+
								     "<img src='"+dom.posterImg+"@200w' width='140' height='197'>"+
								  "</div>"+
								"</div>"+
								"<div class='d3'>"+
								    "<div class='tit'>"+
								       "<a href='javascript:;'>"+dom.projectName+"</a>"+
								    "</div>"+
								    "<div class='tuan'>"+dom.companyName+"</div>"+
								    "<div class='zong clearfix'>"+
								        "<div class='piao'>票数"+":"+"<span>"+dom.voteCount+"</span>"+"</div>"+
								        "<div class='tou "+voteHtml+"' onclick='dcVote(\""+dom.entryId+"\",this)'>投他一票</div>"+
								    "</div>"+
								"</div>"
								+"</li>");
						
					}else{
						$(".pszxRankUl").append("<li entryId='"+dom.entryId+"'class='clearfix'>"+
								"<div class='d2'>"+
								  "<div class='pic'>"+
								     "<img src='"+dom.posterImg+"@200w' width='140' height='197'>"+
								  "</div>"+
								"</div>"+
								"<div class='d3'>"+
								    "<div class='tit'>"+
								       "<a href='javascript:;'>"+dom.projectName+"</a>"+
								    "</div>"+
								    "<div class='tuan'>"+dom.companyName+"</div>"+
								    "<div class='type'>节目类型"+":"+dom.declarationCategory+"</div>"+
								    "<div class='zong clearfix'>"+
								        "<div class='piao'>票数"+":"+"<span>"+dom.voteCount+"</span>"+"</div>"+
								        "<div class='tou "+voteHtml+"' onclick='dcVote(\""+dom.entryId+"\",this)'>投TA一票</div>"+
								    "</div>"+
								"</div>"
								+"</li>");
					}
				});
				
				// 前三名红色
				/* $('.deresultList').each(function () {
					$(this).find('tr:lt(3) .shu').addClass('red');
				}); */
			},"json");
		}
	
		//投票
		function dcVote(entryId,$this){
			 if(noVote != 1){  
			 
				if (userId == null || userId == '') {
		    		//判断登陆
		        	publicLogin("${basePath}/wechatQyg/toRanking.do");
		    	}else{ 
		    		$.post("${path}/wechatQyg/addVote.do",{userId:userId,entryId:entryId}, function (data) {
						if(data == "100"){
							$("#entryId").val(entryId);
							popUps($('.pszxDoor_info'),'show');
							/* $($this).addClass('current');
							var ele = $($this).parents('.ticket').find('.ticket_1 .no span');
							ele.html(parseInt(ele.html()) + 1); */
						 }else if(data == "200"){
							    $($this).addClass('current');
								var ele = $($this).parents('.zong').find('.piao span');
								ele.html(parseInt(ele.html()) + 1);
								popUps($('.pszxDoor_info'),'hide');
		 						popUps($('.pszxDoor_success'),'show');
						}else if(data == "repeat"){
						    popUps($('.pszxDoor_nostart'),'show');
						}else if(data == "500"){
							dialogAlert('系统提示', '投票失败！');
							
						}
					},"json");
		    	}
			 } else{
				 $("#dialog4").css("display","table"); 
				 popUps($(".menban"), 'show');
			 }  
		 }
		 
		 
		 
		 

		//补填手机号
		function saveInfo(){
			var userMobile = $("#cellphone").val();
			var userName=$("#userName").val();
			var telReg = (/^1[34578]\d{9}$/);
			if(userMobile == ""){
		    	dialogAlert('系统提示', '请输入手机号码！');
		        return false;
		    }else if(!userMobile.match(telReg)){
		    	dialogAlert('系统提示', '请正确填写手机号码！');
		        return false;
		    }
			if(!userName){
				dialogAlert('系统提示', '请输入姓名！');
		        return false;
			}
			var data = {
				userId:userId,
				userTelephone:userMobile,
				userNickName:userName
			}
			
			if (userId == null || userId == '') {
        		//判断登陆
            	publicLogin("${basePath}wechatQyg/toRanking.do");
        	}else{
				$.post("${path}/terminalUser/editTerminalUser.do", data, function(data) {
					if (data == "success") {
						var entryId=$("#entryId").val();
						 $.post("${path}/wechatQyg/insertQygUser.do",{userId:userId,cellphone:userMobile,userName:userName,entryId:entryId},function(){
							  if(data == "success"){
		 							
		 							var li=$("li[entryId='"+entryId+"']");
		 							
		 							var span=li.find(".piao span");
		 							
		 							var num=parseInt(span.html());
		 							
		 							span.html(num+1);
		 							
		 							li.find('.tou').addClass('current');
		 							
								  popUps($('.pszxDoor_info'),'hide',function () {
									  popUps($('.pszxDoor_success'),'show');
								  });
								  
							  }else{
								  dialogAlert('系统提示', '保存失败！');
							  }
						 })
					}else {
						dialogAlert('系统提示', "提交失败")
					}
				},"json");
        	}
		}
	
</script>

<style>
	tr{display: table-row!important;}
	td{display: table-cell!important;}
</style>

</head>

<body>
<div class="div-share">
	<div class="share-bg"></div>
	<div class="share">
		<img src="${path}/STATIC/wechat/image/wx-er2.png" />
		<p style="margin-top: 310px;">扫一扫&nbsp;关注文化云</p>
		<p>更多精彩活动、场馆等你发现</p>
		<button type="button" onclick="$('.div-share').hide();$('body,html').removeClass('bg-notouch')">关闭</button>
	</div>
</div>
 <div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
			<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
 </div>
<div class="pszxMain">
    <div class="pszxBan">
        <img class="bg" src="${path }/STATIC/wxStatic/image/pszx/pic3.jpg">
        <div class="pszx_guanfx clearfix" style="top:25px;">
            <a href="javascript:;" class="keep-button">关注</a>
            <a href="javascript:;" class="share-button">分享</a>
        </div>
       
        <div class="navIndex">
            <a class="a1" href="${path }/wechatQyg/index.do?guide=1"></a>
            <a class="a2" href="${path }/wechatQyg/voteRule.do"></a>
            <a class="a3" href="${path }/wechatQyg/announcement.do"></a>
            <a class="a4 current" href="${path }/wechatQyg/toRanking.do"></a>
        </div>
    </div>
    <div class="pszxRank_wc">
        <ul class="pszxRankUl">
        </ul>
         <div id="loadingVoteItemDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
    </div>
    <div class="pszxIndexNav_wc">
        <div class="pszxIndexNav">
            <ul class="clearfix">
              <c:choose>
                <c:when test="${tab==0 }">
                <li class="current" onclick="location.href='${path}/wechatQyg/toRanking.do?tab=0&guide=1'">文艺演出<span></span></li>
                <li onclick="location.href='${path}/wechatQyg/toRanking.do?tab=1&guide=1'">艺术导赏<span></span></li>
                <li onclick="location.href='${path}/wechatQyg/toRanking.do?tab=2&guide=1'">展览展示<span></span></li>
                <li onclick="location.href='${path}/wechatQyg/toRanking.do?tab=3&guide=1'">特色活动<span></span></li>
                </c:when>
                <c:when test="${tab==1 }">
                <li onclick="location.href='${path}/wechatQyg/toRanking.do?tab=0&guide=1'">文艺演出<span></span></li>
                <li class="current" onclick="location.href='${path}/wechatQyg/toRanking.do?tab=1&guide=1'">艺术导赏<span></span></li>
                <li onclick="location.href='${path}/wechatQyg/toRanking.do?tab=2&guide=1'">展览展示<span></span></li>
                <li onclick="location.href='${path}/wechatQyg/toRanking.do?tab=3&guide=1'">特色活动<span></span></li>
                </c:when>
                <c:when test="${tab==2 }">
                <li onclick="location.href='${path}/wechatQyg/toRanking.do?tab=0&guide=1'">文艺演出<span></span></li>
                <li onclick="location.href='${path}/wechatQyg/toRanking.do?tab=1&guide=1'">艺术导赏<span></span></li>
                <li class="current" onclick="location.href='${path}/wechatQyg/toRanking.do?tab=2&guide=1'">展览展示<span></span></li>
                <li onclick="location.href='${path}/wechatQyg/toRanking.do?tab=3&guide=1'">特色活动<span></span></li>
                </c:when>
                <c:when test="${tab==3 }">
                <li onclick="location.href='${path}/wechatQyg/toRanking.do?tab=0&guide=1'">文艺演出<span></span></li>
                <li onclick="location.href='${path}/wechatQyg/toRanking.do?tab=1&guide=1'">艺术导赏<span></span></li>
                <li onclick="location.href='${path}/wechatQyg/toRanking.do?tab=2&guide=1'">展览展示<span></span></li>
                <li class="current" onclick="location.href='${path}/wechatQyg/toRanking.do?tab=3&guide=1'">特色活动<span></span></li>
                </c:when>
                <c:otherwise>
                <li class="current" onclick="location.href='${path}/wechatQyg/toRanking.do?tab=0&guide=1'">文艺演出<span></span></li>
                <li onclick="location.href='${path}/wechatQyg/toRanking.do?tab=1&guide=1'">艺术导赏<span></span></li>
                <li onclick="location.href='${path}/wechatQyg/toRanking.do?tab=2&guide=1'">展览展示<span></span></li>
                <li onclick="location.href='${path}/wechatQyg/toRanking.do?tab=3&guide=1'">特色活动<span></span></li>
                </c:otherwise>
              </c:choose>
            </ul>
        </div>
    </div>
</div>

<!-- 弹窗 -->
<div class="pszxDoorFc" style="display:none;">
    <!-- 投票成功 -->
    <div class="pszxDoor pszxDoor_success" style="display:none;">
        <div class="tit">恭喜您，投票成功！</div>
        <div class="cha close"></div>
        <div class="btnDiv">
            <a class="close" href="javascript:;">看看其他作品</a>
            <a class="huang" id="culture" href="javascript:;">支持公共文化</a>
        </div>
    </div>
    <!-- 还没开始投票 -->
    <div class="pszxDoor pszxDoor_nostart" style="display:none;" id="dialog2">
        <div class="cont">每个用户对同一作品每天只能投一票</div>
        <div class="cha close"></div>
        <div class="btnDiv">
            <a class="close" href="javascript:;">我知道了</a>
        </div>
    </div>
    <!-- 填写信息弹窗 -->
    <div class="pszxDoor pszxDoor_info" style="display:none;" id="dialog3">
    	<input type="hidden" name="entryId" id="entryId"/>
        <div class="infotit">请留下您的个人资料</div>
        <table class="infoTable">
            <tr>
                <td class="td1">姓 名</td>
                <td class="td2"><input class="txt" type="text" id="userName" name="userName"></td>
            </tr>
            <tr>
                <td class="td1">手机号</td>
                <td class="td2"><input class="txt" type="text" id="cellphone" name="cellphone"></td>
            </tr>
        </table>
        <div class="infoCont">
            <p>1、为保证投票的公正性，防止恶意刷票，用户首次投票需要登记手机号码；</p>
            <p>2、每个用户（同一ID）每天可以投多票，但对同一作品每天只能投一票，请珍惜你的宝贵投票机会；</p>
            <p>此规则的最终解释权归上海市群众艺术馆和文化云所有</p>
        </div>
        <div class="btnDiv">
            <a class="close" href="javascript:;">关 闭</a>
            <a class="huang" href="javascript:;" onclick="saveInfo();">提 交</a>
        </div>
    </div>
    <div class="pszxDoor" style="display:none;" id="dialog4">
	    	<div class="nc">
			    		<p style="font-size:26px;text-align:center;color:#fff;">投票时间已结束！</p>
			    		<div class="zhidl cha close">X</div>
			    	</div>
	    </div>
</div>

</body>
</html>