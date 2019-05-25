/**
 * Created by yujinbing on 2015/12/24.
 */
$.ajaxSettings.async = false; 	//同步执行ajax
function doSubmit(){
    var activityId = $("#activityId").val();
    var seatValues = $("#seatValues").val();
    var eventDateTime = $("#eventDateTime").val();
    
    $.post("../wechatActivity/wcActivityOrder.do", $("#bookOrder").serialize() , function(data) {
    	var result=eval(data);
    	if (result.status == "1") {
    		if (result.data.length==10) {
    			var orderValidateCode = result.data;
    		
                location.href="../ticketActivity/saveTicketActivityOderOver.do?activityId="+activityId +"&orderValidateCode=" + orderValidateCode + "&seatValues=" + seatValues +"&eventDateTime=" + eventDateTime;
    		}
        } 
    	else if(result.status == "0") {
    		
    		if(result.msg.errmsg)
           		 dialogAlert("提示", result.msg.errmsg);
    		else
    			 dialogAlert("提示", "下单失败，连接超时！");
        }else if (result.status == 500) {
            window.location.href = "../../../../timeOut.html";
        } 
    	
    }, "json");
}

$(function() {
    var activityId = $("#activityId").val();
   var activityName = $("#activityName").val();
    //判断用户是否已经提交订单
    if ($("#orderNumber").val() != undefined && $("#orderNumber").val() != '') {
        var formData = {orderNumber:$("#orderNumber").val()};
        $.post("../frontActivity/queryOrderNumber.do", formData , function(data) {
            if (data > 0) {
                location.href="../ticketActivity/saveTicketActivityOderOver.do?activityId="+ activityId +"&activityName=" + encodeURI(encodeURI(activityName));
    }
        });
    }

    $(".confirm_order").on("click", function(){
        var html = '<div class="btn-loading" id="btn-tip-loading"><h3>正在提交，请稍等...</h3><div class="img"></div></div>';
        $(this).parent().append(html);
        return false;
    });

});

//get Img
$(function() {
    var imgUrl = $("#iconUrl").attr("iconUrl");
    imgUrl= getImgUrl(imgUrl);
    $("#iconUrl").attr("src", imgUrl);
});