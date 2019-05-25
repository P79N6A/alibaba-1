<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <title>广告管理</title>
    <%@include file="../../common/pageFrame.jsp"%>
    <script type="text/javascript">
        function deleteAdvert(advertId){
            jConfirm('确定要将该广告删除吗?', '系统提示',function (r){
                if(r){
                    $.post("${path}/advert/deleteAdvert.do",{"advertId":advertId}, function(data) {
                        if (data!=null && data=='success') {
                            jAlert('删除成功', '系统提示','success',function (r){
                                window.location.href="${path}/advert/advertIndex.do";
                            });
                        } else {
                            jAlert('删除失败', '系统提示','failure');
                        }
                    });
                }
            });
        }

        $(function(){
            var advertColumn = $('#advertColumn').val();
            $.post(
                "${path}/sysdict/queryCode.do",
                {
                    'dictCode' : 'COLUMN'
                },
                function(data) {
                    if (data != '' && data != null) {
                        var list = eval(data);
                        var ulHtml = '<li data-option="">所有栏目</li>';
                        for (var i = 0; i < list.length; i++) {
                            var dict = list[i];
                            ulHtml += '<li data-option="'+dict.dictId+'">'
                            + dict.dictName + '</li>';
                            if (advertColumn != '' && dict.dictId == advertColumn) {
                                $('#advertColumnDiv').html(dict.dictName);
                            }
                        }
                        $('#advertColumnUl').html(ulHtml);
                    }
                }).success(function() {
                    selectModel();
                });
        });

        $(document).ready(function () {
            //请求页面列表缩略图
            $("td").each(function (index, item) {
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
            });
        });
    </script>
</head>
<body class="rbody">
<form id="advert_form" action="${path}/advert/advertIndex.do" method="post">
    <!-- 正中间panel -->
    <div id="content">
        <div class="content">
            <div class="con-box-blp">
                <h3>广告管理</h3>
                <div class="con-box-tlp">
                    <div class="top-search">
                        <div class="search-icon"><img src="${path}/STATIC/image/search.png"></div>
                        <div class="search-input-text">
                            <input type="text" name="advertTitle" value="${record.advertTitle}"  class="inpTxt"/>
                        </div>
                        <div class="search-input-text">
                            &nbsp;&nbsp;&nbsp;&nbsp;
                        </div>
                        <div class="select-box-one select-box-three">
                            <input type="hidden" name="advertColumn" id="advertColumn" value="${record.advertColumn}"/>
                            <div class="select-text-one select-text-three" data-value="所有栏目" id="advertColumnDiv">所有栏目</div>
                            <ul class="select-option select-option-three" id="advertColumnUl">

                            </ul>
                        </div>
                        <div class="search-btn">
                            <c:forEach items="${sessionScope.user.sysModuleList}" var="module">
                                <c:if test="${module.moduleUrl == '${path}/advert/advertIndex.do'}">
                                    <input type="button" value="搜索" style="border: none;"  onclick="$('#page').val(1);formSub('#advert_form')"/>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                    <div class="table-box">
                        <table class="list-table">
                            <thead>
                            <tr>
                                <th width="65">ID</th>
                                <th width="65">广告缩略图</th>
                                <th class="th-name">广告标题</th>
                                <th class="100">所属栏目</th>
                                <th width="80">操作人</th>
                                <th width="120">操作时间</th>
                                <th width="60">状态</th>
                                <th width="120">管理</th>
                            </tr>
                            </thead>
                            <c:if test="${empty list}">
                                <tr>
                                    <td colspan="8"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                                </tr>
                            </c:if>
                            <tbody>

                            <!-- 内容展示动态数据填充 start -->
                            <c:forEach items="${list}" var="c" varStatus="s">
                                <tr  id="data-div">
                                    <td width="65">${s.index+1}</td>
                                    <td width="65" data-id="${c.advertPicUrl}">
                                        <img src="${path}/STATIC/image/defaultImg.png"  width="60" height="40"/>
                                    </td>
                                    <td class="th-name">${c.advertTitle}</td>
                                    <td width="100">${c.advertColumn}</td>
                                    <td width="80">${c.advertUpdateUser}</td>
                                    <td class="120"><fmt:formatDate value="${c.advertUpdateTime}" pattern="yyyy-MM-dd  HH:mm" /></td>
                                    <td width="60">
                                        <c:choose>
                                            <c:when test="${c.advertState==1}">
                                                草稿
                                            </c:when>
                                            <c:when test="${c.advertState==2}">
                                                已审核
                                            </c:when>
                                            <c:when test="${c.advertState==3}">
                                                审核中
                                            </c:when>
                                            <c:when test="${c.advertState==4}">
                                                退回
                                            </c:when>
                                            <c:when test="${c.advertState==5}">
                                                回收站
                                            </c:when>
                                            <c:when test="${c.advertState==6}">
                                                已发布
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td width="120" class="td-editing">
                                        <c:forEach items="${sessionScope.user.sysModuleList}" var="module">
                                            <c:if test="${module.moduleUrl == '${path}/advert/deleteAdvert.do'}">
                                                <c:if test="${c.advertIsDel == 1 && c.advertState != 6}">
                                                    <a href="javascript:deleteAdvert('${c.advertId}')">删除</a>|
                                                </c:if>
                                            </c:if>
                                        </c:forEach>
                                        <c:forEach items="${sessionScope.user.sysModuleList}" var="module">
                                            <c:if test="${module.moduleUrl == '${path}/advert/preEditAdvert.do'}">
                                                <a href="${path}/advert/preEditAdvert.do?advertId=${c.advertId}">编辑</a>|
                                            </c:if>
                                        </c:forEach>
                                        <c:forEach items="${sessionScope.user.sysModuleList}" var="module">
                                            <c:if test="${module.moduleUrl == '${path}/advert/viewAdvert.do'}">
                                                <a href="${path}/advert/viewAdvert.do?advertId=${c.advertId}">查看</a>
                                            </c:if>
                                        </c:forEach>
                                    </td>
                                </tr>
                            </c:forEach>

                            </tbody>
                        </table>
                    </div>

                    <c:forEach items="${sessionScope.user.sysModuleList}" var="module">
                        <c:if test="${module.moduleUrl == '${path}/advert/advertIndex.do'}">

                        <!-- 分页功能div start -->
                        <c:if test="${fn:length(list) gt 0}">
                            <input type="hidden" id="page" name="page" value="${page.page}" />
                            <div class="turn-page-box">
                                <ul>
                                    <li><a class="first-page" href="javascript:void(0);" onclick="pageSubmit(0)">首页</a></li>
                                    <li><a class="pre-page" href="javascript:void(0);" onclick="pageSubmit(${page.page-1})">上一页</a></li>
                                    <!-- 判断当前页是否小于总页数 start -->
                                    <c:choose>
                                        <c:when test="${(page.page+1) <= page.countPage}">
                                            <li><a class="next-page" href="javascript:void(0);" onclick="pageSubmit(${page.page+1})">下一页</a></li>
                                        </c:when>
                                        <c:otherwise>
                                            <li><a class="next-page" href="javascript:void(0);" onclick="pageSubmit(${page.countPage})">下一页</a></li>
                                        </c:otherwise>
                                    </c:choose>
                                    <!-- 判断当前页是否小于总页数 end -->
                                    <li><a class="last-page" href="javascript:void(0);" onclick="pageSubmit(${page.countPage})">尾页</a></li>
                                </ul>
                                <div class="total-page">
                                    <span>第${page.page}页</span>
                                    <span>/</span>
                                    <span>共${page.countPage}页</span>

                                </div>
                                <div class="go-page">
                                    <span>跳转到：</span>
                                    <input class="go-page-text" id="goPage" type="text" value="${page.page}">
                                    <input class="go-page-btn" type="button" value="GO" onclick="pageSubmit($('#goPage').val())"/>
                                </div>
                            </div>
                            <script type="text/javascript">
                                var pageSize = ${page.countPage};
                                function pageSubmit(page){
                                    if(page == ""){
                                        page = 1;
                                    }
                                    if(page <= pageSize){
                                        $("#page").val(page);
                                        formSub("#advert_form");
                                    }else{
                                        jAlert('跳转页数不能超过总页数', '系统提示','failure',function (r){});
                                    }
                                }
                            </script>
                        </c:if>

                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</form>

<script type="text/javascript">
    //提交表单
    function formSub(formName){
        $(formName).submit();
    }
</script>
<!-- 正中间panel -->

</body>
</html>