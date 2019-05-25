
/**
 * 加载页面中场馆所在区域
 */
function loadArea(){

    var venueCity = $("#venueCity").val();
    var venueArea = $("#venueArea").val();
    var venueAddress = $("#venueAddress").val();

    var spanCity = truncateStr(',',venueCity);
    var spanArea = truncateStr(',',venueArea);
    var spanAddress = truncateStr(',',venueAddress);

    $("#areaSpan").html(spanCity + "" + spanArea + "" +spanAddress);
}

function subRoomDetail(){

    $("#roomDetailForm").submit();
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