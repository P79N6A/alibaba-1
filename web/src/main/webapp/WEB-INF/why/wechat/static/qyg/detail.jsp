<%@ page language="java" pageEncoding="UTF-8" %>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>公共文化配送产品设计大赛</title>
        <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
        <link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css">
	</head>
	
	<style>
		#pszxWorksNow{border:1px solid #ddd5e1;}
		tr{display: table-row!important;}
		td{display: table-cell!important;}
	</style>

	<script type="text/javascript">
	    var entryId = '${entryId}';
	    var entry='${entry}';
	    var noVote = '${noVote}';	//1：不可投票
	     shareTitle = "给"+'${entry.projectName}'+"投上一票，将文化的美好之处传递下去";
		 shareDesc = "2016年上海市民文化节公共文化配送产品设计大赛市民投票活动";
		 assnIconUrl = "${basePath}/STATIC/wxStatic/image/pszx/shareIcon.jpg";
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
				jsApiList: ['onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone','getNetworkType']
			});
			
			wx.ready(function () {
            	wx.onMenuShareAppMessage({
                    title: shareTitle,
                    desc: shareDesc,
                    link: '${basePath}wechatQyg/toDetail.do?entryId='+entryId,
                    imgUrl: assnIconUrl
                });
                wx.onMenuShareTimeline({
                    title: shareTitle,
                    imgUrl: assnIconUrl,
                    link: '${basePath}wechatQyg/toDetail.do?entryId='+entryId
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
                wx.getNetworkType({
	        	    success: function (res) {
	        	        var networkType = res.networkType; // 返回网络类型2g，3g，4g，wifi
	        	        if(networkType!='wifi'){
	        	        	isWifi = false;
	        	        	dialogAlert("提示", "您正在使用非wifi网络，观看视频将产生流量费用！");
	        	        }
	        	    }
	        	});
            });
		}else{
			//APP判断网络
			if(window.injs){
				if(injs.currentNetworkState()!=1){
					isWifi = false;
    	        	dialogAlert("提示", "您正在使用非wifi网络，观看视频将产生流量费用！");
				}
			}
		}
		
		function addVideo(src) {
			$("#pszxWorksNow").children().remove()
			$("#pszxWorksNow").append(
				'<video class="pszxChild" src="' + src + '" style="width:100%;height: 100%;" controls=""></video>' +
				'<div id="pszxVideoTitle">'+"${entry.videoName}"+'</div>'
			)
		}
		
		$(function() {
			
			
			// 分享事件绑定
			//分享
		 	$(".culture-lapiao").click(function() {
				 if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
					dialogAlert('系统提示', '请用微信浏览器打开分享！');
				}else{ 
					$("html,body").addClass("bg-notouch");
					$(".background-fx").css("display", "block")
				}  
			})
			
			$('.background-fx').click(function () {
				$(this).hide();
			});
			
			
			//视频名称
			var videoName='';
			videoName+='${entry.videoName}';
			
			// 视频地址
			var videoUrl='';
			videoUrl+='${entry.videoUrl}';
			
			//视频封面地址
			var videoCoverImg='';
			videoCoverImg+='${entry.videoCoverImg}';
			
			//海报图片
			var  posterImg='';
			posterImg+='${entry.posterImg}';
			
			//视频
			var videoUrlHtml='';
			if(videoUrl!=''){
				if(videoCoverImg!='')
					videoUrlHtml+="<li class='pszxBorder pszxVideo'><img class='pszxChild' data-src="+videoCoverImg+" src="+videoCoverImg+'@240w'+" style='display: block;max-width:240px;max-height:170px;margin:auto;position:absolute;left:0;right:0;top:0;bottom:0;' /><div id='triangle'></div></li>";
				else
					videoUrlHtml+="<li class='pszxBorder pszxVideo'><img class='pszxChild' src='${path}/STATIC/wxStatic/image/qyg/video.jpg' style='display: block;max-width:240px;max-height:170px;margin:auto;position:absolute;left:0;right:0;top:0;bottom:0;' /><div id='triangle'></div></li>";
			}
			
			//海报
			var posterImgHtml='';
			if(posterImg!=''){
				if(videoUrlHtml!=''){
					posterImgHtml+="<li><img class='pszxChild' data-src="+posterImg+" src="+posterImg+'@240w'+" style='display: block;max-width:240px;max-height:170px;margin:auto;position:absolute;left:0;right:0;top:0;bottom:0;' /></li>";	
				}else{
					posterImgHtml+="<li><img class='pszxChild' data-src="+posterImg+" src="+posterImg+'@240w'+" style='display: block;max-width:240px;max-height:170px;margin:auto;position:absolute;left:0;right:0;top:0;bottom:0;' /><div id='triangle'></div></li>";
				}
			}
			
			// 舞台剧照
			var stageImg='';
			stageImg+='${entry.stageImg}';
			var stageImgs=[];
			if(stageImg!=undefined && stageImg!=''){
				stageImgs=stageImg.split(",");	
			}
			
			// 拼接图片
			var stageImgHtml='';
			$.each(stageImgs,function(index,value){
				if(index==0 && videoUrlHtml=='' && posterImgHtml==''){
					stageImgHtml+="<li><img class='pszxChild' data-src="+value+" src="+value+'@240w'+" style='display: block;max-width:240px;max-height:170px;margin:auto;position:absolute;left:0;right:0;top:0;bottom:0;' /><div id='triangle'></div></li>"	
				}else{
					stageImgHtml+="<li><img class='pszxChild' data-src="+value+" src="+value+'@240w'+" style='display: block;max-width:240px;max-height:170px;margin:auto;position:absolute;left:0;right:0;top:0;bottom:0;' /></li>"
				}
			});
			// exhibition_impression_drawing  布展效果图
			
			var exhibitionImpressionDrawing ='';
			exhibitionImpressionDrawing+='${entry.exhibitionImpressionDrawing}';
			var exhibitionImpressionDrawings=[];
			if(exhibitionImpressionDrawing!=undefined && exhibitionImpressionDrawing!=''){
				exhibitionImpressionDrawings=exhibitionImpressionDrawing.split(",");	
			}
			var exhibitionImpressionDrawingHtml='';
			$.each(exhibitionImpressionDrawings,function(index,value){
				if(index==0 && videoUrlHtml=='' && posterImgHtml=='' &&stageImgHtml==''){
					exhibitionImpressionDrawingHtml+="<li><img class='pszxChild' data-src="+value+" src="+value+'@240w'+" style='display: block;max-width:240px;max-height:170px;margin:auto;position:absolute;left:0;right:0;top:0;bottom:0;' /><div id='triangle'></div></li>"	
				}else{
					exhibitionImpressionDrawingHtml+="<li><img class='pszxChild' data-src="+value+" src="+value+'@240w'+" style='display: block;max-width:240px;max-height:170px;margin:auto;position:absolute;left:0;right:0;top:0;bottom:0;' /></li>"
				}
			});
			
			// 视频,海报,舞台剧照,布展效果图
			$("#banner-list").html(videoUrlHtml+posterImgHtml+stageImgHtml+exhibitionImpressionDrawingHtml);
			console.log(videoUrlHtml+posterImgHtml+stageImgHtml+exhibitionImpressionDrawingHtml);
			
 			var liNum = $(".pszxWorksWidth").find("li").length;
			liNum = liNum * 250 - 8;
			$(".pszxWorksWidth").css("width", liNum);

			$(".pszxWorksDiv li").click(function() {
				$("#triangle").remove()
				$(".pszxWorksDiv li").removeClass("pszxBorder")
				$(this).append('<div id="triangle"></div>')
				$(this).addClass("pszxBorder")
				if($(this).hasClass("pszxVideo")) {
					addVideo(videoUrl);
				} else {
					//					$("#pszxWorksNow").find("#pszxVideoTitle").remove()
					$("#pszxWorksNow").children().remove()
					var child = $(this).find(".pszxChild").clone()
					var videoImgSrc = $("#pszxWorksNow").append(child).children().not("#pszxVideoTitle").attr("data-src") + "@670w"
					$("#pszxWorksNow").append(child).children().not("#pszxVideoTitle").attr("src",videoImgSrc)
					$("#pszxWorksNow").append(child).children().not("#pszxVideoTitle").css({
						"max-width": "668px",
						"max-height": "388px",
						"margin":"auto"
					})
				}
			})

			// 关闭你弹窗
			$('.pszxDoor .close').bind('click', function() {
				popUps($(this).parents('.pszxDoor'), 'hide');
			});
			
			
					  if(videoUrl!=''){
						 $("#video1").attr("src",videoUrl);
							$("#videoImgUrl").attr("src",videoCoverImg+"@350w");
							$("#pszxVideoTitle").text(videoName);
							var ImgObj = new Image();
							ImgObj.src = videoCoverImg+"@350w";
							ImgObj.onload = function(){
								if(ImgObj.width/ImgObj.height>750/435){
									var pLeft = (ImgObj.width*(435/ImgObj.height)-750)/2;
									$("#videoImgUrl").css({"height":"388px","position":"absolute","left":"-"+pLeft+"px"});
								}else{
									var pTop = (ImgObj.height*(750/ImgObj.width)-435)/2;
									$("#videoImgUrl").css({"width":"668px","position":"absolute","top":"-"+pTop+"px"});
								}
							}
							$('#video1').on('play', function() {
								if(!isWifi){
									dialogAlert("提示", "您的流量正在燃烧哟~~");
								}
							});
						 
					 }else{
						 //TODO  获取  banner-list 中第一张图片
						  $("#pszxWorksNow").children().remove();
						   var child=$("#banner-list").children(":first").find('img').clone();
						   $("#pszxWorksNow").append(child);
						      var imgSrc = $("#pszxWorksNow").append(child).find("img").attr("data-src") + "@670w";
						 $("#pszxWorksNow").append(child).find("img").attr("src",imgSrc).css({
							 "max-width":"668px",
							 "max-height":"388px"
						 })
					 }
					
					
 				 
					if('{entry.isVote}' == 1){
						$('.delivery .lptp .tp div').css('background-image','url(${path}/STATIC/wxStatic/image/qyg/pic14.png)');
					}
					

					
			//	}
			//},"json");
		})
		
		
		// 弹窗的打开和关闭
			function popUps(windowEle, action, callback) {
				// windowEle:弹窗元素；action表示行为，可以是show或者hide；callback回调函数；
				if(action == 'show') {
					$('.pszxDoorFc').show();
					windowEle.show();
				} else {
					$('.pszxDoorFc').hide();
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
	            	publicLogin("${basePath}wechatQyg/toDetail.do?entryId="+entryId);
	        	}else{
	        		$.post("${path}/wechatQyg/addVote.do",{userId:userId,entryId:entryId}, function (data) {
	        			 if(data == "100"){
	        				$("#entryId").val(entryId);
	   						popUps($('.pszxDoor_info'), 'show');
	    				}else if(data == "200"){
	    					$('.pszxMain .pszxFooter .pszxRightBtn').addClass('add');
	   						/* var ele = $('.pszxMain .pszxFooter .pszxRightBtn').find('span');
	   						ele.html(parseInt(ele.html()) + 1); */
	   						popUps($('.pszxDoor_success'),'show');
	   						var span=$("#count").html();
	   						if(span=='' || span==undefined){
	   							span=0;
	   						}
							var num=parseInt(span);
	   						$("#count").html(num+1);
	   						
	   						
	   						
	    				}else if(data == "repeat"){
	    					popUps($('.pszxDoor_success'),'hide');
	    					popUps($('.pszxDoor_nostart'),'show');
	    				}else if(data == "500"){
	    					dialogAlert('系统提示', '投票失败！');
	    				}
	    			},"json");
	        	}
			 }else{ 
				 $("#dialog5").css("display","table"); 
				 popUps($(".menban"), 'show');
				/*  $(".menban").show(); */ 
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
				dialogAlert('系统提示', '请输姓名！');
		        return false;
			}
			var data = {
				userId:userId,
				userTelephone:userMobile,
				userNickName:userName
			}
			
			
			if (userId == null || userId == '') {
        		//判断登陆
            	publicLogin("${basePath}wechatQyg/toDetail.do?entryId="+entryId);
        	}else{
			$.post("${path}/terminalUser/editTerminalUser.do", data, function(data) {
				if (data == "success") {
					$.post("${path}/wechatQyg/insertQygUser.do",{userId:userId,cellphone:userMobile,userName:userName,entryId:entryId},function(){
						if(data == "success"){
							var span=$("#count").html();
	   						if(span=='' || span==undefined){
	   							span=0;
	   						}
							var num=parseInt(span);
	   						$("#count").html(num+1);
							popUps($('.pszxDoor_info'),'hide',function () {
								  popUps($('.pszxDoor_success'),'show');
							  });
						}
					})
					$("#dialog3").hide();
					popUps($('#dialog1'),'show');
				}else {
					dialogAlert('系统提示', "提交失败")
				}
			},"json");
        	}
		}
	
	
	</script>
	<body>
	 <%   request.setAttribute("vEnter", "\r\n");   %>
		<div class="pszxMain">
		    <div onclick="location.href='${path }/wechatQyg/index.do?guide=1&tab=0'" style="height: 75px;background-color: #653e97;line-height: 75px;">
				<img style="margin-left: 10px;" src="${path}/STATIC/wxStatic/image/pszx/arrow.png" />
				<span style="font-size: 26px;color: #fff;margin-left: 10px;">返回2016年公共文化配送产品设计大赛首页 </span>
			</div>
			<div class="pszxContent">
				<div class="pszxActTitle">${entry.projectName}</div>
				<c:choose>
				 	<c:when test="${entry.entrySubject=='文艺演出'}">
						 <div class="pszxFModel">
							<div class="pszxFModelTitle">节目概述</div>
							<div class="pszxFModelFont" id="topicPurport">
							 ${fn:replace(entry.entryDescription, vEnter, "<br/>")}  
							</div>
							<div class="pszxFModelType">节目类型：<span id="declarationCategory">${entry.declarationCategory}</span></div>
						</div>
					</c:when>
					<c:when test="${entry.entrySubject=='艺术导赏'}">
						 <div class="pszxFModel">
				  			 <div class="pszxFModelTitle">导赏内容</div>
							 <div class="pszxFModelFont"  id="topicPurport">
							  ${fn:replace(entry.entryDescription, vEnter, "<br/>")}  
							 </div>
				         </div>
					 </c:when>
				     <c:when test="${entry.entrySubject=='展览展示'}">
				 		  <div class="pszxFModel">
				    		 <div class="pszxFModelTitle">选题主旨</div>
						     <div class="pszxFModelFont" id="topicPurport">
						      ${fn:replace(entry.topicPurport, vEnter, "<br/>")}  
						     </div>
						     <div class="pszxFModelType">节目类型：<span >${entry.declarationCategory}</span></div>
					      </div>	
				          <div class="pszxFModel">
						      <div class="pszxFModelTitle">活动内容</div>
						      <div class="pszxFModelFont" id="entryDescription">
						         ${fn:replace(entry.supportingActivity, vEnter, "<br/>")}  
						     </div>
				          </div> 
				     </c:when>
				     <c:when test="${entry.entrySubject=='特色活动'}">
				 		   <div class="pszxFModel">
				               <div class="pszxFModelTitle">选题主旨</div>
						       <div class="pszxFModelFont" >
						        ${fn:replace(entry.topicPurport, vEnter, "<br/>")}  
						       </div>
				           </div>		
 				           <div class="pszxFModel">
						       <div class="pszxFModelTitle">效果目标</div>
						       <div class="pszxFModelFont" id="entryDescription">
						        ${fn:replace(entry.activityTarget, vEnter, "<br/>")}  
				           </div> 
				      </c:when>
				</c:choose>
				
				<div class="pszxFModel">
					<div id="pszxWorksNow">
						<div id='pszxVideoTitle'></div>
						<video id="video1" src="" style="width:100%;height:100%;"></video>
					</div>
					<div class="pszxWorksList">
						<div class="pszxWorksDiv">
							<div class="clearfix pszxWorksWidth">
								<ul id="banner-list" class="clearfix">
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="pszxFooter clearfix">
				<div class="pszxLeftBtn clearfix culture-lapiao">
					<img src="${path}/STATIC/wxStatic/image/pszx/getticket.png" />
					<p>支持公共文化</p>
				</div>
				<div class="pszxRightBtn" onclick="dcVote();">
					<img src="${path}/STATIC/wxStatic/image/pszx/vote.png" />
					<p>投票<span id="count">${entry.voteCount}</span></p>
				</div>
				
			</div>
		</div>
		<!--  分享 -->
		<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
					<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
		</div>
		<!-- 弹窗 -->
		<div class="pszxDoorFc" style="display:none;">
		<input type="hidden" name="entryId" id="entryId" />
			<!-- 投票成功 -->
			<div class="pszxDoor pszxDoor_success" style="display:none;" id="dialog1">
				<div class="tit">恭喜您，投票成功！</div>
				<div class="cha close"></div>
				<div class="btnDiv">
					<a class="close" href="javascript:window.location.href='${path }/wechatQyg/index.do?guide=1&tab=0'">看看其他作品</a>
					<a class="huang culture-lapiao"   href="javascript:;">支持公共文化</a>
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
			  <div id="dialog5" class="pszxDoor" style="display:none;">
			    	<div class="nc">
			    		<p style="font-size:26px;text-align:center;color:#fff;">投票时间已结束！</p>
			    		<div class="zhidl cha close">X</div>
			    	</div>
			    </div>
		</div>
	</body>

</html>