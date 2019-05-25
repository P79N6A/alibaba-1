
$(document).ready(function(){
    //加载场馆列表
    doQuery();
    //加载场馆类型标签
    //getVenueTypeIcons();
})

/**
 * 根据区县编码获取商圈列表
 * @param code
 */
function getBusiness(code){
    $.post("../sysdict/queryChildSysDictByDictCode.do",{dictCode:code}, function(data) {
        var list = eval(data);
        var dictHtml =  '<li class="cur"><a onclick="setValueById(\'venueLocation\',\'\')">全部</a></li>';
        var otherHtml = '';
        if(data != null && data.length > 0){
            for (var i = 0; i < list.length; i++) {
                var obj = list[i];
                var dictId = obj.dictId;
                var dictName = obj.dictName;
                if(dictName == '其他'){
                    otherHtml = '<li><a onclick="setValueById(\'venueLocation\',\'' + dictId + '\')">'+dictName+'</a></li>';
                    continue;
                }
                dictHtml += '<li><a onclick="setValueById(\'venueLocation\',\'' + dictId + '\')">'+dictName+'</a></li>';
            }
            $("#businessUl").html(dictHtml + otherHtml);
            $("#businessDiv").show();
        }else{
            $("#businessDiv").hide();
        }
    });
}

/**
 * 点击区县时做出的时间响应
 * @param code
 */
function clickArea(code){
    $("#areaCode").val(code);
    $("#venueLocation").val("");
    //点击上海市时隐藏区县下位置信息
    if(code == ""){
        $("#businessDiv").hide();
    }else {
        getBusiness(code);
    }

    $("#reqPage").val(1);
    doQuery();
}

/**
 * 选择商圈时进行赋值
 * @param id
 * @param value
 */
function setValueById(id,value){
    $("#"+id).val(value);

    $("#reqPage").val(1);
    doQuery();
}

function doQuery(){
    var reqPage = $("#reqPage").val();
    var venueType = $("#venueType").val();
    var countPage = $("#countpage").val();
    var venueMood = $("#venueLocation").val();
    var venueArea = $("#areaCode").val();
    $("#venue_content").load("../ticketVenue/venueListLoad.do",{venueMood:venueMood,venueArea:venueArea,venueType:venueType,countPage:countPage,page:reqPage},function(){
        getVenueListPics();
        //getVenueTypeIcons();

        //分页
        kkpager.generPageHtml({
            pno :$("#pages").val() ,
            //总页码
            total :$("#countpage").val(),
            //总数据条数
            totalRecords :$("#total").val(),
            mode : 'click',
            click : function(n){
                this.selectPage(n);
                $("#reqPage").val(n);

                doQuery();
                return false;
            }
        });
    });
}

//获取列表元素中所包含的图片
function getVenueListPics(){
    //请求页面下方团体所有图片
    $("#venue-list-ul li").each(function (index, item) {
        var imgUrl = $(this).attr("data-id");
        if(imgUrl != undefined && imgUrl != "" && imgUrl != null) {
            imgUrl = getImgUrl(imgUrl);
            imgUrl = getIndexImgUrl(imgUrl,"_300_300")
            $(item).find("img").attr("src", imgUrl);
        }else{
            $(item).find("img").attr("src", "../STATIC/image/default.jpg");
        }
    });
}

//获取场馆类别图标
function getVenueTypeIcons(){
    //请求页面下方团体所有图片
    $("#type-div img").each(function (index, item) {
        var imgUrl = $(this).attr("imgPath");
        if(imgUrl != undefined && imgUrl != "" && imgUrl != null) {
            imgUrl = getImgUrl(imgUrl);
            $(item).attr("src", imgUrl);
            $(item).attr("data-img", imgUrl);
            $(item).attr("data-hover", imgUrl);
        }
    });
}