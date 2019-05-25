<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>添加广告--文化云</title>


    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <link rel="shortcut icon" href="/STATIC/image/favicon.ico" type="image/x-icon" mce_href="/STATIC/image/favicon.ico">
    <link href="/STATIC/image/favicon.ico" rel="icon" type="image/x-icon" mce_href="/STATIC/image/favicon.ico">
    <link rel="stylesheet" type="text/css" href="/STATIC/css/reset.css"/>
    <link rel="stylesheet" type="text/css" href="/STATIC/css/main.css"/>
    <link rel="stylesheet" type="text/css" href="/STATIC/css/jquery.alerts.css">
    <!--[if lte IE 8]>
    <link rel="stylesheet" type="text/css" href="/STATIC/css/main-ie.css"/>
    <![endif]-->
    <link rel="stylesheet" type="text/css" href="/STATIC/css/page.css"/>
    <link rel="stylesheet" type="text/css" href="/STATIC/css/select2.css"/>
    <link rel="stylesheet" type="text/css" href="/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="/STATIC/js/jquery.min.js"></script>
    <script type="text/javascript" src="/STATIC/js/base.js"></script>
    <script type="text/javascript" src="/STATIC/js/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="/STATIC/js/common.js"></script>
    <script type="text/javascript" src="/STATIC/js/jquery.alerts.js"></script>
    <script type="text/javascript" src="/STATIC/js/location.js"></script>
    <script type="text/javascript" src="/STATIC/js/page.min.js"></script>
    <script type="text/javascript" src="/STATIC/js/jquery.uploadify-3.1.min.js"></script>
    <script type="text/javascript" src="/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript" src="/STATIC/js/birthday.js"></script>
    <script type="text/javascript" src="/STATIC/js/clipboard.min.js"></script>

    <link rel="Stylesheet" type="text/css" href="/STATIC/css/DialogBySHF.css" />
    <script type="text/javascript" src="/STATIC/js/DialogBySHF.js"></script>

    <script src="/STATIC/js/avalon.js"></script>
    <script src="/STATIC/js/angular.js"></script>


    <script type="text/javascript" src="/STATIC/js/ckeditor/ckeditor.js"></script>
    <script type="text/javascript" src="/STATIC/js/ckeditor/sample.js"></script>
    <!--富文本编辑器 end-->

    <script type="text/javascript" src="/STATIC/js/jquery.uploadify-3.1.min.js"></script>
    <script type="text/javascript" src="/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">

        function getImgHtml(imgUrl)
        {
            if(imgUrl==""){
                return '<img src="../STATIC/image/defaultImg.png" />';
            }
            return '<img style="width:300px; height:200px;"  src="'+imgUrl+'" />';
        }

        $(function(){


            $("#imgHeadPrev_retina").html(getImgHtml(""));
            $("#imgHeadPrev_retina").html(getImgHtml(""));
            var recordId = '${OpenImage.imageid}';
            if(recordId!="")
            {

                var imgUrl_retina = '${OpenImage.imageurl_retina}';
                var imgUrl_normal = '${OpenImage.imageurl_normal}';
                if(imgUrl_retina!="")
                {
                    $("#imgHeadPrev_retina").html(getImgHtml(getImgUrl(imgUrl_retina)));
                }
                if(imgUrl_normal!="")
                {
                    $("#imgHeadPrev_normal").html(getImgHtml(getImgUrl(imgUrl_normal)));
                }
            }

        });
    </script>

    <script type="text/javascript">


        window.console = window.console || {log:function () {}}
        //seajs.use(['jquery'], function ($) {
        $(function () {
            var advertId = '';
            var tips = "";
            if(advertId!="" && typeof(advertId)!="undefined"){
                tips = "修改成功!";
            }else{
                tips = "保存成功!"
            }


        });
        //});
    </script>

    <script type="text/javascript">


        seajs.config({
            alias: {
                "jquery": "jquery-1.10.2.js"
            }
        });

        seajs.use(['/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        $(document).ready(function() {

            $("#file_retina").uploadify({
                'formData':{
                    'uploadType':$("#uploadType_retina").val(),
                    'type':1,
                    'userCounty':$("#userCounty").val()
                },//传静态参数
                swf:'/STATIC/js/uploadify.swf',
                uploader:'../upload/uploadFile.do;jsessionid=2914CB803EA946A0D0F9BFAE15250B72-n2',//后台处理的请求
                buttonText:'上传图片',//上传按钮的文字
                'buttonClass':"upload-btn",//按钮的样式
                queueSizeLimit:1, //   default 999
                'method': 'post',//和后台交互的方式：post/get
                queueID:'fileContainer',
                fileObjName:'file', //后台接受参数名称
                fileTypeExts:'*.gif;*.png;*.jpg;*.jpeg;', //控制可上传文件的扩展名，启用本项时需同时声明fileDesc
                'auto':true, //true当选择文件后就直接上传了，为false需要点击上传按钮才上传
                'multi':false, //是否支持多个附近同时上传
                height:44,//选择文件按钮的高度
                width:100,//选择文件按钮的宽度
                'debug':false,//debug模式开/关，打开后会显示debug时的信息
                'dataType':'json',
                removeCompleted:false,//上传成功后的文件，是否在队列中自动删除
                onUploadSuccess:function (file, data, response) {
                    var json = $.parseJSON(data);
                    var url=json.data;
                    var hiddenImgUrl = url;
                    //隐藏该区域
                    $(".uploadify-queue-item").hide();
                    var initWidth = parseInt(json.initWidth);
                    var initHeigth = parseInt(json.initHeigth);
                    var displayPosition = $("#displayPosition").val();
                    var linkType = $("#linkType").val();
                    if(initWidth  != 1242 || initHeigth != 2208)
                    {
                        dialogAlert("提示", "请上传尺寸不小于1242*2208(px)的图片", function () {
                        });

                        return;
                    }

                    var imgurl = getImgUrl(url);
                    $("#headImgUrl_retina").val(url);
                    $("#imgHeadPrev_retina").html(getImgHtml(imgurl));

                    return true;
                },
                onSelect:function () {
                },
                onCancel:function () {
                    $("#headImgUrl_retina").val("");
                    $('#file_retina').uploadify('cancel', '*');
                }
            });



            $("#file_normal").uploadify({
                'formData':{
                    'uploadType':$("#uploadType_normal").val(),
                    'type':1,
                    'userCounty':$("#userCounty").val()
                },//传静态参数
                swf:'/STATIC/js/uploadify.swf',
                uploader:'../upload/uploadFile.do;jsessionid=2914CB803EA946A0D0F9BFAE15250B72-n2',//后台处理的请求
                buttonText:'上传图片',//上传按钮的文字
                'buttonClass':"upload-btn",//按钮的样式
                queueSizeLimit:1, //   default 999
                'method': 'post',//和后台交互的方式：post/get
                queueID:'fileContainer',
                fileObjName:'file', //后台接受参数名称
                fileTypeExts:'*.gif;*.png;*.jpg;*.jpeg;', //控制可上传文件的扩展名，启用本项时需同时声明fileDesc
                'auto':true, //true当选择文件后就直接上传了，为false需要点击上传按钮才上传
                'multi':false, //是否支持多个附近同时上传
                height:44,//选择文件按钮的高度
                width:100,//选择文件按钮的宽度
                'debug':false,//debug模式开/关，打开后会显示debug时的信息
                'dataType':'json',
                removeCompleted:false,//上传成功后的文件，是否在队列中自动删除
                onUploadSuccess:function (file, data, response) {
                    var json = $.parseJSON(data);
                    var url=json.data;
                    var hiddenImgUrl = url;
                    //隐藏该区域
                    $(".uploadify-queue-item").hide();
                    var initWidth = parseInt(json.initWidth);
                    var initHeigth = parseInt(json.initHeigth);
                    var displayPosition = $("#displayPosition").val();
                    var linkType = $("#linkType").val();
                    if(initWidth  != 640 || initHeigth != 960)
                    {
                        dialogAlert("提示", "请上传尺寸640*960(px)的图片", function () {});

                        return;
                    }


                    var imgurl = getImgUrl(url);
                    $("#headImgUrl_normal").val(url);
                    $("#imgHeadPrev_normal").html(getImgHtml(imgurl));

                    return true;
                },
                onSelect:function () {
                },
                onCancel:function () {
                    $("#headImgUrl_normal").val("");
                    $('#file_normal').uploadify('cancel', '*');
                }
            });

        });
    </script>
</head>
<body>

<form id="ImageWithStart" method="post">
    <input type="hidden" id="userCounty" value="${param.city}"/>
    <input type="hidden" name="imageid" id="imageid"  value="${param.imageid}"/>
    <input type="hidden" name="city" id="city"  value="${param.city}"/>


    <div class="main-publish">
        <table width="100%" class="form-table">


            <tr>
                <td width="80" class="td-title"><span class="red">*</span>高清图片：</td>
                <td class="td-upload td-coordinate">
                    <input type="hidden"  name="headImgUrl_retina" id="headImgUrl_retina" value="${OpenImage.imageurl_retina}"  />
                    <input type="hidden" name="uploadType_retina" value="Img" id="uploadType_retina" />

                    <div class="img-box">
                        <div  id="imgHeadPrev_retina"  class="img">

                        </div>
                    </div>
                    <div class="controls-box">
                        <div style="height: 46px;">
                            <div class="controls" style="float:left;">
                                <input type="file" name="file_retina" id="file_retina" />
                                图片尺寸:<font color="red">1242*2208</font>
                            </div>


                        </div>
                    </div>
                </td>
            </tr>

            <tr>
                <td width="80" class="td-title"><span class="red">*</span>普通图片：</td>
                <td class="td-upload td-coordinate">
                    <input type="hidden"  name="headImgUrl_normal" id="headImgUrl_normal" value="${OpenImage.imageurl_normal}"  />
                    <input type="hidden" name="uploadType_normal" value="Img" id="uploadType_normal" />

                    <div class="img-box">
                        <div  id="imgHeadPrev_normal"  class="img">

                        </div>
                    </div>
                    <div class="controls-box">
                        <div style="height: 46px;">
                            <div class="controls" style="float:left;">
                                <input type="file" name="file_normal" id="file_normal" />
                                图片尺寸:<font color="red">640*960</font>
                            </div>


                        </div>
                    </div>
                </td>
            </tr>

            <tr>
                <td  class="td-title">开始时间：</td>
                <td class="td-input">

                    <input type="text" id="startDate" name="startDate" value="${OpenImage.startDate}" class="input-text w220" maxlength="50" onClick="WdatePicker()"/>


                </td>
            </tr>

            <tr>
                <td  class="td-title">结束时间：</td>
                <td class="td-input">
                    <input type="text" id="endDate" name="endDate" value="${OpenImage.endDate}" class="input-text w220" maxlength="50" onClick="WdatePicker()"/>
                </td>
            </tr>


            <tr>
                <td  class="td-title">默认图片：</td>
                <td class="td-input">
                    <input type="checkbox" id="isDefaultImage" name="isDefaultImage" <c:if test="${OpenImage.isDefaultImage == 1}">checked</c:if>/>
                </td>
            </tr>

            <tr class="td-btn">

                <td></td>
                <td>
                    <input type="button" value="保存" class="btn-save" />
                    <input type="button" value="关闭" class="btn-publish btn-cancel" />
                </td>
            </tr>
        </table>
    </div>
</form>
</body>
<script language="JavaScript">



    $(".btn-save").click(function(){


        var havestartdate = $("#startDate").val().length > 0;
        var haveenddate = $("#endDate").val().length > 0;
        if((havestartdate ^ haveenddate))
        {
            dialogAlert("提示", "请输入完整开始结束日期", function () {});
            return;
        }


        var p1 =  $("#headImgUrl_normal").val();
        var p2 =  $("#headImgUrl_retina").val();
        if(p1 == '' || p2 == '')
        {
            dialogAlert("提示", "请上传图片", function () {});
            return;
        }
        $.post("/app/updateImage.do", $("#ImageWithStart").serialize(),
                function(data) {


                    if(data > 0)
                    {

                        parent.window.location.href = parent.window.location.href;
                        $("body", parent.document).find('#DialogBySHFLayer,#DialogBySHF').remove();

                    }
                    else
                    {
                        dialogAlert("提示", "更新失败", function () {});

                    }

                }
        );


    });


    $(".btn-cancel").click(function () {

        parent.window.location.href = parent.window.location.href;
        $("body", parent.document).find('#DialogBySHFLayer,#DialogBySHF').remove();

    });
</script>

</html>
