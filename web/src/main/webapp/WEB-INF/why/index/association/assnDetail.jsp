<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta charset="UTF-8"/>
	<%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/bpNormalize.css">
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/bpCulture.css">
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/bzStyle.css">
	<script type="text/javascript" src="${path}/STATIC/js/frontBp/culture.js"></script>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/bpNormalize.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/ui-dialog.css"/>
     <!--阿里上传插件-->
		<script type="text/javascript" src="${path}/STATIC/ossjs/crypto.js"></script>
		<script type="text/javascript" src="${path}/STATIC/ossjs/hmac.js"></script>
		<script type="text/javascript" src="${path}/STATIC/ossjs/sha1.js"></script>
		<script type="text/javascript" src="${path}/STATIC/ossjs/base64.js"></script>
		<script type="text/javascript" src="${path}/STATIC/ossjs/plupload.full.min.js"></script>
		<script type="text/javascript" src="${path}/STATIC/ossjs/upload.js"></script>
		<script type="text/javascript" src="${path}/STATIC/ossjs/uuid.js"></script>
		<link rel="stylesheet" href="${path}/STATIC/ossjs/aliUploadStyle.css" />
	<style type="text/css">
		html{height: 100%;}
		body{background-color: #ededed;height: 100%;}
		div[name = aliFile]{float: left;width: 150px;height: 150px;border: 2px dashed #b0b0b0;margin-right: 13px;margin-bottom: 10px;}
		.imgPack{width: 100%;height: 100%;position: relative;}
		.imgPack .upload-img-identify{position: absolute;left: 0;right: 0;bottom: 0;top: 0;max-width: 154px;max-height: 154px;margin: auto;}
		.imgPack .aliRemoveBtn{position: absolute;right: -10px;top: -10px;z-index: 10;}
		div[name = aliFile] span,div[name = aliFile] b{display: none;}
		
		.mask {position: absolute;}
		.joinWrap {height: auto;padding: 48px 107px 48px 108px;top:0; margin-top: 0;}
		
		#webUpload {width:575px;}
		#container {float:left;}
		#selectfiles {width:80px;height:80px;margin-bottom:15px;}
		#ossfile {width:475px;float:left;}
		#ossfile div[name="aliFile"] {width:80px;height:80px;border:none;margin-left:15px;margin-right:15px;margin-bottom:15px;}
		.imgPack {width:80px;height:80px;position: relative;overflow: hidden;}
		.imgPack .aliRemoveBtn {position: absolute;right: 0;top: 0px;z-index: 10;width: 30px;height: auto;cursor: pointer;}
	</style>
	<script type="text/javascript">
	var userId = '${sessionScope.terminalUser.userId}';
	var assnId = '${assnId}';
	$.ajaxSetup({  
	    async : false //取消异步  
	}); 
	 $(function(){
		 var photoCount = ${photoCount};
		 var videoCount = ${videoCount};
		 var hisActCount = ${hisActCount};
     	//加载社团信息
     	$.post("${path}/frontAssn/getAssnDetail.do",{associationId:assnId,userId:userId}, function (data) {
 			if(data.status == 1){
 			    debugger;
 				var assn = data.data;
 				var assnImgUrl = assn.assnImgUrl.indexOf("http://")<0?getIndexImgUrl(getImgUrl(assn.assnImgUrl),"_750_500"):(assn.assnImgUrl+"@800w");
				var assnIconUrl = assn.assnIconUrl.indexOf("http://")<0?getIndexImgUrl(getImgUrl(assn.assnIconUrl),"_150_150"):(assn.assnIconUrl+"@200w");				
				var memberCount = assn.assnMember;
				var fansCount = eval(assn.fansCount) + eval(assn.assnFansInit);
				var flowerCount = eval(assn.flowerCount) + eval(assn.assnFlowerInit);
				var shareTitle = assn.shareTitle;
				var shareDesc = assn.shareDesc;
				$("#assnHead").append("<img src='"+assnIconUrl+"' class='pto'/>");
     			//是否关注
 				if(assn.isFollow==1){
 					$("#isFollow").append("已关注");
     			}else{
     				$("#isFollow").append("<img src='${path}/STATIC/image/qy_gz.png'/>关注");
     			}
     			//名称
 				$("#assnName").html(assn.assnName);
 				$("#title").append(assn.assnName);
 				//标签
 				var tagHtml = ""
 				var tagList = assn.assnTag.split(",");
 				$.each(tagList, function (i, tag) {
						tagHtml += "<span>"+tag+"</span>";
					});
 				$("#tagUl").html(tagHtml);
 									
 				//是否浇花
 				if(assn.todayIsFlower==1){
 					$("#isFlower").append("已浇花");
 					$("#isFlower").addClass("flower-on");
 				}else{
 					$("#isFlower").append("浇花");
 				}
 								
 				//社团介绍
 				$("#assnContent").html(assn.assnContent.replace(/\r\n/g,"<br/>"));
 				//成员、粉丝、浇花
 				$("#memberCount").html(memberCount);
 				$("#fansCount").html(fansCount);
 				$("#flowerCount").html(flowerCount);

 			}
     	}, "json");
     	
     	if(hisActCount==0){
     		$("#assnHisAct").hide();
     	}
     	if(photoCount!=0){
     		loadPic();
     	}
     	
	 })
	 function loadPic(){
		 var reqPage=$("#reqPage").val();
		/*  var countPage = $("#countpage").val(); */
		//加载社团图片
		$("#imgContent").load("${path}/frontAssn/getAssnRes.do #picDiv",{associationId:assnId,resType:1,page:reqPage},function(responseTxt,statusTxt){
			//分页
	        kkpager.generPageHtml({
	            pno :$("#pages").val() ,
	            //总页码
	            total :$("#countpage").val(),
	            //总数据条数
	            totalRecords :$("#total").val(),
	            mode : 'click',
	            click : function(n){
	                this.selectPage(n);
	                $("#reqPage").val(n);

	                loadPic();
	                return false;
	            }
	        });
	        
	    })
	    /*    	$.post("${path}/frontAssn/getAssnRes.do",{associationId:assnId,resType:1}, function (data) {
	       		if(data.status == 1){
	       			if(data.data.length>0){        				
	       					$.each(data.data, function (i, dom) {
	       						var assnResUrl = dom.assnResUrl.indexOf("http://")<0?getIndexImgUrl(getImgUrl(dom.assnResUrl),"_750_500"):(dom.assnResUrl+"@800w");
	       						
	       						var assnResName = dom.assnResName!=null?dom.assnResName:"";
	       						$("#assnImgUl").append("<li><div class='img'><img src='"+assnResUrl+"' width='240px' height='155px'/></div></li>");       						
	       					});
	       					
	       			}
	       			$("#phoCount").html(" ("+data.data.length+")");
	       		}
	       	}, "json"); */
	 }
	 function loadVideo(){
		//加载社团视频
		 var reqPage=$("#reqPage").val();
		 /* var countPage = $("#countpage").val(); */
		//加载社团图片
		$("#imgContent").load("${path}/frontAssn/getAssnRes.do #videoDiv",{associationId:assnId,resType:2,page:reqPage},function(responseTxt,statusTxt){
			//分页
	        kkpager.generPageHtml({
	            pno :$("#pages").val() ,
	            //总页码
	            total :$("#countpage").val(),
	            //总数据条数
	            totalRecords :$("#total").val(),
	            mode : 'click',
	            click : function(n){
	                this.selectPage(n);
	                $("#reqPage").val(n);

	                loadVideo();
	                return false;
	            }
	        });
	        
	    })
		 	/* $.post("${path}/frontAssn/getAssnRes.do",{associationId:assnId,resType:2}, function (data) {
		 		if(data.status == 1){
		 			if(data.data.length>0){	 				
		 					$.each(data.data, function (i, dom) {
		 						var assnResCover = dom.assnResCover.indexOf("http://")<0?getIndexImgUrl(getImgUrl(dom.assnResCover),"_750_500"):(dom.assnResCover+"@800w");
		 						$("#assnVideoUl").append("<li><div class='img'>" +
		 													"<video src='"+dom.assnResUrl+"' width='240px' height='155px' poster='"+assnResCover+"' controls/>" +	 													
		 												 "</div><div class='stName'>"+dom.assnResName+"</div></li>");
		 					});
		 					
		 				}
		 			$("#videoCount").html(" ("+data.data.length+")");
		 		}
		 	}, "json"); */
	 }	
	  	
	 function loadHisAct(){
			//加载社团视频
			 var reqPage=$("#reqPage").val();
			 /* var countPage = $("#countpage").val(); */
			$("#hisActContent").load("${path}/frontAssn/getAssnHistoryActivity.do #hisActDiv",{associationId:assnId,page:reqPage},function(responseTxt,statusTxt){
				$("#hisActDiv li").each(function (index, item) {
	    			var imgUrl = $(this).attr("data-url");
	                if (imgUrl != undefined && imgUrl != "" && imgUrl != null) {
	                    $(item).find("img").attr("src", getImgUrl(getIndexImgUrl(imgUrl, "_300_300")));
	                } else {
	                    $(item).find("img").attr("src", "../STATIC/image/default.jpg");
	                }
	            });
				//分页
		        kkpager.generPageHtml({
		            pno :$("#pages").val() ,
		            //总页码
		            total :$("#countpage").val(),
		            //总数据条数
		            totalRecords :$("#total").val(),
		            mode : 'click',
		            click : function(n){
		                this.selectPage(n);
		                $("#reqPage").val(n);

		                loadHisAct();
		                return false;
		            }
		        });

		    })
	 }
	 function toAssnHisAct(activityId){
		 location.href='${path}/frontActivity/frontActivityDetail.do?activityId='+activityId;
	 }
    	//加载社团招募信息
    	$(function(){
    		$.post("${path}/frontAssn/getAssnRecruit.do",{assnId:assnId}, function (data) {   		
       			$("#recruitId").val(data.recruitId);
           		$("#endTime").html(data.recruitEndTime);
           		$("#maxPeople").html(data.recruitNumber);
           		$("#require").html(data.recruitRequirment.replace(/\r\n/g,"<br/>"));
           		$("#recruitDiv").show();
        	},"json")
    	})   	
        
		$(function () {
			$(".tabTop").on("click","li",function(){
				$(this).addClass("cur").siblings().removeClass("cur");
				$("#reqPage").val(1);
				$("#kkpager").remove();
				if($(this).attr("id")=="assnPhoto"){					
					$("#assnVideoUl").hide();
					$("#assnHisActUl").hide();
					loadPic();
					$("#assnImgUl").show();
				}
				if($(this).attr("id")=="assnVideo"){					
					$("#assnImgUl").hide();
					$("#assnHisActUl").hide();
					loadVideo();
					$("#assnVideoUl").show();
				}
				if($(this).attr("id")=="assnHisAct"){					
					$("#assnImgUl").hide();
					$("#assnVideoUl").hide();
					loadHisAct();
					$("#assnHisActUl").show();
				}
			});
			$(".zhankai").click(function(){
				if ($(this).hasClass("open")) {
					$(this).removeClass("open");
					$(this).find("img").attr("src","${path}/STATIC/image/qy_down.png");
					$(".stContent").attr("style","height:445px");
				}else{
					$(this).addClass("open");
					$(this).find("img").attr("src","${path}/STATIC/image/qy_up.png");
					$(".stContent").attr("style","height:auto");
				}
			})
			//关注
			$("#isFollow").on("click", function() {
				if (userId == null || userId == "") {
		        	dialogAlert("提示", '登录之后才能关注', function () {
		            		
		            	});
		            return;
		        }else{
					if($("#isFollow").html()=="已关注") {
						$.post("${path}/frontAssn/wcDelCollectAssn.do", {assnId: assnId, userId: userId}, function (data) {
	                        if (data.status == 0) {	    
	                        	dialogAlert("提示", "已取消关注！", function () {
	                        		window.location.href = "${path}/frontAssn/toAssnDetail.do?assnId=" + assnId;
	        	     	        	});	                            
	                        }
	                    }, "json");
					} else {
						$.post("${path}/wechatAssn/wcCollectAssn.do", {assnId: assnId, userId: userId}, function (data) {
	                        if (data.status == 0) {
	                        	dialogAlert("提示", "关注成功！", function () {
	                        		window.location.href = "${path}/frontAssn/toAssnDetail.do?assnId=" + assnId;
	        	     	        	});	
	                        }
	                    }, "json");
					}
				}
			});

        	//浇花
			$("#isFlower").on("click", function() {
				if (userId == null || userId == "") {
		        	dialogAlert("提示", '登录之后才能浇花', function () {
		            		
		            	});
		            return;
		        }else{
					if(!$("#isFlower").hasClass("flower-on")) {
						$.post("${path}/frontAssn/saveAssnFlower.do", {associationId: assnId, userId: userId}, function (data) {
							if(data.status == 1){
								dialogAlert("提示", "浇花成功！", function () {
	                        		window.location.href = "${path}/frontAssn/toAssnDetail.do?assnId=" + assnId;
	        	     	        	});
								
							}
						}, "json");
					}else{
						dialogAlert("提示", "今日已浇花！", function () {
                    		
    	     	        	});
					}
				}
			})
			$(".wantBm").click(function(){
				$('.mask').css({'height': $(document).height()});
				$('.joinWrap').css({'top':$(document).scrollTop() + 20});
				if (userId == null || userId == "") {
		        	dialogAlert("提示", '登录之后才能报名', function () {
		            		
		            	});
		            return;
		        }else{
		        	$(".mask").show();
	        	}								
			})
		});
		 //我要报名
		 function applyRecruit(){
	    	if (userId == null || userId == "") {
	        	dialogAlert("提示", '登录之后才能报名', function () {
	            		
	            	});
	            return;
	        }else{
	     		$("#applyAssnBut").attr("onclick","");
	 	        var applyName=$('#applyName').val();
	 	        var applyCard = $("#applyCard").val();
	 	        var moblie = $("#moblie").val();
	 	        var personProfile = $("#personProfile").val();
	 	        
	 	        //姓名
	 	        if(applyName==undefined||applyName.trim()==""){
	 	        	$("#applyAssnBut").attr("onclick","applyRecruit();");
	 	        	dialogAlert('系统提示', '姓名为必填项！');
	 	            $('#applyName').focus();
	 	            return;
	 	        }else{
	 	            if(applyName.length>20){
	 	            	$("#applyAssnBut").attr("onclick","applyRecruit();");
	 	            	dialogAlert('系统提示',"姓名只能输入20字以内！");
	 	                $('#applyName').focus();
	 	                return false;
	 	            }
	 	        }
	 	       var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
	 	        //身份证
	 	        if(applyCard==undefined||applyCard.trim()==""){
	 	        	$("#applyAssnBut").attr("onclick","applyRecruit();");
	 	            dialogAlert('系统提示',"身份证为必填项！");
	 	            $('#applyCard').focus();
	 	            return;
	 	        }else if(!reg.test(applyCard)){	 
	 	        	$("#applyAssnBut").attr("onclick","applyRecruit();");
 	                dialogAlert('提示', "身份证不合法!");
 	                return;
	 	            
	 	        }
	 	       var telReg = (/^(0|86|17951)?(13[0-9]|15[012356789]|17[0135678]|18[0-9]|14[57])[0-9]{8}$/);
	 	        //联系电话
	 	        if(moblie==undefined||moblie==""){
	 	        	$("#applyAssnBut").attr("onclick","applyRecruit();");
	 	        	dialogAlert('系统提示',"联系方式为必填项！");
	 	            $('#moblie').focus();
	 	            return;
	 	        }else if (!moblie.match(telReg)) {
	 	        	$("#applyAssnBut").attr("onclick","applyRecruit();");
	                dialogAlert('系统提示', '请正确填写手机号码！');
	                return;
	            }
	 	         	     	        
	 	      	//个人简介
	 	        if(personProfile==undefined||personProfile.trim()==""){
	 	        	$("#applyAssnBut").attr("onclick","applyRecruit();");
	 	        	dialogAlert('系统提示',"个人简介为必填！");
	 	            $('#assnIntroduce').focus();
	 	            return;
	 	        }else{
	 	            if(personProfile.length>1000){
	 	            	$("#applyAssnBut").attr("onclick","applyRecruit();");
	 	            	dialogAlert('系统提示',"个人简介只能输入500字以内！");
	 	                $('#personProfile').focus();
	 	                return false;
	 	            }
	 	        }
	 	       var imgpic = $(".upload-img-identify");
	   	      	if(imgpic.length==0){
	   	      		$("#applyAssnBut").attr("onclick","applyAssn();");
	   	        	dialogAlert('系统提示',"图片必须上传！");
	   	            return;
	   	      	}else{
	   	      		$("#pic").val("");
	   	      		for(var i = 0;i < imgpic.length; i++){
	   	      			if($("#pic").val().trim()==""){
	   						$("#pic").val(imgpic[i].getAttribute('src'));
	   					}else{
	   						$("#pic").val($("#pic").val()+","+imgpic[i].getAttribute('src'));
	   					} 
	   	      		}
	   	      	}
	 	      	$("#applyId").val(userId);
	 	      	$("#assnId").val(assnId);
	 	        //保存申请信息
	 	        $.post("${path}/frontAssn/applyRecruit.do", $("#recruitApplyForm").serialize(),function(data) {
	                 if (data!=null&&data=='success') {
	                	 dialogAlert("提示", "申请完成！", function () {
	                 		window.location.href = '${path}/frontAssn/toAssnDetail.do?assnId=' + assnId;
	 	     	        	});
	                 }else if(data!=null&&data=='applyed'){
	                	 dialogAlert("提示", "您已经报名了,请不要重复报名！", function () {
		                 		window.location.href = '${path}/frontAssn/toAssnDetail.do?assnId=' + assnId;
		 	     	        	});
	                 }else{
	                 	$("#applyAssnBut").attr("onclick","applyRecruit();");
	                 	dialogAlert('系统提示', '申请失败！');
	                 }
	 	        },"json");
	     	}
		    }
			function test(up, file, fileName) {
				
				//上传格式判断，如果不对，触发删除事件
				var _type = fileName.split(".")[1].toLowerCase();
				if(_type != "png" && _type != "jpg" && _type != "jpeg" && _type != "gif"){
					$("#" + file.id).find(".aliRemoveBtn").click();
				}else{
					/* if($("#pic").val().trim()==""){
						$("#pic").val(fileName);
					}else{
						$("#pic").val($("#pic").val()+","+fileName);
					} */
				}
				
				//console.log('http://culturecloud.img-cn-hangzhou.aliyuncs.com/' + fileName)
			}
			$(function() {
				$(".mask").click(function(){
					$(this).hide();
				});
				$(".joinWrap").click(function(e){
					window.event? window.event.cancelBubble = true : e.stopPropagation();
				});
				$(".fqBtn").click(function(){
					$(".mask").hide();
				});
				console.log($("#select").val())

				aliUpload({
					uploadDomId: 'webUpload',
					//fileFormat:'jpg,jpeg',
					fileNum: 9,
					progressBar: false,
					callBackFunc: test,
					imgPreview: true,
				})
			})
	</script>
</head>
<body>
<div class="header">
   <!-- 导入头部文件 -->
<%@include file="/WEB-INF/why/index/header.jsp" %>
</div>
	<div class="qyMain">
		<div class="bread" id="title">所在位置：文体社团 &gt; </div>
		<div class="stTop clearfix">
			<div class="stPhoto" id="assnHead">				
			<%-- 	<!-- T  G   V-->
				<img src="${path}/STATIC/image/pt_t.png" class="grade"> --%>
			</div>
			<div class="perInfo">
				<p class="name" id="assnName"></p>
				<div class="perTag" id="tagUl"></div>
				<div class="slTag"><span>实名认证</span><span>资格认证</span></div>
			</div>
			<div class="infoNum clearfix">
				<div>
					<p id="memberCount"></p>
					<hr>
					<p>成&nbsp;&nbsp;员</p>
				</div>
				<div>
					<p id="fansCount"></p>
					<hr>
					<p>粉&nbsp;&nbsp;丝</p>
				</div>
				<div>
					<p id="flowerCount"></p>
					<hr>
					<p>浇&nbsp;&nbsp;花</p>
				</div>
			</div>
		</div>
		<div class="stMain clearfix">
			<div class="stLeft">
				<ul class="tabTop clearfix">
					<li class="cur" id="assnPhoto">社团照片<span id="phoCount">（${photoCount}）</span></li>
					<li id="assnVideo">社团视频<span id="videoCount">（${videoCount}）</span></li>
					<li id="assnHisAct">精彩回顾<span id="hisActCount">（${hisActCount}）</span></li>
				</ul>
				<div class="stList">
					<!-- 社团照片 -->
					<div id="imgContent"></div>

					<!-- 视频列表 -->
					<div id="videoContent"></div>
					
					<!-- 精彩回顾 -->
					<div id="hisActContent"></div>
					<input type="hidden" id="reqPage"  value="1">
				</div>
			</div>
			<div class="stRight">
				<div class="btnWrap">
					<span><button id="isFollow"></button></span>
					<span><button id="isFlower"><img src="${path}/STATIC/image/qy_jh.png"></button></span>
					<p class="node"><img src="${path}/STATIC/image/qy_gt.png">每天24:00后，可以为圈主浇花一次</p>
				</div>
				<div class="rightMain">										
					<!-- 社团招募 -->
					<div id="recruitDiv" style="display:none">
						<div class="title">社团招募</div>
						<hr>
						<div class="information clearfix"><span>截止时间：</span><b id="endTime"></b></div>
						<div class="information clearfix"><span>招募人数：</span><b id="maxPeople"></b></div>
						<div class="information clearfix"><span>招募要求：</span></div>
						<div class="yqContent">
							<p id="require"></p>
						</div>
						<button class="wantBm">我要报名</button>
					</div>
					<!-- 社团简介 -->
					<br/>
					<div>
						<div class="title">社团简介</div>
						<hr>
						<div class="stContent">
							<p id="assnContent"></p>							
						</div>
						<div class="zhankai"><img src="${path}/STATIC/image/qy_down.png"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="mask" style="display: none">
		<form id="recruitApplyForm">
		<input id="applyId" name="applyId" type="hidden" value=""/>
		<input id="recruitId" name="recruitId" type="hidden" value=""/>
		<input id="assnId" name="assnId" type="hidden" value=""/>
		<input id="pic" name="pic" type="hidden"/>
			<div class="joinWrap">
				<p class="title">请填写您的个人资料</p>
				<div class="information clearfix">
					<label>姓&emsp;&emsp;名</label>
					<input type="text" id="applyName" name="applyName" placeholder="请输入您的姓名"/>
				</div>
				<div class="information clearfix">
					<label>身&nbsp;&nbsp;份&nbsp;&nbsp;证</label>
					<input type="text" id="applyCard" name="applyCard" placeholder="请输入您的身份证号码" maxlength="18"/>
				</div>
				<div class="information clearfix">
					<label>联系方式</label>
					<input type="text" id="moblie" name="moblie" maxlength="11" placeholder="请输入您的联系方式"/>
				</div>
				<div class="information clearfix">
					<label>个人简介</label>
					<textarea name="personProfile" id="personProfile"  maxlength="1000" placeholder="请输入您的个人简介,最多1000字"></textarea>
				</div>
				<div id="webUpload" class="clearfix">
					<div id="container">
						<img id="selectfiles" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201813181606eRHL6i84mkpxwprkN4sIwy71iD7h7.jpg" />
					</div>
					<div id="ossfile" class="clearfix"></div>
	
				</div>
			
			<p style="font-size: 14px;margin-top: 25px;color: #999999;">可上传9张图片，格式为jpg，jpeg，png，gif，大小不超过2M</p>
				<div class="btnWrap"><span class="fqBtn"><i>放弃</i></span><span onclick="applyRecruit()"><i>提交</i></span></div>
				<p class="warn">如果你对加入本社团感兴趣，请提交相关信息，我们的工作人员会尽快与你联系</p>
			</div>
		</form>
	</div>
<div class="footer">
	<%@include file="/WEB-INF/why/index/footer.jsp" %>
</div>
</body>
</html>