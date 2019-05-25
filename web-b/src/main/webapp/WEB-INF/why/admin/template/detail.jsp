<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
    <link rel="stylesheet" type="text/css" href="/STATIC/css/normalize.css">
    <link rel="stylesheet" type="text/css" href="/STATIC/css/style-series.css">
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
    <script type="text/javascript" src="/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">

        function getImgHtml(imgUrl){
            if(imgUrl=="")
            {
                return '<img src="../STATIC/image/defaultImg.png" />';
            }
            return '<img style="width:300px; height:200px;"  src="'+imgUrl+'" />';
        }

        $(function(){





            var recordId = '${ActivityTopic.id}';
            if(recordId!="")
            {

                var shareImgUrl =  '${ActivityTopic.shareimg}';
                if(shareImgUrl!="")
                {

                    //shareImgUrl = getIndexImgUrl(shareImgUrl,"_300_300")
                    $("#shareimgHeadPrev").html(getImgHtml(getImgUrl(shareImgUrl)));
                }else
                {
                    $("#shareimgHeadPrev").html(getImgHtml(""));
                }

                var imgUrl = '${ActivityTopic.headimg}';
                if(imgUrl!="")
                {
                    //$("#imgHeadPrev").attr("src",getImgUrl(imgUrl));
                    //imgUrl = getIndexImgUrl(imgUrl,"_300_300")
                    $("#imgHeadPrev").html(getImgHtml(getImgUrl(imgUrl)));
                }else
                {
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


            $(".btn-cancel").on("click", function(){
                dialog.close().remove();
            });
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
                    if(initWidth<750 || initHeigth<200)
                    {
                        dialogAlert("提示", "请上传尺寸不小于750*200(px)的图片", function () {
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

                    var imgUrl = getImgUrl(url);
                    $("#imgHeadPrev").html(getImgHtml(imgUrl));
                    $("#headimg").val(url);
                    return false;
                },
                onSelect:function () {
                },
                onCancel:function () {
                    $("#headimg").val("");
                    $('#file').uploadify('cancel', '*');
                }
            });



            $("#sharefile").uploadify({
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
                    if(initWidth<300 || initHeigth<300)
                    {
                        dialogAlert("提示", "请上传尺寸不小于300*300(px)的图片", function () {
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

                    var imgUrl = getImgUrl(url);
                    $("#shareimgHeadPrev").html(getImgHtml(imgUrl));
                    $("#shareheadimg").val(url);
                    return false;
                },
                onSelect:function () {
                },
                onCancel:function () {
                    $("#shareheadimg").val("");
                    $('#sharefile').uploadify('cancel', '*');
                }
            });


        });
    </script>
</head>
<body>
<input type="hidden" id="userCounty" value="45,上海市"/>
<form id="topicdetail" method="post">
    <input type="hidden"  name="topicid" id="topicid" value="${ActivityTopic.id}" />




    <div class="site">
        <em>您现在所在的位置：</em>运维管理 &gt; 活动专题 &gt;添加修改专题
    </div>



    <div class="site-title">添加专题</div>
    <div class="main-publish">
        <table width="100%" class="form-table">



            <tr>
                <td  class="td-title"><span class="red">*</span>专题标题：</td>
                <td class="td-input">
                    <input type="text" id="topictitle" name="topictitle"  value="${ActivityTopic.title}" class="input-text w220" maxlength="50"/>
                </td>
            </tr>



            <tr>
                <td width="100" class="td-title"><span class="red">*</span>头部图片：</td>
                <td class="td-upload td-coordinate">
                    <input type="hidden"  name="headimg" id="headimg" value="${ActivityTopic.headimg}"  />
                    <input type="hidden" name="uploadType" value="Img" id="uploadType" />

                    <div class="img-box">
                        <div  id="imgHeadPrev"  class="img">

                        </div>
                    </div>
                    <div class="controls-box">
                        <div style="height: 46px;">
                            <div class="controls" style="float:left;">
                                <span><input type="file" name="file" id="file" /></span><span>图片尺寸:<font color="red">750*250</font></span>
                            </div>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>分享图片：</td>
                <td class="td-upload td-coordinate">

                    <input type="hidden"  name="shareheadimg" id="shareheadimg" value="${ActivityTopic.shareimg}"  />

                    <div class="img-box">
                        <div  id="shareimgHeadPrev"  class="img">

                        </div>
                    </div>
                    <div class="controls-box">
                        <div style="height: 46px;">
                            <div class="controls" style="float:left;">
                                <input type="file" name="sharefile" id="sharefile" />图片尺寸:<font color="red">300*300</font>
                            </div>

                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td  class="td-title"><span class="red">*</span>分享标题：</td>
                <td class="td-input">
                    <input type="text" id="sharetitle" name="sharetitle"  value="${ActivityTopic.sharetitle}" class="input-text w220" maxlength="50"/>
                </td>
            </tr>
            <tr>
                <td  class="td-title"><span class="red">*</span>分享内容：</td>
                <td class="td-input">
                    <textarea   name="sharedesc" rows="4" class="textareaBox ng-pristine ng-valid ng-empty ng-valid-maxlength ng-touched" maxlength="300" style="width: 500px;resize: none">${ActivityTopic.sharedesc}</textarea>
                </td>
            </tr>
            <tr>
                <td  class="td-title"><span class="red">*</span>活动配置：</td>
                <td class="td-input" >
                    <div class="activityContent"  >
                        <c:forEach items="${ActivityList}" var="Activity" varStatus="status">
                            <input type="button" class="button-div1"  value="[${Activity.hname}]${Activity.title}" style="height: 30px; margin-bottom: 10px" onclick="gotodetail(${Activity.id})" activityid="${Activity.id}">
                            <c:if test="${status.index > 0}">
                                <input type="button"    style="float:left;height: 30px; margin-bottom: 10px;margin-left: 5px;" value="上升" onclick="upActivityOrder(${Activity.id},${ActivityList[status.index - 1].aord},'up')"/>
                            </c:if>
                            <c:if test="${status.index < (fn:length(ActivityList) - 1)}">
                                <input type="button"    style="float:left;height: 30px; margin-bottom: 10px;margin-left: 5px;" value="下降" onclick="upActivityOrder(${Activity.id},${ActivityList[status.index + 1].aord},'down')"/>
                            </c:if>

                            <br/>
                        </c:forEach>
                    </div>
                    <div style="clear: both"></div>

                    <div style="margin-top: 10px">
                        <input type="button" value="新增活动 " class="addActivity" style="height: 30px;">
                    </div>
                </td>
            </tr>

            <tr>
                <td  class="td-title"><span class="red">*</span>板块配置：</td>
                <td class="td-input" >
                    <div class="blockContent"  >
                        <c:forEach items="${BlockList}" var="Block" varStatus="status">
                            <input type="button" class="button-div1"  value="${Block.bname}" style="height: 30px; margin-bottom: 10px" onclick="gotoBlockDetail(${Block.id})" blockid="${Block.id}">
                            <c:if test="${status.index > 0}">
                                <input type="button"    style="float:left;height: 30px; margin-bottom: 10px;margin-left: 5px;" value="上升" onclick="upblockorder(${Block.id},${BlockList[status.index - 1].aord},'up')"/>
                            </c:if>
                            <c:if test="${status.index < (fn:length(BlockList) - 1)}">
                                <input type="button"    style="float:left;height: 30px; margin-bottom: 10px;margin-left: 5px;" value="下降" onclick="upblockorder(${Block.id},${BlockList[status.index + 1].aord},'down')"/>
                            </c:if>
                            <br/>
                        </c:forEach>
                    </div>
                    <div style="margin-top: 10px">
                        <input type="button" value="新增板块" class="addBlock" style="height: 30px;">
                    </div>
                </td>
            </td>


            <tr class="td-btn">
                <td></td>
                <td>
                    <input type="button" value="保存" class="btn-save" />
                    <input type="button" value="预览" class="btn-publish btn-preview" />
                    <input type="button" value="返回" class="btn-publish btn-cancel" onclick="javascript:history.back(-1)" />
                    <%--<input type="button" value="删除" class="btn-publish btn-del" />--%>
                </td>
            </tr>
        </table>
    </div>
</form>
</body>
<script language="JavaScript">




    function  upActivityOrder(id,aord,type)
    {
        var o = aord;
        if(type == "up")
        {
            o -= 1;
        }
        else {
            o += 1;
        }

        $.post("/template/updateActivityOrder.do", "aid="+id+"&aord="+o,
                function(data) {



                    if(data ==  1)
                    {

                        window.location.reload();


                    }
                    else
                    {
                        dialogAlert("提示", "更新失败", function () {});
                    }

                }
        );
    }


    function upblockorder(id,aord,type)
    {
        var o = aord;
        if(type == "up")
        {
            o -= 1;
        }
        else {
            o += 1;
        }

        $.post("/template/updateBlockOrder.do", "bid="+id+"&aord="+o,
                function(data) {



                    if(data ==  1)
                    {

                       window.location.reload();


                    }
                    else
                    {
                        dialogAlert("提示", "更新失败", function () {});
                    }

                }
        );
    }



    $(".btn-preview").click(function () {

        window.open("/template/activityTopicDetail.do?topicid="+$("#topicid").val());

    });


    $(".btn-del").click(function () {


        $.post("/template/delTopic.do", "topicid="+$("#topicid").val(),
                function(data) {



                    if(data ==  1)
                    {

                        parent.window.frames["main"].location.reload();
                        //history.back();
                        //alert();
                        //parent.window.frames["main"].location.reload();
                        //window.close();


                    }
                    else
                    {
                        dialogAlert("提示", "删除失败", function () {});
                    }

                }
        );

    });

    $(".addActivity").click(function()
    {
        var topicid = $("#topicid").val();
        if(topicid == 0)
        {
            dialogAlert("提示", "请先保存,然后添加活动", function () {});
            return;
        }
        $.DialogBySHF.Dialog({ Width: 1024, Height: 768, Title: "添加活动", URL: '/template/activitydetail.do?actnum=${fn:length(ActivityList)}&topicid='+topicid });
    });

    $(".addBlock").click(function()
    {
        var topicid = $("#topicid").val();
        if(topicid == 0)
        {
            dialogAlert("提示", "请先保存,然后添加板块", function () {});
            return;
        }
        $.DialogBySHF.Dialog({ Width: 1024, Height: 768, Title: "添加板块", URL: '/template/blockdetail.do?blocknum=${fn:length(BlockList)}&topicid='+topicid });
    });




    $(".btn-save").click(function(){

        var topicid = $("#topicid").val();
        var topictitle = $("#topictitle").val();
        var headimg =$("#headimg").val();
        var sharetitle = $("#sharetitle").val();
        var sharedesc = $("#sharedesc").val();
        var shareimg =$("#shareheadimg").val();
        if(topictitle == '')
        {
            dialogAlert("提示", "请输入标题", function () {});
            return;
        }
        if(headimg == '')
        {
            dialogAlert("提示", "请上传头部图片", function () {});
            return;
        }
        if(sharetitle == '')
        {
            dialogAlert("提示", "请输入分享标题", function () {});
            return;
        }
        if(sharedesc == '')
        {
            dialogAlert("提示", "请输入分享内容", function () {});
            return;
        }
        if(shareimg == '')
        {
            dialogAlert("提示", "请上传分享图片", function () {});
            return;
        }


        $.post("/template/updateTopic.do", $("#topicdetail").serialize(),
                        function(data) {

                            if(data > 0)
                            {
                                $("#topicid").val(data);
                                dialogAlert("提示", "更新成功", function () {});
                            }
                            else
                            {
                                dialogAlert("提示", "更新失败", function () {});
                            }

                        }
        );
    });

    function updateActivityContent(title,id)
    {

        window.location.href = window.location.href;
//        var haveActivity = false;
//        $(".activityContent").children().each(function () {
//
//            var aid = $(this).attr("activityid");
//            if(aid == id)
//            {
//                $(this).val(title);
//                haveActivity = true;
//            }
//        });
//
//        if(haveActivity == false)
//        {
//
//            var c = "<input type=\"button\" class=\"button-div1\"  value=\"" + title + "\" style=\"height: 30px; margin-bottom: 10px\"  onclick=\"gotodetail("+id+")\" activityid=\""+id+"\" ><br/>";
//            $(".activityContent").append(c);
//        }
    }

    function gotodetail(id)
    {

        var topicid = $("#topicid").val();
        $.DialogBySHF.Dialog({ Width: 1024, Height: 768, Title: "添加活动", URL: "/template/activitydetail.do?aid="+id+"&topicid="+topicid });
    }

    function gotoBlockDetail(id)
    {

        var topicid = $("#topicid").val();
        $.DialogBySHF.Dialog({ Width: 1024, Height: 768, Title: "添加活动", URL: "/template/blockdetail.do?topicid="+topicid+"&bid="+id});
    }




</script>
</html>
