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
     		
     		var userId=$("#userId").val();
			
			var tuserIsActiviey=$("#tuserIsActiviey").val();
     		
     		if(text)
     		{
     			$(".btn-save").prop("disabled", true);
     			
     			var data= $("#form").serializeArray();
     			
     			 $.post('${path}/teamUser/authDo.do',data,function(result){
            		 
            		 if(result>=0)
            		{
            			 alert("提交成功！");
            			 
            			 if(roomOrderId)
            				 parent.location.href = '${path}/cmsRoomOrder/roomOrderDetail.do?roomOrderId='+roomOrderId;
            			 else if(tuserIsActiviey)
            				 parent.location.href = '${path}/teamUser/teamUserIndex.do?tuserIsActiviey='+tuserIsActiviey+'&userId='+userId;
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
<input type="hidden" id="tuserIsDisplay" name="tuserIsDisplay" value="3">
<input type="hidden" id="tuserId" name="tuserId" value="${tuserId}"/>
<input type="hidden" id="applyId" name="applyId" value="${applyId}"/>
<input type="hidden" id="roomOrderId" name="roomOrderId" value="${roomOrderId}"/>
<input type="hidden" id="tuserIsActiviey" name="tuserIsActiviey" value="${tuserIsActiviey}"/>
<input type="hidden" id="userId" name="userId" value="${userId}"/>
<!-- 正中间panel -->
<div id="content">
    <div class="content">
        <div class="con-box-blp">
            <form id="tag_form" action="" method="post">
                <div class="con-box-tlp">
                    <div class="form-box">
                        <table class="form-table">
                            <tbody>
                            <tr style="padding-left:50px;display:block; margin-top:20px;">
                                    <td class="td-input" style="display:inline-block;width:80px; font-size: 13px;">
                                       <textarea name="text" id="text" rows="4" class="textareaBox" style="width: 400px;resize: none" ></textarea>
                                               
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