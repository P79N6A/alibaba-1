
$(document).ready(function(){

    //loadArea();
    loadRoomImg();
    //选中当前label
    $('#venueLabel').addClass('cur').siblings().removeClass('cur');
})

//获取活动室图片
function loadRoomImg(){
    var imgUrl = $("#roomImg").attr("data-id");
    imgUrl=getIndexImgUrl(getImgUrl(imgUrl),"_300_300");
    $("#roomImg").attr("src", imgUrl);
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


/**
 *
 * @param roomId
 * @param bookId
 */
function singleRoomBook(roomId,bookId,tuserId,userTel){
    $("#roomId2").val(roomId);
    $("#bookId2").val(bookId);
    $("#tuserId2").val(tuserId);
    $("#userTel2").val(userTel);
    $("#roomBookForm").submit();
}