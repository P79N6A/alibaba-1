<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/js/admin/jiazhouInfo/addjiazhouInfo.js"></script>
    <link rel="stylesheet" href="${path}/STATIC/js/ossjs/style.css" type="text/css" />
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/uuid.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ossjs/crypto.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ossjs/hmac.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ossjs/sha1.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ossjs/base64.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ossjs/plupload.full.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ossjs/upload-img.js"></script>
    
</head>
<style>
	div[name=aliFile] br,div[name=aliFile] p,div[name=aliFile] span，.progress{display:none!important;}
	#webupload1 div[name=aliFile] img:nth-child(1){position:relative!important;max-width:700px!important;max-height:700px!important;}
	#webupload2 div[name=aliFile] img:nth-child(1){position:relative!important;max-width:300px!important;max-height:300px!important;}
	#webupload1 div[name=aliFile] img:nth-child(1){max-width:700px;max-height:700px;}
	#webupload1 div[name=aliFile]{width:700px!important;max-width:700px!important;}
	#webupload2 div[name=aliFile] img:nth-child(1){max-width:300px;max-height:300px;}
	#webupload2 div[name=aliFile]{width:300px!important;max-width:300px!important;}
</style>
<body ng-controller="infoCon" ng-app="addInfo">
<ng-form id="infoFrom" novalidate
         ng-init="infoFrom.jiazhouInfoId='${jiazhouInfoId}'">
    <div class="site">
        <em>您现在所在的位置：</em>古韵嘉州 &gt; 资讯编辑
    </div>
    <div class="site-title">资讯编辑</div>
    <div class="main-publish">
        <table width="100%" class="form-table">
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>标题：</td>
                <td placeholder="标题" class="td-input">
                    <input type="text" placeholder="标题最多输入24个字" ng-model="infoFrom.jiazhouInfoTitle"
                           class="input-text w510" maxlength="24"/>
                    <a style="color: red"><span ng-bind="leftTitle()"></span>/24</a>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>资讯封面：</td>    
                <td class="td-upload" id="">
                <table>
                    <tr>
                        <td>
                        	<div class="whyVedioInfoContent" style="margin-top:-10px;">
	                            <div class="whyUploadVedio" id="webupload1">
									<div style="width: 700px;">
										<div id="ossfile2"></div>
										<div id="container2" style="clear:both;">
											<a id="selectfiles2" href="javascript:void(0);" class='btn'>选择文件</a>
											<pre style="font-size: 14px;color: #999;line-height: 25px;">Tip：可上传1张图片，格式为jpg、jpeg、png、gif，大小不超过2M</pre>
										</div>
										<script type="text/javascript">
												// 图片
												aliUploadImg('webupload1', uploadImgCallback1, 1, true, 'H5');
										</script> 
									</div>
								</div>
							</div>
                        </td>
                    </tr>
                </table>
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
                <td width="100" class="td-title"><span class="red">*</span>来源：</td>
                <td placeholder="来源" class="td-input">
                    <input type="text" placeholder="来源最多输入32个字" ng-model="infoFrom.publisherName"
                           class="input-text w510" maxlength="32"/>
                    <a style="color: red"><span ng-bind="leftPublisherName()"></span>/32</a>
                </td>
            </tr> 
            <tr>
               <td width="100" class="td-title"><span class="red">*</span>分类：</td>
                <td placeholder="分类" class="td-tag">
			    <dd id="activityTypeLabel">
			    <a ng-repeat="(a, b) in infoFrom.activityType" id="{{a}}" ng-click="setActivityType(a)">{{b}}</a>
                </dd>
                </td>
            </tr>  
              <tr>
               <td width="100" class="td-title">标签：</td>
                <td placeholder="标签" class="td-input">
                    <input type="text" ng-model="infoFrom.jiazhouInfoTag[0]" class="input-text w110"/>
                    <input type="text" ng-model="infoFrom.jiazhouInfoTag[1]" class="input-text w110"/>
                    <input type="text" ng-model="infoFrom.jiazhouInfoTag[2]" class="input-text w110"/>
                </td>
            </tr>                  
            <tr class="">
                <td width="100" class="td-title"><span class="red">*</span>活动描述：</td>
                <td class="td-content">
                    <div class="editor-box">
                        <textarea ckeditor ng-model="infoFrom.jiazhouInfoContent" ></textarea>
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
                <td width="100" class="td-title"><span class="red">*</span>分享封面：</td>    
                <td class="td-upload" id="">
                <table>
                    <tr>
                        <td>
                        	<div class="whyVedioInfoContent" style="margin-top:-10px;">
	                            <div class="whyUploadVedio" id="webupload2">
									<div style="width: 500px;">
										<div id="ossfile2"></div>
										<div id="container2" style="clear:both;">
											<a id="selectfiles2" href="javascript:void(0);" class='btn'>选择文件</a>
											<pre style="font-size: 14px;color: #999;line-height: 25px;">Tip：可上传1张图片，格式为jpg、jpeg、png、gif，大小不超过2M</pre>
										</div>
										<script type="text/javascript">
												// 图片
												aliUploadImg('webupload2', uploadImgCallback2, 1, true, 'H5');
										</script> 
									</div>
								</div>
							</div>
                        </td>
                    </tr>
                </table>
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