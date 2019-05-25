<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <link rel='stylesheet' href='${path}/STATIC/css/reset.css'/>
    <script type="text/javascript">
		var linkUrl = '${linkUrl}';	
    
        $(function () {
        	var clipboard = new Clipboard('.copyButton');
        	
        	clipboard.on('success', function(e) {
        		dialogAlert("提示", "复制完成！");
        	});
        });
    	
    </script>

</head>

<body>
	<div style="float:right;width: 42px;height: 42px;line-height: 42px;font-size: 42px;text-align: center;color: red;cursor: pointer;" onclick="$('body', parent.document).find('#DialogBySHFLayer,#DialogBySHF').remove();">×</div>
	<div style="clear: both;"></div>
	<div style="width: 530px;height: 380px;margin: auto;line-height: 30px;font-size: 14px;">
		<div style="width: 480px;margin: 12px auto 0px;">
			<div style="float: left;width: 35px;">
				<p style="line-height: 30px;margin: 0px;">URL:</p>
			</div>
			<div style="float: left;width: 340px;">
				<p style="line-height: 30px;margin: 0px;word-break : break-all;word-wrap : break-word;">${linkUrl}</p>
			</div>
			<a class="copyButton" data-clipboard-text='${linkUrl}' style="cursor: pointer;float: right;display: inline-block;width: 100px;height: 30px;overflow: hidden;color: #ffffff;border-radius: 5px;-moz-border-radius: 5px;-webkit-border-radius: 5px;background: #1882FC;text-align: center;">复制链接</a>
			<div style="clear: both;"></div>
		</div>
		<div style="padding-top: 20px;">
			<img src="${QRCodeUrl}" style="display: block;margin:auto;height: 140px;width: 140px;" />
			<p style="text-align: center;margin-top: 10px;">右键单击-图片另存为-下载此二维码</p>
		</div>
		<div style="margin-top: 20px;font-size: 13px">
			<p style="margin-left: 50px;">说明：此链接可用于在其他平台进行推广；</p>
			<p style="margin-left: 89px;">下载二维码，可以打印供现场用户扫码预定本场馆活动。</p>
		</div>
	</div>
</body>
</html>