<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>

    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

    <script type="text/javascript">
        $(function(){
            getPage();

            getSearchParameter();
            // 冻结
            freeTerminalUser();
            // 激活
            activeTerminalUser();
        });

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
                    formSub('#teamUserForm');
                    return false;
                }
            });
        }

        //搜索
        function formSub(formName){
            if($("#tuserName").val() == "输入团体名称关键词"){
                $("#tuserName").val("");
            }
            $(formName).submit();
        }

        // 参数
        function getSearchParameter(){
            var paramArr;
            var tuserIsDisplay = '${record.tuserIsDisplay}';
            if('${record.tuserIsDisplay}' == undefined || '${record.tuserIsDisplay}' == ''){
                paramArr = {};
            }else {
                paramArr = {tuserIsDisplay:tuserIsDisplay};
            }
            $.post("${path}/teamUser/getExistArea.do",paramArr,function(data){
                if(data != '' && data != null){
                    var tuserCounty = $('#tuserCounty').val();
                    var list = eval(data);
                    var ulHtml = '<li data-option="">全部区县</li>';
                    for(var i = 0;i<list.length;i++){
                        var area = list[i];
                        var areaId = area.substring(0,area.indexOf(","));
                        var areaName = area.substring(area.indexOf(",")+1,area.length);
                        ulHtml +='<li data-option="'+areaId+'">'+areaName+'</li>';
                        if(tuserCounty != '' && areaId == tuserCounty){
                            $('#countyDiv').html(areaName);
                        }
                    }
                    $('#countyUl').html(ulHtml);
                }
            }).success(function(){
                selectModel();
            });
        }

        function freeTerminalUser(){
            $(".active").on("click", function(){
                var tuserId = $(this).attr("tuserId");
                var name = $(this).parent().siblings(".title").find("a").text();
                var html = "您确定要冻结" + name + "吗？";
                dialogConfirm("提示", html, function(){
                    $.post("${path}/teamUser/freezeTeamUser.do",{tuserId:tuserId},function(data) {
                        if (data == 'success') {
                            window.location.href="${path}/teamUser/teamUserIndex.do?tuserIsDisplay="+$("#tuserIsDisplay").val();
                        }
                    });
                })
            });
        }

        function activeTerminalUser(){
            $(".freeze").on("click", function(){
                var tuserId = $(this).attr("tuserId");
                var name = $(this).parent().siblings(".title").find("a").text();
                var html = "您确定要激活" + name + "吗？";
                dialogConfirm("提示", html, function(){
                    $.post("${path}/teamUser/activeTeamUser.do",{tuserId:tuserId},function(data) {
                        if (data == 'success') {
                            window.location.href="${path}/teamUser/teamUserIndex.do";
                        }
                    });
                })
            });
        }
    </script>
</head>
<body>

<form id="teamUserForm" action="${path}/teamUser/teamUserIndex.do" method="post">
<div class="site">
    <em>您现在所在的位置：</em>团体管理 &gt; <c:if test="${record.tuserIsDisplay == 0}">草稿箱</c:if>
    <c:choose><c:when test="${record.tuserIsDisplay == 1}">团体列表</c:when><c:otherwise>待激活</c:otherwise></c:choose>
</div>
    <input type="hidden" name="tuserIsDisplay" value="${record.tuserIsDisplay}" id="tuserIsDisplay"/>
    <div class="search">
        <div class="search-box">
            <i></i><input class="input-text" name="tuserName" data-val="输入团体名称关键词" value="<c:choose><c:when test='${not empty record.tuserName}'>${record.tuserName}</c:when><c:otherwise>输入团体名称关键词</c:otherwise></c:choose>" type="text" id="tuserName"/>
        </div>
        <div class="select-box w135">
            <input type="hidden" id="tuserCounty" name="tuserCounty" value="${tuserCounty}"/>
            <div class="select-text" data-value="" id="countyDiv">全部区县</div>
            <ul class="select-option" id="countyUl">
            </ul>
        </div>
        <div class="select-btn">
            <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#teamUserForm');"/>
        </div>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th width="65">ID</th>
                <th class="title">团体名称</th>
                <th class="80">所属区县</th>
                <th width="100">管理员</th>
                <th width="100">联系电话</th>
                <th class="80">操作人</th>
                <th class="80">操作时间</th>
               <%-- <th width="60">状态</th>--%>
                <th width="160">管理</th>
            </tr>
            </thead>
            <c:if test="${empty list}">
                <tr>
                    <td colspan="8"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            <tbody>
            <c:forEach items="${list}" var="c" varStatus="s">
                <tr>
                    <td width="65">${s.index+1}</td>
                    <td class="title">${c.tuserName}</td>
                    <td class="80">${fn:substring(c.tuserCounty, fn:indexOf(c.tuserCounty, ",")+1,fn:length(c.tuserCounty))}</td>
                    <td width="100">${c.managerName}</td>
                    <td width="100">${c.userMobileNo}</td>
                    <td class="80">${c.tUpdateUser}</td>
                    <td class="80"><fmt:formatDate value="${c.tUpdateTime}" pattern="yyyy-MM-dd  HH:mm" /></td>
                    <%--<td width="60">
                        <c:choose>
                            <c:when test="${c.tuserIsDisplay==0}">
                                草稿箱
                            </c:when>
                            <c:when test="${c.tuserIsDisplay==1}">
                                已激活
                            </c:when>
                            <c:when test="${c.tuserIsDisplay==2}">
                                冻结
                            </c:when>
                        </c:choose>
                    </td>--%>
                    <td width="160" class="td-editing">

                        <c:if test="${c.tuserIsDisplay==1}">
                            <%if(teamFreezeButton){%>
                                <a class="active" tuserId="${c.tuserId}">冻结</a> |
                            <%}%>
                            <%if(teamPreEditButton){%>
                                <a href="${path}/teamUser/preEditTeamUser.do?tuserId=${c.tuserId}">编辑</a><%if(teamViewButton){%> | <%}%>
                            <%}%>
                            <%if(teamViewButton){%>
                            <a href="${path}/teamUser/viewTeamUser.do?tuserId=${c.tuserId}">查看</a>
                            <%}%>
                        </c:if>

                        <c:if test="${c.tuserIsDisplay != 1}">
                            <%if(teamActiveButton){%>
                                <a class="freeze" tuserId="${c.tuserId}">激活</a> |
                            <%}%>
                            <%if(teamPreWaiteEditButton){%>
                                <a href="${path}/teamUser/preEditTeamUser.do?tuserId=${c.tuserId}">编辑</a><%if(teamViewButton){%> | <%}%>
                            <%}%>
                            <%if(teamViewWaiteButton){%>
                            <a href="${path}/teamUser/viewTeamUser.do?tuserId=${c.tuserId}">查看</a>
                            <%}%>
                        </c:if>




                            <%--<c:if test="${c.tuserIsDisplay != 0}">--%>
                                <%--<a href="${path}/terminalUser/teamTerminalUserIndex.do?tuserId=${c.tuserId}">成员</a>--%>
                            <%--</c:if>--%>
                    </td>
                </tr>
            </c:forEach>

            </tbody>
        </table>
        <c:if test="${not empty list}">
            <input type="hidden" id="page" name="page" value="${page.page}" />
            <div id="kkpager"></div>
        </c:if>
    </div>
</form>
</body>
</html>