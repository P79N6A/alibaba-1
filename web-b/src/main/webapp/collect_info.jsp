<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	String path = request.getContextPath();
	request.setAttribute("path", path);
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head lang="en">
	<meta charset="UTF-8">
	<title>文化云数字化平台取票管理</title>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/reset.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-index.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-new.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/lanrenzhijia.css"/><!--模拟键盘-->
	<!--[if lte IE 8]>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-ie.css"/>
	<![endif]-->
	<script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/culture.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/DatePicker/WdatePicker.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/lanrenzhijia.js"></script><!--模拟键盘-->
	<script language="javascript" src="${path}/STATIC/js/LodopFuncs.js"></script>
	<object  id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width=0 height=0>
		<embed id="LODOP_EM" type="application/x-print-lodop" width=0 height=0></embed>
	</object>
	<script type="text/javascript">
		$(function(){
			setIframeHeight();
			$("#collect_main1").hide();
			$(".ticket-top").on("click", ".menu a", function(){
				var $this= $(this);
				if(!$this.hasClass("curr")){
					$this.addClass("curr");
					$this.siblings().removeClass("curr");
					$(".line_pop_card>div").eq($this.index()).show();
					$(".line_pop_card>div").eq($this.index()).siblings().hide();
				}
			});
		});
		$(window).resize(function(){
			setIframeHeight();
		});
		/*设置iframe的高度*/
		function setIframeHeight(){
			var winH = $(window).height();
			var ifr = $("#book-iframe");
			ifr.css("height", winH-163);
			var layerBox = $("#ticket-layer");
			var layerTop = parseInt(($(window).height() - layerBox.height())/2);
			layerBox.css({"top": layerTop});
		}
		function showTicketMsg(title, msg){
			var $body = $('body');
			var ticketBg = $('<div></div>').addClass("ticket-body-bg").appendTo($body);
			var html = '<div id="ticket-layer">'+
					'<div class="layer-info">'+
					'<div class="txt">'+
					'<h3>'+ title +'</h3>'+
					'<p>'+ msg +'</p></div>'+
					'<a class="btn-confirm">确定</a>'+
					'</div></div>';
			var layerBox = $(html).appendTo($body);
			var layerTop = parseInt(($(window).height() - layerBox.height())/2);
			layerBox.css({"top": layerTop});
			$(".btn-confirm").click(function(){
				$("#ticket-layer").remove();
				$(".ticket-body-bg").remove();
			});
		}

		var a=window.location.href;
		if(a.indexOf('date')==-1){
			window.location.href=a+'&date='+new Date();
		}

		function PrintPiao()
		{
					var orderValidateCode=$(".coll_password").val();
					var area=QueryString('area');
					$.ajax({
						type:"post",
						url:"${path}/ticket/validateCode.do",
						data:{"orderValidateCode":orderValidateCode,"area":area},
						dataType: "json",
						success:function(data){
							if(data.status==0){
								if(data.data.length>30){
									$("#page1").html(data.data);
									printAct();
									showPiao();
									setTimeout('hidePiao()',6000);
								}
							}
							if(data.status==14113 || data.status==14112){
								showTicketMsg('取票信息有误',data.data);
							}
						}
					});
		}

		function QueryString(item){
			var sValue=location.search.match(new RegExp("[\?\&]"+item+"=([^\&]*)(\&?)","i"))
			return sValue?sValue[1]:sValue
		}

		//取票成功后，显示取票动画
		function showPiao(){
			var str = '<img src="${path}/STATIC/image/collect_success.png"/>';
			$("#flashContent").html(str);
			$("#collect_main1").hide();
			$("#collect_main3").show();
		}
		//隐藏取票动画，转到取票页面
		function hidePiao(){
			$("#flashContent").html('');
			$("#collect_main1").show();
			$("#collect_main3").hide();
			$(".coll_password").val('');
			window.formColl.coll_password.focus();
		}
	</script>
</head>
<body style="background-color: #ffffff;">
<div class="ticket-top">
	<div class="menu">
		<a><span>取票</span></a>
		<a class="curr"><span>订票</span></a>
	</div>
</div>
<div class="line_pop_card" id="line_success" style="width: 100%;">
	<div id="collect_main1" style="width: 1073px; margin: 0 auto;">
		<div class="line_pop_content line_pop_content3">
			<h2>请输入取票码</h2>
			<div id="container">
				<form name="formColl"><input type="text" id="write" class="coll_password" name="coll_password"></form>
					 <ul id="keyboard" style="overflow: hidden;">
						<li class="symbol"><span class="off">`</span><span class="on">~</span></li>
						<li class="symbol"><span class="off">1</span><span class="on">!</span></li>
						<li class="symbol"><span class="off">2</span><span class="on">@</span></li>
						<li class="symbol"><span class="off">3</span><span class="on">#</span></li>
						<li class="symbol"><span class="off">4</span><span class="on">$</span></li>
						<li class="symbol"><span class="off">5</span><span class="on">%</span></li>
						<li class="symbol"><span class="off">6</span><span class="on">^</span></li>
						<li class="symbol"><span class="off">7</span><span class="on">&amp;</span></li>
						<li class="symbol"><span class="off">8</span><span class="on">*</span></li>
						<li class="symbol"><span class="off">9</span><span class="on">(</span></li>
						<li class="symbol"><span class="off">0</span><span class="on">)</span></li>
						<li class="symbol"><span class="off">-</span><span class="on">_</span></li>
						<li class="symbol"><span class="off">=</span><span class="on">+</span></li>
						<li class="delete lastitem">delete</li>
						<li class="tab">tab</li>
						<li class="letter">q</li>
						<li class="letter">w</li>
						<li class="letter">e</li>
						<li class="letter">r</li>
						<li class="letter">t</li>
						<li class="letter">y</li>
						<li class="letter">u</li>
						<li class="letter">i</li>
						<li class="letter">o</li>
						<li class="letter">p</li>
						<li class="symbol"><span class="off">[</span><span class="on">{</span></li>
						<li class="symbol"><span class="off">]</span><span class="on">}</span></li>
						<li class="symbol lastitem"><span class="off">\</span><span class="on">|</span></li>
						<li class="capslock">caps lock</li>
						<li class="letter">a</li>
						<li class="letter">s</li>
						<li class="letter">d</li>
						<li class="letter">f</li>
						<li class="letter">g</li>
						<li class="letter">h</li>
						<li class="letter">j</li>
						<li class="letter">k</li>
						<li class="letter">l</li>
						<li class="symbol"><span class="off">;</span><span class="on">:</span></li>
						<li class="symbol"><span class="off">'</span><span class="on">&quot;</span></li>
						<li class="return lastitem">return</li>
						<li class="left-shift">shift</li>
						<li class="letter">z</li>
						<li class="letter">x</li>
						<li class="letter">c</li>
						<li class="letter">v</li>
						<li class="letter">b</li>
						<li class="letter">n</li>
						<li class="letter">m</li>
						<li class="symbol"><span class="off">,</span><span class="on">&lt;</span></li>
						<li class="symbol"><span class="off">.</span><span class="on">&gt;</span></li>
						<li class="symbol"><span class="off">/</span><span class="on">?</span></li>
						<li class="right-shift lastitem">shift</li>
						<li class="space lastitem">&nbsp;</li>
					</ul>
			</div>
		</div>
		<input type="submit" value="确定取票" class="sure_btn" onclick="PrintPiao();"/>
	</div>

	<div class="book-ticket">
		<iframe src="${path}/frontActivity/venueBookIndex.do" width="100%" frameborder="0" id="book-iframe"></iframe>
	</div>

	<div class="collect_main coflash clearfix" id="collect_main3">
		<div id="flashContent" style="text-align:center;">
		</div>
	</div>
</div>
<!--ticket end-->
<div id="printsfz" style="display:none">
	<div id='page1'>
		<div style='font-family:微软雅黑;font-size:20px;'> [文化云]活动预约<br>嘉定区图书馆预定活动</div>
		<div style='font-family:微软雅黑;font-size:10px;'>地点:彭浦新村地铁站:<br>时间:2015-12-02<br>
			座位：<span style='font-family:微软雅黑;font-size:18px;'>1排1座</span><br>
			票类：网络票<br>
			sb.append("取票时间：2015-12-02 12:49  <br>
			恭候您的大驾光临！<br></div>
		<div style='font-family:微软雅黑;font-size:11px;'>温馨提醒:开场前停止入场,未入场达2次本年将取消订票资格.<br>
			----------------------------------------<br></div>

		<div style='font-family:微软雅黑;font-size:10px;'>更多精彩内容请访问 http://www.wenhuayun.cn</div><br>
		<div style='font-family:微软雅黑;font-size:20px;'>副券</div><br>
		<div style='font-family:微软雅黑;font-size:10px;'>账号:张三 <br> 座位号:1排1座</div>
	</div>

</div>
<script language="javascript" type="text/javascript">
	var LODOP; //声明为全局变量
	function printAct() {
		LODOP=getLodop(document.getElementById('LODOP'),document.getElementById('LODOP_EM'));
		LODOP.PRINT_INIT("");
		LODOP.SET_PRINT_PAGESIZE(3,800,0,"");
		LODOP.SET_PRINT_STYLEA(1, "ItemType", 0);
		LODOP.SET_PRINT_STYLEA(1,"FontName","微软雅黑");
		LODOP.SET_PRINT_STYLEA(1,"FontSize",8);
		LODOP.ADD_PRINT_HTM(10,20,800,400,document.getElementById("printsfz").innerHTML);
		LODOP.ADD_PRINT_BARCODE(270,55,140,140,"QRCode",$(".coll_password").val());
		//LODOP.PREVIEW(); //打印预览
		LODOP.PRINT();	//打印
	};
</script>
</body>
</html>