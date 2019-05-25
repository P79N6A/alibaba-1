

$(function(){

    //选中当前label
    $('#venueLabel').addClass('cur').siblings().removeClass('cur');

    doQuery();

    /*$('#tagTypeUl').on("click", "a", function(){
        var typeId = $(this).attr("data-option");
        var dictData = '';
        $("#dict-div li").each(function(){
            if($(this).attr("class") == 'cur'){
                dictData = $(this).children().attr("data-option");
            }
        });
        doQuery(dictData,typeId);

    })

    //选中标签时，异步加载场馆数据
    $("#dict-div a").click(function(){
        var dictData = $(this).attr("data-option");
        var typeId = '';
        $("#tagTypeUl li").each(function(){
            if($(this).attr("class") == 'cur'){
                typeId = $(this).children().attr("data-option");
            }
        });
        doQuery(dictData,typeId);
    });*/

    $("#antiqueClick").click(function(){
        var dictData = $("#dict-div").find("li[class=cur] a").attr("data-option");
        var typeId = $("#tagTypeUl").find("li[class=cur] a").attr("data-option");
        doQuery(dictData,typeId);
    });
});

/**
 * 馆藏详情页
 * @param venueId
 */
function antiqueDetail(antiqueId){
    $("#antiqueId").val(antiqueId);
    $("#antiqueDetailForm").submit();
}

// dictCode:朝代，typeId:藏品类型
function doQuery(dictData,typeId){
    var reqPage=$("#reqPage").val();
    var antiqueName =  "";
    var countPage = $("#countpage").val();
    var vId = $("#venueId").val();
    $("#activty_content").load("../frontAntique/antiqueListLoad.do",{
        antiqueName:antiqueName,
        venueId:vId,
        antiqueVenueId:typeId,
        countPage:countPage,
        page:reqPage,
        antiqueYears:dictData
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

                var typeId = '';
                $("#tagTypeUl li").each(function(){
                    if($(this).attr("class") == 'cur'){
                        typeId = $(this).children().attr("data-option");
                    }
                });
                doQuery(dictData,typeId);
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