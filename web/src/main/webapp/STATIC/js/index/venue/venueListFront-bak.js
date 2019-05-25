
$(document).ready(function(){
    $("#searchVal").val($("#keywordVal").val());
    $("#searchSltVal").val("场馆");
    $("#searchSltSpan").html("场馆");

    //加载场馆列表
    doQuery();

    //选中当前label
    $('#venueLabel').addClass('cur').siblings().removeClass('cur');

    // 默认展开更多选项
    //$("#search .attr-extra").trigger("click");
})

$(function(){
    //搜索框enter时触发查询
    $('#searchVal').keydown(function(event){
        if(event.keyCode == "13")
        {
            searchVenueList(1);
            event.preventDefault();
        }
    });

    //选中标签时，异步加载场馆数据
    /*$("#tag-div a").click(function(){
        var typeData = $(this).attr("data-option");
        searchVenueList("",typeData,undefined);
    });*/

   /* $("#reserve-div a").click(function(){
        var reserveData = $(this).attr("data-option");
        searchVenueList("",undefined,reserveData);
    });*/
});

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
    /*searchVenueList(1);*/
}

//选中时赋值
function setValueById(id,value){
    $("#"+id).val(value);
    /*searchVenueList(1);*/
}

function searchVenueList(pageNum,typeData,reserveData){
    $("#disableSort").val("N");
    //获取地区数据
    var areaData = $("#areaCode").val();
    //获取人群标签数据
    var crowdData = '';
    //获取类型标签数据
    if(typeData == undefined){
        $("#tag-div li").each(function(){
            if($(this).attr("class") == 'cur'){
                typeData = $(this).children().attr("data-option");
            }
        });
    }
    if(reserveData == undefined){
        $("#reserve-div li").each(function(){
            if($(this).attr("class") == 'cur'){
                reserveData = $(this).children().attr("data-option");
            }
        });
    }
    if(pageNum != undefined && pageNum != null && pageNum != ''){
        $("#reqPage").val(1);
    }
    doQuery(areaData,typeData,crowdData,reserveData);
}

function doQuery(venueArea,typeData,crowdData,reserveData){
    var sort = $("#sort").val();
    var disableSort = $("#disableSort").val();
    if(sort == undefined){
        sort = 5;
    }
    var reqPage=$("#reqPage").val();

    var venueName =  $("#searchVal").val();
    var countPage = $("#countpage").val();
    var venueLocation = $("#venueLocation").val();
    $("#venue_content").load("../frontVenue/venueListLoad.do",{venueName:venueName,venueMood:venueLocation,sortType:sort,venueArea:venueArea,typeData:typeData,crowdData:crowdData,reserveData:reserveData,countPage:countPage,page:reqPage},function(){
        getVenueListPics();

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
            $("#reqPage").val(1);
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