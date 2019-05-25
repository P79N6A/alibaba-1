

$(function(){
    selectAllOrNot();
    // 全选
    $("#selectAll").bind("click", function () {
        if($(this).prop("checked")){
            $(".td-checkbox input[type='checkbox']").each(function(){
                $(this).prop("checked",true);
            });
        }else{
            $(".td-checkbox input[type='checkbox']").each(function(){
                $(this).prop("checked",false);
            });
        }
    });

    //控制全选、反选
    $(".td-checkbox input[type='checkbox']").bind("click",function(){
        selectAllOrNot();
    });


    function selectAllOrNot(){
        var result = false;
        $(".td-checkbox input[type='checkbox']").each(function(){
            var value = $(this).val();
            if(value == 1 && !$(this).prop("checked")){
                result = true;
            }
        });
        if(result){
            $("#selectAll").prop("checked",false);
        }else{
            $("#selectAll").prop("checked",true);
        }
    }
});

/**
 * 检查星期是否全部没有选择
 * @returns {boolean}
 */
function checkSelected(){
    var count = 0;
    $(".td-checkbox input[type='checkbox']").each(function(){
        var value = $(this).val();
        if(value == 1 && !$(this).attr("checked")){
            count = count + 1;
        }
    });
    if(count == 7){
        return false;
    }else{
        return true;
    }
}

//选择关键字标签时，赋值
function setVenueTag(value,id) {

    var tagIds = $("#"+id).val();
    if (tagIds != '') {
        var ids = tagIds.substring(0, tagIds.length - 1).split(",");
        var data = '', r = true;
        for (var i = 0; i < ids.length; i++) {
            if (ids[i] == value) {
                r = false;
            } else {
                data = data + ids[i] + ',';
            }
        }
        if (r) {
            data += value + ',';
        }
        $("#"+id).val(data);
    } else {
        $("#"+id).val(value + ",");
    }
}

//标签选择时更改样式
function tagSelect(id) {
    /* tag标签选择 */
    $('#'+id).find('a').click(function() {
        if ($(this).hasClass('cur')) {
            $(this).removeClass('cur');
        } else {
            $(this).addClass('cur');
        }
    });
}

/**
 * 单选
 * @param value
 * @param id
 */
function setVenueSingle(value,id){
    $("#"+id).val(value);
    $('#'+id).find('a').removeClass('cur');
}

/**
 * 单选
 * @param id
 */
function tagSelectSingle(id) {
    /* tag标签选择 */

    $('#'+id).find('a').click(function() {
        $('#'+id).find('a').removeClass('cur');
        $(this).addClass('cur');
    });
}

//添加场馆数据时进行数据校验
function checkSave(){
    var result = true;

    var venueName = $("#venueName").val();
    var venueStars = $("#venueStars").val();
    var venueIconUrl = $("#venueIconUrl").val();
    var venueParentDeptId = $("#venueParentDeptId").val();
    var venueType = $("#venueType").val();
    var commonTag=$("#commonTag").val();
    var childTag=$("#childTag").val(); 
    
    //var venueCrowd = $("#venueCrowd").val();
    var venueMood = $("#venueMood").val();
    var venueTheme = $("#venueTheme").val();
    //var venueLinkman = $("#venueLinkman").val();
    var venueMobile = $("#venueMobile").val();
    var venueTel = $("#venueTel").val();

    var venueOpenHour = $("#venueOpenHour").val();
    var venueOpenMin = $("#venueOpenMin").val();
    var venueEndHour = $("#venueEndHour").val();
    var venueEndMin = $("#venueEndMin").val();

    var venueArea = $("#loc_town").find("option:selected").val()+","+$("#loc_town").find("option:selected").text();

    var venueLon = $("#venueLon").val();
    var venueLat = $("#venueLat").val();
    var venueAddress = $("#venueAddress").val();
    var venuePrice = $("#venuePrice").val();
    /********权限标签必选  2016.04.06  ******/
    var venueDeptLable = $("#venueDeptLable").val();


    /********权限标签必选  2015.04.06  ******/
    if(venueName.trim() == ""){
        removeMsg("venueNameLabel");
        appendMsg("venueNameLabel", "请填写场馆名称!");
        $('#venueName').focus();
        return false;
    }else{
        removeMsg("venueNameLabel");
    }

  /**  if(venueStars.trim() == ""){
        removeMsg("venueStarsLabel");
        appendMsg("venueStarsLabel", "请选择场馆星级!");
        $('#venueStars').focus();
        return false;
    }else{
        removeMsg("venueStarsLabel");
    }**/
    
    if(venueIconUrl.trim() == ""){
        removeMsg("venueIconUrlLabel");
        appendMsg("venueIconUrlLabel", "请上传场馆封面!");
        $('#venueIconUrl').focus();
        return false;
    }else{
        removeMsg("venueIconUrlLabel");
    }

    if(venueParentDeptId.trim() == ""){
        removeMsg("userDeptIdLable");
        appendMsg("userDeptIdLable", "请选择组织机构!");
        $("#parentIframe").focus();
        return false;
    }else{
        removeMsg("userDeptIdLable");
    }
    
    if($("input[name='venueDeptLable']:checked").val() == undefined){
        removeMsg("venueDeptLableId");
        appendMsg("venueDeptLableId", "请选择权限标签!");
        $("input[name='venueDeptLable']").focus();
        return false;
    }else{
        removeMsg("venueDeptLableId");
    }

    if(venueArea.trim() == ",区"){
        removeMsg("venueLocLabel");
        appendMsg("venueLocLabel", "请填写场馆省市区!");
        $('#venueLocMessageLabel').focus();
        return false;
    }else{
        removeMsg("venueLocLabel");
    }

    if(venueMood.trim() == ""){
        removeMsg("venueMoodLabel");
        appendMsg("venueMoodLabel", "请选择场馆热区标签!");
        $('#venueMoodMessage').focus();
        return false;
    }else{
        removeMsg("venueMoodLabel");
    }

    if(venueType.trim() == ""){
        removeMsg("venueTypeLabel");
        appendMsg("venueTypeLabel", "请选择场馆类型标签!");
        $('#venueTypeMessage').focus();
        return false;
    }else{
        removeMsg("venueTypeLabel");
    }
    
    /*if(!commonTag && !childTag){
        removeMsg("commonTagLabel");
        appendMsg("commonTagLabel", "请选择标签!");
        $('#commonTagMessage').focus();
        return false;
    }else{
        removeMsg("commonTagLabel");
    }*/
    
  /**  if(childTag.trim() == ""){
        removeMsg("childTagLabel");
        appendMsg("childTagLabel", "请选择分类标签!");
        $('#childTagMessage').focus();
        return false;
    }else{
        removeMsg("childTagLabel");
    }**/
    
    if(venueAddress.trim() == ""){
        removeMsg("venueAddressLabel");
        appendMsg("venueAddressLabel", "请填写场馆地址!");
        $('#venueAddress').focus();
        return false;
    }else{
        removeMsg("venueAddressLabel");
    }

    var mapReg = /^[-\+]?\d+(\.\d+)?$/;
    if(venueLon.trim() == ""){
        removeMsg("venueMapLabel");
        appendMsg("venueMapLabel", "请填写场馆X坐标!");
        $('#venueLon').focus();
        return false;
    }else{
        removeMsg("venueMapLabel");
        if(!mapReg.test(venueLon.trim())){
            removeMsg("venueMapLabel");
            appendMsg("venueMapLabel", "请拾取正确的X坐标!");
            $('#venueLon').focus();
            return false;
        }else{
            removeMsg("venueMapLabel");
        }
    }

    if(venueLat.trim() == ""){
        removeMsg("venueMapLabel");
        appendMsg("venueMapLabel", "请填写场馆Y坐标!");
        $('#venueLat').focus();
        return false;
    }else{
        removeMsg("venueMapLabel");
        if(!mapReg.test(venueLat.trim())){
            removeMsg("venueMapLabel");
            appendMsg("venueMapLabel", "请拾取正确的Y坐标!");
            $('#venueLat').focus();
            return false;
        }else{
            removeMsg("venueMapLabel");
        }
    }


    if(venueMobile.trim() == ""){
        removeMsg("venueMobileLabel");
        appendMsg("venueMobileLabel", "请填写场馆联系电话!");
        $('#venueMobile').focus();
        return false;
    }else{
        removeMsg("venueMobileLabel");
    }


    if(venueOpenHour.trim() == "时" || venueOpenHour.trim() == ""){
        removeMsg("venueOpenTimeLabel");
        appendMsg("venueOpenTimeLabel", "请填写开放时间!");
        $('#venueOpenTimeMessage').focus();
        return false;
    }else{
        removeMsg("venueOpenTimeLabel");
    }

    if(venueOpenMin.trim() == "分" || venueOpenMin.trim() == ""){
        removeMsg("venueOpenTimeLabel");
        appendMsg("venueOpenTimeLabel", "请填写开放时间!");
        $('#venueOpenTimeMessage').focus();
        return false;
    }else{
        removeMsg("venueOpenTimeLabel");
    }

    if(venueEndHour.trim() == "时" || venueEndHour.trim() == ""){
        removeMsg("venueEndTimeLabel");
        appendMsg("venueEndTimeLabel", "请填写结束时间!");
        $('#venueEndTimeMessage').focus();
        return false;
    }else{
        removeMsg("venueEndTimeLabel");
    }

    if(venueEndMin.trim() == "分" || venueEndMin.trim() == ""){
        removeMsg("venueEndTimeLabel");
        appendMsg("venueEndTimeLabel", "请填写结束时间!");
        $('#venueEndTimeMessage').focus();
        return false;
    }else{
        removeMsg("venueEndTimeLabel");
    }

    var intOpenHour = parseInt(venueOpenHour,10);
    var intEndHour = parseInt(venueEndHour,10);
    var intOpenMin = parseInt(venueOpenMin,10);
    var intEndMin = parseInt(venueEndMin,10);
    if(intOpenHour > intEndHour){
        removeMsg("venueEndTimeLabel");
        appendMsg("venueEndTimeLabel", "结束时间不能早于开始时间!");
        $('#venueEndMin').focus();
        return false;
    }else if(intOpenHour == intEndHour){
        if(intOpenMin > intEndMin){
            removeMsg("venueEndTimeLabel");
            appendMsg("venueEndTimeLabel", "结束时间不能早于开始时间!");
            $('#venueEndMin').focus();
            return false;
        }else if(intOpenMin == intEndMin){
            removeMsg("venueEndTimeLabel");
            appendMsg("venueEndTimeLabel", "结束时间不能与开始时间相同!");
            $('#venueEndMin').focus();
            return false;
        }else{
            removeMsg("venueEndTimeLabel");
        }
    }else{
        removeMsg("venueEndTimeLabel");
    }

    if(venueTel != undefined && venueTel.trim() != ""){
        if(!is_mobile(venueTel)){
            removeMsg("venueTelLabel");
            appendMsg("venueTelLabel","请正确填写场馆电话!");
            $('#venueTel').focus();
            return false;
        }else{
            removeMsg("venueTelLabel");
        }
    }

    if($("input[name='venueIsFree']:checked").val() == undefined){
        removeMsg("venueIsFreeLabel");
        appendMsg("venueIsFreeLabel", "请勾选是否收费!");
        $("input[name='venueIsFree']").focus();
        return false;
    }else{
        removeMsg("venueIsFreeLabel");
        if($("input[name='venueIsFree']:checked").val() == "yes" && venuePrice.trim() == ""){
            removeMsg("venueIsFreeLabel");
            appendMsg("venueIsFreeLabel", "请填写场馆费用!");
            $('#venuePrice').focus();
            return false;
        }else{
            removeMsg("venueIsFreeLabel");
        }
    }
   
    if($("input[name='venueHasMetro']:checked").val() == undefined){
        removeMsg("venueHasMetroLabel");
        appendMsg("venueHasMetroLabel", "请勾选有无地铁!");
        $("input[name='venueHasMetro']").focus();
        return false;
    }else{
        removeMsg("venueHasMetroLabel");
    }
    
    if($("input[name='venueHasBus']:checked").val() == undefined){
        removeMsg("venueHasBusLabel");
        appendMsg("venueHasBusLabel", "请勾选有无公交!");
        $("input[name='venueHasBus']").focus();
        return false;
    }else{
        removeMsg("venueHasBusLabel");
    }
    
    if($("input[name='venueHasRoom']:checked").val() == undefined){
        removeMsg("venueHasRoomLabel");
        appendMsg("venueHasRoomLabel", "请勾选活动室情况!");
        $("input[name='venueHasRoom']").focus();
        return false;
    }else{
        removeMsg("venueHasRoomLabel");
    }


    if($("input[name='venueHasAntique']:checked").val() == undefined){
        removeMsg("venueHasAntiqueLabel");
        appendMsg("venueHasAntiqueLabel", "请勾选馆藏情况!");
        $("input[name='venueHasAntique']").focus();
        return false;
    }else{
        removeMsg("venueHasAntiqueLabel");
    }

    /**********2015.11.09 验证漫游地址*********/


/**
    if($("#venueRoamUrl").val()!=""){
        //var urlReg=/^([hH][tT]{2}[pP]:\/\/|[hH][tT]{2}[pP][sS]:\/\/)(([A-Za-z0-9-~]+)\.)+([A-Za-z0-9-~\/])+$/;
        if($("#venueRoamUrl").val().indexOf("http")==-1 || $("#venueRoamUrl").val().indexOf("script")!=-1){
            removeMsg("venueRoamUrlLabel");
            appendMsg("venueRoamUrlLabel", "请正确输入漫游地址");
            $("#venueRoamUrl").focus();
            return;
        }else{
            removeMsg("venueRoamUrlLabel");
        }
    }**/



    var venueMemo = CKEDITOR.instances.venueMemo.getData();
    if(venueMemo.trim() == ""){
        removeMsg("venueMemoLabel");
        appendMsg("venueMemoLabel", "请填写场馆描述!");
        $('#venueMemo').focus();
        return false;
    }else{
        removeMsg("venueMemoLabel");
    }

    return result;
}

/**
 * 设置默认值
 */
function setDefaultVal(){
    //设置开始结束时间
    var venueOpenHour = $("#venueOpenHour").val();
    var venueOpenMin = $("#venueOpenMin").val();
    var venueEndHour = $("#venueEndHour").val();
    var venueEndMin = $("#venueEndMin").val();
    var venueOpenTime = venueOpenHour + ":" + venueOpenMin;
    var venueEndTime = venueEndHour + ":" + venueEndMin;
    $("#venueOpenTime").val(venueOpenTime);
    $("#venueEndTime").val(venueEndTime);
    //设置单选框选中情况
    var venueIsFree = $("input[name='venueIsFree']:checked").val();
    if(venueIsFree == "yes"){
        //2为收费
        $("input[name='venueIsFree']").val(2);
    }else{
        //1为免费
        $("input[name='venueIsFree']").val(1);
    }
    //富文本
    $('#venueMemo').val(CKEDITOR.instances.venueMemo.getData());

    $("#venueProvince").val($("#loc_province").find("option:selected").val()+","+$("#loc_province").find("option:selected").text());
    $("#venueCity").val($("#loc_city").find("option:selected").val()+","+$("#loc_city").find("option:selected").text());
    $("#venueArea").val($("#loc_town").find("option:selected").val()+","+$("#loc_town").find("option:selected").text());
}