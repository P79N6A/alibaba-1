

$(function(){

    //选中标签时，异步加载场馆数据
    $("#area-div a").click(function(){
        var areaData = $(this).attr("data-option");
        var dictData = '';
        $("#dict-div li").each(function(){
            if($(this).attr("class") == 'cur'){
                dictData = $(this).children().attr("data-option");
            }
        });
        doQuery(dictData,areaData);
     });


    //选中标签时，异步加载场馆数据
    $("#dict-div a").click(function(){
        var dictData = $(this).attr("data-option");
        var areaData = '';
        $("#area-div li").each(function(){
            if($(this).attr("class") == 'cur'){
                areaData = $(this).children().attr("data-option");
            }
        });
        doQuery(dictData,areaData);
    });
    //失去焦点执行
    $("#keyword").blur(function(){
        antiqueSearch();
    });
});


//回车执行
document.onkeydown=keyDownLogin;
function keyDownLogin(e) {
    var theEvent = e || window.event;
    var code = theEvent.keyCode || theEvent.which || theEvent.charCode;
    if (code == 13) {
        antiqueSearch();
        return false;
    }
    return true;
}

function antiqueSearch(){
    var antiqueName =  $("#keyword").val() == "请输入关键词" ? "" : $("#keyword").val();
    $("#keyword").val(antiqueName);

/*    if($.trim(antiqueName)==""){
        return;
    }*/
    var dictData = '';
    $("#dict-div li").each(function(){
        if($(this).attr("class") == 'cur'){
            dictData = $(this).children().attr("data-option");
        }
    });
    var areaData = '';
    $("#area-div li").each(function(){
        if($(this).attr("class") == 'cur'){
            areaData = $(this).children().attr("data-option");
        }
    });
    doQuery(dictData,areaData);
}




/**
 * 馆藏详情页
 * @param venueId
 */
function antiqueDetail(antiqueId){
    $("#antiqueId").val(antiqueId);
    $("#antiqueDetailForm").submit();
}


// code:区域 tuserName:名称 tagId:标签
function doQuery(antiqueVenueId,areaId){
    var reqPage=$("#reqPage").val();
    var antiqueName =  $("#keyword").val() == "请输入关键词" ? "" : $("#keyword").val();
    var countPage = $("#countpage").val();
    $("#antiqueListDiv").load("../frontAntique/antiqueListLoad.do",{
        antiqueName:antiqueName,
        //antiqueVenueId:antiqueVenueId,//类型id
        antiqueVenueId:areaId,
        countPage:countPage,
        page:reqPage,
        antiqueYears:antiqueVenueId
    },function(){
        getAntiqueListPics();
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

                //获取标签数据
                var dictData = '';
                $("#dict-div li").each(function(){
                    if($(this).attr("class") == 'cur'){
                        dictData = $(this).children().attr("data-option");
                    }
                });

                var areaData = '';
                $("#area-div li").each(function(){
                    if($(this).attr("class") == 'cur'){
                        areaData = $(this).children().attr("data-option");
                    }
                });
                doQuery(dictData.areaData);
                return false;
            }
        });
    });
}


//获取列表元素中所包含的图片
function getAntiqueListPics(){
    //请求页面下方团体所有图片
    $("#antique-list-ul li").each(function (index, item) {
        var imgUrl = $(this).attr("data-id");
        imgUrl = getIndexImgUrl(getImgUrl(imgUrl),"_300_300");
        $(item).find("img").attr("src", imgUrl);
    });
}