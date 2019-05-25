<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

    <link rel="stylesheet" type="text/css" href="/STATIC/aliImage/style.css"/>
    <script type="text/javascript" src="/STATIC/aliImage/uuid.js"></script>
    <script type="text/javascript" src="/STATIC/aliImage/crypto.js"></script>
    <script type="text/javascript" src="/STATIC/aliImage/hmac.js"></script>
    <script type="text/javascript" src="/STATIC/aliImage/sha1.js"></script>
    <script type="text/javascript" src="/STATIC/aliImage/base64.js"></script>
    <script type="text/javascript" src="/STATIC/aliImage/plupload.full.min.js"></script>
    <script type="text/javascript" src="/STATIC/aliImage/upload-img.js"></script>
    <script type="text/javascript" src="/STATIC/aliImage/upload-files.js"></script>

    <script src="/STATIC/js/avalon.js"></script>

    <script type="text/javascript" src="/STATIC/js/jquery.uploadify-3.1.min.js"></script>
    <script type="text/javascript" src="/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">

        function getImgHtml(imgUrl){
            if(imgUrl==""){
                return '<img src="../STATIC/image/defaultImg.png" />';
            }
            return '<img style="width:300px; height:200px;"  src="${IMGURL}'+imgUrl+'" />';
        }


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

            if('${param.bid}' !='' && '${param.bid}' > '0')
            {
                $(".chooseTemplate").hide();
                $(".main-publish").show();
            }
            else
            {
                $(".chooseTemplate").show();
                $(".main-publish").hide();
            }
            initUploadifyFunction();

        });
    </script>
</head>
<body>
<input type="hidden" id="userCounty" value="45,上海市"/>
<form id="blockdetail" method="post">
    <input type="hidden" name="id" id="id"  value="${param.id}"/>
    <input type="hidden" name="topicid" id="topicid"  value="${param.topicid}"/>
    <input type="hidden" name="bid" id="bid"  value="${param.bid}"/>
    <input type="hidden"  name="headimg" id="headimg" value=""  />
    <input type="hidden" name="uploadType" value="Img" id="uploadType" />
    <input type="hidden" name="bcid" value="" id="bcid" />
    <div class="chooseTemplate" style="display:none">
        <div style="line-height: 30px;font-size: large">选择模版</div>
        <div style="margin: 10px;">
                <ul>
                    <c:forEach items="${TemplateList}" var="Template">
                    <li style="float: left;margin:20px">
                        <div style="position: relative;width: 325px;height: 200px;">
                            <img class="hkPlayBtn" src="/STATIC/image/${Template.image}" style="position: absolute;left: 0;right: 0;bottom: 0;top: 0;margin: auto;z-index: 10;width: 325px;height: 200px;" onclick="document.getElementById('video1').play()" />
                        </div>
                        <div class="lccwz"><input type="radio" name="templateRadio" value="${Template.id}"/></div>
                    </li>
                    </c:forEach>
                </ul>
        </div>
        <div style="clear:both;"></div>
        <div style="margin: 30px;height: 30px;" >
           板块名称: <input type="text" id="blockname" name="blockname" value="" class="input-text w220" style="line-height:30px;" maxlength="150" />
            <input type="button" value="确定" class="confirmTemplate" style="height: 30px;width: 60px;"/>
            <input type="button" value="关闭" class="btn-publish btn-cancel" />

        </div>
    </div>
    <div class="main-publish" style="display:none">
        <table width="100%" class="form-table">

            <tr>
                <td  class="td-title" style="width: 12%;"><span class="red">*</span>板块名称：</td>
                <td class="td-input">
                    <input type="text" id="bname" name="bname" value="${Block.bname}" class="input-text w220" maxlength="150" />
                </td>
            </tr>


            <tr>
                <td  class="td-title" style="width: 12%;"><span class="red">*</span>板块内容：</td>
                <td class="td-input" >
                    <div class="blockContentShow" >

                    </div>
                    <div style="clear: both"></div>

                    <div style="margin-top: 10px" class="inputBlockContent">


                    </div>

                </td>
            </tr>


            <tr class="td-btn">
                <td></td>
                <td>
                    <input type="button" value="保存" class="btn-save" />
                    <input type="button" value="重置" class="btn-publish btn-reset" />
                    <input type="button" value="关闭&保存标题" class="btn-publish btn-cancel" />
                    <input type="button" value="删除" class="btn-publish btn-del" />


                </td>
            </tr>
        </table>
    </div>
</form>
</body>




<script language="JavaScript">

    var strSplit = "|!!|";//参数和参数url的分隔符号
    var fieldSplit = "＄";//全角$作为分隔符
    var templateList = new Array();
    <c:forEach items="${TemplateList}" var="Template" varStatus="status">
    templateList[${status.index}] = new Array('${Template.id}','${Template.container}','${Template.content}','${Template.fields}','${Template.fieldnum}','${Template.image}');
    </c:forEach>
    var currentTemplate;

    function uploadVideoCallback(up, file, info)
    {
        var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
        $("#uploadVideoFile").prev().val(filePath);
        $("#ossfile2").html('')
    }




    $(".btn-reset").click(function () {
        $(".inputBlockContent").children().each(function (index) {

            var cls =  $(this).attr("class");
            var name =  $(this).attr("name");
            if (cls == 'updateloadImg')
            {
                $("#headimg").val();
                $(".updateloadImg").attr("src","");
            }
            else if(name == 'param')
            {
                $(this).val("");
            }
            else if(name == 'param_url')
            {
                $(this).val("");

            }

        });
        $("#bcid").val("");
    });

    $(".btn-save").click(function(){

        var fieldsNum = parseInt(currentTemplate[4])
        var param = new Array(fieldsNum);
        var param_url = new Array(fieldsNum);
        var parmvalue = ""
        var parmurlvalue = ""
        var idx = -1;
        $(".inputBlockContent").children().each(function () {

            var cls =  $(this).attr("class");
            var name =  $(this).attr("name");
            var val = $(this).val();
            if (cls == 'uploadify')
            {
                val = $("#headimg").val();
            }
            val = val.replace('＄','$')//内容中的全角$替换成半角$
            val = val.replace('&','~~');
            if(name == 'param' || cls == 'uploadify')
            {//parm,parmurl,parm,parm,parm,parmurl

                param[++idx] = val;
                //param += val+" "+fieldSplit;
            }
            else if(name == 'param_url')
            {
                param_url[idx] = val;
                //param_url += val+" "+fieldSplit;
            }

        });

        for(var i = 0;i < fieldsNum;i++)
        {
            if (typeof param[i] == 'undefined')
            {
                param[i] = '';
            }
            if (typeof param_url[i] == 'undefined')
            {
                param_url[i] = '';
            }
            parmvalue += param[i];
            parmurlvalue += param_url[i];
            if(i < (fieldsNum - 1))
            {
                parmvalue += " "+fieldSplit + " ";
                parmurlvalue  += " "+fieldSplit + " ";
            }
        }

        var topicid = $("#topicid").val();
        var bid = $("#bid").val()
        var bcid = $("#bcid").val();
        //split会忽视Null数据，需要加上空格带入
        var paramlist = "bcid="+bcid+"&bid="+bid+"&topicid="+topicid+"&attr="+parmvalue + strSplit +" "+ parmurlvalue+"&tag="+Math.random();
        $.post("/template/updateBlockContent.do", paramlist,
                function(data) {


                    if(data > 0)
                    {
                        //initBlockContent(param,param_url,currentTemplate[3],data);
                        window.location.href = "/template/blockdetail.do?topicid="+topicid+"&bid="+bid;
                        dialogAlert("提示", "更新成功", function () {});
                        $("#bcid").val("");


                    }
                    else
                    {
                        dialogAlert("提示", "更新失败", function () {});

                    }

                }
        );


    });

    function initBlockContent(param,param_url,fieldlist,id)
    {
        var pm = param.split(fieldSplit);
        if(param_url == null || typeof param_url =='undefined')
            param_url = '';
        var pmu = param_url.split(fieldSplit);
        var idvalue = "blockcontent_"+id;
        var fields =  fieldlist.split(";");
        var c = "";
        var div = $("<div id='"+idvalue+"'></div>").appendTo($(".blockContentShow"));
        for(var i = 0;i<fields.length;i++)
        {
            div.append('<p>{"'+fields[i]+'":"'+pm[i]+'";"链接":"'+pmu[i]+'"}</p>');
        }

        div.append('<input type="button" style="height:30px;width:60px;margin-bottom: 10px;" onclick="delBlockContent('+id+')"  value="删 除"/>');
        div.append('<input type="button" style="height:30px;width:60px;margin-bottom: 10px;" onclick="editBlockContent('+id+')"  value="编 辑"/>');
        div.append("<p style='width:100%;height:1px;background: black'> <hr/></p>");
    }



//    $(".addBlockContent").click(function(){
//
//
//
//    });

    <c:if test="${Block != null}">
    var templateid = ${Block.templateid};
    initCurrentTemplate(templateid);
    </c:if>

    var bcAry = new Array();
    var p;
    <c:forEach var="BlockContent" items="${BlockContentList}" varStatus="status">
    bcAry[${status.index}] = new Array('${BlockContent.id}','${BlockContent.attr}');
    p = '${BlockContent.attr}'.split(strSplit);
    initBlockContent(p[0],p[1],currentTemplate[3],${BlockContent.id});

    </c:forEach>


    function editBlockContent(id)
    {


        var attr = "";
        for(var i=0;i<bcAry.length;i++)
        {

            if(bcAry[i][0] == id)
            {
                attr = bcAry[i][1];
                break;
            }
        }
        var cc = attr.split(strSplit);
        var pm = cc[0].split(fieldSplit);
        var pmu = cc[1].split(fieldSplit);
        var idx = -1;
        $(".inputBlockContent").children().each(function (index) {

            var cls =  $(this).attr("class");
            var name =  $(this).attr("name");
            var val = $(this).val();
            if (cls == 'updateloadImg')
            {
                $("#headimg").val(pm[++idx]);//更新用
                $(".updateloadImg").attr("src",pm[idx]);//显示用
            }
            else if(name == 'param')
            {
                $(this).val(pm[++idx]);
            }
            else if(name == 'param_url')
            {
                $(this).val(pmu[idx]);

            }

        });
        $("#bcid").val(id);

    }



    function delBlockContent(id)
    {
        if(confirm("确认删除?"))
        {
            var idvalue = "blockcontent_"+id;
            $.post("/template/delblockContent.do", "bcid="+id,
                    function(data) {

                        if(data ==  1)
                        {
                            //window.location.reload();
                            $("#"+idvalue).remove();
                        }
                        else
                        {
                            dialogAlert("提示", "删除失败", function () {});
                        }

                    }
            );
        }

    }




    $(".btn-del").click(function () {


        $.post("/template/delblock.do", "bid="+$("#bid").val(),
                function(data) {

                    if(data ==  1)
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


    $(".btn-cancel").click(function () {


        var bname = $("#bname").val();
        var id = $("#bid").val();
        if(bname != '${Block.bname}')
        {
            $.post("/template/updateBlockDetailTitle.do", "id="+id+"&bname="+bname,function(data){

                if(data == '1')
                {
                    alert(data);
                }

            });
        }


        parent.window.location.href = parent.window.location.href;
        $("body", parent.document).find('#DialogBySHFLayer,#DialogBySHF').remove();

    });

    $(".confirmTemplate").click(function () {


        var templateid = $('input:radio[name=templateRadio]:checked').val();
        var blockname = $("#blockname").val();
        if(blockname == '')
        {
            dialogAlert("提示", "请输入板块名称", function () {});
            return;
        }
        if(typeof templateid == 'undefined')
        {
            dialogAlert("提示", "请选择模块", function () {});
            return;
        }
        var aord = (${param.blocknum} + 1) * 1000000;
        var blockname = $("#blockname").val();
        $.post("/template/updateblock.do", "aord="+aord+"&templateid="+templateid+"&"+$("#blockdetail").serialize(),
                function(data) {



                    if(data > 0)
                    {
                        $("#bid").val(data);
                        $("#bname").val(blockname);
                        $(".chooseTemplate").hide();
                        $(".main-publish").show();
                        initCurrentTemplate(templateid);
                    }
                    else
                    {
                        dialogAlert("提示", "创建板块失败", function () {});
                    }

                }
        );





    });

    function initCurrentTemplate(templateid)
    {
        for(var i=0;i<templateList.length;i++)
        {
            if(templateid == templateList[i][0])
            {
                currentTemplate = templateList[i];
                var field = currentTemplate[3].split(";");
                for(var x=0;x<field.length;x++)
                {
                    var f = field[x];
                    var idx = f.indexOf("_")
                    if(idx > 0)
                    {
                        $(".inputBlockContent").append($("<p >"+field[x].substring(0,idx)+"</p>"));
                    }
                    else
                    {
                        $(".inputBlockContent").append($("<p >"+field[x]+"</p>"));
                    }

                    if (f.indexOf("_image") >= 0)
                    {
                        $(".inputBlockContent").append($("<img style='width:100px;height:100px' src='' class='updateloadImg'><input type=\"file\" name=\"param\" id=\"file\" />"));
                    }
                    else
                    {
                        $(".inputBlockContent").append($("<input type='text'  name='param' class=\"input-text w340\" placeholder='内容'>"));
                    }
                    if(f.indexOf("WITHOUTURL") <= 0)
                    {//不需要link
                        $(".inputBlockContent").append($("<input type='text'  name='param_url' class=\"input-text w400\" placeholder='http为外链。V+场馆ID,A+活动ID自适应h5和app，如：Vb59a52acb6034133b6e38d91153de7e8 '>"));
                    }
                    if(f.indexOf("UPLOAD") > 0)
                    {
//                        $(".inputBlockContent").append("<span id='uploadVideoFile'><a id='selectfiles2' class='selectFiles btn'>选择文件</a></span>");
                        $(".inputBlockContent").append("<div class='whyUploadVedio assnResVideoUrlsDiv' id='uploadVideoFile'><div class='clearfix'><div id='container2' style='float: left;overflow: hidden;margin: 10px 10px 10px 0;'><a id='selectfiles2' class='selectFiles btn'>选择文件</a></div><div id='ossfile2' style='width: 300px;float: left;' class='clearfix'>你的浏览器不支持flash,Silverlight或者HTML5！</div></div></div>")
                        aliUploadFiles('uploadVideoFile', uploadVideoCallback, 1, true, 'H5');
                    }


                }
                initUploadifyFunction();
                break;
            }

        }

    }

//    $('.inputBlockContent').on('change', 'input', function(){
//        if($(this).attr("type") == 'file')
//        {
//            alert('sdf');
//
//        }
//
//    });


    function initUploadifyFunction()
    {
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
                if(initWidth<100 || initHeigth<100)
                {
                    dialogAlert("提示", "请上传尺寸不小于100*100(px)的图片", function () {
                    });
                    $("#isCutImg").val("N");
                    return;
                }

                if(displayPosition ==''){
                    dialogAlert("提示","请选择位置以确定需要裁切图片的尺寸",function(){
                    });
                    return;
                }


                var imgurl = getImgUrl(url);
                $("#headimg").val(imgurl);
                $(".updateloadImg").attr('src',imgurl);

                dialogAlert("提示", "图片上传成功", function () {});
                return true;
            },
            onSelect:function () {
            },
            onCancel:function () {
                $("#headImgUrl").val("");
                $('#file').uploadify('cancel', '*');
            }
        });
    }

</script>

</html>
