<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>添加广告--文化云</title>
<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
	<script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
	<script type="text/javascript">

		function getImgHtml(imgUrl){
			if(imgUrl==""){
				return '<img src="../STATIC/image/defaultImg.png" />';
			}
			return '<img style="width:300px; height:200px;"  src="'+imgUrl+'" />';
		}

		$(function(){

			window.onload = function(){
				var editor = CKEDITOR.replace('advertDescribe');
			}


			//当为场馆的轮播图的时候 隐藏 区县
			if ($("#displayPosition").val() != undefined && $("#displayPosition").val() == '2') {
				$("#city-select").hide();
				$("#advertPos").val("45");
			}

			var recordId = '${record.advertId}';
			if(recordId!=""){
				//地区选中
				$("#CarouselList").html('${record.advertColumn}');
				//排序选中
				var deSort = '${record. advertPosSort}';
				$("#advertPosSort").val(deSort);
				$("#sortDiv").attr("data-value",deSort);
				$("#sortDiv").html(deSort);

				var imgUrl = '${record.advertPicUrl}';
				if(imgUrl!=""){
					//$("#imgHeadPrev").attr("src",getImgUrl(imgUrl));
					imgUrl = getIndexImgUrl(imgUrl,"_300_300")
					$("#imgHeadPrev").html(getImgHtml(getImgUrl(imgUrl)));
				}else{
					$("#imgHeadPrev").html(getImgHtml(""));
				}
			}else{
				$("#imgHeadPrev").html(getImgHtml(""));
			}
			selectModel(function(){
				if($("#displayPosition").val() == 2){
					$("#city-select").hide();
					$("#advertPos").val("45");
				}else{
					$("#city-select").show();
				}

				var $pos = $("#displayPosition");
				var num = $pos.val();
				var imgSize = "";
				$pos.siblings(".select-option").find("li").each(function(){
					if($(this).attr("data-option") == num){
						imgSize = $(this).attr("data-imgSize");
					}
				});
				$("#messageTip").html(imgSize);
			});
		});
	</script>

	<script type="text/javascript">


		window.console = window.console || {log:function () {}}
		//seajs.use(['jquery'], function ($) {
			$(function () {
				var advertId = '${record.advertId}';
				var tips = "";
				if(advertId!="" && typeof(advertId)!="undefined"){
					tips = "修改成功!";
				}else{
					tips = "保存成功!"
				}

				/*点击确定按钮*/
				$(".btn-save").on("click", function(){
					var position = $("#advertPos").val();
					var sort = $("#advertPosSort").val();
					var isCutImg =$("#isCutImg").val();
					var linkType = $("#linkType").val();
					var displayPosition = $("#displayPosition").val()

					if("N"==isCutImg) {
						dialogAlert("提示","请上传系统要求尺寸的图片",function(){
						});
						return;
					}

					if(position == ""){
						dialogAlert("提示","请选择轮播图位置",function(){
						});
						return;
					}
					$("#siteId").val(position);
					if(displayPosition == 3){
						$("#advertPos").val(1);
					}
					if(sort==""){
						dialogAlert("提示","请选择轮播图排序",function(){
						});
						return;
					}

					//富文本赋值
					if ($("#advertDescribe").val() != undefined) {
						$('#advertDescribe').val(CKEDITOR.instances.advertDescribe.getData());
					}

					$.post("${path}/advert/addAdvert.do", $("#addAdvert").serialize(),
							function(data) {
								if(data != null && data == 'success'){
									dialogAlert("提示",tips,function(){
										if( linkType =="" || linkType !="APP"){
											parent.location.href="${path}/advert/advertIndex.do?displayPosition=" + $("#displayPosition").val();
										}else{
											parent.location.href="${path}/advert/appRecommendadvertlist.do";
										}

										dialog.close().remove();
									});
								} else if(data != null && data == 'ADVERT_NOT_INSERT'){

									var show ="当前排序已经存在,请修改当前排序或将编辑已存在的排序再做添加!";
										removeMsg("PromptMessger");
										appendMsg("PromptMessger",show);
								}else if(data != null && data == 'ADVERT_HAVE_POSITION'){
									dialogConfirm("提示信息", "您目前添加的广告版位图片的顺序不是第一位,是否继续提交", removeParent);
									function removeParent() {

										$.post("${path}/advert/add.do", $("#addAdvert").serialize(),
												function(data){
													if(data != null && data == 'success'){
														dialogAlert("提示",tips,function(){
															parent.location.href="${path}/advert/advertIndex.do?displayPosition=" + $("#displayPosition").val();
															dialog.close().remove();
														});
													}else if(data != null && data == 'ADVERT_NOT_INSERT'){
														var show ="当前排序已经存在,请修改当前排序或将编辑已存在的排序再做添加!";
														removeMsg("PromptMessger");
														appendMsg("PromptMessger",show);
													}else{
														dialogAlert("提示","操作失败,请联系管理员!",function(){

														});
													}
												});

									}
								}else {
									dialogAlert("提示","操作失败！",function(){

									});
								}
							});

				});
				/*点击取消按钮，关闭登录框*/
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

		seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
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
				swf:'${path}/STATIC/js/uploadify.swf',
				uploader:'../upload/uploadFile.do;jsessionid=${pageContext.session.id}',//后台处理的请求
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
					if(linkType == "APP"){
						if(displayPosition =="1"){
							if(initWidth<750 || initHeigth<400){
								dialogAlert("提示","请上传尺寸不小于750*400(px)的图片",function(){
								});
								$("#isCutImg").val("N");
								return;
							}
						}else{
							if(initWidth<750 || initHeigth<150){
								dialogAlert("提示","请上传尺寸不小于750*150(px)的图片",function(){
								});
								$("#isCutImg").val("N");
								return;
							}
						}
					}else{
						if(displayPosition =="1"){
							if(initWidth<750 || initHeigth<400){
								dialogAlert("提示","请上传尺寸不小于750*400(px)的图片",function(){
								});
								$("#isCutImg").val("N");
								return;
							}
						}else{
							if(initWidth<1200 || initHeigth<530){
								dialogAlert("提示","请上传尺寸不小于1200*530(px)的图片",function(){
								});
								$("#isCutImg").val("N");
								return;
							}
						}
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

					var url =getImgUrl(url);
					dialog({
						url: '${path}/att/toCutImgJsp.do',
						data: {
							imageUrl: url,
							initWidth:initWidth,
							initHeigth:initHeigth,
							cutImageWidth:cutImageWidth,
							cutImageHeigth:cutImageHeigth
						},
						title: '图片裁剪',
						fixed: false,
						onclose: function () {
							if(this.returnValue){
								var imgUrl = this.returnValue.imageUrl;
								var isCutImg = this.returnValue.isCutImg;
								setTimeout(function(){
									$("#imgHeadPrev").html(getImgHtml(imgUrl));
								},0);
								$("#isCutImg").val(isCutImg);
								$("#headImgUrl").val(hiddenImgUrl);
							}
						}
					}).showModal();
					return false;
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
<input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}"/>
<form id="addAdvert" method="post">
	<input type="hidden"  name="advertId" value="${record.advertId}" />
	<input type="hidden" id="isCutImg" value="Y"/>
	<input type="hidden" id="linkType" value="${linkType}"/>

	<c:choose>
		<c:when test="${linkType != 'APP'}">
			<div class="site">
				<em>您现在所在的位置：</em>推荐管理 &gt; Web端 &gt;添加修改广告
			</div>
		</c:when>
		<c:otherwise>
			<div class="site">
				<em>您现在所在的位置：</em>推荐管理 &gt; App端 &gt;添加修改广告
			</div>
		</c:otherwise>
	</c:choose>
      <div class="site-title">添加广告</div>
      <div class="main-publish">
          <table width="100%" class="form-table">

			  <tr>
				  <td class="td-title"><span class="red">*</span>位置：</td>
				  <td class="td-select">
					  <div class="select-box w240">
						  <input type="hidden" id="displayPosition" name="displayPosition" value="${record.displayPosition}" />
						  <div class="select-text" data-value="" id="sortDiv">选择位置</div>
						  <ul class="select-option">
							  <c:if test="${linkType != 'APP'}">
								  <li data-option="1" data-imgSize="750*400">首页轮播图</li>
								  <li data-option="2" data-imgSize="1200*530">场馆列表轮播图</li>
							  </c:if>
							  <c:if test="${linkType=='APP'}">
								  <li data-option="1" data-imgSize="750*400">首页轮播图</li>
								  <li data-option="3" data-imgSize="750*150">近期活动广告位</li>
							  </c:if>
						  </ul>
					  </div>
				  </td>
			  </tr>

			  <c:choose>
				  <c:when test="${linkType == 'APP'}">
					  <input type="hidden" id="advertPos" name="advertPos" value="0" />
				  </c:when>
				  <c:otherwise>
					  <tr id="city-select">
						  <td  class="td-title"><span class="red">*</span>区县：</td>

						  <c:choose>

							  <c:when test="${not empty areaName}">
								  <td class="td-input">
									  <input type="hidden" id="advertPos" name="advertPos" value="${siteId}" />
									  <input type="text" value="${areaName}" class="input-text w220" readonly="readonly"/>
								  </td>
							  </c:when>

							  <c:otherwise>
								  <td class="td-select">
									  <div class="select-box w240">
										  <input type="hidden" id="advertPos" name="advertPos" value="${record.advertSite}"/>
										  <div id="CarouselList" class="select-text" data-value="">所有轮播图</div>
										  <ul class="select-option" id="areaDiv">
												  <%--<li data-option="0">App首页轮播图</li>--%>
											  <li data-option="45">上海市轮播图</li>
											  <li data-option="46">黄浦区轮播图</li>

											  <li data-option="48">徐汇区轮播图</li>
											  <li data-option="49">长宁区轮播图</li>
											  <li data-option="50">静安区轮播图</li>
											  <li data-option="51">普陀区轮播图</li>
											  <li data-option="52">闸北区轮播图</li>

											  <li data-option="53">虹口区轮播图</li>
											  <li data-option="54">杨浦区轮播图</li>
											  <li data-option="55">闵行区轮播图</li>
											  <li data-option="56">宝山区轮播图</li>
											  <li data-option="57">嘉定区轮播图</li>

											  <li data-option="58">浦东新区轮播图</li>
											  <li data-option="59">金山区轮播图</li>
											  <li data-option="60">松江区轮播图</li>
											  <li data-option="61">青浦区轮播图</li>
											  <li data-option="63">奉贤区轮播图</li>
											  <li data-option="64">崇明县轮播图</li>
										  </ul>
									  </div>
								  </td>
							  </c:otherwise>

						  </c:choose>
					  </tr>

				  </c:otherwise>

			  </c:choose>
			  <tr>
				  <td class="td-title"><span class="red">*</span>排序：</td>
				  <td class="td-select" id="PromptMessger">
					  <div class="select-box w240">
						  <input type="hidden" id="advertPosSort" name="advertPosSort" value="${record.advertPosSort}" />
						  <div class="select-text" data-value="" id="sortDiv">选择排序</div>
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
				  <td  class="td-title"><span class="red">*</span>标题：</td>
				  <td class="td-input">
					  <input type="text" id="advertTitle" name="advertTitle"
							 value="${record.advertTitle}" class="input-text w220" maxlength="10"/>
				  </td>
			  </tr>
			  <tr>
				  <td  class="td-title">标题简介：</td>
				  <td class="td-input">
					  <input type="text" id="advertContent" name="advertContent"
							 value="${record.advertContent}" class="input-text w220" maxlength="30"/>
				  </td>
			  </tr>
			  <tr <c:if test="${empty record.advertRecDes}"> style="display: none"</c:if>  id="sbuject">
				  <td class="td-title">广告栏目：</td>
				  <td>
					  <c:forEach items="${dictList}" var="t">
						  <input type="radio" value="${t.dictId}" name="advertRecDes" id="p${t.dictId}" <c:if test="${t.dictId eq record.advertRecDes}">checked="checked"</c:if> />
						  <label for="p${t.dictId}">${t.dictName}</label>&nbsp;&nbsp;&nbsp;&nbsp;
					  </c:forEach>
				  </td>
			  </tr>
			  <tr>
				  <td  class="td-title"><span class="red">*</span>广告链接：</td>
				  <td class="td-input" >
					  <input type="text" id="advertConnectUrl" name="advertConnectUrl"
							 value="${record.advertConnectUrl}" class="input-text w220"/>
				  </td>
			  </tr>

			  <tr>
				  <td width="100" class="td-title"><span class="red">*</span>上传封面：</td>
				  <td class="td-upload td-coordinate"><%-- class="td-upload"--%>
					  <input type="hidden"  name="advertPicUrl" id="headImgUrl" value="${record.advertPicUrl}"  />
					  <input type="hidden" name="uploadType" value="Img" id="uploadType" />

					  <div class="img-box">
						  <div  id="imgHeadPrev"  class="img">

						  </div>
					  </div>
					  <div class="controls-box">
						  <div style="height: 46px;">
							  <div class="controls" style="float:left;">
								  <input type="file" name="file" id="file" />
							  </div>
							  <c:choose>
								  <c:when test="${linkType == 'APP'}">
									  <c:choose>
										  <c:when test="${record.displayPosition == 3}">
											  <span class="upload-tip">建议尺寸:<span id="messageTip">750*150</span>像素</span>
										  </c:when>
										  <c:otherwise>
											  <span class="upload-tip">建议尺寸:<span id="messageTip">750*400</span>像素</span>
										  </c:otherwise>
									  </c:choose>
								  </c:when>
								  <c:otherwise>
									  <span class="upload-tip">建议尺寸:首页轮播图<span id="messageTip">750*400</span>像素</span>
								  </c:otherwise>
							  </c:choose>
						  </div>
					  </div>
				  </td>
			  </tr>
			  <%--<tr>
				  <td width="100" class="td-title"></td>
				  <td class="td-upload td-cut">
					  <input type="file" name="file" id="file" />
					  <c:choose>
						  <c:when test="${linkType == 'APP'}">
							  <c:choose>
								  <c:when test="${record.displayPosition == 3}">
									  <span style="display: block;">建议尺寸:<span id="messageTip">750*150</span>像素</span>
								  </c:when>
								  <c:otherwise>
									  <span style="display: block;">建议尺寸:<span id="messageTip">750*400</span>像素</span>
								  </c:otherwise>
							  </c:choose>
						  </c:when>
						  <c:otherwise>
							  <span style="display: block;">建议尺寸:首页轮播图<span id="messageTip">800*500</span>像素</span>
						  </c:otherwise>
					  </c:choose>
				  </td>
			  </tr>--%>

			  <c:if test="${linkType == 'APP'}">
			  <tr>
				  <td width="100" class="td-title">广告内容：</td>
				  <td class="td-content" id="advertDescribeLabel">
					  <div class="editor-box">
						  <textarea name="advertDescribe" id="advertDescribe">${record.advertDescribe}</textarea>
					  </div>
				  </td>
			  </tr>
			  </c:if>

              <tr class="td-btn">
                  <td></td>
                  <td>
                      <input type="button" value="发布" class="btn-save" />
                      <input type="button" value="返回" class="btn-publish btn-cancel" onclick="javascript:history.back(-1)" />
                  </td>
              </tr>
          </table>
      </div>
  </form>
</body>
</html>
