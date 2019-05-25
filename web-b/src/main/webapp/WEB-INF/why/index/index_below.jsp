<%@ page language="java"  pageEncoding="UTF-8"%>

<div class="in-bottom">
  <div class="in-part4 clearfix">
    <div class="in-phone"><img src="${path}/STATIC/image/phone.png" alt="" width="159" height="273"/></div>

    <div class="in-app">
      <img src="${path}/STATIC/image/app-ewm.png" alt="" width="170" height="170"/>
    </div>

<%--    <div class="in-app">
      <div class="in-iphone">
        <img src="${path}/STATIC/image/download-iphone.png" alt="" width="104" height="104">
        <span><i></i>App Store下载</span>
      </div>
      <div class="in-android">
        <img src="${path}/STATIC/image/download-android.png" alt="" width="104" height="104">
        <span><i></i><a href="#" target="_blank" style="color:#FFFFFF">Android下载</a></span>
      </div>
    </div>--%>
    <div class="in-sweep">
      <h2>扫一扫<br/>下载文化云平台APP</h2>
      <h4>精彩尽在www.wenhuayun.cn</h4>
    </div>
  </div>
</div>

<div id="in-footer">
  <div class="in-footer">
    <%--<div class="in-footer1">
      <p>文化上海云 版权所有 | 未经授权禁止复制或镜像 | 联系电话:021-58741254 | 传真:65874269 | 沪ICP备06021945号 |
        <a href="${path}/frontIndex/legal.do" style="color:#999999;">服务条款</a>
          <a  href="javascript:;" onclick="feedBack()" style="color:#999999;">| 意见反馈</a>
     </p>
      <p>Copyright © 2014 - 2020 www.culture.com All Rights Reserved.
        <script type="text/javascript">var cnzz_protocol = (("https:" == document.location.protocol) ? " https://" : " http://");document.write(unescape("%3Cspan id='cnzz_stat_icon_1256993307'%3E%3C/span%3E%3Cscript src='" + cnzz_protocol + "s95.cnzz.com/z_stat.php%3Fid%3D1256993307' type='text/javascript'%3E%3C/script%3E"));</script>
      </p>
    </div>--%>
    <div class="in-footer1">
      <p>联系电话：4000182346 | 传真：36696098-8080 | <a href="${path}/frontIndex/legal.do" style="color:#999999;"> 服务条款</a> |  <a href="javascript:;" onclick="feedBack()" style="color:#999999;">意见反馈</a></p>
      <p>沪ICP备07032795号-8 | Copyright &copy; 2014-2016 wenhuayun.cn 文化云 版权所有，未经授权禁止复制或镜像 | <script type="text/javascript">var cnzz_protocol = (("https:" == document.location.protocol) ? " https://" : " http://");document.write(unescape("%3Cspan id='cnzz_stat_icon_1256993307'%3E%3C/span%3E%3Cscript src='" + cnzz_protocol + "s95.cnzz.com/z_stat.php%3Fid%3D1256993307' type='text/javascript'%3E%3C/script%3E"));</script></p>
      <!--<p>文化上海云 版权所有 | 未经授权禁止复制或镜像 | 联系电话：021-58741254 | 传真：65874269 | 沪ICP备06021945号 | 服务协议 | 意见反馈</p>
      <p>Copyright © 2014 - 2020 www.culture.com All Rights Reserved. <script type="text/javascript">var cnzz_protocol = (("https:" == document.location.protocol) ? " https://" : " http://");document.write(unescape("%3Cspan id='cnzz_stat_icon_1256993307'%3E%3C/span%3E%3Cscript src='" + cnzz_protocol + "s95.cnzz.com/z_stat.php%3Fid%3D1256993307' type='text/javascript'%3E%3C/script%3E"));</script></p>-->
    </div>
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
  else{window.location.href="${path}/frontIndex/feedBack.do";}

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
