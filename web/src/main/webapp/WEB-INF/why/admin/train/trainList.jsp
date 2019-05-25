<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<head>
    <title>培训讲座</title>
    <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
    <link type="text/css" rel="stylesheet" href="${path}/STATIC/css/normalize.css" />
	<link rel="stylesheet" href="${path}/STATIC/css/owl.carousel.min.css">
	<link rel="stylesheet" href="${path}/STATIC/css/owl.theme.default.min.css">
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/cqStyle.css" />
	<script type="text/javascript" src="${path}/STATIC/js/jquery-1.9.0.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/owl.carousel.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/jquery.SuperSlide.2.1.1.js" ></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/page.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/index_new.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/index/activity/activityDetail.js?version=20160603"></script>
    <script type="text/javascript">

    </script>
</head>
<style>
    #activitySearchType ul.av_list a{
        display:inline-block!important;
    }
    #activitySearchType ul.av_list a.cur{
        border-color: #36c7de;
        background-color: #36c7de;
        color: #fff;
    }
</style>
<body>
<!-- start 头部  -->
<div class="header">
    <!-- 导入头部文件 -->
    <%@include file="/WEB-INF/why/index/header.jsp" %>
</div>
<!-- end 头部  -->
<div id="in_search">
    <input type="hidden" id="activityId" value="${train.id}"/>
    <div class="in_search">
        <div class="prop-attrs prop-attrs-type">
            <div class="attr">
                <div class="attrKey" style="width:75px;padding-right:5px">类型：</div>
                <div class="attrValue" id="activitySearchType">
                    <ul class="av_list">
                        <input type="hidden" name="trainType" id="trainType" style="width: 10px;"/>
                        <a href="#" class="item cur">全部</a>
                        <c:forEach items="${tagList}" var="tag">
                            <a href="#" class="item" v="${tag.tagId}">${tag.tagName}</a>
                        </c:forEach>
                    </ul>
                </div>
                <a class="btn-icon">收起</a>
            </div>
        </div>
        <%--<div class="prop-attrs prop-attrs-area" style="display: block;" id="cityDiv">
            <div id="areaDiv" class="filterWrap clearfix">
                <div class="filterWrap clearfix">
                    <div class="lab">区域</div>
                    <div class="filterRight">
                        <input type="hidden" id="trainArea"/>
                        <input type="hidden" name="venueDept" id="venueDept" value=""/>
                        <input type="hidden" name="venueCity" id="venueCity" value=""/>
                        <input type="hidden" name="areaCode" id="areaCode" value=""/>
                        <input type="hidden" name="venueTown" id="venueTown" value="" />
                        <ul class="filterListYi clearfix" id="areaUl">
                        </ul>
                        <div class="filterChild" style="display: none;">
                            <input type="hidden" name="trainLocation" id="trainLocation" style="width: 10px;"/>
                            <ul class="filterListEr clearfix" id="businessUl">
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>--%>
        <%--      <div class="prop-attrs prop-attrs-area" id="prop-attrs-area" style="display: block" >
                <div id="areaDiv" class="filterWrap clearfix">
                  <div class="lab">区域：</div>
                  <div class="filterRight" id="attr-area">
                      <input type="hidden" name="venueDept" id="venueDept" value=""/>
                      <input type="hidden" name="venueCity" id="venueCity" value=""/>
                      <input type="hidden" name="areaCode" id="areaCode" value=""/>
                      <input type="hidden" name="venueTown" id="venueTown" value="" />
                      <ul class="filterListYi clearfix" id="areaUl">
                      </ul>
                      <div class="filterChild" style="display: none;">
                          <ul class="filterListEr clearfix" id="businessUl">
                          </ul>
                      </div>
                   &lt;%&ndash; <ul class="filterListYi clearfix" id="areaUl">
                      <input type="hidden" id="trainArea"/>
                      <a href="#" class="item cur">全部</a>
                      <c:forEach items="${deptList}" var="dept">
                        <a href="#" class="item" v="${dept.deptId}">${dept.deptName}</a>
                      </c:forEach>
                    </ul>&ndash;%&gt;
                  </div>
                </div>
              </div>--%>
    </div>
</div>

<!--list start-->
<div id="hot_list">
    <!--tit start-->
    <div class="tit clearfix">
        <div class="tit_l fl">
            <input type="hidden" name="sort" id="sort"/>
            <a href="#" class="item cur" v="1">智能排序</a>
            <a href="#" class="item" v="2">最新发布</a>
            <a href="#" class="item" v="3">即将开始</a>
            <a href="#" class="item" v="4">即将结束</a>
        </div>
    </div>
    <!--tit end-->
    <!--list start-->
    <div class="ul_list" id="activityListDivChild">
        <ul class="hl_list clearfix">
        </ul>
    </div>

</div>
<!--list end-->
<div id="kkpager"></div>
<input type="hidden" id="page" value="">
<!-- end 第一部分 -->

<!-- start 底部 -->
<div class="zjFooter">
    <%@include file="/WEB-INF/why/index/footer.jsp" %>
</div>
<!-- end 底部 -->

</body>
<script>
    // 冒泡
    function setStopPropagation(evt) {
        var e = evt || window.event;
        if(typeof e.stopPropagation == 'function') {
            e.stopPropagation();
        } else {
            e.cancelBubble = true;
        }
    }
    $(function(){
        $("#activityLi").addClass('cur').siblings().removeClass('cur');

        $(".btn-icon").click(function () {
            var $this = $(this);
            if($this.hasClass("open")){
                $('#cityDiv').show();
                $this.removeClass("open").text("收起");
            }else{
                $('#cityDiv').hide();
                $this.addClass("open").text("展开");
            }
        });


        //选择菜单弹出二级选项
        $('.filterListYi, .filterListEr').on('click', '.item', function () {
            $(this).addClass('cur').siblings().removeClass('cur');
            if($(this).index() == 0) {
                var id = $(this).attr("id");
                if (id !== undefined && id != null && id != '') {
                    $(this).parent().siblings('.filterChild').show();
                } else {
                    $(this).parent().siblings('.filterChild').hide();
                }

            } else {
                $(this).parent().siblings('.filterChild').show();
            }
        });

        if ('${sessionScope.dwcityInfo}'!="") {
            var deptRemark = parseInt('${sessionScope.dwcityInfo.deptRemark}');
            if (deptRemark < 4) {
                loadArea();
            } else if (deptRemark == 4) {
                $('#areaUl').append('<li class="item cur">'+'${sessionScope.dwcityInfo.deptName}'+'</li>');
            }
        } else {
            loadArea();
        }
        // 头部显示微信公众号
        $(".headerTop .weixin").hover(function () {
            $(this).find(".ewm_code").toggle();
        });
        $('.selDiv dt').bind('click', function () {
            $(this).parent('.selDiv').find('dd').toggle();
        });
        $('.selDiv dd').on('click', 'a', function () {
            $(this).parent('dd').find('a').removeClass('cur');
            $(this).addClass('cur');
            $(this).parents('.selDiv').find('dt').html($(this).html());
            $(this).parent('dd').hide();
        });
        $('html,body').bind('click', function () {
            $('.selDiv dd').hide();
        })
        $('.selDiv').bind('click', function (evt) {
            setStopPropagation(evt)
        });
        // 区域 类型 排序选择
        $('.prop-attrs-type, .prop-attrs-area, .tit').on('click', '.item', function () {
            $(this).addClass('cur').siblings().removeClass('cur');
            var v = $(this).attr('v');
            $(this).parent().find('input').val(v);
            loadDate(1,8);
        })
        loadDate(1,8);
    })
    function clickArea(code){
        $("#trainArea").val(code);
        $("#areaCode").val(code);
        $("#trainLocation").val("");
        //点击上海市时隐藏区县下位置信息
        if(code == ""){
            //$("#businessDiv").hide();
            $("#businessUl").html("");
        }else{
            getBusiness(code);
            $("#").show();
        }

        $("#reqPage").val(1);
    }
    //加载区域
    function loadArea(){
        var cityId = '${areaCode}';
        if('${sessionScope.dwcityInfo}'==""){
            $('#areaUl').append('<li class="item cur" onclick="clickArea(\'\')">全部</li>');
        }
        $.ajax({
            url:"${path}/dept/queryAreaList.do",
            data:{pid:cityId,grade:''},
            dataType:"json",   //返回格式为json
            async:false, //请求是否异步，默认为异步，这也是ajax重要特性
            type:"POST",   //请求方式
            success:function(data){
                //请求成功时处理
                if (data != '' && data != null) {
                    var list = eval(data);
                    for (var i = 0; i < list.length; i++) {
                        var area = list[i];

                        if('${sessionScope.dwcityInfo}'!=""){
                            if('${sessionScope.dwcityInfo.deptId}' == area.deptId){
                                $('#areaUl').append("<li class='item cur' onclick='clickArea(\""+ area.deptId +"\")' id="+area.deptId+">"+area.deptName+"</li>");
                                clickArea(area.deptId);
                                $(".filterChild").show();
                            }
                        }else{
                            $('#areaUl').append("<li class='item' onclick='clickArea(\""+ area.deptId +"\")' id="+area.deptId+">"+area.deptName+"</li>");
                        }
                    }
                }
            }
        })
    }
    function setTrainLocation(id,value){
        $("#trainLocation").val(value);
    }
    //加载镇
    function getBusiness(code){
        var venueTown = $("#venueTown").val();
        $.post("../dept/queryAreaList.do",{pid:code,grade:''}, function(data) {
            var list = eval(data);
            var dictHtml =  '<li class="item cur" onclick="setTrainLocation(\'trainLocation\',\'\')">全部</li>';
            if(data != null && data.length > 0){
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var dictId = obj.deptId;
                    var dictName = obj.deptName;
                    dictHtml += '<li class="item" id="' + dictId + '" onclick="setTrainLocation(\'trainLocation\', \'' + dictId +'\')">'+dictName+'</li>';
                }
                $("#businessUl").html(dictHtml);
                $("#businessDiv").show();
            }else{
                $("#businessUl").html("");
                $("#businessDiv").hide();
            }
        });
    }
    function loadDate (index, pagesize) {
        $.post("${path}/cmsTrain/trainList.do", {
            page: index,
            pageNum: pagesize,
            trainArea:$('#trainArea').val(),
            trainType:$('#trainType').val(),
            trainLocation:$("#trainLocation").val(),
            order:$('#sort').val()
        }, function (data) {
            $("#loadingDiv").hide();
            if (data.status == 0) {
                var html = "";
                if(index==0 && data.data.length==0){
                    $(".peixunList").html('<img style="display: block;position: absolute; top: 0;right: 0;bottom: 0;left: 0; margin: auto;" src="${path}/STATIC/wechat/image/kong.png" />');
                    return;
                }
                console.log("data.page.total===" + data.page.total);
                console.log("data.page.countPage===" + data.page.countPage);
                kkpager.total = data.page.countPage;
                kkpager.totalRecords = data.page.total;
                kkpager.generPageHtml({
                    pno: index,
                    total: data.page.countPage,
                    totalRecords: data.page.total,
                    mode: 'click',//默认值是link，可选link或者click
                    click: function (n) {
                        this.selectPage(n);
                        $("#page").val(n);
                        loadDate(n,8);
                        return false;
                    }
                });
                for(var i=0;i<data.data.length;i++){
                    var obj = data.data[i];
                    if(data.data[i].trainTag.indexOf(",")>-1){
                        var tag = data.data[i].trainTag.split(",")[0];
                    }else{
                        tag = data.data[i].trainTag;
                    }
                    var registrationStartTime = new Date((Date.parse(obj.registrationStartTime)));
                    var registrationEndTime = new Date((Date.parse(obj.registrationEndTime)));
                    var trainStartTime = new Date((Date.parse(obj.trainStartTime)));
                    var trainEndTime = new Date((Date.parse(obj.trainEndTime)));
                    var now = new Date();
                    var baoming = "";
                    if(registrationStartTime > now){
                        baoming = '<div><a class="reserve"   d-id="'+obj.id+'">报名即将开始</a></div>';
                    }
                    if(registrationStartTime < now && registrationEndTime > now){
                        /*                        if(obj.admissionsPeoples < obj.maxPeople && (obj.maxPeople != null || obj.maxPeople != "")){
                                                    baoming = '<div><a class="reserve"  d-id="'+obj.id+'">报名中</a></div>';
                                                }else{
                                                    baoming = '<div><a class="reserve gray"   d-id="'+obj.id+'">名额已满</a></div>';
                                                }*/
                        if(obj.maxPeople != null && obj.maxPeople != ""){
                            if(obj.admissionsPeoples < obj.maxPeople){
                                baoming = '<div><a class="reserve"  d-id="'+obj.id+'">报名中</a></div>';
                            }else{
                                baoming = '<div><a class="reserve gray"   d-id="'+obj.id+'">名额已满</a></div>';
                            }
                        }else{
                            baoming = '<div><a class="reserve"  d-id="'+obj.id+'">报名中</a></div>';
                        }
                    }
                    if(registrationEndTime < now && trainStartTime > now ){
                        baoming = '<div><a class="reserve"   d-id="'+obj.id+'">待开课</a></div>';
                    }
                    if(trainEndTime > now && trainStartTime < now){
                        baoming = '<div><a class="reserve"   d-id="'+obj.id+'">培训中</a></div>';
                    }
                    if(trainEndTime < now){
                        baoming = '<div><a class="reserve gray"  style="width:209px;" d-id="'+obj.id+'">培训已结束</a></div>';
                    }
                    html +='<li>' +
                        '<div class="img" d-id="'+obj.id+'">'+
                        '<a target="_blank">'+
                        '<img src="' + data.data[i].trainImgUrl + '" width="280" height="185" /></a>'+
                        '</div>'+
                        '<div class="intro" d-id="'+obj.id+'">'+
                        '<h3><a target="_blank"</a>' + data.data[i].trainTitle +'</h3>'+
                        '<p>时间：' + obj.trainStartTime + '至'+ obj.trainEndTime + '</p>'+
                        '<p>地点：' + data.data[i].trainAddress + '</p>'+
                        '</div>';
                    html += '<div class="do">';
                    console.log("isCollect =====" + obj.isCollect);
                    if (obj.isCollect > 0) {
                        html += '<div class="collect"><a class="collected"></a><span>收藏</span></div>';
                    } else {
                        html += '<div class="collect"><a></a><span>收藏</span></div>';
                    }
                    if(trainEndTime < now){
                        html += baoming;
                    }else{
                        if(obj.maxPeople != null && obj.maxPeople != ""){
                            html += '<div class="ticket"><em id="' + data.data[i].trainId + '">' + obj.admissionsPeoples +"/"+obj.maxPeople+ '</em><span>报名数</span></div>';
                            html += baoming;
                        }else{
                            html += '<div class="ticket"><em id="' + data.data[i].trainId + '">' + obj.admissionsPeoples + '</em><span>报名数</span></div>';
                            html += baoming;
                        }
                    }
                    html +=  '</div></li>';
                }
                if(index==0){
                    $(".hl_list").html(html);
                }else{
                    $(".hl_list").html(html);
                }

                $(".hl_list li .img,.hl_list li .intro ,.hl_list li .reserve").on('click',function () {
                    location.href='${path}/cmsTrain/trainDetail.do?id='+$(this).attr('d-id');
                })
            }
        }, "json");
    }
</script>

</html>