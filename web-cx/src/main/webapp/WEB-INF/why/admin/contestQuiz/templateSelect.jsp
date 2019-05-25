<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>标签管理</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
      <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>

    <script type="text/javascript">

    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
      });

    seajs.config({
        alias: {
          "jquery": "${path}/STATIC/js/dialog/lib/jquery-1.10.2.js"
        }
      });
     
        $(function () {
        	
        	var dialog = parent.dialog.get(window);
      
            $(".btn-publish").on("click", function () {
            	
            	var templateId=$("input[name='templateId']:checked").val();
            	
            	var templateName=$("input[name='templateId']:checked").parent().find("#templateName").html();
            	
            	var valData = {"templateId": templateId,"templateName":templateName}
					
            	dialog.close(valData).remove();

            });

            $(".btn-cancel").on("click", function(){
                dialog.close().remove();
              });

        });


    </script>
</head>
<body class="rbody">

<!-- 正中间panel -->
<div id="content">
    <div class="content">
        <div class="con-box-blp">
            <form id="tag_form" action="" method="post">
                <div class="con-box-tlp">
                    <div class="form-box">
                        <table class="form-table">
                            <tbody>
                            
                            <tr style="padding-left:80px;display:block; margin-top:20px;">
                                <c:forEach items="${list}" var="template" varStatus="sta">

                                    <td class="td-input" style="display:inline-block;font-size: 13px;margin-right:20px">
                                        <input type="radio" name="templateId" style="display:inline; width:15px; height: 15px; margin-right:3px; cursor: pointer; vertical-align: middle;"

                                               <c:if test="${templateId eq template.templateId}">
                                                 checked="true"
                                                </c:if>
                                               value="${template.templateId}" ><span id="templateName">${template.templateName }</span> </br>
                                      <img src="${template.coverImgUrl}@150w" alt="" height="150" width="100" style="max-height: 50;max-width: 100">      
                                               
                                               
                                               <img src="${template.backgroundImgUrl}@150w" alt="" height="150" width="100" style="max-height: 50;max-width: 100">
                                               </td>
                                      
                                         </c:forEach>
                            </tr>
                           
                            
                            <tr class="td-btn" style="margin-top:15px;">
                                <td colspan="2">
                                
                                 <input type="button" value="返回" class="btn-save btn-cancel"  style="margin-left: 155px;margin-top: 20px;"/>
                                <input type="button" value="保存" class="btn-publish" />
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

</body>
</html>