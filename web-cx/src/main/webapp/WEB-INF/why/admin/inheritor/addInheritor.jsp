<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/admin/inheritor/UploadCultureInheritorImg.js"></script>
</head>

<body style="background: none;">
<form id="inheritorForm">
    <div class="main-publish tag-add">
        <input type="hidden" id="sessionId" value="${pageContext.session.id}"/>
        <input type="hidden" name="cultureId" value="${inheritor.cultureId}"/>
            <table width="100%" class="form-table">
                <tr>
                    <td class="td-title" width="20%">传承非遗：</td>
                    <td class="td-input">${inheritor.cultureName}</td>
                </tr>
                <tr>
                    <td class="td-title"><span class="red">*</span>姓名：</td>
                    <td class="td-input" id="inheritorNameLabel"><input type="text" class="input-text w210" id="inheritorName" name="inheritorName" maxlength="20"/></td>
                </tr>
                <tr>
                    <td class="td-title">性别：</td>
                    <td class="td-radio">
                        <label><input type="radio" value="1" name="inheritorSex" checked/><em>男</em></label>
                        <label><input type="radio" value="2" name="inheritorSex"/><em>女</em></label>
                    </td>
                </tr>
                <tr>
                    <td class="td-title">年龄：</td>
                    <td class="td-input" id="inheritorAgeLabel"><input type="text" id="inheritorAge" class="input-text w210" name="inheritorAge" onkeyup="this.value=this.value.replace(/\D/g,'')" maxlength="11"/></td>
                </tr>
                <tr>
                    <td class="td-title"><span class="red">*</span>民族：<input type="text" id="inheritorNationHidden" style="position: absolute; left: -9999px;" /></td>
                    <td class="td-select" id="inheritorNationLabel">
                        <input type="hidden" name="inheritorNation"  id="inheritorNation"/>
                        <select id="inheritorNationType" style="width:142px; margin-right: 8px"></select>
                    </td>
                </tr>
                <tr>
                    <td class="td-title"><span class="red">*</span>传承人头像：</td>
                    <td class="td-upload">
                        <table>
                            <tr>
                                <td id="inheritorHeadImgUrlLabel">
                                    <input type="hidden"  name="inheritorHeadImgUrl" id="inheritorHeadImgUrl">
                                    <input type="hidden" name="uploadType" value="Img" id="uploadType"/>

                                    <div class="img-box">
                                        <div  id="imgHeadPrev" class="img"> </div>
                                    </div>

                                    <div style="margin-left: 20px; display: inline-block; vertical-align: bottom;">
                                        <div style="height: 46px;">
                                            <div class="controls" style="float:left;">
                                                <input type="file" name="file" id="file">
                                            </div>
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
                <tr class="td-line">
                    <td class="td-title">传承人简介：</td>
                    <td class="td-input">
                        <textarea rows="4" name="inheritorRemark" class="textareaBox" style="width: 500px;resize: none"></textarea>
                    </td>
                </tr>
                <tr>
                    <td class="td-title"></td>
                    <td class="td-btn">
                        <input class="btn-save" type="button"  value="保存"/>
                        <input class="btn-cancel" type="button" value="关闭"/>
                    </td>
                </tr>
            </table>
    </div>
</form>

<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
    $(function(){
        showNationSelectData("inheritorNationType", "${path}/sysdict/queryCode.do?dictCode=NATION_TYPE", "请选择民族");
        $("#inheritorNationType").change(function() {
            $("#inheritorNation").val($(this).find("option:selected").val());
        });
    });

    function showNationSelectData(el_id, url, title, selected_id, fn) {
        var el	= $('#'+el_id);
        el.empty();
        el.append('<option value="">'+ title +'</option>');

        el.select2();

        if (selected_id) {
            loadingNationSelectData(el_id, url,  selected_id);
        } else {
            loadingNationSelectData(el_id, url);
        }
    }
    /*加载select 数据*/
    function loadingNationSelectData(el_id , url , selected_id){
        var el	= $('#'+el_id);
        if(url) {
            $.post(url, {}, function (data) {
                if (data) {
                    var index = 1;
                    var selected_index = 0;
                    $.each(data, function (k, v) {
                        var option	= '<option value="'+data[k].dictId+'">'+data[k].dictName+'</option>';
                        el.append(option);
                        if (data[k].id == selected_id) {
                            selected_index = index;
                        }
                        index++;
                    });
                    el.attr('selectedIndex' , selected_index);
                }
            }).success(function(){
                el.select2("val", selected_id);   /*赋默认值*/
            });
        }
        el.select2("val", "");
    }

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
            /*点击确定按钮*/
            $(".btn-save").on("click", function(){
                var inheritorName = $("#inheritorName").val();
                var inheritorAge = $("#inheritorAge").val();
                var inheritorNation = $("#inheritorNation").val();
                var inheritorHeadImgUrl = $("#inheritorHeadImgUrl").val();

                if(inheritorName==undefined||$.trim(inheritorName)==""){
                    removeMsg("inheritorNameLabel");
                    appendMsg("inheritorNameLabel","姓名为必填项!");
                    $('#inheritorName').focus();
                    return;
                }else{
                    removeMsg("inheritorNameLabel");
                }

                if(inheritorAge != undefined && $.trim(inheritorAge) != ""){
                    if(parseInt(inheritorAge) < 1 || parseInt(inheritorAge) > 200){
                        removeMsg("inheritorAgeLabel");
                        appendMsg("inheritorAgeLabel","年龄必须在1到200岁之间!");
                        $('#inheritorAge').focus();
                        return;
                    }else{
                        removeMsg("inheritorAgeLabel");
                    }
                }else{
                    removeMsg("inheritorAgeLabel");
                }

                if(inheritorNation==undefined||$.trim(inheritorNation)==""){
                    removeMsg("inheritorNationLabel");
                    appendMsg("inheritorNationLabel","民族为必选项!");
                    $('#inheritorNation').focus();
                    return;
                }else{
                    removeMsg("inheritorNationLabel");
                }

                if(inheritorHeadImgUrl == undefined || $.trim(inheritorHeadImgUrl) == ""){
                    removeMsg("inheritorHeadImgUrlLabel");
                    appendMsg("inheritorHeadImgUrlLabel","传承人图片必须上传!");
                    $('#inheritorHeadImgUrl').focus();
                    return;
                }else{
                    removeMsg("inheritorNationLabel");
                }

                $.post("${path}/inheritor/addInheritor.do", $("#inheritorForm").serialize(), function(result) {
                    if (result == "success") {
                        dialogSaveDraft("提示", "保存成功", function(){
                            parent.location.href="${path}/inheritor/inheritorIndex.do?cultureId=${inheritor.cultureId}&cultureName=${inheritor.cultureName}";
                            dialog.close().remove();
                        });
                    }else{
                        dialogSaveDraft("提示", "保存失败");
                    }
                });
            });
            /*点击取消按钮，关闭登录框*/
            $(".btn-cancel").on("click", function(){
                dialog.close().remove();
            });
        });
    });
</script>
</body>
</html>