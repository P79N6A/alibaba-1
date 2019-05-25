<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>

    <script type="text/javascript">
        $(function(){
            dialogConfirm("提示","您确定要初始化权限？", function(){
                $("#initMessage").html("正在初始化权限，请稍后......");
                $.post("${path}/module/initModule.do",function(message){
                    if(message == "success"){
                        $("#initMessage").html("权限初始化成功,退出再登录后生效!");
                    }else{
                        $("#initMessage").html("权限初始化失败!");
                    }
                });
            });
        });
    </script>
  </head>

  <body>
  <%--<div id="content">
      <div class="content">
          <div class="con-box-blp">
              <h3>初始化权限信息</h3>
              <div class="con-box-tlp">
                  <div class="form-box" id="initMessage">

                  </div>
              </div>
          </div>
      </div>
  </div>--%>
  <div class="init-box">
      <h3>初始化权限</h3>
      <p id="initMessage"></p>
  </div>
  </body>
</html>
