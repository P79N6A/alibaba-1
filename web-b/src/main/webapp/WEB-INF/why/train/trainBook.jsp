<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
    request.setAttribute("basePath", basePath);
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>填报个人信息</title>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/train/css/reset-index.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/train/css/culture.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/train/css/trains.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/ui-dialog.css"/><style>	
	.register-content  #btn-tip-loading{ float:left;margin-left:80px; background:url('${path}/STATIC/train/image/register-icongray.png') no-repeat center center; border-radius:5px; -webkit-border-radius:5px;-moz-border-radius:5px;}
	#btn-tip-loading h3{ color:#ffffff;}
	#submit_second{ width:680px; height:44px; margin:0 auto;}
	#submit_second input{float:left;}
</style>
<script type="text/javascript" src="${path}/STATIC/train/js/jquery.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/train/js/train_index.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
<script type="text/javascript">
     $(function(){
        //真实姓名
 
        $("#c_real").focus(function(){
		var txt_val=$(this).val();
		if(txt_val=="请输入真实姓名"){
			   $(this).val("");
			}
		});

     	$("#c_real").blur(function(){
		 var txt_val=($(this).val()).trim();
		 if(txt_val=="" || txt_val=="请输入真实姓名"){
			   $(this).val("请输入真实姓名");
			   $("#c_real").css("border","1px solid #ff0000");
			   $("#c_real").siblings("i").css("display","inline-block");
			}else{
				//$(this).val(this.defaultValue);
				$("#c_real").css("border","1px solid #cccccc");
			    $("#c_real").siblings("i").text("").css("display","none");
			}
		})
		
		$("#c_mobile").focus(function(){
		var txt_val=($(this).val()).trim();
		if(txt_val=="请输入手机号"){
			   $(this).val("");
			}
		});

     	$("#c_mobile").blur(function(){
			 var txt_val=($(this).val()).trim();
			 if(txt_val==""){
				   $(this).val("请输入手机号");
				   $("#c_mobile").css("border","1px solid #ff0000");
				}else if(txt_val!="请输入手机号"){
				    if(!/^(((13[0-9]{1})|(14[0-9]{1})|(15[0-9]{1})|(17[0-9]{1})|(18[0-9]{1}))+\d{8})$/.test(txt_val)){
                       $("#c_mobile").css("border","1px solid #ff0000");
			           $("#c_mobile").siblings("i").text("请正确填写手机号").css("display","inline-block");   
				    }else{
						$.post("${path}/train/checkPhoneNumExsits.do", {userMobileNo:txt_val}, function(data) {
			                if (data=='exists') {
			                	$("#c_mobile").css("border","1px solid #ff0000");
			           			$("#c_mobile").siblings("i").text("该手机号已存在").css("display","inline-block");
			                } else {
			                    $("#c_mobile").css("border","1px solid #cccccc");
				       			$("#c_mobile").siblings("i").text("").css("display","none");  
			                }
					});
				    }
				}
			})
		
		
		//电子邮件
	    $("#c_email").blur(function(){
			 var txt_val=($(this).val()).trim();
			 if(txt_val.trim()==""){
				   $(this).val("请输入电子邮件");
				   $("#c_email").css("border","1px solid #ff0000");
				}else if(txt_val!="请输入电子邮件"){
				    if(!/^([\.a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(\.[a-zA-Z0-9_-])+/.test(txt_val)){
                       $("#c_email").css("border","1px solid #ff0000");
			           $("#c_email").siblings("i").text("请正确填写电子邮件").css("display","inline-block");   
				    }else{
				       $("#c_email").css("border","1px solid #cccccc");
				       $("#c_email").siblings("i").text("").css("display","none");  
				    }
				}
			})
			
				$("#c_ID").blur(function(){
			 var txt_val=($(this).val()).trim();
			 if(txt_val==""){
				   $(this).val("请输入身份证号码");
				   $("#c_ID").css("border","1px solid #ff0000");
				}else if(txt_val!="请输入身份证号码"){
				    if(!/(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/.test(txt_val)){
                       $("#c_ID").css("border","1px solid #ff0000");
			           $("#c_ID").siblings("i").text("请正确填写身份证号").css("display","inline-block");   
				    }else{
				    	$.post("${path}/train/checkIDExsits.do", {IDNumber:txt_val}, function(data) {
			                if (data=='exists') {
			                	$("#c_ID").css("border","1px solid #ff0000");
			           			$("#c_ID").siblings("i").text("该身份证已存在").css("display","inline-block");
			                } else {
			                    $("#c_ID").css("border","1px solid #cccccc");
				       			$("#c_ID").siblings("i").text("").css("display","none");  
			                }
			            });
				    }
				}
			})
			
	  
	   //下拉列表
	   $(".select-option").on("mousedown","li",function(){
	      $(this).parents(".select-box").css("border","1px solid #cccccc");
	   })
        $("#c_code").focus(function(){
           var txt_val=$(this).val();
		  if(txt_val==this.defaultValue){
			   $(this).val("");
			   $(this).css("border","1px solid #CCCCCC");
			}
        })
        
	 	if(!($("#c_code").attr("disabled")=='disabled')){
	 	
			$("#c_code").blur(function(){
			
			 var txt_val=($(this).val()).trim();
			   if($(this).hasClass("hadVal")){
			       if(txt_val=="" || txt_val=="请输入验证码"){
					   //$(this).val(this.defaultValue);
					   $("#c_code").css("border","1px solid #cccccc");
					  // $("#c_code").siblings("i").css("display","inline-block");
					}else{
						$("#c_code").css("border","1px solid #cccccc");
					   // $("#c_code").siblings("i").text("").css("display","none");
					}  
			   }else{
				 if(txt_val=="" || txt_val=="请输入验证码"){
					   $(this).val("请输入验证码");
					   $("#c_code").css("border","1px solid #ff0000");
					   $("#c_code").siblings("i").css("display","inline-block");
					}else{
						$("#c_code").css("border","1px solid #cccccc");
					    $("#c_code").siblings("i").text("").css("display","none");
					}
			   }
			})
		}
		
		$("#c_unit").blur(function(){
		 var txt_val=($(this).val()).trim();
		 if(txt_val=="" || txt_val=="请输入您所在单位名称"){
			   $("#c_unit").css("border","1px solid #ff0000");
			   $("#c_unit").siblings("i").css("display","inline-block");
			}else{
				$("#c_unit").css("border","1px solid #cccccc");
			    $("#c_unit").siblings("i").text("").css("display","none");
			}
		})
		
		$("#c_number").focus(function(){
			var txt_val=$(this).val();
			if(txt_val==this.defaultValue){
				   $(this).val("");
				   $(this).css("border","1px solid #CCCCCC");
				}
		})
		
	    $("#c_number").blur(function(){
			 var txt_val=$(this).val();
			 if(txt_val==""){
				   $(this).val(this.defaultValue);
				}
			})
		
	 })
	 
	
	 
	 
	function formSub(){
	
		var mobile = ($("#c_mobile").val()).trim();
		if(mobile=='' || mobile=='请输入手机号'){
			$("#c_mobile").css("border","1px solid #ff0000");
			return false;
		}else if(!/^(((13[0-9]{1})|(14[0-9]{1})|(15[0-9]{1})|(17[0-9]{1})|(18[0-9]{1}))+\d{8})$/.test(mobile)){
			$("#c_mobile").css("border","1px solid #ff0000");
			$("#c_mobile").siblings("i").text("请正确填写手机号").css("display","inline-block");
			return false;
		}else if($("#c_mobile").siblings("i").text()=='该手机号已存在'){
			return false;
		}
		
		var rn = ($("#c_real").val()).trim();
		if(rn=='' || rn=='请输入真实姓名'){
			$("#c_real").css("border","1px solid #ff0000");
			return false;
		}
		
		var e = ($("#c_email").val()).trim();
		if(e=='' || e=='请输入电子邮件'){
			//$("#c_email").siblings("i").text("请输入电子邮件").css("display","inline-block");
			$("#c_email").css("border","1px solid #ff0000");
			return false;
		}else if(!/^([\.a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(\.[a-zA-Z0-9_-])+/.test(e)){
			//alert("请正确填写电子邮件");
			$("#c_email").css("border","1px solid #ff0000");
			$("#c_email").siblings("i").text("请正确填写电子邮件").css("display","inline-block");
			return false;
		}
		var ID = ($("#c_ID").val()).trim();
		if(!($("#c_ID").prop("disabled"))){
			if(ID=='' || ID=='请输入身份证号码'){
				$("#c_ID").css("border","1px solid #ff0000");
				return false;
			}else if(!/(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/.test(ID)){
				$("#c_ID").css("border","1px solid #ff0000");
				$("#c_ID").siblings("i").text("请正确填写身份证号").css("display","inline-block");
				return false;
			}else if($("#c_ID").siblings("i").text()=='该身份证已存在'){
				return false;
			}
		}
		
		if(($("#areaId").val()).trim()==''){
		     $("#areaId").parent(".select-box").css("border","1px solid #ff0000");
			return false;
		}
		
		if($("#c_unit").val().trim()=='' || $("#c_unit").val()=='请输入您所在单位名称'){
			$("#c_unit").css("border","1px solid #ff0000");
			return false;
		}
		
		if(($("#positionId").val()).trim() ==''){
			$("#positionId").parent(".select-box").css("border","1px solid #ff0000");
			return false;
		}
		
		if(($("#titleId").val()).trim()==''){
			$("#titleId").parent(".select-box").css("border","1px solid #ff0000");
			return false;
		}
		
		if(($("#fieldId").val()).trim()==''){
			$("#fieldId").parent(".select-box").css("border","1px solid #ff0000");
			return false;
		}
		
		if($("#c_number").val()=='请输入证书编号'){
			$("#c_number").val("");
			//return false;
		}
		
		
		if(!($("#c_code").prop("disabled"))){
			if(($("#c_code").val()).trim()=='' || $("#c_code").val()=='请输入验证码'){
				$("#c_code").css("border","1px solid #ff0000");
				return false;
			}
		}
		
		//提交等待 
    		var html = '<div class="btn-submit btn-loading" id="btn-tip-loading"><h3>正在提交，请稍等...</h3><div class="img"></div></div>';
            $(".btn-submit").parent().append(html);
            $("#subOrder").hide();
	
	$.post("${path}/train/savePersonalInfo.do", $("#vform").serialize(), function(data) {
                var map = eval(data);
                if (map.success=='Y') {
                	$("#btn-tip-loading").remove();
                    location.href="${path}/train/toOrder.do";
                } else {
                    dialogAlert("提示", map.msg);
                    $("#btn-tip-loading").remove();
                    $("#subOrder").show();
                }
            }); 
	}
</script>
<style>
.error_tip{ color:#ff0000; padding-left:5px; font-style:normal; display:none; line-height:40px; }
#certify{ background:#40b4ff; color:#ffffff; text-align:center; height:40px; line-height:40px; width:140px;  margin-left:10px; display:inline-block; border:none; cursor:pointer;}
.train_control_one  #btn-tip-loading{ float:none;margin:0 auto;}
</style>
</head>
<body>
<%@include file="../index/index_top.jsp"%>
    <!--con start-->
    <div id="register-content">
    <div class="register-content">
        <div class="steps steps-room">
            <ul class="clearfix">
                <li class="step_1 active">1.填写个人信息<i class="tab_status"></i></li>
                <li class="step_2 ">2.选择课程<i class="tab_status"></i></li>
               <!--  <li class="step_3">3.等待确认<i class="tab_status"></i></li> -->
               <li class="step_4">3.等待确认</li> 
            </ul>
        </div>
        <form action="${path}/train/savePersonalInfo.do" id="vform" method="post">
        <input type="hidden" name="userId" value="${user.userId}" class="rp_noinput"/>
        <div class="room-part1 room-part2">
            <table class="tab1" width="100%" style="margin-top: 0;">
                <tbody>
                 <tr>
                    <td>
                        <span class="rp_label">昵称</span>
                        <input type="text" readOnly value="${user.userName}" class="rp_noinput"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="rp_label">性别</span>
                        <input type="text" readOnly <c:if test="${user.userSex==1 }">value="男"</c:if>  <c:if test="${user.userSex==2 }">value="女"</c:if> <c:if test="${empty user.userSex}">value="保密"</c:if> class="rp_noinput"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="rp_label">手机号码</span>
                        <input id="c_mobile" name="userMobileNo" type="text" <c:if test="${not empty user and not empty user.userMobileNo}">value="${user.userMobileNo }" disabled  </c:if>  <c:if test="${empty user or empty user.userMobileNo}">value="请输入手机号"</c:if> class="rp_input"/>
                        <i class="error_tip">请输入手机号</i>
                    </td>
                </tr>
                <tr>
                  <td>
                    <div class="straightlines"></div>
                  </td>
                </tr>
                <tr>
                    <td>
                        <span class="rp_label"><font class="lightred">*</font>真实姓名</span>
                        <input maxlength="30" id="c_real" type="text" name="realName" <c:if test="${not empty trainUser and not empty trainUser.realName}">value="${trainUser.realName }"  readOnly </c:if> <c:if test="${empty trainUser or empty trainUser.realName}">value="请输入真实姓名"</c:if>  class="rp_input"/>
                       <i class="error_tip">请输入真实姓名</i>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="rp_label"><font class="lightred">*</font>电子邮件</span>
                        <input id="c_email" type="text" name="userEmail" <c:if test="${not empty trainUser and not empty trainUser.userEmail}">value="${trainUser.userEmail }" </c:if> <c:if test="${empty trainUser or empty trainUser.userEmail}">value="请输入电子邮件"</c:if>  class="rp_input input_style"/>
                       <i class="error_tip">请输入电子邮件</i>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="rp_label"><font class="lightred">*</font>身份证号码</span>
                        <c:if test="${not empty trainUser and not empty trainUser.idNumber}">
                        	<input id="c_ID"  name="idNumber" value="${trainUser.idNumber}" disabled class="rp_input"/>
                        </c:if>
                        <c:if test="${empty trainUser or empty trainUser.idNumber}">
                        	<input id="c_ID" type="text" name="idNumber" value="请输入身份证号码" class="rp_input input_style"/>
                        </c:if>
                        <i class="error_tip">请输入身份证号码</i>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="rp_label"><font class="lightred">*</font>所在单位区县</span>
                        <div class="trains_select select-box w168 fl">
                           <input type="hidden" name="unitArea" value="${trainUser.unitArea}" class="trains_input"  id="areaId"/>
                           <div id="areaDiv" class="select-text" data-value="">
                           <c:choose>
					        	<c:when test="${not empty trainUser and not empty trainUser.unitArea}">
					        	<script type="text/javascript">
					          		$(function(){
					          			var txt=$("#areaId").val();
					          			$("#areaDiv").text($("#"+txt).text());
					          		})
					          	</script>
					        	</c:when>
					        	<c:otherwise>
					        		请选择所在单位区县
					        	</c:otherwise>
					        </c:choose>
                           	</div>
                           <ul class="select-option">
                             <li id="46"  data-option="46">黄浦区</li>
                             <li id="48"  data-option="48">徐汇区</li>
                             <li id="49"  data-option="49">长宁区</li>
                             <li id="50"  data-option="50">静安区</li>
                             <li id="51"  data-option="51">普陀区</li>
                             <li id="53"  data-option="53">虹口区</li>
                             <li id="54"  data-option="54">杨浦区</li>
                             <li id="55"  data-option="55">闵行区</li>
                             <li id="56"  data-option="56">宝山区</li>
                             <li id="57"  data-option="57">嘉定区</li>
                             <li id="58"  data-option="58">浦东新区</li>
                             <li id="59"  data-option="59">金山区</li>
                             <li id="60"  data-option="60">松江区</li>
                             <li id="61"  data-option="61">青浦区</li>
                             <li id="63"  data-option="63">奉贤区</li>
                             <li id="64"  data-option="64">崇明县</li>
                           </ul>
                        </div>
                        <span class="rp_label" style="width:136px;"><font class="lightred">*</font>所在单位名称</span>
                        <input maxlength="30" id="c_unit" type="text" name="unitName" <c:if test="${not empty trainUser and not empty trainUser.unitName}">value="${trainUser.unitName }"</c:if>  <c:if test="${empty trainUser or empty trainUser.unitName}"> value="请输入您所在单位名称"</c:if>  class="rp_input fl input_style" style="width:280px;"/>
                        <i class="error_tip">请输入您所在单位名称</i>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="rp_label"><font class="lightred">*</font>职务</span>
                        <div class="trains_select select-box w168 fl">
                           <input type="hidden" name="jobPosition" value="${trainUser.jobPosition}" class="trains_input"  id="positionId"/>
                           <div id="positionDiv" class="select-text" data-value="">
                           <c:choose>
					        	<c:when test="${not empty trainUser and not empty trainUser.jobPosition}">
					        	<script type="text/javascript">
					          		$(function(){
					          			var txt=$("#positionId").val();
					          			$("#positionDiv").text($("#"+txt).text());
					          		})
					          	</script>
					        	</c:when>
					        	<c:otherwise>
					        		  请选择职务
					        	</c:otherwise>
					        </c:choose>
                         </div>
                           <ul class="select-option">
                           <c:forEach items="${jobs}" var="job" varStatus="i">
                             <li id="${job.dictId}" data-option="${job.dictId}">${job.dictName}</li>
                           </c:forEach>
                           </ul>
                        </div>
                        <span class="rp_label"  style="width:136px;"><font class="lightred">*</font>职称</span>
                        <div class="trains_select select-box w168 fl">
                           <input type="hidden" name="jobTitle" value="${trainUser.jobTitle}" class="trains_input" id="titleId" />
                           <div id="titleDiv" class="select-text" data-value="">
                           	<c:choose>
					        	<c:when test="${not empty trainUser and not empty trainUser.jobTitle}">
					        	<script type="text/javascript">
					          		$(function(){
					          			var txt=$("#titleId").val();
					          			$("#titleDiv").text($("#"+txt).text());
					          		})
					          	</script>
					        	</c:when>
					        	<c:otherwise>
					        		请选择职称
					        	</c:otherwise>
					        </c:choose>
                          	 </div>
                           <ul class="select-option">
                           	<c:forEach items="${titles}" var="title" varStatus="i">
                             <li id="${title.dictId}" data-option="${title.dictId}">${title.dictName}</li>
                            </c:forEach>
                           </ul>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="rp_label"><font class="lightred">*</font>从事领域</span>
                        <div class="trains_select select-box w168">
                           <input type="hidden" name="engagedField" value="${trainUser.engagedField }" class="trains_input"  id="fieldId"/>
                           <div id="fieldDiv" class="select-text">
                           <c:choose>
					        	<c:when test="${not empty trainUser and not empty trainUser.engagedField}">
					        	<script type="text/javascript">
					          		$(function(){
					          			var txt=$("#fieldId").val();
					          			$("#fieldDiv").text($("#"+txt).text());
					          		})
					          	</script>
					        	</c:when>
					        	<c:otherwise>
					        		请选择从事领域
					        	</c:otherwise>
					        </c:choose>
					        </div>
                           <ul class="select-option">
                           	 <c:forEach items="${fields}" var="field" varStatus="i">
                             <li id="${field.dictId }" data-option="${field.dictId }">${field.dictName }</li>
                             </c:forEach>
                           </ul>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="rp_label">第一轮培训证书编号</span>
                        <input maxlength="30" id="c_number" type="text" name="ertificateNumber" <c:if test="${not empty trainUser and not empty trainUser.ertificateNumber}">value="${trainUser.ertificateNumber }"</c:if>  <c:if test="${empty trainUser or empty trainUser.ertificateNumber}">value="请输入证书编号"</c:if> class="rp_input"/>
                        <i class="error_tip">请输入证书编号</i>
                    </td>
                </tr>
                <tr>
                    <td>
                       <span class="rp_label"><font class="lightred">*</font>报名识别码</span>
                        <input id="c_code" type="text" name="verificationCode" <c:if test="${not empty trainUser and not empty trainUser.verificationCode}">value="${trainUser.verificationCode }" disabled</c:if>  <c:if test="${empty trainUser or empty trainUser.verificationCode}"> value="请输入报名识别码"</c:if>  class="rp_input"/>
                        <button  type="button" id="certify">更改</button>
                        <i class="error_tip">请输入报名识别码</i><br>
                         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;【请联系所在单位办公室或区县文广局索取报名识别码】
                        <script>
                          $("#certify").click(function(){
                            $("#c_code").val("");
                            $("#c_code").prop("disabled",false);
                            $("#c_code").removeClass("input_style");
                            $("#c_code").addClass("hadVal");
                          })
                        </script>
                    </td>

                </tr>
                <tr>
     
                  <td><p style="color:#ff0000; font-size:14px; padding-left:182px;">*只针对上海市公共文化从业人员</p></td>
                </tr>
            </tbody>
         </table>
        </div>
        <div class="book-control train-control train_control_one"><input id="subOrder" type="button"  value="下一步" onclick="return formSub();" class="btn-submit book-submit"></div>
        </form>
    </div>
</div>
    <!--con end-->
<%@include file="../index/index_foot.jsp"%>
<script>
//执行下拉列表
selectModel();
</script>
</body>
</html>
