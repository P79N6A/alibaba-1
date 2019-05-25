<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·邀你一起打造上海城市名片</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<%@include file="/WEB-INF/why/common/aliImageFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	
	<script>
		var cityType = 7;	//本次活动编号
		var tab = '${tab}';
		var noControl = '${noControl}';	//1：不可操作
		var startIndex = 0;		//页数
	
		if (userId == null || userId == '') {
    		//判断登陆
        	publicLogin("${basePath}wechatFunction/cityIndex.do");
    	}
		
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '佛山文化云·邀你一起打造上海城市名片';
	    	appShareDesc = '每个月一个主题，征集你在上海各种空间的图片记忆，爱上海，从我做起。';
	    	appShareImgUrl = 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg';
	    	appShareLink = '${basePath}wechatFunction/cityIndex.do';
	    	
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
					title: "佛山文化云·邀你一起打造上海城市名片",
					desc: '每个月一个主题，征集你在上海各种空间的图片记忆，爱上海，从我做起。',
					link: '${basePath}wechatFunction/cityIndex.do',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg'
				});
				wx.onMenuShareTimeline({
					title: "佛山文化云·邀你一起打造上海城市名片",
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg',
					link: '${basePath}wechatFunction/cityIndex.do'
				});
				wx.onMenuShareQQ({
					title: "佛山文化云·邀你一起打造上海城市名片",
					desc: '每个月一个主题，征集你在上海各种空间的图片记忆，爱上海，从我做起。',
					link: '${basePath}/wechatFunction/cityIndex.do',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg'
				});
				wx.onMenuShareWeibo({
					title: "佛山文化云·邀你一起打造上海城市名片",
					desc: '每个月一个主题，征集你在上海各种空间的图片记忆，爱上海，从我做起。',
					link: '${basePath}/wechatFunction/cityIndex.do',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg'
				});
				wx.onMenuShareQZone({
					title: "佛山文化云·邀你一起打造上海城市名片",
					desc: '每个月一个主题，征集你在上海各种空间的图片记忆，爱上海，从我做起。',
					link: '${basePath}/wechatFunction/cityIndex.do',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg'
				});
			});
		}
		
		$(function () {
			if(tab == 1 || sessionStorage.getItem("showCover") == 1) {
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
			
			loadMyImg();
			loadSelectImg('f0e4ed4982c04829ad355af89b9f3e42');
			loadCityImg(0,20);
			
			aliUploadImg('cityImgWebupload', getCityUrls, 9, true, 'H5');
			
			//swiper初始化div
		    initSwiper();
			
			navFixed($(".kjmbNav"),'touchmove',240);
		    navFixed($(".kjmbNav"),'scroll',240);
		    
		    //话题
		    $(".huti span").click(function(){
		    	var cityImgContent = $("#cityImgContent").val();
		    	$("#cityImgContent").val(cityImgContent+$(this).text());
		    });
		    
		 	// 首页和个人中心关闭大图
	        $('.roomBigPic').bind('click', function () {
	            $(this).stop().fadeOut(80, function () {
	                outSwiper.removeAllSlides();
	            });
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
		
		//上传回调
        function getCityUrls(up, file, info) {
        	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
        	$("#"+file.id).append("<input type='hidden' value='"+filePath+"'/>");
        	//自动居中
	    	$("#"+file.id).find('img:eq(0)').picFullCentered({'boxWidth' : 160,'boxHeight' : 160});
		}
		
		//查询自己上传照片
		function loadMyImg(){
			var data = {
				cityType: cityType,
            	userId: userId,
            	isMe: 1
            };
			$.post("${path}/wechatFunction/queryCityImgList.do",data, function (data) {
				if(data.length>0){
					var imgCount = 0;	//照片张数
					$.each(data, function (i, dom) {
						var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
						var cityImgHtml = getCityImgHtml(dom.cityImgId,dom.cityImgUrl,"my");
						$.each(dom.cityImgUrl.split(";"), function (j, dom2) {
							imgCount++;
						});
						var voteClass = "";
						if(dom.isVote == 1){
							voteClass = "current";
						}
						$("#myImgUl").append("<li>" +
									            "<div class='sphead clearfix'>" +
								                    "<div class='toux'>"+userHeadImgHtml+"</div>" +
								                    "<div class='char'><div class='na'>"+dom.userName+"</div></div>" +
								                "</div>" +
								                cityImgHtml +
								                "<div class='miaoshu'>"+dom.cityImgContent+"</div>" +
								                "<div class='operate clearfix'>" +
								                    "<div class='qulp' onclick='location.href=\"${path}/wechatFunction/cityDetail.do?cityImgId="+dom.cityImgId+"\"'>去拉票</div>" +
								                    "<div class='dian "+voteClass+"' onclick='cityVote(\""+dom.cityImgId+"\",this);'>"+dom.voteCount+"</div>" +
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
							                "<div class='icon' onclick='toMyCityImg()'></div>" +
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
		
		//精选照片
		function loadSelectImg(cityImgIds){
			var data = {
				cityType: cityType,
            	userId: userId,
            	cityImgIds: cityImgIds
            };
			$.post("${path}/wechatFunction/querySelectCityImgList.do",data, function (data) {
				if(data.length>0){
					$.each(data, function (i, dom) {
						var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
						var cityImgHtml = getCityImgHtml(dom.cityImgId,dom.cityImgUrl,"img");
						var voteClass = "";
						if(dom.isVote == 1){
							voteClass = "current";
						}
						$("#selectImgUl").append("<li>" +
											        "<div class='sphead clearfix'>" +
									                    "<div class='toux'>"+userHeadImgHtml+"</div>" +
									                    "<div class='char'><div class='na'>"+dom.userName+"</div></div>" +
									                "</div>" +
									                cityImgHtml +
									                "<div class='miaoshu'>"+dom.cityImgContent+"</div>" +
									                "<div class='operate clearfix'>" +
									                    "<div class='qulp' onclick='location.href=\"${path}/wechatFunction/cityDetail.do?cityImgId="+dom.cityImgId+"\"'>去拉票</div>" +
									                    "<div class='dian "+voteClass+"' onclick='cityVote(\""+dom.cityImgId+"\",this);'>"+dom.voteCount+"</div>" +
									                "</div>" +
									            "</li>");
					});
				}
			},"json");
		}
		
		//最新照片
		function loadCityImg(index, pagesize){
			var data = {
				cityType: cityType,
            	userId: userId,
            	firstResult: index,
               	rows: pagesize
            };
			$.post("${path}/wechatFunction/queryCityImgList.do",data, function (data) {
				if(data.length<20){
        			$("#loadingCityImgDiv").html("");
	        	}
				if(data.length>0){
					$.each(data, function (i, dom) {
						var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
						var cityImgHtml = getCityImgHtml(dom.cityImgId,dom.cityImgUrl,"img");
						var voteClass = "";
						if(dom.isVote == 1){
							voteClass = "current";
						}
						$("#cityImgUl").append("<li>" +
											        "<div class='sphead clearfix'>" +
									                    "<div class='toux'>"+userHeadImgHtml+"</div>" +
									                    "<div class='char'><div class='na'>"+dom.userName+"</div></div>" +
									                "</div>" +
									                cityImgHtml +
									                "<div class='miaoshu'>"+dom.cityImgContent+"</div>" +
									                "<div class='operate clearfix'>" +
									                    "<div class='qulp' onclick='location.href=\"${path}/wechatFunction/cityDetail.do?cityImgId="+dom.cityImgId+"\"'>去拉票</div>" +
									                    "<div class='dian "+voteClass+"' onclick='cityVote(\""+dom.cityImgId+"\",this);'>"+dom.voteCount+"</div>" +
									                "</div>" +
									            "</li>");
					});
				}
			},"json");
		}
		
		//投票
		function cityVote(cityImgId,$this){
			if(noControl != 1){
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatFunction/cityIndex.do");
	        	}else{
	        		$.post("${path}/wechatFunction/addCityVote.do",{userId:userId,cityImgId:cityImgId,cityType:cityType}, function (data) {
	    				if(data == "200"){
	    					$($this).addClass('current');
	   						var count = $($this).text();
	   						$($this).text(eval(count) + 1);
	    				}else if(data == "repeat"){
	    					dialogAlert('系统提示', '一天只能投一票！');
	    				}else if(data == "500"){
	    					dialogAlert('系统提示', '投票失败！');
	    				}
	    			},"json");
	        	}
			}else{
				dialogAlert('系统提示', '活动已结束！');
			}
		}
		
		//跳转到我的图片
		function toMyCityImg(){
			$('.syxyhide').hide();
			$('.sygerzx').show();
            
			$(".kjmbNav").css('position', 'static');
		}
		
		//即刻参与
		function toUpload(){
			if(noControl != 1){
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatFunction/cityIndex.do");
	        	}else{
	        		$.post("${path}/wechatFunction/queryCityUser.do", {userId: userId}, function (data) {
	        			if(data.ccpCityUser==null){
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
	        		        $("#cityImgContent").val("");
	        		        $("#upPhoto").attr("src","${path}/STATIC/wxStatic/image/roomage/pic10.jpg");
	        			}
	        		}, "json");
	        	}
			}else{
				dialogAlert('系统提示', '活动已结束！');
			}
		}
		
		//保存用户
		function userInfo(){
			if (userId == null || userId == '') {
				//判断登陆
				publicLogin("${basePath}wechatFunction/cityIndex.do");
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
				$.post("${path}/wechatFunction/addCityUser.do", data, function(data) {
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
				publicLogin("${basePath}wechatFunction/cityIndex.do");
			}else{
				var cityImgContent = $("#cityImgContent").val();
				if(cityImgContent == ""){
			    	dialogAlert('系统提示', '请输入内容！');
			    	$("#uploadBtn").attr("onclick","userUploadImg();");
			        return false;
			    }
	    		var cityImgUrl = '';
				var flag = 0;
	    		$("#ossfile2 div[name=aliFile]").each(function(index, element) {
	    			if(!$(element).find("input")){
				    	flag = 1;
	    			}else{
	    				cityImgUrl += $(element).find("input").val() + ";";
	    			}
	    		});
	    		if(flag == 1){
	    			dialogAlert('系统提示', '图片还在上传中，请稍后~');
			    	$("#uploadBtn").attr("onclick","userUploadImg();");
			    	return false;
	    		}
	    		if(cityImgUrl.length>0){
	    			cityImgUrl = cityImgUrl.substring(0, cityImgUrl.length-1);
	    		}else{
	    			dialogAlert('系统提示', '请上传图片！');
	    			$("#uploadBtn").attr("onclick","userUploadImg();");
	    			return false;
	    		}
				var data = {
					cityType:cityType,
					cityImgUrl:cityImgUrl,
					userId:userId,
					cityImgContent:cityImgContent
				}
				$.post("${path}/wechatFunction/addCityImg.do",data, function (data) {
					if (data == "1") {
	    				dialogConfirm('系统提示', "提交成功，恭喜获得500文化云积分！",function(){
	    					location.href = '${path}/wechatFunction/cityIndex.do?tab=1'
	    				});
	    			}else if (data == "2") {
	    				dialogConfirm('系统提示', "提交成功，恭喜获得700文化云积分！",function(){
	    					location.href = '${path}/wechatFunction/cityIndex.do?tab=1'
	    				});
	    			}else if (data == "10") {
	    				dialogConfirm('系统提示', "提交成功，恭喜获得200文化云积分！",function(){
	    					location.href = '${path}/wechatFunction/cityIndex.do?tab=1'
	    				});
	    			}else if (data == "200") {
	    				dialogConfirm('系统提示', "提交成功！",function(){
	    					location.href = '${path}/wechatFunction/cityIndex.do?tab=1'
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
		function getCityImgHtml(cityImgId,cityImgUrl,attrName){
			var cityImgUrls = cityImgUrl.split(";");
			var cityImgType = 1;	//1张图
			if(cityImgUrls.length > 1 && cityImgUrls.length <= 3){	//2、3张图
				cityImgType = 2;
			}else if(cityImgUrls.length > 3){	//大于3张图
				cityImgType = 3;
			}
			var cityImgHtml = "<div class='pictrue clearfix pictrue_"+cityImgType+"'>";
			$.each(cityImgUrls, function (i, dom) {
				var cityImgWidth;
				var cityImgHeigth;
				if(cityImgType == 2){
					cityImgWidth = 207;
					cityImgHeigth = 166;
				}else if(cityImgType == 3){
					if(i == 0){
						cityImgWidth = 420;
						cityImgHeigth = 340;
					}else{
						cityImgWidth = 215;
						cityImgHeigth = 166;
					}
				}
				var ImgObj = new Image();
				ImgObj.src = dom+"@700w";
				ImgObj.onload = function(){
					if(cityImgType == 1 && (ImgObj.width/ImgObj.height)<1.6 && (ImgObj.width/ImgObj.height)>0.4){	//不作处理
						if(ImgObj.width/ImgObj.height<1){
							$("img[cityImgId="+attrName+cityImgId+i+"]").css("height","646px");
						}else{
							$("img[cityImgId="+attrName+cityImgId+i+"]").css("width","646px");
						}
					}else{
						if(cityImgType == 1){	//1张图时按宽高比做不同处理
							if(ImgObj.width/ImgObj.height<1){
								cityImgWidth = 538;
								cityImgHeigth = 646;
							}else{
								cityImgWidth = 646;
								cityImgHeigth = 340;
							}
							$("img[cityImgId="+attrName+cityImgId+i+"]").parent(".item").css({"height":cityImgHeigth+"px","width":cityImgWidth+"px"});
						}
						if(ImgObj.width/ImgObj.height>cityImgWidth/cityImgHeigth){
							var pLeft = (ImgObj.width*(cityImgHeigth/ImgObj.height)-cityImgWidth)/2;
							$("img[cityImgId="+attrName+cityImgId+i+"]").css({"height":cityImgHeigth+"px","position":"absolute","left":"-"+pLeft+"px"});
						}else{
							var pTop = (ImgObj.height*(cityImgWidth/ImgObj.width)-cityImgHeigth)/2;
							$("img[cityImgId="+attrName+cityImgId+i+"]").css({"width":cityImgWidth+"px","position":"absolute","top":"-"+pTop+"px"});
						}
					}
				}
				if(cityImgType == 3 && i > 1){
					cityImgHtml += "<div class='item' onclick='previewImg(\""+dom+"\",\""+cityImgUrl+"\")'><img cityImgId='"+attrName+cityImgId+i+"' src='"+dom+"@700w'><div class='outstrip'>+"+eval(cityImgUrls.length-2)+"</div></div>";
					return false;
				}else{
					cityImgHtml += "<div class='item' onclick='previewImg(\""+dom+"\",\""+cityImgUrl+"\")'><img cityImgId='"+attrName+cityImgId+i+"' src='"+dom+"@700w'></div>";
				}
			});
			cityImgHtml += "</div>"
			return cityImgHtml;
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
              		loadCityImg(index,20);
           		},500);
            }
        });
	</script>
	
	<style>
		html,body {height: 100%;}
		.roomage {min-height: 100%;}
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
	<div style="display: none;"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg"/></div>
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
	    <img class="bg" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619105626kkX3bo1SnuGh0uCiYodxl8ZbxvmlbR.jpg">
	    <div class="jiant"></div>
	</div>
	
	<div class="roomage">
		<div class="lccbanner">
			<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201761910580PO8neFr00YNFpdQh9scgaNJrKOc3wH.jpg" width="750" height="250">
			<ul class="lccshare clearfix">
				<li class="share-button"><a href="javascript:;">分享</a></li>
				<li class="keep-button"><a href="javascript:;">关注</a></li>
			</ul>
		</div>
		<div class="kjmbNav_wc">
			<ul class="kjmbNav clearfix">
				<li class="current"><a href="${path}/wechatFunction/cityIndex.do?tab=1">首页</a></li>
				<li><a href="${path}/wechatFunction/cityRanking.do">排行榜</a></li>
				<li><a href="${path}/wechatFunction/cityRule.do">活动规则</a></li>
				<li><a href="${path}/wechatFunction/cityReview.do">往期回顾</a></li>
			</ul>
		</div>
	    <!-- 首页 -->
	    <div class="syxyhide">
	        <div class="sywenz jz700"><p>　　上海是一座现代化摩登都市，然而最让人流连的却是老城区里的一条条弄堂和海派风情的老洋房。在幽深的弄堂里人们迎着太阳或是斜倚门栏，或是摇着扇儿；在上海老洋房里人们听着黑胶唱片缓缓起舞或是感慨世间纷扰，或是感叹大好时光...... 通过老弄堂、老洋房看尽旧上海的韵味悠然。探索上海老弄堂、老洋房，让房屋发声，讲述旧上海的前世今生，随手拍下老弄堂或是老洋房的独特风情，即可获得500积分，感受上海老建筑情怀，尽享城市文化生活。</p></div>
	        <div id="userInfo1" class="personlable" style="display: none;"></div>
	        
            <div class="sytitxian"><span style="background-color:#eee;">精　选</span></div>
            <ul id="selectImgUl" class="springList"></ul>
            <div class="sytitxian"><span style="background-color:#eee;">最　新</span></div>
            <ul id="cityImgUl" class="springList"></ul>
            <div id="loadingCityImgDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
	        
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
	        <div class="huti">
	            <span>#弄堂里#</span>
	            <span>#老洋房#</span>
	            <span>#上海风情#</span>
	            <span>#石库门#</span>
	        </div>
	        <textarea id="cityImgContent" class="lcctxtarea" placeholder="请输入文字..." maxlength="100"></textarea>
	        <div class="add-comment-list" id="cityImgWebupload">
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