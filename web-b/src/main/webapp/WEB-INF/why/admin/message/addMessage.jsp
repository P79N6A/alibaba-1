<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<head>
    <title></title>
    <!-- 导入头部文件 start -->
    <%@include file="../../common/pageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/admin/sysMessage/addMessage.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">
        seajs.config({
            alias: {
                "jquery": "jquery-1.10.2.js"
            }
        });

        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        window.console = window.console || {log:function () {}}
        seajs.use(['jquery'], function ($) {
            $(function () {

              var dialog = parent.dialog.get(window);

             $(".btn-save").on("click", function(){
                     setDisBtn(true);
                 //验证
                     var msType = $("#msType").val();
                     if(typeof(msType) == "undefined"||msType==""){
                         $("#msTypeErr").html("请选择消息类型");
                         setDisBtn(false);
                         return;
                     }else{
                         $("#msTypeErr").html("");
                     }

                    var  msContent=$("#msContent").val();
                    if($.trim(msContent)==""){
                        $("#msContentErr").html("请输入消息内容");
                        setDisBtn(false);
                        return;
                    }else{
                        $("#msContentErr").html("");
                    }
                var  mtId=$("#mtId").val();
                if(typeof(mtId) == "undefined"||mtId==""){
                    $.post("${path}/message/addMessage.do", $("#messageForm").serialize(), function(data) {
                        if (data == "success") {
                            var html = "<h2>保存成功!</h2>";
                            dialogTypeSaveDraft("提示", html, function(){
                                parent.location.href="${path}/message/messageIndex.do";
                                dialog.close().remove();
                            });
                        }else if (data =='repeat'){
                            dialogTypeSaveDraft("提示", "", function(){

                            });
                        }
                        else {
                            var html = "<h2>更新失败,请联系管理员!</h2>";
                            dialogTypeSaveDraft("提示", html, function(){

                            });
                        }
                    });
                }else{
                    //执行更新操作
                    $.post("${path}/message/editMessage.do", $("#messageForm").serialize(), function(data) {
                        if (data == "success") {
                            var html = "<h2>更新成功!</h2>";
                            dialogTypeSaveDraft("提示", html, function(){
                                parent.location.href="${path}/message/messageIndex.do";
                                dialog.close().remove();

                            });
                        }else if (data =='repeat'){
                            dialogTypeSaveDraft("提示", "", function(){
                            });
                        }
                        else {
                            var html = "<h2>更新失败,请联系管理员!</h2>";
                            dialogTypeSaveDraft("提示", html, function(){

                            })
                        }
                    });
                }

                });
                /*点击取消按钮，关闭登录框*/
                $(".btn-cancel").on("click", function(){
                    dialog.close().remove();
                });

            });
        });


        function setDisBtn(tf){
            $(".btn-save").prop("disabled",tf);
        }

        function dialogTypeSaveDraft(title, content, fn){
            var d = parent.dialog({
                width:400,
                title:title,
                content:content,
                fixed: true,
                okValue: '确 定',
                ok: function () {
                    if(fn)  fn();
                }
            });
            d.showModal();
        }
    </script>
</head>

<body>

<%--<div class="site">
    <em>您现在所在的位置：</em>消息管理
    <c:choose>
        <c:when test="${empty mt}">新建系统消息</c:when>
        <c:otherwise>编辑系统消息</c:otherwise>
    </c:choose>
</div>

<div class="site-title">
    <c:choose>
        <c:when test="${empty mt}">新建系统消息</c:when>
        <c:otherwise>编辑系统消息</c:otherwise>
    </c:choose>
</div>

--%>

<div class="main-publish tag-add">

    <form  id="messageForm" method="post">
    <table width="100%" class="form-table">

        <tr>
            <td width="28%"  class="td-title"><span class="red">*</span>消息类型：</td>
            <td class="td-select">
                <div class="select-box w240">
                    <input type="hidden" id="msType" name="messageType" value="${mt.messageType}"/>
                    <div id="selType" class="select-text" data-value="${mt.messageType}">选择类型</div>
                    <ul class="select-option">
                        <c:forEach items="${messageTypeList}" var="mst">
                            <li data-option="${mst.dictId}">${mst.dictName}</li>
                            <c:if test="${mt.messageType eq mst.dictId}">
                                <input type="hidden" id="umsType" value="${mst.dictName}" />
                            </c:if>
                        </c:forEach>
                    </ul>
                </div>
                <span id="msTypeErr" class="error-msg"></span>
            </td>
        </tr>


<%--        <tr>
            <td width="100" class="td-title"><span class="red">*</span>目标用户：</td>
            <td class="td-select">
                <div class="select-box w140">
                    <input type="hidden" id="msUser" name="messageTargetUser" value="${mt.messageTargetUser}"/>
                    <div id="selTarget" class="select-text"  data-value="${mt.messageTargetUser}">选择目标用户</div>
                    <ul class="select-option">
                        <c:forEach items="${targetUserList}" var="t">
                            <li data-option="${t.dictId}">${t.dictName}</li>
                            <c:if test="${mt.messageTargetUser eq t.dictId}">
                                <input type="hidden" id="umsTarget" value="${t.dictName}" />
                            </c:if>
                        </c:forEach>
                    </ul>
                </div>
                <span id="msUserErr" class="error-msg"></span>
            </td>
        </tr>--%>

        <tr>
            <td width="28%"  class="td-title"><span class="red">*</span>消息内容：</td>
            <td class="td-input">
                <%--<input type="text" id="msContent" class="input-text w510" name="messageContent" maxlength="100" value="${mt.messageContent}"/>--%>
                <textarea id="msContent" class="textareaBox" style="height: 200px;"  name="messageContent">${mt.messageContent}</textarea>
                <span id="msContentErr" class="error-msg"></span>
            </td>
        </tr>



        <input type="hidden" id="mtId" name="messageId"  value="${mt.messageId}">


        <tr>

            <td class="td-btn" align="center" colspan="2">
                <input class="btn-save" type="button" value="保存" />
                <input class="btn-cancel" type="button" value="取消"/>
            </td>

<%--            <td class="td-title"></td>
            <td class="td-btn">
                <input class="btn-save" type="button" onclick="doSubmit()"  value="保存" />
                <input class="btn-publish" type="button" onclick="history.back(-1)" value="返回" />
            </td>--%>
        </tr>

    </table>
    </form>
</div>






<!-- 正中间panel -->
<%--<div id="content">
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
</div>--%>

</body>
</html>
