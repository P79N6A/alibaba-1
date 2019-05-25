<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
  String path = request.getContextPath();
  request.setAttribute("path", path);
  String basePath = request.getScheme() + "://"
          + request.getServerName() + ":" + request.getServerPort()
          + path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head lang="en">
  <meta charset="UTF-8">
  <title>文化云数字化平台取票管理</title>
    <link rel="shortcut icon" href="${path}/STATIC/image/favicon.ico" type="image/x-icon" mce_href="${path}/STATIC/image/favicon.ico">
    <link href="${path}/STATIC/image/favicon.ico" rel="icon" type="image/x-icon" mce_href="${path}/STATIC/image/favicon.ico">
   <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/reset-index.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-user.css"/>
    <!--[if lte IE 8]>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-ie.css"/>
  <![endif]-->
  <script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/keyboard.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/culture.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/getTicket.js?version=20151226"></script>
    <script language="javascript" src="${path}/STATIC/js/LodopFuncs.js"></script>
    <!-- 插入打印控件 -->
    <div style="height: 0; overflow: hidden;">
    <object  id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width=0 height=0>
        <embed id="LODOP_EM" type="application/x-print-lodop" width=0 height=0></embed>
    </object>
    </div>
    <script type="text/javascript">
        /*取票机全屏*/
        function setTicketScreen(){
            var $ticket = $("#ticket-iframe");
            if($ticket.length > 0){
                var ticketH = 0, winH = $(window).height();
                var navH = $("#ticket-top").height();
                ticketH = winH - navH;
                $ticket.css({"height": ticketH});
                $("#ticket-content").css({"height": ticketH});
                $(".ticket-part").css({"height": ticketH});
            }
        }
        $(function(){
            /*取票机全屏*/
            setTicketScreen();
            $(".ticket-menu").on("click", ".btn", function(){
                $("#ticket-iframe").attr("src",'${path}/ticketActivity/ticketActivityList.do');
                var $this = $(this);
                var index = $this.index();
                $this.addClass("cur").siblings().removeClass("cur");
                $(".ticket-part").eq(index).show().siblings(".ticket-part").hide();
                $(".get-ticket").show().siblings().hide();
                $("#ticket-code").val("");
                $(".error-msg").hide();
                $("h2").show();
            });

            $(".ticket-info").on("click", ".seat a", function(){
                var $this = $(this);
                if($this.hasClass("cur")){
                    $this.removeClass("cur");
                    if($(".ticket-info .seat").find(".cur").length < 1){
                        $(".btn-confirm").css("background","gray").attr("disabled", true);
                    }
                }else{
                     $this.addClass("cur");
                    $(".btn-confirm").css("background","#f58636").attr("disabled", false);
                }
            });

           //数字键盘
            var cursorPos = 0;
            var cardNum = $("#ticket-code");
            var cardNumDom = cardNum.get(0);
            var cardNumVal = "";
            var cursorPos;
            $(".num-board").on("click", ".key", function(){
                var $this = $(this);
                var keyNum = keyboard.trim($this.html());
                cardNumVal = cardNum.val();
                var cardNumArr = cardNumVal.split("");
                cardNumArr.splice(cursorPos, 0, keyNum);
                cardNumVal = cardNumArr.join("");
                cardNum.val(cardNumVal);
                cursorPos++;
                keyboard.setCursorPosition(cardNum.get(0), cursorPos);
            });

            $("#btn-del").on("click", function(){
                var $this = $(this);
                cursorPos = keyboard.getPositionForInput(document.getElementById("ticket-code"));
                cardNumVal = cardNum.val();
                if(cursorPos > 0) {
                    var cardNumArr = cardNumVal.split("");
                    cardNumArr.splice(cursorPos - 1, 1);
                    cardNumVal = cardNumArr.join("");
                    cardNum.val(cardNumVal);
                    cursorPos--;
                    keyboard.setCursorPosition(cardNum.get(0), cursorPos);
                }else{
                    keyboard.setCursorPosition(cardNum.get(0), 0);
                }
            });
            $("#ticket-code").on("click", function(){
                cursorPos = keyboard.getPositionForInput(document.getElementById("ticket-code"));
            })

        });

        //跳转至登录页面
        function ticketLogin(){
            //跳转至登录页面
            $("#ticket-iframe").attr("src",'${path}/ticketUser/preTicketUserLogin.do');
            var $this = $(this);
            var index = 1;
            $this.addClass("cur").siblings().removeClass("cur");
            $(".ticket-part").eq(index).show().siblings(".ticket-part").hide();
            $(".get-ticket").show().siblings().hide();
            $("#ticket-code").val("");
            $(".error-msg").hide();
            $("h2").show();
        }

        function ticketOutLogin() {
            $.post("${path}/frontTerminalUser/outLogin.do",function(result) {
            if (result == "success") {
                location.reload();
                //location.href='${path}/ticketActivity/ticketActivityList.do';
            } else {
                alert("退出失败");
            }
            });
        }

        $(window).resize(function(){
            /*取票机全屏*/
            setTicketScreen();
        });

        //活动取票机取票
        function activityPrintPiao()
        {
            var validateCode=$("#orderValidateCode").val();
            var seatStr = "";
            $(".seat a").each(function(){
                if($(this).hasClass("cur")){
                    seatStr += $(this).attr("data-val") + ",";
                }
            });
            if(seatStr!=null && seatStr!=''){
                 $(".btn-confirm").attr("disabled", true);
            }else{
                 //$(".btn-confirm").attr("background","#ffffff");  Active order take
            }
            $.ajax({
                type:"post",
                url:"${path}/ticket/activeOrderTake.do",
                data:{"validateCode":validateCode,"seats":seatStr},
                dataType: "json",
                success:function(data){
                    if(data.status==0){
                        if(data.data.length>30){
                            $("#page1").html(data.data);
                          //  $("#printsfz").show();
                            printAct();
                            showPiao();
                            setTimeout('hidePiao()',1000);
                        }
                    }
                    if(data.status==14113 || data.status==14112){
                          // showTicketMsg('取票信息有误',data.data);
                           $(".error-msg").html(data.data);
                           $(".error-msg").show();
                    }
                }
            });
        }
        //活动室取票流程
        function roomPrintPiao()
        {
            var validateCode=$("#orderValidateCode").val();
            $.ajax({
                type:"post",
                url:"${path}/ticket/roomOrderTake.do",
                data:{"validateCode":validateCode},
                dataType: "json",
                success:function(data){
                    if(data.status==0){
                        if(data.data.length>30){
                            $("#page1").html(data.data);
                           // $("#printsfz").show();
                            printAct();
                            showPiao();
                            setTimeout('hidePiao()',1000);
                        }
                    }
                    if(data.status==14113 || data.status==14112){
                        // showTicketMsg('取票信息有误',data.data);
                        $(".error-msg").html(data.data);
                        $(".error-msg").show();
                    }
                }
            });
        }



        //取票成功后，显示取票动画
        function showPiao(){
            $("#collect_main1").hide();
            $(".ticket-info").hide();
        }
        //隐藏取票动画，转到取票页面
        function hidePiao(){
            $("#collect_main1").show();
            $(".txt").val('');
            window.formColl.coll_password.focus();
        }

        var LODOP; //声明为全局变量
        function printAct() {
            LODOP=getLodop(document.getElementById('LODOP'),document.getElementById('LODOP_EM'));
            LODOP.PRINT_INIT("");
            LODOP.SET_PRINT_PAGESIZE(3,800,0,"");
            LODOP.SET_PRINT_STYLEA(1, "ItemType", 0);
            LODOP.SET_PRINT_STYLEA(1,"FontName","微软雅黑");
           // LODOP.SET_PRINT_STYLEA(1,"FontSize",8);
            LODOP.ADD_PRINT_HTM(10,0,800,400,document.getElementById("printsfz").innerHTML);
            // LODOP.ADD_PRINT_BARCODE(270,55,140,140,"QRCode",$("#ticket-code").val());
             //LODOP.PREVIEW(); //打印预览
             LODOP.PRINT();	//打印
        };

    </script>
</head>
<body>
<input type="hidden" id="path" value="${path}"/>
<div id="ticket-top">
  <div class="ticket-top">
    <div class="logo fl"><a href="javascript:;"><img src="${path}/STATIC/image/logo-ticket.png" alt=""/></a></div>
    <div class="ticket-menu fr">
      <a title="取票" class="btn btn-take cur"></a>
      <a title="订票" class="btn btn-book"></a>
        <% if(session.getAttribute("terminalUser") != null) { %>
            <a id="btnLogin" href="javascript:ticketOutLogin();" title="退出" class="btn2 btn-logout"></a>
        <% } else{ %>
        <a id="btnLogin" href="javascript:ticketLogin();" title="登录" class="btn2 btn-login"></a>
        <%}%>

    </div>
  </div>
</div>
<div id="ticket-content">
  <div class="ticket-part" id="get-ticket">
    <div class="get-ticket" id="collect_main1">
        <div class="take-ticket">
            <form name="formColl">
                <h2>请输入取票码</h2>
                <div class="error-msg" style="display:none">取票码有误，请重新输入</div>
                <input type="text" class="txt" id="ticket-code" name="coll_password" class="coll_password"/>
                <div class="num-board">
                    <ul>
                        <li class="key">1</li>
                        <li class="key">2</li>
                        <li class="key">3</li>
                        <li class="btn"><input type="button" class="btn-del" id="btn-del" value="删除"/></li>
                        <li class="key">4</li>
                        <li class="key">5</li>
                        <li class="key">6</li>
                        <li class="key">7</li>
                        <li class="key">8</li>
                        <li class="key">9</li>
                        <li class="key">0</li>
                    </ul>
                </div>
                <input type="button" value="确定取票" class="btn-submit" onclick="getTicket();return false;"/>
                <div class="tip">如有疑问，请联系工作人员</div>
            </form>
        </div>

    </div>
      <!--ticket 详情 -->
    <div class="ticket-info" style="display:none;">
    </div>
      <!--ticket end-->

     <!--打印活动票据 -->
      <div id="printsfz" style="display:none">
      <div id="page1">
      <div class="ticket-print" style="width: 320px;">
          <div style="padding: 20px;">
              <div style="height: 32px; overflow: hidden;">
                  <div style="float: left;"><img src="image/logo-print.png" alt="" height="30"/></div>
                  <div style="float: left; border-left: solid 5px #080808; padding-left: 5px; margin:1px 0 1px 10px; height: 30px;">
                      <h1 style="line-height: 20px; font-size: 12pt;">活动预约</h1>
                      <p style="line-height: 12px; font-size: 7pt; font-family: Arial;">Activity Appointment</p>
                  </div>
              </div>
              <h2 style="line-height: 20px; font-size: 12pt; margin-top: 18px; padding: 6px 0;">在线选座测试</h2>
              <p style="line-height: 18px; font-size: 10pt; padding: 6px 0;">上海市广中西路777弄</p>
              <p style="line-height: 18px; font-size: 10pt; padding: 6px 0;">时间：2015-12-12 8:00-12:00</p>
              <div style="width: 100%; height: 92px; padding: 6px 0; position: relative;">
                  <p style="line-height: 18px; font-size: 10pt; padding: 6px 0;">座位：4排6座</p>
                  <p style="line-height: 15px; font-size: 8pt; padding-top: 34px;">票类：网络票</p>
                  <p style="line-height: 15px; font-size: 8pt; padding-top: 4px;">取票时间：2015-12-23 13:50</p>
               <%--   <img src="image/ewm-print.png" width="92" height="92" style="position: absolute; bottom: 0; right: 0;"/>--%>
                  <div id='qrcodeImg' data-val=""></div>
              </div>
          </div>
          <div style="height: 25px; line-height: 25px; text-align: center; background: #9a9a9a; color: #ffffff; font-size: 10px;">更多精彩内容请访问：http://www.wenhuayun.cn</div>
      </div>
</div>
 </div>
      <!--打印活动票据 end-->
  </div>
  <div class="ticket-part ticket-page" id="ticketPage" style="display: none;">
    <iframe src="${path}/ticketActivity/ticketActivityList.do" frameborder="0" width="100%" height="100%" id="ticket-iframe" style="background: transparent;"></iframe>
  </div>
</div>
</div>
</body>
</html>