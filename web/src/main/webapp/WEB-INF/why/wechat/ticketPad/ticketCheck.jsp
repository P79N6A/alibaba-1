<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/ticketPad/commonFramePad.jsp" %>
    <!-- <title>验票</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/ticket.css"/>
    <script src="${path}/STATIC/js/avalon.js"></script>
    <script type="text/javascript">
        
        var dataForm = avalon.define({
            $id: "dataForm"
        });

        function trim(str){
            return str.replace(/[ ]/g,""); //去除字符算中的空格
        }
        
        function ticketCheck(){
            var orderValidateCode=$('#orderValidateCode').val();

            if (orderValidateCode==undefined||orderValidateCode=="") {
                $("#orderValidateCode").focus();
                showDialog('请输入取票码！');
                return;
            }
            orderValidateCode=trim(orderValidateCode);
            var asm = new Date().getTime();
            $.post("${path}/wechatcheckTicket/checkOrderNumValid.do?asm="+asm,{orderValidateCode:orderValidateCode},function(data) {
                var json = $.parseJSON(data);
                if (json!=undefined&&json.status == "0") {
                   window.location.href="${path}/wechatcheckTicket/ticketInfoPad.do?asm="+asm+"&code="+orderValidateCode;
                }
                else {
                    $("#orderValidateCode").focus();
                    showDialog(json.data);
                }
            });
        }
        
      	//弹窗提示
        function showDialog(text){
        	$('.ipad-middle-pop p').html(text);
        	$('.ipad-middle-pop').show();
        }
    </script>
    
</head>
<body>
	<div class="main ipad" style="overflow: auto;">
		<div class="content ipad-middle">
			<div class="logo2" style="margin-top: 100px;">
				<img src="${path}/STATIC/wechat/image/logo3.png" />
				<p style="color: #5e648f;font-size: 100px;margin: 50px 0px;">安康文化云自助验票</p>
			</div>
			<div class="ipad-user">
				<div class="ipad-user-name" ms-controller="dataForm">
					<input style="width: 930px;" type="tel" placeholder="请输入取票码" id="orderValidateCode" value="" maxlength="18"/>
				</div>
				<button type="button" onclick="ticketCheck()">确认</button>
			</div>
			<div class="ipad-middle-pop" style="display: none;">
				<img src="${path}/STATIC/wechat/image/warning.png" style="margin-top: 60px;" />
				<p style="margin:0 50px;"></p>
				<div class="ipad-pop-button" onclick="$('.ipad-middle-pop').hide();">确认</div>
			</div>
		</div>
	</div>
	
	<script language="JavaScript">
	    $(function () {
	        //var code = '${orderNumber}';
	        //$('#orderValidateCode').val(code.substr(0,4)+" "+code.substr(4,2)+"00 00")
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