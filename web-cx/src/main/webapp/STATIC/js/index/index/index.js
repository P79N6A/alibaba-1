$(function () {
    showAdvertPicture();
    getActivitySearchType();
    loadActivityData(1);
    hotelRecommend();

    if ($("#activityName").val() != undefined && $("#activityName").val() != '') {
        $("#searchVal").val($("#activityName").val());
    }
    // 活动或场馆搜索时使用
    $("#searchSltVal").val("activity");
    $("#searchSltSpan").html("活动");
});


// 显示轮播图
function showAdvertPicture() {
    var code = $("#areaCode").val();
    if (code == "") {
        code = "45";
    }
    $.post("../ccpAdvert/loadAdvertIndex.do?advertPostion=1&advertType=A&version=" + new Date().getTime(), '', function (data) {
        if (data != undefined && data != null && data != "" && data.length > 0) {
            $("#banner .in-ban").html(getAdvertHtml(data));
            jQuery(".in-ban").slide({
                titCell: ".in-ban-icon",
                mainCell: ".in-ban-img",
                effect: "fold",
                autoPlay: true,
                autoPage: true,
                delayTime: 600,
                trigger: "click"
            });
        } else {
        }
    });
}

// 拼接轮播图ul下的li
function getAdvertHtml(data) {
    var htmlimg = "";
    var htmlindex = "";
    htmlimg += "<ul class='in-ban-img'>";
    htmlindex += "<ul class='in-ban-icon'>";
    var imgUrl = '';
    var connectUrl = '';
    for (var i in data) {
        if (data[i].advertState != undefined && data[i].advertState == 1 && data[i].advertImgUrl != "") {
            imgUrl = getIndexImgUrl(getImgUrl(data[i].advertImgUrl), "");
            connectUrl = data[i].advertUrl;
            if ("" == connectUrl || connectUrl.indexOf("http") == -1) {
                htmlimg += "<li><a><img src='" + getIndexImgUrl(imgUrl,"_750_400") + "' width='750' height='400'/></a></li>";
            } else {
                htmlimg += "<li><a target='_blank' href='" + connectUrl + "'><img onload='fixImage(this,750,475)' src='" + getIndexImgUrl(imgUrl,"_750_400") + "'/></a></li>";
            }
        }
    }
    htmlindex += "<li></li>";
    htmlimg += "</ul>";
    htmlindex += "</ul>";
    return htmlimg + htmlindex;
}


// 获取热点推荐的图片
function getHotelRecommendPicture() {
    $("#hotelRecommendDivChild a").each(function (index, item) {
        var imgUrl = $(this).attr("data-url");
        if (imgUrl != undefined && imgUrl != "" && imgUrl != null) {
            $(item).find("img").attr("src", getIndexImgUrl(getImgUrl(imgUrl), "_300_300"));
        } else {
            $(item).find("img").attr("src", "../STATIC/image/default.jpg");
        }
    });
}
//获取活动搜索类型
function getActivitySearchType() {
    $.post("../tag/getChildTagByType.do", {code: 'ACTIVITY_TYPE'}, function (data) {
        var activityTypeHtml = "<ul class='av_list'>";
        activityTypeHtml += '<li><a href="javascript:setValueById(\'activityType\',\'\');"> 全部</a></li>';
        var list = eval(data);
        for (var i = 0; i < list.length; i++) {
            var tag = list[i];
            activityTypeHtml += '<li><a href="javascript:setValueById(\'activityType\',\'' + tag.tagId + '\');">' + tag.tagName + '</a></li>';
        }
        activityTypeHtml += "</ul>";
        $("#activitySearchType").html(activityTypeHtml);
    });
}

// 选择区域
function clickArea(code) {
    isAjax = 0;
    $("#areaCode").val(code);
    //切换轮播图
    showAdvertPicture();
    $("#activityLocation").val("");
    if (code == "") {
        $("#businessDiv").hide();
    } else {
        getBusiness(code);
    }
    $(".ul_list>ul").html("");
    loadActivityData(1);
}

// 得到商圈
function getBusiness(code) {
    var activityLocation = $("#activityLocation").val();
    $.post("../sysdict/queryChildSysDictByDictCode.do", {dictCode: code}, function (data) {
        var list = eval(data);
        var dictHtml = '<li class="cur"><a onclick="setValueById(\'activityLocation\',\'\')">全部</a></li>';
        var otherHtml = '';
        if (data != null && data.length > 0) {
            for (var i = 0; i < list.length; i++) {
                var obj = list[i];
                var dictId = obj.dictId;
                var dictName = obj.dictName;
                if (dictName == '其他') {
                    otherHtml = '<li id="' + dictId + '"><a onclick="setValueById(\'activityLocation\',\'' + dictId + '\')">' + dictName + '</a></li>';
                    continue;
                }
                dictHtml += '<li id="' + dictId + '"><a onclick="setValueById(\'activityLocation\',\'' + dictId + '\')">' + dictName + '</a></li>';
            }
            $("#businessDiv").html(dictHtml + otherHtml);
            //选中商圈
            if (activityLocation != undefined && activityLocation != '') {
                $('#' + activityLocation).addClass('cur').siblings().removeClass('cur');
            }
        } else {
        }
    });
}

//选中时赋值 并进行查询
function setValueById(id, value) {
    $("#" + id).val(value);
    $(".ul_list>ul").html("");
    isAjax = 0;
    loadActivityData(1);
}


<!--推荐切换js-->

$(function () {
    $(".btn-icon").click(function () {
        var $this = $(this);
        if ($this.hasClass("open")) {
            $this.prev().removeClass("attr-expand").addClass("attr-collapse");
            $this.removeClass("open").text("展开");
        } else {
            $this.prev().removeClass("attr-collapse").addClass("attr-expand");
            $this.addClass("open").text("收起");
        }
    });
    $("#in_search").on("click", ".av_list li", function () {
        var $this = $(this);
        var $parentsArea = $this.parents("#attr-area");
        var $area = $("#attr-area");
        if ($parentsArea.length > 0 && $this.parent().index() == 0) {
            if ($this.index() == 0) {
                $area.siblings(".btn-icon").hide();
                $area.removeClass("attr-expand").addClass("attr-collapse");
            } else {
                $area.removeClass("attr-collapse").addClass("attr-expand");
                $area.find(".av_list").show();
                $area.siblings(".btn-icon").show();
            }
        }
        $this.addClass("cur").siblings().removeClass("cur");
    });
    $("#hot_list").on("click", ".tit_l a", function () {
        $(this).addClass("cur").siblings().removeClass("cur");
    });
});


// 获取即将开始的活动
/*function showActivityList(){
 //var areaCode = $("#area").find("a[class='cur']").attr("data-option");
 $("#activityListDiv").load("../frontIndex/activityQueryList.do #activityListDivChild",$("#indexForm").serialize(),function(){
 getActivityPicture();
 });
 }

 // 获取活动的图片
 function getActivityPicture(){
 $("#activityListDivChild li").each(function (index, item) {
 var imgUrl = $(this).attr("data-url");
 if(imgUrl != undefined && imgUrl != "" && imgUrl != null) {
 $(item).find("img").attr("src", getIndexImgUrl(getImgUrl(imgUrl),"_300_300"));
 }else{
 $(item).find("img").attr("src", "../STATIC/image/default.jpg");
 }
 });
 }*/


////活动列表 滑动加载
//$(window).on("scroll",function(event){
//    var $winHeight = $(window).height(),
//        $pageHeight = $("body").height(),
//        scrollDis = $(window).scrollTop();
//    if(scrollDis >= ($pageHeight - $winHeight - 420)){
//        if(isCanScroll){
//            loadActivityData(nextPage);
//        }
//    }
//});

var isCanScroll = false, nextPage = 1, isAjax = 0;
function loadActivityData(page) {
    $("#page").val(page);
    if (page == 1) {
        $(".btn-loading").remove();
    }
    if (isAjax) {
        return;
    }
    isAjax = 1;
    $.ajax({
        url: "../frontIndex/activityQueryList.do",
        method: "post",
        dataType: "json",
        data: $("#indexForm").serialize(),
        beforeSend: function () {
            loadingIcon.add();
        },
        success: function (result) {
            if (page == 1) {
                $(".ul_list>ul").empty();
            }
            var rsObj = jQuery.parseJSON(result);
            var data = rsObj.list;
            if (data.length == 0 && page == 1) {
                $(".btn-loading").remove();
                if ($(".null_result").length < 1) {
                    $('<div class="null_result"><div class="cont"><h2>抱歉，没有找到相关结果</h2><p>您可以修改搜索条件重新尝试</p></div></div>').insertBefore(".ul_list");
                }
                return;
            } else {
                $(".null_result").remove();
            }

            if (data.length > 0) {
                var str = '';
                for (var k in data) {
                    if (k >= 16) {
                        break;
                    }
                    str += '<li>';
                    str += '  <div class="img">';
                    var imgUrl = data[k].activityIconUrl;
                    var trueImgUrl;
                    var index=imgUrl.lastIndexOf("http:");
                    if(index>-1){
                    	trueImgUrl = imgUrl;
                    }
                    else
                    	trueImgUrl = getIndexImgUrl(getImgUrl(imgUrl), "_300_300");
                    var activityTime = data[k].activityStartTime;
                    //判断是否过期
                    var maxDateTime = "";
                    if (data[k].maxDateTime != undefined && data[k].maxDateTime != '') {
                        var maxDate = data[k].maxDateTime.substr(0, 16);
                        maxDateTime = new Date(maxDate.replace(/-/g, "/"));
                    }
                    var nowDateTime = new Date();
                    //是否收藏
                    var collectNum = data[k].collectNum;
                    var availableCount = data[k].availableCount;
                    if (data[k].activityEndTime != '') {
                        activityTime += "至" + data[k].activityEndTime;
                    }
                    var activitySite = data[k].activitySite;
                    if (activitySite == undefined || activitySite == '') {
                        activitySite = data[k].activityAddress;
                    }
                    if (data[k].sysNo != undefined && data[k].sysNo != '' && data[k].sysId != undefined && data[k].sysId != '') {
                        str += '<input name="sysId" type="hidden" value="' + data[k].sysId + '" />';
                    }


                    str += '    <a target="_blank" href="../frontActivity/frontActivityDetail.do?activityId=' + data[k].activityId + '"><img src="' + trueImgUrl + '" width="280" height="185" /></a>';
                    str += '  </div>';
                    str += '  <div class="intro">';
                    str += '    <h3><a target="_blank" href="../frontActivity/frontActivityDetail.do?activityId=' + data[k].activityId + '">' + data[k].activityName + '</a></h3>';
                    str += '    <p>时间：' + activityTime + '</p>';
                    str += '    <p>地点：' + activitySite + '</p>';
                    str += '  </div>';
                    str += '  <div class="do">';
                    if (collectNum > 0) {
                        str += '     <div class="collect"><a class="collected"></a><span>收藏</span></div>';
                    } else {
                        str += '    <div class="collect"><a></a><span>收藏</span></div>';
                    }
                    if (data[k].activityIsReservation == 2) {

                        if (nowDateTime - maxDateTime < 0) {
                            if (availableCount > 0) {
                                str += '    <div class="ticket"><em id="' + data[k].sysId + '">' + availableCount + '</em><span>余票</span></div>';
                                str += ' <a target="_blank" dataId=' + data[k].activityId + ' id="bookType' + data[k].sysId + '" href="../frontActivity/frontActivityDetail.do?activityId=' + data[k].activityId + '" class="reserve">预 订</a>';
                            } else {
                                str += '    <div class="ticket"><em id="' + data[k].sysId + '">' + 0 + '</em><span>余票</span></div>';
                                str += ' <a dataId=' + data[k].activityId + ' class="reserve gray" id="bookType' + data[k].sysId + '">已 订 完</a>';
                            }
                        } else {
                            str += '    <div class="ticket"><em id="' + data[k].sysId + '">' + 0 + '</em><span>余票</span></div>';
                            str += ' <a  dataId=' + data[k].activityId + ' class="reserve gray" id="bookType' + data[k].sysId + '">已 结 束</a>';
                        }

                    }
                    str += '  </div>';
                    str += '</li>';
                }
                isAjax = 0;
                isCanScroll = true;
                nextPage = page + 1;
                loadingIcon.remove();
                $(".ul_list>ul").append(str);
            } else {
                isCanScroll = false;
                isAjax = 1;
                loadingIcon.remove();
            }
        },
        error: function () {
            isAjax = 0;
            loadingIcon.remove();
        }
    }).success(function () {
        getSubSystemTicketCount();
    });
}

var loadingIcon = {
    add: function () {
        if ($(".bg-loading").length > 0) {
            $(".bg-loading").fadeIn(100);
        } else {
            $(".ul_list").append('<span class="btn-loading"></span>');
        }
    },
    remove: function () {
        $(".btn-loading").remove();
    }
};
// 获取热点推荐
function hotelRecommend(page) {
    $("#hotelRecommendDiv").load("../frontIndex/advert.do?type=E #hotelRecommendDivChild", {venueArea: $("#areaCode").val()}, function () {
        getHotelRecommendPicture();
        jQuery("#recommond").slide({
            titCell: ".arrow ul",
            mainCell: ".in-hot ul",
            autoPage: true,
            effect: "left",
            autoPlay: false,
            vis: 1,
            delayTime: 700,
            trigger: "click",
            easing: "easeOutCirc"
        });
    });
}

//异步加载子系统中的余票数
function getSubSystemTicketCount() {
    if ($("input[name='sysId']") != undefined && $("input[name='sysId']").length > 0) {
        $.post("../frontActivity/getSubSystemTicketCount.do", $("#indexForm").serialize(), function (rsData) {
            var jsonObject = jQuery.parseJSON(rsData);
            $.each(jsonObject.tickets, function (k, v) {
                $("#" + k).html(v);
                if (v == '0') {
                    $("#bookType" + k).attr("class", 'reserve gray');
                    $("#bookType" + k).html("已 订 完");
                } else if (v > '0') {
                    $("#bookType" + k).attr("class", 'reserve');
                    $("#bookType" + k).html("预 订");
                    var activityUrl = "../frontActivity/frontActivityDetail.do?activityId=" + $.trim($("#bookType" + k).attr("dataId"));
                    $("#bookType" + k).attr("href", activityUrl);
                }

            })
        });
    }
}