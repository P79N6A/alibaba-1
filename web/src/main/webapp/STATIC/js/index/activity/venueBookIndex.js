
$(document).ready(function(){

    $("#keyword").val($("#keywordVal").val());

    //加载场馆列表
    doQuery();

    //选中当前label
    $('#activityListLabel').addClass('cur').siblings().removeClass('cur');

    // 默认展开更多选项
    /*$("#search .attr-extra").trigger("click");*/
})

$(function(){
    $('#keyword').keydown(function(event){
        if(event.keyCode == "13")
        {
            searchVenueList(1);
            event.preventDefault();
        }
    });
});

function searchVenueList(pageNum){
    $("#disableSort").val("N");
    //获取地区数据
    var venueName = '';
    /*$("#area_div li").each(function(){
        if($(this).attr("class") == 'w162 cur'){
            venueName = $(this).children().attr("data-option");
        }
    });*/
/*    //获取类型标签数据
    var typeData = '';
    $("#tag-div li").each(function(){
        if($(this).attr("class") == 'cur'){
            typeData = $(this).children().attr("data-option");
        }
    });
    //获取人群标签数据
    var crowdData = '';
    $("#crowd-div li").each(function(){
        if($(this).attr("class") == 'cur'){
            crowdData = $(this).children().attr("data-option");
        }
    });*/
    if(pageNum != undefined && pageNum != null && pageNum != ''){
        $("#reqPage").val(1);
    }
    doQuery(venueName,'','');
}


// code:区域 tuserName:名称 tagId:标签
function doQuery(venueName,typeData,crowdData){
    var sort = $("#sort").val();
    var disableSort = $("#disableSort").val();
    if(sort == undefined){
        sort = 1;
    }
    var reqPage=$("#reqPage").val();
    var activityName =  $("#keyword").val() == "请输入关键词" ? "" : $("#keyword").val();
    var type = $("#type").val();
    var countPage = $("#countpage").val();
    $("#activity_content").load("../frontActivity/venueBookIndexLoad.do",{venueName:"上海图书馆",activityName:activityName,type:type,countPage:countPage,page:reqPage},function(){
        getVenueListPics();
        //得到喜欢搜藏的人数
        $(".activity_ul").find("span[class=like]").each(function (index, item) {
            var activityId = $(this).attr("mid");
            $.ajax({
                type: 'POST',
                dataType : "json",
                url: "../collect/getHotNum.do?relateId="+activityId+"&type=2",//请求的action路径
                error: function () {//请求失败处理函数
                },
                success:function(data){ //请求成功后处理函数。
                    $("#"+activityId).html(data);
                }
            });
        });
        if(disableSort == "Y"){
            $("#sortDiv").hide();
        }else if(disableSort == "N"){
            $("#sortDiv").show();
        }

        // 加载load文件时
        $(".sort-box").find("a").each(function(index,item){
            if($(this).text() == "默认"){
                $(this).addClass("icon-asc").siblings("a").attr("class", "item");
            }else if($(this).text() == "热度"){
                if(sort == 2){
                    $(this).addClass("icon-asc").siblings("a").attr("class", "item");
                }else if(sort == 3){
                    $(this).addClass("icon-desc").siblings("a").attr("class", "item");
                }
            }else if($(this).text() == "发布时间"){
                if(sort == 4){
                    $(this).addClass("icon-asc").siblings("a").attr("class", "item");
                }else if(sort == 5){
                    $(this).addClass("icon-desc").siblings("a").attr("class", "item");
                }
            }
        });

        /*搜索排序 1-默认 2-热度升序 3-热度降序 4-激活时间升序 5-激活时间降序*/
        $(".sort-box").on("click", ".item", function(){
            var that = $(this);
            if(that.attr("class") == "item") {
                that.addClass("icon-asc").siblings("a").attr("class", "item");
                getSort(that);
            }else if(that.hasClass("icon-asc")){
                that.removeClass("icon-asc").addClass("icon-desc").siblings("a").attr("class", "item");
                getSort(that);
            }else if(that.hasClass("icon-desc")){
                that.removeClass("icon-desc").addClass("icon-asc").siblings("a").attr("class", "item");
                getSort(that);
            }
            searchVenueList();
        });


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

                searchVenueList();
                return false;
            }
        });
    });
}


function getSort(that){
    if(that.text() == "默认"){
        $("#sort").val(1);
    }
    if(that.text() == "热度"){
        if(that.hasClass("icon-asc")){
            $("#sort").val(2);
        }else if(that.hasClass("icon-desc")){
            $("#sort").val(3);
        }
    }
    if(that.text() == "发布时间"){
        if(that.hasClass("icon-asc")){
            $("#sort").val(4);
        }else if(that.hasClass("icon-desc")){
            $("#sort").val(5);
        }
    }
}


//获取列表元素中所包含的图片
function getVenueListPics(){
    //请求页面下方团体所有图片
    $(".activity_ul li").each(function (index, item) {
        var imgUrl = $(this).attr("data-li-url");
        if(imgUrl != undefined || imgUrl != "") {
            imgUrl = getImgUrl(imgUrl);
            imgUrl = getIndexImgUrl(imgUrl,"_300_300")
            $(item).find("img").attr("src", imgUrl);
        }
    });
}

function activityDetail(activityId){
    $("#activityId").val(activityId);
    $("activityDetailForm").submit();
}