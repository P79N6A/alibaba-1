<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <!-- <title>验票</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/ticket.css"/>
    <script type="text/javascript">
        
        var dataForm = avalon.define({
            $id: "dataForm"
        });

    </script>
    
    <style>
    	html,body,.main{height:100%}
        .content {padding-top: 100px;padding-bottom: 18px;}
    </style>
    <script type="text/javascript">
        function trim(str){
            return str.replace(/[ ]/g,""); //去除字符算中的空格
        }
        function ticketCheck(){
            var orderValidateCode=$('#orderValidateCode').val();

            if (orderValidateCode==undefined||orderValidateCode=="") {
                $("#orderValidateCode").focus();
                dialogAlert('系统提示', '请输入取票码！');
                return;
            }
            orderValidateCode=trim(orderValidateCode);
            var asm = new Date().getTime();
            $.post("${path}/wechatcheckTicket/checkOrderNumValid.do?asm="+asm,{orderValidateCode:orderValidateCode},function(data) {
                var json = $.parseJSON(data);
                if (json!=undefined&&json.status == "0") {
                   window.location.href="${path}/wechatcheckTicket/ticketInfo.do?asm="+asm+"&code="+orderValidateCode;
                }
                else {
                     $("#orderValidateCode").focus();
                    dialogAlert('系统提示',json.data);
                }
            });
        }
    </script>
</head>
<body class="body">

<div class="main">
    <div class="content">
        <div class="user-input" ms-controller="dataForm">
            <input type="tel" placeholder="请输入取票码" id="orderValidateCode" value="${orderNumber}" maxlength="18"/>
        </div>
        <div class="user-login">
            <button type="button" onclick="ticketCheck()">验证</button>
        </div>
    </div>
</div>
<script language="JavaScript">
    $(function () {
        var code = '${orderNumber}';
        $('#orderValidateCode').val(code.substr(0,4)+" "+code.substr(4,2)+"00 00")
    });

    var test = document.getElementById("orderValidateCode")
    test.onkeydown = function() {
        var x = 0;
        if (window.event) // IE8 以及更早版本
        {
            x = event.keyCode;
        } else if (event.which) // IE9/Firefox/Chrome/Opera/Safari
        {
            x = event.which;
        }
        //			alert(x);
        if (x != 8) {
            if (test.value.length % 5 == 4) {
                test.value = test.value + " ";
            }
        }
    }

</script>
</body>
</html>