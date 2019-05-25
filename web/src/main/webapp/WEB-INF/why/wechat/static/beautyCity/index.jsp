<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·发现城市之美</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/webuploader.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/upload-beautycity.js"></script>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var startIndex = 0;		//页数
		var tagNum = '${tagNum}';	//当前所在标签
		var isEnd = '${isEnd}';		//是否能参与（1：已结束）
		var needWirteInfo = 0;		//是否需要填写个人信息
		var beautycityVenueId = '';		//空间页查看照片用（function loadVenueImg）
		
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '上海最美的100个城市空间，你认识几个？';
	    	appShareDesc = '用手机镜头，拍下最美空间的最美印记，100元电话卡，最美城市纪念图册等你来拿';
	    	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/beautyCity/beautycityShare.jpg';
	    	
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
					title: "上海最美的100个城市空间，你认识几个？",
					desc: '用手机镜头，拍下最美空间的最美印记，100元电话卡，最美城市纪念图册等你来拿',
					imgUrl: '${basePath}/STATIC/wxStatic/image/beautyCity/beautycityShare.jpg'
				});
				wx.onMenuShareTimeline({
					title: "上海最美的100个城市空间，你认识几个？",
					imgUrl: '${basePath}/STATIC/wxStatic/image/beautyCity/beautycityShare.jpg'
				});
				wx.onMenuShareQQ({
					title: "上海最美的100个城市空间，你认识几个？",
					desc: '用手机镜头，拍下最美空间的最美印记，100元电话卡，最美城市纪念图册等你来拿',
					imgUrl: '${basePath}/STATIC/wxStatic/image/beautyCity/beautycityShare.jpg'
				});
				wx.onMenuShareWeibo({
					title: "上海最美的100个城市空间，你认识几个？",
					desc: '用手机镜头，拍下最美空间的最美印记，100元电话卡，最美城市纪念图册等你来拿',
					imgUrl: '${basePath}/STATIC/wxStatic/image/beautyCity/beautycityShare.jpg'
				});
				wx.onMenuShareQZone({
					title: "上海最美的100个城市空间，你认识几个？",
					desc: '用手机镜头，拍下最美空间的最美印记，100元电话卡，最美城市纪念图册等你来拿',
					imgUrl: '${basePath}/STATIC/wxStatic/image/beautyCity/beautycityShare.jpg'
				});
			});
		}
		
		$(function() {
			//首页不传参数
			if(tagNum == '' || tagNum == null) {
				tagNum = 0;
			}
			
			//进页面时判断标签显示
			$(".bcMenuList>ul>li").eq(tagNum).addClass("bcChoose");
			$(".bcContentList>ul>li").eq(tagNum).show();
			
			if(tagNum==1){
				loadVenue(0,100);
			}else if(tagNum==3||tagNum==0){
				if (userId != null && userId != '') {
					loadUserInfo();
					loadUserImg(0, 20);
				}else{
					$("#joinBut").show();
				}
				
				loadSelected("3b111d82388f408794fafcfc8d618305");
				loadSelected("8b3911da80744ffa817a05935b05aded");
				loadSelected("e34e3686b3e346c4b1b67a9b3c081d14");
				loadSelected("dfc9c9d0f53c482bbaa0be1571a9e734");
				loadNewest(0,20);
				loadRanking();
			}
	
			//顶部菜单fixed
			$(document).scroll(function() {
				if($(document).scrollTop() >= 250) {
					$(".bcMenuList").css("position", "fixed")
				} else if($(document).scrollTop() < 250) {
					$(".bcMenuList").css("position", "relative")
				}
			})
	
			$(".bcMyPnamePopBtn").click(function(e){
				e.stopPropagation();
			})

			//关闭图片预览
			$(".imgPreview,.imgPreview>img").click(function() {
				$(".imgPreview").fadeOut("fast");
			})
			
			//分享
			$(".bcShare").click(function() {
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
			$(".bcKeep").on("touchstart", function() {
				$('.div-share').show()
				$("body,html").addClass("bg-notouch")
			})
			
		})
		
		//加载用户信息
		function loadUserInfo(){
			$.post("${path}/wechatStatic/getBeautycityList.do",{userId:userId}, function (data) {
    			if (data.status == 1) {
    				if(data.data.list.length>0){
    					var dom = data.data.list[0];
    					var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
    					$("#userInfo1").html("<div class='bcMyImg'>"+userHeadImgHtml+"</div>" +
												"<div class='bcMyPname'>" +
													"<div>" +
														"<div class='bcMyPname1'>"+dom.createUserName+"</div>" +
														"<div class='bcMyPname2'>我的奖品</div>" +
														"<div style='clear: both;'></div>" +
													"</div>" +
													"<p>我已参与<span>"+dom.venueCount+"</span>个空间，发布了<span>"+dom.imgCount	+"</span>张照片</p>" +
												"</div>" +
												"<div class='bcMyBtn' onclick=\"$('.bcHome').hide();$('.bcHomeMe').show();\">" +
													"<img src='${path}/STATIC/wxStatic/image/beautyCity/bcMyBtn.png' />" +
												"</div>" +
												"<div style='clear: both;'></div>");
    					$("#userInfo1").show();
    					$("#userInfo2").html("<div class='bcMyImg'>"+userHeadImgHtml+"</div>" +
												"<div class='bcMyPname'>" +
													"<div>" +
														"<div class='bcMyPname1'>"+dom.createUserName+"</div>" +
														"<div class='bcMyPname2'>我的奖品</div>" +
														"<div style='clear: both;'></div>" +
													"</div>" +
													"<p>我已参与<span>"+dom.venueCount+"</span>个空间，发布了<span>"+dom.imgCount	+"</span>张照片</p>" +
												"</div>" +
												"<div style='clear: both;'></div>");
    					
    					//我的奖品弹窗
    					$(".bcMyPname2").click(function(e){
    						e.stopPropagation();
    						$(".bcMyPnamePop").show()
    						$(".bcMyPnamePop").click(function(e){
    							e.stopPropagation();
    							$(this).hide()
    						})
    					})
    					//我的奖品
    					if(dom.venueCount>=10){
    						if(dom.venueCount>=10){
        						$(".bcMyPnamePop img").after("<p style='top: 300px;'>已发布10个空间 获得500积分</p>");
        					}
    						if(dom.venueCount>=50){
        						$(".bcMyPnamePop img").after("<p style='top: 350px;'>已发布50个空间 获得1000积分</p>");
        					}
    						if(dom.venueCount==100){
    							if(dom.finishVenueRanking<=100){
        							$(".bcMyPnamePop img").after("<p style='top: 400px;'>我是第"+dom.finishVenueRanking+"名发布完所有空间的，获得【京东少儿图书卡】一张</p>");
        						}
    						}
    					}else{
    						$(".bcMyPnamePop img").after("<p style='top: 300px;'>您还未获得任何奖励</p>");
    					}
    					
    					//判断是否需要填写个人信息
    					if(dom.userName){
    						needWirteInfo = 1;	
    					}
    				}
    				$("#joinBut").show();
    			}
			},"json");
		}
		
		//加载用户照片
		function loadUserImg(index, pagesize){
			var data = {
                	userId: userId,
                	isMe: 1
                };
			$.post("${path}/wechatStatic/getBeautycityImgList.do",data, function (data) {
				if (data.status == 1) {
					var ranking = '';
					var rankingI = '';
					$.each(data.data.list, function (i, dom) {
						var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
						var beautycityImgUrl = dom.beautycityImgUrl+"@200w";
						var ImgObj = new Image();
						ImgObj.src = beautycityImgUrl;
						ImgObj.onload = function(){
    						if(ImgObj.width/ImgObj.height>310/285){
    							$("img[imgId="+dom.beautycityImgId+"]").css("height","285px");
    						}else{
    							$("img[imgId="+dom.beautycityImgId+"]").css("width","310px");
    						}
						}
						var beautycityImgUrlPreview = dom.beautycityImgUrl+"@700w";
						var voteImg = "";
						var voteOnlick = "";
						if(dom.beautycityImgIsVote==0){
            				voteImg = "${path}/STATIC/wxStatic/image/beautyCity/brvOff.png";
            				voteOnlick = "onclick='userVote(\""+dom.beautycityImgId+"\",$(this))'";
            			}else{
            				voteImg = "${path}/STATIC/wxStatic/image/beautyCity/brvOn.png";
            			}
						$("#userImgUl").append("<li>" +
													"<div class='spaceTitle'>" +
														"<div class='spaceTitleImg'>"+userHeadImgHtml+"</div>" +
														"<div class='spaceTitleName'>" +
															"<p class='sName1'>"+dom.userName+"</p>" +
															"<p class='sName2'><img src='${path}/STATIC/wxStatic/image/beautyCity/bcplace.png'/><span>"+dom.venueName+"</span></p>" +
														"</div>" +
														"<div style='clear: both;'></div>" +
													"</div>" +
													"<div class='spaceImg' onclick='showPreview(\""+beautycityImgUrlPreview+"\");'><img imgId='"+dom.beautycityImgId+"' src='"+beautycityImgUrl+"' /></div>" +
													"<div class='spaceMenu'>" +
														"<div class='bcVoted' onclick='toShare(\""+dom.beautycityImgId+"\")'>去拉票</div>" +
														"<div class='bcVotedNum'><img src='"+voteImg+"' "+voteOnlick+"/><span>"+dom.voteCount+"</span></div>" +
														"<div style='clear: both;'></div>" +
													"</div>" +
												"</li>");
						
						if(ranking>dom.ranking||i==0){
							ranking = dom.ranking;
							rankingI = i;
						}
					});
					
					//排行榜(自己)
					if(ranking>0){
						var dom = data.data.list[rankingI];
						var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
						var beautycityImgUrl = dom.beautycityImgUrl+"@200w";
						var beautycityImgUrlPreview = dom.beautycityImgUrl+"@700w";
						var ImgObj = new Image();
						ImgObj.src = beautycityImgUrl;
						ImgObj.onload = function(){
    						if(ImgObj.width/ImgObj.height>130/130){
    							$("img[rankingImgId="+dom.beautycityImgId+"]").css("height","130px");
    						}else{
    							$("img[rankingImgId="+dom.beautycityImgId+"]").css("width","130px");
    						}
						}
						var voteImg = "";
						var voteOnlick = "";
						if(dom.beautycityImgIsVote==0){
            				voteImg = "${path}/STATIC/wxStatic/image/beautyCity/brvOff.png";
            				voteOnlick = "onclick='userVote(\""+dom.beautycityImgId+"\",$(this))'";
            			}else{
            				voteImg = "${path}/STATIC/wxStatic/image/beautyCity/brvOn.png";
            			}
						$("#myRanking").html("<div class='bcRankList'>" +
												"<div class='bcRankNum bcNumMe'>"+dom.ranking+"</div>" +
											 "</div>" +
											 "<div class='bcRankImg' onclick='showPreview(\""+beautycityImgUrlPreview+"\");'>" +
												"<img rankingImgId='"+dom.beautycityImgId+"' src='"+beautycityImgUrl+"' />" +
											 "</div>" +
											 "<div class='bcRankName'>" +
												"<p class='bcRankNameTitle'>"+userHeadImgHtml+dom.userName+"</p>" +
												"<p class='bcRankNamePlace'><img src='${path}/STATIC/wxStatic/image/beautyCity/bcplace.png' />"+dom.venueName+"</p>" +
											 "</div>" +
											 "<div class='bcRankBrv'>" +
												"<img src='"+voteImg+"' "+voteOnlick+" />" +
												"<span>"+dom.voteCount+"</span>" +
											 "</div>" +
											 "<div style='clear: both;'></div>");
						$("#myRanking").show();
					}
				}
			},"json");
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
            	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png'/>";
            } else if (userHeadImgUrl.indexOf("/front/") != -1) {
                var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
                userHeadImgHtml = "<img src='" + imgUrl + "' onerror='imgNoFind();'/>";
            } else {
            	userHeadImgHtml = "<img src='" + userHeadImgUrl + "' onerror='imgNoFind();'/>";
            }
			return userHeadImgHtml;
		}
		
		//投票
		function userVote(beautycityImgId,$this){
			if(isEnd == 1){
				dialogAlert('系统提示', '活动结束，已不能投票！');
			}else{
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatStatic/beautyCity.do");
	        	}else{
	        		$this.attr("onclick","");
					$.post("${path}/wechatStatic/voteBeautycityImg.do",{beautycityImgId:beautycityImgId,userId:userId}, function (data) {
						if (data.status == 1) {
							var voteCount = $this.parent().find("span").text();
							$this.parent().find("span").text(eval(voteCount)+1);
							$this.attr("src", "${path}/STATIC/wxStatic/image/beautyCity/brvOn.png");
						}
					}, "json");
	        	}
			}
		} 
		
		//精选照片
		function loadSelected(beautycityImgId){
			var data = {
                	userId: userId,
                	beautycityImgId: beautycityImgId
                };
			$.post("${path}/wechatStatic/getBeautycityImgList.do",data, function (data) {
				if (data.status == 1) {
					$.each(data.data.list, function (i, dom) {
						var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
						var beautycityImgUrl = dom.beautycityImgUrl+"@200w";
						var beautycityImgUrlPreview = dom.beautycityImgUrl+"@700w";
						var ImgObj = new Image();
						ImgObj.src = beautycityImgUrl;
						ImgObj.onload = function(){
    						if(ImgObj.width/ImgObj.height>310/285){
    							$("img[imgId="+dom.beautycityImgId+"]").css("height","285px");
    						}else{
    							$("img[imgId="+dom.beautycityImgId+"]").css("width","310px");
    						}
						}
						var voteImg = "";
						var voteOnlick = "";
						if(dom.beautycityImgIsVote==0){
            				voteImg = "${path}/STATIC/wxStatic/image/beautyCity/brvOff.png";
            				voteOnlick = "onclick='userVote(\""+dom.beautycityImgId+"\",$(this))'";
            			}else{
            				voteImg = "${path}/STATIC/wxStatic/image/beautyCity/brvOn.png";
            			}
						$("#selectedImgUl").append("<li>" +
														"<div class='spaceTitle'>" +
														"<div class='spaceTitleImg'>"+userHeadImgHtml+"</div>" +
														"<div class='spaceTitleName'>" +
															"<p class='sName1'>"+dom.userName+"</p>" +
															"<p class='sName2'><img src='${path}/STATIC/wxStatic/image/beautyCity/bcplace.png'/><span>"+dom.venueName+"</span></p>" +
														"</div>" +
														"<div style='clear: both;'></div>" +
													"</div>" +
													"<div class='spaceImg' onclick='showPreview(\""+beautycityImgUrlPreview+"\");'><img imgId='"+dom.beautycityImgId+"' src='"+beautycityImgUrl+"' /></div>" +
													"<div class='spaceMenu'>" +
														"<div class='bcVoted' onclick='toShare(\""+dom.beautycityImgId+"\")'>去拉票</div>" +
														"<div class='bcVotedNum'><img src='"+voteImg+"' "+voteOnlick+"/><span>"+dom.voteCount+"</span></div>" +
														"<div style='clear: both;'></div>" +
													"</div>" +
												"</li>");
					});
				}
			},"json");
		}
		
		//最新照片
		function loadNewest(index, pagesize){
			var data = {
                	userId: userId,
                	resultFirst: index,
                	resultSize: pagesize
                };
			$.post("${path}/wechatStatic/getBeautycityImgList.do",data, function (data) {
				if (data.status == 1) {
					if(data.data.list.length<20){
               			$("#loadingNewestDiv").html("");
   	        		}
					$.each(data.data.list, function (i, dom) {
						var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
						var beautycityImgUrl = dom.beautycityImgUrl+"@200w";
						var beautycityImgUrlPreview = dom.beautycityImgUrl+"@700w";
						var ImgObj = new Image();
						ImgObj.src = beautycityImgUrl;
						ImgObj.onload = function(){
    						if(ImgObj.width/ImgObj.height>310/285){
    							$("img[imgId="+dom.beautycityImgId+"]").css("height","285px");
    						}else{
    							$("img[imgId="+dom.beautycityImgId+"]").css("width","310px");
    						}
						}
						var voteImg = "";
						var voteOnlick = "";
						if(dom.beautycityImgIsVote==0){
            				voteImg = "${path}/STATIC/wxStatic/image/beautyCity/brvOff.png";
            				voteOnlick = "onclick='userVote(\""+dom.beautycityImgId+"\",$(this))'";
            			}else{
            				voteImg = "${path}/STATIC/wxStatic/image/beautyCity/brvOn.png";
            			}
						$("#newestImgUl").append("<li>" +
														"<div class='spaceTitle'>" +
														"<div class='spaceTitleImg'>"+userHeadImgHtml+"</div>" +
														"<div class='spaceTitleName'>" +
															"<p class='sName1'>"+dom.userName+"</p>" +
															"<p class='sName2'><img src='${path}/STATIC/wxStatic/image/beautyCity/bcplace.png'/><span>"+dom.venueName+"</span></p>" +
														"</div>" +
														"<div style='clear: both;'></div>" +
													"</div>" +
													"<div class='spaceImg' onclick='showPreview(\""+beautycityImgUrlPreview+"\");'><img imgId='"+dom.beautycityImgId+"' src='"+beautycityImgUrl+"' /></div>" +
													"<div class='spaceMenu'>" +
														"<div class='bcVoted' onclick='toShare(\""+dom.beautycityImgId+"\")'>去拉票</div>" +
														"<div class='bcVotedNum'><img src='"+voteImg+"' "+voteOnlick+"/><span>"+dom.voteCount+"</span></div>" +
														"<div style='clear: both;'></div>" +
													"</div>" +
												"</li>");
					});
				}
			},"json");
		}
		
		//空间列表
		function loadVenue(index, pagesize){
			var data = {
                	userId: userId,
                	resultFirst: index,
                	resultSize: pagesize
                };
			$.post("${path}/wechatStatic/getBeautycityVenueList.do",data, function (data) {
				if (data.status == 1) {
					$.each(data.data, function (i, dom) {
						var venueIconUrl = getImgUrl(dom.venueIconUrl);
						var isPublishHtml = '';
						if(dom.isPublish>0){
							isPublishHtml = "<div class='upHistory'>已发布</div>";
						}
						$("#venueListUl").append("<li id='"+dom.beautycityVenueId+"'>" +
													"<div><img src='"+venueIconUrl+"' /></div>" +
													"<p>"+dom.venueName+"</p>" +
												 "</li>");
						$("#venueChooseUl").append("<li id='"+dom.beautycityVenueId+"'>" +
														"<div><img src='"+venueIconUrl+"' />"+isPublishHtml+"</div>" +
														"<p>"+dom.venueName+"</p>" +
												   "</li>");
					});
					
					//空间详情列表
					$(".beautySpaceList>li").click(function() {
						$(".beautySpaceList").hide();
						$(".beautySpaceInfo").show();
						//获取空间名字并赋值详情标题
						var sTitle = $(this).find("p").text();
						$(".beautySpaceTitle").html("#&nbsp;" + sTitle + "&nbsp;#");
						beautycityVenueId = $(this).attr("id");
						loadVenueImg(0,20);
					});
					
					//选择空间
					$(".chooseList>li").click(function() {
						var ImgUrl = $(this).find("img").attr("src");
						var ImgTitle = $(this).find("p").text();
						$(".chooseImg").attr("src", ImgUrl);
						$(".chooseTitle").html(ImgTitle);
						$(".chooseSpace").hide();
						$(".chooseSpaceOn").show();
						$(".chooseSpaceList").hide();
						var beautycityVenueId = $(this).attr("id");
						$('#beautycityVenueId').val(beautycityVenueId);
					})
				}
			},"json");
		}
		
		//场馆照片
		function loadVenueImg(index, pagesize){
			var data = {
                	userId: userId,
                	beautycityVenueId: beautycityVenueId,
                	resultFirst: index,
                	resultSize: pagesize
                };
			$.post("${path}/wechatStatic/getBeautycityImgList.do",data, function (data) {
				if (data.status == 1) {
					if(data.data.list.length<20){
               			$("#loadingVenueImgDiv").html("");
   	        		}
					$.each(data.data.list, function (i, dom) {
						var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
						var beautycityImgUrl = dom.beautycityImgUrl+"@200w";
						var beautycityImgUrlPreview = dom.beautycityImgUrl+"@700w";
						var ImgObj = new Image();
						ImgObj.src = beautycityImgUrl;
						ImgObj.onload = function(){
    						if(ImgObj.width/ImgObj.height>310/285){
    							$("img[imgId="+dom.beautycityImgId+"]").css("height","285px");
    						}else{
    							$("img[imgId="+dom.beautycityImgId+"]").css("width","310px");
    						}
						}
						var voteImg = "";
						var voteOnlick = "";
						if(dom.beautycityImgIsVote==0){
            				voteImg = "${path}/STATIC/wxStatic/image/beautyCity/brvOff.png";
            				voteOnlick = "onclick='userVote(\""+dom.beautycityImgId+"\",$(this))'";
            			}else{
            				voteImg = "${path}/STATIC/wxStatic/image/beautyCity/brvOn.png";
            			}
						$("#venueImgUl").append("<li>" +
														"<div class='spaceTitle'>" +
														"<div class='spaceTitleImg'>"+userHeadImgHtml+"</div>" +
														"<div class='spaceTitleName'>" +
															"<p class='sName1'>"+dom.userName+"</p>" +
															"<p class='sName2'><img src='${path}/STATIC/wxStatic/image/beautyCity/bcplace.png'/><span>"+dom.venueName+"</span></p>" +
														"</div>" +
														"<div style='clear: both;'></div>" +
													"</div>" +
													"<div class='spaceImg' onclick='showPreview(\""+beautycityImgUrlPreview+"\");'><img imgId='"+dom.beautycityImgId+"' src='"+beautycityImgUrl+"' /></div>" +
													"<div class='spaceMenu'>" +
														"<div class='bcVoted' onclick='toShare(\""+dom.beautycityImgId+"\")'>去拉票</div>" +
														"<div class='bcVotedNum'><img src='"+voteImg+"' "+voteOnlick+"/><span>"+dom.voteCount+"</span></div>" +
														"<div style='clear: both;'></div>" +
													"</div>" +
												"</li>");
					});
				}
			},"json");
		}
		
		//排名
		function loadRanking(){
			$.post("${path}/wechatStatic/getBeautycityImgRankingList.do",{userId: userId}, function (data) {
				if (data.status == 1) {
					$.each(data.data, function (i, dom) {
						var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
						var beautycityImgUrl = dom.beautycityImgUrl+"@200w";
						var beautycityImgUrlPreview = dom.beautycityImgUrl+"@700w";
						var ImgObj = new Image();
						ImgObj.src = beautycityImgUrl;
						ImgObj.onload = function(){
    						if(ImgObj.width/ImgObj.height>130/130){
    							$("img[rankingImgId="+dom.beautycityImgId+"]").css("height","130px");
    						}else{
    							$("img[rankingImgId="+dom.beautycityImgId+"]").css("width","130px");
    						}
						}
						var voteImg = "";
						var voteOnlick = "";
						if(dom.beautycityImgIsVote==0){
            				voteImg = "${path}/STATIC/wxStatic/image/beautyCity/brvOff.png";
            				voteOnlick = "onclick='userVote(\""+dom.beautycityImgId+"\",$(this))'";
            			}else{
            				voteImg = "${path}/STATIC/wxStatic/image/beautyCity/brvOn.png";
            			}
						$("#userRanking").append("<li>" +
													"<div class='bcRanking'>" +
														"<div class='bcRankList'><div class='bcRankNum'>"+(i+1)+"</div></div>" +
														"<div class='bcRankImg' onclick='showPreview(\""+beautycityImgUrlPreview+"\");'>" +
															"<img rankingImgId='"+dom.beautycityImgId+"' src='"+beautycityImgUrl+"' />" +
														"</div>" +
														"<div class='bcRankName'>" +
															"<p class='bcRankNameTitle'>"+userHeadImgHtml+dom.userName+"</p>" +
															"<p class='bcRankNamePlace'><img src='${path}/STATIC/wxStatic/image/beautyCity/bcplace.png' />"+dom.venueName+"</p>" +
														"</div>" +
														"<div class='bcRankBrv'>" +
															"<img src='"+voteImg+"' "+voteOnlick+" />" +
															"<span>"+dom.voteCount+"</span>" +
														"</div>" +
														"<div style='clear: both;'></div>" +
													"</div>" +
												"</li>");
					});
				}
			},"json");
		}
		
		//参与按钮
		function joinBut(){
			if (userId == null || userId == '') {
        		//判断登陆
            	publicLogin("${basePath}wechatStatic/beautyCity.do");
        	}else{
        		$(".bcHome,.bcHomeMe,.join").hide();
        		if(needWirteInfo == 1){
        			$(".bcTakePhoto").show();
        		}else{
        			$(".joinAct").show();
        		}
        	}
		}
		
		//分享按钮
		function toShare(beautycityImgId){
			if (userId == null || userId == '') {
        		//判断登陆
            	publicLogin("${basePath}wechatStatic/beautyCity.do");
        	}else{
        		location.href = '${path}/wechatStatic/beautyCityShare.do?beautycityImgId='+beautycityImgId;
        	}
		}
		
		//下一步
		function nextBtn(){
			if(isEnd == 1){
				dialogAlert('系统提示', '活动已结束！');
			}else{
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatStatic/beautyCity.do");
	        	}else{
	        		$("#nextBtn").attr("onclick","");
	        		var userName = $("#userName").val();
	        		var userMobile = $("#userMobile").val();
	        		if(userName.trim()==""){
	    	        	$("#nextBtn").attr("onclick","nextBtn();");
	    	        	dialogAlert('系统提示', '姓名为必填项！');
	    	            return;
	    	        }
	        		var telReg = (/^1[34578]\d{9}$/);
	    	        if(userMobile.trim()==""){
	    	        	$("#nextBtn").attr("onclick","nextBtn();");
	    	        	dialogAlert('系统提示', '手机号为必填项！');
	    	            return;
	    	        }else if(!userMobile.match(telReg)) {
	    	        	$("#nextBtn").attr("onclick","nextBtn();");
	    	            dialogAlert('系统提示', '请正确填写手机号码！');
	    	            return;
	    	        }
	        		$.post("${path}/wechatStatic/saveBeautycity.do",{userId: userId,userName:userName,userMobile:userMobile}, function (data) {
	    				if (data.status == 1) {
	    					$('.joinAct').hide();
	    	        		$('.bcTakePhoto').show();
	    				}else{
	    					$("#nextBtn").attr("onclick","nextBtn();");
	                    	dialogAlert('系统提示', '提交失败！');
	                    }
	        		},"json");	
	        	}
			}
		}
		
		//提交
		function imgSubmit(){
			if(isEnd == 1){
				dialogAlert('系统提示', '活动已结束！');
			}else{
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatStatic/beautyCity.do");
	        	}else{
	        		$("#imgSubmit").attr("onclick","");
	        		var beautycityImgUrl = $("#beautycityImgUrl").val();
	        		var beautycityVenueId = $("#beautycityVenueId").val();
	        		if(beautycityImgUrl.trim()==""){
	    	        	$("#imgSubmit").attr("onclick","imgSubmit();");
	    	        	dialogAlert('系统提示', '请上传图片！');
	    	            return;
	    	        }
	        		if(beautycityVenueId.trim()==""){
	    	        	$("#imgSubmit").attr("onclick","imgSubmit();");
	    	        	dialogAlert('系统提示', '请选择空间！');
	    	            return;
	    	        }
	        		$.post("${path}/wechatStatic/saveBeautycityImg.do",{userId: userId,beautycityImgUrl:beautycityImgUrl,beautycityVenueId:beautycityVenueId}, function (data) {
	    				if (data.status == 1) {
	    					dialogAlert('系统提示', '提交成功！');
	    					setTimeout(function(){
	    						location.href='${path}/wechatStatic/beautyCity.do'
	    					},1600);
	    				}else{
	    					$("#nextBtn").attr("onclick","nextBtn();");
	                    	dialogAlert('系统提示', '提交失败！');
	                    }
	        		},"json");	
	        	}
			}
		}
		
		//预览大图
		function showPreview(url){
			$(".imgPreview img").attr("src",url);
			$(".imgPreview").fadeIn("fast");
		}
		
		//查看积分
		function showIntegral(){
        	location.href = '${path}/wechatUser/userIntegral.do';
		}
		
		//滑屏分页
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 40)) {
           		startIndex += 20;
           		var index = startIndex;
           		setTimeout(function () { 
           			if(tagNum==0){
               			loadNewest(index, 20);
           			}else if(tagNum==1){
           				loadVenueImg(index, 20);
           			}
           		},800);
            }
        });
	</script>
	
	<style>
		html,body {
			height: 100%;
			width: 100%;
		}
		.beautyCityMain {
			width: 750px;
			margin: auto;
		}
		.bcUpPhoto>div:nth-last-child(2){
			width: 700px;
			height: 600px;
			overflow: hidden;
			background-color:#7c7c7c;
		}
		.bcUpPhoto>div input,.bcUpPhoto>div label{
			display: none;
		}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/beautyCity/beautycityShare.jpg"/></div>
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
	<div class="beautyCityMain">
		<div class="bcTop">
			<img src="${path}/STATIC/wxStatic/image/beautyCity/banner.jpg" />
			<div class="bcKeep">
				<img src="${path}/STATIC/wxStatic/image/beautyCity/keep.png" />
			</div>
			<div class="bcShare">
				<img src="${path}/STATIC/wxStatic/image/beautyCity/share.png" />
			</div>
		</div>
		<div class="bcMenu">
			<div class="bcMenuList">
				<ul>
					<li onclick="location.href='${path}/wechatStatic/beautyCity.do'">首页</li>
					<li onclick="location.href='${path}/wechatStatic/beautyCity.do?tagNum=1'">空间之美</li>
					<li onclick="location.href='${path}/wechatStatic/beautyCity.do?tagNum=2'">活动规则</li>
					<li onclick="location.href='${path}/wechatStatic/beautyCity.do?tagNum=3'">排行榜</li>
					<div style="clear: both;"></div>
				</ul>
			</div>
		</div>
		<!--点击放大图片-->
		<div class="imgPreview" style="display: none;">
			<img src="" />
		</div>
		<div class="bcContentList">
			<ul>
				<li style="background-color: #eeeeee;overflow: hidden;min-height: 870px;display: none;">
					<div class="bcHome">
						<div class="bcHomeTop">
							<img src="${path}/STATIC/wxStatic/image/beautyCity/bcHomeTop.jpg" />
						</div>
						<div id="userInfo1" class="bcMyPrizes" style="display: none;"></div>
						<div class="bcHomeList">
							<p class="listTitle">精选</p>
							<ul id="selectedImgUl" style="overflow: hidden;"></ul>
						</div>
						<div class="bcHomeList">
							<p class="listTitle">最新</p>
							<ul id="newestImgUl" style="overflow: hidden;"></ul>
							<div id="loadingNewestDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
						</div>
					</div>
					<div class="bcHomeMe" style="display: none;margin-top: 10px;">
						<div id="userInfo2" class="bcMyPrizes"></div>
						<div class="bcHomeList">
							<ul id="userImgUl" style="overflow: hidden;"></ul>
						</div>
					</div>
					<div id="joinBut" class="join" onclick="joinBut();" style="display: none;">
						<img src="${path}/STATIC/wxStatic/image/beautyCity/join.png" />
					</div>
					<div class="bcMyPnamePop">
						<img src="${path}/STATIC/wxStatic/image/beautyCity/mypnamepop.png" width="100%" height="100%" />
						<div class="PopTips">
							<p style="float: left;">积分会直接打入你的文化云账户</p>
							<div onclick="showIntegral();" class="bcMyPnamePopBtn" style="display: inline;float: right;">点击查看</div>
							<div style="clear: both;"></div>
							<p style="margin-top: 5px;">关注文化云公众号 以免错过礼品兑换详情</p>
						</div>
					</div>
					<!--我要参赛-->
					<div class="joinAct">
						<p style="text-align: center;font-size: 32px;">#&nbsp;我要参赛&nbsp;#</p>
						<p style="text-align: center;font-size: 24px;margin-top: 20px;">请先填写资料</p>
						<div class="userInfoInput">
							<div class="bcUserName">
								<span class="inputTitle">姓名</span><input id="userName" type="text" class="inputText" maxlength="20"/>
							</div>
							<div class="bcUserPhone">
								<span class="inputTitle">手机</span><input id="userMobile" type="text" class="inputText" maxlength="11"/>
							</div>
							<p style="width: 500px;margin: auto;font-size: 24px;margin-top: 20px;">请正确填写个人信息，如您获得奖项，您提交的信息将作为领奖依据，一经提交不可修改</p>
							<div id="nextBtn" class="nextBtn" onclick="nextBtn();">下一步</div>
						</div>
					</div>
					<!--上传相片-->
					<div class="bcTakePhoto">
						<div class="bcUpPhotoDiv">
							<div class="bcUpPhoto">
								<img id="upPhoto" src="${path}/STATIC/wxStatic/image/beautyCity/upPhoto.png" style="max-height: 600px;max-width: 700px;display: block;margin: auto;position: absolute;left:0;top:0;right:0;bottom:0; "/>
							</div>
						</div>
						<!--选择空间-->
						<div class="chooseSpace" onclick="loadVenue(0,100);$('.chooseSpaceList').show();">+&nbsp;请选择一个对应的空间</div>
						<!--已选空间-->
						<div class="chooseSpaceOn" style="display: none;">
							<img class="chooseImg" src="${path}/STATIC/wxStatic/image/beautyCity/banner.jpg" />
							<p class="chooseTitle"></p>
							<p onclick="$('.chooseSpaceList').show();" style="float: right;margin-right: 20px;font-size: 24px;color: #262626;line-height: 100px;">更换空间&nbsp;></p>
							<div style="clear: both;"></div>
						</div>
						<input type="hidden" id="beautycityVenueId"/>
						<input type="hidden" id="beautycityImgUrl"/>
						<div id="imgSubmit" class="bcSubmit" onclick="imgSubmit();">提&nbsp;交</div>

						<!--空间选择-->
						<div class="chooseSpaceList" style="display: none;">
							<div class="spaceListDiv">
								<p style="padding-left: 20px;border-left: 5px solid #fff;font-size: 32px;color: #fff;">请选择一个空间</p>
								<ul id="venueChooseUl" class="chooseList"></ul>
							</div>
						</div>
					</div>
				</li>
				<li style="background-color: #eeeeee;overflow: hidden;display: none;">
					<div class="beautySpace">
						<!--空间列表-->
						<ul id="venueListUl" class="beautySpaceList" style="overflow: hidden;"></ul>
						<!--空间详情-->
						<div class="beautySpaceInfo" style="display: none;">
							<p class="beautySpaceTitle"></p>
							<ul id="venueImgUl" style="overflow: hidden;"></ul>
							<div id="loadingVenueImgDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
						</div>
					</div>
				</li>
				<li style="display: none;background-color: #eeeeee;overflow: hidden;">
					<div class="ruleImg">
						<p style="text-align: center;">“城市空间•最美印象”市民微摄影征集活动</p><br />
						<p>活动说明</p><br />
						<p>爱上海 发现城市之美！</p><br />
						<p>用手机镜头，拍下最美空间的最美印记。</p><br />
						<p>用微语微图，表达城市空间的最美印象。</p><br />
						<p>活动时间</p><br />
						<p style="padding-left: 20px;">1、 参与时间：2016年9月19日-2016年10月19日（10月19日24点关闭线上参赛通道）</p><br />
						<p style="padding-left: 20px;">2、 投票时间：2016年9月19日-2016年10月19日（10月19日24点关闭线上投票通道）</p><br />
						<p style="padding-left: 20px;">3、 公示时间：2016年10月20日通过“文化云”官方微信平台公示获奖名单。</p><br />
						<p>参与方式</p><br />
						<p style="padding-left: 20px;">1、 在云活动页面所示的“100个最美城市空间”随手拍出照片</p><br />
						<p style="padding-left: 20px;">2、 将照片上传至云活动页面，关联空间地点，提交时留下正确的个人信息。</p><br />
						<p style="padding-left: 40px;">&bull;您需要根据活动页面提示，注册成为安康文化云用户，方可参与活动。</p><br />
						<p style="padding-left: 40px;">&bull;您可以发布多张照片，但不可重复，经判定如有同一角度同一场景的高相似度照片，主办方有权删除其中相似的照片。</p><br />
						<p style="padding-left: 40px;">&bull;发布照片须为个人原创，体现空间之美，不得违反国家法律法规，一旦上传将默认授权主办单位刊发出版（非营利）照片的相关著作权限。</p><br />
						<p style="padding-left: 20px;">3、根据活动页面提示转发您的参赛作品至朋友圈，请亲朋好友为您的作品点赞，根据单张照片票数排名即有机会获得奖励。</p><br />
						<p style="padding-left: 40px;">&bull;参赛选手可将本活动分享转发至朋友圈，邀请用户投票</p><br />
						<p style="padding-left: 40px;">&bull;用户可通过本活动页面直接为喜欢的参赛选手投票，每人（以唯一用户判断）每天只可以投一次票，但可以为多名用户投票。</p><br />
						<p>【奖项设置】</p><br />
						<p style="padding-left: 20px;">1、最美印象奖：</p><br />
						<p>活动结束后，按照作品的最终投票排名，选出投票最多前30幅作品，其作者可以获得奖品：</p><br />
						<p style="padding-left: 40px;">&bull;第1名，获得价值686元的诸子百家文创旅游套装+双百图书+最美地图；</p><br />
						<p style="padding-left: 40px;">&bull;第2-4名，获得价值480元的丝巾+双百图书+最美地图；</p><br />
						<p style="padding-left: 40px;">&bull;第5-10名，获得价值100元手机充值卡+双百图书+最美地图；</p><br />
						<p style="padding-left: 40px;">&bull;第11-30名，获得双百图书+最美地图。</p><br />
						<p>*双百图书全称为：</p><br />
						<p>“ 市民眼中100个上海最美城市空间”+“100个上海城市空间塑造案例”</p><br />
						<p style="padding-left: 20px;">2、 最多发现奖：</p><br />
						<p>您可以上传多个空间照片，在活动期间，提交作品涉及规定数量不同空间的，可根据涉及空间的多少，获得不同级别的奖励。</p><br />
						<p style="padding-left: 40px;">&bull;集满10个不同空间的照片，即可获得500文化云积分</p><br />
						<p style="padding-left: 40px;">&bull;集满50个不同空间的照片，即可获得1000文化云积分</p><br />
						<p style="padding-left: 40px;">&bull;集满100个不同空间的照片，即可获得价值168元的京东读书卡（限前100名）</p><br />
						<p>特别注意：</p><br />
						<p style="padding-left: 40px;">&bull;参赛选手通过本页面一经提交成功参赛资料，即视为接受所有参赛条款，并承诺对参赛作品原创性负责，如有作假或冒用，即取消参赛资格及所获奖励。</p><br />
						<p style="padding-left: 40px;">&bull;活动组委会有权对同一用户提交的同一角度同一场景的高相似度照片作删除合并处理。</p><br />
						<p style="padding-left: 40px;">&bull;本活动投票及评选公正公开，禁止任何手段的刷票或作弊行为，一经发现，取消参赛资格及所获奖励。</p><br />
						<p style="padding-left: 40px;">&bull;本活动的最终解释权归“文化云”所有。</p><br />
					</div>
				</li>
				<li style="display: none;">
					<div id="myRanking" class="bcRanking bcRankMe" style="display: none;"></div>
					<ul id="userRanking" class="bcRankOther"></ul>
				</li>
			</ul>
		</div>
	</div>
</body>
</html>