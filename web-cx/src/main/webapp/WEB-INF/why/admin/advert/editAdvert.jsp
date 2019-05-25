<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/admin/advert/UploadAdvertFile.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/area.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript">



    </script>

</head>

<body style="background: none;">
<form action="${path}/advert/add.do" id="addAdvert" method="post">
    <input type="hidden" name ="advertState" value="${record.advertState}"/>
    <div class="main-publish tag-add">
        <table width="100%" class="form-table">
            <tr>
                <td width="28%" class="td-title">位置:</td>
                <td class="td-select">
                    <div class="select-box w240">
                        <input type="hidden" id="displayPosition" name="displayPosition" value="${record.displayPosition}" />
                        <div class="select-text" data-value="" id="sortDiv">选择位置</div>
                        <ul class="select-option">
                            <li data-option="1">首页轮播图</li>
                            <li data-option="2">场馆列表轮播图</li>
                        </ul>
                    </div>
                </td>
            </tr>

            <tr>
                <td width="28%" class="td-title">区县：</td>
                <td class="td-select">
                    <div class="select-box w240">
                        <input type="hidden" id="advertPos" name="advertPos" value="0"/>
                        <div id="CarouselList" class="select-text" data-value="0">App首页轮播图</div>
                        <ul class="select-option">
                            <li data-option="0">App首页轮播图</li>
                            <li data-option="45">上海市轮播图</li>
                            <li data-option="46">黄浦区轮播图</li>
                            <li data-option="48">徐汇区轮播图</li>
                            <li data-option="50">静安区轮播图</li>
                            <li data-option="49">长宁区轮播图</li>
                            <li data-option="51">普陀区轮播图</li>
                            <li data-option="52">闸北区轮播图</li>
                            <li data-option="53">虹口区轮播图</li>
                            <li data-option="54">杨浦区轮播图</li>
                            <li data-option="58">浦东新区轮播图</li>
                            <li data-option="56">宝山区轮播图</li>
                            <li data-option="57">嘉定区轮播图</li>
                            <li data-option="60">松江区轮播图</li>
                            <li data-option="51">青浦区轮播图</li>
                            <li data-option="55">闵行区轮播图</li>
                            <li data-option="59">金山区轮播图</li>
                            <li data-option="63">奉贤区轮播图</li>
                            <li data-option="64">崇明县轮播图</li>
                        </ul>
                    </div>
                </td>
            </tr>

            <tr>
                <td width="28%" class="td-title">排序：</td>
                <td class="td-select">
                    <div class="select-box w240">
                        <input type="hidden" id="advertPosSort" name="advertPosSort" value="1"/>
                        <div class="select-text" data-value="1">1</div>
                        <ul class="select-option">
                            <li data-option="1">1</li>
                            <li data-option="2">2</li>
                            <li data-option="3">3</li>
                            <li data-option="4">4</li>
                            <li data-option="5">5</li>
                            <li data-option="6">6</li>
                        </ul>
                    </div>
                </td>
            </tr>

            <tr>
                <td width="28%" class="td-title">内容标题：</td>
                <td class="td-input">
                    <input type="text" id="advertTitle" name="advertTitle" value="${cmsAdvert.advertTitle}" maxlength="10" class="input-text w220"/>
                </td>
            </tr>
            <tr>
                <td width="28%" class="td-title">内容简介：</td>
                <td class="td-input">
                    <textarea name="advertContent" class="textareaBox" rows="7" maxlength="30" style="width: 350px;resize: none">${record.advertContent}</textarea>
                </td>
            </tr>
            <tr>
                <td width="28%" class="td-title">广告链接：</td>
                <td class="td-input" >
                    <input type="text" id="advertConnectUrl" name="advertConnectUrl" value="${cmsAdvert.advertConnectUrl}" class="input-text w220"/>
                </td>
            </tr>



            <tr>
                <td width="28%" class="td-title">上传封面：</td>
                <td class="td-upload" id="activityIconUrlLabel">
                    <table>
                        <tr>
                            <td width="80"  ><span id="imgShow"><input type="hidden" name="" id="" value = imgs/></span></td>
                            <td>
                                <input type="hidden"  name="InputadvertPicUrl" id="InputadvertPicUrl" value="">
                                <input type="hidden" name="uploadType" value="Img" id="uploadType"/>

                                <div style="float: left; margin-left: 20px;">
                                    <div style="height: 30px;">
                                        <div class="controls" style="float:left;">
                                            <input type="file" name="file" id="file">
                                        </div>
                                    </div>
                                    <div id="fileContainer"></div>
                                    <div id="btnContainer" style="display: none;">
                                        <a style="margin-left:250px;" href="javascript:clearQueue();" class="btn">取消</a>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>

                </td>
            </tr>
            <tr>
                <td class="td-btn" align="center" colspan="1000">
                    <a style="color: red" id="PromptMessger"></a>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-upload">
                    <input type="file" name="file" id="file" />
                    <span>建议尺寸：首页轮播图800*600，场馆1200*530像素</span>
                </td>
            </tr>

            <tr>
                <td class="td-btn" align="center" colspan="2">
                    <input class="btn-save" type="button" value="保存"/>
                    <input class="btn-cancel" type="button" value="取消"/>
                </td>
            </tr>
        </table>
    </div>
</form>


<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
    $(function(){
        selectModel();
    });
</script>

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
            /*点击确定按钮*/
            $(".btn-save").on("click", function(){
                $.post("${path}/advert/editAdvert.do", $("#addAdvert").serialize(),
                        function(data) {
                            if(data != null && data == 'success'){
                                $('#PromptMessger').html("");
                                parent.location.href="${path}/advert/advertIndex.do";
                                dialog.close().remove();
                            } else if(data != null && data == 'ADVERT_NOT_INSERT'){
                                var advertPos1 = null
                                var advertPos_ =  $("#advertPos").val();
                                var advertPosSort_ =$("#advertPosSort").val();

                                if(advertPos_ == "0"){
                                    advertPos1 = "App首页轮播图";
                                }
                                if(advertPos_ == "45"){
                                    advertPos1 = "上海市轮播图";
                                }
                                if(advertPos_ == "46"){
                                    advertPos1 = "黄浦区轮播图";
                                }
                                if(advertPos_ == "48"){
                                    advertPos1 = "徐汇区轮播图";
                                }
                                if(advertPos_ == "50"){
                                    advertPos1 = "静安区轮播图";
                                }
                                if(advertPos_ == "49"){
                                    advertPos1 = "长宁区轮播图";
                                }
                                if(advertPos_ == "51"){
                                    advertPos1 = "普陀区轮播图";
                                }
                                if(advertPos_ == "52"){
                                    advertPos1 = "闸北区轮播图";
                                }
                                if(advertPos_ == "53"){
                                    advertPos1 = "虹口区轮播图";
                                }
                                if(advertPos_ == "54"){
                                    advertPos1 = "杨浦区轮播图";
                                }
                                if(advertPos_ == "58"){
                                    advertPos1 = "浦东新区轮播图";
                                }
                                if(advertPos_ == "56"){
                                    advertPos1 = "宝山区轮播图";
                                }
                                if(advertPos_ == "57"){
                                    advertPos1 = "嘉定区轮播图";
                                }
                                if(advertPos_ == "60"){
                                    advertPos1 = "松江区轮播图";
                                }
                                if(advertPos_ == "51"){
                                    advertPos1 = "青浦区轮播图";
                                }
                                if(advertPos_ == "55"){
                                    advertPos1 = "闵行区轮播图";
                                }
                                if(advertPos_ == "59"){
                                    advertPos1 = "金山区轮播图";
                                }
                                if(advertPos_ == "63"){
                                    advertPos1 = "奉贤区轮播图";
                                }
                                if(advertPos_ == "64"){
                                    advertPos1 = "崇明县轮播图";
                                }
                                var show_ = "您目前选择的是:"+advertPos1+" 排序为:"+advertPosSort_+",但是该排序已经存在,请将之前排序的内容下架再做添加！谢谢";
                                $('#PromptMessger').html(show_);
                            } else if(data != null && data == 'ADVERT_HAVE_POSITION'){
                                dialogConfirm("提示信息", "您目前添加的广告版位图片的顺序不是第一位,是否继续提交", removeParent);
                                function removeParent() {
                                    $.post("${path}/advert/add.do", $("#addAdvert").serialize(),
                                            function(data){
                                                if(data != null && data == 'success'){
                                                    $('#PromptMessger').html("");
                                                    parent.location.href="${path}/advert/advertIndex.do";
                                                    dialog.close().remove();
                                                }
                                            })
                                }
                            }else {
                                dialog.close().remove();
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
