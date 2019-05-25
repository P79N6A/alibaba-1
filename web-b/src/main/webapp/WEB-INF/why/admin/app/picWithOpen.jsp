<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <script type="text/javascript" src="/STATIC/js/jquery.min.js"></script>

    <script type="text/javascript" src="${path}/STATIC/js/admin/activity/UploadActivityFile.js"></script>
    <%--<script type="text/javascript" src="${path}/STATIC/js/admin/activity/getActivityFile.js"></script>--%>
    <script type="text/javascript" src="${path}/STATIC/js/area.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/area-venues-admin.js?version=20151125"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <!--文本编辑框 end-->
    <!-- dialog start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ckeditor/sample.js"></script>
    <script type="text/javascript" src="/STATIC/js/page.min.js"></script>
    <link rel="stylesheet" type="text/css" href="/STATIC/css/page.css"/>
    <link rel="Stylesheet" type="text/css" href="/STATIC/css/DialogBySHF.css" />
    <script type="text/javascript" src="/STATIC/js/DialogBySHF.js"></script>


</head>

<body >


    <div class="site">
        <span><em>您现在所在的位置：</em>运营维护 &gt; app开机画面设置</span>
        <span style="float: right">
        	<input type="hidden" name="city" id="selectCity" value="${city}"/>
            <button  style="height:25px;width: 100px;"   onclick="editImageWithStart('')">新增</button>
        </span>
    </div>


    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th width="50">ID</th>
                <th width="100">图片</th>
                <th width="100">开始／结束时间</th>
                <th width="110">默认开机图片</th>
                <th width="110">创建时间</th>
                <th width="80">管理</th>
            </tr>
            </thead>

            <tbody>

            <c:forEach var="image" items="${OpenImageList}">
                <tr>
                    <td>${image.imageid}</td>
                    <td><img src="${IMGHOST}${image.imageurl_normal}" width="120" height="160"/></td>
                    <td>${image.startDate}至${image.endDate}</td>
                    <td>
                        <c:choose>
                            <c:when test="${image.isDefaultImage == 1}">是</c:when>
                            <c:otherwise>否</c:otherwise>
                        </c:choose>
                    </td>
                    <td>${image.cdate}</td>
                    <td> <a onclick="editImageWithStart(${image.imageid})">编辑</a>  |
                        <a onclick="setdefaultImage(${image.imageid})">设为默认</a>  |
                        <a onclick="delImage(${image.imageid})">删除</a></td>

                </tr>
            </c:forEach>

            </tbody>
        </table>
        <input type="hidden" id="page" name="page" value="1"/>
        <div id="kkpager"></div>

    </div>


</body>

<script language="JavaScript">

    function setdefaultImage(imageid)
    {
        var city = $("#selectCity").val();
        $.post("/app/setDefaultImage.do", "imageid="+imageid+"&city="+city,
                function(data) {



                    if(data ==  1)
                    {

                        alert("设置成功!");
                        document.location.reload();


                    }
                    else
                    {
                        alert("设置失败!");
                    }

                }
        );
    }

    function delImage(imageid)
    {

        $.post("/app/delImage.do", "imageid="+imageid,
                function(data) {



                    if(data ==  1)
                    {

                        alert("删除成功!");
                        document.location.reload();


                    }
                    else
                    {
                        alert("删除失败!");
                    }

                }
        );
    }

    kkpager.generPageHtml({
        pno : '${Page.pageNum}',
        mode : 'click', //设置为click模式
        //总页码
        total : '${Page.pages}',
        //总数据条数
        totalRecords : '${Page.total}',
        //点击页码、页码输入框跳转、以及首页、下一页等按钮都会调用click
        //适用于不刷新页面，比如ajax
        click : function(n){
            location.href = "/template/templateIndex.do?page="+n;
        },
        //getHref是在click模式下链接算法，一般不需要配置，默认代码如下
        getHref : function(n){
            return '#';
        }

    });


    function  editImageWithStart(imageid)
    {
        var city = $("#selectCity").val();
        $.DialogBySHF.Dialog({ Width: 1024, Height: 768, Title: "添加活动", URL: "/app/imagedetail.do?imageid="+imageid+"&city="+city});
    }


</script>
</html>