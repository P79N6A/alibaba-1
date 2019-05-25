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
   <%-- <script type="text/javascript" src="${path}/STATIC/js/area.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/area-venues-admin.js"></script>--%>
    <script type="text/javascript">

/*        $(function(){
            showVenueData();
        });*/


        function doSubmit(){
            //所属场所
/*
            var loc_venue=$('#loc_venue').val();
            var venueId=$('#venueId').val();

            if(loc_venue!=undefined){
                $('#venueId').val(loc_venue);
                venueId=loc_venue;
            }
            if(typeof(venueId) == "undefined"||venueId==""){
                //appendMsg("venueIdLabel","请选择所属场所!");
                $("#msTypeErr").html("请选择所属场馆");
                $('#venueId').focus();
                return;
            }else{
                $("#msTypeErr").html("");
            }
*/

            var  msContent=$("#antiqueTypeName").val();
            if($.trim(msContent)==""){
                $("#msContentErr").html("请输入藏品类型名称");
                return;
            }else{
                $("#msContentErr").html("");
            }


            var  mtId=$("#mtId").val();
            if(typeof(mtId) == "undefined"||mtId==""){
                $.post("${path}/antiqueType/addAntiqueType.do", $("#messageForm").serialize(), function(data) {
                    if (data == "success") {
                        var html = "<h2>保存成功!</h2>";
                        dialogSaveDraft("提示", html, function(){
                            window.location.href="${path}/antiqueType/index.do";
                        });
                    }else if (data =='repeat'){
                        var html = "<h2>code重复!</h2>";
                        dialogSaveDraft("提示", html, function(){

                        });
                    }
                    else {
                        var html = "<h2>更新失败,请联系管理员!</h2>";
                        dialogSaveDraft("提示", html, function(){

                        });
                    }
                });
            }
        }
    </script>
</head>

<body>

<form action="" id="typeForm">
<div class="main-publish tag-add">
    <div class="form-table type-add">

        <span id="errMsg" style="color: #EB3838; display: block; line-height: 20px; padding-bottom: 10px;"></span>

        <a class="btn-add">点击添加</a>
        <div class="type-list" id="type-list">
            <input class="input-text" type="text"  value="" data-val="请输入藏品类型" maxlength="25"/>
        </div>

        <div class="td-btn">
            <input class="btn-save" type="button" value="保存"/>
            <input class="btn-cancel" type="button" value="取消"/>
        </div>
    </div>
</div>
    <input type="hidden"  name="antiqueTypeName"  id="antiqueTypeName"  />
    <input type="hidden" value="${venueId}" name="venueId" />
</form>

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
        var dialog = parent.dialog.get(window);
        /*点击确定按钮*/
        $(".btn-save").on("click", function(){
            var  antiqueTypeName = "";
            $.each($("#type-list input"),function(){
                if($(this).val()!="请输入藏品类型" && $.trim($(this).val())){
                    antiqueTypeName+=$(this).val()+";";
                }
            });
            if(antiqueTypeName==""){
                $("#errMsg").html("请至少填写一个藏品类型");
                dialog.height($(document).height());
                dialog.reset();     // 重置对话框位置
                return;
            }
            $("#errMsg").html("");
            $("#antiqueTypeName").val(antiqueTypeName.substring(0,antiqueTypeName.length-1));
            var venueId="${venueId}";
            var html = '保存后只可增加、修改藏品类型，不可删除藏品类型。<br/>是否确认保存？';
            dialogTypeConfirm('保存提示', html, function(){


                $.post("${path}/antiqueType/addAntiqueType.do", $("#typeForm").serialize(), function(data) {
                    if (data == "success") {
                        var html = "<h2>保存成功!</h2>";
                        dialogTypeSaveDraft("提示", html, function(){
                            parent.location.href="${path}/antique/antiqueIndex.do?venueId="+venueId+"&antiqueState=6";
                            var status = "edit";
                            dialog.close(status).remove();
                        });
                    }else if (data =='repeat'){
                        var html = "<h2>code重复!</h2>";
                        dialogSaveDraft("提示", html, function(){

                        });
                    }
                    else {
                        var html = "<h2>更新失败,请联系管理员!</h2>";
                        dialogTypeSaveDraft("提示", html, function(){

                        });
                    }
                });

            })
        });
        /*点击取消按钮，关闭登录框*/
        $(".btn-cancel").on("click", function(){
            dialog.close().remove();
        });
        /*点击添加*/
        $(".btn-add").on('click', function(){
            if($("#type-list").find("input[type=text]").length < 20) {
                var oInput = $('<input class="input-text" type="text"  value="" data-val="请输入藏品类型" maxlength="25" />');
                $("#type-list").prepend(oInput);
            }else{
                var html = '请保存后再次添加';
                dialogTypeAlert('提示', html, function(){

                });
            }
            dialog.height($(document).height());
            dialog.reset();     // 重置对话框位置
        });

        $("#type-list").on({
            focus :function(){
                if($(this).val() == $(this).attr("data-val") || $(this).val() == "" || $(this).val() == null){
                    $(this).val("").css("color", "#13213F");
                }
            },
            blur :function(){
                if($(this).val() == $(this).attr("data-val") || $(this).val() == "" || $(this).val() == null){
                    $(this).val($(this).attr("data-val")).removeAttr('style');
                }
            }
        }, ".input-text");
    });

    function dialogTypeConfirm(title, content, fn){
        var d = parent.dialog({
            width:400,
            title:title,
            content:content,
            fixed: true,
            button:[{
                value: '确定',
                callback: function () {
                    if(fn)  fn();
                },
                autofocus: true
            },{
                value: '取消'
            }]
        });
        d.showModal();
    }
    function dialogTypeAlert(title, content, fn){
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
    /*保存草稿箱*/
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

<%--
<div class="site">
    <em>您现在所在的位置：</em>藏品类型管理&gt;添加藏品类型
</div>

<div class="site-title">
</div>
<div class="main-publish">
    <form  id="messageForm" method="post">
    <table width="100%" class="form-table">
        <tr>
                <td width="100" class="td-title"><span class="red">*</span>所属场馆：</td>
                <td class="td-select" id="venueIdLabel">
                    <input type="text" style="position: absolute; left: -9999px;" id="venueId" name="venueId"/>
                    <select id="loc_area" style="width:142px; margin-right: 8px"></select>
                    <select id="loc_category" style="width:142px; margin-right: 8px"></select>
                    <select id="loc_venue"  style="width:142px; margin-right: 8px"></select>
                    <span id="msTypeErr" class="error-msg"></span>
                </td>
        </tr>

        <tr>
            <td width="100" class="td-title"><span class="red">*</span>藏品类型名称：</td>
            <td class="td-input">

                    <input type="text" id="antiqueTypeName" class="input-text w510"
                           name="antiqueTypeName" maxlength="100" value=""/>

                <span id="msContentErr" class="error-msg"></span>
            </td>
        </tr>

        <input type="hidden" id="antiqueTypeId" name="antiqueTypeId" value="">


        <tr>
            <td width="100" class="td-title"></td>
            <td class="td-btn">
                <input class="btn-save" type="button" onclick="doSubmit()"  value="保存" />
                <input class="btn-publish" type="button" onclick="history.back(-1)" value="返回" />
            </td>
        </tr>

    </table>
    </form>
</div>--%>

</body>
</html>
