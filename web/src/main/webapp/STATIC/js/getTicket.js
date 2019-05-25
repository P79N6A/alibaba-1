function QueryString(item){
    var sValue=location.search.match(new RegExp("[\?\&]"+item+"=([^\&]*)(\&?)","i"));
    return sValue?sValue[1]:sValue
}

//获取订单信息
function getTicket(orderCode){
    var orderValidateCode=$(".txt").val();
    
    orderValidateCode=orderValidateCode.replace(/\s/gi,'');
    
    var $parent = document;
    if(orderCode!=null){
        orderValidateCode=orderCode;
        $parent = window.parent.document;
    }
    var path = $("#path", $parent).val();
    var area=QueryString('area');
    var ticket="<div><div class='tit'>"+"<span class='num'></span><span class='status'>状态：<em class='orange'></em></span></div>"+"<h2></h2>"+"<p id='address'></p>"+"<p id='time'></p>"+"<p class='seat'>座位：</p>"+"<p id='photoNo'></p><hr/><span id='submit'></span><input type='hidden' id='orderValidateCode'/></div>";
    var $dom=$(ticket);
    if(orderCode=="1234567890"){
        console.log(orderCode);
    }else{
        $.ajax({
            type:"post",
            url:path+"/ticket/orderDetails.do",
            data:{"orderValidateCode":orderValidateCode,"area":area},
            dataType: "json",
            success:function(data){
                var str="";
                if(data.status==0){
                    //显示活动订单信息
                    for(var i in data.data){
                        $dom.find("#orderValidateCode").attr("value",data.data[i].orderValidateCode);
                        $dom.find(".num").html("订单编号："+data.data[i].orderNumber);
                        //1-未出票 2-已取消 3-已出票 4-已验票 5-已失效
                        if(data.data[i].orderPayStatus==1){
                            $dom.find(".orange").html("未出票");
                            $dom.find("#submit").html("<input type='submit' value='确认取票' class='btn-confirm' onclick='activityPrintPiao();'/>");
                        }else if(data.data[i].orderPayStatus==2){
                            $dom.find(".orange").html("已取消");
                        }else if(data.data[i].orderPayStatus==3){
                            $dom.find(".orange").html("已出票");
                        }else if(data.data[i].orderPayStatus==4){
                            $dom.find(".orange").html("已验票");
                        }else{
                            $dom.find(".orange").html("已失效");
                        }
                        $dom.find("h2").html("活动："+data.data[i].activityName);
                        $dom.find("#address").html("地址："+data.data[i].activityAddress);
                        $dom.find("#time").html("场次："+data.data[i].activityTime);
                        //获取座位信息
                        var seatArray = [];
                        seatArray=data.data[i].seats.split(",");
                        for(var j=0; j < seatArray.length-1; j++){
                            $dom.find(".seat").append("<a data-val='"+data.data[i].activitySeats.split(",")[j]+"' class='cur'>"+seatArray[j].toString()+"</a>");
                        }
                        $dom.find(".seat").after("<p id='peopleNum'>人数："+data.data[i].orderVotes+"</p>");
                        $dom.find(".seat").before(" <p id='validateCode'>取票码："+data.data[i].orderValidateCode+"</p>");
                        $dom.find("#photoNo").html("手机号："+data.data[i].orderPhotoNo);
                        str+=$dom.html();
                    }
                }else if(data.status==1){
                    for(var i in data.data) {
                        $dom.find("#orderValidateCode").attr("value", data.data[i].validCode);
                        //显示活动室订单信息
                        $dom.find(".num").html(data.data[i].roomOrderNo);
                        //1未出票，2 取消,3 进场 4.已删除 5.已出票 6.已失效
                        if (data.data[i].orderStatus == 1) {
                            $dom.find(".orange").html("未使用");
                            $dom.find("#submit").html("<input type='submit' value='确认取票' class='btn-confirm' onclick='roomPrintPiao();'/>");
                        } else if (data.data[i].orderStatus == 2) {
                            $dom.find(".orange").html("已取消");
                        } else if (data.data[i].orderStatus == 3) {
                            $dom.find(".orange").html("已使用");
                        }else if(data.data[i].orderStatus == 4){
                            $dom.find(".orange").html("已删除");
                        }else if(data.data[i].orderStatus == 5){
                            $dom.find(".orange").html("已出票");
                        } else {
                            $dom.find(".orange").html("已失效");
                        }
                        $dom.find("h2").html("活动室:" + data.data[i].roomName);
                        $dom.find("#address").html("地址:" + data.data[i].venueAddress);
                        $dom.find("#time").html("场次:" + data.data[i].roomTime);
                        $dom.find(".seat").html("团体:" + data.data[i].tuserTeamName);
                        $dom.find("#photoNo").html("手机号：" + data.data[i].orderTel);
                        str+=$dom.html();
                    }
                }else  if(data.status==14112 || data.status==14113){
                    $("h2", $parent).hide();
                    $(".error-msg", $parent).html(data.data);
                    $(".error-msg", $parent).show();
                    return false;
                }
                $(".ticket-info", $parent).html(str);
                $(".ticket-info", $parent).show();
                $(".get-ticket", $parent).hide();
            }
        });
    }


}
