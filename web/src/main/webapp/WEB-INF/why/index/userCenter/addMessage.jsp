<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="../top.jsp"%>
    <script type="text/javascript">
        $(function(){
            var umsType = $("#umsType").val();
            if(typeof(umsType) != "undefined"){
                    $("#selType").html(umsType);
            }
            var umsTarget=$("#umsTarget").val();
            if(typeof(umsTarget) != "undefined"){
                $("#selTarget").html(umsTarget);
            }
            selectModel();
        });



        function doSubmit(){
            var  msContent=$("#msContent").val();
            if($.trim(msContent)==""){
                alert("请输入内容");
                //removeMsg("sensitiveWordsLable");
                //appendMsg("sensitiveWordsLable","请输入敏感词!");
                return;
            }else{
                //removeMsg("sensitiveWordsLable");
            }
            var  mtId=$("#mtId").val();
            if(typeof(mtId) == "undefined"||mtId==""){
                $.post("${path}/message/addMessage.do", $("#messageForm").serialize(), function(data) {
                    if (data == "success") {
                        jAlert('保存成功', '系统提示','success',function (r){
                            window.location.href="${path}/message/messageIndex.do";
                        });
                    }else if (data =='repeat'){
                        jAlert('保存失败该敏感词已经存在', '系统提示','failure',function (r){});
                    }
                    else {
                        jAlert('保存失败'+ data, '系统提示','failure',function (r){});
                    }
                });
            }else{
                //执行更新操作
                $.post("${path}/message/editMessage.do", $("#messageForm").serialize(), function(data) {
                    if (data == "success") {
                        jAlert('更新成功', '系统提示','success',function (r){
                            window.location.href="${path}/message/messageIndex.do";
                        });
                    }else if (data =='repeat'){
                        jAlert('保存失败该敏感词已经存在', '系统提示','failure',function (r){});
                    }
                    else {
                        jAlert('更新失败'+ data, '系统提示','failure',function (r){});
                    }
                });
            }


        }

    </script>
</head>

<body class="rbody">
<!-- 正中间panel -->
<div id="content">
    <div class="content">
        <div class="con-box-blp">
            <h3>
                <c:choose>
                    <c:when test="${empty mt}">新建系统消息</c:when>
                    <c:otherwise>更新系统消息</c:otherwise>
                </c:choose>
            </h3>
            <div class="con-box-tlp">
                <div class="form-box">
                    <form id="messageForm" method="post">
                        <table class="form-table">
                            <tbody>

                            <tr>
                                <td class="td-title"><span class="td-prompt">*</span>消息模板内容：</td>
                                <td class="td-input-one" colspan="3" id="activityNameLabel">
                                    <input type="text" id="msContent" name="messageContent" maxlength="100" value="${mt.messageContent}"/>
                                </td>
                            </tr>

                            <tr>
                                <td class="td-title"><span class="td-prompt">*</span>消息类型：</td>

                                <td class="td-input-two">
                                    <div class="select-box-one select-box-three">
                                        <input type="hidden" id="msType" name="messageType" value="${mt.messageType}"/>
                                        <div id="selType" class="select-text-one select-text-three" data-value="${mt.messageType}">选择类型</div>
                                        <ul class="select-option select-option-three">
                                            <c:forEach items="${messageTypeList}" var="mst">
                                                <li data-option="${mst.dictId}">${mst.dictName}</li>
                                                <c:if test="${mt.messageType eq mst.dictId}">
                                                    <input type="hidden" id="umsType" value="${mst.dictName}" />
                                                </c:if>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </td>

                            </tr>
                            <tr>
                                <td class="td-title"><span class="td-prompt">*</span>目标用户：</td>

                                <td class="td-input-two">
                                    <div class="select-box-one select-box-three">
                                        <input type="hidden" id="msUser" name="messageTargetUser" value="${mt.messageTargetUser}"/>
                                        <div id="selTarget" class="select-text-one select-text-three"  data-value="${mt.messageTargetUser}">选择目标用户</div>
                                        <ul class="select-option select-option-three">
                                            <c:forEach items="${targetUserList}" var="t">
                                                <li data-option="${t.dictId}">${t.dictName}</li>
                                                <c:if test="${mt.messageTargetUser eq t.dictId}">
                                                    <input type="hidden" id="umsTarget" value="${t.dictName}" />
                                                </c:if>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </td>

                            </tr>

                            <input type="hidden" id="mtId" name="messageId"  value="${mt.messageId}">

                            <tr class="submit-btn">
                                <td colspan="2">
                                    <input type="button" value="保存" onclick="doSubmit()"/>
                                    <input type="button" value="返回" onclick="history.back(-1)"/>
                                </td>
                            </tr>

                            </tbody>
                        </table>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
