<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
</head>
<body ng-controller="infoCon" ng-app="addInfo">
<ng-form id="infoFrom" novalidate
         ng-init="infoFrom.informationId='${informationId}'">
    <div class="site">
        <em>您现在所在的位置：</em>资讯管理 &gt; 资讯内容编辑
    </div>
    <div class="site-title">资讯内容编辑</div>
    <div class="main-publish">
        <table width="100%" class="form-table">
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>标题：</td>
                <td placeholder="标题" class="td-input">
                    <input type="text" placeholder="标题最多输入24个字" ng-model="infoFrom.informationTitle"
                           class="input-text w510" maxlength="24"/>
                    <a style="color: red"><span ng-bind="leftTitle()"></span>/24</a>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>作者：</td>
                <td placeholder="作者" class="td-input">
                    <input type="text" placeholder="作者最多输入32个字" ng-model="infoFrom.authorName" class="input-text w510"
                           maxlength="32"/>
                    <a style="color: red"><span ng-bind="leftAuthorName()"></span>/32</a>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>发布者：</td>
                <td placeholder="发布者" class="td-input">
                    <input type="text" placeholder="发布者最多输入32个字" ng-model="infoFrom.publisherName"
                           class="input-text w510" maxlength="32"/>
                    <a style="color: red"><span ng-bind="leftPublisherName()"></span>/32</a>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>标签：</td>
                <td placeholder="标签" class="td-input">
                    <input type="text" ng-model="infoFrom.informationTag[0]" class="input-text w110"/>
                    <input type="text" ng-model="infoFrom.informationTag[1]" class="input-text w110"/>
                    <input type="text" ng-model="infoFrom.informationTag[2]" class="input-text w110"/>
                    <input type="text" ng-model="infoFrom.informationTag[3]" class="input-text w110"/>
                    <input type="text" ng-model="infoFrom.informationTag[4]" class="input-text w110"/>
                    <input type="text" ng-model="infoFrom.informationTag[5]" class="input-text w110"/>
                </td>
            </tr>
            <tr class="">
                <td width="100" class="td-title"><span class="red">*</span>活动描述：</td>
                <td class="td-content">
                    <div class="editor-box">
                        <textarea ckeditor ng-model="infoFrom.informationContent"></textarea>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>分享标题：</td>
                <td placeholder="分享标题" class="td-input">
                    <input type="text" placeholder="分享标题最多输入64个字" ng-model="infoFrom.shareTitle" class="input-text w510"
                           maxlength="64"/>
                    <a style="color: red"><span ng-bind="leftShareTitle()"></span>/64</a>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>分享简介：</td>
                <td class="td-input">
                    <div class="editor-box">
                        <textarea ng-model="infoFrom.shareSummary" placeholder="分享简介最多输入256个字" rows="4"
                                  class="textareaBox" maxlength="256"></textarea>
                        <a style="color: red"><span ng-bind="leftShareSummary()"></span>/256</a>
                    </div>
                </td>
            </tr>
            <%--<tr>--%>
            <%--<td width="100" class="td-title"><span class="red">*</span>分享基数：</td>--%>
            <%--<td placeholder="分享基数" class="td-input">--%>
            <%--<input type="number" placeholder="分享基数"--%>
            <%--ng-model="infoFrom.shareCount" class="input-text w110" maxlength="32"/>--%>
            <%--</td>--%>
            <%--</tr>--%>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>上传封面：</td>
                <td class="td-upload">
                    <table>
                        <tr>
                            <td>
                                <div id="informationIconUrl" class="btn" ng-model="infoFrom.informationIconUrl"
                                     snail-uploadify="{auto:false,buttonText:'图片上传'}">
                                </div>
                                <div class="img-box" style="width: 270px;height:150px ">
                                    <div id="informationIconUrlPrev" class="img" style="width: 270px;height:150px "><img
                                            ng-src="{{infoFrom.informationIconUrlShow}}"
                                            style="width: 270px;height:150px "></div>
                                </div>
                            </td>
                        </tr>
                        <input type="button" class="upload-cut-btn" ng-click="showImg(infoFrom.informationIconUrl)"
                               value="查看原图" style="width:102px;height:48px;position:absolute;bottom:-90px;left:290px;"/>
                    </table>
                    <span class="upload-tip">可上传1张图片，尺寸大于900*500像素，格式为jpg,jpeg,png,gif，大小不超过2M</span>
                    <table>
                        <tr>
                            <td>
                                <div id="shareIconUrl" class="btn" ng-model="infoFrom.shareIconUrl"
                                     snail-uploadify="{auto:false,buttonText:'图片上传'}"></div>
                                <div class="img-box" style="width: 150px;height:150px ">
                                    <div id="shareIconUrlPrev" class="img" style="width: 150px;height:150px "><img
                                            ng-src="{{infoFrom.shareIconUrlShow}}" style="width: 150px;height:150px ">
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <span class="upload-tip">可上传1张图片，尺寸大于500*500像素，格式为jpg,jpeg,png,gif，大小不超过2M</span>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>页脚图片：</td>
                <td class="td-input">
                    <input type="checkbox" ng-true-value='1' ng-false-value='0' ng-model="infoFrom.informationFooter"/>
                    默认
                    <div ng-switch="infoFrom.informationFooter">
                        <div ng-switch-when="1">
                            <div class="change_img">
                                <img src="${path}/STATIC/image/advice_img.png" width="680" height="375">
                            </div>
                        </div>
                        <div ng-switch-default>

                        </div>
                    </div>

                </td>

            </tr>
            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-btn">
                    <div class="room-order-info info2" style="position: relative;">
                        <input class="btn-save" type="submit" ng-click="saveInfo()" value="保存"/>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</ng-form>
</body>
</html>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>

<script type="text/javascript">
    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });
</script>

<script type="text/javascript" src="${path}/STATIC/js/admin/information/addInformation.js?20160517"></script>
