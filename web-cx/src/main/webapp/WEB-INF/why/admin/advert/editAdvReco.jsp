<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/normalize.css">
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/advert.css">
    <script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">
        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        var count = '${fn:length(appAdvertRecommendRfer)}';
        var tagC = "${appAdvertRecommend.advPostion}";
        $(document).ready(function () {
            $(".top-menu li div").click(function () {
                $(".top-menu li div").css({"background-color": "#fff", "color": "#142340"})
                $(this).css({"background-color": "dodgerblue", "color": "white"})
            })
            $(".checkbox1").click(function () {
                if ($(this).is(':checked')) {
                    $(this).next(".checkbox2").attr("checked", false)
                    $(this).parentsUntil("li").find(".line-2").removeClass("checkedoff")
                    $(this).next("select").val(0)
                    $(this).parentsUntil("li").find("select").addClass("checkedoff")
                    $(this).parentsUntil("li").find(".line-2").removeClass("checkedoff").html("URL:")
                } else {
                    $(this).parentsUntil("li").find(".line-2").addClass("checkedoff")
                }
            })
            $(".checkbox2").click(function () {
                if ($(this).is(':checked')) {
                    $(this).prev(".checkbox1").attr("checked", false)
                    $(this).parentsUntil("li").find(".line-2").addClass("checkedoff")
                    $(this).next("select").removeClass("checkedoff")
                    $(this).next("select").val(0)
                    $(this).next("select").change(function () {
                        if ($(this).parentsUntil("li").find(".ckselect").val() == 1 || $(this).parentsUntil("li").find(".ckselect").val() == 3) {
                            $(this).parentsUntil("li").find(".line-2").removeClass("checkedoff").html("关键字:")
                        } else if ($(this).parentsUntil("li").find(".ckselect").val() == 2 || $(this).parentsUntil("li").find(".ckselect").val() == 4) {
                            $(this).parentsUntil("li").find(".line-2").removeClass("checkedoff").html("ID:")
                        } else {
                        }
                    })
                } else {
                    $(this).parentsUntil("li").find(".ckselect").addClass("checkedoff")
                    $(this).parentsUntil("li").find(".line-2").removeClass("checkedoff").html("URL:")
                }
            })
        })


        //主题标签
        $(function () {
            var type = $("#uploadType").val();
            var sessionId = $("#sessionId").val();
            var userCounty = $("#userCounty").val();
            uploadFun(type, userCounty, sessionId, "filea");
            uploadFun(type, userCounty, sessionId, "fileb");
            uploadFun(type, userCounty, sessionId, "filec");
            for (var i = 0; i < count; i++) {
                uploadFun(type, userCounty, sessionId, "file" + i);
            }
            $.post("../tag/getChildTagByType.do?code=ACTIVITY_TYPE", function (data) {
                var list = eval(data);
                var tagHtml = '';
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var tagId = obj.tagId;
                    var tagName = obj.tagName;
                    if (tagId == tagC) {
                        tagHtml += '<a width:30 id="' + tagId + '" class="cur" >' + tagName + '</a>';
                    }

                }
                if (tagC == 0) {
                    tagHtml += '<a width:30px id="' + tagId + '" class="cur" >推荐</a>';
                }
                $("#activityTypeLabel").html(tagHtml);
                $("#advPostion").val(tagC);
            });

            $(".btn-save").on("click", function () {

                var advBannerFImgUrl = $("#imgUrlfilea").val();
                var advBannerSImgUrl = $("#imgUrlfileb").val();
                var advBannerLImgUrl = $("#imgUrlfilec").val();
                var advBannerFUrl = $("#advBannerFUrl").val();
                var advBannerSUrl = $("#advBannerSUrl").val();
                var advBannerLUrl = $("#advBannerLUrl").val();
                if(advBannerFUrl==undefined||advBannerFUrl==""){
                    removeMsg("advLinka");
                    appendMsg("advLinka","请填写链接!");
                    $('#advLink').focus();
                    return;
                }else{
                    removeMsg("advLinka");
                }
                if(advBannerSUrl==undefined||advBannerSUrl==""){
                    removeMsg("advLinkb");
                    appendMsg("advLinkb","请填写链接!");
                    $('#advLink').focus();
                    return;
                }else{
                    removeMsg("advLinkb");
                }
                if(advBannerLUrl==undefined||advBannerLUrl==""){
                    removeMsg("advLinkc");
                    appendMsg("advLinkc","请填写链接!");
                    $('#advLink').focus();
                    return;
                }else{
                    removeMsg("advLinkc");
                }
                if(advBannerFImgUrl==undefined||advBannerFImgUrl==""){
                    removeMsg("advBanner");
                    appendMsg("advBanner","请上传广告位大图!");
                    $('#advBanner').focus();
                    return;
                }else{
                    removeMsg("advBanner");
                }
                if(advBannerSImgUrl==undefined||advBannerSImgUrl==""){
                    removeMsg("advBanner");
                    appendMsg("advBanner","请上传广告位左侧小图!");
                    $('#advBanner').focus();
                    return;
                }else{
                    removeMsg("advBanner");
                }
                if(advBannerLImgUrl==undefined||advBannerLImgUrl==""){
                    removeMsg("advBanner");
                    appendMsg("advBanner","请上传广告位右侧小图!");
                    $('#advBanner').focus();
                    return;
                }else{
                    removeMsg("advBanner");
                }

                $.post("${path}/advertRecommend/addAdvert.do", $("#advertForm").serialize(),

                        function (data) {
                            if (data != null && data == 'success') {
                                dialogAlert("提示", "操作成功", function () {
                                    window.location.href = "${path}/advertRecommend/appAdvertRecommendIndex.do";
                                });
                            } else {
                                dialogAlert("提示", "操作失败！", function () {
                                });
                            }
                        });
            });
        });

        function uploadFun(type, userCounty, sessionId, fileName) {
            var num = fileName ? fileName : "";
            var queueIDStr = num ? ('fileContainer' + num) : 'fileContainer';
            var imgType="";
            var haveUrl=$("#imgUrl"+ num).val();
            if (num == 'fileb' || num == 'filec') {
                imgType=11;
                if(haveUrl!=""){
                    $("#imgHeadPrev" + num).html(getImgHtml(150, 50, getImgUrl(haveUrl)));

                }
            } else {
                imgType=12;
                if(haveUrl!=""){
                    $("#imgHeadPrev" + num).html(getImgHtml(300, 100, getImgUrl(haveUrl)));
                }
            }
            $("#" + num).uploadify({
                'formData': {'uploadType': type, 'type': imgType, userCounty: userCounty},//传静态参数
                swf: '../STATIC/js/uploadify.swf',
                uploader: '../upload/uploadFile.do;jsessionid=' + sessionId, //后台处理的请求
                buttonText: '选择图片',//上传按钮的文字
                'fileSizeLimit': '2MB',
                'buttonClass': "upload-btn",//按钮的样式
                queueSizeLimit: 1, //   default 999
                'method': 'post',//和后台交互的方式：post/get
                queueID: queueIDStr,
                fileObjName: 'file', //后台接受参数名称
                fileTypeExts: '*.gif;*.png;*.jpg;*.jpeg;', //控制可上传文件的扩展名，启用本项时需同时声明fileDesc
                'auto': true, //true当选择文件后就直接上传了，为false需要点击上传按钮才上传
                'multi': false, //是否支持多个附近同时上传
                height: 44,//选择文件按钮的高度
                width: 100,//选择文件按钮的宽度
                'debug': false,//debug模式开/关，打开后会显示debug时的信息
                'dataType': 'json',
                removeCompleted: false,//上传成功后的文件，是否在队列中自动删除
                onUploadSuccess: function (file, data, response) {
                    var json = $.parseJSON(data);
                    var url = json.data;
                    var hiddenImgUrl = url;
                    $("#imgUrl" + num).val(url);
                    $("#btnContainer" + num).show();
                    if (num != '') {

                        //$("#imgHeadPrev"+num).html(getImgHtml(getImgUrl(url),300,200));
                        var initWidth = parseInt(json.initWidth);
                        var initHeigth = parseInt(json.initHeigth);
//                        if (initWidth < 750 || initHeigth < 250) {
//                            dialogAlert("提示", "请上传尺寸不小于750*250(px)的图片", function () {
////                                $('#fileContainer'+num).html("");
////                                $("#btnContainer"+num).hide();
//                            });
////                            $("#isCutImg").val("N");
//                            return;
//                        }
                        if (num == 'fileb' || num == 'filec') {
                            var cutImageWidth = 748;
                            var cutImageHeigth = 310;
                        } else {
                            var cutImageWidth = 750;
                            var cutImageHeigth = 250;
                        }
                        console.log("================" + url);
                        var url = getImgUrl(url);
                        dialog({
                            url: "${path}/att/toCutImgJsp.do",
                            data: {
                                imageUrl: url,
                                initWidth: initWidth,
                                initHeigth: initHeigth,
                                cutImageWidth: cutImageWidth,
                                cutImageHeigth: cutImageHeigth
                            },
                            title: '图片裁剪',
                            fixed: false,
                            onclose: function () {
                                if (this.returnValue) {
                                    var imgUrl = this.returnValue.imageUrl;
                                    var isCutImg = this.returnValue.isCutImg;
                                    console.log("^^^^^^" + imgUrl)
                                    setTimeout(function () {
                                        if (num == 'fileb' || num == 'filec') {
                                            $("#imgHeadPrev" + num).html(getImgHtml(150, 50, imgUrl));
                                        } else {
                                            $("#imgHeadPrev" + num).html(getImgHtml(300, 100, imgUrl));
                                        }
                                    }, 0);
                                    $("#isCutImg").val(isCutImg);
                                    $("#voteCoverImgUrl" + num).val(hiddenImgUrl);

                                }
                            }
                        }).showModal();
                    } else {
                        $("#imgHeadPrev" + num).html(getImgHtml(100, 100, getImgUrl(url)));
                    }
                    return false;
                },
                onSelect: function () { //插件本身没有单文件上传之后replace的效果
                    var notLast = $('#fileContainer' + num).find('div.uploadify-queue-item').not(':last');
                    notLast.remove();
                    $('#btnContainer' + num).show();
                },
                onCancel: function () {
                    $('#btnContainer' + num).hide();
                }
            });
        }
        function getImgHtml(width, height, imgUrl) {
            if (imgUrl == "") {
                return '<img src="../STATIC/image/defaultImg.png" />';
            }
            return '<img style="width:' + width + 'px; height:' + height + 'px;"  src="' + imgUrl + '" />';
        }

        //选择关键字标签时，赋值
        function setActivityTag(value) {
            var tagId = value;
            $("#advPostion").val(tagId);
        }
        //加载小广告为
        function setActivityTag(value) {
            var tagId = value;
            $("#advPostion").val(tagId);
        }
    </script>
</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em>推荐管理 &gt; App端端推荐 &gt; 广告位推荐 &gt; 编辑广告位
</div>
<form id="advertForm" method="post">
    <input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}"/>
    <input type="hidden" id="sessionId" value="${pageContext.session.id}"/>
    <input type="hidden" id="advertId" name="advertId" value="${appAdvertRecommend.advertId}"/>
    <input type="hidden" name="uploadType" value="Img" id="uploadType"/>
    <div class="main">
        <h5>首页-广告位置</h5>
        <div class="top-menu">
            <table class="form-table">
                <tr style="clear:both;">
                    <td class="td-tag " style="width:100%">
                        <dl>
                            <input id="advPostion" name="advPostion" style="position: absolute; left: -9999px;"
                                   type="hidden" value=""/>
                            <dd id="activityTypeLabel" style="clear:both;width: 100%">
                            </dd>
                        </dl>
                    </td>
                </tr>
            </table>
        </div>
        <div class="content-p1">
            <div class="content-p1-left1" id="advBanner" name="advBanner">
                <div class="left-p1"  style="position:relative;">
                    <input type="hidden" name="advBannerFImgUrl" id="imgUrlfilea"
                           value="${appAdvertRecommend.advBannerFImgUrl}">
                    <input type="file" name="filea" id="filea">
                    <div id="imgHeadPrevfilea" style="position:absolute;top:0px;left:0px;"></div>
                    <div id="fileContainer1"></div>
                </div>
                <div class="left-p2" style="position:relative; overflow: hidden;">
                    <input type="file" name="fileb" id="fileb">
                    <input type="hidden" name="advBannerSImgUrl" id="imgUrlfileb"
                           value="${appAdvertRecommend.advBannerSImgUrl}">
                    <div id="imgHeadPrevfileb" style="position:absolute; width:150px; height:50px; top:0px;left:0px;"></div>
                    <div id="fileContainer2"></div>
                </div>
                <div class="left-p3" style="position:relative; overflow: hidden;">
                    <input type="file" name="filec" id="filec">
                    <input type="hidden" name="advBannerLImgUrl" id="imgUrlfilec"
                           value="${appAdvertRecommend.advBannerLImgUrl}">
                    <div id="imgHeadPrevfilec" style="position:absolute; top:0px;left:0px;"></div>
                    <div id="fileContainer3"></div>
                </div>
                <div style="clear: both;"></div>
            </div>
            <div class="content-p1-right1">
                <h5><span>首页</span>位置:</h5>
                <ul>
                    <li>
                        <span class="line-title" >A1:</span>
                        <div class="line">
                            <p class="line-1">
                                <input class="checkbox1" <c:if
                                        test="${appAdvertRecommend.advBannerFIsLink ==1}"> checked="checked" </c:if>type="checkbox"
                                       name="advBannerFIsLink" value="1"/>外链
                                <input class="checkbox2" <c:if
                                        test="${appAdvertRecommend.advBannerFIsLink ==0}"> checked="checked" </c:if>type="checkbox"
                                       name="advBannerFIsLink" value="0"/>内链
                                <select class="ckselect checkedoff" name="advBannerFLinkType">
                                    <option value="">请选择..</option>
                                    <option value="0" <c:if
                                            test="${appAdvertRecommend.advBannerFLinkType ==0}"> selected="checked" </c:if>>
                                        活动list
                                    </option>
                                    <option value="1" <c:if
                                            test="${appAdvertRecommend.advBannerFLinkType ==1}"> selected="checked" </c:if>>
                                        活动详细页
                                    </option>
                                    <option value="2" <c:if
                                            test="${appAdvertRecommend.advBannerFLinkType ==2}"> selected="checked" </c:if>>
                                        场馆list
                                    </option>
                                    <option value="3" <c:if
                                            test="${appAdvertRecommend.advBannerFLinkType ==3}"> selected="checked" </c:if>>
                                        场馆详细页
                                    </option>
                                </select>
                            </p>
                        </div>
                        <div style="clear: both;"></div>
                        <div style="margin-left:0px;" id="advLinka" name="advLinka"><label class="line-2"  style="margin-right:10px;">Url/关键词：</label><input
                                type="text" name="advBannerFUrl" id="advBannerFUrl" value="${appAdvertRecommend.advBannerFUrl}" style="width: 280px; height: 30px; border:1px solid #ACB4C3;border-radius: 5px;-webkit-border-radius:5px;-moz-border-radius:5px; outline: none;"></div>
                    </li>
                    <li>
                        <span class="line-title" >A2:</span>
                        <div class="line">
                            <p class="line-1">
                                <input class="checkbox1" <c:if
                                        test="${appAdvertRecommend.advBannerSIsLink ==1}"> checked="checked" </c:if>type="checkbox"
                                       name="advBannerSIsLink" value="1"/>外链
                                <input class="checkbox2" <c:if
                                        test="${appAdvertRecommend.advBannerSIsLink ==0}"> checked="checked" </c:if>type="checkbox"
                                       name="advBannerSIsLink" value="0"/>内链
                                <select class="ckselect checkedoff" name="advBannerSLinkType">
                                    <option value="">请选择..</option>
                                    <option value="0"<c:if
                                            test="${appAdvertRecommend.advBannerSLinkType ==0}"> selected="checked" </c:if>>
                                        活动list
                                    </option>
                                    <option value="1"<c:if
                                            test="${appAdvertRecommend.advBannerSLinkType ==1}"> selected="checked" </c:if>>
                                        活动详细页
                                    </option>
                                    <option value="2"<c:if
                                            test="${appAdvertRecommend.advBannerSLinkType ==2}"> selected="checked" </c:if>>
                                        场馆list
                                    </option>
                                    <option value="3"<c:if
                                            test="${appAdvertRecommend.advBannerSLinkType ==3}"> selected="checked" </c:if>>
                                        场馆详细页
                                    </option>
                                </select></input>
                            </p>
                        </div>
                        <div style="clear: both;"></div>
                        <div style="margin-left:0px;" id="advLinkb" name="advLinkb"><label class="line-2"  style="margin-right:10px;">Url/关键词：</label><input
                                type="text" name="advBannerSUrl" id="advBannerSUrl" value="${appAdvertRecommend.advBannerSUrl}" style="width: 280px; height: 30px; border:1px solid #ACB4C3;border-radius: 5px;-webkit-border-radius:5px;-moz-border-radius:5px; outline: none;"></div>
                    </li>
                    <li>
                        <span class="line-title" >A3:</span>
                        <div class="line">
                            <p class="line-1">
                                <input class="checkbox1" <c:if
                                        test="${appAdvertRecommend.advBannerLIsLink ==1}"> checked="checked" </c:if>type="checkbox"
                                       name="advBannerLIsLink" value="1"/>外链
                                <input class="checkbox2" <c:if
                                        test="${appAdvertRecommend.advBannerLIsLink ==0}"> checked="checked" </c:if>type="checkbox"
                                       name="advBannerLIsLink" value="0"/>内链
                                <select class="ckselect checkedoff" name="advBannerLLinkType">
                                    <option value="">请选择..</option>
                                    <option value="0"<c:if
                                            test="${appAdvertRecommend.advBannerLLinkType ==0}"> selected="checked" </c:if>>
                                        活动list
                                    </option>
                                    <option value="1"<c:if
                                            test="${appAdvertRecommend.advBannerLLinkType ==1}"> selected="checked" </c:if>>
                                        活动详细页
                                    </option>
                                    <option value="2"<c:if
                                            test="${appAdvertRecommend.advBannerLLinkType ==2}"> selected="checked" </c:if>>
                                        场馆list
                                    </option>
                                    <option value="3"<c:if
                                            test="${appAdvertRecommend.advBannerLLinkType ==3}"> selected="checked" </c:if>>
                                        场馆详细页
                                    </option>
                                </select></input>
                            </p>
                        </div>
                        <div style="clear: both;"></div>
                        <div style="margin-left:0px;" id="advLinkc" name="advLinkc"><label class="line-2"  style="margin-right:10px;">Url/关键词：</label><input
                                type="text" name="advBannerLUrl" id="advBannerLUrl" value="${appAdvertRecommend.advBannerLUrl}" style="width: 280px; height: 30px; border:1px solid #ACB4C3;border-radius: 5px;-webkit-border-radius:5px;-moz-border-radius:5px; outline: none;"></div>
                    </li>
                </ul>
            </div>
            <div style="clear: both;"></div>
        </div>
        <div class="content-p2">
            <p class="tit"><input type="checkbox" <c:if
                    test="${appAdvertRecommend.isContainActivtiyAdv ==1}"> checked="checked" </c:if>
                                  name="isContainActivtiyAdv" value="1"/>新增广告位(每隔3场活动出现一次)</p>
            <div class="p2-upload">
                <p class="p2-upload-title">排序</p>
                <ul>
                    <c:forEach items="${appAdvertRecommendRfer}" var="c" varStatus="s">
                        <li>
                            <div>
                                <div class="p2-upload-left" style='position:relative;'>
                                    <input type="file" name="file${s.index}" id="file${s.index}">
                                    <div id="imgHeadPrevfile${s.index}" style="position:absolute;top:0px;left:0px;" value="${c.advertImgUrl}"></div>
                                    <input type="hidden" name="dataList[${s.index}].advertImgUrl"
                                           id="imgUrlfile${s.index}"
                                           value="${c.advertImgUrl}">
                                </div>
                                <div class="p2-upload-right">
                                    <p class="p2-line1">B${s.index+1}:<span>URL:</span><input value="${c.advertUrl}"
                                                                                   name="dataList[${s.index}].advertUrl"
                                                                                   type="text" class="p2-line1-1 w200"><input
                                            value="${c.advertSort}" name="dataList[${s.index}].advertSort" type="text"
                                            class="p2-line1-2"></p>
                                    <button class="rm" type="button">删除</button>
                                </div>
                                <div style="clear: both;"></div>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
            <button type="button" class="add-upload">+</button>
        </div>
    </div>
    <tr>
        <td width="100" class="td-title">
        <td class="td-btn">
            <input class="btn-save" type="button"
                   style="background-color:#f00000; width: 120px; height: 40px;line-height: 40px; font-size: 18px; outline: none; margin-left:730px; color: #ffffff; text-align: center; -webkit-border-radius: 5px;-moz-border-radius: 5px;border:none;"
                   value="确定"/>
        </td>
    </tr>
    <script>
        $(document).ready(function () {
            $(".add-upload").click(function () {
                var num = $(".p2-upload li").length + 1
                $(".content-p2 ul").append(
                        "<li>" +
                        "<div>" +
                        "<div class='p2-upload-left' style='position:relative;'><input type='file' name='file" + count + "' id='file" + count + "'><div id='imgHeadPrevfile" + count + "' style='position:absolute;top:0px;left:0px;'></div><input type='hidden' name='dataList[" + count + "].advertImgUrl' id='imgUrlfile" + count + "'value=''></div>" +
                        "<div class='p2-upload-right'>" +
                        "<p class='p2-line1'>" +
                        "B" + num + ":" + "<span>" + "URL:" + "</span><input type='text' name='dataList[" + count + "].advertUrl' class='p2-line1-1 w200'>" + "<input name='dataList[" + count + "].advertSort' type='text' class='p2-line1-2'>" +
                        "</p>" +
                        "<button class='rm' type='button'>删除</button>" +
                        "</div>" +
                        "<div style='clear: both;'></div>" +
                        "</div>" +
                        "</li>"
                );
                var type = $("#uploadType").val();
                var sessionId = $("#sessionId").val();
                var userCounty = $("#userCounty").val();
                uploadFun(type, userCounty, sessionId, "file" + count);
                count++;
                $(".rm").click(function () {
                    $(this).parentsUntil("ul").remove()
                })
            })
            $(".rm").click(function () {
                $(this).parentsUntil("ul").remove()
            })
        })
    </script>
</form>
</body>
</html>
