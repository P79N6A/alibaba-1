<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<head>
    <title></title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">
	$(function() {
		//调用下拉列表js
		selectModel();
		
		var resultList = ${resultList };
		if(resultList==''){
			dialogAlert("推荐失败！","已无可用运营位，请将已经推荐的排序取消",function(){
                parent.location.href='${path}/beipiaoInfo/infoList.do';
                dialog.close().remove();
           });
		}
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
                /*点击取消按钮，关闭登录框*/
                $(".btn-cancel").on("click", function(){
                    dialog.close().remove();
                });
                
                $(".btn-save").on("click", function(){
                    var number = $("#infoNumber").val();
                    if(number==null||number==""){
                    	alert(1);
                    }else{
                    	$.post("${path}/beipiaoInfo/recommendInfo.do",$('#recommendForm').serialize(),function(data){
             			   if (data != null && data == 'success') {
                                dialogAlert("提示","推荐成功！",function(){
                                    parent.location.href='${path}/beipiaoInfo/infoList.do';
                                    dialog.close().remove();
                               });
            			   }else if (data =="nologin"){
            				   dialogConfirm("提示", "请先登录！", function(){
                         		  window.location.href = "${path}/login.do";
         	                   });
            			   }else {
            				   dialogAlert("提示", "推荐失败！")
            			   }
            		   });
                    }
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
<body>
<div class="main-publish tag-add" style="overflow:visible">
    <form id="recommendForm" method="post">
	    <table width="100%" class="form-table">
	        <tr>
	        	<td>
	        		<div class="search">
	        		<div style="float: left">排序：</div>
	        		 <div class="select-box w135">
	        		 	<input type="hidden" id="infoNumber" name="infoNumber" />
						<div id="bookStatusDiv" class="select-text" data-value="">
						</div>
						<ul class="select-option">
							<c:forEach items="${resultList }" var="result"> 
								<li data-option="${result }">${result }</li>
							</c:forEach>
						</ul>
					</div>
					</div>
	        	</td>
	        </tr>
	        <tr>
	        	<td>
	        		<input type="hidden" id="infoId" name="infoId" value="${infoId}" />
	        		<div><span style="color:red">&nbsp;&nbsp;&nbsp;&nbsp;提示：</span>请将已经推荐的排序取消，避免重复推荐</div>
	        	</td>
	        </tr>
	        <tr>
	            <td class="td-btn" align="center" colspan="2">
	                <input class="btn-save" type="button"  value="保存"/>
	                <input class="btn-cancel" type="button" value="取消"/>
	            </td>
	        </tr>
	    </table>
    </form>
</div>
</body>
</html>
