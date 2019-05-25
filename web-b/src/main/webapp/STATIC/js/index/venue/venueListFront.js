$(document).ready(function(){
    $("#searchVal").val($("#keywordVal").val());
/*    $("#searchSltVal").val("场馆");
    $("#searchSltSpan").html("场馆");*/


    //加载场馆列表
    doQuery();
    $("#searchSltVal").val("venue");
    $("#searchSltSpan").html("场馆");
    $("#queryType").val("venue");

    //选中当前label
    $('#venueLabel').addClass('cur').siblings().removeClass('cur');
})

$(function(){
    //搜索框enter时触发查询
    $('#searchVal').keydown(function(event){
        if(event.keyCode == "13")
        {
            doQuery();
            event.preventDefault();
        }
    });

    var code = "45";;
    $.post("../frontActivity/getAdvertImg.do?siteId="+code+"&displayPosition=2&version="+new Date().getTime(),function(data){
        if(data != undefined && data != null && data != "" && data.length > 0){
            $("#venue_banner .venue_banner").html(getAdvertHtml(data));
            jQuery(".venue_banner").slide({ titCell:".in-ban-icon", mainCell:".in-ban-img",effect:"fold", autoPlay:true, autoPage:true, delayTime:600, trigger:"click"});
        }else{
        }
    });
});

function getAdvertHtml(data){
    var htmlimg = "";
    var htmlindex="";
    htmlimg += "<ul class='in-ban-img'>";
    htmlindex += "<ul class='in-ban-icon'>";
    var imgUrl='';
    var connectUrl='';
    for(var i in data){
        if(data[i].displayPosition != undefined && data[i].displayPosition==2){
            imgUrl = getIndexImgUrl(getImgUrl(data[i].advertPicUrl),"_1200_530");
            connectUrl=data[i].advertConnectUrl;
            if(""==connectUrl || connectUrl.indexOf("http") == -1){
                connectUrl="#";
                htmlimg += "<li><a href='#'><img src='"+imgUrl+"' "+ "width='1200' height='530'/></a></li>";
            }else{
                htmlimg += "<li><a target='_blank' href='"+connectUrl+"'><img src='"+imgUrl+"' "+ "width='1200' height='530'/></a></li>";
            }
            if(i==0){
                htmlindex += "<li class='on'></li>";
            }else{
                htmlindex += "<li></li>";
            }
        }
    }
    htmlimg += "</ul>";
    htmlindex += "</ul>";
    return  htmlimg+htmlindex;
}

// 得到商圈
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

function clickArea(code){
    $("#areaCode").val(code);
    $("#venueLocation").val("");
    //点击上海市时隐藏区县下位置信息
    if(code == ""){
        $("#businessDiv").hide();
    }else{
        getBusiness(code);
    }

    $("#reqPage").val(1);
    doQuery();
}

function clickVenueType(obj){
    $(obj).parent().addClass('cur').siblings().removeClass('cur');
    doQuery();
}

function clickStatus(obj){
    $(obj).parent().addClass('cur').siblings().removeClass('cur');
    doQuery();
}

//选中时赋值
function setValueById(id,value){
    $("#"+id).val(value);
    $("#reqPage").val(1);
    doQuery();
}

function doQuery(){
    var reqPage=$("#reqPage").val();
    var venueName =  $("#searchVal").val();
    var countPage = $("#countpage").val();
    var venueMood = $("#venueLocation").val();
    var venueArea = $("#areaCode").val();
    var venueType = $("#tag-div").find("li[class='cur']").find("a").attr("data-option");
    var venueIsReserve = $("#reserve-div").find("li[class='cur']").find("a").attr("data-option");

    $("#venue_content").load("../frontVenue/venueListLoad.do",{venueName:venueName,venueMood:venueMood,venueArea:venueArea,venueType:venueType,venueIsReserve:venueIsReserve,countPage:countPage,page:reqPage},function(){
        getVenueListPics();

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