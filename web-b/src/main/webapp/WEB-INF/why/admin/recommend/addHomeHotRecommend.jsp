<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <script type="text/javascript">
        //绑定事件
        $(function () {
            $("#areaDiv li").mousedown(function () {
                if ($(this).attr("data-option") == 0) {
                    $("#sbuject").show();
                } else {
                    $("#sbuject").hide();
                }
            });
        });


    </script>

    <script type="text/javascript">
        //** 日期控件
        $(function () {
            $(".start-btn").on("click", function () {
                WdatePicker({
                    el: 'startDateHidden',
                    dateFmt: 'yyyy-MM-dd',
                    doubleCalendar: true,
                    minDate: '%y-%M-{%d}',
                    maxDate: '#F{$dp.$D(\'endDateHidden\')}',
                    position: {left: -224, top: 8},
                    isShowClear: false,
                    isShowOK: true,
                    isShowToday: false,
                    onpicked: pickedStartFunc
                })
            })
            $(".end-btn").on("click", function () {
                WdatePicker({
                    el: 'endDateHidden',
                    dateFmt: 'yyyy-MM-dd',
                    doubleCalendar: true,
                    minDate: '#F{$dp.$D(\'startDateHidden\')}',
                    position: {left: -224, top: 8},
                    isShowClear: false,
                    isShowOK: true,
                    isShowToday: false,
                    onpicked: pickedendFunc
                })
            })
        });
        function pickedStartFunc() {
            $dp.$('activityStartTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
            $dp.$('startWeek').innerHTML = $dp.cal.getDateStr('DD');
        }
        function pickedendFunc() {
            $dp.$('activityEndTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
            $dp.$('endWeek').innerHTML = $dp.cal.getDateStr('DD');
        }
    </script>

</head>
<body style="background: none;">
<%--360下无法取得session--%>
<input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}"/>
<input type="hidden" id="isCutImg" value=""/>
<form id="addAdvert" method="post">

    <input type="hidden" name="advertId" value="${advertId}"/>

    <div class="main-publish tag-add">
        <table width="100%" class="form-table">


            <tr>
                <td width="28%" class="td-title">排序：</td>
                <td class="td-input">
                    <input type="text" id="advertPosSort" name="advertPosSort"
                           value="${sortNum}" class="input-text w220" readonly/>
                </td>
            </tr>

            <tr>
                <td width="28%" class="td-title">内容标题：</td>
                <td class="td-input">
                    <input type="text" id="advertTitle" name="advertTitle"
                           value="" class="input-text w220"/>
                </td>
            </tr>


            <tr>
                <td width="28%" class="td-title">地址：</td>
                <td class="td-input">
                    <input type="text" id="advertAdress" name="advertAdress"
                           value="" class="input-text w220"/>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动日期：</td>
                <td class="td-time" id="activityStartTimeLabel">
                    <div class="start w340">
                        <span class="text">开始日期</span>
                        <input type="hidden" id="startDateHidden"/>
                        <input type="text" id="activityStartTime" name="startTime" value="" readonly/>
                        <span class="week" id="startWeek"></span>
                        <i class="data-btn start-btn"></i>
                    </div>
                    <div class="end w340" style="margin-top: 10px;">
                        <span class="text">结束日期</span>
                        <input type="hidden" id="endDateHidden"/>
                        <input type="text" id="activityEndTime" name="endTime" value="" readonly/>
                        <span class="week" id="endWeek"></span>
                        <i class="data-btn end-btn"></i>
                    </div>
                </td>
            </tr>


            <tr>
                <td width="28%" class="td-title">链接：</td>
                <td class="td-input">
                    <input type="text" id="advertConnectUrl" name="advertConnectUrl"
                           value="" class="input-text w220"/>
                </td>
            </tr>


            <tr>
                <td width="28%" class="td-title">上传图片：</td>
                <td class="td-upload"><%-- class="td-upload"--%>
                    <input type="hidden" name="advertPicUrl" id="headImgUrl" value=""/>
                    <input type="hidden" name="uploadType" value="Img" id="uploadType"/>

                    <div class="img-box">
                        <div id="imgHeadPrev" class="img">

                        </div>
                    </div>

                </td>


            </tr>

            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-upload">
                    <input type="file" name="file" id="file"/>
                    <span>建议尺寸133px*100px</span>
                </td>
            </tr>

            <tr>
                <td class="td-btn" align="center" colspan="1000">
                    <a style="color: red" id="PromptMessger"></a>
                </td>
            </tr>
            </tr>
            <tr>
                <td class="td-btn" align="center" colspan="2">
                    <input class="btn-save" type="button" value="保存"/>
                    <input class="btn-cancel" type="button" value="取消"/>
                </td>
            </tr>
        </table>
    </div>
    <input type="hidden" value="" id="siteId" name="siteId"/>
</form>

<script type="text/javascript">

    function getImgHtml(imgUrl) {
        if (imgUrl == "") {
            return '<img src="../STATIC/image/defaultImg.png" />';
        }
        return '<img style="width:"+300px; height:200px;"  src="' + imgUrl + '" />';
    }

    $(function () {
        var recordId = '${record.advertId}';
        if (recordId != "") {
            //地区选中
            $("#CarouselList").html('${record.advertColumn}');
            //排序选中
            var deSort = '${record. advertPosSort}';
            $("#advertPosSort").val(deSort);
            $("#sortDiv").attr("data-value", deSort);
            $("#sortDiv").html(deSort);

            var imgUrl = '${record.advertPicUrl}';
            if (imgUrl != "") {
                //$("#imgHeadPrev").attr("src",getImgUrl(imgUrl));
                $("#imgHeadPrev").html(getImgHtml(getImgUrl(imgUrl)));
            } else {
                $("#imgHeadPrev").html(getImgHtml(""));
            }
        } else {
            $("#imgHeadPrev").html(getImgHtml(""));
        }
        selectModel();
    });
</script>
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


    seajs.use(['jquery'], function ($) {
        $(function () {

            var dialog = parent.dialog.get(window);
            mdialog = dialog;

            var tips = "添加成功";
            /*点击确定按钮*/
            $(".btn-save").on("click", function () {


                var isCutImg = $("#isCutImg").val();
                if ("N" == isCutImg) {
                    dialogAlert("提示", "请上传尺寸不小于系统要求的图片", function () {
                    });
                    return;
                }


                var sort = $("#advertPosSort").val();

                if (sort == "") {
                    dialogTypeSaveDraft("提示", "请选择活动热点图排序", function () {
                    });
                    return;
                }

                var activityStartTime = $("#activityStartTime").val();
                var activityEndTime = $("#activityEndTime").val();
                if (activityStartTime == "" || activityEndTime == "") {
                    dialogTypeSaveDraft("提示", "请选择活动时间", function () {
                    });
                    return;
                }

                var imgUrl = $("#headImgUrl").val();
                if (!imgUrl) {
                    dialogTypeSaveDraft("提示", "请上传图片", function () {
                    });
                    return;
                }


                $.post("${path}/advert/addHomeHotRecommendAdvert.do", $("#addAdvert").serialize(),
                        function (data) {
                            if (data != null && data == 'success') {
                                $('#PromptMessger').html("");
                                dialogTypeSaveDraft("提示", tips, function () {
                                    parent.location.href = "${path}/recommend/homeHotRecommendIndex.do";
                                    dialog.close().remove();
                                });
                            }

                        });
            });

            /*点击取消按钮，关闭登录框*/
            $(".btn-cancel").on("click", function () {
                mdialog.close().remove();
            });

        });
    });
    function dialogTypeSaveDraft(title, content, fn) {
        var d = parent.dialog({
            width: 400,
            title: title,
            content: content,
            fixed: true,
            okValue: '确 定',
            ok: function () {
                if (fn)  fn();
            }
        });
        d.showModal();
    }


</script>
<script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        var Img = $("#uploadType").val();
        $("#file").uploadify({
            'formData': {
                'uploadType': Img,
                'type': 2,
                'userCounty': $("#userCounty").val()
            },//传静态参数
            swf: '${path}/STATIC/js/uploadify.swf',
            uploader: '../upload/uploadFile.do;jsessionid=${pageContext.session.id}',//后台处理的请求
            buttonText: '上传图片',//上传按钮的文字
            'buttonClass': "upload-btn",//按钮的样式
            queueSizeLimit: 1, //   default 999
            'method': 'post',//和后台交互的方式：post/get
            queueID: 'fileContainer',
            fileObjName: 'file', //后台接受参数名称
            fileTypeExts: '*.gif;*.png;*.jpg;*.jpeg;', //控制可上传文件的扩展名，启用本项时需同时声明fileDesc
            'auto': true, //true当选择文件后就直接上传了，为false需要点击上传按钮才上传
            'multi': false, //是否支持多个附近同时上传
            height: 30,//选择文件按钮的高度
            width: 80,//选择文件按钮的宽度
            'debug': false,//debug模式开/关，打开后会显示debug时的信息
            'dataType': 'json',
            removeCompleted: false,//上传成功后的文件，是否在队列中自动删除
            onUploadSuccess: function (file, data, response) {
                var json = $.parseJSON(data);
                var url = json.data;
                var imgUrl = getImgUrl(url);
                $("#headImgUrl").val(url);
                //$("#imgHeadPrev").attr("src",imgUrl);
                var initWidth = parseInt(json.initWidth);
                var initHeigth = parseInt(json.initHeigth);

                $("#imgHeadPrev").html(getImgHtml(imgUrl));

                //隐藏该区域
                $(".uploadify-queue-item").hide();
            },
            <%--var initWidth = parseInt(json.initWidth);--%>
            <%--var initHeigth = parseInt(json.initHeigth);--%>
            <%--if(initWidth<133 && initHeigth<100){--%>
            <%--dialogAlert("提示","请上传尺寸不小于133*100(px)的图片",function(){--%>
            <%--});--%>
            <%--$("#isCutImg").val("N");--%>
            <%--return;--%>
            <%--}else{--%>
            <%--$("#isCutImg").val("Y");--%>
            <%--}--%>


            <%--var cutImageWidth =133;--%>
            <%--var cutImageHeigth =100;--%>
            <%--var url =getImgUrl(url);--%>

            <%--parent.dialog({--%>
            <%--url: '${path}/att/toCutImgJsp.do',--%>
            <%--data: {--%>
            <%--imageUrl: url,--%>
            <%--initWidth:initWidth,--%>
            <%--initHeigth:initHeigth,--%>
            <%--cutImageWidth:cutImageWidth,--%>
            <%--cutImageHeigth:cutImageHeigth--%>
            <%--},--%>
            <%--title: '图片裁剪',--%>
            <%--fixed: false,--%>
            <%--onclose: function () {--%>
            <%--if(this.returnValue){--%>
            <%--//alert("返回值：" + this.returnValue.imageUrl);--%>
            <%--$("#imgHeadPrev").html(getImgHtml(this.returnValue.imageUrl));--%>
            <%--// $("#headImgUrl").val(this.returnValue.imageUrl);--%>
            <%--$("#isCutImg").val("Y");--%>
            <%--}--%>
            <%--}--%>
            <%--}).showModal();--%>
            <%--return false;--%>
            <%--},--%>
            <%----%>
            onSelect: function () {
            },
            onCancel: function () {
                $("#headImgUrl").val("");
                $('#file').uploadify('cancel', '*');
                //cancelUpload();
            }
        });

    });
    //if (navigator.userAgent.indexOf("Firefox") != -1) {
    //myUploadImg();
    //}


    //取消上传时
    /*    function cancelUpload(){
     $("#headImgUrl").val("");
     $('#file').uploadify('cancel', '*');
     }*/

</script>

</body>
</html>



