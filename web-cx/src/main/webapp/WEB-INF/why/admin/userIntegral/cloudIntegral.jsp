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
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    
    <script type="text/javascript">

    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });

        function save() {
        	
        	var data= $("#form").serializeArray();
          
            $.post('${path}/userIntegral/saveCloudIntegral.do', data, function (result) {
                if (0 == result) {
                    
                    dialogTypeSaveDraft("提示", "发送成功", function () {
                    	 parent.location.reload();
                       
                    });
                   
                } else {
                    dialogAlert("提示", "系统错误，发送失败！");
                }
            });
        }
        $(function () {
          


        });
        
        function dialogTypeSaveDraft(title, content, fn) {
            var d = parent.dialog({
                width: 400,
                title: title,
                content: content,
                fixed: true,
                okValue: '确 定',
                ok: function () {
                    if (fn)  fn();
                }
            });
            d.showModal();
        }


    </script>
</head>
<body class="rbody">
<form id="form">
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
                            <tr style="padding-left:100px;display:block; margin-top:20px;">
								
                                    <td class="td-input" style="display:inline-block;width:80px; font-size: 13px;">
                                        <input type="radio" name="changeType" style="display:inline; width:15px; height: 15px; margin-right:3px; cursor: pointer; vertical-align: middle;"
                                                 checked
                                               value="0" >增 </td>
                                   <td class="td-input" style="display:inline-block;width:80px; font-size: 13px;">
                                        <input type="radio" name="changeType" style="display:inline; width:15px; height: 15px; margin-right:3px; cursor: pointer; vertical-align: middle;"

                                               value="1" >减
                                      </td>

                            </tr>
                            <tr style="padding-left:100px;display:block; margin-top:20px;" >
                             <td class="td-title">积分数：</td>
			                <td class="td-input" id="">
			                    <input type="text" id="integralChange" name="integralChange" value="" maxlength="10" class="input-text w60"/>
			                </td>
			                </tr>
			                 <tr style="padding-left:100px;display:block; margin-top:20px;" >
                             <td  class="td-title">事项：</td>
			                <td class="td-input" id="">
			                  <textarea name="integralFrom" id="integralFrom" rows="4" class="textareaBox"  maxlength="300" style="width: 300px;resize: none"></textarea>
			                </td>
			                </tr>
                            
                            <tr class="td-btn" style="margin-top:15px;">
                                <td colspan="2"><input type="button" value="保存" onclick="save()" class="btn-save"
                                                       style="margin-left: 155px;margin-top: 20px;"/>
                                    <input type="button" value="返回" class="btn-publish btn-cancel"/></td>
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
</form>
</html>