<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/ticketPad/commonFramePad.jsp" %>
    <!-- <title>票务信息</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/ticket.css"/>
    <script type="text/javascript">
    </script>
    
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
                	showDialog(json.data);
                } else if (json!=undefined&&json.status == "14113") {
                	showDialog(json.data);
                }
                else {
                	showDialog("验证码有误!");
                }
            });
        });

        function updateOrderStatus(){
            var asm = new Date().getTime();
            $.post("${path}/wechatcheckTicket/updateOrderNumStatus.do?asm="+asm,$('#orderFormInfo').serialize(), function(data) {
                var json = $.parseJSON(data);
                if(json!=undefined&&json.status == "0"){
                	showDialog(json.data);
                }
                else {
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
	<form  id="orderFormInfo" name="orderFormInfo" style="height: 100%">
	    <input type="hidden" id="userId" name="userId"/>
	    <input type="hidden" id="orderValidateCode" name="orderValidateCode"/>
	    <input type="hidden" id="orderPayStatus" name="orderPayStatus"/>
	    <input type="hidden" id="seats"  name="seats"/>
	
		<div class="main ipad" style="overflow: auto;">
			<div class="header">
				<p>文化云自助验票</p>
			</div>
			<div class="content" style="margin: 250px 100px 100px 100px;">
				<div class="ipad-active">
					<ul>
						<li class="border-bottom">
							<label>活动</label>
							<span id="activityName"></span>
							<div style="clear: both;"></div>
						</li>
						<li class="border-bottom">
							<label>地址</label>
	                    	<span id="address"> </span>
							<div style="clear: both;"></div>
						</li>
						<li class="border-bottom">
							<label>场次</label>
	                    	<span id="activityTime"></span>
							<div style="clear: both;"></div>
						</li>
						<li class="border-bottom" style="display: none">
							<label>座位</label>
	                    	<span id="seatInfo"></span>
							<div style="clear: both;"></div>
						</li>
						<li class="border-bottom">
							<label>人数</label>
	                    	<span id="personCount"></span>
							<div style="clear: both;"></div>
						</li>
						<li class="border-bottom">
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
				<div class="ipad-user" style="margin-top: 150px;">
					<button type="button" onclick="updateOrderStatus()">确认</button>
				</div>
				<div class="ipad-middle-pop" style="display: none;">
					<img src="${path}/STATIC/wechat/image/success.png" style="margin-top: 60px;" />
					<p style="margin:0 20px;"></p>
					<div class="ipad-pop-button" onclick="$('.ipad-middle-pop').hide();">确认</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>