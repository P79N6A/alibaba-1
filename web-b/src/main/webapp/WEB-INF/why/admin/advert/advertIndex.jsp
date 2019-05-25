<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>轮播图列表--文化云</title>
    <%@include file="../../common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <script type="text/javascript">



        //查询活动中存在的区域
        $(function () {
            var defaultAreaId = $("#activityArea").val();
            $.get("${path}/activity/queryExistArea.do",{'activityState' : $("#activityState").val()},
                    function(areaData) {
                        var ulHtml = "<li data-option=''>全上海市</li>";
                        var divText = "全上海市";
                        if (areaData != '' && areaData != null) {
                            for(var i=1; i<areaData.length; i++){
                                var area = areaData[i].activityArea;
                                var array = area.split(",");
                                var areaId = array[0];
                                var areaText = array[1];
                                ulHtml += '<li data-option="'+areaId+'">'
                                + areaText
                                + '</li>';
                                if(defaultAreaId == areaId){
                                    divText = areaText;
                                }
                            }
                            $("#areaDiv").html(divText);
                            $("#areaUl").html(ulHtml);
                        }
                    }).success(function() {

                    });
        });



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
    <em>您现在所在的位置：</em>推荐管理 &gt;
    <c:choose>
        <c:when test="${LinkType !='APP'}">Web端推荐&gt;轮播图管理</c:when>
        <c:otherwise>App端推荐&gt;首页轮播图</c:otherwise>
    </c:choose>

</div>
<form id="advertIndexForm" action="${path}/advert/advertIndex.do" method="post">
    <div class="search">
        <div class="search-box">
            <i></i><input id="inputQueryMessger" class="input-text"  name="advertTitle" value="${record.advertTitle}" type="text" data-val="请输入关键字" />
        </div>

        <c:if test="${LinkType !='APP'}">
            <div class="select-box w135">
                <input type="hidden" id="displayPosition" name="displayPosition" value="${record.displayPosition}"/>
                <div id="displayPosition" class="select-text" data-value="">全部轮播图</div>
                <ul class="select-option" id="">
                    <li data-option="1">首页轮播图</li>
                    <li data-option="2">场馆列表轮播图</li>
                </ul>
            </div>

            <div class="select-box w135">
                <input type="hidden" id="activityArea" name="advertSite" value="${record.advertSite}"/>
                <div id="areaDiv" class="select-text" data-value="">全上海市</div>
                <ul class="select-option" id="areaUl">
                </ul>
            </div>
        </c:if>
        <!--因为热点推荐和轮播图是走的后台同一方法，所以LinkType代表从哪里链接-->
        <input type="hidden" name="LinkType" value="${LinkType}" id="LinkType"/>
        <div class="select-btn">
            <input type="button" onclick="queryByCondition()" id="btnSearch" value="搜索"/>
        </div>
        <%
            if(advertAddButton) {
        %>
        <div class="search-total">
            <div class="select-btn">
                <input class="btn-add-tag" type="button" value="+ 添加" style="background:#ED3838; "/>
            </div>
        </div>
        <%
            }
        %>

    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <c:choose>
                    <c:when test="${LinkType =='APP'}">
                        <th>轮播图位置</th>
                    </c:when>
                    <c:otherwise>
                        <th>轮播图区县</th>
                    </c:otherwise>
                </c:choose>

                <th>广告标题</th>
                <th>封面图</th>
                <th class="title">尺寸(长*宽)</th>
                <th class="venue">排序</th>
                <th>操作人</th>
                <th>更新时间</th>

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
                    <td>${c.advertColumn}</td>
                    <td>${c.advertTitle}</td>
                    <td data-id="${c.advertPicUrl}">
                        <img src="" data-url="${c.advertPicUrl}"  width="60" height="40"/>
                    </td>
                    <td class="title"> ${c.advertSizeWidth}*${c.advertSizeHeight} </td>
                    <td class="venue">${c.advertPosSort}</td>
                    <td>${c.advertUpdateUser}</td>
                    <td><fmt:formatDate value="${c.advertUpdateTime}" pattern="yyyy-MM-dd HH:mm" /></td>

                    <td>
                        <c:choose>
                            <c:when test="${c.advertState==1}">
                                <%
                                    if(advertEditButton) {
                                %>
                                <a href="javascript:;" onclick="advertEdit('${c.advertId}')">编辑</a> |
                                <%
                                    }
                                %>
                                <%
                                    if(advertDeleteButton) {
                                %>
                                <a onclick="offLineAdvert('${c.advertId}','${c.advertSite}')" href="#">下架</a>
                                <%
                                    }
                                %>
                            </c:when>
                            <c:otherwise>
                                <%-- <a href="javascript:;" onclick="advertEdit('${c.advertId}')">编辑</a> |--%>
                                <%
                                    if(advertEditButton) {
                                %>
                                <a href="javascript:;" onclick="advertEdit('${c.advertId}')">编辑</a> |
                                <%
                                    }
                                %>

                                <%
                                    if(advertDeleteButton) {
                                %>
                                <a onclick="deleteAdvert('${c.advertId}','${c.advertSite}')" href="#">删除</a>|
                                <%
                                    }
                                %>

                                <%
                                    if(recoveryAdvertButton) {
                                %>
                                <a onclick="recoveryAdvert('${c.advertId}','${c.advertSite}','${c.advertPosSort}')"
                                   href="#">上线</a>
                                <%
                                    }
                                %>

                            </c:otherwise>
                        </c:choose>
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
        //异步展示图片
        $("#advertImg Img").each(function(index,item){
            $(this).attr("src",getImgUrl($(this).attr("data-url")));
        });
    });


    //执行下线
    function offLineAdvert(id,siteId){
        var linkType = $("#LinkType").val() ;
        var displayPosition = $("#displayPosition").val()
        var advertSite = $("#activityArea").val();

        dialogConfirm("提示", "是否下线该轮播图?", function(){
            $.post("${path}/advert/deleteAdvert.do",{
                advertId:id,
                siteId:siteId
            }, function(data) {
                if (data!=null && data=='success') {
                    dialogAlert("提示","操作成功",function(){
                        if(linkType =="APP"){
                            window.location.href="${path}/advert/appRecommendadvertlist.do";
                        }else{
                            window.location.href="${path}/advert/advertIndex.do?displayPosition="+displayPosition+"&advertSite="+advertSite;
                        }

                    });
                }else{
                    dialogAlert("提示","操作失败,请联系管理员",function(){

                    });
                }

            });
        })
    }

    //重新上线
    function recoveryAdvert(id,siteId,advertPosSort){

        var linkType = $("#LinkType").val();
        var displayPosition = $("#displayPosition").val()
        var advertSite = $("#activityArea").val();

        dialogConfirm("提示", "是否重新上线该轮播图?", function(){
            $.post("${path}/advert/recovery.do",{
                id:id,
                siteId:siteId,
                advertPosSort:advertPosSort,
                displayPosition:displayPosition
            }, function(data) {
                if (data!=null && data=='success') {
                    dialogAlert("提示","操作成功",function(){
                        if(linkType =="APP"){
                            window.location.href="${path}/advert/appRecommendadvertlist.do";
                        }else{
                            window.location.href="${path}/advert/advertIndex.do?displayPosition="+displayPosition+"&advertSite="+advertSite;
                        }
                    });
                }else if(data=='repeat'){
                    dialogAlert("提示","当前排序已经存在,请修改当前排序或将编辑已存在的排序再做添加!",function(){
                    });
                }else{
                    dialogAlert("提示","操作失败,请联系管理员",function(){
                    });
                }
            });
        })
    }

    //删除
    function deleteAdvert(id,siteId){

        var linkType = $("#LinkType").val();
        var displayPosition = $("#displayPosition").val()
        var advertSite = $("#activityArea").val();

        dialogConfirm("提示", "是否删除该轮播图?", function(){
            $.post("${path}/advert/delete.do",{
                id:id,
                siteId:siteId
            }, function(data) {
                if (data!=null && data=='success') {
                    dialogAlert("提示","操作成功",function(){
                        if(linkType =="APP"){
                            window.location.href="${path}/advert/appRecommendadvertlist.do";
                        }else{
                            window.location.href="${path}/advert/advertIndex.do?displayPosition="+displayPosition+"&advertSite="+advertSite;
                        }
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
        //暂时去掉赵大英 2015.9.12
        /* var tempStr =$("#selectInputTypeDiv").html();
         if($("#advertColumn").val()!=""){
         $("#advertColumn").val(tempStr);
         }*/
        if($("#inputQueryMessger").val()=="请输入关键字"){
            $("#inputQueryMessger").val("");
        }
        var LinkType = $("#LinkType").val();
        if(LinkType == "APP"){
            $("#advertIndexForm").attr("action","${path}/advert/appRecommendadvertlist.do");
        }

        $("#advertIndexForm").submit();
    }

    function queryByCondition(){
        // alert($("#activityArea").val());
        queryAdvert();
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
            var linkType = $("#LinkType").val();
            window.location.href = "${path}/advert/addAdvertShow.do?LinkType="+linkType;
            <%--dialog({--%>
                <%--url: '${path}/advert/addAdvertShow.do?LinkType='+linkType,--%>
                <%--title: '添加轮播图',--%>
                <%--width: 560,--%>
                <%--height:750,--%>
                <%--fixed: true--%>
            <%--}).showModal();--%>
            <%--return false;--%>
        });
    });

    function advertEdit(advertId){
        var tagId = $(this).attr("id");
        var linkType = $("#LinkType").val();
        window.location.href='${path}/advert/editAdvertShow.do?advertId='+advertId+"&LinkType="+linkType;
        <%--dialog({--%>
            <%--url: '${path}/advert/editAdvertShow.do?advertId='+advertId+"&LinkType="+linkType,--%>
            <%--title: '编辑轮播图',--%>
            <%--width: 560,--%>
            <%--height:750,--%>
            <%--fixed: true,--%>
            <%--data: {--%>
                <%--title: $(this).parent().siblings().text(),--%>
                <%--type: $(this).parents("tr").find(".title").text(),--%>
                <%--imgUrl: $(this).siblings().attr("src")--%>
            <%--} // 给 iframe 的数据--%>
        <%--}).showModal();--%>
        <%--return false;--%>
    }

</script>


</body>
</html>