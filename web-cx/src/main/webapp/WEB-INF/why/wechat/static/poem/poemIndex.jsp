<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·每日诗品</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css?t=New Date()"/>
	
	<script>
		var poem;
	
		if (userId == null || userId == '') {
			//判断登陆
		   	publicLogin("${basePath}wechatStatic/poemIndex.do");
		}else{
			//已完成答题的跳赏析页
			$.ajax({
        		type: 'post',  
      			url : "${path}/wechatStatic/queryPoemList.do",  
      			dataType : 'json',
      			async : false,
      			data: {poemDate:'${poemDate}',userId:userId},
      			success: function (data) {
      				if(data.length>0 && data[0].poemIsComplete == 1){
    					location.href = "${path}/wechatStatic/poemComplete.do?poemDate=${poemDate}";
    					return;
    				}
      			}
    		});
		}
		
		//分享是否隐藏
		if(window.injs){
		   	//分享文案
		   	appShareTitle = '每日诗品-名师古诗赏析+填字游戏，快来挑战你的古诗功底！';
		   	appShareDesc = '每天一位中文名师，带你赏析古诗的独特魅力，争当古诗词达人！';
		   	appShareImgUrl = 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg';
		   	
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
					title: "每日诗品-名师古诗赏析+填字游戏，快来挑战你的古诗功底！",
					desc: '每天一位中文名师，带你赏析古诗的独特魅力，争当古诗词达人！',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg'
				});
				wx.onMenuShareTimeline({
					title: "每日诗品-名师古诗赏析+填字游戏，快来挑战你的古诗功底！",
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg'
				});
				wx.onMenuShareQQ({
					title: "每日诗品-名师古诗赏析+填字游戏，快来挑战你的古诗功底！",
					desc: '每天一位中文名师，带你赏析古诗的独特魅力，争当古诗词达人！',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg'
				});
				wx.onMenuShareWeibo({
					title: "每日诗品-名师古诗赏析+填字游戏，快来挑战你的古诗功底！",
					desc: '每天一位中文名师，带你赏析古诗的独特魅力，争当古诗词达人！',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg'
				});
				wx.onMenuShareQZone({
					title: "每日诗品-名师古诗赏析+填字游戏，快来挑战你的古诗功底！",
					desc: '每天一位中文名师，带你赏析古诗的独特魅力，争当古诗词达人！',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg'
				});
			});
		}
	
		$(function () {
		    
			$.post("${path}/wechatStatic/queryPoemList.do",{poemDate:'${poemDate}'}, function (data) {
				if(data.length>0){
					poem = data[0];
					readPoetry(data[0]);
					$("#poemLectorDiv").fadeIn(100);
				}else{
					$("#poemShowDiv").css({"padding":"400px 0 0 279px","font-size":"30px","color":"#6B6969","font-weight":"bolder"});
					$("#poemShowDiv").html("本日暂无数据~");
				}
				
				$("#poemShowDiv").show();
			},"json");
			
			//swiper初始化div
		    initSwiper();
			
			// 引导页上滑
			var urlSess = window.sessionStorage.getItem("touchName");//读取
			if(urlSess == '1') {
		        $(".dailyPty_yinc").hide();
		    } else {
		        // 引导页上滑
		        $('html,body').css('overflow','hidden');
		        $(".dailyPty_yinc").bind('click',function() {
		            $(this).animate({
		                top: "50px",
		            }, 500).animate({
		                top: "-3000px",
		            }, 300, function () {
		                $(this).hide();
		                $('html,body').css('overflow','visible');
		            });
		            window.sessionStorage.setItem("touchName", '1'); //存入
		        });
		        $(".dailyPty_yinc").bind('touchstart',function() {
		            $(this).animate({
		                top: "50px",
		            }, 500).animate({
		                top: "-3000px",
		            }, 300, function () {
		                $(this).hide();
		                $('html,body').css('overflow','visible');
		            });
		            window.sessionStorage.setItem("touchName", '1'); //存入
		            return false;
		        });
		    }
		    $(".dailyPty_yinc .ssgz").bind('click', function (evt) {
		        var e = evt || window.event;
		        e.stopPropagation();
		    });
		    $(".dailyPty_yinc .ssgz").bind('touchstart', function (evt) {
		        var e = evt || window.event;
		        e.stopPropagation();
		    });

		    // 关闭你讲师弹窗
		    $('.shiLectorDoor .zhidaole').bind('click', function () {
		    	$(this).parents('.shiDoorWc').stop().fadeOut(100);
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
		});
		
		// 读取诗词数据
		function readPoetry(data) {
			var neir = data.poemTemplate;
			neir = neir.replace(/\#/g,'<input type="text" readonly="readonly">')
			var txt1 = '<div class="tit">' + data.poemTitle + '</div>' + '<div class="author">' + data.poemAuthor + '</div>' + '<div class="neir">' + neir.replace(/\r\n/g,'<br>') + '</div>';
			$('.fillPoetry').html(txt1);
			var _poemWord = data.poemWord.split(',');
			var lunArr = _poemWord.sort(function(){ return 0.5 - Math.random() }) 
			var txt2 = '';
			for(var i in lunArr) {
				txt2 = txt2 + '<li onclick="fillPoetry(this)">' + _poemWord[i] + '</li>';
			}
			$('.keyReelList').html(txt2);
			
			$("#lectorHeadImg img").attr("src",data.lectorHeadImg+"@150w");
			$("#lectorHeadImg img").attr("onclick","previewImg('"+data.lectorHeadImg+"','"+data.lectorHeadImg+"')");
			$("#lectorName").html(data.lectorName);
			$("#lectorJob").html(data.lectorJob);
			$("#lectorIntro").html(data.lectorIntro.replace(/\r\n/g,'<br>'));
		}
		
		// 填空
		var fillPoetryIndex = 0;
		function fillPoetry(ele) {
			if(fillPoetryIndex <= 3) {
				if($(ele).hasClass('cur')) {
					return;
				}
				$('.fillPoetry .neir input').eq(fillPoetryIndex).val($(ele).html());
				$(ele).addClass('cur');
				fillPoetryIndex++;
			}
		}
		
		// 提交验证
		function checkPoetry() {
			var _poemWord = poem.poemWord.split(',');
			var _inputTxt = $('.fillPoetry .neir input');
			for(var i = 0; i < _inputTxt.length; i++) {
				if(!(_inputTxt.eq(i).val() == _poemWord[i])) {
					$('#shicuo').show();
					return;
				}
			}
			
			$.post("${path}/wechatStatic/addPoemUser.do",{userId:userId,poemId:poem.poemId}, function (data) {
				if(data == "200"){
					$('#shidui').show();
				}else if(data == "100"){
					$('#shidui2').show();
				}else{
					dialogAlert('系统提示', '提交出错！');
				}
			},"json");
			return;
		}
		
		// 重新填写
		function againFill() {
			$('.keyReelList li').removeClass('cur');
			$('.fillPoetry .neir input').val('');
			fillPoetryIndex = 0;
		}
		
		// 重新答题
		function againAnswer() {
			$('#shicuo').hide();
			againFill();
		}
		
		//正确答案
		function toComplete(){
			location.href = "${path}/wechatStatic/poemComplete.do?poemDate="+poem.poemDate;
		}
	</script>
	
	<style>
		html,body {min-height: 100%;background: url(${path}/STATIC/wxStatic/image/dailyPoetry/bg2.jpg) no-repeat top center;background-color: #eee}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg"/></div>
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
	
	<!-- 引导页 -->
	<div class="dailyPty dailyPty_yinc">
	    <img class="bg" src="${path}/STATIC/wxStatic/image/dailyPoetry/bg1.jpg">
	    <div class="jiant"></div>
	    <ul class="lccshare clearfix ssgz">
			<li class="share-button"><a href="javascript:;">分享</a></li>
			<li class="keep-button"><a href="javascript:;">关注</a></li>
			<li onclick="toWhyIndex();"><a href="javascript:;">首页</a></li>
		</ul>
		<div class="guijiang ssgz">
			<a href="${path}/wechatStatic/poemRule.do"><img src="${path}/STATIC/wxStatic/image/dailyPoetry/icon1.png">活动规则</a>
			<a href="${path}/wechatStatic/poemLectorList.do"><img src="${path}/STATIC/wxStatic/image/dailyPoetry/icon2.png">名&nbsp;&nbsp;师&nbsp;&nbsp;团</a>
		</div>
	</div>
	
	<!-- 首页 -->
	<div class="dailyPty">
		<ul class="lccshare clearfix">
			<li><a href="${path}/wechatStatic/poemRule.do">活动规则</a></li>
			<li class="share-button"><a href="javascript:;">分享</a></li>
			<li onclick="toWhyIndex();"><a href="javascript:;">首页</a></li>
		</ul>
		<table class="jinrps">
			<tr>
				<td class="td1">${fn:substring(poemDate, 0, 4)}年<fmt:parseNumber integerOnly="true" value="${fn:substring(poemDate, 5, 7)}" />月</td>
				<td class="td2" rowspan="2">今日诗品</td>
			</tr>
			<tr><td class="td3"><fmt:parseNumber integerOnly="true" value="${fn:substring(poemDate, 8, 10)}" /></td></tr>
		</table>
		
		<div id="poemShowDiv" style="display: none;">
			<div class="fillPoetry"></div>
			<div class="zenmewan"><div onclick="$('#zhongmewan').show()"></div></div>
			<div class="keyReel">
				<div class="clearfix"><div class="backtian" onclick='againFill()'>重填</div></div>
				<ul class="keyReelList clearfix"></ul>
			</div>
			<div class="subBtn" onclick='checkPoetry()'></div>
		</div>
	
		<!-- 讲师弹窗 -->
		<div id="poemLectorDiv" class="shiDoorWc" style="display: none;">
			<div class="shiLectorDoor">
				<div class="toux" id="lectorHeadImg"><div><img src=""></div></div>
				<div class="name" id="lectorName"></div>
				<div class="xuex" id="lectorJob"></div>
				<div class="neirong" id="lectorIntro"></div>
				<div class="zhidaole"></div>
			</div>
		</div>
		
		<!-- 答对了 -->
		<div class="shiDoorWc" id="shidui" style="display:none;">
			<div class="shidatiDoor">
				<div class="tupian">
					<div class="da">答对了</div>
					今日任务完成+100分
				</div>
				<div class="anniu">
					<a href="javascript:;" onclick="toComplete();">赏析<em></em></a>
				</div>
			</div>
		</div>
		<div class="shiDoorWc" id="shidui2" style="display:none;">
			<div class="shidatiDoor">
				<div class="tupian">
					<div class="da" style="margin-top: 92px;">答对了</div>
				</div>
				<div class="anniu">
					<a href="javascript:;" onclick="toComplete();">赏析<em></em></a>
				</div>
			</div>
		</div>
		
		<!-- 答错了 -->
		<div class="shiDoorWc" id="shicuo" style="display:none;">
			<div class="shidatiDoor">
				<div class="tupian">
					<div class="da">答错了</div>
					三人行，必有吾师焉
				</div>
				<div class="anniu">
					<a href="javascript:;" onclick="againAnswer();">重新答题<em></em></a>
					<a href="javascript:;" onclick="toComplete();">正确答案<em></em></a>
				</div>
			</div>
		</div>
		
		<!-- 怎么玩 -->
		<div class="shiDoorWc" id="zhongmewan" style="display:none;">
			<div class="shiLectorDoor">
				<div class="neirong">
					<ol class="zhongmewan">
						<li>依次点击选中的字，会按顺序填在诗歌空格处。</li>
						<li>填完要修改？点击 “&nbsp;&nbsp;&nbsp;<span style="font-size: 22px;color:#666;">重填&nbsp;</span><img src="${path}/STATIC/wxStatic/image/dailyPoetry/icon5.png">&nbsp;&nbsp;&nbsp;” ，重新点击。</li>
						<li>确认无误？“&nbsp;&nbsp;&nbsp;<img style="height:32px;width:auto;" src="${path}/STATIC/wxStatic/image/dailyPoetry/icon4.png">&nbsp;&nbsp;&nbsp;” 就知道你的古诗功底怎么样啦！答对即获100积分。</li>
					</ol>
				</div>
				<div class="zhidaole"></div>
			</div>
		</div>
	</div>
</body>
</html>