<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>视频列表--文化云</title>
    <%@include file="../../common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <script type="text/javascript">

        $(document).ready(function(){

            $(document).keydown(function(e){
                var curKey = e.which;
                if(curKey == 13){
                    document.getElementById("btnSearch").click();
                    return false;
                }
            });
        });
    </script>
</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em><c:if test="${videoType == 1}">活动管理&gt; 活动列表&gt; 视频管理</c:if>
                             <c:if test="${videoType == 2}">场馆管理&gt; 场馆信息管理&gt; 场馆列表&gt; 视频管理</c:if>
</div>
<form id="videoIndex" action="${path}/video/videoIndex.do" method="post">
<div class="search">
    <div class="search-box">
       <i></i><input id="inputQueryMessger" class="input-text"  name="videoTitle" value="${videos.videoTitle}" type="text" data-val="请输入关键字" />
    </div>
    <div class="form-table" style="float: left;">
        <div class="td-time" style="margin-top: 0px;">
            <div class="start w240" style="margin-left: 8px;">
                <span class="text">开始日期</span>
                <input type="hidden" id="startDateHidden"/>
                <input type="text" id="startTime" name="startTime" value="<fmt:formatDate value="${videos.startTime}" pattern="yyyy-MM-dd" />" readonly/>
                <i class="data-btn start-btn"></i>
            </div>
            <span class="txt" style="line-height: 42px;">至</span>
            <div class="end w240">
                <span class="text">结束日期</span>
                <input type="hidden" id="endDateHidden"/>
                <input type="text" id="endTime" name="endTime" value="<fmt:formatDate value="${videos.endTime}" pattern="yyyy-MM-dd" />"  readonly/>
                <i class="data-btn end-btn"></i>
            </div>
        </div>
    </div>
    <input type="hidden" name="videoType" value="${videoType}" id="videoType"/>
    <input type="hidden" name="referId" value="${referId}" id="referId"/>
    <div class="select-btn">
        <input type="button" onclick="queryByCondition()" id="btnSearch" value="搜索"/>
    </div>
	    <div class="search-total">
	        <div class="select-btn">
	            <input class="btn-add-tag" type="button" value="添加"/>
	        </div>
	    </div>
</div>
    <div class="search menage">
        <h2>${referName}<c:if test="${videoType == 1}">活动视频列表</c:if>
            <c:if test="${videoType == 2}">场馆视频列表</c:if></h2>
    </div>
<div class="main-content">
    <table width="100%">
        <thead>
        <tr>
            <th>ID</th>
            <th>视频标题</th>
            <th>发布人</th>
            <th>发布时间</th>
            <th>操作人</th>
            <th>操作时间</th>
            <th>管理</th>
        </tr>
        </thead>

        <c:if test="${empty list}">
            <tr>
                <td colspan="8"> <h4 style="color:#DC590C">暂无数据!</h4></td>
            </tr>
        </c:if>

        <tbody id="advertImg">

        <c:forEach items="${list}" var="c" varStatus="s">
            <tr id="data-div">
                <td>${s.index+1}</td>
                <td>${c.videoTitle}</td>
                <td>${c.videoCreateUser}</td>
                <td><fmt:formatDate value="${c.videoCreateTime}" pattern="yyyy-MM-dd HH:mm" /></td>
                <td>${c.videoUpdateUser}</td>
                <td><fmt:formatDate value="${c.videoUpdateTime}" pattern="yyyy-MM-dd HH:mm" /></td>
                <td>
                    <a href="javascript:;" onclick="videoEdit('${c.videoId}')">编辑</a>|
                    <a href="javascript:;" onclick="videoDelete('${c.videoId}')">删除</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <input type="hidden" id="page" name="page" value="${page.page}" />
    <c:if test="${not empty list}">
        <div id="kkpager"></div>
    </c:if>

</div>
</form>

<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
    $(function(){
        getPage();//分页
        selectModel();
    });

    //删除
    function videoDelete(videoId){
        dialogConfirm("提示", "是否删除该视频?", function(){
            $.post("${path}/video/deleteVideo.do",{
                videoId:videoId
            }, function(data) {
                if (data!=null && data=='success') {
                    dialogAlert("提示","操作成功",function(){
                        window.location.href="${path}/video/videoIndex.do?referId=" + $("#referId").val()+'&videoType=' + $("#videoType").val();
                    });
                }else{
                    dialogAlert("提示","操作失败,请联系管理员",function(){
                    });
                }
            });
        })
    }

    /**
     * 执行搜索
     */

    function queryAdvert(){
        if($("#inputQueryMessger").val()=="请输入关键字"){
            $("#inputQueryMessger").val("");
        }
        $("#videoIndex").submit();
    }

    function queryByCondition(){
        queryAdvert();
    }
    //** 日期控件
    $(function(){
        $(".start-btn").on("click", function(){
            WdatePicker({el:'startDateHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'',maxDate:'#F{$dp.$D(\'endDateHidden\')}',oncleared:function() {$("#startTime").val("");},position:{left:-224,top:8},isShowClear:true,isShowOK:true,isShowToday:false,onpicked:pickedStartFunc})
        })
        $(".end-btn").on("click", function(){
            WdatePicker({el:'endDateHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'#F{$dp.$D(\'startDateHidden\')}',oncleared:function() {$("#endTime").val("");},position:{left:-224,top:8},isShowClear:true,isShowOK:true,isShowToday:false,onpicked:pickedendFunc})
        })
    });
    function pickedStartFunc(){
        $dp.$('startTime').value=$dp.cal.getDateStr('yyyy-MM-dd');
    }
    function pickedendFunc(){
        $dp.$('endTime').value=$dp.cal.getDateStr('yyyy-MM-dd');
    }
    // 分页
    function getPage(){
        kkpager.generPageHtml({
            pno : '${page.page}',
            total : '${page.countPage}',
            totalRecords :  '${page.total}',
            mode : 'click',//默认值是link，可选link或者click
            click : function(n){
                this.selectPage(n);
                $("#page").val(n);
                queryAdvert();
                return false;
            }
        });
    }

    function messger(){

    }


    seajs.config({
        alias: {
            "jquery": "jquery-1.10.2.js"
        }
    });
    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });

    window.console = window.console || {
        log:function () {

        }
    }
    seajs.use(['jquery'], function ($) {
        $('.btn-add-tag').on('click', function () {
            var referId = $("#referId").val();
            var videoType = $("#videoType").val();
            dialog({
                url: '${path}/video/preAddVideo.do?referId='+referId+'&videoType='+videoType,
                title: '添加视频',
                width: 560,
                height:700,
                fixed: true
            }).showModal();
            return false;
        });
    });

    function videoEdit(videoId){
        var referId = $("#referId").val();
        var videoType = $("#videoType").val();
        dialog({
            url: '${path}/video/preEditVideo.do?referId='+referId+'&videoType='+videoType+'&videoId='+videoId,
            title: '编辑视频',
            width: 560,
            height:700,
            fixed: true,
            data: {
                title: $(this).parent().siblings().text(),
                type: $(this).parents("tr").find(".title").text(),
                imgUrl: $(this).siblings().attr("src")
            } // 给 iframe 的数据
        }).showModal();
        return false;
    }
</script>
</body>
</html>