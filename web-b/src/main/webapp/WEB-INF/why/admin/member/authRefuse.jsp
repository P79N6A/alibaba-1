<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title></title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
     <script type="text/javascript">
     
     	function sub(){
     		var text=$("#text").val();
     		
     		var roomOrderId=$("#roomOrderId").val();
     		
     		var userIsDisable=$("#userIsDisable").val();
     		
     		if(text)
     		{
     			$(".btn-save").prop("disabled", true);
     			
     			var data= $("#form").serializeArray();
     			
     			 $.post('${path}/terminalUser/authDo.do',data,function(result){
            		 
            		 if(result>=0)
            		{
            			 alert("提交成功！");
            			 if(roomOrderId)
             				parent.location.href = '${path}/cmsRoomOrder/roomOrderDetail.do?roomOrderId='+roomOrderId;
             			else if(userIsDisable)
             				parent.location.href = '${path}/terminalUser/terminalUserIndex.do?userType=3&userIsDisable='+userIsDisable;
             			else 
             				parent.location.href = '${path}/cmsRoomOrder/roomOrderCheckIndex.do';
            		}
            		 else
            		{
            			 alert("提交失败,系统错误！");
            			 $(".btn-save").prop("disabled", false);
            		}
            			
            		 
            	 });
     		}
     	}
     </script>
    
<body class="rbody">
<form id="form" >
<input type="hidden" id="userType" name="userType" value="4">
<input type="hidden" id="userId" name="userId" value="${userId}"/>
<input type="hidden" id="roomOrderId" name="roomOrderId" value="${roomOrderId}"/>
<input type="hidden" id="userIsDisable" name="userIsDisable" value="${userIsDisable }">

<!-- 正中间panel -->
<div id="content">
    <div class="content">
        <div class="con-box-blp">
            <form id="tag_form" action="" method="post">
                <div class="con-box-tlp">
                    <div class="form-box">
                        <table class="form-table">
                            <tbody>
                            <tr style="padding-left:50px;display:block; margin-top:20px;width:300px;">
                            <td>拒绝原因:</td>
                                    <td class="td-input" style="padding-left:30px;font-size: 13px;">
                                        <select name="text" id="text" class="">
                                        	<option value="照片不清晰">照片不清晰</option>
                                        	<option value="非身份证照片">非身份证照片</option> 
                                        	<option value="非本人身份证">非本人身份证</option>
                                        	<option value="已被他人占用">已被他人占用</option>
                                        	<option value="其他原因">其他原因</option>
                                        	
                                        </select>
                                               
                                               
                                     </td>
                            </tr>
                            <tr class="td-btn" style="margin-top:15px;">
                                <td colspan="2"><input type="button" value="保存" onclick="sub()" class="btn-save"
                                                       style="margin-left: 155px;margin-top: 20px;"/>
                                   </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
</form>
</body>
</html>