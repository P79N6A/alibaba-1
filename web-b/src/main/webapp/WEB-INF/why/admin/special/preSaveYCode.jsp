<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>

<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
    $(function(){
        selectModel();
    });
    seajs.config({
        alias: {
            "jquery": "jquery-1.10.2.js"
        }
    });

    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });

    window.console = window.console || {log:function () {}}
    seajs.use(['jquery'], function ($) {
        $(function () {
            var dialog = parent.dialog.get(window);
            
            
            /*点击确定按钮*/
            $(".btn-save").on("click", function(){
            	
            	var number = parseInt($("#number").val());
                var surpluCode=parseInt($("#surpluCode").val());
                var customerId=$("#customerId").val();
                
                if(!number || number>surpluCode){
                	
                	 dialogTypeSaveDraft("提示", "生成Y码数,并且小于等于剩余数!");
                }
                else
                {
                	  $.post("${path}/specialYcode/saveCode.do", $("#form").serialize(), function(result) {
                      	
                          if (result == "success") {
                              dialogTypeSaveDraft("提示", "保存成功", function(){
                                
                            	  parent.location.href = '../specialYcode/index.do?customerId='+customerId;
                            	  
                              });
                          }else{
                              dialogTypeSaveDraft("提示", "保存失败");
                          }
                      });
                }
            });
            /*点击取消按钮，关闭登录框*/
            $(".btn-cancel").on("click", function(){
                dialog.close().remove();
            });
        });
    });

    function dialogTypeSaveDraft(title, content, fn){
        var d = parent.dialog({
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

<body style="background: none;">
<form id="form">
    <div class="main-publish tag-add" style="overflow:visible;">
    	<input type="hidden" name="customerId" id="customerId" value="${customer.customerId }"/>
    	 <input type="hidden" name="surpluCode" id="surpluCode" value="${surpluCode }"/>
            <table width="100%" class="form-table">
                <tr>
                    <td class="td-title" width="20%">活动票务总数：</td>
                    <td class="td-input">${codeSum }</td>
                </tr>
                <tr>
                    <td class="td-title" width="20%">已设置Y码：：</td>
                    <td class="td-input">${createdCode }</td>
                </tr>
              <tr>
                    <td class="td-title" width="20%">剩余可设置Y码：</td>
                    <td class="td-input">${surpluCode }</td>
                </tr>
                <tr>
                     <td class="td-title" width="20%"><span class="red">*</span>生成Y码数：</td>
                    <td class="td-input"><input type="text" class="input-text w210" id="number" name="number" value=""/>
                    <span class="error-msg" id="customerNameSpan"></span>
                    </td>
                </tr>
                <tr>
                    <td class="td-title"></td>
                    <td class="td-btn">
                        <input class="btn-save" type="button"  value="保存"/>
                        <input class="btn-cancel" type="button" value="关闭"/>
                    </td>
                </tr>
            </table>
    </div>
</form>


</body>
</html>