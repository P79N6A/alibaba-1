<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>市民文化节·我们的行走故事摄影大赛</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<%@include file="/WEB-INF/why/common/aliImageFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	
	<script>
		var noControl = '${noControl}';	//1：不可操作
		var noVote = '${noVote}';	//1：不可投票
		var startIndex = 0;		//页数
	
		if (userId == null || userId == '') {
    		//判断登陆
        	publicLogin("${basePath}wechatStatic/walkIndex.do");
    	}
		
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '市民文化节·“我们的行走故事”摄影作品正在征集';
	    	appShareDesc = '用一个镜头，一张照片，一段文字，讲述旅途中扣人心弦的人、景和事';
	    	appShareImgUrl = 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg';
	    	appShareLink = '${basePath}wechatStatic/walkIndex.do';
	    	
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
					title: "市民文化节·“我们的行走故事”摄影作品正在征集",
					desc: '用一个镜头，一张照片，一段文字，讲述旅途中扣人心弦的人、景和事',
					link: '${basePath}wechatStatic/walkIndex.do',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg'
				});
				wx.onMenuShareTimeline({
					title: "市民文化节·“我们的行走故事”摄影作品正在征集",
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg',
					link: '${basePath}wechatStatic/walkIndex.do'
				});
				wx.onMenuShareQQ({
					title: "市民文化节·“我们的行走故事”摄影作品正在征集",
					desc: '用一个镜头，一张照片，一段文字，讲述旅途中扣人心弦的人、景和事',
					link: '${basePath}/wechatStatic/walkIndex.do',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg'
				});
				wx.onMenuShareWeibo({
					title: "市民文化节·“我们的行走故事”摄影作品正在征集",
					desc: '用一个镜头，一张照片，一段文字，讲述旅途中扣人心弦的人、景和事',
					link: '${basePath}/wechatStatic/walkIndex.do',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg'
				});
				wx.onMenuShareQZone({
					title: "市民文化节·“我们的行走故事”摄影作品正在征集",
					desc: '用一个镜头，一张照片，一段文字，讲述旅途中扣人心弦的人、景和事',
					link: '${basePath}/wechatStatic/walkIndex.do',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg'
				});
			});
		}
		
		$(function () {
			if(sessionStorage.getItem("showCover") == 1) {
		        $(".room_yindy").hide();
		    } else {
		        // 引导页上滑
		        $('html,body').css('overflow','hidden');
		        $(".room_yindy").bind('click',function() {
		            $(this).animate({
		                top: "50px",
		            }, 500).animate({
		                top: "-3000px",
		            }, 300, function () {
		                $(this).hide();
		                $('html,body').css('overflow','visible');
		            })
		            sessionStorage.setItem("showCover",1);
		        });
		        $(".room_yindy").bind('touchstart',function() {
		            $(this).animate({
		                top: "50px",
		            }, 500).animate({
		                top: "-3000px",
		            }, 300, function () {
		                $(this).hide();
		                $('html,body').css('overflow','visible');
		            });
		            sessionStorage.setItem("showCover",1);
		            return false;
		        });
		    }
			$(".room_yindy .ssgz").bind('click', function (evt) {
		        var e = evt || window.event;
		        e.stopPropagation();
		    });
		    $(".room_yindy .ssgz").bind('touchstart', function (evt) {
		        var e = evt || window.event;
		        e.stopPropagation();
		    });
		    
		    aliUploadImg('walkImgWebupload', getWalkUrls, 9, true, 'H5');
			
		    //swiper初始化div
		    initSwiper();
		    
			loadMyImg();
			loadWalkImg(0,20);
			
			navFixed($(".kjmbNav"),'touchmove',240);
		    navFixed($(".kjmbNav"),'scroll',240);
		    
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
		
		//上传回调
        function getWalkUrls(up, file, info) {
        	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
        	$("#"+file.id).append("<input type='hidden' value='"+filePath+"'/>");
        	//自动居中
	    	$("#"+file.id).find('img:eq(0)').picFullCentered({'boxWidth' : 160,'boxHeight' : 160});
		}
		
		//查询自己上传照片
		function loadMyImg(){
			var data = {
            	userId: userId,
            	isMe: 1
            };
			$.post("${path}/wechatStatic/queryWalkImgList.do",data, function (data) {
				if(data.length>0){
					var imgCount = 0;	//照片张数
					$.each(data, function (i, dom) {
						var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
						var walkImgHtml = getWalkImgHtml(dom.walkImgId,dom.walkImgUrl,"my");
						$.each(dom.walkImgUrl.split(";"), function (j, dom2) {
							imgCount++;
						});
						var voteClass = "";
						if(dom.isVote == 1){
							voteClass = "current";
						}
						var walkImgContentHtml = dom.walkImgContent.substring(0,80);
						if(walkImgContentHtml.length>80){
							walkImgContentHtml += "...<span style='color:#396ac3;' onclick='location.href=\"${path}/wechatStatic/walkDetail.do?walkImgId="+dom.walkImgId+"\"'>全文</span>";
						}
						$("#myImgUl").append("<li>" +
									            "<div class='sphead clearfix'>" +
								                    "<div class='toux'>"+userHeadImgHtml+"</div>" +
								                    "<div class='char'>" +
								                    	"<div class='na' style='margin-top: 2px;'>"+dom.userName+"</div>" +
								                    	"<div class='add'>"+dom.walkImgTime+"摄于"+dom.walkImgSite+"</div>" +
								                    "</div>" +
								                "</div>" +
								                walkImgHtml +
								                "<div class='miaoBiao'>"+dom.walkImgName+"</div>" +
								                "<div class='miaoxie'>"+walkImgContentHtml+"</div>" +
								                "<div class='operate clearfix'>" +
								                    "<div class='qulp' onclick='location.href=\"${path}/wechatStatic/walkDetail.do?walkImgId="+dom.walkImgId+"\"'>去拉票</div>" +
								                    "<div class='dian "+voteClass+"' onclick='walkVote(\""+dom.walkImgId+"\",this);'>"+dom.voteCount+"</div>" +
								                "</div>" +
								            "</li>");
					});
					
					$("#userInfo1").show();
					var user = data[0];
					var userHeadImgHtml = getUserHeadImgHtml(user.userHeadImgUrl);
					$("#userInfo1").html("<div class='jz700 clearfix'>" +
							                "<div class='pic'>"+userHeadImgHtml+"</div>" +
							                "<div class='char'>" +
							                    "<p style='margin-top: 12px;'>"+user.userName+"<span onclick='toUserCenter();'>个人中心</span></p>" +
							                    "<p>我已发布了"+imgCount+"张照片</p>" +
							                "</div>" +
							                "<div class='icon' onclick='toMyWalkImg()'></div>" +
							             "</div>");
					$("#userInfo2").html("<div class='jz700 clearfix'>" +
							                "<div class='pic'>"+userHeadImgHtml+"</div>" +
							                "<div class='char'>" +
							                    "<p style='margin-top: 12px;'>"+user.userName+"<span onclick='toUserCenter();'>个人中心</span></p>" +
							                    "<p>我已发布了"+imgCount+"张照片</p>" +
							                "</div>" +
							             "</div>");
				}
			},"json");
		}
		
		//最新照片
		function loadWalkImg(index, pagesize){
			var data = {
            	userId: userId,
            	walkStatus: 1,
            	firstResult: index,
               	rows: pagesize
            };
			$.post("${path}/wechatStatic/queryWalkImgList.do",data, function (data) {
				if(data.length<20){
        			$("#loadingWalkImgDiv").html("");
	        	}
				if(data.length>0){
					$.each(data, function (i, dom) {
						var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
						var walkImgHtml = getWalkImgHtml(dom.walkImgId,dom.walkImgUrl,"img");
						var voteClass = "";
						if(dom.isVote == 1){
							voteClass = "current";
						}
						var walkImgContentHtml = dom.walkImgContent.substring(0,81);
						if(walkImgContentHtml.length>80){
							walkImgContentHtml += "...<span style='color:#396ac3;' onclick='location.href=\"${path}/wechatStatic/walkDetail.do?walkImgId="+dom.walkImgId+"\"'>全文</span>";
						}
						$("#walkImgUl").append("<li>" +
											        "<div class='sphead clearfix'>" +
									                    "<div class='toux'>"+userHeadImgHtml+"</div>" +
									                    "<div class='char'>" +
									                    	"<div class='na' style='margin-top: 2px;'>"+dom.userName+"</div>" +
									                    	"<div class='add'>"+dom.walkImgTime+"摄于"+dom.walkImgSite+"</div>" +
									                    "</div>" +
									                "</div>" +
									                walkImgHtml +
									                "<div class='miaoBiao'>"+dom.walkImgName+"</div>" +
									                "<div class='miaoxie'>"+walkImgContentHtml+"</div>" +
									                "<div class='operate clearfix'>" +
									                    "<div class='qulp' onclick='location.href=\"${path}/wechatStatic/walkDetail.do?walkImgId="+dom.walkImgId+"\"'>去拉票</div>" +
									                    "<div class='dian "+voteClass+"' onclick='walkVote(\""+dom.walkImgId+"\",this);'>"+dom.voteCount+"</div>" +
									                "</div>" +
									            "</li>");
					});
				}
			},"json");
		}
		
		//投票
		function walkVote(walkImgId,$this){
			if(noVote != 1){
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatStatic/walkIndex.do");
	        	}else{
	        		$.post("${path}/wechatStatic/addWalkVote.do",{userId:userId,walkImgId:walkImgId}, function (data) {
	    				if(data == "200"){
	    					$($this).addClass('current');
	   						var count = $($this).text();
	   						$($this).text(eval(count) + 1);
	    				}else if(data == "repeat"){
	    					dialogAlert('系统提示', '一天只能投一票！');
	    				}else if(data == "noPass"){
	    					dialogAlert('系统提示', '该作品还未通过审核！');
	    				}else if(data == "500"){
	    					dialogAlert('系统提示', '投票失败！');
	    				}
	    			},"json");
	        	}
			}else{
				dialogAlert('系统提示', '投票已结束！');
			}
		}
		
		//跳转到我的图片
		function toMyWalkImg(){
			$('.syxyhide').hide();
			$('.sygerzx').show();
            
			$(".kjmbNav").css('position', 'static');
		}
		
		//即刻参与
		function toUpload(){
			if(noControl != 1){
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatStatic/walkIndex.do");
	        	}else{
	        		$.post("${path}/wechatStatic/queryWalkUser.do", {userId: userId}, function (data) {
	        			if(data.ccpWalkUser==null){
	        				$.post("${path}/wechatUser/queryTerminalUserByUserId.do", {userId: userId}, function (data) {
	       						$("#userName").val(data.userNickName);
	               				$("#userMobile").val(data.userTelephone);
	               				// 首页
	               		        $('.syxyhide').hide();
	               		        // 留资页
	               		        $('.syliuzy').show();
	        				}, "json");
	        			}else{
	        				// 首页
	        		        $('.syxyhide').hide();
	        		     	// 上传照片
	        		        $('.lccscphoto').show();
	        		     	
	        		        $("#userUploadImg").val("");
	        		        $("#walkImgName").val("");
	        		        $("#walkImgContent").val("");
	        		        $("#walkImgTime").val("");
	        		        $("#walkImgSite").val("");
	        		        $("#upPhoto").attr("src","${path}/STATIC/wxStatic/image/roomage/pic10.jpg");
	        			}
	        		}, "json");
	        	}
			}else{
				dialogAlert('系统提示', '活动已截止！');
			}
		}
		
		//保存用户
		function userInfo(){
			if (userId == null || userId == '') {
				//判断登陆
				publicLogin("${basePath}wechatStatic/walkIndex.do");
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
				$.post("${path}/wechatStatic/addWalkUser.do", data, function(data) {
					if (data == "200") {
						// 留资页
				        $('.syliuzy').hide();
				        // 上传照片
				        $('.lccscphoto').show();
					}else {
						dialogAlert('系统提示', "提交失败")
					}
				},"json");
			}
		}
		
		//保存用户上传图片
		function userUploadImg(){
			$("#uploadBtn").attr("onclick","");
			if (userId == null || userId == '') {
				//判断登陆
				publicLogin("${basePath}wechatStatic/walkIndex.do");
			}else{
				var walkImgName = $("#walkImgName").val();
				if(!walkImgName){
			    	dialogAlert('系统提示', '请输入作品名称！');
			    	$("#uploadBtn").attr("onclick","userUploadImg();");
			        return false;
			    }
				var walkImgContent = $("#walkImgContent").val();
				if(!walkImgContent){
			    	dialogAlert('系统提示', '请输入照片故事！');
			    	$("#uploadBtn").attr("onclick","userUploadImg();");
			        return false;
			    }else{
			    	if(walkImgContent.length<20){
			    		dialogAlert('系统提示', '照片故事至少200字！');
				    	$("#uploadBtn").attr("onclick","userUploadImg();");
				        return false;
			    	}
			    }
				var walkImgTime = $("#walkImgTime").val();
				if(!walkImgTime){
			    	dialogAlert('系统提示', '请输入拍摄时间！');
			    	$("#uploadBtn").attr("onclick","userUploadImg();");
			        return false;
			    }else{
			    	if(!(/^\d{4}(\.)\d{1,2}\1\d{1,2}$/.test(walkImgTime))){
			    		dialogAlert('系统提示', '拍摄时间格式不对，例：2017.03.15！');
				    	$("#uploadBtn").attr("onclick","userUploadImg();");
				        return false;
			    	}else{
			    		if(walkImgTime.substring(0,4)>=2018){
			    			dialogAlert('系统提示', '拍摄时间不得超过2017年！');
					    	$("#uploadBtn").attr("onclick","userUploadImg();");
					        return false;
			    		}
			    	}
			    }
				var walkImgSite = $("#walkImgSite").val();
				if(!walkImgSite){
			    	dialogAlert('系统提示', '请输入拍摄地点！');
			    	$("#uploadBtn").attr("onclick","userUploadImg();");
			        return false;
			    }
				var walkImgUrl = '';
				var flag = 0;
	    		$("#ossfile2 div[name=aliFile]").each(function(index, element) {
	    			if(!$(element).find("input")){
				    	flag = 1;
	    			}else{
	    				walkImgUrl += $(element).find("input").val() + ";";
	    			}
	    		});
	    		if(flag == 1){
	    			dialogAlert('系统提示', '图片还在上传中，请稍后~');
			    	$("#uploadBtn").attr("onclick","userUploadImg();");
			    	return false;
	    		}
	    		if(walkImgUrl.length>0){
	    			walkImgUrl = walkImgUrl.substring(0, walkImgUrl.length-1);
	    		}else{
	    			dialogAlert('系统提示', '请上传图片！');
	    			$("#uploadBtn").attr("onclick","userUploadImg();");
	    			return false;
	    		}
				var data = {
					walkImgUrl:walkImgUrl,
					userId:userId,
					walkImgName:walkImgName,
					walkImgContent:walkImgContent,
					walkImgTime:walkImgTime,
					walkImgSite:walkImgSite
				}
				$.post("${path}/wechatStatic/addWalkImg.do",data, function (data) {
					if (data == "100") {
	    				dialogConfirm('系统提示', "恭喜获得600文化云积分！我们已收到您的参赛作品！会在72小时内审核，通过后即可成功参赛，请您关注本页面。",function(){
	    					location.href = '${path}/wechatStatic/walkIndex.do'
	    				});
	    			}else if (data == "200") {
	    				dialogConfirm('系统提示', "我们已收到您的参赛作品！会在72小时内审核，通过后即可成功参赛，请您关注本页面。",function(){
	    					location.href = '${path}/wechatStatic/walkIndex.do'
	    				});
	    			}else{
	    				dialogAlert('系统提示', "提交失败！");
	    				$("#uploadBtn").attr("onclick","userUploadImg();");
	    			}
	    		},"json");
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
            	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png'/>";
            } else if (userHeadImgUrl.indexOf("/front/") != -1) {
                var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
                userHeadImgHtml = "<img src='" + imgUrl + "' onerror='imgNoFind();'/>";
            } else {
            	userHeadImgHtml = "<img src='" + userHeadImgUrl + "' onerror='imgNoFind();'/>";
            }
			return userHeadImgHtml;
		}
		
		//列表图片
		function getWalkImgHtml(walkImgId,walkImgUrl,attrName){
			var walkImgUrls = walkImgUrl.split(";");
			var walkImgType = 1;	//1张图
			if(walkImgUrls.length > 1 && walkImgUrls.length <= 3){	//2、3张图
				walkImgType = 2;
			}else if(walkImgUrls.length > 3){	//大于3张图
				walkImgType = 3;
			}
			var walkImgHtml = "<div class='pictrue clearfix pictrue_"+walkImgType+"'>";
			$.each(walkImgUrls, function (i, dom) {
				var walkImgWidth;
				var walkImgHeigth;
				if(walkImgType == 2){
					walkImgWidth = 207;
					walkImgHeigth = 166;
				}else if(walkImgType == 3){
					if(i == 0){
						walkImgWidth = 420;
						walkImgHeigth = 340;
					}else{
						walkImgWidth = 215;
						walkImgHeigth = 166;
					}
				}
				var ImgObj = new Image();
				ImgObj.src = dom+"@700w";
				ImgObj.onload = function(){
					if(walkImgType == 1 && (ImgObj.width/ImgObj.height)<1.6 && (ImgObj.width/ImgObj.height)>0.4){	//不作处理
						if(ImgObj.width/ImgObj.height<1){
							$("img[walkImgId="+attrName+walkImgId+i+"]").css("height","646px");
						}else{
							$("img[walkImgId="+attrName+walkImgId+i+"]").css("width","646px");
						}
					}else{
						if(walkImgType == 1){	//1张图时按宽高比做不同处理
							if(ImgObj.width/ImgObj.height<1){
								walkImgWidth = 538;
								walkImgHeigth = 646;
							}else{
								walkImgWidth = 646;
								walkImgHeigth = 340;
							}
							$("img[walkImgId="+attrName+walkImgId+i+"]").parent(".item").css({"height":walkImgHeigth+"px","width":walkImgWidth+"px"});
						}
						if(ImgObj.width/ImgObj.height>walkImgWidth/walkImgHeigth){
							var pLeft = (ImgObj.width*(walkImgHeigth/ImgObj.height)-walkImgWidth)/2;
							$("img[walkImgId="+attrName+walkImgId+i+"]").css({"height":walkImgHeigth+"px","position":"absolute","left":"-"+pLeft+"px"});
						}else{
							var pTop = (ImgObj.height*(walkImgWidth/ImgObj.width)-walkImgHeigth)/2;
							$("img[walkImgId="+attrName+walkImgId+i+"]").css({"width":walkImgWidth+"px","position":"absolute","top":"-"+pTop+"px"});
						}
					}
				}
				if(walkImgType == 3 && i > 1){
					walkImgHtml += "<div class='item' onclick='previewImg(\""+dom+"\",\""+walkImgUrl+"\")'><img walkImgId='"+attrName+walkImgId+i+"' src='"+dom+"@700w'><div class='outstrip'>+"+eval(walkImgUrls.length-2)+"</div></div>";
					return false;
				}else{
					walkImgHtml += "<div class='item' onclick='previewImg(\""+dom+"\",\""+walkImgUrl+"\")'><img walkImgId='"+attrName+walkImgId+i+"' src='"+dom+"@700w'></div>";
				}
			});
			walkImgHtml += "</div>"
			return walkImgHtml;
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
		
	  	//滑屏分页
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 20)) {
           		setTimeout(function () { 
      				startIndex += 20;
              		var index = startIndex;
              		loadWalkImg(index,20);
           		},500);
            }
        });
	</script>
	
	<style>
		html,body {height: 100%;}
		.roomage {min-height: 100%;}
		.kjmbNav li {width: 130px;padding-left: 60px;padding-right: 60px;}
		.webuploader-element-invisible {
			display: none;
		}
		.moxie-shim{width:100%!important;height:100%!important;}
		div[name=aliFile]{    
			z-index: 2;
		    position: relative;
		    display: inline-block;
		    width: 160px;
		    height: 160px;
		    float: left;
		    margin-right: 20px;
		    margin-bottom: 22px;
		    overflow: hidden;
	    }
	    div[name=aliFile]:nth-child(4n){
	    	margin-right: 0;
	    }
	    div[name=aliFile] img:nth-child(1){
	    	max-height:none!important;
	    	max-width:none!important;
	    }
	    div[name=aliFile] br,div[name=aliFile] span,div[name=aliFile] .progress,div[name=aliFile] b{
	    	display:none;
	    }
	    .aliRemoveBtn{
	        width: 48px!important;
		    height: 48px;
		    position: absolute;
		    top: 0px;
		    right: 0px;
		    z-index: 9;
	    }
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg"/></div>
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
	
	<!-- 封面 -->
	<div class="roomage room_yindy">
	    <img class="bg" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017324143335kG2z2arMrICipZ7JKnOw4Xad5Wboz0.jpg">
	    <div class="jiant"></div>
	    <a class="ssgz" style="display:block;font-size:26px;color:#07121a;text-decoration: underline;position:absolute;right:45px;top:45px;" href="http://hs.hb.wenhuayun.cn/information/preInfo.do?informationId=88f97dd294cc4a70a7b730f195e3a4fb"><img style="margin-right:20px;" src="${path}/STATIC/wxStatic/image/roomagekind/icon8.png">赛事规则</a>
	</div>
	
	<div class="roomage">
		<div class="lccbanner">
			<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20173241350114xTaBebccFZGcBmOZEqGTsc0uLWREb.jpg" width="750" height="250">
			<ul class="lccshare clearfix">
				<li class="share-button"><a href="javascript:;">分享</a></li>
				<li class="keep-button"><a href="javascript:;">关注</a></li>
			</ul>
		</div>
		<div class="kjmbNav_wc">
			<ul class="kjmbNav clearfix">
				<li class="current"><a href="${path}/wechatStatic/walkIndex.do">首页</a></li>
				<li><a href="${path}/wechatStatic/walkRule.do">活动规则</a></li>
				<li><a href="${path}/wechatStatic/walkRanking.do">排行榜</a></li>
			</ul>
		</div>
	    <!-- 首页 -->
	    <div class="syxyhide">
	        <div class="sywenz jz700">
	        	<p>　　为迎接中国共产党第十九次全国代表大会的召开，反映近年来百姓生活的巨大变化，同时给广大摄影爱好者搭建交流展示的平台，体现大众参与摄影活动的成果，特举办此次市民摄影故事大赛活动。</p>
            	<p>　　本次大赛以“我们的行走故事”为主题，邀请群众通过镜头捕捉行走中的精彩瞬间，并用文字描述镜头外丰富多彩的旅途故事。专家评审与网民投票结合，入围即获颁发证书和百万用户品鉴，更选出100幅优秀作品在上海市群众艺术馆展览并编辑成册。</p>
	        </div>
	        <div id="userInfo1" class="personlable" style="display: none;"></div>
	        
            <div class="sytitxian"><span style="background-color:#eee;">最　新</span></div>
            <ul id="walkImgUl" class="springList"></ul>
            <div id="loadingWalkImgDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
	        
	        <div class="roomjkcy" onclick="toUpload();"><a href="javascript:;">即 刻<br>参 与</a></div>
	    </div>
	    <!-- 留资页 -->
	    <div class="roomcont jz700 syliuzy" style="display: none;">
	        <div class="jz645">
	            <div class="jinhaotit">
	                <div class="h1">#&nbsp;&nbsp;我要参赛&nbsp;&nbsp;#</div>
	                <div class="h2">请先填写参赛资料</div>
	            </div>
	            <div class="lccliuzy">
	                <div class="lccshuru">
	                    <span>姓名</span>
	                    <input class="txt" id="userName" type="text" maxlength="20">
	                </div>
	                <div class="lccshuru">
	                    <span>手机</span>
	                    <input class="txt" id="userMobile" type="text" maxlength="20">
	                </div>
	                <p>请正确填写个人信息，如您获得奖项，您提交的信息将作为领奖依据，一经提交不可修改。</p>
	                <div class="lccnextbu" onclick="userInfo();">下一步</div>
	            </div>
	        </div>
	    </div>
	    <!-- 上传照片 -->
	    <div class="lccscphoto jz700" style="display: none;">
		    <input id="walkImgName" class="lccPhotoD" placeholder="请输入作品名称（15字以内）" maxlength="15">
	        <textarea id="walkImgContent" class="lccPhotoK" placeholder="请告诉我们您拍摄这组照片的背后故事（200-2000字）" maxlength="2000"></textarea>
	        <input id="walkImgTime" class="lccPhotoD" placeholder="请输入拍摄时间，如：2017.03.15" maxlength="10">
	        <input id="walkImgSite" class="lccPhotoD" placeholder="请输入拍摄地点，如：云南丽江" maxlength="30">
	        <div class="add-comment-list" id="walkImgWebupload">
	            <ul id="ossfile2"></ul>
	            <div id="container" class="add-comment-button">
	               <img id="selectfiles2" src="${path}/STATIC/wxStatic/image/roomage/icon8.jpg" style="width:160px;height:160px;display:block;" />
	            </div>
	            <div style="clear:both"></div>
	        </div>
	        <div id="uploadBtn" class="lccnextbu" onclick="userUploadImg();">提 交</div>
	    </div>
	    <!-- 个人中心 -->
	    <div class="sygerzx" style="display: none;">
	        <div id="userInfo2" class="personlable"></div>
	        <div class="jz700" style="background-color:#fff;padding:24px 0;">
	            <ul id="myImgUl" class="springList"></ul>
	        </div>
	    </div>
	</div>
</body>
</html>