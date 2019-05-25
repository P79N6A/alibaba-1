<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
	<meta charset="UTF-8">
	<title>第一步</title>
	<link rel="stylesheet" type="text/css" href="${path }/STATIC/css/cnwd/reset.css">
	<link rel="stylesheet" type="text/css" href="${path }/STATIC/css/cnwd/dance.css">
	<link rel="Stylesheet" type="text/css" href="${path }/STATIC/css/cnwd/DialogBySHF.css" />
	<script type="text/javascript" src="${path }/STATIC/js/cnwd/DialogBySHF.js"></script>
</head>
<body>
	<%@include file="/WEB-INF/why/index/cnwd/header.jsp"%>

	<p class="crumbs">我的位置：2017年舞蹈大赛</p>


	<ul class="steps">
		<li class="cur">填写团队基本信息</li>
		<hr class="hrone">
		<li class="">上传参赛视频</li>
		<hr class="hrtwo">
		<li class="">提交成功</li>
	</ul>
<form action=" " id="registerForm" method="post">
	<div class="content_wrap">
		<div class="section clear">
			<div class="information clear">
				<span class="name">机构/单位名称</span>
				<input type="text" id="agencyName" data-type="notnull" value="${cnwdEntryForm.agencyName }" data-msg="机构/单位名称必填" name="agencyName" class="text_one">
			</div>
			<input type="hidden" id="entryId" name="entryId" value="${cnwdEntryForm.entryId }">
			<div class="information clear">
				<span class="name">机构类型</span>
				<label for="one">
					<span class="button">企业</span>
					<input type="radio"   id="one"  name="agencyType" value="企业" class="box">
				</label>
				<label for="two">
					<span class="button">事业单位</span>
					<input type="radio" name="agencyType" id="two" value="事业单位" class=" box big_w">
				</label>
				<label for="three">
					<span class="button">民非组织</span>
					<input type="radio" name="agencyType" id="three" value="民非组织" class=" box big_w">
				</label>
				<label for="four">
					<span class="button">院校</span>
					<input type="radio"  name="agencyType" id="four"  value="院校" class="box">
				</label>
				<label for="five">
					<span class="button">社团</span>
					<input type="radio" name="agencyType"  id="five"  value="社团" class="box">
				</label>
				<br>
			   <label for="six" class="mar_left">
					<span class="button">其他</span>
					<input type="radio" name="agencyType" id="six"  class="box">
				</label>
				<input type="text" id="qita" placeholder="请填写具体类型" class="detail_type mar_top">
			</div>
			<div class="information clear">
				<span class="name">团队名称</span>
				<input type="text" id="teamName" data-type="notnull" value="${cnwdEntryForm.teamName }" data-msg="团队名称必填" name="teamName" class="text_one"></input>
			</div>
			<div class="information clear">
				<span class="name">成立时间</span>
				<input type="text" id="dateOfEstablishment" value="${cnwdEntryForm.dateOfEstablishment }"  data-type="notnull" data-msg="成立时间必填" name="dateOfEstablishment" class="text_one"></input>
			</div>
			<div class="information clear">
				<span class="name">成员人数</span>
				<input type="text" id="memberNumber" value="${cnwdEntryForm.memberNumber }" data-type="notnull" data-msg="成员人数必填" name="memberNumber" class="text_two"  onkeyup="this.value=this.value.replace(/[^\d]/g,'')"></input>
				<span class="name" style="margin-left: 115px;">平均年龄</span>
				<input type="text" id="avgAge" value="${cnwdEntryForm.avgAge }" name="avgAge" data-type="notnull" data-msg="平均年龄必填" class="text_two"  onkeyup="this.value=this.value.replace(/[^\d]/g,'')"></input>
			</div>
			<div class="information clear">
				<span class="name">领队姓名</span>
				<input type="text" id="leaderName" value="${cnwdEntryForm.leaderName }"  data-type="notnull" data-msg="领队姓名必填" name="leaderName" class="text_two"></input>
				<span class="name" style="width:128px;margin-left: 95px;">联系方式（手机）</span>
				<input type="text" id="telephone" value="${cnwdEntryForm.telephone }" data-type="notnull" maxlength="11" data-msg="联系方式必填" name="telephone" class="text_two"></input>
			</div>
			<div class="information clear">
				<span class="name">电子邮箱</span>
				<input type="text" id="email" value="${cnwdEntryForm.email }" data-type="notnull" data-msg="电子邮箱必填" name="email" class="text_two"></input>
				<span class="name" style="margin-left: 115px;">传真电话</span>
				<input type="text" id="faxaphone" value="${cnwdEntryForm.faxaphone }" data-type="notnull" data-msg="传真电话必填" name="faxaphone" class="text_two"></input>
			</div>
			<div class="information clear">
				<span class="name">联系地址</span>
				<input type="text" id="address"  value="${cnwdEntryForm.address }" data-type="notnull" data-msg="联系地址必填" name="address" class="text_one"></input>
			</div>
			<div class="information clear">
				<span class="name">团队简介</span>
				<textarea id="teamProfile" name="teamProfile" class="team_info" placeholder="特色、经历、获得荣誉、感人故事等">${cnwdEntryForm.teamProfile }</textarea>
			</div>
			<a href="#" id="btn" class="btn btn_bgone btn_next">下一步</a>
		</div>
	</div>
</form>
<%@include file="/WEB-INF/why/index/cnwd/footer.jsp"%>
</body>
</html>
<script type="text/javascript">
    var entryId = $("#entryId").val();
     var agencyType ='${cnwdEntryForm.agencyType}';
    $(function(){
    	if(agencyType){
    		$("input:radio[name='agencyType']").each(function() {
        		var checkedAgencyType = $(this).val();
        		if(agencyType==checkedAgencyType){
        			$(this).attr("checked","checked");
        			$(this).siblings("span.button").addClass("cur");
        		}
    		});
    		if($(":radio[name=agencyType]:checked").size() == 0){
    			$("#six").attr("checked","checked");
    			$("#six").siblings("span.button").addClass("cur");
    			$("#qita").val(agencyType);
    			$(".detail_type").show();
    		}
    	}
    }) 
    
	
    /*按钮样式的改变*/
	$(".box").change(function(){
		$(this).is(':checked');
		if($(this).is(':checked') == true){
			 $(this).siblings("span.button").addClass("cur").parent().siblings().children("span.button").removeClass("cur");
			 $(this).attr("checked","checked").parent().siblings().find(".box").removeAttr('checked');
			 
		}else{
			$(this).siblings("span.button").removeClass("cur");
			$(this).removeAttr('checked')
		}
		if ($(this).attr('id') == 'six') {
			 $(".detail_type").show().focus();

			}else if ($(this).is(':checked') == true ) {
				$(".detail_type").hide();
				$("#qita").val('');
			}else{
				$(".detail_type").hide();
				$("#qita").val("");
			}
		console.log($(this).is(':checked'));
		console.log($(this).attr('id'));
	});
    
    
    //提交
    $("#btn").click(function(){
    	var qita = $("#qita").val();
    	if(!validate()){
    		return;
    	}
    	if(qita){
    		$("#six").attr("value",qita);
    	}
    	$.post("${path}/cnwdEntry/registerOneSave.do",$("#registerForm").serialize(),function(data){
    		//alert(data.msg)
    		if(data.msg=="ok"){
    			window.location.href="${path}/cnwdEntry/registerTwo.do?entryId="+entryId;
    		}
    	})
    })
    
    //校验
    function validate(){
	var isOk=true;
	
	$(".content_wrap").find('input').each(function (index,item) {
		console.log($(item));
		if($(item).attr("data-type")=='notnull'){
			var value=$(item).val();
			if(value== undefined ||value=='' || value.length==0){
				$.DialogBySHF.Alert({ Width: 590, Height: 332, Content: $(item).attr("data-msg") });
				isOk=false;
				return false;
			}
		}
		// 邮箱验证
		var userEmail = $("#email").val();
		if(!/^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+/.test(userEmail) && userEmail){
			$.DialogBySHF.Alert({ Width: 590, Height: 332, Content: '请输入正确的邮箱' });
			isOk=false;
			return false;
		} 
		
		//手机号验证
		var phoneNo=$("#telephone").val();
		if(!/^1[3|4|5|7|8][0-9]{9}$/.test(phoneNo) && phoneNo){
			$.DialogBySHF.Alert({ Width: 590, Height: 332, Content: '请输入正确的手机号！' });
			isOk=false;
			return false;
		 }
	
		   if($(":radio[name=agencyType]:checked").size() == 0){
			  $.DialogBySHF.Alert({ Width: 590, Height: 332, Content: '请选择机构类型！' });
				isOk = false;
				return false;
		} 
		 if($("#six").is(':checked')){
			var qita=$("#qita").val();
			if(!qita){
				$.DialogBySHF.Alert({ Width: 590, Height: 332, Content: '请填写其他机构类型！' });
				isOk = false;
				return false;
			}
		}    
		
		var teamProfile=$("#teamProfile").val();
		if(!teamProfile){
			$.DialogBySHF.Alert({ Width: 590, Height: 332, Content: '请填写团队简介！' });
			isOk = false;
			return false;
		}
	});
	
	
	
	return isOk;
}
function test() {
   
}
</script>