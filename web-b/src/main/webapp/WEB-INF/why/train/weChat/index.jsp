<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%
	String path = request.getContextPath();
	request.setAttribute("path", path);
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	request.setAttribute("basePath", basePath);
%>
<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>万人培训-首页</title>
<meta name="viewport"  content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
<link rel="stylesheet" type="text/css"href="${path}/STATIC/train/weChat/css/mobiscroll.custom-2.4.4.min.css">
<link rel="stylesheet" type="text/css"href="${path}/STATIC/train/weChat/css/css.css">
<link rel="stylesheet" type="text/css" href="${path}/STATIC/train/weChat/css/ui-dialog.css"/>
<script type="text/javascript"src="${path}/STATIC/train/weChat/js/jquery-min.js"></script>
<script type="text/javascript"src="${path}/STATIC/train/weChat/js/common.js"></script>
<script type="text/javascript"src="${path}/STATIC/train/weChat/js/mobiscroll.custom-2.17.0.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
<!--移动端版本兼容 -->
<script type="text/javascript">
	var phoneWidth =  parseInt(window.screen.width);
	var phoneScale = phoneWidth/750;
	var ua = navigator.userAgent;            //浏览器类型
	if (/Android (\d+\.\d+)/.test(ua)){      //判断是否是安卓系统
		var version = parseFloat(RegExp.$1); //安卓系统的版本号
		if(version>2.3){
			document.write('<meta name="viewport" content="width=750, minimum-scale = '+phoneScale+', maximum-scale = '+phoneScale+', target-densitydpi=device-dpi">');
		}else{
			document.write('<meta name="viewport" content="width=750, target-densitydpi=device-dpi">');
		}
	} else {
		document.write('<meta name="viewport" content="width=750, user-scalable=no, target-densitydpi=device-dpi">');
	}
</script>
<!--移动端版本兼容 end -->
<script type="text/javascript">
 $(function(){
	   $("#c_real").blur(function(){
			 var txt_val=($(this).val()).trim();
			if(txt_val==""){
				   $("#c_real").css("border","1px solid #ff0000");
				}else{
					//$(this).val(this.defaultValue);
					$("#c_real").css("border","1px solid #cccccc");
					$("#"+$(this).attr("id")+"Error").text("").css("display","none");
				}
	      });
	   $("#c_mobile").blur(function(){
			 var txt_val=($(this).val()).trim();
			 if(txt_val==""){
				   $(this).attr("placeholder","请输入手机号");
				   $("#c_mobile").css("border","1px solid #ff0000");
				}else if(txt_val!=""){
				    if(!/^(((13[0-9]{1})|(14[0-9]{1})|(15[0-9]{1})|(17[0-9]{1})|(18[0-9]{1}))+\d{8})$/.test(txt_val)){
                     $("#c_mobile").css("border","1px solid #ff0000");
                     $("#"+$(this).attr("id")+"Error").text("请正确填写手机号").css("display","inline-block");   
				    }else{
						$.post("${path}/train/checkPhoneNumExsits.do", {userMobileNo:txt_val}, function(data) {
			                if (data=='exists') {
			                	$("#c_mobile").css("border","1px solid #ff0000");
			                	$("#"+$(this).attr("id")+"Error").text("该手机号已存在").css("display","inline-block");
			                } else {
			                    $("#c_mobile").css("border","1px solid #cccccc");
			                    $("#"+$(this).attr("id")+"Error").text("").css("display","none");  
			                }
					});
				    }
				}
			})
			//电子邮件
	    $("#c_email").blur(function(){
			 var txt_val=($(this).val()).trim();
			 if(txt_val.trim()==""){
				   $(this).attr("placeholder","请输入电子邮件");
				   $("#c_email").css("border","1px solid #ff0000");
				}else if(txt_val!=""){
				    if(!/^([\.a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(\.[a-zA-Z0-9_-])+/.test(txt_val)){
                       $("#c_email").css("border","1px solid #ffffff");
                       $("#"+$(this).attr("id")+"Error").text("请正确填写电子邮件").css("display","inline-block");   
				    }else{
				       $("#c_email").css("border","1px solid #ffffff");
				       $("#"+$(this).attr("id")+"Error").text("").css("display","none");  
				    }
				}
			})
				$("#c_ID").blur(function(){
			 var txt_val=($(this).val()).trim();
			 if(txt_val==""){
				   $(this).attr("placeholder","请输入身份证号码");
				   $("#c_ID").css("border","1px solid #ff0000");
				}else if(txt_val!=""){
				    if(!/(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/.test(txt_val)){
                       $("#c_ID").css("border","1px solid #ff0000");
                       $("#"+$(this).attr("id")+"Error").text("请正确填写身份证号").css("display","inline-block");   
				    }else{
				    	$.post("${path}/train/checkIDExsits.do", {IDNumber:txt_val}, function(data) {
			                if (data=='exists') {
			                	$("#c_ID").css("border","1px solid #ff0000");
			                	 $("#c_IDError").text("该身份证已存在").css("display","inline-block");
			                } else {
			                    $("#c_ID").css("border","1px solid #cccccc");
			                    $("#c_IDError").text("").css("display","none");  
			                }
			            });
				    }
				}
			})
				$("#c_code").blur(function(){
			
			 var txt_val=($(this).val()).trim();
			   if($(this).hasClass("hadVal")){
			       if(txt_val==""){
					   $("#c_code").css("border","1px solid #cccccc");
					}else{
						$("#c_code").css("border","1px solid #cccccc");
					}  
			   }else{
				 if(txt_val==""){
					   $(this).attr("placeholder","请输入报名识别码");
					   $("#c_code").css("border","1px solid #ff0000");
					}else{
						$("#c_code").css("border","1px solid #cccccc");
						$("#"+$(this).attr("id")+"Error").text("").css("display","none");
					}
			   }
			})
}) 
   function formSub(){
		var mobile = ($("#c_mobile").val()).trim();
		if(mobile==''){
			$("#c_mobile").css("border","1px solid #ff0000");
			$("#c_mobileError").text("请输入手机号").css("display","inline-block");
			return false;
		}else if(!/^(((13[0-9]{1})|(14[0-9]{1})|(15[0-9]{1})|(17[0-9]{1})|(18[0-9]{1}))+\d{8})$/.test(mobile)){
			$("#c_mobile").css("border","1px solid #ff0000");
			$("#c_mobileError").text("请正确填写手机号").css("display","inline-block");
			return false;
		}else if($("#c_mobileError").text()=='该手机号已存在'){
			return false;
		}
		//真实姓名
		var rn = ($("#c_real").val()).trim();
		if(rn==''){
			$("#c_real").css("border","1px solid #ff0000");
			return false;
		}
		//邮箱
		var e = ($("#c_email").val()).trim();
		if(e==''){
			$("#c_email").css("border","1px solid #ff0000");
			return false;
		}else if(!/^([\.a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(\.[a-zA-Z0-9_-])+/.test(e)){
			//alert("请正确填写电子邮件");
			$("#c_email").css("border","1px solid #ff0000");
			$("#c_emailError").text("请正确填写电子邮件").css("display","inline-block");
			return false;
		}
		//身份证号码
		var ID = ($("#c_ID").val()).trim();
		if(!($("#c_ID").prop("disabled"))){
			if(ID==''){
				$("#c_ID").css("border","1px solid #ff0000");
				return false;
			}else if(!/(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/.test(ID)){
				$("#c_ID").css("border","1px solid #ff0000");
				$("#c_IDError").text("请正确填写身份证号").css("display","inline-block");
				return false;
			}else if($("#c_IDError").text()=='该身份证已存在'){
				return false;
			}
		}
		//
		if(($("#areaId").val()).trim()==''){
		     $("#areaId").parents("li").css("border","1px solid #ff0000");
			return false;
		}else{
			  $("#areaId").parents("li").css("border","1px solid #ffffff");
		}
		
		if($("#c_unit").val().trim()==''){
			$("#c_unit").css("border","1px solid #ff0000");
			return false;
		}else{
			$("#c_unit").css("border","1px solid #ffffff");
		}
		
		if(($("#positionId").val()).trim() ==''){
			$("#positionId").parents("li").css("border","1px solid #ff0000");
			return false;
		}else{
			  $("#positionId").parents("li").css("border","1px solid #ffffff");
		}
		
		if(($("#titleId").val()).trim()==''){
			$("#titleId").parents("li").css("border","1px solid #ff0000");
			return false;
		}else{
			  $("#titleId").parents("li").css("border","1px solid #ffffff");
		}
		
		if(($("#fieldId").val()).trim()==''){
			$("#fieldId").parents("li").css("border","1px solid #ff0000");
			return false;
		}else{
			  $("#fieldId").parents("li").css("border","1px solid #ffffff");
		}
		if(!($("#c_code").prop("disabled"))){
			if(($("#c_code").val()).trim()==''){
				$("#c_code").parents("li").css("border","1px solid #ff0000");
				return false;
			}else{
				  $("#c_code").parents("li").css("border","1px solid #ffffff");
			}
		}
		//提交等待 
      $.post("${path}/millionPeople/savePersonalInfo.do", $("#vform").serialize(), function(data) {
            var map = eval(data);
            if (map.success=='Y') {
            	$("#btn-tip-loading").remove();
                location.href="${path}/millionPeople/toOrder.do";
            } else {
                dialogAlert("提示", map.msg);
                $("#btn-tip-loading").remove();
                $("#subOrder").show();
            }
        }); 
   }
</script>
</head>
<body>
	<div class="header">
		<a href="javascript:history.go(-1);" class="pre"></a> <span>文化云 </span><a class="center" href="${path}/millionPeople/queryCourseOrder.do">个人中心</a>
	</div>
	<div class="content">
		<div class="millonImg">
			<img src="${path}/STATIC/train/weChat/images/banenr.jpg">
			<p class="personal">填写个人信息</p>
		</div>
		 <form action="${path}/millionPeople/savePersonalInfo.do" id="vform" method="post">
		 <input type="hidden" name="userId" value="${user.userId}" />
		<div class="formList writelist">
			<ul class="clearfix">
				<li class="boxSize">
				   <input type="text" readOnly value="${user.userName}" placeholder="姓名" data-pass="false"> 
				   <span class="type"></span>
				</li>
				<li class="boxSize" value="0"><input type="text" class="val"
					<c:if test="${user.userSex==1 }">value="男"</c:if>
					<c:if test="${user.userSex==2 }">value="女"</c:if>
					<c:if test="${ empty user.userSex or user.userSex==''}">value="保密"</c:if> readonly
					placeholder="性别"> <span class="type"></span>
				</li>
				<li class="option errortip" id="c_realError"></li>
				<li class="boxSize"><input type="text" id="c_real"
					name="realName"
					<c:if test="${not empty trainUser and not empty trainUser.realName}">value="${trainUser.realName }"  </c:if>
					<c:if test="${empty trainUser or empty trainUser.realName}">placeholder="请输入真实姓名"</c:if>
					data-pass="false" class="textMess"> <span class="type"></span>
				</li>
				<li class="option errortip" id="c_mobileError"></li>
				<li class="boxSize"><input type="text" id="c_mobile"
					name="userMobileNo" placeholder="手机号码" data-pass="false"
					<c:if test="${not empty user and not empty user.userMobileNo}">value="${user.userMobileNo }" disabled  </c:if>
					<c:if test="${empty user or empty user.userMobileNo}"> placeholder="请输入手机号"</c:if>
					class="textMess"> <span class="type"></span>
				</li>
				<li class="option errortip" id="c_emailError"></li>
				<li class="boxSize"><input type="text" id="c_email"
					name="userEmail"
					<c:if test="${not empty trainUser and not empty trainUser.userEmail}">value="${trainUser.userEmail }" </c:if>
					<c:if test="${empty trainUser or empty trainUser.userEmail}"> placeholder="请输入邮箱"</c:if>>
					<span class="type"></span>
				</li>
				<li class="option errortip" id="c_IDError"></li>
				<li class="boxSize"><c:if
						test="${not empty trainUser and not empty trainUser.idNumber}">
						<input type="text" id="c_ID" name="idNumber"  disabled	value="${trainUser.idNumber}"  data-pass="false"
							class="textMess" />
					</c:if> <c:if test="${empty trainUser or empty trainUser.idNumber}">
						<input id="c_ID" type="text" name="idNumber"
							placeholder="请输入身份证号码" data-pass="false" class="textMess" />
					</c:if> <span class="type"></span>
				</li>
				<li class="option errortip" id="areaIdError"></li>
				<li class="boxSize" value="1">
					<p class="coverTxt">所在单位区县</p> <input type="hidden" id="areaId" class="val" name="unitArea"
				 value="${trainUser.unitArea}"	readonly placeholder=""> 
					 <c:choose>
					        	<c:when test="${not empty trainUser and not empty trainUser.unitArea}">
					        	<script type="text/javascript">
					          		$(function(){
					          			var txt=$("#areaId").val();
					          			$("#areaId").siblings('.selectOption').find("option[value='"+txt+"']").prop('selected',true);
					          			$("#areaId").siblings(".coverTxt").hide();
					          			
					          		})
					          	</script>
					        	</c:when>
					        </c:choose>
					<select class="selectOption">
						     <option   value="46">黄浦区</option>
                             <option   value="48">徐汇区</option>
                             <option   value="49">长宁区</option>
                             <option   value="50">静安区</option>
                             <option   value="51">普陀区</option>
                             <option   value="53">虹口区</option>
                             <option   value="54">杨浦区</option>
                             <option   value="55">闵行区</option>
                             <option   value="56">宝山区</option>
                             <option   value="57">嘉定区</option>
                             <option   value="58">浦东新区</option>
                             <option   value="59">金山区</option>
                             <option   value="60">松江区</option>
                             <option   value="61">青浦区</option>
                             <option   value="63">奉贤区</option>
                             <option   value="64">崇明县</option>
				</select> <span class="button"></span>
				</li>
				<li class="option errortip" id="c_unitError"></li>
				<li class="boxSize"><input placeholder="所在单位名称" maxlength="30"
					type="text" id="c_unit" name="unitName"
					<c:if test="${not empty trainUser and not empty trainUser.unitName}">value="${trainUser.unitName }" </c:if>
					<c:if test="${empty trainUser or empty trainUser.unitName}">  placeholder="请输入您所在单位名称"</c:if>
					data-pass="false" class="textMess"> <span class="type"></span>
				</li>
				<li class="option errortip" id="positionIdError"></li>
				<li class="option errortip" id="titleIdError"></li>
				<li class="half boxSize job " value="2">
					<p class="coverTxt">职务</p> <input type="hidden" class="val" name="jobPosition"
				value="${trainUser.jobPosition}"	readonly placeholder="" id="positionId">
				  <c:choose>
					        	<c:when test="${not empty trainUser and not empty trainUser.jobPosition}">
					        	<script type="text/javascript">
					        	$(function(){
				          			var txt=$("#positionId").val();
				          			$("#positionId").siblings('.selectOption').find("option[value='"+txt+"']").prop('selected',true);
				          			$("#positionId").siblings(".coverTxt").hide();
				          			
				          		})
					          	</script>
					        	</c:when>
					        </c:choose>
				 <select class="selectOption">
				           <c:forEach items="${jobs}" var="job" varStatus="i">
                             <option id="${job.dictId}" value="${job.dictId}">${job.dictName}</option>
                           </c:forEach>
				</select>
				 <span class="button"></span>
				</li>
				<li class="half boxSize " value="3">
					<p class="coverTxt">职称</p> <input type="hidden" class="val" name="jobTitle"
					value="${trainUser.jobTitle}" readonly placeholder="" id="titleId">
					<c:choose>
					        	<c:when test="${not empty trainUser and not empty trainUser.jobTitle}">
					        	<script type="text/javascript">
					        	$(function(){
				          			var txt=$("#titleId").val();
				          			$("#titleId").siblings('.selectOption').find("option[value='"+txt+"']").prop('selected',true);
				          			$("#titleId").siblings(".coverTxt").hide();
				          			
				          		})
					          	</script>
					        	</c:when>
					        </c:choose>
			    <select class="selectOption">
						<c:forEach items="${titles}" var="title" varStatus="i">
                             <option id="${title.dictId}" value="${title.dictId}">${title.dictName}</option>
                            </c:forEach>
				</select> <span class="button"></span>
				</li>
				<li class="option errortip" id="fieldIdError"></li>
				<li class="boxSize" value="4">
					<p class="coverTxt">从事领域</p> <input type="hidden" class="val" name="engagedField"
					value="${trainUser.engagedField}" readonly placeholder="" id="fieldId">
					<c:choose>
					        	<c:when test="${not empty trainUser and not empty trainUser.engagedField}">
					        	<script type="text/javascript">
					        	$(function(){
				          			var txt=$("#fieldId").val();
				          			$("#fieldId").siblings('.selectOption').find("option[value='"+txt+"']").prop('selected',true);
				          			$("#fieldId").siblings(".coverTxt").hide();
				          			
				          		})
					          	</script>
					        	</c:when>
					        </c:choose>
					 <select class="selectOption">
					<c:forEach items="${fields}" var="field" varStatus="i">
                             <option id="${field.dictId}" value="${field.dictId}">${field.dictName }</option>
                     </c:forEach>
				</select> <span class="button"></span>
				</li>
				<li class="option errortip" id="c_numberError"></li>
				<li class="boxSize"><input type="text" id="c_number"
					name="ertificateNumber"
					<c:if test="${not empty trainUser and not empty trainUser.ertificateNumber}">value="${trainUser.ertificateNumber }"</c:if>
					<c:if test="${empty trainUser or empty trainUser.ertificateNumber}"> placeholder="新一轮培训证书编号" </c:if>
					data-pass="false" class="textMess"> <span class="type"></span>
				</li>
				<li class="option errortip" id="c_codeError"></li>
				<li class="boxSize"><input type="text" name="verificationCode"
					<c:if test="${not empty trainUser and not empty trainUser.verificationCode}">value="${trainUser.verificationCode}"  disabled</c:if>
					<c:if test="${empty trainUser or empty trainUser.verificationCode}">  placeholder="请输入报名识别码"</c:if> id="c_code"
					data-pass="false" class="textMess"> 
					<span class="type"></span>
				</li>
			</ul>
			<p class="tip">【请联系所在单位办公室或区县文广局索取报名识别码】</p>
			<p style="color:#ff0000; font-size:24px; padding:10px 0 0 50px; line-height:40px; ">*只针对上海市公共文化从业人员</p>
			<div type="button" class="submitS1" >
				<span onclick="return formSub();">提交</span>
			</div>
			 </form>
		</div>
	<script>
$(function () {
	$('.selectOption').each(function(index, element) {
         $(this).mobiscroll().select({
			theme: 'mobiscroll',
			lang: 'zh',
			display: 'bottom',
			multiline: 3,
			height: 86,
			setText: '确定',
			cancelText: '取消',
			onSelect: function (v, inst) {
					  $(this).closest('li').find('input').val(v);
				     $(this).siblings(".coverTxt").hide();
				     $(this).closest('li').find('input').css("color","#333");
				     $(this).closest('li').find('input.val').val(inst._tempValue);	
			}
       });
    });
    $('span.button,p.coverTxt').click(function () {
        $(this).siblings('.selectOption').mobiscroll('show');
        return false;
    });
});
</script>
	<script>
      $(".textMess").blur(function(){
		    var txt=$(this).val();
			var pass=$(this).attr('data-pass');
			if(txt!==''){
				  $(this).attr('data-pass','true');
				  if(pass){
				      $(this).siblings('span').addClass('typeRight');
					  $(this).css("color","#333");
				   }
				}else{
				  $(this).attr('data-pass','false');
				  $(this).siblings('span').removeClass('typeRight');	
					} 
		  })
		$(".button").click(function(){
			  
			})
  </script>
</body>
</html>






























































































