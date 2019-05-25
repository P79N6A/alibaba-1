<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <title>查看团体</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/admin/teamUser/UploadTeamUserImg.js"></script>

    <script type="text/javascript">
        $(function(){
            /*getTuserCrowdTag();*/
            getTuserPropertyTag();
            /*getTuserSiteTag();*/
            getTuserLocationDict();
        });

        /*// 人群标签
        function getTuserCrowdTag(){
            $.post("${path}/tag/getChildTagByType.do?code=TEAMUSER_CROWD", function(data) {
                var list = eval(data);
                var tagHtml = '';
                var tagIds = '${record.tuserCrowdTag}';
                var ids = '';
                if (tagIds.length > 0) {
                    ids = tagIds.substring(0, tagIds.length - 1).split(",");
                }
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var tagId = obj.tagId;
                    var tagName = obj.tagName;
                    var result = false;
                    if (ids != '') {
                        for (var j = 0; j <ids.length; j++) {
                            if (tagId == ids[j]) {
                                result = true;
                                break;
                            }
                        }
                    }
                    var cl = '';
                    if (result) {
                        cl = 'class="cur"';
                    }
                    tagHtml += '<a ' + cl +' style="cursor:text">' + tagName
                    + '</a>';
                }
                $("#teamUserCrowdLabel").html(tagHtml);
            });
        }*/

        // 属性标签
        function getTuserPropertyTag(){
            $.post("${path}/tag/getChildTagByType.do?code=TEAMUSER_PROPERTY", function(data) {
                var list = eval(data);
                var tagHtml = '';
                var tagIds = '${record.tuserPropertyTag}';
                var ids = '';
                if (tagIds.length > 0) {
                    ids = tagIds.substring(0, tagIds.length - 1).split(",");
                }
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var tagId = obj.tagId;
                    var tagName = obj.tagName;
                    var result = false;
                    if (ids != '') {
                        for (var j = 0; j <ids.length; j++) {
                            if (tagId == ids[j]) {
                                result = true;
                                break;
                            }
                        }
                    }
                    var cl = '';
                    if (result) {
                        cl = 'class="cur"';
                    }
                    tagHtml += '<a '+cl+' style="cursor:text">' + tagName
                    + '</a>';
                }
                $("#teamUserPropertyLabel").html(tagHtml);
            });
        }

        // 地点标签
        /*function getTuserSiteTag(){
            $.post("${path}/tag/getChildTagByType.do?code=TEAMUSER_SITE", function(data) {
                var list = eval(data);
                var tagHtml = '';
                var tagIds = '${record.tuserSiteTag}';
                var ids = '';
                if (tagIds.length > 0) {
                    ids = tagIds.substring(0, tagIds.length - 1).split(",");
                }
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var tagId = obj.tagId;
                    var tagName = obj.tagName;
                    var result = false;
                    if (ids != '') {
                        for (var j = 0; j <ids.length; j++) {
                            if (tagId == ids[j]) {
                                result = true;
                                break;
                            }
                        }
                    }
                    var cl = '';
                    if (result) {
                        cl = 'class="cur"';
                    }
                    tagHtml += '<a '+cl+' style="cursor:text">' + tagName
                    + '</a>';
                }
                $("#teamUserSiteLabel").html(tagHtml);
            });
        }*/

        // 商圈位置
        function getTuserLocationDict(){
            $.post("${path}/sysdict/queryChildSysDictByDictCode.do",{dictCode:'${fn:substringBefore(record.tuserCounty,',')}'}, function(data) {
                var list = eval(data);
                var dictHtml = '';
                var other = "";
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var dictId = obj.dictId;
                    var dictName = obj.dictName;
                    var cl = '';
                    if (dictId == '${record.tuserLocationDict}') {
                        cl = 'class="cur"';
                    }

                    if(dictName == "其他"){
                        other =  '<a '+cl+'style="cursor:text">' + dictName
                        + '</a>';
                    }else{
                        dictHtml += '<a '+cl+' style="cursor:text">' + dictName
                        + '</a>';
                    }
                }
                dictHtml += other;
                $("#teamUserLocationLabel").html(dictHtml);
            });
        }
    </script>
</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em>团体管理 &gt; 查看团体
</div>
<div class="site-title">查看团体</div>
<!-- 正中间panel -->
<div class="main-publish">
    <table class="form-table" width="100%">
        <tbody>
        <tr>
            <td class="td-title" width = "130">团体名称：</td>
            <td class="td-input">
                <span>${record.tuserName}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">所属站点：</td>
            <td class="td-input">
                <span>
                    <c:choose>
                        <c:when test="${fn:substringAfter(record.tuserProvince,',') eq fn:substringAfter(record.tuserCity,',')}">
                            ${fn:substringAfter(record.tuserCity,',')}&nbsp;${fn:substringAfter(record.tuserCounty,',')}
                        </c:when>
                        <c:otherwise>
                            ${fn:substringAfter(record.tuserProvince,',')}&nbsp;${fn:substringAfter(record.tuserCity,',')}&nbsp;${fn:substringAfter(record.tuserCounty,',')}
                        </c:otherwise>
                    </c:choose>
                </span>
            </td>
        </tr>
        <tr>
            <td class="td-title">管理员姓名：</td>
            <td class="td-input">
                <span>
                    ${user.userNickName}
                </span>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <span>
                    昵称：&nbsp;&nbsp;${user.userName}
                </span>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <span>
                    性别：&nbsp;&nbsp;<c:choose><c:when test="${user.userSex eq 1}">男</c:when><c:when test="${user.userSex eq 2}">女</c:when><c:otherwise>保密</c:otherwise></c:choose>
                </span>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <span>
                    手机号码：&nbsp;&nbsp;${user.userMobileNo}
                </span>
            </td>
        </tr>
        <tr>
            <td class="td-title">团体标签：</td>
            <td class="td-tag">
                <%--<dl>
                    <dt>人群</dt>
                    <dd id="teamUserCrowdLabel">
                    </dd>
                </dl>--%>
                <dl>
                    <dt>属性</dt>
                    <dd id="teamUserPropertyLabel">
                    </dd>
                </dl>
                <%--<dl>
                    <dt>地点</dt>
                    <dd id="teamUserSiteLabel">
                    </dd>
                </dl>--%>
                <dl>
                    <dt>位置</dt>
                    <dd id="teamUserLocationLabel">
                    </dd>
                </dl>
            </td>
        </tr>
        <tr>
            <td class="td-title">团体图像：</td>
            <td class="td-upload">
                <table>
                    <tr>
                        <td id="tuserPictureLabel">
                            <input type="hidden" id="tuserPicture" value="${record.tuserPicture}">
                            <div class="img-box">
                                <div  id="imgHeadPrev" class="img"></div>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="td-title">团体类别：</td>
            <td class="td-input">
                <span>${dict.dictName}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">成员上限：</td>
            <td class="td-input">
                <span>${record.tuserLimit}&nbsp;人</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">团体描述：</td>
            <td class="td-content">
                <span>${record.tuserTeamRemark}</span>
            </td>
        </tr>
        <tr class="submit-btn">
            <td></td>
            <td class="td-btn">
                <input type="button" class="btn-save" value="返回" onclick="javascript :history.back(-1);"/>
            </td>
        </tr>
        </tbody>
    </table>
</div>
</body>
</html>
