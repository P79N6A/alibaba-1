/**
 * Created by yujinbing on 2015/12/23.
 */


$(function() {
    //加载列表页数据
    doQuery(1);
});

//查询
function doQuery(page) {
    if (page != undefined && page != '') {
        $("#page").val(1);
    }
    $("#activity_content").load("../ticketActivity/ticketActivityListLoad.do",$("#ticketForm").serialize(),function(){
        getPicture();
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
                $("#page").val(n);
                doQuery('');
                return false;
            }
        });

    });
}


//异步加载图片
function getPicture(){
    $("#data-ul li").each(function(index,item){
        var imgUrl = $(this).attr("data-li-url");
        if(imgUrl==undefined||imgUrl==""){
            $(item).find("img").attr("src", "../STATIC/image/default.jpg");
        }else{
            imgUrl=getIndexImgUrl(getImgUrl(imgUrl),"_300_300");
            $(item).find("img").attr("src", imgUrl);
        }
    });
}



//主题列表信息
$(function() {

    if ($("#areaCode").val() != undefined && $("#areaCode").val() != '') {
        var code = $("#areaCode").val();
        $("#areaCode").val(code);
        if(code == ""){
            $("#businessDiv").hide();
        }else{
            getBusiness(code);
        }
        $('#'+$("#areaCode").val()).addClass('cur').siblings().removeClass('cur');
    }

    $.post("../tag/getChildTagByType.do?code=ACTIVITY_TYPE",function(data) {
        if (data != '' && data != null) {
            var list = eval(data);
            var ulHtml = '<a class="icon cur"  href="javascript:setValueById(\'activityType\', \'\');"><img src="../STATIC/image/search-icon1a.png" data-img="../STATIC/image/search-icon1.png" data-hover="../STATIC/image/search-icon1a.png"/>全部</a>';
            for (var i = 0; i <list.length; i++) {
                var tag = list[i];
                if (tag.tagName ==  '演出') {
                    ulHtml += '<a id="' + tag.tagId + '" class="icon"  href="javascript:setValueById(\'activityType\',\''+ tag.tagId + '\');">' + '<img src="../STATIC/image/search-icon2.png" data-img="../STATIC/image/search-icon2.png" data-hover="../STATIC/image/search-icon2a.png"/><span>'+ tag.tagName +'</a></span>';
                } else if (tag.tagName ==  '培训') {
                    ulHtml += '<a id="' + tag.tagId + '" class="icon"  href="javascript:setValueById(\'activityType\',\''+ tag.tagId + '\');">' + '<img src="../STATIC/image/search-icon3.png" data-img="../STATIC/image/search-icon3.png" data-hover="../STATIC/image/search-icon3a.png"/><span>'+ tag.tagName +'</a></span>';
                } else if (tag.tagName ==  '展览') {
                    ulHtml += '<a id="' + tag.tagId + '" class="icon"  href="javascript:setValueById(\'activityType\',\''+ tag.tagId + '\');">' + '<img src="../STATIC/image/search-icon4.png" data-img="../STATIC/image/search-icon4.png" data-hover="../STATIC/image/search-icon4a.png"/><span>'+ tag.tagName +'</a></span>';
                } else if (tag.tagName ==  '讲座') {
                    ulHtml += '<a id="' + tag.tagId + '" class="icon"  href="javascript:setValueById(\'activityType\',\''+ tag.tagId + '\');">' + '<img src="../STATIC/image/search-icon5.png" data-img="../STATIC/image/search-icon5.png" data-hover="../STATIC/image/search-icon5a.png"/><span>'+ tag.tagName +'</a></span>';
                } else {
                    ulHtml += '<a id="' + tag.tagId + '" class="icon"  href="javascript:setValueById(\'activityType\',\''+ tag.tagId + '\');">' + '<img src="../STATIC/image/search-icon5.png" data-img="../STATIC/image/search-icon5.png" data-hover="../STATIC/image/search-icon5a.png"/><span>'+ tag.tagName +'</a></span>';
                }
            }
            $('#activityTypeMenu').html(ulHtml);
        }

        //选中类型
/*
        if ($("#activityType").val() != undefined && $("#activityType").val() != '') {
            $('#'+$("#activityType").val()).addClass('cur').siblings().removeClass('cur');
        }
*/
    });
});


// 选择区域
function clickArea(code){
    $("#areaCode").val(code);
    $("#activityLocation").val("");
    if(code == ""){
        $("#businessDiv").hide();
    }else{
        getBusiness(code);
    }

    doQuery(1);
}

// 得到商圈
function getBusiness(code){
    var activityLocation = $("#activityLocation").val();
    $.post("../sysdict/queryChildSysDictByDictCode.do",{dictCode:code}, function(data) {
        var list = eval(data);
        var dictHtml =  '<li class="cur"><a onclick="setValueById(\'activityLocation\',\'\')">全部</a></li>';
        var otherHtml = '';
        if(data != null && data.length > 0){
            for (var i = 0; i < list.length; i++) {
                var obj = list[i];
                var dictId = obj.dictId;
                var dictName = obj.dictName;
                if(dictName == '其他'){
                    otherHtml = '<li id="' + dictId + '"><a onclick="setValueById(\'activityLocation\',\'' + dictId + '\')">'+dictName+'</a></li>';
                    continue;
                }
                dictHtml += '<li id="' + dictId + '"><a onclick="setValueById(\'activityLocation\',\'' + dictId + '\')">'+dictName+'</a></li>';
            }
            $("#businessUl").html(dictHtml + otherHtml);
            $("#businessDiv").show();

            //选中商圈
            if (activityLocation != undefined && activityLocation != '') {
                $('#'+activityLocation).addClass('cur').siblings().removeClass('cur');
            }
        }else{
            $("#businessDiv").hide();
        }
    });
}

//选中时赋值
function setValueById(id,value){
    $("#"+id).val(value);
    doQuery(1);
}

//标签选中效果
$(function(){
    $(".search-menu .icon").each(function(){
        if($(this).hasClass("cur")) {
            var thisHoverImgUrl = $(this).find("img").attr("data-hover");
            $(this).find("img").attr("src", thisHoverImgUrl);
        }
    });
    $(".search-menu").on("click", ".icon", function(){
        $(".search-menu .icon").each(function(){
            if($(this).hasClass("cur")) {
                var thisImgUrl = $(this).find("img").attr("data-img");
                $(this).find("img").attr("src", thisImgUrl);
            }
        });
        var $this = $(this);
        /*  if(!$this.hasClass("cur")){*/
        var $img = $this.find("img");
        var imgUrl = $img.attr("src");
        var hoverImgUrl = $img.attr("data-hover");
        $this.addClass("cur").siblings().removeClass("cur");
        $img.attr("src", hoverImgUrl);
        /*}*/
    });
});