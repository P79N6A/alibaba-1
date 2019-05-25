<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>安康文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp" %>
    <link type="text/css" rel="stylesheet" href="${path}/STATIC/css/normalize.css"/>
    <link type="text/css" rel="stylesheet" href="${path}/STATIC/css/styleChild.css"/>

    <script type="text/javascript" src="${path}/STATIC/aliImage/crypto.js"></script>
    <script type="text/javascript" src="${path}/STATIC/aliImage/hmac.js"></script>
    <script type="text/javascript" src="${path}/STATIC/aliImage/sha1.js"></script>
    <script type="text/javascript" src="${path}/STATIC/aliImage/base64.js"></script>
    <script type="text/javascript" src="${path}/STATIC/aliImage/plupload.full.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/aliImage/upload.js"></script>
    <script type="text/javascript" src="${path}/STATIC/aliImage/uuid.js"></script>

    <style type="text/css">
        html, body {
            background-color: #f6f6f6;
        }
        .btn-loading{
            display: block;
            border: 0;
            height: 75px;
            text-indent: -99em;
            overflow: hidden;
            background: url(${paht}/STATIC/image/btn-loading.gif) center center no-repeat;
        }
    </style>
</head>
<body>
<div class="header">
    <%@include file="../header.jsp" %>
</div>

<!-- start 面包屑导航  -->
<div class="breadCrumbs jzCenter">
    所在的位置：文化联盟&nbsp;&gt;&nbsp;${param.leagueName}&nbsp;&gt;&nbsp;${member.memberName}
</div>
<!-- end 面包屑导航  -->

<!-- start banner  -->
<div class="bannerCommon">
    <div class="bd">
        <ul class="picList">
            <c:forEach items="${member.images.split(',')}" var="img">
                <li><a href="javascript:;"><img src="${img}"/></a></li>
            </c:forEach>
        </ul>
    </div>
    <div class="hd">
        <ul>
            <c:forEach items="${member.images.split(',')}" var="img">
                <li></li>
            </c:forEach>
        </ul>
    </div>
</div>
<script type="text/javascript">
    $(function () {
        //$('.bd ul>li img').picFullCentered({'boxWidth': 1200, 'boxHeight': 500});
        jQuery(".bannerCommon").slide({mainCell: ".bd ul", effect: "leftLoop", autoPlay: true, interTime: 3500});
    });
</script>
<!-- end banner  -->

<div class="jzCenter" style="font-size: 23px;color: #333333;padding: 18px 0;">${member.memberName}</div>
<input type="hidden" id="memberName" value="${member.memberName}"/>
<div class="jzCenter clearfix" style="margin-bottom: 30px;">
    <div style="float: left;width: 300px;">
        <div class="unionIntroZuo">
            <div class="tit">简介</div>
            <div class="cont">
                ${member.introduction}
            </div>
        </div>
        <div class="unionMapZuo">
            <div id="unionMap" style="width: 100%;height: 205px;"></div>

            <script type="text/javascript"
                    src="http://webapi.amap.com/maps?v=1.3&key=de421f9a41545db0c1c39cbb84f32163"></script>
        </div>
        <script type="text/javascript">
            var unionMap = new AMap.Map('unionMap', {
                resizeEnable: true,
                zoom: 19,
                center: [${member.lng},${member.lat}]
            });
            var marker = new AMap.Marker({
                position: new AMap.LngLat(${member.lng}, ${member.lat})
            });
            unionMap.add(marker);
        </script>
    </div>
    <div style="float: right;width: 880px;border: 1px solid #b1b1b1;padding-bottom: 20px;">
        <ul class="headNavList unionNavList clearfix">
            <li class="cur"><a href="javascript:;">首 页</a></li>
            <li type="activity"><a href="javascript:;">文化活动</a></li>
            <li type="venue"><a href="javascript:;">文化场馆</a></li>
            <li type="culturalOrder"><a href="javascript:;">文化点单</a></li>
            <li type="info"><a href="javascript:;">动态资讯</a></li>
            <li type="comment"><a href="javascript:;">用户留言</a></li>
        </ul>
        <div class="unionXiaCeng">
            <div  class="unionItem" id="index">
                <div id="hot_list" class="unionVenueList unionHotActList">
                    <div class="unionRightTit clearfix">文化活动<a class="more" href="javascript:showMore('activity');">查看全部&nbsp;&gt;&gt;</a></div>
                    <ul class="hl_list clearfix">
                    </ul>
                </div>
                <div class="unionCommonDiv">
                    <div class="unionRightTit clearfix">文化场馆<a class="more" href="javascript:showMore('venue');">查看全部&nbsp;&gt;&gt;</a></div>
                    <ul class="venue_ul unionVenueList clearfix">

                    </ul>
                </div>
                <div class="unionCommonDiv">
                    <div class="unionRightTit clearfix">
                        <span class="fl">文化点单</span>
                        <div class="unionOrderNavOne">
                            <span class="cur" culturalOrderLargeType="1">我要参与</span>
                            <span culturalOrderLargeType="2">我要邀请</span>
                        </div>
                        <a class="more" href="javascript:showMore('culturalOrder');">查看全部&nbsp;&gt;&gt;</a>
                    </div>
                    <div class="diandanWc">
                        <ul class="unionUlList unionUlList-san clearfix" style="width: 855px;" id="culturalOrderUl">
                        </ul>
                    </div>
                </div>
                <div class="unionCommonDiv">
                    <div class="unionRightTit clearfix">动态资讯<a class="more" href="javascript:showMore('info');">查看全部&nbsp;&gt;&gt;</a></div>
                    <ul class="unionUlList unionUlList-san clearfix" style="width: 855px;" id="member_index_info">
                    </ul>
                </div>
                <div class="unionCommonDiv">
                    <div class="unionRightTit clearfix">用户留言<a class="more" href="javascript:showMore('comment');">查看全部&nbsp;&gt;&gt;</a></div>
                    <ul class="leaveComments clearfix" id="member_comment_ul">

                    </ul>
                </div>
            </div>
            <div class="unionItem" style="display: none;" id="content_div"></div>
       <%--     <div class="unionItem" style="display: none;" id="venue"></div>
            <div class="unionItem" style="display: none;" id="diandan"></div>
            <div class="unionItem" style="display: none;" id="info"></div>
            <div class="unionItem" style="display: none;" id="comment"></div>--%>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/why/index/footer.jsp" %>
</body>

<script type="text/javascript">
    function showMore(type) {
        $('.unionNavList li').removeClass('cur');
        $('.unionNavList li').each(function () {
            if($(this).attr('type') == type) {
                $(this).addClass('cur');
            }
        });

        $('.unionXiaCeng .unionItem').hide();
        $('.unionXiaCeng .unionItem').eq(1).show();

        if(type=='comment'){
            $("#content_div").load("../member/memberComment.do?rows=10&id=${member.id}",function () { });
        }else if(type=='activity'){
            $("#content_div").load("../member/activityList.do?id=${member.id}",function () { });
        }else if(type=='venue'){
            $("#content_div").load("../member/venueList.do?id=${member.id}",function () { });
        }else if(type=='info'){
            $("#content_div").load("../member/infoList.do?id=${member.id}",function () { });
        }else if(type=='culturalOrder'){
            $("#content_div").load("../member/culturalOrderList.do?id=${member.id}",function () { });
        }
    }
    $(function () {

        $('.unionNavList').on('click', 'li', function () {
            $(this).addClass('cur').siblings().removeClass('cur');
            var index = $(this).index();
            if(index > 0)  index = 1;

            $('.unionXiaCeng .unionItem').hide();
            $('.unionXiaCeng .unionItem').eq(index).show();

            if($(this).attr("type")=='comment'){
                $("#content_div").load("../member/memberComment.do?rows=10&id=${member.id}",function () {
                });
            }else if($(this).attr("type")=='activity'){
                $("#content_div").load("../member/activityList.do?id=${member.id}",function () {
                });
            }else if($(this).attr("type")=='venue'){
                $("#content_div").load("../member/venueList.do?id=${member.id}",function () {
                });
            }else if($(this).attr("type")=='info'){
                $("#content_div").load("../member/infoList.do?id=${member.id}",function () {
                });
            }else if($(this).attr("type")=='culturalOrder'){
                $("#content_div").load("../member/culturalOrderList.do?id=${member.id}",function () { });
            }
        });

        $("#leagueIndex").addClass('cur').siblings().removeClass('cur');

        loadActivityData(1);
        loadVenueData();
        loadInfoData();
        loadCommentList(1);

        $(function () {
            $('.unionOrderNavOne').on('click', 'span', function () {
                $(this).addClass('cur').siblings().removeClass('cur');
                loadCulturalOrderData($(this).attr('culturalOrderLargeType'));
                //$('.diandanWc .unionUlList-san').hide();
                //$('.diandanWc .unionUlList-san').eq($(this).index()).show();
            });
        });


        loadCulturalOrderData(1);
    });


    function loadActivityData() {
        $.ajax({
            url: "../member/activityQueryList.do",
            method: "post",
            dataType: "json",
            data: {id: '${member.id}', rows: 3},
            success: function (result) {
                var rsObj = jQuery.parseJSON(result);
                var data = rsObj.list;
                if (data.length > 0) {
                    var str = '';
                    for (var k in data) {
                        str += '<li>';
                        str += '  <div class="img">';
                        var imgUrl = data[k].activityIconUrl;
                        var trueImgUrl;
                        var index = imgUrl.lastIndexOf("http:");
                        if (index > -1) {
                            trueImgUrl = imgUrl;
                        }
                        else
                            trueImgUrl = getIndexImgUrl(getImgUrl(imgUrl), "_300_300");

                        var activityTime = data[k].activityStartTime;
                        //判断是否过期
                        var maxDateTime = "";
                        if (data[k].activityEndTime != undefined && data[k].activityEndTime != '') {
                            var maxDate = data[k].activityEndTime.substr(0, 16);
                            maxDateTime = new Date(maxDate.replace(/-/g, "/"));
                        }
                        var nowDateTime = new Date();
                        //是否收藏
                        var collectNum = data[k].collectNum;
                        var availableCount = data[k].availableCount;
                        if (data[k].activityEndTime != undefined && data[k].activityEndTime != '') {
                            activityTime += "至" + data[k].activityEndTime;
                        }
                        var activitySite = data[k].activitySite;
                        if (activitySite == undefined || activitySite == '') {
                            activitySite = data[k].activityAddress;
                        }
                        if (activitySite.length > 36) {
                            activitySite = activitySite.substr(0, 36);
                            activitySite += "...";
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

                        } else {
                            if (nowDateTime - maxDateTime < 0) {
                                str += ' <a href="../frontActivity/frontActivityDetail.do?activityId=' + data[k].activityId + '"  dataId=' + data[k].activityId + ' class="traffic" id="bookType' + data[k].sysId + '">直 接 前 往</a>';

                            } else {
                                str += ' <a href="../frontActivity/frontActivityDetail.do?activityId=' + data[k].activityId + '"  dataId=' + data[k].activityId + ' class="traffic gray" id="bookType' + data[k].sysId + '">已 结 束</a>';
                            }
                        }
                        str += '  </div>';
                        str += '</li>';
                    }
                    $(".hl_list").append(str);
                }
            }
        });
    }

    var loadingIcon = {
        add: function () {
            if ($(".bg-loading").length > 0) {
                $(".bg-loading").fadeIn(100);
            } else {
                $("#content_div").append('<span class="btn-loading"></span>');
            }
        },
        remove: function () {
            $(".btn-loading").remove();
        }
    }

    function loadVenueData() {
        $.ajax({
            url: "../member/venueQueryList.do",
            method: "post",
            dataType: "json",
            data: {id: '${member.id}', rows: 3},
            success: function (result) {
                var rsObj = jQuery.parseJSON(result);
                var data = rsObj.list;
                if (data.length > 0) {
                    var str = '';
                    for (var k in data) {
                        var obj = data[k];
                        var jiaotong = "";
                        if (obj.venueHasMetro == 2 && obj.venueHasBus == 3) {
                            jiaotong = '地铁、公交';
                        } else if (obj.venueHasMetro = 2 && obj.venueHasBus == 1) {
                            jiaotong = '地铁';
                        } else if (obj.venueHasMetro == 1 && obj.venueHasBus == 2) {
                            jiaotong = '公交';
                        }
                        var province = obj.venueProvince.split(',')[1];
                        var city = obj.venueCity.split(',')[1];
                        var area = obj.venueArea.split(',')[1];

                        var imgUrl = obj.venueIconUrl;
                        var trueImgUrl;
                        var index = imgUrl.lastIndexOf("http:");
                        if (index > -1) {
                            trueImgUrl = imgUrl;
                        }
                        else
                            trueImgUrl = getIndexImgUrl(getImgUrl(imgUrl), "_300_300");


                        str += '<li>\n';

                        if (obj.venueIsReserve == 2) {
                            str += '\t\t\t\t\t\t <div class="order">订</div>\n';
                        }

                        str += '\t\t\t\t\t\t <a href="/frontVenue/venueDetail.do?venueId=' + obj.venueId + '" class="img" target="_blank">\n' +
                            '\t\t\t\t\t\t\t <img onload="fixImage(this, 280, 187)" src="' + trueImgUrl + '" width="280" height="186">\n' +
                            '\t\t\t\t\t\t </a>\n' +
                            '\t\t\t\t\t\t <div class="info">\n' +
                            '\t\t\t\t\t\t\t <h1><a target="_blank" href="/frontVenue/venueDetail.do?venueId=4e0b5a08d934434c8882896f3076375f">' + obj.venueName + '</a></h1>\n' +
                            '\t\t\t\t\t\t\t <!-- <div class="start" tip="5"><p></p></div> -->\n' +
                            '\t\t\t\t\t\t\t <div class="text">\n' +
                            '\t\t\t\t\t\t\t\t <p title="' + province + '&nbsp;' + city + '&nbsp;' + area + obj.venueAddress + '"><span>地址:</span>' + province + '&nbsp;' + city + '&nbsp;' + area + obj.venueAddress + '</p>\n' +
                            '\t\t\t\t\t\t\t\t <p>\n' +
                            '\t\t\t\t\t\t\t\t\t <span>交通:</span>' + jiaotong + '\n' +
                            '\t\t\t\t\t\t\t\t </p>\n' +
                            '\t\t\t\t\t\t\t </div>\n' +
                            '\t\t\t\t\t\t </div>\n' +
                            '\t\t\t\t\t </li>';
                    }
                    $(".venue_ul").append(str);
                }
            }
        });
    }

    function loadInfoData() {
        $.ajax({
            url: "../member/infoQueryList.do",
            method: "post",
            dataType: "json",
            data: {id: '${member.id}', rows: 3},
            success: function (result) {
                var rsObj = jQuery.parseJSON(result);
                var data = rsObj.list;
                if (data.length > 0) {
                    var str = '';
                    for (var k in data) {
                        var obj = data[k];
                        //beipiaoInfo/bpInfoDetail.do?infoId=90a0bd91fd3c42e894cbc88aabecb39b
                        str+=' <li onclick="window.location.href=\'${path}/beipiaoInfo/bpInfoDetail.do?infoId='+obj.beipiaoinfoId+'\'" class="qyItem" style="height: 280px;">\n' +
                            '                    <div class="pic">\n' +
                            '                        <img src="'+obj.beipiaoinfoHomepage+'">\n' +
                            '                    </div>\n' +
                            '                    <div class="char">\n' +
                            '                        <p class="name">'+obj.beipiaoinfoTitle+'</p>\n' +
                            '                        <p class="info">'+obj.beipiaoinfoContent+'</p>\n' +
                            '                    </div>\n' +
                            '                </li>';
                    }
                    $("#member_index_info").html(str);
                }
            }
        });
    }


    function loadCulturalOrderData(culturalOrderLargeType) {
        $.ajax({
            url: "../member/loadCulturalOrderList.do",
            method: "post",
            dataType: "json",
            data: {id: '${member.id}', rows: 3,page:1,culturalOrderLargeType:culturalOrderLargeType},
            success: function (result) {
                var str = '';
                var rsObj = jQuery.parseJSON(result);
                var data = rsObj.list;
                if (data.length > 0) {
                    var rsObj = jQuery.parseJSON(result);
                    var data = rsObj.list;
                    if (data.length > 0) {
                        for (var k in data) {
                            var obj = data[k];
                            if(culturalOrderLargeType==1){
                                var date1 = new Date(obj.startDate);
                                var date2 = new Date(obj.endDate);
                            }else{
                                var date1 = new Date(obj.culturalOrderStartDate);
                                var date2 = new Date(obj.culturalOrderEndDate);
                            }
                            var startDate  =  date1.Format('yyyy-MM-dd');
                            var endDate = date2.Format('yyyy-MM-dd')
                            str+='<li class="qyItem" style="height: 280px;" onclick="window.open(\'../culturalOrder/culturalOrderDetail.do?culturalOrderId='+obj.culturalOrderId+'&culturalOrderLargeType='+culturalOrderLargeType+'\')">\n' +
                                '            <div class="pic">\n' +
                                '                <img src="'+obj.culturalOrderImg+'">\n' +
                                '            </div>\n' +
                                '            <div class="char">\n' +
                                '                <p class="name">'+obj.culturalOrderName+'</p>\n' +
                                '                <p class="info">日期：'+startDate+'至'+endDate+'</p>\n' +
                                '            </div>\n' +
                                '        </li>';

                        }
                    }
                }
               $("#culturalOrderUl").html(str);
            }
        });
    }


    /**
     * 加载推荐评论列表
     */
    function loadCommentList(){
        $("#comment-list-div ul").html();
        var data = {rows:3,commentType: 21,"commentRkId" :'${member.id}'};
        $.post("../comment/commentList.do",data ,
            function(data) {
                var commentHtml = "";
                if(data != null && data != ""){
                    for(var i=0; i<data.length; i++){


                        var comment = data[i];
                        var commentRemark = comment.commentRemark.replace(/</g,'&lt;').replace(/>/g,'&gt;');
                        var commentTime = comment.commentTime;
                        var commentUserName = comment.commentUserName;
                        var userHeadImgUrl = comment.userHeadImgUrl;
                        var commentImgUrl = comment.commentImgUrl;
                        var userSex = comment.userSex;

                        if(userHeadImgUrl != null && userHeadImgUrl !="") {
                            if(userHeadImgUrl.indexOf("http")==-1){
                                userHeadImgUrl = getUserImgUrl(userHeadImgUrl);
                            }
                        }else{
                            if(userSex == 1){
                                userHeadImgUrl = "${path}/STATIC/image/face_boy.png";
                            }else if(userSex == 2){
                                userHeadImgUrl = "${path}/STATIC/image/face_girl.png";
                            }else{
                                userHeadImgUrl = "${path}/STATIC/image/face_secrecy.png";
                            }
                        }
                        //var imgUrl = getCommentImgUrl(commentImgUrl);





                        commentHtml +=' <li>\n' +
                            '                            <div class="topBox clearfix">\n' +
                            '                                <div class="avatar"><img src="'+userHeadImgUrl+'"></div>\n' +
                            '                                <div class="char">\n' +
                            '                                    <div class="name">'+commentUserName+'</div>\n' +
                            '                                    <div class="time">'+commentTime+'</div>\n' +
                            '                                </div>\n' +
                            '                            </div>\n' +
                            '                            <div class="cont">\n'+ commentRemark +
                            '                            </div>\n' +
                            '                        </li>';
                    }
                }
                $("#member_comment_ul").html(commentHtml);
        });
    }

    function getCommentImgUrl(commentImgUrl){
        if(commentImgUrl == undefined || commentImgUrl == "" || commentImgUrl == null){
            return "";
        }
        var allUrl = commentImgUrl.split(";");
        var imgDiv = '<div class="wk"><div class="pld_img_list">';
        for(var i=0;i<allUrl.length;i++){
            if(allUrl[i] == undefined || allUrl[i] == "" || allUrl[i] == null){
                continue;
            }
            commentImgUrl = getImgUrl(allUrl[i]);
            commentImgUrl = getIndexImgUrl(commentImgUrl, "_300_300");
            imgDiv = imgDiv + "<div class='pld_img fl'><img src='"+commentImgUrl+"' onload='fixImage(this, 75, 50)'/></div>";
        }
        imgDiv = imgDiv + "</div><div class='after_img'><div class='do'><a href='javascript:void(0)' class='shouqi'>" +
            "<span><img src='../STATIC/image/shouqi.png' width='8' height='11' /></span>收起</a><a href='#' class='yuantu'>" +
            "<span><img src='../STATIC/image/fangda.png' width='11' height='11'/></span>原图</a></div><img src='' class='fd_img'/></div></div>";
        return imgDiv;
    }


    // 对Date的扩展，将 Date 转化为指定格式的String
    // 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符，
    // 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字)
    Date.prototype.Format = function (fmt) {
        var o = {
            "M+": this.getMonth() + 1, //月份
            "d+": this.getDate(), //日
            "H+": this.getHours(), //小时
            "m+": this.getMinutes(), //分
            "s+": this.getSeconds(), //秒
            "q+": Math.floor((this.getMonth() + 3) / 3), //季度
            "S": this.getMilliseconds() //毫秒
        };
        if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
        for (var k in o)
            if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        return fmt;
    }
</script>
</html>