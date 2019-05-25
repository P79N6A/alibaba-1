/**
 * Created by cj on 2015/7/8.
 */

//String扩展，兼容ie8
String.prototype.trim = function ()
{
    return this.replace(/(^\s*)|(\s*$)/g, "");
}
String.prototype.ltrim = function ()
{
    return this.replace(/(^\s*)/g, "");
}
String.prototype.rtrim = function ()
{
    return this.replace(/(\s*$)/g, "");
}

window.onload = function(){
    //var editor = CKEDITOR.replace( 'roomFacility' );
}

$(function(){
    if($("input[name='roomIsFree']:checked").val() == "yes"){
        $(".extra").css("display", "inline-block");
    }

    $(".room-time-set input[type=text]").on("blur",function(){
        var $this = $(this);
        var timePeriod = $(this).val();
        var timePeriodReg = /^\d{2}:\d{2}-\d{2}:\d{2}$/;
        if(timePeriod.trim() != "" && timePeriod.trim() != "请设置时间段"){
            if(!timePeriodReg.test($.trim(timePeriod))){
                $(this).focus();
            }else {
                if (!validateTime(timePeriod)) {
                    $(this).focus();
                }else{
                    var currTime = timeToArray(timePeriod);
                    var prevTimePeriod = "",nextTimePeriod = "",prevTimeVal="",nextTimeVal="";
                    var currIndex = $this.parent().index();
                    var currParent = $this.parent();
                    var currParentTr = currParent.parent("tr");
                    var totalTdLen = $this.parent().siblings().length;

                    for(var i = (currIndex-1); i > 0; i--){
                        prevTimeVal = currParentTr.find("td").eq(i).find("input[type=text]").val();
                        if(prevTimeVal != "" &&  prevTimeVal != "请设置时间段"){
                            prevTimePeriod = prevTimeVal;
                            break;
                        }
                    }

                    for(var i = (currIndex+1); i <= totalTdLen; i++){
                        nextTimeVal = currParentTr.find("td").eq(i).find("input[type=text]").val();
                        if(nextTimeVal != "" &&  nextTimeVal != "请设置时间段"){
                            nextTimePeriod = nextTimeVal;
                            break;
                        }
                    }

                    var prevTime = prevTimePeriod == "" ? "" : timeToArray(prevTimePeriod);
                    var nextTime = nextTimePeriod == "" ? "" : timeToArray(nextTimePeriod);
                    if(prevTime != ""){
                        if(Number(currTime.startStr) <= Number(prevTime.endStr)){
                            $this.focus();
                            //alert("开始时间小于或等于上一场的结束时间");
                        }
                    }
                    if(nextTime != ""){
                        if(Number(currTime.endStr) >= Number(nextTime.startStr)){
                            $this.focus();
                            //alert("时间时间大于或等于下一场的开始时间");
                        }
                    }
                }
            }
        }
    });
});

function timeToArray(value){
    var valArr = value.split("-");
    var startArr = valArr[0].split(":");
    var endArr = valArr[1].split(":");
    var startStr = valArr[0].replace(":", "");
    var endStr = valArr[1].replace(":", "");
    return {"startStr": startStr, "endStr": endStr}
}

function validateTime(value){
    var valArr = value.split("-");
    var startArr = valArr[0].split(":");
    var endArr = valArr[1].split(":");
    var startStr = valArr[0].replace(":", "");
    var endStr = valArr[1].replace(":", "");
    if(startArr[0] <= 23 && endArr[0] <=23 && startArr[1] <=59 && endArr[1] <= 59 && startStr < endStr){
        return true;
    }else{
        //alert("时间格式不符合！");
        return false;
    }
}

function checkTimePeriod(){
    var checkResult = true;
    $(".room-time-set input[type=text]").each(function(){
        var timePeriod = $(this).val();

        var timePeriodReg = /^\d{2}:\d{2}-\d{2}:\d{2}$/;
        if(timePeriod.trim() != "" &&  timePeriod.trim() != "请设置时间段" && !timePeriodReg.test(timePeriod.trim())){
            $(this).focus();
            checkResult = false;
            return;
        }
    });
    return checkResult;
}

function checkSave(){
    var result = true;

    var roomName = $("#roomName").val();
    var roomPicUrl = $("#roomPicUrl").val();
    var roomNo = $("#roomNo").val();
    var roomConsultTel = $("#roomConsultTel").val();
    var roomFee = $("#roomFee").val();
    var roomArea = $("#roomArea").val();
    var roomCapacity = $("#roomCapacity").val();
    var roomTag = $("#roomTag").val();
    
    var commonTag=$("#commonTag").val();
    var childTag=$("#childTag").val(); 

    if(roomName.trim() == ""){
        removeMsg("roomNameLabel");
        appendMsg("roomNameLabel", "请填写活动室名称!");
        $('#roomName').focus();
        return false;
    }else{
        removeMsg("roomNameLabel");
    }

    if(roomPicUrl.trim() == ""){
        removeMsg("roomPicUrlLabel");
        appendMsg("roomPicUrlLabel", "请上传活动室封面!");
        $('#roomPicUrlMessage').focus();
        return false;
    }else{
        removeMsg("roomPicUrlLabel");
    }
    
    if(roomTag==undefined||roomTag==""){
        removeMsg("roomTagLabel");
        appendMsg("roomTagLabel","请选择活动室类型标签!");
        $('#roomTagMessage').focus();
        return;
    }else{
        removeMsg("roomTagLabel");
    }
    
    if(!commonTag && ! childTag){
        removeMsg("commonTagLabel");
        appendMsg("commonTagLabel", "请选择标签!");
        $('#commonTagMessage').focus();
        return false;
    }else{
        removeMsg("commonTagLabel");
    }
    
    var roomVenueId = $('#roomVenueId').val();
    
    var loc_venue = $('#loc_venue').val();
    //所属场所
    if (loc_venue) {

        $('#roomVenueId').val(loc_venue);
    }
    
    roomVenueId = loc_venue;

    if (roomVenueId == undefined || roomVenueId == "") {

        removeMsg("venueIdLabel");
        appendMsg("venueIdLabel", "请选择场馆!");
        $('#venueId').focus();

        return;
    } else {
        removeMsg("venueIdLabel");
    }  

    	 

    if(roomNo.trim() == "" || roomNo.trim() == "活动室具体楼层门牌号"){
        removeMsg("roomNoLabel");
        appendMsg("roomNoLabel", "请填写活动室位置!");
        $('#roomNo').focus();
        return false;
    }else{
        removeMsg("roomNoLabel");
    }

    if(roomConsultTel.trim() == ""){
        removeMsg("roomConsultTelLabel");
        appendMsg("roomConsultTelLabel", "请填写活动室咨询电话!");
        $('#roomConsultTel').focus();
        return false;
    }/*else if(!is_mobile(roomConsultTel)){
        removeMsg("roomConsultTelLabel");
        appendMsg("roomConsultTelLabel","请正确填写活动室咨询电话!");
        $('#roomConsultTel').focus();
        return false;
    }*/else{
        removeMsg("roomConsultTelLabel");
    }

    var checkResult = checkTimePeriod();
    if(!checkResult){
        return false;
    }

    if($("input[name='roomIsFree']:checked").val() == undefined){
        removeMsg("roomIsFreeLabel");
        appendMsg("roomIsFreeLabel", "请勾选是否收费!");
        $("input[name='roomIsFree']").focus();
        return false;
    }else{
        removeMsg("roomIsFreeLabel");
        if($("input[name='roomIsFree']:checked").val() == "yes"){
            if(roomFee.trim() == ""){
                removeMsg("roomIsFreeLabel");
                appendMsg("roomIsFreeLabel", "请填写活动室费用!");
                $('#roomFee').focus();
                return false;
            }
        }else{
            removeMsg("roomIsFreeLabel");
        }
    }

    if(roomArea.trim() == ""){
        removeMsg("roomAreaLabel");
        appendMsg("roomAreaLabel", "请填写活动室面积!");
        $('#roomArea').focus();
        return false;
    }else if(!/^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$/.test(roomArea)){
        removeMsg("roomAreaLabel");
        appendMsg("roomAreaLabel", "请正确填写活动室面积!");
        $('#roomArea').focus();
        return false;
    }else{
        removeMsg("roomAreaLabel");
    }

    if(roomCapacity.trim() == ""){
        removeMsg("roomCapacityLabel");
        appendMsg("roomCapacityLabel", "请填写可容纳人数!");
        $('#roomCapacity').focus();
        return false;
    }else{
        removeMsg("roomCapacityLabel");
    }

    var reg=/^[1-9]([0-9]*)$/;
    if(!reg.test(roomCapacity.trim())) {
        removeMsg("roomCapacityLabel");
        appendMsg("roomCapacityLabel", "可容纳人数必须为数字!");
        $('#roomCapacity').focus();
        return false;
    }else {
        removeMsg("roomCapacityLabel");
    }
    
    return result;
}

/**
 * 设置默认值
 */
function setDefaultVal(){
    //设置单选框选中情况
    var roomIsFree = $("input[name='roomIsFree']:checked").val();
    if(roomIsFree == "yes"){
        //2为收费
        $("input[name='roomIsFree']").val(2);
    }else{
        //1为免费
        $("input[name='roomIsFree']").val(1);
    }
    //富文本
    //$('#roomFacility').val(CKEDITOR.instances.roomFacility.getData());

    //时间日期按格式赋值以供后台解析处理
    var allRoomDayArr = [];
    var roomDayArr = ["roomDayMondayTr","roomDayTuesdayTr","roomDayWednesdayTr","roomDayThursdayTr","roomDayFridayTr","roomDaySaturdayTr","roomDaySundayTr"];
    $.each(roomDayArr,function(i,item){
        allRoomDayArr.push(getRoomDayData(item));
    });
    var allRoomDayStr = allRoomDayArr.join("*")
    $("#allRoomDayStr").val(allRoomDayStr);
}

/**
 * 根据页面中日期部分的TR的ID获取TR中类型为文本的文本框数据，多个之间用 逗号 分割
 * @param trId
 * @returns {string}
 */
function getRoomDayData(trId){
    var roomDayStr = "";
    $("#"+ trId +" td").each(function(index,val){
        //index>0是为了过滤掉第一个td
        if(index>0){
            var timeId = $(this).attr("id");
            var period = $(this).find("input[type='text']").val();
            if(period.trim() == "" || period.trim() == "请设置时间段") {
                //OFF代表时间段关闭
                roomDayStr = roomDayStr + timeId + "_" + "OFF" + ",";
            }else{
                roomDayStr = roomDayStr + timeId + "_" + period  + ",";
            }
        }
    });
    return roomDayStr.substring(0,roomDayStr.length-1);
}