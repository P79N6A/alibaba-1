<%@ page language="java" pageEncoding="UTF-8" %>
<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
<!-- foot start -->
<div class="footer">
<div class="footWen">佛山市文化广电新闻出版局&emsp;|&emsp;合作电话：0757-83031822&emsp;</div>
<div class="footWen">技术支持：<a href="http://www.creatoo.cn" target="_blank">创图科技</a></div>
</div>
<script>
function outLogin(){var a="${sessionScope.terminalUser}";if(a){$.post("${path}/frontTerminalUser/outLogin.do?asm="+new Date().getTime(),function(b){window.location.reload(true)})}else{window.location.reload(true)}};
function feedBack(){
  if('${sessionScope.terminalUser}' == null || '${sessionScope.terminalUser}' == ""){
    dialogAlert("提示","登录之后才能反馈！");
    return;
  }else{
	  window.location.href="${path}/frontIndex/feedBack.do";
  }
}
</script>

<!-- foot end -->	