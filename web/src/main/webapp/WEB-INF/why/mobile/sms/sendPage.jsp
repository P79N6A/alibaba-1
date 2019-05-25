<%--
  Created by IntelliJ IDEA.
  User: niubiao
  Date: 2016/3/9
  Time: 10:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%request.setAttribute("path",request.getContextPath());%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <!-- <title>短信发送</title> -->
        <link href="${path}/STATIC/css/boot/Bootstrap.css" rel="stylesheet">
        <link href="${path}/STATIC/css/boot/BootstrapTheme.css" rel="stylesheet">
        <script src="${path}/STATIC/js/jquery.min.js"></script>
    <script>
        function rmDom(obj){
            $(obj).remove();
        }
        function addMobileNo(){
               var mobileNo = $("#mobileNo").val();
               if(mobileNo&&mobileNo.length===11){
                   var _thisHtml='<a href="javascript:;" class="list-group-item list-group-item-success" onclick="rmDom(this)">'+mobileNo+'<input type="hidden" value="'+mobileNo+'"'+'>'+'</a>';
                   $("#addList").prepend(_thisHtml);
                   $("#mobileNo").val("");
                   $("#mobileNo").focus();
               }else{
                   $("#mobileNo").focus();
               }
        }
        function sendSms(){
            var mobileNo ="";
            $("#addList input").each(function(index,item){
                mobileNo+=$(this).val()+",";
            });
            if(mobileNo){
                mobileNo=mobileNo.substring(0,mobileNo.length-1);
            }
            $("#sendSms").html("短信发送中,请稍后。。。");
            $("#sendSms").unbind("click");
            $.ajax({
                type: "POST",
                url: "${path}/sms/send.do?asm="+new Date().getTime(),
                data: {mobileNo:mobileNo},
                success: function(res){
                    if(res.code==200){
                       setTimeout(function(){
                           $("#sendSms").html("短信发送成功");
                       },500);
                    }else{
                       $("#sendSms").html("短信发送成功");
                    }
                }
            });
        }
        $(function(){
           $("#sendSms").bind("click",sendSms);
        });
    </script>
</head>
<body>
<h1>文化云</h1>
<br/>
<p>
        <form>
            <div class="form-group">
                <input type="input" class="form-control" placeholder="请输入手机号" maxlength="11" id="mobileNo" autocomplete="false"
                       onkeyup="if(this.value!=this.value.replace(/\D/g,'')) this.value=this.value.replace(/\D/g,'')"
                       onafterpaste="this.value=this.value.replace(/\D/g,'')"
                       onblur="this.value=this.value.replace(/\D/g,'')"
                       onfocus="this.value=this.value.replace(/\D/g,'')" />
            </div>
            <button type="button" class="btn btn-default" onclick="addMobileNo()">添加手机号</button>
        </form>
</p>


<br/><br/>

<div class="list-group" id="addList">

</div>

<br/><br/>
<button type="button" class="btn btn-default"  id="sendSms">发送短信</button>
<br/><br/><br/><br/>
<div class="container-fluid">
    <ul class="list-group">
        <c:forEach items="${dataList}" var="t" varStatus="st">
            <c:if test="${st.index%2==0}"><li class="list-group-item list-group-item-info">${t}</li></c:if>
            <c:if test="${st.index%2!=0}"><li class="list-group-item list-group-item-success">${t}</li></c:if>
        </c:forEach>
    </ul>
</div>
</body>
</html>
