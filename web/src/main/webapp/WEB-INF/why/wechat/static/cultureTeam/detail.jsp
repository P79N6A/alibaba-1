<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">


<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>浦东百强团队评选活动</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/swiper.min.css">
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css">
<style type="text/css">
html,body {background-color: #f5f5f5;}
</style>
<script type="text/javascript">

var cultureTeamId='${cultureTeamId}';
var noVote='${noVote}';
var img='${team.cultureTeamAddressUrl}'
var img1='${team.cultureTeamFamily}'

if (userId == null || userId == '') {
	//判断登陆
	publicLogin("${basePath}wechatStatic/cultureTeamIndex.do");
}

shareTitle = "给“"+'${team.cultureTeamName}'+"”投上一票，让TA离“百强文化团队”更近一步";
shareDesc = "2017浦东新区“百强文化团队”线上大众投票！";
assnIconUrl = "${basePath}/STATIC/wxStatic/image/hundred/shareIcon.png";
//分享是否隐藏
if(window.injs){
	
	appShareTitle = shareTitle;
	appShareDesc = shareDesc;
	appShareImgUrl = assnIconUrl;
	
	injs.setAppShareButtonStatus(true);
}

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
           title: shareTitle,
           desc: shareDesc,
           link: 'http://www.wenhuayun.cn/wechatStatic/cultureTeamDetail.do?cultureTeamId='+cultureTeamId+'&t='+new Date().getTime(),
           imgUrl: assnIconUrl
       });
       wx.onMenuShareTimeline({
           title: shareTitle,
           imgUrl: assnIconUrl,
           link: 'http://www.wenhuayun.cn/wechatStatic/cultureTeamDetail.do?cultureTeamId='+cultureTeamId+'&t='+new Date().getTime()
       });
       wx.onMenuShareQQ({
       	title: shareTitle,
           desc: shareDesc,
           imgUrl: assnIconUrl
       });
       wx.onMenuShareWeibo({
       	title: shareTitle,
           desc: shareDesc,
           imgUrl: assnIconUrl
       });
       wx.onMenuShareQZone({
       	title: shareTitle,
           desc: shareDesc,
           imgUrl: assnIconUrl
       });
   });
}


 $(function(){
	 
	//关闭图片预览
	 $(".imgPreview,.imgPreview>img").click(function() {
	 	$(".imgPreview").fadeOut("fast");
	 }) 
	 
    //拉票
	$(".fx").click(function() {
 	  if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
 			dialogAlert('系统提示', '请用微信浏览器打开分享！');
 		}else{    
			 
			$("html,body").addClass("bg-notouch");
			$(".background-fx").css("display", "block");
			
	   }   
	})
	
	//投票成功后的拉票
    $("#lapiao").click(function() {
 	  if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
 			dialogAlert('系统提示', '请用微信浏览器打开分享！');
 		}else{    
			 
			$("html,body").addClass("bg-notouch");
			$("#indexShareBg").css("display", "block");
			
	   }   
	})
	
	//分享的图片
	$(".background-fx").click(function() {
		$("html,body").removeClass("bg-notouch");
		$(".background-fx").css("display", "none")
	})
	
	
	//在首页投票后，给详情页投票按钮添加样式
	 var data = {
 		    userId:userId,
 		    cultureTeamId:cultureTeamId
         };
 	$.post("${path}/wechatStatic/queryCultureTeamlist.do",data, function (data) {
 		$.each(data, function (i, dom) {
 			if(dom.isVote == 1){
 				$(".toup").addClass("active");
 			}
 		})
 	})
 	
 	
 	//对第一张图片的处理
 	if(img1){
 		var Imga =new Image() ;
 	 	Imga.src = img1.split(",")[0]+"@800w";
 		Imga.onload = function(){
 			if(Imga.width/Imga.height>750/435){
 				var pLeft = (Imga.width*(435/Imga.height)-750)/2;
 				$("img[cId="+cultureTeamId+"]").css({"height":"435px","position":"absolute","left":"-"+pLeft+"px"});
 			}else{
 				var pTop = (Imga.height*(750/Imga.width)-435)/2;
 				$("img[cId="+cultureTeamId+"]").css({"width":"750px","position":"absolute","top":"-"+pTop+"px"});
 			}
 		}
 	}
    
 	if(img){
 		var ImgObj = new Image();
 		ImgObj.src = img.split(",")[0]+"@700w";
 		ImgObj.onload = function(){
 			if(ImgObj.width/ImgObj.height>690/230){
 				var pLeft = (ImgObj.width*(230/ImgObj.height)-690)/2;
 				$("img[cultureTeamId="+cultureTeamId+"]").css({"height":"230px","position":"absolute","left":"-"+pLeft+"px"});
 			}else{
 				var pTop = (ImgObj.height*(690/ImgObj.width)-230)/2;
 				$("img[cultureTeamId="+cultureTeamId+"]").css({"width":"690px","position":"absolute","top":"-"+pTop+"px"});
 			}
 		}
 	}
	
})


// 弹窗的打开和关闭
    function popUps(windowEle, action, callback) {
        // windowEle:弹窗元素；action表示行为，可以是show或者hide；callback回调函数；
        if(action == 'show') {
            $('.hundredDoorFc').show();
            windowEle.show();
            $('.hundredDoorFc').on('touchmove', function () {
                return false;
            });
        } else {
            $('.hundredDoorFc').hide();
            windowEle.hide();
        }
        if(callback) {
            callback();
        }
    }

//投票
 function dcVote(){
 	  if(noVote != 1){  
 	 
 		  if (userId == null || userId == '') {
     		//判断登陆
         	publicLogin("${basePath}wechatStatic/cultureTeamIndex.do");
     	}else{  
     		$.post("${path}/wechatStatic/addVote.do",{userId:userId,cultureTeamId:cultureTeamId}, function (data) {
 				if(data == "100"){
 				    // 投TA一票
 				        $(".toup").addClass("current");
 				    	var _shuzi =$("#count");
 				    	var num=_shuzi.html();
 				    	if(num=='' || num==undefined){
 				    		num=0;
 				    	}
 				    	_shuzi.html(parseInt(num) + 1);
 				    	/* popUps($('.hundredDoor_info'),'show'); *///可能以后要用(第一次投票的填信息窗口)
 				    	popUps($('.hundredDoor_success'),'show');
 				 }else if(data == "200"){
 					    $(".toup").addClass("current");
 					    var _shuzi =$("#count");
				    	var num=_shuzi.html();
				    	if(num=='' || num==undefined){
				    		num=0;
				    	}
				    	_shuzi.html(parseInt(num) + 1);
 				    	popUps($('.hundredDoor_success'),'show');
 				}else if(data == "repeat"){
 					 popUps($('.hundredDoor_nostart'),'show');
 				}else if(data == "500"){
 					dialogAlert('系统提示', '投票失败！');
 				}
 			},"json");
     	 } 
 	}else{
 		popUps($('#dialog4'),'show');
 	} 
  }
  
  
//添加用户名和手机号
 function saveInfo(){
 	var userMobile = $("#cellphone").val();
 	var userName=$("#userName").val();
 	var telReg = (/^1[34578]\d{9}$/);
 	var Reg  = /^[\s]*$/;
 	if(userMobile == ""){
     	dialogAlert('系统提示', '请输入手机号码！');
         return false;
     }else if(!userMobile.match(telReg)){
     	dialogAlert('系统提示', '请正确填写手机号码！');
         return false;
     }
 	if(userName.match(Reg)){
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
     	publicLogin("${basePath}wechatStatic/cultureTeamIndex.do");
 	}else{
 		$.post("${path}/terminalUser/editTerminalUser.do", data, function(data) {
 			if (data == "success") {
 				var cultureTeamId=$("#cultureTeamId").val();
 				 $.post("${path}/wechatStatic/insertUserMessage.do",{userId:userId,cellphone:userMobile,userName:userName,cultureTeamId:cultureTeamId},function(){
 					  if(data == "success"){
 						 popUps($('.hundredDoor_info'),'hide',function () {
							  popUps($('.hundredDoor_success'),'show');
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
/*  
 var url=$(".char .pic img").attr('src'); */ 
//预览大图
function showPreview(url){
	$(".imgPreview img").attr("src",url);
	$(".imgPreview").fadeIn("fast");
}




</script>
</head>

<body>
<%   request.setAttribute("vEnter", "\r\n");   %>
<!-- 分享的图片 -->
 <div id="indexShareBg" class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
 </div>
<div class="hundredmain">
    <c:if test="${not empty team.cultureTeamFamily }">
	  <div class="hundDban"><img cId="${team.cultureTeamId }" src="${fn:split(team.cultureTeamFamily,',')[0]}@800w"></div>
	</c:if>
	<div class="hundDInfo">
	 <c:if test="${not empty team.cultureTeamName }">
		<div class="item clearfix">
			<div class="c1">团队名称：</div>
			<div class="c2">${team.cultureTeamName }</div>
		</div>
	 </c:if>
	 <c:if test="${not empty team.cultureTeamCount }">
		<div class="item clearfix">
			<div class="c1">团队人数：</div>
			<div class="c2">${team.cultureTeamCount }</div>
		</div>
	 </c:if>
	 <c:if test="${not empty team.cultureTeamTown }">
		<div class="item clearfix">
			<div class="c1">所属单位：</div>
			<div class="c2">${team.cultureTeamTown }</div>
		</div>
	</c:if>
	<c:if test="${not empty team.cultureTeamType }">
		<div class="item clearfix">
			<div class="c1">所属门类：</div>
			<c:if test="${team.cultureTeamType=='1'}">
			  <div class="c2">舞蹈</div>
			</c:if>
			<c:if test="${team.cultureTeamType=='2'}">
			  <div class="c2">音乐</div>
			</c:if>
			<c:if test="${team.cultureTeamType=='3'}">
			  <div class="c2">戏剧</div>
			</c:if>
			<c:if test="${team.cultureTeamType=='4'}">
			  <div class="c2">美书影</div>
			</c:if>
			<c:if test="${team.cultureTeamType=='5'}">
			  <div class="c2">综合</div>
			</c:if>
			<c:if test="${team.cultureTeamType=='6'}">
			  <div class="c2">曲艺</div>
			</c:if>
		</div>
	</c:if>
	</div>
	<c:if test="${not empty team.cultureTeamAddressUrl}">
		<div class="hundDAcitity">
			<div class="jz690">
				<div class="tit"><img src="${path}/STATIC/wxStatic/image/hundred/icon26.png">活动场所<span style="font-size:24px;">（点击图片查看大图）</span></div>
				<div class="char" style="height: auto;">
					<p class="pic"><img cultureTeamId="${cultureTeamId }" onclick="showPreview('${fn:split(team.cultureTeamAddressUrl,',')[0]}@700w');" src="${fn:split(team.cultureTeamAddressUrl,',')[0] }@700w"></p>
					<p><span class="hei">场地地址：</span>${team.cultureTeamAddress }</p>
				</div>
			</div>
		</div>
	</c:if>
	<c:if test="${not empty team.cultureTeamIntro }">
		<div class="hundDAcitity">
			<div class="jz690">
				<div class="tit"><img src="${path}/STATIC/wxStatic/image/hundred/icon13.png">团队简介及主要艺术成果</div>
				<div class="char">
					<div>${fn:replace(team.cultureTeamIntro, vEnter, "<br/>")}</div>
				</div>
				<div class="jian"></div>
			</div>
		</div>
	</c:if>
	<c:if test="${ not empty team.cultureTeamContent }">
		<div class="hundDAcitity">
			<div class="jz690">
				<div class="tit"><img src="${path}/STATIC/wxStatic/image/hundred/icon14.png">社会活动影响及品牌创新</div>
				<div class="char">
					<div>${fn:replace(team.cultureTeamContent, vEnter, "<br/>")}</div>
				</div>
				<div class="jian"></div>
			</div>
		</div>
	</c:if>
	<c:if test="${ not empty team.cultureTeamRule }">
		<div class="hundDAcitity">
			<div class="jz690">
				<div class="tit"><img src="${path}/STATIC/wxStatic/image/hundred/icon27.png">团队管理制度及议事制度</div>
				<div class="char">
					<div>${fn:replace(team.cultureTeamRule, vEnter, "<br/>")}</div>
				</div>
				<div class="jian"></div>
			</div>
		</div>
	</c:if>
	<c:if test="${not empty list }">
	<div class="hundDAcitity" id="hundDAcitity">
	    <c:forEach items="${list}" var="list">
		    <div class="tit" _tit="${list.worksName }"><img src="${path}/STATIC/wxStatic/image/hundred/icon17.png">原创和改编作品 - ${list.worksName }</div>
			<div class="tupian">
				<div class="jz720">
					<div class="nc clearfix">
					    <c:if test="${not empty list.worksManuscript }">
						    <c:forEach items="${fn:split(list.worksManuscript,';') }" var="worksManuscriptImg">
							<div class="picTit" data-src="${worksManuscriptImg }@700w">
								<div class="pic">
									<img src="${worksManuscriptImg }@600w" width="275" height="199">
								</div>
							</div>
						</c:forEach>
						</c:if>
						<c:if test="${not empty list.worksStage }">
							<c:forEach items="${fn:split(list.worksStage,';') }" var="worksStageImg">
							<div class="picTit" data-src="${worksStageImg }@750w">
								<div class="pic">
									<img src="${worksStageImg }@700w" width="275" height="199">
								</div>
							</div>
							</c:forEach>
						</c:if>
					</div>
				</div>
			</div>
		</c:forEach>
	</div>
	</c:if>
	<c:if test="${not empty team.cultureTeamPrize }">
	<div class="hundDAcitity">
			<div class="tit"><img src="${path}/STATIC/wxStatic/image/hundred/icon15.png">所获奖项</div>
			<div class="tupian">
				<div class="jz720">
					<div class="nc clearfix">
					<c:forEach items="${fn:split(team.cultureTeamPrize,',') }" var="cultureTeamPrizeImg">
						<div class="picTit" data-src="${cultureTeamPrizeImg }@750w">
							<div class="pic">
								<img src="${cultureTeamPrizeImg }@700w" width="275" height="199">
							</div>
					    </div>
				  </c:forEach>
				</div>
			</div>
		   </div>
	</div>
	</c:if>
	<c:if test="${not empty team.cultureTeamMedia }">
	<div class="hundDAcitity">
			<div class="tit"><img src="${path}/STATIC/wxStatic/image/hundred/icon16.png">媒体宣传</div>
			<div class="tupian">
				<div class="jz720">
					<div class="nc clearfix">
					    <c:forEach items="${fn:split(team.cultureTeamMedia,',') }" var="cultureTeamMediaImg">
						<div class="picTit" data-src="${cultureTeamMediaImg }@750w">
							<div class="pic">
								<img src="${cultureTeamMediaImg}@700w" width="275" height="199">
							</div>
						</div>
					    </c:forEach>
					</div>
				</div>
			</div>
	</div>
	</c:if>
	<div class="dgzp_div" style="text-align: center;background-color: #fff;padding-bottom: 50px;margin-top:-15px;">
		<a class="gdzp" style="display: inline-block;width: 240px; height: 60px;line-height: 60px;border: 2px solid #a73760;border-radius: 8px;font-size: 28px;color: #a73760;text-align: center;" href="${path }/wechatStatic/cultureTeamIndex.do?guide=1&tab=1">看看其他团队</a>
	</div>
	<!-- 分享 投票 -->
	<c:if test="${noVote == 1 }">
	<div class="hundDFoot_wc">
		<div class="hundDFoot clearfix">
			<div class="fx"><span>支持公共文化</span></div>
			<div class="toup" onclick="dcVote();"><span>投票已结束</span></div>
		</div>
	</div>
	</c:if>
	<c:if test="${noVote != 1 }">
	<div class="hundDFoot_wc">
		<div class="hundDFoot clearfix">
			<div class="fx"><span>支持公共文化</span></div>
			<div class="toup" onclick="dcVote();"><span>投票</span><em id="count">${team.voteCount }</em><em class="one">+1</em></div>
		</div>
	</div>
	</c:if>
	<!-- 弹窗 -->
	<div class="hundDoor">
		<div class="stitle"><a style="color:#9f4869;" href="javascript:;"></a><span><em class="em1">1</em> / <em class="em2">5</em></span></div>
		<div class="swiper-container">
	        <div class="swiper-wrapper"></div>
	        <div class="swiper-pagination"></div>
	    </div>
		<div class="close">关 闭</div>
	</div>
</div>

<!-- 弹窗 -->
<div class="hundredDoorFc" style="display:none;">
    <!-- 投票成功 -->
    <div class="hundredDoor hundredDoor_success" style="display:none;">
        <div class="tit">恭喜您，投票成功！</div>
        <div class="cha close"></div>
        <div class="btnDiv">
            <a class="close" href="${path }/wechatStatic/cultureTeamIndex.do?guide=1&tab=1">看看其他团队</a>
            <a class="huang" href="javascript:;" id="lapiao">支持公共文化</a>
        </div>
    </div>
    <!-- 一天只能投一票 -->
    <div class="hundredDoor hundredDoor_nostart" style="display:none;">
        <div class="cont">一个用户每天只能对同一团队投一票</div>
        <div class="cha close"></div>
        <div class="btnDiv">
            <a class="close" href="javascript:;">我知道了</a>
        </div>
    </div>
    <div class="hundredDoor" style="display:none;" id="dialog4">
	        <div class="tit">投票已结束</div>
	        <div class="cha close"></div>
	</div>
    <!-- 填写信息弹窗 -->
    <div class="hundredDoor hundredDoor_info" style="display:none;">
        <div class="infotit">请留下您的个人资料</div>
        <table class="infoTable">
            <tr>
                <td class="td1">姓 名</td>
                <td class="td2"><input class="txt" type="text" name="userName" id="userName"></td>
            </tr>
            <tr>
                <td class="td1">手机号</td>
                <td class="td2"><input class="txt" type="text" name="cellphone" id="cellphone"></td>
            </tr>
        </table>
        <div class="infoCont">
            <p>1、为保证投票的公正性，防止恶意刷票，用户首次投票需要登记手机号码</p>
            <p>2、每个用户每天对同一个团队只能投一票</p>
            <p>此规则的最终解释权归上海市群众艺术馆和文化云所有</p>
        </div>
        <div class="btnDiv">
            <a class="close" href="javascript:;">关 闭</a>
            <a class="huang" href="javascript:;" onclick="saveInfo();">提 交</a>
        </div>
    </div>
</div>

<!--点击放大图片-->
<div class="imgPreview" style="display: none;">
	<img src="" />
</div>
</body>
<script type="text/javascript" src="${path}/STATIC/wxStatic/js/swiper.min.js"></script>
<script type="text/javascript">
$(function() {
	// 点击显示全部文字
	$('.hundDAcitity .jian').bind('click', function () {
		if($(this).hasClass('s')) {
			$(this).parents('.hundDAcitity').find('.char').css({'height':'126px'});
			$(this).removeClass('s');
		} else {
			$(this).parents('.hundDAcitity').find('.char').css({'height':'auto'});
			$(this).addClass('s');
		}
		
	});

	// 图片横向排列
	$('.hundDAcitity .tupian .nc').width(function () {
		var sum = 0;
		$(this).find('.picTit').each(function () {
			sum = sum + $(this).width() + 10;
		});
		return sum;
	});
	
	// 获取.picTit这个元素的data-src的值
	function picTitDataSrc(ele) {
		var imgSrcArr = [];
		ele.find('.picTit').each( function () {
			imgSrcArr.push($(this).attr('data-src'));
		});
		return imgSrcArr;
	}
	
	// 查看大图

	var swiperFlag = 0;
	var mySwiper = null;
	var swiperTit = $('.hundDoor .stitle')
	$('.hundDAcitity .picTit').bind('click', function () {
		var _index = $(this).index();
		var zongAmount = $(this).parents('.tupian').find('.picTit').length;
		var imgSrcArr = picTitDataSrc($(this).parents('.tupian'));
		var txt1 = $(this).parents('.tupian').prev('.tit').text();
		if(txt1 == '所获奖项' || txt1 == '媒体宣传') {
			$('.hundDoor .stitle a').html(txt1);
		} else {
			$('.hundDoor .stitle a').html($(this).parents('.tupian').prev('.tit').attr('_tit'));
		}
		
		$('.hundDoor').fadeIn(80, function () {
			if(swiperFlag == 0) {
				mySwiper = new Swiper('.swiper-container', {
			        pagination: '.swiper-pagination',
			        paginationClickable: true,
			        lazyLoading : true,
			        lazyLoadingInPrevNext : true,
			        observer:true,
			        onInit: function(swiper){
			        	for (var i = 0; i < zongAmount; i++) {
			        		swiper.appendSlide('<div class="swiper-slide"><div class="pic"><img data-src="' + imgSrcArr[i] + '" class="swiper-lazy"><div class="swiper-lazy-preloader"></div></div>' + '</div>');

			        	}
						swiper.slideTo(_index, 0, false);
						swiperTit.find('.em1').html(swiper.activeIndex + 1);
						swiperTit.find('.em2').html(zongAmount);
				    },
				    onSlideChangeEnd: function(swiper){
				    	swiperTit.find('.em1').html(swiper.activeIndex + 1);
				    }
			    });
			    swiperFlag = 1;
		    } else {
		    	mySwiper.removeAllSlides();
		    	for (var i = 0; i < zongAmount; i++) {
		    		mySwiper.appendSlide('<div class="swiper-slide"><div class="pic"><img src="' + imgSrcArr[i] + '"></div>' + '</div>');
	        	}
				mySwiper.slideTo(_index, 0, false);
				swiperTit.find('.em1').html(mySwiper.activeIndex + 1);
				swiperTit.find('.em2').html(zongAmount);
		    }
		});

	});
	
	// 点击关闭大图弹窗
	$('.hundDoor .close').bind('click', function () {
		$(this).parent('.hundDoor').fadeOut(80, function () {
			mySwiper.removeAllSlides();
		});
	});

    // 关闭你弹窗
    $('.hundredDoor .close').bind('click', function () {
        popUps($(this).parents('.hundredDoor'),'hide');
    });


});
</script>

</html>