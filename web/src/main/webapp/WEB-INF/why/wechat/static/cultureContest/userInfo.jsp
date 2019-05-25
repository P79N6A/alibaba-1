<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>中华优秀传统文化知识大赛</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css?v=20170511"/>
	<script src="${path}/STATIC/js/common.js"></script>
<style type="text/css">
html,body {height: 100%;}
</style>
 <script type="text/javascript">
 

 if (userId == null || userId == '') {
		//判断登陆
	 publicLogin('${basePath}wechatStatic/cultureContestIndex.do');
}
 
 $(function() {
	 
	 if(window.screen.width > 750){
		 	//PC
		 	
		 	$("img").each(function(){
		 		
		 		
		 		var src=$(this).attr("src");
		 		
		 		src=src.replace('/tradKnow/','/tradKnowPc/')
		 		
		 		$(this).attr("src",src);
		 	});
		 }
 
	  /*设置生日*/
     var myDate = new Date();
     var myYear = myDate.getFullYear();
     var year = myDate.getFullYear();
     var $year = $(".information .year");
     var $month = $(".information .month");
     var $day = $(".information .day");
     var $group = $(".information .group");
     for (var i = 0; i < 100; i++) {
         $year.append('<option value="'+myYear+'">'+myYear--+'</option>');
     }
     for (var i = 1; i < 13; i++) {
         $month.append('<option value="'+i+'">'+i+'</option>');
     }
     for (var i = 1; i < 32; i++) {
         $day.append('<option value="'+i+'">'+i+'</option>');
     }

     /*判断是什么组别*/
     $year.change(function(){
         var personalYear = parseInt($(this).find("option:selected").val());
         var currentYear = parseInt(year);
         var age = currentYear - personalYear;
         if (age<=14) {
             $group.html('<option selected="selected" value="1">少年组</option>');
         }else if (age>=15&&age<=55) {
             $group.html('<option selected="selected" value="2">中青年组</option>');
         }else{
             $group.html('<option selected="selected" value="3">老年组</option>');
         }  
     });
 });
 
 function submitInfo(){
	 
		var userRealName=$("#userRealName").val();
		var userTelephone=$("#userTelephone").val();
		
		if(!userRealName){
			dialogAlert('系统提示', '姓名不能为空！');
			return;
		}
		
		var telReg = (/^1[34578]\d{9}$/);
		
		if(userTelephone == ""){
	    	dialogAlert('系统提示', '手机号码不能为空！');
	        return false;
	    }else if(!userTelephone.match(telReg)){
	    	dialogAlert('系统提示', '请正确填写手机号码！');
	        return false;
	    }
		
		var year=parseInt($("#year").val());
		var month=parseInt($("#month").val());
		var day=parseInt($("#day").val());
		var userArea=$("#userArea").val();
		
		if(!userArea){
			dialogAlert('系统提示', '请选择区域！');
	        return false;
		}
		
		
		if(!year){
			dialogAlert('系统提示', '请选择出生年！');
	        return false;
		}
		
		if(!month){
			dialogAlert('系统提示', '请选择出生月！');
	        return false;
		}

		if(!day){
			dialogAlert('系统提示', '请选择出生日！');
	        return false;
		}
		
	 	var form=$('#userForm');
	 
		var formData= form.serializeArray();
		
		formData.push({'name':'userId','value':userId});
		
		formData.push({'name':'birthday','value':year+"-"+month+"-"+day});
		
		var userGroupType= $("#userGroupType").val();
		
		formData.push({'name':'userGroupType','value':userGroupType});
		
		$.post("${path}/cultureContest/saveUserInfo.do",formData, function(data) {
			
			var result=data.result;
			
			if(result=='success'){
				
				dialogSaveDraft('提示', '保存成功,恭喜你获得500积分！',function(){
					
					var stageNumber=$("#stageNumber").val();
					
					window.location.href='${basePath}wechatStatic/cultureContestEnter.do?userId='+userId+"&stageNumber="+stageNumber;
				});
				
			}else{
				dialogAlert('提示', '保存失败，系统繁忙');
			}
		},'json');
 }
 
 function dialogSaveDraft(title, content, fn){
	    var d = dialog({
	        width:400,
	        title:title,
	        content:content,
	        fixed: true,
	        okValue: '确 定',
	        ok: function () {
	            if(fn)  fn();
	        }
	    });
	    d.showModal();
	}
 </script>

</head>

<body>
	<input type="hidden" value="${stageNumber }" id="stageNumber" name="stageNumber"/>
 <div class="tradKnowWap">
        <div class="head"></div>
         <%@include file="head.jsp"%>
        <div class="section">
            <div class="charwen">
                <img src="${path}/STATIC/wxStatic/image/tradKnow/char3.png">
            </div>
            <!-- 活动规则 -->
            <a href="${path }/wechatStatic/cultureContestRule.do"><img src="${path}/STATIC/wxStatic/image/tradKnow/icon7.png" class="role"></a>

            <form id="userForm" class="fill clearfix">
                <div class="information clearfix">
                    <i>姓名</i>
                    <input type="text" id="userRealName" name="userRealName">
                </div>
                <div class="information clearfix">
                    <i>手机</i>
                    <input type="text" id="userTelephone" name="userTelephone" maxlength="11">
                </div>
                <div class="information clearfix">
                    <i>性别</i>
                    <select id="userSex" name="userSex">
                        <option value="2">女</option>
                        <option value="1">男</option>
                    </select>
                </div>
                 
                <div class="information clearfix">
                    <i>生日</i>
                    <select class="year pl20" id="year" name="year">
                        <option>年份</option>
                    </select>
                    <select class="month" id="month" name="month">
                        <option>月</option>
                    </select>
                    <select class="day" id="day" name="day">
                        <option>日</option>
                    </select>
                </div>
                <div class="information clearfix">
                    <i>区域</i>
                    <select id="userArea" name="userArea" class="w200">
                    	 <option value="">请选择</option>
                        <option value="黄浦">黄浦</option>
                        <option value="徐汇">徐汇</option>
                        <option value="长宁">长宁</option>
                        <option value="静安">静安</option>
                        
                        <option value="普陀">普陀</option>
                        <option value="虹口">虹口</option>
                        <option value="杨浦">杨浦</option>
                        <option value="闵行">闵行</option>
                        <option value="宝山">宝山</option>
                        <option value="嘉定">嘉定</option>
                        <option value="浦东">浦东</option>
                        <option value="金山">金山</option>
                        <option value="松江">松江</option>
                        <option value="青浦">青浦</option>
                        <option value="奉贤">奉贤</option>
                        <option value="崇明">崇明</option>
                        <option value="其他">其他</option>
                    </select>
                </div>
                <div class="information clearfix">
                    <i>您的参赛组别为</i>
                    <select class="group w200 pl24" id="userGroupType" name="userGroupType" disabled="disabled">
                    </select>
                </div>
                <p class="note">*您填写的信息将作为分组排行和获奖的依据，一经填写不得修改，请保证填写真实</p>
            </form>
            <div class="tradAnniu" onclick="submitInfo();">
                <img src="${path}/STATIC/wxStatic/image/tradKnow/icon8.png">
            </div>
        </div>
    </div>

</body>

</html>
