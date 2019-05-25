<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>场馆列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript">
        $(function() {
        	//区县搜索
            var defaultAreaId = $("#areaData").val();
            $.post("${path}/venue/getLocArea.do",function(areaData) {
                var ulHtml = "<li data-option=''>全部区县</li>";
                var divText = "全部区县";
                if (areaData != '' && areaData != null) {
                    for(var i=0; i<areaData.length; i++){
                        var area = areaData[i];
                        var areaId = area.id;
                        var areaText = area.text;
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
            	//类型搜索
                var defaultTypeId = $("#venueType").val();
                $.post("${path}/tag/getChildTagByType.do?code=VENUE_TYPE",function(venueType) {
                    var ulHtml = "<li data-option=''>全部类别</li>";
                    var divText = "全部类别";
                    if (venueType != '' && venueType != null) {
                        for(var i=0; i<venueType.length; i++){
                            var type = venueType[i];
                            var typeId = type.tagId;
                            var typeText = type.tagName;
                            ulHtml += '<li data-option="'+typeId+'">'
                            + typeText
                            + '</li>';
                            if(defaultTypeId == typeId){
                                divText = typeText;
                            }
                        }
                        $("#venueTypeDiv").html(divText);
                        $("#venueTypeUl").html(ulHtml);
                    }
                }).success(function() {
                    selectModel();
                });
            });

            $(".delete").on("click", function(){
                var venueId = $(this).attr("id");
                var name = $(this).parent().siblings(".title").find("a").text();
                var html = "您确定要删除" + name + "吗？";
                dialogConfirm("提示", html, function(){
                    $.post("${path}/venue/deleteVenue.do",{"venueId":venueId}, function(data) {
                        if (data!=null && data=='success') {
                            window.location.href="${path}/venue/venueIndex.do";
                        }
                    });
                })
            });
        });


        //场馆推荐与取消推荐
        function recommendVenue(venueId,type){
            $.post("${path}/venue/recommendVenue.do", {venueId:venueId,type:type},
                    function(data) {
                    if(data!=null && data== 'success'){
                        dialogAlert("提示","操作成功",function(){
                            formSub('#venueIndexForm');
                        });

                    }else{
                        dialogAlert("提示","操作失败",function(){

                        });
                    }
            });
        }

    </script>
</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>推荐管理 &gt; web端推荐&gt;首页场馆推荐
</div>
<form id="venueIndexForm" method="post" action="${path}/recommend/homeVenueRecommendIndex.do?recommend=Y">
    <input type="hidden" name="recommend"/>
    <div class="search">
        <div class="search-box">
            <i></i><input id="searchKey" name="searchKey" class="input-text" data-val="请输入场馆名称" type="text"
                          value="<c:choose><c:when test="${not empty searchKey}">${searchKey}</c:when><c:otherwise>请输入场馆名称</c:otherwise></c:choose>"/>
        </div>
        <div class="select-box w135">
	        <input type="hidden" name="areaData" id="areaData" value="${areaData}"/>
	        <div id="areaDiv" class="select-text" data-value="">全部区县</div>
	        <ul id="areaUl" class="select-option">
	        </ul>
        </div>

        <div class="select-btn">
            <%
                if(selectVenueButton){
            %>
            <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#venueIndexForm')"/>
            <%
                }
            %>
        </div>
    </div>

    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th class="title">场馆名称</th>
                <th>所属区县</th>
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
            <tbody>

            <c:forEach items="${list}" var="c" varStatus="s" >
                <tr>
                    <td>${s.index+1}</td>
                    <td class="title">
                        <c:if test="${s.index<5 && page.page<2 && empty searchKey && empty areaData}">
                            <i class="recommend-icon"></i>
                        </c:if>

                        <a href="${path}/frontVenue/venueDetail.do?venueId=${c.venueId}" target="_blank">
                            <c:out escapeXml="true" value="${c.venueName }"/>
                        </a>
                    </td>

                    <td>${fn:substringAfter(c.venueArea, ',')}</td>
                    <td>${c.venueUpdateUser }</td>
                    <td><fmt:formatDate value="${c.venueUpdateTime}" pattern="yyyy-MM-dd HH:mm"/></td>

                    <td>
                        <% if(recommendVenueButton){

                        %>
                        <c:if test="${c.venueIsRecommend==2}">
                            <a href="javascript:recommendVenue('${c.venueId}','no')">取消置顶</a>
                        </c:if>
                        <c:if test="${c.venueIsRecommend==1}">
                            <a href="javascript:recommendVenue('${c.venueId}','yes')">置顶${c.venueRecommendTime}</a>
                        </c:if>
                        <%
                            }
                        %>
                        <%--<c:if test="${c.venueIsRecommend==1}">
                            <%
                                if(recommendVenueButton){
                            %>
                            <a href="javascript:recommendVenue('${c.venueId}','yes')">置顶</a>
                            <%
                                }
                            %>
                        </c:if>
                        <c:if test="${c.venueIsRecommend==2}">
                            <%
                                if(notRecommendVenueButton){
                            %>
                            <a href="javascript:recommendVenue('${c.venueId}','no')">取消置顶</a>
                            <%
                                }
                            %>
                        </c:if>--%>

                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <c:if test="${not empty list}">
            <input type="hidden" id="page" name="page" value="${page.page}" />
            <div id="kkpager"></div>
        </c:if>
        <script type="text/javascript">
            $(function(){
                kkpager.generPageHtml({
                    pno : '${page.page}',
                    total : '${page.countPage}',
                    totalRecords :  '${page.total}',
                    mode : 'click',//默认值是link，可选link或者click
                    click : function(n){
                        this.selectPage(n);
                        $("#page").val(n);
                        formSub('#venueIndexForm');
                        return false;
                    }
                });
            });

            //提交表单
            function formSub(formName){
                var searchKey = $("#searchKey").val();
                if(searchKey == "请输入场馆名称"){		//"\\"代表一个反斜线字符\
                    $("#searchKey").val("");
                }
                $(formName).submit();
            }

            //场馆推荐与取消推荐
           /* function recommendVenue(venueId,type){
                $.ajax({
                    url:'${path}/venue/recommendVenue.do',
                    type:"POST",
                    data:{venueId:venueId,type:type},
                    dataType:"json",
                    success:function(re){
                        formSub('#venueIndexForm');
                    }
                });
            }*/

        </script>
    </div>
</form>

</body>
</html>