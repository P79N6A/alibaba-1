
$(document).ready(function(){
	$("#searchSltVal").val("场馆");
    $("#searchSltSpan").html("场馆");
	
    //加载场馆列表
    doQuery();

    //选中当前label
    $('#venueLabel').addClass('cur').siblings().removeClass('cur');

    var code = "45";;
    var path = $("#path").val();
    $.post(path+"/frontActivity/getAdvertImg.do?siteId="+code+"&displayPosition=2&version="+new Date().getTime(),function(data){
        if(data.length!=0){
            $("#venue_banner .venue_banner").html(getAdvertHtml(data));
            jQuery(".venue_banner").slide({ titCell:".in-ban-icon", mainCell:".in-ban-img",effect:"fold", autoPlay:true, autoPage:true, delayTime:600, trigger:"click"});
        }else{
        }
    });
})


$(function(){
    //选中标签时，异步加载场馆数据
    $("#search_more a").click(function(){
        //给标签加样式
        $(this).addClass("search_red").siblings().removeClass("search_red");
        var areaData = "";
        var tagData = $(this).attr("data-option");
        $("#search_more a").each(function(){
            if($(this).attr("class") == 'search_red'){
                tagData = $(this).attr("data-option");
            }
        });

        $("#reqPage").val(1);
        doQuery(areaData,tagData);
    });

    $('#venueName').keydown(function(event){
        if(event.keyCode == "13")
        {
            var areaData = "";
            //获取标签数据
            var tagData = '';
            $("#search_more a").each(function(){
                if($(this).attr("class") == 'search_red'){
                    tagData = $(this).attr("data-option");
                }
            });
            $("#reqPage").val(1);
            doQuery(areaData,tagData);
            event.preventDefault();
        }
    });
});


function doQuery(venueArea,tagId){
    var reqPage=$("#reqPage").val();
    var venueName = "";
    var countPage = $("#countpage").val();
    $("#venueListDiv").load("../frontVenue/venueIndexListLoad.do",{venueName:venueName,venueArea:venueArea,tagId:tagId,countPage:countPage,page:reqPage},function(){
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

                var areaData = '';
                //获取标签数据
                var tagData = '';
                $("#search_more a").each(function(){
                    if($(this).attr("class") == 'search_red'){
                        tagData = $(this).attr("data-option");
                    }
                });
                doQuery(areaData,tagData);
                return false;
            }
        });
        getVenueListPics();
    });
}

//获取列表元素中所包含的图片
function getVenueListPics(){
    //请求页面下方团体所有图片
    $("#venue-list-ul li").each(function (index, item) {
        var imgUrl = $(this).attr("data-id");
        if(imgUrl != undefined && imgUrl != "" && imgUrl != null){
            imgUrl= getImgUrl(imgUrl);
            imgUrl = getIndexImgUrl(imgUrl,"_300_300");
            $(item).find("img").attr("src",imgUrl);
        }else{
            $(item).find("img").attr("src",path+"/STATIC/image/default.jpg");
        }
    });
}


function getAdvertHtml(data){
    var htmlimg = "";
    var htmlindex="";
    htmlimg += "<ul class='in-ban-img'>";
    htmlindex += "<ul class='in-ban-icon'>";
    var imgUrl='';
    var connectUrl='';
    for(var i in data){
        //console.log("========>"+data[i].displayPosition);
        if(data[i].displayPosition!=undefined&&data[i].displayPosition==2){
        imgUrl = getIndexImgUrl(getImgUrl(data[i].advertPicUrl),"_1200_530");
        connectUrl=data[i].advertConnectUrl;
        if(""==connectUrl||connectUrl.indexOf("http")==-1){
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