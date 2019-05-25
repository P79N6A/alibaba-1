<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <script type="text/javascript" src="/STATIC/js/jquery.min.js"></script>

    <script type="text/javascript" src="${path}/STATIC/js/area.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/area-venues-admin.js?version=20151125"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <!--文本编辑框 end-->
    <!-- dialog start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/admin/activity/addActivity.js?version=20151126"></script>
    <script type="text/javascript" src="/STATIC/js/page.min.js"></script>
    <link rel="stylesheet" type="text/css" href="/STATIC/css/page.css"/>



</head>

<body >


    <div class="site">
        <span><em>您现在所在的位置：</em>活动专题 &gt; 专题列表</span>
        <span style="float: right">
            <button  style="height:25px;width: 100px;"   onclick="addNewActivityTopic()">新增</button>
        </span>
    </div>


    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th width="50">ID</th>
                <th width="100">标题</th>

                <th width="110">创建时间</th>
                <th width="80">管理</th>
            </tr>
            </thead>

            <tbody>

            <c:forEach var="topic" items="${ActivityTopicList}">
                <tr>
                    <td>${topic.id}</td>
                    <td>${topic.title}</td>

                    <td>${topic.ctime}</td>
                    <td><a href="/template/templatedetail.do?id=${topic.id}">编辑</a> |
                        <a href="/template/activityTopicDetail.do?topicid=${topic.id}" target="_blank">预览</a>  |
                        <a onclick="delActivity(${topic.id})">删除</a></td>

                </tr>
            </c:forEach>

            </tbody>
        </table>
        <input type="hidden" id="page" name="page" value="1"/>
        <div id="kkpager"></div>

    </div>


</body>

<script language="JavaScript">

    function delActivity(tid)
    {
        $.post("/template/delTopic.do", "topicid="+tid,
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


    function  addNewActivityTopic()
    {

        location.href = "/template/templatedetail.do";
    }


</script>
</html>