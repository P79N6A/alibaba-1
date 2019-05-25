<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
<div class="foot_bg">
  <div class="foot">
    <ul class="clearfix">
      <li><a href="${path}/frontIndex/contact.do">联系我们</a></li>
      <em>|</em>
      <li><a href="${path}/frontIndex/partner.do">合作伙伴</a></li>
      <em>|</em>
      <li><a href="${path}/frontIndex/friendship.do">友情链接</a></li>
      <em>|</em>
      <li><a href="${path}/frontIndex/legal.do" >服务条款</a></li>
      <em>|</em>
      <li><a href="javascript:;" onclick="feedBack()"> 意见反馈</a></li>
    </ul>
        <p>联系电话：4000182346 | 传真：36696098-8080  </p>
        <p>沪ICP备07032795号-8 | Copyright &copy; 2014-2016 wenhuayun.cn 文化云 版权所有，未经授权禁止复制或镜像 | <script type="text/javascript">var cnzz_protocol = (("https:" == document.location.protocol) ? " https://" : " http://");document.write(unescape("%3Cspan id='cnzz_stat_icon_1256993307'%3E%3C/span%3E%3Cscript src='" + cnzz_protocol + "s95.cnzz.com/z_stat.php%3Fid%3D1256993307' type='text/javascript'%3E%3C/script%3E"));</script></p>
    <a href="javascript:;" onclick="scrollTo(0,0);" id="toTop"></a>
  </div>
</div>
<script>
function outLogin(){var a="${sessionScope.terminalUser}";if(a){$.post("${path}/frontTerminalUser/outLogin.do?asm="+new Date().getTime(),function(b){window.location.reload(true)})}else{window.location.reload(true)}};
function feedBack(){
  if('${sessionScope.terminalUser}' == null || '${sessionScope.terminalUser}' == ""){
    dialogAlert("提示","登录之后才能反馈！");
    return;

  }
window.location.href="${path}/frontIndex/feedBack.do";

}
</script>

<script>
  var _hmt = _hmt || [];
  (function() {
    var hm = document.createElement("script");
    hm.src = "//hm.baidu.com/hm.js?eec797acd6a9a249946ec421c96aafeb";
    var s = document.getElementsByTagName("script")[0];
    s.parentNode.insertBefore(hm, s);
  })();
</script>
<script type="text/javascript" src="${path}/stat/stat.js"></script>