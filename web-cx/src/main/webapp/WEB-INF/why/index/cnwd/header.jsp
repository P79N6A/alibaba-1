<%@ page language="java" pageEncoding="UTF-8" %>
<div class="top_wrap">
	<div class="top clear">
		<a href="javascript:;" class="logo fl"><img src="${path }/STATIC/image/cnwd/images/logo.png"></a>
		<a href="javascript:void(0);" class="exit fr" onclick="getUrl();"/>退出</a>
	</div>
</div>
<script>
function getUrl() {
    var url=getChinaServerUrl();
    //console.log(url);
    return window.location.href=url+"cnwdFrontUser/login.do?type=${basePath}cnwdEntry/registerOne.do";
}
</script>