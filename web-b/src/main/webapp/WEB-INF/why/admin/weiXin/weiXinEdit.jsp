<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="s" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title>修改场馆--文化云</title>

	<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
	<%@include file="/WEB-INF/why/common/limit.jsp"%>
	<script type="text/javascript" src="${path}/STATIC/layer/layer.js"></script>
    <script type="text/javascript" src="${path}/STATIC/layer/extend/layer.ext.js"></script>
	<!--文本编辑框 end-->
	<!-- dialog start -->
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
	<script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/admin/venue/editVenue.js?version=20151119"></script>
	<script type="text/javascript" src="${path}/STATIC/js/admin/venue/UploadVenueImg.js?version=201511101033"></script>
	<script type="text/javascript" src="${path}/STATIC/js/admin/venue/UploadVenueAudio.js?version=201511101033"></script>
	<script type="text/javascript" src="http://api.map.baidu.com/api?v=1.3"></script>
	<script type="text/javascript">

		window.onload = function(){
			var editor = CKEDITOR.replace( 'venueMemo' );
		}
		/**
		 * Created by cj on 2015/7/2.
		 */
		seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
			window.dialog = dialog;
		});

		window.console = window.console || {log:function () {}}



		// 省市区
		function getArea(){
			var venueProvince='${cmsVenue.venueProvince}';
			var venueCity='${cmsVenue.venueCity}';
			var venueArea='${cmsVenue.venueArea}';
			if(venueProvince!=undefined&&venueCity!=undefined&&venueArea!=undefined){
				//省市区
				showVenueLocation(venueProvince.split(",")[0],venueCity.split(",")[0],venueArea.split(",")[0]);
				$("#loc_province").select2("val", venueProvince.split(",")[0]);
				$("#loc_city").select2("val", venueCity.split(",")[0]);
				$("#loc_town").select2("val",  venueArea.split(",")[0]);
			}else {
				showVenueLocation();
			}
		}

		//显示省市区
		function showVenueLocation(province , city , town) {
			var loc	= new Location();
			var title	= ['省' , '市' , '区'];
			$.each(title , function(k , v) {
				title[k]	= '<option value="">'+v+'</option>';
			});

			$('#loc_province').append(title[0]);
			$('#loc_city').append(title[1]);
			$('#loc_town').append(title[2]);

			$("#loc_province,#loc_city,#loc_town").select2()
			$('#loc_province').change(function() {
				$('#loc_city').empty();
				$('#loc_city').append(title[1]);
				loc.fillOption('loc_city' , '0,'+$('#loc_province').val());
				$('#loc_city').change()
			});

			$('#loc_city').change(function() {
				$('#loc_town').empty();
				$('#loc_town').append(title[2]);
				loc.fillOption('loc_town' , '0,' + $('#loc_province').val() + ',' + $('#loc_city').val());
			});

			$('#loc_town').change(function() {
				var userProvince = $("#loc_province").find("option:selected").val() +","+$("#loc_province").find("option:selected").text();
				var userCity = $("#loc_city").find("option:selected").val() +","+$("#loc_city").find("option:selected").text();
				var userArea = $("#loc_town").find("option:selected").val() +","+$("#loc_town").find("option:selected").text();
				// 位置字典根据区域变更
				dictLocation($("#loc_town").find("option:selected").val());
			});

			if (province) {
				loc.fillOption('loc_province' , '0' , province);
				if (city) {
					loc.fillOption('loc_city' , '0,'+province , city);
					if (town) {
						loc.fillOption('loc_town' , '0,'+province+','+city , town);
					}
				}
			} else {
				loc.fillOption('loc_province' , '0');
			}
		}

		$(function() {
			var venueVoiceUrl = $("#venueVoiceUrl").val();
			if(venueVoiceUrl != undefined && venueVoiceUrl != ""){
				$("#loadVoice").attr("href",getImgUrl(venueVoiceUrl));
				/*if(venueVoiceUrl.indexOf("http") == -1){
					$("#loadVoice").attr("href",getImgUrl(venueVoiceUrl));
				}else{
					$("#loadVoice").attr("href",venueVoiceUrl);
				}*/
			}

			//显示省市区
			getArea();

			//人群标签
			$.post("${path}/tag/getChildTagByType.do?code=VENUE_TYPE", function(data) {
				var list = eval(data);
				var tagHtml = '';
				var tagIds = $("#venueType").val();
				var ids = '';
				if (tagIds.length > 0) {
					ids = tagIds.substring(0, tagIds.length).split(",");
				}
				for (var i = 0; i < list.length; i++) {
					var obj = list[i];
					var tagId = obj.tagId;
					var tagName = obj.tagName;
					var result = false;
					if (ids != '') {
						for (var j = 0; j <ids.length; j++) {
							if (list[i].tagId == ids[j]) {
								result = true;
								break;
							}
						}
					}
					var cl = '';
					if (result) {
						cl = 'class="cur"';
					}
					tagHtml += '<a ' + cl + 'onclick="setVenueSingle(\''
					+ tagId + '\',\'venueType\')">' + tagName
					+ '</a>';
				}
				$("#venueTypeLabel").html(tagHtml);
				tagSelectSingle("venueTypeLabel");
			});

			//人群标签
			/*$.post("../tag/getChildTagByType.do?code=VENUE_CROWD", function(data) {
				var list = eval(data);
				var tagHtml = '';
				var tagIds = $("#venueCrowd").val();
				var ids = '';
				if (tagIds.length > 0) {
					ids = tagIds.substring(0, tagIds.length - 1).split(",");
				}
				for (var i = 0; i < list.length; i++) {
					var obj = list[i];
					var tagId = obj.tagId;
					var tagName = obj.tagName;
					var result = false;
					if (ids != '') {
						for (var j = 0; j <ids.length; j++) {
							if (list[i].tagId == ids[j]) {
								result = true;
								break;
							}
						}
					}
					var cl = '';
					if (result) {
						cl = 'class="cur"';
					}
					tagHtml += '<a ' + cl + 'onclick="setVenueTag(\''
					+ tagId + '\',\'venueCrowd\')">' + tagName
					+ '</a>';
				}
				$("#venueCrowdLabel").html(tagHtml);
				tagSelect("venueCrowdLabel");
			});*/

			dictLocation('${fn:substringBefore(cmsVenue.venueArea,",")}');
		});


		function dictLocation(code){
			if('${fn:substringBefore(cmsVenue.venueArea,",")}' == code){
				$("#venueMood").val('${cmsVenue.venueMood}');
			}else{
				$("#venueMood").val("");
			}
			// 位置字典
			$.post("${path}/sysdict/queryChildSysDictByDictCode.do",{dictCode:code}, function(data) {
				var list = eval(data);
				var dictHtml = '';
				var otherHtml = '';
				var tid = $("#venueMood").val();
				for (var i = 0; i < list.length; i++) {
					var obj = list[i];
					var dictId = obj.dictId;
					var dictName = obj.dictName;
					var result = false;
					if (tid == dictId) {
						result = true;
					}
					var cl = '';
					if (result) {
						cl = 'class="cur"';
					}

					if(dictName == '其他'){
						otherHtml = '<a '+cl+' onclick="setVenueDict(\''
						+ dictId + '\',\'venueMood\')">' + dictName
						+ '</a>';
						continue;
					}
					dictHtml += '<a '+cl+' onclick="setVenueDict(\''
					+ dictId + '\',\'venueMood\')">' + dictName
					+ '</a>';
				}
				$("#venueMoodLabel").html(dictHtml + otherHtml);
				tagSelectDict("venueMoodLabel");
			});
		}

		function setVenueDict(value,id){
			$("#"+id).val(value);
			$('#'+id).find('a').removeClass('cur');
		}

		function tagSelectDict(id) {
			/* tag标签选择 */

			$('#'+id).find('a').click(function() {
				$('#'+id).find('a').removeClass('cur');
				$(this).addClass('cur');
			});
		}

		$(function(){
			selectModel();
			//小时
			var venueOpenTime = $("#venueOpenTime").val();
			var venueEndTime = $("#venueEndTime").val();
			var venueOpenHour = venueOpenTime.substring(0,venueOpenTime.indexOf(":"));
			var venueOpenMin = venueOpenTime.substring(venueOpenTime.indexOf(":")+1,venueOpenTime.length);
			var venueEndHour = venueEndTime.substring(0,venueEndTime.indexOf(":"));
			var venueEndMin = venueEndTime.substring(venueEndTime.indexOf(":")+1,venueEndTime.length);

			$("#venueOpenHour").val(venueOpenHour);
			$("#venueOpenMin").val(venueOpenMin);
			$("#venueEndHour").val(venueEndHour);
			$("#venueEndMin").val(venueEndMin);

			$("#venueOpenHour").next().html(venueOpenHour);
			$("#venueOpenMin").next().html(venueOpenMin);
			$("#venueEndHour").next().html(venueEndHour);
			$("#venueEndMin").next().html(venueEndMin);

			$.post("${path}/venue/getVenueHours.do",
				function(data) {
					if (data != '' && data != null) {
						var json = $.parseJSON(data);
						var list=json.data;
						var ulHtml = '';
						for (var i = 0; i < list.length; i++) {
							ulHtml += '<li data-option="'+ list[i]+'">'+ list[i] + '</li>';
						}
						$('#venueOpenHourUl').html(ulHtml);
						$('#venueEndHourUl').html(ulHtml);
					}
				})
			//分钟
			$.post("${path}/venue/getVenueMin.do",
				function(data) {
					if (data != '' && data != null) {
						var json = $.parseJSON(data);
						var list=json.data;
						var ulHtml = '';
						for (var i = 0; i < list.length; i++) {
							ulHtml += '<li data-option="'+ list[i]+'">'+ list[i] + '</li>';
						}
						$('#venueOpenMinUl').html(ulHtml);
						$('#venueEndMinUl').html(ulHtml);
					}
				})
		});

		//提交与发布草稿按钮对应事件
		$(function() {
			$(".btn-save").on("click", function(){

				if($(this).val() == "返回"){
					history.back(-1);
				}else if($(this).val() == "保存草稿"){

					var isCutImg =$("#isCutImg").val();
					if("N"==isCutImg) {
						dialogAlert("提示","请上传尺寸不小于750*500(px)的图片",function(){
						});
						return;
					}

					//检查字段是否满足格式
					var checkResult = checkSave();
					if(checkResult){
						$("#venueState").val(1);
						setDefaultVal();
						var html = "";
						$.post("${path}/venue/editVenue.do", $("#editVenueForm").serialize(),
							function(data) {
								if (data != "failure" && data != "repeat") {
									html = "<h2>保存成功!</h2><p>";
									dialogSaveDraft("提示", html, function(){
										window.location.href = "${path}/venue/venueDraftList.do";
									})
								}else if(data == "failure") {
									html = "<h2>保存失败!</h2>";
									dialogSaveDraft("提示", html, function(){
										window.location.href = "${path}/venue/venueDraftList.do";
									})
								}else{
									html = "<h2>场馆名称不能重复！</h2>";
									dialogSaveDraft("提示", html, function(){
									})
								}
							});
					}
				}
			});

			$(".btn-publish").on("click", function(){

				var isCutImg =$("#isCutImg").val();
				if("N"==isCutImg) {
					dialogAlert("提示","请上传尺寸不小于750*500(px)的图片",function(){
					});
					return;
				}

				//检查字段是否满足格式
				var checkResult = checkSave();
				if(checkResult){
					$("#venueState").val(6);
					setDefaultVal();
					var html = "";
					$.post("${path}/venue/editVenue.do", $("#editVenueForm").serialize(),
						function(data) {
							if (data != "failure" && data != "repeat") {
								var venueHasRoom = $("input[name='venueHasRoom']:checked").val();
								var venueHasAntique = $("input[name='venueHasAntique']:checked").val();

								if(venueHasRoom != 2 && venueHasAntique != 2){
									html = "<h2>发布成功!</h2>";
								}
								if(venueHasRoom == 2 && venueHasAntique != 2){
									html = "<h2>发布成功!</h2><p>您还可以："+
									"<a href='${path}/activityRoom/preAddActivityRoom.do?venueId=" +data+ "'>添加活动室</a></p>";
								}
								if(venueHasRoom != 2 && venueHasAntique == 2){
									html = "<h2>发布成功!</h2><p>您还可以："+
									"<a href='${path}/antique/preAddAntique.do?venueId=" +data+ "'>添加馆藏</a></p>";
								}
								if(venueHasRoom == 2 && venueHasAntique == 2){
									html = "<h2>发布成功!</h2><p>您还可以："+
									"<a href='${path}/activityRoom/preAddActivityRoom.do?venueId=" +data+ "'>添加活动室</a>"+
									"或<a href='${path}/antique/preAddAntique.do?venueId=" +data+ "'>添加馆藏</a></p>";
								}
								dialogSaveDraft("提示", html, function(){
									window.location.href = "${path}/venue/venueIndex.do";
								})
							}else if(data == "failure") {
								html = "<h2>保存失败!</h2>";
								dialogSaveDraft("提示", html, function(){
									window.location.href = "${path}/venue/venueIndex.do";
								})
							}else{
								html = "<h2>场馆名称不能重复！</h2>";
								dialogSaveDraft("提示", html, function(){
									/*经产品确认不做跳转*/
									<%--window.location.href = "${path}/venue/venueIndex.do";--%>
								})
							}
						});
				}
			});

			//获取经纬度
			$('#getMapAddressPoint').on('click', function () {
				var address =$('#venueAddress').val();
				dialog({
					url: '${path}/activity/queryMapAddressPoint.do?address='+encodeURI(encodeURI(address)),
					title: '获取经纬度',
					width: 800,
					fixed: true,
					onclose: function () {
						if(this.returnValue){

							$('#venueLon').val(this.returnValue.xPoint);
							$("#venueLat").val(this.returnValue.yPoint);
						}
						//dialog.focus();
					}
				}).showModal();
				return false;
			});
		});


		seajs.config({
			alias: {
				"jquery": "jquery-1.10.2.js"
			}
		});

		seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
			window.dialog = dialog;
		});
		seajs.use(['jquery'], function ($) {


			$('.upload-cut-btn').on('click', function () {
				var cutImageSize;
				var width;
				var height;
				cutImageSize="750*500";

				var urlStr = $("#venueIconUrl").val();

				var url =getImgUrl(urlStr);
				dialog({
					url: '${path}/att/toCutImgJsp.do?imageURL='+url+'&cutImageSize='+cutImageSize,
					title: '图片裁剪',
					fixed: false,
					onclose: function () {
						if(this.returnValue){
							//alert("返回值：" + this.returnValue.imageUrl);
							$("#imgHeadPrev").html(getImgHtml(this.returnValue.imageUrl));
							$("#venueIconUrl").val(this.returnValue.imageUrl);
						}
					}
				}).showModal();
				return false;
			});
		});


	</script>
	<!-- dialog end -->
</head>
<body>
<%--2015.11.6 niu  add  避免火狐下session丢失--%>
<div class="site">
	<em>您现在所在的位置：</em>微信管理 &gt; 自动回复&gt; 修改自动回复
</div>
<div class="site-title">修改自动回复</div>
<form method="post" id="editVenueForm">
<%-- 基础路径 --%>
<div class="main-publish">
	<table width="100%" class="form-table">
		<tr>
			<td width="100" class="td-title"><span class="red">*</span>自动回复内容：</td>
			<td class="td-input" id="venueNameLabel">
			<textArea id="autoContent" name="autoContent" rows="5" cols="100">${weiXin.autoContent}</textArea>
				<span class="error-msg"></span>
			</td>
		</tr>
		
		<tr>
			<td width="100" class="td-title"></td>
			<td class="td-btn">
				<input type="hidden" id="weiXinId" name="weiXinId" value="${weiXin.weiXinId}"/>
				<input class="btn-save" type="button" value="返回" onclick="javascript:history.back(-1);"/>
				<input class="btn-publish" type="button" value="保存修改"/>
			</td>
		</tr>
	</table>
</div>
</form>

</body>
<script type="text/javascript">
$(".btn-publish").on("click", function(){
 	$.post("${path}/weiXin/editWeiXin.do", $("#editVenueForm").serialize(),
 	
						function(data) {
							if (data != "failure") {
                                   html = "<h2>修改成功!</h2>";
								dialogSaveDraft("提示", html, function(){
									window.location.href = "${path}/weiXin/weiXinIndex.do";
								});
							}else{
								html = "<h2>修改失败！</h2>";
								dialogSaveDraft("提示", html, function(){
									/*经产品确认不做跳转*/
									<%--window.location.href = "${path}/venue/venueIndex.do";--%>
								})
							}
						});
})
</script>
</html>