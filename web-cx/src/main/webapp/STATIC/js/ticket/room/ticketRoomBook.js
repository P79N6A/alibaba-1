
$(document).ready(function(){

    //显示当前活动室地址信息
    //loadArea();
    loadRoomImg();
    //当用户浏览器点击回退时，如果已同意则改变提交按钮颜色为红色
    if($("#agreement").prop("checked")){
        $("#subOrder").css('background','#F58636');
    };

    //选中当前label
    $('#venueLabel').addClass('cur').siblings().removeClass('cur');

    $(function(){
        $(".tab1 td").on("blur input propertychange",'.input-text', function(){
            if($(this).val() == ''){
                $(this).parent().addClass("showPlaceholder");
            }else{
                $(this).parent().removeClass("showPlaceholder");
            }
        });
        $(".placeholder").on({
            click:function(){ $(this).parent().find(".input-text").focus();},
            dblclick:function(){ $(this).parent().find(".input-text").focus();}
        });
        /*IE8 IE7 IE6*/
        var userAgent=window.navigator.userAgent.toLowerCase();
        var msie = /msie/.test(userAgent);
        var msie8 = /msie 8\.0/i.test(userAgent);
        var msie7 = /msie 7\.0/i.test(userAgent);
        var msie6 = /msie 6\.0/i.test(userAgent);
        if(msie && (msie8 || msie7 || msie6)){
            $(".tab1 td").on("focus",'.input-text', function(){
                $(this).parent().removeClass("showPlaceholder");
            });
        }
    });
})


/**
 * 加载页面中场馆所在区域
 */
/*function loadArea(){

    var venueCity = $("#venueCity").val();
    var venueArea = $("#venueArea").val();
    var venueAddress = $("#venueAddress").val();

    var spanCity = truncateStr(',',venueCity);
    var spanArea = truncateStr(',',venueArea);
    var spanAddress = truncateStr(',',venueAddress);

    $("#areaSpan").html(spanCity + " " + spanArea + " " +spanAddress);
}*/

/**
 * 是否同意条款
 */
function acceptItem(){

    if($("#agreement").prop("checked")){
        $("#subOrder").css('background','#F58636');
    }else{
        $("#subOrder").css('background','#808080');
    }
}

//获取活动室图片
function loadRoomImg(){
    var imgUrl = $("#roomImg").attr("data-id");
    imgUrl=getIndexImgUrl(getImgUrl(imgUrl),"_300_300");
    $("#roomImg").attr("src", imgUrl);
}

/**
 * 根据当前活动室以及用户选择的日期加载可选的场次
 */
function getRoomBookListByDate(){
    var roomId = $("#roomId").val();
    var curDate = $("#dateHidden").val();

    var data = {"roomId":roomId,"curDate":curDate};
    $.post("../ticketRoom/roomBookList.do",data ,
        function(dataList) {

            if(dataList != null && dataList.length > 0) {
                var optionHtml = "";
                var captionText = "";

                for (var i = 0; i < dataList.length; i++) {
                    var roomBook = dataList[i];
                    optionHtml = optionHtml + "<option value=" + roomBook.openPeriod + ">" + roomBook.openPeriod + "</option>";
                    if (i == 0) {
                        captionText = roomBook.openPeriod;
                    }
                }

                $("#cate").css("display", "");
                $("#errorMsg").css("display", "");
                $("#openPeriod").html(optionHtml);
                if (captionText != "") {
                    $("#caption").html(captionText);
                }
                $('#openPeriod option:first').attr("selected", "selected");
                $("#openPeriod").selectedText = captionText;
            }else{
                $("#cate").css("display","none");
                $("#errorMsg").css("display","none");
            }
    });
}

/**
 * 提交预定信息
 */
function bookSubmit(){
    var tuserId = $("#tuserId").val();
    var tuserName = $("#tuserName").val();
    var userName = $("#userName").val();
    var userTel = $("#userTel").val();
    var cateCss = $("#cate").css("display");

    if(cateCss == "none"){
        dialogAlert("提示","当前无可预订场次，请选择其它日期!");
        return;
    }
    if(tuserId == ""){
        dialogAlert("提示","您的团体身份已被冻结，请联系管理员为您激活!");
        return;
    }
    if(tuserName == ""){
        dialogAlert("提示","所属团体为必填项!");
        return;
    }
    if(userName == ""){
        dialogAlert("提示","预订人为必填项!");
        return;
    }
    if(userTel == ""){
        dialogAlert("提示","手机号码为必填项!");
        return;
    }else{
        //var telReg = !!userTel.match(/^1[34578]\d{9}$/);
        //if(telReg == false){
        //    dialogAlert("提示","手机号码格式不正确!");
        //    return;
        //}
    }

    if(!$("#agreement").prop("checked")){
        dialogAlert("提示","请阅读并勾选预订须知!");
        return;
    }
    $("#roomBookOrderForm").submit();
}

/**
 * 根据分隔符截取字符串
 * @param splitChar
 * @param truncateStr
 * @returns {*}
 */
function truncateStr(splitChar,truncateStr){
    var indexOfSplitChar = null;
    var result = "";
    if(isLegal(splitChar) && isLegal(truncateStr)){
        indexOfSplitChar = truncateStr.indexOf(splitChar);

        var len = truncateStr.length;
        if(indexOfSplitChar != null){
            result = truncateStr.substring(indexOfSplitChar+1,len);
        }
    }
    return result;
}

/**
 * 判断一个字符串是否合理
 * @param str
 * @returns {boolean}
 */
function isLegal(str){
    var result = true;
    if(str == undefined || str == null || str == ""){
        result = false;
    }
    return result;
}