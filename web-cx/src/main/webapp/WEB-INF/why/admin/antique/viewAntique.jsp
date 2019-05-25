<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <title>查看馆藏</title>
    <%@include file="../../common/pageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/getAntiqueImg.js"></script>
</head>
<body class="rbody">
<!-- 正中间panel -->
<form id="antique_update_form" action="" method="post">
    <!-- 正中间panel -->
    <div id="content">
        <div class="content">
            <div class="con-box-blp">
                <h3>查看馆藏</h3>
                <div class="con-box-tlp">
                    <div class="form-box">
                        <table class="form-table">
                            <tbody>
                            <tr>
                                <td class="td-title">馆藏名称：</td>
                                <td class="td-input-one" colspan="3">
                                    <span class="td-prompt-one">${record.antiqueName}</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="td-title" width="120">所属场所：</td>
                                <td class="td-input-two" colspan="3">
                                    <span class="td-prompt-one">
                                    ${cmsVenue.venueArea.substring(cmsVenue.venueArea.indexOf(",")+1,cmsVenue.venueArea.length())}
                                    &nbsp;&nbsp;
                                    <!-- 查询类型 -->
                                    &nbsp;&nbsp;
                                    ${cmsVenue.venueName}
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td class="td-title" width="120">馆藏分类：</td>
                                <td class="td-input-two" width="270">
                                    <c:forEach items="${sysDictList}" var="c" varStatus="s">
                                        <span class="td-prompt-one"><c:if test="${c.dictId == record.antiqueVenueId}"> ${c.dictName}</c:if></span>
                                    </c:forEach>
                                </td>
                                <td class="td-title" width="120" align="right">馆藏所在区域：</td>
                                <td class="td-input-two">
                                    <span class="td-prompt-one">${record.antiqueGalleryAddress}</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="td-title" >藏品时间：</td>
                                <td class="td-input-one td-input-two" colspan="3">
                                    <span class="td-prompt-one">${record.antiqueYears}</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="td-title">馆藏图片：</td>
                                <td class="td-input-two td-input-four"colspan="3">
                                    <div id="imgHeadPrev" style="width:100px; height:100px;position: relative; overflow: hidden;  float: left;">
                                        <input type="hidden"  name="antiqueImgUrl" id="antiqueImgUrl" value="${record.antiqueImgUrl}">
                                    </div>
                                </td>
                            </tr>

                            <tr>
                                <td class="td-title">音频介绍：</td>
                                <td class="td-input-two td-input-four"colspan="3">
                                    <span class="td-prompt-one">${record.antiqueVoiceUrl}</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="td-title">视频介绍：</td>
                                <td class="td-input-two td-input-four"colspan="3">
                                    <span class="td-prompt-one">${record.antiqueVideoUrl}</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="td-title">三维展示：</td>
                                <td class="td-input-two td-input-four"colspan="3">
                                    <span class="td-prompt-one">${record.antique3dUrl}</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="td-title-one">文字介绍：</td>
                                <td class="td-input-two td-input-five"colspan="3">
                                    <span class="td-prompt-one">${record.antiqueRemark}</span>
                                </td>
                            </tr>
                            <tr class="submit-btn">
                                <td colspan="4">
                                    <input type="button" value="返回" onclick="history.back(-1)"/>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
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
</body>
</html>