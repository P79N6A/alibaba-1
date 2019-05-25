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
                        var ulHtml = "<li data-option=''>全部区县</li>";
                        var divText = "全部区县";
                        if (areaData != '' && areaData != null) {
                            for(var i=0; i<areaData.length; i++){
                                var area = areaData[i].activityArea;
                                var array = area.split(",");
                                var areaId = array[0];
                                var areaText = array[1];
                                ulHtml += '<li data-option="'+areaId+'">'
                                + areaText+"轮播图"
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


            //请求页面列表缩略图
/*            $("td").each(function (index, item) {
                var imgUrl = $(this).attr("data-id");
                if(imgUrl != undefined && imgUrl != null){
                    var fileName=new Array();
                    fileName=imgUrl.split("/");
                    var imgc=fileName[fileName.length-1];
                    var filename2=new Array();
                    filename2 = imgc.split(".");
                    $.ajax({
                        type: "post",
                        url: "../get/getFile.do?url="+imgUrl+"&width=60&height=40",
                        dataType: "json",
                        contentType: "application/json;charset=utf-8",
                        cache:false,//缓存不存在此页面
                        async: true,//异步请求
                        success: function (date) {
                            if(date.data.length>0){
                                $(item).find("img").attr("src", "data:image/"+filename2[1]+";base64,"+date.data);
                            }
                        }
                    });
                }
            });*/

    </script>

</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>推荐管理 &gt;Web端推荐&gt;首页推荐
</div>
<form id="advertIndexForm" action="${path}/recommend/homeHotRecommendIndex.do" method="post">
<%--<div class="search">--%>
    <%--<div class="search-box">--%>
       <%--<i></i><input id="inputQueryMessger" class="input-text"  name="advertTitle" value="${record.advertTitle}" type="text" data-val="请输入关键字" />--%>
    <%--</div>--%>
   <%--<div class="select-box w135">--%>
        <%--<input type="hidden" id="advertColumn" name="advertColumn" value="${record.advertColumn}" />--%>
        <%--<div class="select-text" data-value="" id="selectInputTypeDiv">--%>
            <%--<c:choose>--%>
                    <%--<c:when test="${not empty record.advertColumn}">${record.advertColumn}</c:when>--%>
                    <%--<c:otherwise>全上海市</c:otherwise>--%>
            <%--</c:choose>--%>
        <%--</div>--%>
        <%--<ul class="select-option">--%>
            <%--<li data-option=""></li>--%>
            <%--<li data-option="0">App首页轮播图</li>--%>
            <%--<li data-option="45">上海市轮播图</li>--%>
            <%--<li data-option="46">黄埔区轮播图</li>--%>
            <%--<li data-option="48">徐汇区轮播图</li>--%>
            <%--<li data-option="50">静安区轮播图</li>--%>
            <%--<li data-option="49">长宁区轮播图</li>--%>
            <%--<li data-option="51">普陀区轮播图</li>--%>
            <%--<li data-option="52">闸北区轮播图</li>--%>
            <%--<li data-option="53">虹口区轮播图</li>--%>
            <%--<li data-option="54">杨浦区轮播图</li>--%>
            <%--<li data-option="58">浦东新区轮播图</li>--%>
            <%--<li data-option="56">宝山区轮播图</li>--%>
            <%--<li data-option="57">嘉定区轮播图</li>--%>
            <%--<li data-option="60">松江区轮播图</li>--%>
            <%--<li data-option="51">青浦区轮播图</li>--%>
            <%--<li data-option="55">闵行区轮播图</li>--%>
            <%--<li data-option="59">金山区轮播图</li>--%>
            <%--<li data-option="63">奉贤区轮播图</li>--%>
            <%--<li data-option="64">崇明县轮播图</li>--%>
        <%--</ul>--%>
    <%--</div>--%>
    <%--<div class="select-box w135">--%>
        <%--<input type="hidden" id="activityArea" name="activityArea" value="${activity.activityArea}"/>--%>
        <%--<div id="areaDiv" class="select-text" data-value="">全部区县</div>--%>
        <%--<ul class="select-option" id="areaUl">--%>
        <%--</ul>--%>
    <%--</div>--%>


    <%--<div class="select-btn">--%>
        <%--<input type="button" onclick="queryByCondition()" value="搜索"/>--%>
    <%--</div>--%>

<%--</div>--%>
<div class="main-content">
    <table width="100%">
        <thead>
        <tr>
            <th>ID</th>
            <th>广告标题</th>
            <th>封面图</th>
            <th>尺寸</th>
            <th>操作人</th>
            <th>更新时间</th>
            <th>管理</th>
        </tr>
        </thead>

        <tbody id="advertImg">
        <c:if test="${empty list}">
            <c:forEach var="i" begin="1" end="5">
                <tr>
                    <td class="sortNum">${i}</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td>
                        <%
                            if(homeHotAdd){
                        %>
                        <a class="btn-add-tag">添加</a>
                        <%
                            }
                        %>
                    </td>
                </tr>
            </c:forEach>
        </c:if>

        <c:if test="${not empty list}">
            <c:forEach var="i" begin="1" end="5">
                <%boolean flag = false;%>
                <c:forEach items="${list}" var="advert">
                    <c:if test="${advert.advertPosSort eq i}">
                        <tr>
                            <td class="sortNum">${i}</td>
                            <td>${advert.advertTitle}</td>
                            <%--<td><img src=""/></td>--%>
                            <td data-id="${advert.advertPicUrl}">
                                <img src="" data-url="${advert.advertPicUrl}"  width="60" height="40"/>
                            </td>
                            <td>133*100</td>
                            <td>${advert.advertUpdateUser}</td>
                            <td><c:if test="${not empty advert.advertUpdateTime}"><fmt:formatDate value="${advert.advertUpdateTime}"  pattern="yyyy-MM-dd HH:mm:ss" /></c:if></td>
                            <td>
                                <%
                                    if(homeHotDelete){
                                %>
                                <a class="" onclick="IsRecommendAdvert('${advert.advertId}')">删除</a>
                                <%
                                    }
                                %>
                            </td>
                        </tr>
                        <%flag = true;%>
                    </c:if>
                </c:forEach>
                <%if(!flag){%>
                    <tr>
                        <td class="sortNum">${i}</td>
                        <td></td>
                        <td>
                        </td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td>
                            <%
                            if(homeHotAdd){
                            %>
                            <a class="btn-add-tag">添加</a>
                            <%
                                }
                            %>
                        </td>
                    </tr>
                <%}%>
            </c:forEach>
        </c:if>
        </tbody>
    </table>
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
    function IsRecommendAdvert(advertId){

            $.post("${path}/advert/upateIsRecommendAdvert.do?advertId="+advertId, {
//                advertId:id,
//                siteId:siteId
            }, function(data) {
                if (data!=null && data=='success') {

                        window.location.href="${path}/recommend/homeHotRecommendIndex.do";

                }else{

                        window.location.href="${path}/recommend/homeHotRecommendIndex.do";

                }

            });
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
        $("#advertIndexForm").submit();
    }

    function queryByCondition(){
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

            var sortNum = $(this).parent().siblings(".sortNum").text();
            dialog({
                url: '${path}/recommend/addHomeRecommend.do?sortNum='+sortNum,
                title: '添加首页热点推荐',
                width: 560,
                height:700,
                fixed: true
            }).showModal();
            return false;
        });
    });

    function advertEdit(advertId){
        var tagId = $(this).attr("id");
        dialog({
            url: '${path}/advert/editAdvertShow.do?advertId='+advertId,
            title: '编辑轮播图',
            width: 560,
            height:750,
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