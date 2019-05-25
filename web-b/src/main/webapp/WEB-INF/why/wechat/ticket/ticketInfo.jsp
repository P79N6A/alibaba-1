<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <!-- <title>票务信息</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/ticket.css"/>
    <script type="text/javascript">
    </script>
    
    <style>
    	html,body,.main{height:100%}
        .content {padding-top: 100px;padding-bottom: 18px;}
    </style>
    <script type="text/javascript">

        $(function () {
            var code='${code}';
            var asm = new Date().getTime();
            $.post("${path}/wechatcheckTicket/checkOrderNumValid.do?asm="+asm,{orderValidateCode:code},function(data) {
                var json = $.parseJSON(data);
                if (json!=undefined&&json.status == "0") {

                    $('#activityName').html(json.data[0].activityName);
                    $('#address').html(json.data[0].activityAddress);
                    $('#activityTime').html(json.data[0].activityTime);
                    $('#personCount').html(json.data[0].orderVotes);
                    $('#userName').html(json.data[0].userName);
                    $('#phone').html(json.data[0].orderPhotoNo);
                    $('#orderValidateCode').val(json.data[0].orderValidateCode);
                    $('#userId').val(json.data[0].userId);
                    $('#orderPayStatus').val(json.data[0].orderPayStatus);
                    $('#seats').val(json.data[0].activitySeats);
                    var statInfo=json.data[0].activitySeats;
                    var statStatus=json.data[0].seatStatus;
                    var count=0;
                    var validSeat="";
                    if(statInfo!=undefined&&statStatus!=undefined){
                        if(statInfo.indexOf("_")!=-1){
                            statInfo =statInfo.split(",");
                            statStatus=statStatus.split(",");
                            var seat =[];
                            for(var i=0;i<statInfo.length-1;i++) {
                                if (statStatus[i] != undefined && statStatus[i] != "2") {
                                    count+=+1;
                                    validSeat+=statInfo[i]+",";
                                var code = statInfo[i].split("_");
                                if (code!=undefined&&code[0] != undefined && code[1] != undefined) {
                                    seat.push(code[0] + "排" + code[1] + "座" + " ");
                                }
                            }
                            }
                            $('#seatInfo').html(seat.join(""));
                            $('#personCount').html(count);
                            $('#seatInfoLabel').show();
                            $('#seats').val(validSeat);
                        }else{
                            $('#seatInfoLabel').hide();
                        }
                    }
                }
                else if (json!=undefined&&json.status == "14112") {
                    dialogAlert('系统提示',json.data);
                } else if (json!=undefined&&json.status == "14113") {
                    dialogAlert('系统提示', json.data);
                }
                else {
                   dialogAlert('系统提示', "验证码有误!");
                }
            });
        });

        function updateOrderStatus(){
            var asm = new Date().getTime();
            $.post("${path}/wechatcheckTicket/updateOrderNumStatus.do?asm="+asm,$('#orderFormInfo').serialize(), function(data) {
                var json = $.parseJSON(data);
                if(json!=undefined&&json.status == "0"){
                    dialogAlert('系统提示',json.data);
                }
                else {
                    dialogAlert('系统提示',json.data);
                }
            });
        }

    </script>
</head>
<body class="body">
<form  id="orderFormInfo" name="orderFormInfo" style="height: 100%">
   <input type="hidden" id="userId" name="userId"/>
   <input type="hidden" id="orderValidateCode" name="orderValidateCode"/>
   <input type="hidden" id="orderPayStatus" name="orderPayStatus"/>
    <input type="hidden" id="seats"  name="seats"/>

<div class="main info-bg">
    <div class="info-content">
        <div class="info-list">
            <ul>
                <li>
                    <label>活动</label>
                    <span id="activityName"></span>
                    <div style="clear: both;"></div>
                </li>
                <li>
                    <label>地址</label>
                    <span id="address"> </span>
                    <div style="clear: both;"></div>
                </li>
                <li>
                    <label>场次</label>
                    <span id="activityTime"></span>
                    <div style="clear: both;"></div>
                </li>
                <li id="seatInfoLabel" style="display: none">
                    <label>座位</label>
                    <span id="seatInfo"></span>
                    <div style="clear: both;"></div>
                </li>
                <li>
                    <label>人数</label>
                    <span id="personCount"></span>
                    <div style="clear: both;"></div>
                </li>
                <li>
                    <label>预定人昵称</label>
                    <span id="userName"></span>
                    <div style="clear: both;"></div>
                </li>
                <li>
                    <label>手机</label>
                    <span id="phone"></span>
                    <div style="clear: both;"></div>
                </li>
            </ul>
        </div>
        <div class="info-sure" onclick="updateOrderStatus()">
            <div class="info-sure-mi">
                <div class="info-sure1">
                    <img src="${path}/STATIC/wechat/image/sure.jpg" />
                </div>
                <div class="info-sure2">
                    <p>确认使用</p>
                </div>
                <div style="clear: both;"></div>
            </div>
        </div>
    </div>
</div>
</form>
</body>
</html>