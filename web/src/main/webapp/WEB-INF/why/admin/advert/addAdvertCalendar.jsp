<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html ng-controller="advCon" ng-app="addAdv" ng-init="advFrom.advertId='${advertId}'">
<%--<html>--%>
<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/reset.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/main.css"/>
</head>
<body>
<ng-form ng-init="">
    <div class="site">
        <em>您现在所在的位置：</em>日历广告位 &gt; 日历广告位编辑
    </div>
    <div class="site-title">日历广告位编辑</div>
    <div class="main-publish">
        <table width="100%" class="form-table">
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>上传封面：</td>
                <td class="td-upload">
                    <table>
                        <tr>
                            <td>
                                <div class="img-box" style="width: 300px;height:152px ">
                                    <div class="img" style="width: 300px;height:152px ">
                                        <img ng-src="{{advFrom.advImgUrlShow}}" style="width: 300px;height:152px ">
                                    </div>
                                </div>
                                <div class="controls-box" style="height: 46px;">
                                    <div id="advImgUrl_750_380" class="controls" ng-model="advFrom.advImgUrl"
                                         snail-uploadify="{auto:false,buttonText:'图片上传'}">
                                    </div>
                                    <span class="upload-tip">可上传1张图片，建议尺寸750*380像素，格式为jpg,jpeg,png,gif，大小不超过2M</span>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr class="form-table td-time">
                <td width="100" class="td-title"><span class="red">*</span>日期：</td>
                <td class="td-input ">
                    <div class="start w340">
                        <input type="text" ng-model="advFrom.advertDate"
                               value="" readonly/>
                        <i date-picker ng-model="advFrom.advertDate"></i>
                    </div>
                    <input type="hidden" id="datePicker"/>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>主题名称：</td>
                <td class="td-input">
                    <input type="text" placeholder="作者最多输入32个字" ng-model="advFrom.advertName" class="input-text w510"
                           maxlength="32"/>
                    <a style="color: red"></a>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>链接：</td>
                <td placeholder="发布者" class="td-input" >
                    <label><input type="radio" ng-model="advFrom.advLink" value="1"/><em>外链</em></label>
                    <label><input type="radio" ng-model="advFrom.advLink" value="0"/><em>内链</em></label>
                    <select ng-model="advFrom.advLinkType" ng-show="advFrom.advLinkShow">
                        <option  ng-if="!advFrom.advLinkType">请选择</option>
                        <option value=0>活动列表</option>
                        <option value=1>活动详情</option>
                        <option value=2>场馆列表</option>
                        <option value=3>场馆详情</option>
                    </select>
                </td>
            </tr>
            <tr ng-switch="advFrom.advLink">
                <td ng-switch-when="0" ng-switch="advFrom.advLinkType" width="100" class="td-title"><span class="red">*</span>
                    <a ng-switch-when="3">ID</a>
                    <a ng-switch-when="1">ID</a>
                    <a ng-switch-when="2">关键字</a>
                    <a ng-switch-when="0">关键字</a>
                </td>
                <td ng-switch-when="1" width="100" class="td-title"><span class="red">*</span>
                    <a>URL</a>
                </td>
                <td  class="td-input">
                    <input type="text" ng-model="advFrom.advUrl"
                           class="input-text w510" maxlength="32"/>
                    <a style="color: red"></a>
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
<script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/base.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/jquery.alerts.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>
<script src="${path}/STATIC/js/angular.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
<script type="text/javascript">
    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });
</script>
<script type="text/javascript" src="${path}/STATIC/js/admin/advert/addAdvCal.js?201606"></script>
<script type="text/javascript" src="${path}/STATIC/js/admin/datePicker.js?201605145"></script>
<script type="text/javascript" src="${path}/STATIC/js/admin/uploadify.js?201605145"></script>

</html>
