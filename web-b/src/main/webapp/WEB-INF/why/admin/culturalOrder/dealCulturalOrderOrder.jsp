<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>    
<script type="text/javascript">	
//关闭页面
function buttonEnd() {
	$("body", parent.document).find('#DialogBySHFLayer,#DialogBySHF').remove(); 
}

function saveCulturalOrderOrder() {
	var culturalOrderOrderStatus = $("input[name='culturalOrderOrderStatus']:checked").val();
	var culturalOrderReply = $('#culturalOrderReply').val();
	
	if (culturalOrderOrderStatus == undefined || culturalOrderOrderStatus == "") {
		dialogAlert("系统提示","请选择处理意见");
        return;
	}
	
	if (culturalOrderReply == undefined || culturalOrderReply == "") {
		dialogAlert("系统提示","请填写回复");
        return;
    }
	
	$.post("${path}/culturalOrderOrder/saveCulturalOrderOrderReply.do", $("#culturalOrderOrderForm").serialize(), function(data) { 
		switch (data) {
			case("success"):
				dialogAlert("系统提示", "保存成功", function () {
					parent.location.reload();
				});
				break; 
			case("noActive"):
          		dialogAlert("系统提示", "请登陆后再进行操作", function () {
					window.location.href = "../admin.do";
				});
				break;
			default:
				dialogAlert("系统提示", "发生错误，请查看数据是否完整", function () {
				});
				break;
		}
	});
}
</script>
<style type="text/css">
.dingdRadio {
 width: 512px;
 margin: 0 auto;
 text-align: center;
 margin-bottom: 20px;
}
.dingdRadio label {
	display:inline-block;
    vertical-align: middle;
    padding: 10px 30px;
    font-size: 18px;
    color: #666;
}
.dingdRadio label input {
	margin-right:10px;
}
.dingdTextareaBox{ 
	display:block;
	width: 450px; 
 	margin: 0 auto;
	line-height: 20px; 
	padding: 5px; 
	overflow: auto; 
	border: solid 1px #ACB4C3; 
	color: #142340; 
	border-radius: 4px; 
	-webkit-border-radius: 4px; 
	-moz-border-radius: 4px; 
	resize: none;
}
</style>
</head>
<body>
<form action="" id="culturalOrderOrderForm" method="post">
	<input type="hidden" id="ids" name="ids" value="${ids}"/>
	<div class="site-title">
		处理订单
	</div>
	<div class="main-publish">
		<div class="dingdRadio clearfix">
			<label><input type="radio" name="culturalOrderOrderStatus" value="1"/>确认</label>
			<label><input type="radio" name="culturalOrderOrderStatus" value="2"/>拒绝</label>
		</div>
		<textarea id="culturalOrderReply" name="culturalOrderReply" rows="5" class="dingdTextareaBox"  maxlength="200" style="width: 500px;resize: none"></textarea>
	  	<table width="512" class="form-table" style="margin: 0 auto;"> 	                     
            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-btn">
                    <div class="room-order-info info2" style="position: relative;">
                    	<input class="btn-publish" type="button" onclick="saveCulturalOrderOrder()" value="保存"/>
                    	<input class="btn-publish" type="button" onclick="buttonEnd()" value="关闭"/>
                    </div>
                </td>
            </tr>           
        </table>
	</div>
</form>
</body>
</html>
