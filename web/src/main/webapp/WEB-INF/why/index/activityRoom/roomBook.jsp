<%@ page language="java" pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/style_fs.css" />	
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/jedate_book.css" />
<script type="text/javascript" src="${path}/STATIC/keyboard/vk_loader.js?vk_layout=US US&vk_skin=flat_gray" ></script>
<style>
	.amap-logo,
	.amap-copyright {
		display: none!important;
		z-index: -1;
	}
</style>

<script>
$.ajaxSettings.async = false; //同步执行ajax				
$(function() {	
    var imgUrl = $("#roomPic").attr("data-id");				
    if(imgUrl == undefined || imgUrl == null || imgUrl == ""){
    	$("#roomPic").attr("src", "${path}/STATIC/image/default.jpg");
       }else{
           imgUrl = getImgUrl(imgUrl);
           imgUrl = getIndexImgUrl(imgUrl,"_750_500")
          $("#roomPic").attr("src", imgUrl);
       }		    
 });
	
//提交
function sub(){
	var textReg = (/^[a-zA-Z0-9\u4e00-\u9fa5]+$/);		//中文，字母，数字组成正则	
	var orderName=$("#orderName").val(); 
	
	if(!orderName){
    	dialogAlert('系统提示', '请输入联系人名称！');
        return false;
    }
	if(!orderName.match(textReg)){
    	dialogAlert('提示', '名称只能由中文，字母，数字组成！');
        return false;
    }
	
	var orderTel=$("#orderTel").val(); 
	var telReg = (/^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$/);
	if(!orderTel){
    	dialogAlert('系统提示', '请输入手机号码！');
        return false;
    }else if(!orderTel.match(telReg)){
    	dialogAlert('系统提示', '请正确填写手机号码！');
        return false;
    }
	
	var purpose=$("#purpose").val();
	if(!purpose){
    	dialogAlert('系统提示', '请输入场馆用途！');
        return false;
    }
	
	var data=$("#roomOrderForm").serialize();	
	var encode = function(json) {  
              
            var tmps = [];  
            for (var key in json) {  
                tmps.push(key + '=' + json[key]);  
            }               
            return tmps.join('&');  
        }  
	
	$.ajax({
		type:"post",
		url:"${path}/wechatVenue/roomOrderConfirm.do",
		data:data,
		dataType: "json",
		success:function(data){
			if(data.status==0){ 
				 //dialogAlert("提示", "活动室预订成功!");
				 var urlData=encode(data.data)+"&userId="+$("#userId").val();
					
				 window.parent.roomBookSuccess(encodeURI(encodeURI(urlData)));
				 window.parent._SHFClose();							
			}else{
				dialogAlert('系统提示', data.data);
			}			
		}
	});
}
</script>
</head>

<body>
	<form id="roomOrderForm">		
		<input type="hidden" id="bookId" name="bookId" value="${bookId}"/>
		<input type="hidden" id="userId" name="userId" value="${sessionScope.terminalUser.userId}"/>
		<input type="hidden" id="tuserId" name="tuserId" value="${cmsTeamUser.tuserId}">		
	<div class="bookactivityroom">
			<h1>${cmsActivityRoom.roomName}</h1>
			<h2>${cmsVenue.venueName}</h2>
			<div class="roomimage">
				<img id="roomPic" data-id="${cmsActivityRoom.roomPicUrl}"  />
			</div>
			<div id="softkey" style="width:100%;position:absolute;left:100px;bottom:250px;"></div>
			<div class="roominfo">						
				<div class="roominfolist clearfix">
					<span>日&emsp;期：</span>
					<span>${dateStr} ${weekStr}</span>
				</div>
				<div class="roominfolist clearfix">
					<span>场&emsp;次：</span>
					<span>${openPeriod}</span>
				</div>
				<div class="roominfolist clearfix">
					<span>使用者：</span>
					<span>${cmsTeamUser.tuserName }</span>
				</div>
			</div>
			<form action="">
				<div class="playroominfo clearfix">
					<span>预订联系人：</span>
					<input type="text" id="orderName" name="orderName" placeholder="请填写预定联系人" value="${cmsTerminalUser.userNickName}"/>
				</div>
				<div class="playroominfo clearfix">
					<span>联系人手机：</span>
					<input type="text" id="orderTel" name="orderTel" maxlength="11"  placeholder="请填写预定人手机" value="${userTelephone}"/>
				</div>
				<div class="playroominfo clearfix">
					<span>预订用途：</span>
					<textarea class="fs30" id="purpose" name="purpose" style="resize: none;float: left;padding: 12px 0;border: 0;width: 202px;height:100px;color: #666;font-size: 14px;" placeholder="请填写活动室使用用途"></textarea>
				</div>
				 <!--  <div class="playroominfo clearfix" style="background:none">
					<span>备注：</span>
					<input type="text" placeholder="请控制数字在20字以内" maxlength="20" />
				</div> -->
				<p class="bookwarn">提示：*为必填项</p>
			</form>
			<div class="complete clearfix" style="padding-top: 20px;text-align: center;">
				<div style="width: 120px;margin: auto;" class="totalBtn" onclick="sub()">提交</div>
			</div>			
		</div>
</form>
</body>
</html>

