<%@ page import="java.util.Date" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
    <title>文化云_全面_便捷_趣味_互动_更多免费活动_文化引领品质生活</title>
    <meta name="description" content="登录文化云，立即参与您身边的万场文化活动，优质的文化活动内容，闲暇时间的精神消费首选，体验3公里内的品质文化生活，尽在文化云！">
    <meta name="Keywords" content="文化云、近期活动、培训、演出、讲座、电影、免费、退休、交友、养生、美食、聚会、亲子、赛事、旅行、活动预订、免费活动">
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/frontPageFrame.jsp" %>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css"/>
    <script type="text/javascript">
        //禁用Enter键表单自动提交
        document.onkeydown = function (event) {

            var target, code, tag;
            if (!event) {
                event = window.event; //针对ie浏览器
                target = event.srcElement;
                code = event.keyCode;
                if (code == 13) {
                    tag = target.tagName;
                    if (tag == "TEXTAREA") {
                        return true;
                    }
                    else {
                        return false;
                    }
                }
            }
            else {
                target = event.target; //针对遵循w3c标准的浏览器，如Firefox
                code = event.keyCode;
                if (code == 13) {
                    tag = target.tagName;
                    if (tag == "INPUT") {
                        return false;
                    }
                    else {
                        return true;
                    }
                }
            }
        };
    </script>
    <script type="text/javascript">
        $(function () {
            //$("#search .attr-extra").trigger("click");
            /*搜索排序*/
            $(".sort-box").on("click", ".item", function () {
                var that = $(this);
                if (that.attr("class") == "item") {
                    that.addClass("icon-asc").siblings("a").attr("class", "item");
                } else if (that.hasClass("icon-asc")) {
                    that.removeClass("icon-asc").addClass("icon-desc").siblings("a").attr("class", "item");
                } else if (that.hasClass("icon-desc")) {
                    that.removeClass("icon-desc").addClass("icon-asc").siblings("a").attr("class", "item");
                }
            });
        });
    </script>
    <script type="text/javascript">

        $(function () {
            $("#searchVal").val($("#activityName").val());
            $("#searchSltVal").val("活动");
            $("#searchSltSpan").html("活动");

            doQuery();

            //选中当前label
            $('#activityLabel').addClass('cur').siblings().removeClass('cur');
            /*详情过来的搜索关键词*/
            var key = '<c:out value="${activity.activityName}" escapeXml="true"/>';
            if (key != "") {
                $("#keyword").val(key);
            }

        });

        //主题列表信息
        $(function () {
            if ($("#areaCode").val() != undefined && $("#areaCode").val() != '') {
                var code = $("#areaCode").val();
                $("#areaCode").val(code);
                if (code == "") {
                    $("#businessDiv").hide();
                } else {
                    getBusiness(code);
                }
                $('#' + $("#areaCode").val()).addClass('cur').siblings().removeClass('cur');
            }

            $.post("${path}/tag/getChildTagByType.do?code=ACTIVITY_TYPE", function (data) {
                if (data != '' && data != null) {
                    var list = eval(data);
                    var ulHtml = '<li class="cur"><a href="javascript:setValueById(\'activityType\', \'\');">全部</a></li>';
                    for (var i = 0; i < list.length; i++) {
                        var tag = list[i];
                        ulHtml += '<li id="' + tag.tagId + '"><a href="javascript:setValueById(\'activityType\',\'' + tag.tagId + '\');">' + tag.tagName + '</a></li>';
                    }
                    $('#activityTypeInfo').html(ulHtml);
                }

                //选中类型
                if ($("#activityType").val() != undefined && $("#activityType").val() != '') {
                    $('#' + $("#activityType").val()).addClass('cur').siblings().removeClass('cur');
                }
            });
        });

        // 选择区域
        function clickArea(code) {
            $("#areaCode").val(code);
            $("#activityLocation").val("");
            if (code == "") {
                $("#businessDiv").hide();
            } else {
                getBusiness(code);
            }
            doQuery();
        }

        // 得到商圈
        function getBusiness(code) {
            var activityLocation = $("#activityLocation").val();
            $.post("${path}/sysdict/queryChildSysDictByDictCode.do", {dictCode: code}, function (data) {
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
                    $("#businessUl").html(dictHtml + otherHtml);
                    $("#businessDiv").show();

                    //选中商圈
                    if (activityLocation != undefined && activityLocation != '') {
                        $('#' + activityLocation).addClass('cur').siblings().removeClass('cur');
                    }
                } else {
                    $("#businessDiv").hide();
                }
            });
        }

        //心情
        $(function () {
            //选中
            $.post("${path}/tag/getChildTagByType.do?code=ACTIVITY_MOOD", function (data) {
                if (data != '' && data != null) {
                    var list = eval(data);
                    var ulHtml = '<li class="cur"><a href="javascript:setValueById(\'activityMood\', \'\');">全部</a></li>';
                    for (var i = 0; i < list.length; i++) {
                        var tag = list[i];
                        ulHtml += '<li><a href="javascript:setValueById(\'activityMood\',\'' + tag.tagId + '\');">' + tag.tagName + '</a></li>';
                    }
                    $('#activityMoodInfo').html(ulHtml);
                }
            });
        });

        //异步加载图片
        function getPicture() {
            $("#data-ul li").each(function (index, item) {
                var imgUrl = $(this).attr("data-li-url");
                if (imgUrl == undefined || imgUrl == "") {
                    $(item).find("img").attr("src", "../STATIC/image/default.jpg");
                } else {
                    imgUrl = getIndexImgUrl(getImgUrl(imgUrl), "_300_300");
                    $(item).find("img").attr("src", imgUrl);
                }
            });
        }
        //异步加载子系统中的余票数
        function getSubSystemTicketCount() {
            /*    $("input[name='sysId']").each(function(){
             alert($(this).val());
             })*/
            if ($("input[name='sysId']") != undefined && $("input[name='sysId']").length > 0) {
                $.post("${path}/frontActivity/getSubSystemTicketCount.do", $("#activityForm").serialize(), function (rsData) {
                    var jsonObject = jQuery.parseJSON(rsData);
                    $.each(jsonObject.tickets, function (k, v) {
                        $("#" + k).html(v);
                    })
                })
            }
        }
        //查询
        function doQuery() {
            $("#loadListId").load("${path}/frontActivity/frontActivityListLoad.do", $("#activityForm").serialize(), function () {
                getPicture();
                getSubSystemTicketCount();
                //分页
                kkpager.generPageHtml({
                    pno: $("#pages").val(),
                    //总页码
                    total: $("#countpage").val(),
                    //总数据条数
                    totalRecords: $("#total").val(),
                    mode: 'click',
                    click: function (n) {
                        this.selectPage(n);
                        $("#page").val(n);
                        doQuery();
                        return false;
                    }
                });

            });

        }
        //选中时赋值
        function setValueById(id, value) {
            $("#" + id).val(value);
            doQuery();
        }
    </script>

</head>
<body>
<!-- 导入头部文件 -->
<div class="header">
	<%@include file="../header.jsp" %>
</div>

<form name="activityForm" id="activityForm" method="post">

    <input type="hidden" name="activityName" id="activityName"
           value="<c:out value="${activity.activityName}" escapeXml="true"/>"/>
    <input type="hidden" name="activityLocation" id="activityLocation" value="${activity.activityLocation}"/>
    <input type="hidden" id="page" name="page" value="1">

    <div class="crumb"><i></i>您所在的位置： 活动 &gt; 活动列表</div>

    <div id="search">
        <div class="search">
            <div class="prop-attrs">
                <div class="attr">
                    <div class="attrKey">区域</div>
                    <div class="attrValue">
                        <ul class="av-expand">
                            <input type="hidden" name="activityArea" id="areaCode" value="${activity.activityArea}"/>
                            <li class="cur"><a href="javascript:clickArea('');">上海市</a></li>
                            <li id="46"><a href="javascript:clickArea('46');">黄浦区</a></li>
                            <li id="48"><a href="javascript:clickArea('48');">徐汇区</a></li>
                            <li id="50"><a href="javascript:clickArea('50');">静安区</a></li>
                            <li id="49"><a href="javascript:clickArea('49');">长宁区</a></li>
                            <li id="51"><a href="javascript:clickArea('51');">普陀区</a></li>
                            <li id="52"><a href="javascript:clickArea('52');">闸北区</a></li>
                            <li id="53"><a href="javascript:clickArea('53');">虹口区</a></li>
                            <li id="54"><a href="javascript:clickArea('54');">杨浦区</a></li>
                            <li id="58"><a href="javascript:clickArea('58');">浦东新区</a></li>
                            <li id="56"><a href="javascript:clickArea('56');">宝山区</a></li>
                            <li id="57"><a href="javascript:clickArea('57');">嘉定区</a></li>
                            <li id="60"><a href="javascript:clickArea('60');">松江区</a></li>
                            <li id="61"><a href="javascript:clickArea('61');">青浦区</a></li>
                            <li id="55"><a href="javascript:clickArea('55');">闵行区</a></li>
                            <li id="59"><a href="javascript:clickArea('59');">金山区</a></li>
                            <li id="63"><a href="javascript:clickArea('63');">奉贤区</a></li>
                            <li id="64"><a href="javascript:clickArea('64');">崇明县</a></li>
                        </ul>
                        <!-- <a href="javascript:;" class="av-more"><b></b>展开</a> -->
                    </div>
                </div>
            </div>
            <div class="prop-attrs hot-attrs" id="businessDiv" style="display: none">
                <div class="attr">
                    <div class="attrKey" style="background:none;"></div>
                    <div class="attrValue">
                        <ul class="av-expand" id="businessUl"></ul>
                    </div>
                </div>
            </div>

            <div class="prop-attrs" style="display: none">
                <div class="attr">
                    <div class="attrKey">时间</div>
                    <div class="attrValue">
                        <ul class="av-collapse data_pre_ul">
                            <li class="cur"><a href="javascript:;" onclick="cleanTime();">全部</a></li>
                            <li><a href="javascript:;" onclick="todayTime();">今天</a></li>
                            <li><a href="javascript:;" onclick="yesterdayTime();">明天</a></li>
                            <li><a href="javascript:;" onclick="weekendTime();">本周末</a></li>
                            <li><a href="javascript:;" onclick="thisweekTime();">本周</a></li>
                        </ul>
                        <div class="av-calender">
                            <div class="start">
                                <span class="text">开始日期</span>
                                <input type="hidden" id="startDateHidden"/>
                                <input type="text" id="activityStartTime" name="activityStartTime" value="" readonly/>
                                <span class="week" id="startWeek"></span>
                                <i class="data-btn start-btn"></i>
                                <script type="text/javascript">
                                    $(function () {
                                        $(".start-btn").on("click", function () {
                                            WdatePicker({
                                                el: 'startDateHidden',
                                                dateFmt: 'yyyy-MM-dd DD',
                                                doubleCalendar: true,
                                                maxDate: '#F{$dp.$D(\'endDateHidden\')}',
                                                position: {left: -225, top: 4},
                                                isShowClear: false,
                                                isShowOK: false,
                                                isShowToday: false,
                                                onpicked: pickedStartFunc
                                            })
                                        })
                                        $(".end-btn").on("click", function () {
                                            WdatePicker({
                                                el: 'endDateHidden',
                                                dateFmt: 'yyyy-MM-dd DD',
                                                doubleCalendar: true,
                                                minDate: '#F{$dp.$D(\'startDateHidden\')}',
                                                position: {left: -225, top: 4},
                                                isShowClear: false,
                                                isShowOK: false,
                                                isShowToday: false,
                                                onpicked: pickedEndFunc
                                            })
                                        })
                                    });
                                    function pickedStartFunc() {
                                        $dp.$('activityStartTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
                                        $dp.$('startWeek').innerHTML = $dp.cal.getDateStr('DD');
                                        doQuery();
                                    }
                                    function pickedEndFunc() {
                                        $dp.$('activityEndTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
                                        $dp.$('endWeek').innerHTML = $dp.cal.getDateStr('DD');
                                        doQuery();
                                    }
                                    function cleanTime() {
                                        $('#startDateHidden,#activityStartTime,#endDateHidden,#activityEndTime').val("");
                                        $('#startWeek,#endWeek').text("");
                                        doQuery();
                                    }
                                    ;
                                    function getDateStr(dd) {	//得到String格式时间
                                        var y = dd.getFullYear();
                                        var m = dd.getMonth() + 1;
                                        m = parseInt(m, 10);
                                        if (m < 10) {
                                            m = "0" + m;
                                        }
                                        var d = dd.getDate();
                                        d = parseInt(d, 10);
                                        if (d < 10) {
                                            d = "0" + d;
                                        }
                                        return y + "-" + m + "-" + d;
                                    }
                                    function todayTime() {	//今天
                                        var dd = new Date();
                                        $('#activityStartTime').val(getDateStr(dd));
                                        $('#activityEndTime').val(getDateStr(dd));
                                        var dayNames = new Array("星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六");
                                        $('#startWeek').text(dayNames[dd.getDay()]);
                                        $('#endWeek').text(dayNames[dd.getDay()]);
                                        doQuery();
                                    }
                                    function yesterdayTime() {	//明天
                                        var dd = new Date();
                                        dd.setTime(dd.getTime() + 1000 * 60 * 60 * 24);
                                        $('#activityStartTime').val(getDateStr(dd));
                                        $('#activityEndTime').val(getDateStr(dd));
                                        var dayNames = new Array("星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六");
                                        $('#startWeek').text(dayNames[dd.getDay()]);
                                        $('#endWeek').text(dayNames[dd.getDay()]);
                                        doQuery();
                                    }
                                    function weekendTime() {		//本周末
                                        var weekday = (new Date()).getDay();
                                        var sat = new Date(1000 * 60 * 60 * 24 * (6 - weekday) + (new Date()).getTime());
                                        var sun = new Date(1000 * 60 * 60 * 24 * (7 - weekday) + (new Date()).getTime());
                                        $('#activityStartTime').val(getDateStr(sat));
                                        $('#activityEndTime').val(getDateStr(sun));
                                        var dayNames = new Array("星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六");
                                        $('#startWeek').text(dayNames[sat.getDay()]);
                                        $('#endWeek').text(dayNames[sun.getDay()]);
                                        doQuery();
                                    }
                                    function thisweekTime() {	//本周
                                        var weekday = (new Date()).getDay();
                                        var mon = new Date(1000 * 60 * 60 * 24 * (1 - weekday) + (new Date()).getTime());
                                        var sun = new Date(1000 * 60 * 60 * 24 * (7 - weekday) + (new Date()).getTime());
                                        $('#activityStartTime').val(getDateStr(mon));
                                        $('#activityEndTime').val(getDateStr(sun));
                                        var dayNames = new Array("星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六");
                                        $('#startWeek').text(dayNames[mon.getDay()]);
                                        $('#endWeek').text(dayNames[sun.getDay()]);
                                        doQuery();
                                    }
                                </script>
                            </div>
                            <div class="end">
                                <span class="text">结束日期</span>
                                <input type="hidden" id="endDateHidden"/>
                                <input type="text" name="activityEndTime" id="activityEndTime" value="" readonly/>
                                <span class="week" id="endWeek"></span>
                                <i class="data-btn end-btn"></i>
                            </div>
                        </div>
                        <a href="javascript:;" class="av-more fold" style="display: none;"><b></b>收起</a>
                    </div>
                </div>
            </div>
            <div class="prop-attrs" style="display: none">
                <div class="attr">
                    <div class="attrKey">类型</div>
                    <div class="attrValue">
                        <input type="hidden" name="activityType" id="activityType" value="${activity.activityType}"/>
                        <ul class="av-expand" id="activityTypeInfo">
                        </ul>
                        <a class="av-more fold" style="display: none;"><b></b>收起</a>
                    </div>
                </div>
            </div>
        </div>
        <div class="advanced">
            <div class="attr-extra">
                <span>更多选项</span><b></b>
            </div>
        </div>
    </div>
    <div id="loadListId">
    </div>
    <!-- 导入foot文件 start -->
	<%@include file="/WEB-INF/why/index/footer.jsp" %>
</form>
</body>
</html>