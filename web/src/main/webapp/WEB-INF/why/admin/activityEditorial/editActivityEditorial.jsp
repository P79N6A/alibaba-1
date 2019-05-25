<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
	
    <script type="text/javascript" src="${path}/STATIC/js/admin/activityEditorial/UploadActivityEditorialFile.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/area.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/admin/activityEditorial/editActivityEditorial.js"></script>
    
    <script type="text/javascript">
        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        window.console = window.console || {log:function () {}}
        
    </script>
</head>

<body>
	<form action="${path}/activity/addActivity.do" id="activityEditorialForm" method="post">
	    <input type="hidden" id="userCounty" name="userCounty" value="${sessionScope.user.userCounty}"/>
	    <input type="hidden" id="sessionId" value="${pageContext.session.id}"/>
	    <input type="hidden" id="activityId" name="activityId" value="${activityEditorial.activityId}"/>
	    <input type="hidden" id="activityState" name="activityState" value="${activityEditorial.activityState}"/>
	    <input type="hidden" name="eventStartTime" value="" id="eventStartTime"/>
	    <input type="hidden" name="eventEndTime" value="" id="eventEndTime"/>
	    <input type="hidden" id="isCutImg" value="Y"/>
	    
	    <div class="site">
	        <em>您现在所在的位置：</em>运维管理  &gt; 采编活动管理  &gt; 编辑采编
	    </div>
	    <div class="site-title">编辑采编</div>
	    <div class="main-publish">
	        <table width="100%" class="form-table">
	            <tr>
	                <td width="100" class="td-title"><span class="red">*</span>活动标题：</td>
	                <td class="td-input" id="activityNameLabel"><input type="text" id="activityName" name="activityName" class="input-text w510" maxlength="13" value='<c:out value="${activityEditorial.activityName}" escapeXml="true"/>'/></td>
	            </tr>
				<tr>
	                <td width="100" class="td-title"><span class="red">*</span>活动主题：</td>
	                <td class="td-input" id="activitySubjectLabel">
	                    <input type="text" id="activitySubject" name="activitySubject" class="input-text w510" maxlength="7" value="${activityEditorial.activitySubject}"/>
	                    <span class="upload-tip" style="color:#596988" id="activitySubjectTipLabel">（主题请在7个字以内）</span>
	                </td>
	            </tr>
	            <tr>
	                <td width="100" class="td-title"><span class="red">*</span>上传封面：</td>
	                <td class="td-upload" id="activityIconUrlLabel">
	                    <table>
	                        <tr>
	                            <td>
	                                <input type="hidden"  name="activityIconUrl" id="activityIconUrl" value="${activityEditorial.activityIconUrl}">
	                                <input type="hidden" name="uploadType" value="Img" id="uploadType"/>
	
	                                <div class="img-box">
	                                    <div  id="imgHeadPrev" class="img"> </div>
	                                </div>
	                                <div class="controls-box">
	                                    <div style="height: 46px;">
	                                        <div class="controls" style="float:left;">
	                                            <input type="file" name="file" id="file">
	                                        </div>
	                                        <%--<input type="button" class="upload-cut-btn" id="" value="裁剪图片"/>--%>
	                                        <span class="upload-tip">可上传1张图片，建议尺寸750*500像素，格式为jpg,jpeg,png,gif，大小不超过2M</span>
	                                    </div>
	                                    <div id="fileContainer"></div>
	                                    <div id="btnContainer" style="display: none;">
	                                        <a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>
	                                    </div>
	                                </div>
	                            </td>
	                        </tr>
	                    </table>
	                </td>
	            </tr>
	            <tr>
	                <td width="100" class="td-title">
						<%--<span class="red">*</span>--%>
						URL：</td>
	                <td class="td-input" id="activityUrlLabel">
	                	<input type="text" id="activityUrl" name="activityUrl" class="input-text w510" value="${activityEditorial.activityUrl}"/>
	                </td>
	            </tr>
	            <tr>
	                <td width="100" class="td-title"><span class="red">*</span>活动类别：</td>
	                <td class="td-tag">
                        <dl>
                            <input id="activityType" name="activityType"  style="position: absolute; left: -9999px;" type="hidden" value="${activityEditorial.activityType}"/>
                            <dd id="activityTypeLabel">
                            </dd>
                        </dl>
	                </td>
	            </tr>
	            <tr>
	                <td width="100" class="td-title"><span class="red">*</span>活动日期：</td>
	                <td class="td-time" id="activityStartTimeLabel">
	                    <div class="start w340">
	                        <span class="text">开始日期</span>
	                        <input type="hidden" id="startDateHidden" value='<fmt:formatDate value="${activityEditorial.activityStartTime}" pattern="yyyy-MM-dd"/>'/>
	                        <input type="text" id="activityStartTime" name="activityStartTime" value='<fmt:formatDate value="${activityEditorial.activityStartTime}" pattern="yyyy-MM-dd"/>' readonly/>
	                        <span class="week" id="startWeek"></span>
	                        <i class="data-btn start-btn"></i>
	                    </div>
	                    <span class="txt">至</span>
	                    <div class="end w340">
	                        <span class="text">结束日期</span>
	                        <input type="hidden" id="endDateHidden" value='<fmt:formatDate value="${activityEditorial.activityEndTime}" pattern="yyyy-MM-dd"/>'/>
	                        <input type="text" id="activityEndTime" name="activityEndTime" value='<fmt:formatDate value="${activityEditorial.activityEndTime}" pattern="yyyy-MM-dd"/>' readonly/>
	                        <span class="week" id="endWeek"></span>
	                        <i class="data-btn end-btn"></i>
	                    </div>
	                    <span class="txt des">具体描述</span>
	                    </div><input type="text" maxlength="100" class="input-text w210" id="activityTimeDes" name="activityTimeDes" data-val="例如：每周三上午8:00-11:30" value='<c:out value="${activityEditorial.activityTimeDes}" escapeXml="true"/>'/></td>
	            </tr>
	            <tr>
	                <td width="100" class="td-title"><span class="red">*</span>活动时间：</td>
	                <td class="td-input">
	                    <div id="free-time-set">
	                        <div id="put-ticket-list" style="width: 800px;">
	                            <div class="ticket-item"  id="activityTimeLabel1">
	                                <input onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"  type="text"  name="eventStartHourTime" data-type="hour" class="input-text w64" maxlength="2" value='<fmt:formatDate value="${activityEditorial.activityStartTime}" pattern="HH"/>'/><em>：</em>
	                                <input onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"  type="text" name="eventStartMinuteTime" data-type="minute" class="input-text w64" maxlength="2" value='<fmt:formatDate value="${activityEditorial.activityStartTime}" pattern="mm"/>'/><span class="zhi">至</span>
	                                <input onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"  type="text" name="eventEndHourTime" data-type="hour" class="input-text w64" maxlength="2" value='<fmt:formatDate value="${activityEditorial.activityEndTime}" pattern="HH"/>'/><em>：</em>
	                                <input onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"  type="text" name="eventEndMinuteTime" data-type="minute" class="input-text w64" maxlength="2" value='<fmt:formatDate value="${activityEditorial.activityEndTime}" pattern="mm"/>'/>
	                            </div>
	                        </div>
	                    </div>
	                </td>
	                </td>
	            </tr>
	            <tr>
	                <td width="100" class="td-title"><span class="red">*</span>具体地点：</td>
	                <td class="td-input" id="activityAddressLabel">
	                    <input type="text" id="activityAddress" name="activityAddress" class="input-text w510" maxlength="50" value='<c:out value="${activityEditorial.activityAddress}" escapeXml="true"/>'/>
	                    <span class="upload-tip" style="color:#596988" id="activityAddressTipLabel">（场馆名称+馆内位置，例如："中华艺术宫3层"）</span>
	                </td>
	            </tr>
		<tr>
			<td width="100" class="td-title">
				<%--<span class="red">*</span>--%>
				联系电话：</td>
			<td class="td-input" id="activityTelLabel">
				<input type="text" id="activityTel" name="activityTel" class="input-text w510" maxlength="20" value="${activityEditorial.activityTel}"/>
				<%--<span class="upload-tip" style="color:#596988" id="activityTelTipLabel">（场馆名称+馆内位置，例如："中华艺术宫3层"）</span>--%>
			</td>
		</tr>
	            <tr>
	                <td width="100" class="td-title"><span class="red">*</span>是否收费：</td>
	                <td class="td-input td-fees" id="activityPriceLabel">
	                    <label><input type="radio"  checked="checked" name="activityIsFree" value="1" <c:if test="${activityEditorial.activityIsFree ==1}"> checked="checked" </c:if>/><em>免费</em></label>
	                    <label><input type="radio"  name="activityIsFree" value="2" <c:if test="${activityEditorial.activityIsFree ==2}"> checked="checked" </c:if>/><em>收费</em></label>
	                </td>
	            </tr>
	            <tr>
                <td width="100" class="td-title">简介：</td>
	                <td class="td-input">
	                    <div class="editor-box">
	                        <textarea name="activityMemo" rows="4" class="textareaBox"  maxlength="50" style="width: 500px;resize: none">${activityEditorial.activityMemo}</textarea>
	                    	<span class="upload-tip" style="color:#596988" id="activityMemoTipLabel">（0~50个字以内）</span>
	                    </div>
	                </td>
	            </tr>
	            <tr>
	                <td width="100" class="td-title"></td>
	                <td class="td-btn">
	                    <div class="room-order-info info2" style="position: relative;">
	                        <input class="btn-publish" type="button" onclick="updateActivity()" value="保存修改"/>
	                        <input type="button" class="btn-save" onclick="javascript:history.go(-1);" value="返回"/>
	                    </div>
	                </td>
	            </tr>
	        </table>
	    </div>
	</form>
</body>
</html>