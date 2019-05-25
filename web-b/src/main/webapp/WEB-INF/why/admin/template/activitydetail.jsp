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

        function getImgHtml(imgUrl){
            if(imgUrl==""){
                return '<img src="../STATIC/image/defaultImg.png" />';
            }
            return '<img style="width:300px; height:200px;"  src="'+imgUrl+'" />';
        }

        $(function(){



            var recordId = '${Activity.id}';
            if(recordId!=""){

                var imgUrl = '${Activity.image}';
                if(imgUrl!=""){
                    //$("#imgHeadPrev").attr("src",getImgUrl(imgUrl));
                    //imgUrl = getIndexImgUrl(imgUrl,"_300_300")
                    $("#imgHeadPrev").html(getImgHtml(getImgUrl(imgUrl)));
                }else{
                    $("#imgHeadPrev").html(getImgHtml(""));
                }
            }else{
                $("#imgHeadPrev").html(getImgHtml(""));
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
            var Img=$("#uploadType").val();
            $("#file").uploadify({
                'formData':{
                    'uploadType':Img,
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
                    if(initWidth<290 || initHeigth<175)
                    {
                        dialogAlert("提示", "请上传尺寸不小于290*175(px)的图片", function () {
                        });
                        $("#isCutImg").val("N");
                        return;
                    }

                    if(displayPosition ==''){
                        dialogAlert("提示","请选择位置以确定需要裁切图片的尺寸",function(){
                        });
                        return;
                    }
                    var cutImageWidth ;
                    var cutImageHeigth;
                    if(linkType == "APP"){
                        if(displayPosition==1){
                            cutImageWidth = 750;
                            cutImageHeigth =400;
                        }else{
                            cutImageWidth = 750;
                            cutImageHeigth =150;
                        }
                    }else{
                        if(displayPosition==1){
                            cutImageWidth = 750;
                            cutImageHeigth =400;
                        }else{
                            cutImageWidth = 1200;
                            cutImageHeigth =530;
                        }
                    }

                    var imgurl = getImgUrl(url);
                    $("#headImgUrl").val(url);
                    $("#imgHeadPrev").html(getImgHtml(imgurl));

                    return true;
                },
                onSelect:function () {
                },
                onCancel:function () {
                    $("#headImgUrl").val("");
                    $('#file').uploadify('cancel', '*');
                }
            });

        });
    </script>
</head>
<body>
<input type="hidden" id="userCounty" value="45,上海市"/>
<form id="topicactivity" method="post">
    <input type="hidden" name="topicid" id="topidic"  value="${param.topicid}"/>
    <input type="hidden" name="aid" id="aid"  value="${param.aid}"/>


    <div class="main-publish">
        <table width="100%" class="form-table">

            <tr>
                <td  class="td-title"><span class="red">*</span>顶部标签：</td>
                <td class="td-input">
                    <input type="text" id="hname" name="hname" value="${Activity.hname}" class="input-text w220" maxlength="10"/>
                </td>
            </tr>




            <tr>
                <td width="80" class="td-title"><span class="red">*</span>活动图片：</td>
                <td class="td-upload td-coordinate">
                    <input type="hidden"  name="headImgUrl" id="headImgUrl" value="${Activity.image}"  />
                    <input type="hidden" name="uploadType" value="Img" id="uploadType" />

                    <div class="img-box">
                        <div  id="imgHeadPrev"  class="img">

                        </div>
                    </div>
                    <div class="controls-box">
                        <div style="height: 46px;">
                            <div class="controls" style="float:left;">
                                <input type="file" name="file" id="file" />
                                图片尺寸:<font color="red">290*175</font>
                            </div>


                        </div>
                    </div>
                </td>
            </tr>


            <tr>
                <td  class="td-title"><span class="red">*</span>活动标题：</td>
                <td class="td-input">
                    <input type="text" id="title" name="title"  value="${Activity.title}" class="input-text w220" maxlength="50"/>
                </td>
            </tr>

            <tr>
                <td  class="td-title"><span class="red">*</span>活动地点：</td>
                <td class="td-input">
                    <input type="text" id="addr" name="addr" value="${Activity.addr}" class="input-text w220" maxlength="50"/>
                </td>
            </tr>

            <tr>
                <td  class="td-title"><span class="red">*</span>活动时间：</td>
                <td class="td-input">
                    <input type="text" id="duration" name="duration" value="${Activity.duration}" class="input-text w220" maxlength="150"/>
                </td>
            </tr>

            <tr>
                <td  class="td-title">活动id：</td>
                <td class="td-input">
                    <input type="text" id="activityid" name="activityid" value="${Activity.activityid}" class="input-text w220" maxlength="50"/>
                </td>
            </tr>

            <tr>
                <td  class="td-title">链接文字：</td>
                <td class="td-input">
                    <input type="text" id="linktitle" name="linktitle" value="${Activity.linktitle}" class="input-text w220" maxlength="50"/>
                    <input type="checkbox" id="linkisblue" name="linkisblue" <c:if test="${Activity.linkisblue == 1}">checked</c:if>/>蓝色背景
                </td>
            </tr>

            <tr class="td-btn">

                <td></td>
                <td>
                    <input type="button" value="保存" class="btn-save" />
                    <input type="button" value="关闭" class="btn-publish btn-cancel" />
                    <c:if test="${param.aid !=null and param.aid != '' }">
                        <input type="button" value="删除" class="btn-publish btn-del" />
                    </c:if>
                </td>
            </tr>
        </table>
    </div>
</form>
</body>
<script language="JavaScript">

    $(".btn-del").click(function () {

        var aid  = $("#aid").val();
        $.post("/template/delActivityContent.do", "aid="+aid,
                function (data) {

                    if(data == '1')
                    {
                        parent.window.location .href = parent.window.location .href;
                        $("body", parent.document).find('#DialogBySHFLayer,#DialogBySHF').remove();
                    }
                    else
                    {
                        dialogAlert("提示", "删除失败", function () {});

                    }
                }
        );

    });

    $(".btn-save").click(function(){

        //alert($("#topicactivity").serialize());
        var hname = $("#hname").val();
        if(hname == '')
        {
            dialogAlert("提示", "请输入顶部标签", function () {});
            return;
        }
        var title = $("#title").val();
        if(title == '')
        {
            dialogAlert("提示", "请输入标题", function () {});
            return;
        }
        var aord = (${param.actnum} + 1) * 1000000;
        $.post("/template/updateTopicActivity.do", "aord="+aord+"&"+$("#topicactivity").serialize(),
                function(data) {


                    if(data > 0)
                    {
                        $("#aid").val(data);
                        dialogAlert("提示", "更新成功", function () {});
                        window.parent.updateActivityContent(title,data);
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

        $("body", parent.document).find('#DialogBySHFLayer,#DialogBySHF').remove();

    });
</script>

</html>
