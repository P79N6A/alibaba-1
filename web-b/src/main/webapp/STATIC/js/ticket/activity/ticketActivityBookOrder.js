/**
 * Created by yujinbing on 2015/12/24.
 */

function doSubmit(){
    var activityId = $("#activityId").val();
    var seatValues = $("#seatValues").val();
    var eventDateTime = $("#eventDateTime").val();
    $.post("../ticketActivity/saveTicketActivityOder.do", $("#bookOrder").serialize() , function(data) {
        var map = eval(data);
        if (map.success=='Y') {
            var activityOrderId = map.msg;
            location.href="../ticketActivity/saveTicketActivityOderOver.do?activityId="+activityId + "&activityOrderId=" + activityOrderId + "&seatValues=" + encodeURI(encodeURI(seatValues)) +"&eventDateTime=" + eventDateTime;
        } else {
            $("#btn-tip-loading").remove();
            if (map.msg == 'activityEmpty') {
                dialogAlert("提示", "活动不能为空!");
            } else if (map.msg == 'seatEmpty') {
                dialogAlert("提示", "请选择座位!");
            } else if (map.msg == 'more') {
                dialogAlert("提示", "购票数不能超过5张!");
            }  else if (map.msg == 'login') {
                dialogAlert("提示", "请先登录!");
            } else if (map.msg == 'overtime') {
                dialogAlert("提示", "不在可预订时间内!");
            } else if (data.msg == 'overCount') {
                dialogAlert("提示", "剩余票数不够!");
            } else if (data.msg == 'errorCount') {
                dialogAlert("提示", "请输入正确的票数!");
            }else {
                dialogAlert("提示", "预订失败:" + map.msg + "!");
            }

        }
    });
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