<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <!-- <title>微信登录</title> -->
</head>
<body>
  <script>
      (function(){
          var resCode='${resCode}';
          var type='${type}';
          if(resCode==200){
        	  if(type) {
				  window.location.href = type;
			  }else{
				  window.location.href="${state}/wechat/index.do";
			  }
          }else if(resCode==500){
              window.location.href="${state}/muser/login.do?tips=微信系统忙,请稍后重试"+"&type"+type;
          }else if(resCode==401){
              window.location.href="${state}/muser/login.do?tips=用户取消了授权"+"&type="+type;
          }
      }());
  </script>
</body>
</html>
