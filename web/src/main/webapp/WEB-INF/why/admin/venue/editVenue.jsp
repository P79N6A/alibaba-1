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

			//类型标签
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
					var cl = 'class="tagType"';
					if (result) {
						cl = 'class="cur tagType"';
					}
					tagHtml += '<a id="'+tagId+'" '+cl+'  onclick="setVenueSingle(\''
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
			
			 $(".form-table .td-fees").on("click", "input[type=radio][name=venueIsFree]", function(){
                 if($(this).val() == "yes"){
                    $(".extra").show();
                 }else{
                	 $(".extra").hide();
                 }
             });

			dictLocation('${fn:substringBefore(cmsVenue.venueArea,",")}');
			
			var venueTags='${venueTags}';
			
			var venueTagArray=venueTags.split(",");
			
		 	//通用标签
            $.post("${path}/tag/getCommonTag.do?type=1", function (data) {
                var list = eval(data);
                var tagHtml = '';
                var commonTagArray=new Array();
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var tagId = obj.tagSubId;
                    var tagName = obj.tagName;
                    
                    var cl = '';
                    
                    if($.inArray(tagId,venueTagArray)>-1)
                    {
                    	commonTagArray.push(tagId);
                    	
                    	cl = 'class="cur"';
                    }
                    
                    tagHtml += '<a '+cl+' onclick="setVenueTag(\''
                            + tagId + '\',\'commonTag\')">' + tagName
                            + '</a>';
                }
                $("#commonTagLabel").html(tagHtml);
                tagSelect("commonTagLabel");
                
                if(commonTagArray.length>0)
            		$("#commonTag").val(commonTagArray.join(",")+",");
            });
		 	
            var venueType = $("#venueType").val();
            
            $.post("${path}/tag/getTagSubByTagId.do?tagId="+venueType, function (data) {
                var list = eval(data);
                var tagHtml = '';
                var childTagArray=new Array();
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var tagId = obj.tagSubId;
                    var tagName = obj.tagName;
                    var cl = 'class="tagType"';
                    
                    if($.inArray(tagId,venueTagArray)>-1)
                    {
                    	childTagArray.push(tagId);
                    	
                    	cl = 'class="cur"';
                    }
                    
                    tagHtml += '<a id="'+tagId+'" '+cl+' onclick="setVenueTag(\''
                            + tagId + '\',\'childTag\')">' + tagName
                            + '</a>';
                }
                $("#childTagLabel").html(tagHtml);
                tagSelect("childTagLabel");
                
                if(childTagArray.length>0)
            	$("#childTag").val(childTagArray.join(",")+",");
            });
            
		 	
			$("#venueTypeLabel").on("click",".tagType", function () { 
          		
          		var tagId=$(this).attr("id");
          		
          	  //类型标签
              $.post("${path}/tag/getTagSubByTagId.do?tagId="+tagId, function (data) {
                    var list = eval(data);
                    var tagHtml = '';
                    for (var i = 0; i < list.length; i++) {
                        var obj = list[i];
                        var tagId = obj.tagSubId;
                        var tagName = obj.tagName;
                        var cl = '';
                        cl = 'class="cur"';
                        tagHtml += '<a id="'+tagId+'" class="tagType" onclick="setVenueTag(\''
                                + tagId + '\',\'childTag\')">' + tagName
                                + '</a>';
                    }
                    $("#childTagLabel").html(tagHtml);
                    $("#childTag").val("");
                    tagSelect("childTagLabel");
                });
          	});
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
				
			         // 配套设施，并选中
            $.post("${path}/sysdict/queryChildSysDictByDictCode.do?dictCode=VENUE_FACILITY", function(data) {
                var list = eval(data);
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var dictId = obj.dictId;
                    var dictName = obj.dictName;
                    $("#venueFacilityLabel").append('<label><input onclick="setvenueFacility()" id="'+dictId+'" name="venueFacilityLabel" type="checkbox" value="'+dictId+'"/><em>'+dictName+'</em></label>');
                	
                    var idsStr = $("#venueFacility").val();
                    if (idsStr.length > 0) {
                        ids = idsStr.substring(0, idsStr.length - 1).split(",");
                        if(ids.length == list.length){	//确认是否已全选
                        	$('#venueFacilityAll').attr("checked",'true');
                        }
                       	for (var j = 0; j <ids.length; j++) {	//选中已选
                             if (dictId == ids[j]) {
                             	$('#'+dictId).attr("checked",'true');
                             	break;
                             }
                         }
                    }
                }
                
                //添加与全选键的联动
                var $subBox = $("input[name='venueFacilityLabel']");
                $subBox.click(function(){
                	if($subBox.length == $("input[name='venueFacilityLabel']:checked").length){
                		$("#venueFacilityAll").attr("checked",'true');
                	}else{
                		$("#venueFacilityAll").get(0).checked = false;
                	}
                });
            });
	         
	            $("#venueFacilityAll").click(function() {
	            	//复选框全选
	                $('input[name="venueFacilityLabel"]').prop("checked",this.checked); 
	                setvenueFacility();
	            });
		});
		
        //配套设施赋值
        function setvenueFacility(){
        	var dictIds =$("input[name='venueFacilityLabel']");
        	var dictIdsStr = '';
        	for(var i=0;i<dictIds.length;i++){
	        	if(dictIds[i].checked){
	        		dictIdsStr += dictIds[i].value + ",";
        		}
        	}
        	$("#venueFacility").val(dictIdsStr);
        }

		//提交与发布草稿按钮对应事件
		$(function() {
			$(".btn-save").on("click", function(){

				if($(this).val() == "返回"){
					history.back(-1);
				}else if($(this).val() == "保存草稿"){

					//检查字段是否满足格式
					var checkResult = checkSave();
					if(checkResult){
						
						var isCutImg =$("#isCutImg").val();
						if("N"==isCutImg) {
							dialogAlert("提示","请先裁剪系统要求尺寸(750*500)的图片，再提交！",function(){
							});
							return;
						}
						
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

			$("#btnPublish").on("click", function(){

				//检查字段是否满足格式
				var checkResult = checkSave();
				if(checkResult){
					
					var isCutImg =$("#isCutImg").val();
					if("N"==isCutImg) {
						dialogAlert("提示","请先裁剪系统要求尺寸(750*500)的图片，再提交！",function(){
						});
						return;
					}
					
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
			
			$(".btn-preview").on("click", function(){
            	
            	var tagArray=new Array();
            	
            	$("#venueTypeLabel .cur").each(function(index,item){
            		var tagName=$(this).html();
            		tagArray.push(tagName)
                });
            	
            	$("#commonTagLabel .cur").each(function(index,item){
            		var tagName=$(this).html();
            		tagArray.push(tagName)
                });
            	
            	$("#childTagLabel .cur").each(function(index,item){
            		var tagName=$(this).html();
            		tagArray.push(tagName)
                });
            	
            	$("#roomTagName").val(tagArray.join(","))
            	
            	var venueOpenHour = $("#venueOpenHour").val();
			    var venueOpenMin = $("#venueOpenMin").val();
			    var venueEndHour = $("#venueEndHour").val();
			    var venueEndMin = $("#venueEndMin").val();
			
			    var venueOpenTime = venueOpenHour + ":" + venueOpenMin;
			    var venueEndTime = venueEndHour + ":" + venueEndMin;
			    $("#venueOpenTime").val(venueOpenTime);
			    $("#venueEndTime").val(venueEndTime);
            	
            	$("#editVenueForm").submit();
            });
			
			 $(".form-table .td-fees").on("click", "input[type=radio][name=venueHasMetro]", function(){
	            	var val=$(this).val();
	            	
	            	if(val=="2"){
	            		$("#metroLine").show();
	            	}
	            	else
	            		$("#metroLine").hide();
	            });
	            
	            $(".form-table .td-fees").on("click", "input[type=radio][name=venueHasBus]", function(){
	            	var val=$(this).val();
	            	
	            	if(val=="2"){
	            		$("#busLine").show();
	            	}
	            	else
	            		$("#busLine").hide();
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

		function searchInitImage(){
			var imgaeInitUrl = $("#venueIconUrl").val();
			var url = getImgUrl(imgaeInitUrl);
			var html='<img src="'+url+'" target="_blank"/>';
			//document.write(html);
			dialogInitImgConfirm("原图", html, function(){

			})
		}
	</script>
	<!-- dialog end -->
</head>
<body>
<%--2015.11.6 niu  add  避免火狐下session丢失--%>
<input type="hidden" id="sessionId" value="${pageContext.session.id}" />
<input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}" />
<input type="hidden" id="isCutImg" value="Y"/>
<div class="site">
	<em>您现在所在的位置：</em>场馆管理 &gt; 场馆信息管理&gt; 修改场馆
</div>
<div class="site-title">场馆发布</div>
<form method="post" id="editVenueForm" action="previewVenue.do" target="blank">

	<input type="hidden" id="roomTagName" name="roomTagName" />
<%-- 基础路径 --%>
<div class="main-publish">
	<table width="100%" class="form-table">
		<tr>
			<td width="100" class="td-title"><span class="red">*</span>场馆名称：</td>
			<td class="td-input" id="venueNameLabel">
				<input id="venueName" name="venueName" type="text" class="input-text w510" value='<c:out value="${cmsVenue.venueName}" escapeXml="true"/>'  maxlength="20"/>
				<span class="error-msg"></span>
			</td>
		</tr>
	<!--<tr>
            <td width="100" class="td-title"><span class="red">*</span>场馆星级：</td>
            <input type="hidden" name="venueStars"  id="venueStars" value="${cmsVenue.venueStars}" />
            <td>
				<div class="star_list">
				  <ul class="star_score" style="float:left;">
				    <li><a href="javascript:void(0)" class="star1">0.5</a></li>
				    <li><a href="javascript:void(0)" class="star2">1</a></li>
				     <li><a href="javascript:void(0)" class="star3">1.5</a></li>
				    <li><a href="javascript:void(0)" class="star4">2</a></li>
				     <li><a href="javascript:void(0)" class="star5">2.5</a></li>
				    <li><a href="javascript:void(0)" class="star6">3</a></li>
				     <li><a href="javascript:void(0)" class="star7">3.5</a></li>
				    <li><a href="javascript:void(0)" class="star8">4</a></li>
				     <li><a href="javascript:void(0)" class="star9">4.5</a></li>
				    <li><a href="javascript:void(0)" class="star10">5</a></li>
				  </ul>
				  <p style="float:left;"><span id="fenshu">${cmsVenue.venueStars}</span> 分</p>
				  <span id="venueStarsLabel" style="margin-left: 20px;"></span>
				</div>
				<script>
				var aa=$(".star_score a");
				aa.each(function(index, element) {
					var scor=$(this).text();
					var stars = '${cmsVenue.venueStars}';
					if(scor == stars){
						var n=parseInt(index)+1;
						 var lefta=index*16;
						 var ww=16*n;

						 $(".star_score a").removeClass("clibg");
						 $(this).addClass("clibg");
						 $(this).css({"width":ww,"left":"0"});
					}

				     $(this).click(function(){
						 var scor=$(this).text();
						 var n=parseInt(index)+1;
						 var lefta=index*16;
						 var ww=16*n;

						 $(".star_score a").removeClass("clibg");
						 $(this).addClass("clibg");
						 $(this).css({"width":ww,"left":"0"});
					     $("#fenshu").text(scor);
					     $("#venueStars").val(scor);
						 });
				});

				</script>
            </td>
        </tr>
         -->
		<tr>
			<td width="100" class="td-title"><span class="red">*</span>上传封面：</td>
			<td class="td-upload" id="venueIconUrlLabel">
			  <input type="text" id="venueIconUrlMessage" style="position: absolute; left: -9999px;"/>
				<table>
					<tr>
						<td>
							<input type="hidden"  name="venueIconUrl" id="venueIconUrl" value="${cmsVenue.venueIconUrl}">
							<input type="hidden" name="uploadType" value="Img" id="uploadType"/>
							<div class="img-box">
								<div  id="imgHeadPrev" class="img"> </div>
							</div>
							<div class="controls-box">
								<div style="height: 46px;position:relative;">
									<div class="controls" style="float:left;">
										<input type="file" name="file" id="file">
									</div>
									<input type="button" class="upload-cut-btn" onclick="searchInitImage();" value="查看原图" style="width:102px;height:48px;position:absolute;bottom:50px;left:-10px;"/>
									<span class="upload-tip">可上传1张图片，建议尺寸750*500像素，格式为jpg,jpeg,png,gif，大小不超过2M</span>
								</div>
								<div id="fileContainer"></div>
								<div id="btnContainer" style="display: none;">
									<a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>
								</div>
							</div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
		  <td class="td-title">
			  <span class="red">*</span> 组织机构：
		  </td>
		  <td class="td-input" id="userDeptIdLable">
			  <script type="text/javascript">
				  //iframe层-父子操作
				  function selectDept() {
					  layer.open({
						  type: 2,
						  title: '请选择部门',
						  area: ['450px', '440px'],
						  fix: false, //固定
						  maxmin: true,
						  content: '${path}/user/selectDept.do?type=venue'
					  });
				  }
			  </script>
			  <input type="hidden" name="venueParentDeptId" id="venueParentDeptId" value="${cmsVenue.venueParentDeptId}"/>
			  <input data-val="输入用户部门"  class="input-text" type="text" name="venueParentDeptName" id="venueParentDeptName" value="${cmsVenue.venueParentDeptName}"  readonly />
			  <c:if test="${sessionScope.user != null && sessionScope.user.userIsManger!=4}">
			  	<input type="button"  value="点击选择部门" id="parentIframe" class="upload-btn" onclick="selectDept()"/>
			  </c:if>
		  </td>
	    </tr>
	    <tr>
			<td width="100" class="td-title"><span class="red">*</span>权限标签：</td>
			<td class="td-input td-fees" id="venueDeptLableId">
				<c:if test="${user.userLabel1== '1' }">
				<label>
					<input type="radio" name="venueDeptLable" <c:if test="${cmsVenue.venueDeptLable == 1}">checked="checked"</c:if> value="1"/><em>文广体系</em>
				</label>
					</c:if>
				<c:if test="${user.userLabel2== '2' }">
				<label>
					<input type="radio" name="venueDeptLable" <c:if test="${cmsVenue.venueDeptLable == 2}">checked="checked"</c:if> value="2"/><em>独立商家</em>
				</label>
				</c:if>
				<c:if test="${user.userLabel3== '3' }">
				<label>
					<input type="radio" name="venueDeptLable" <c:if test="${cmsVenue.venueDeptLable == 3}">checked="checked"</c:if> value="3"/><em>其他</em>
				</label>
				</c:if>
			</td>
		</tr>
		<tr>
			<td  class="td-title"><span class="red">*</span>所属省市区：
				<input type="text" id="venueLocMessageLabel" style="position: absolute; left: -9999px;" />
			</td>
			<td  class="td-select"  id="venueLocLabel">
				<div id="locProvinceDiv">
					<select id="loc_province" style="width: 130px;"></select>
					<input type="hidden" name="venueProvince" id="venueProvince" value="${cmsVenue.venueProvince}"/>
				</div>
				<div id="locCityDiv">
					<select id="loc_city"style="width: 130px; margin-left: 10px"></select>
					<input type="hidden" name="venueCity" id="venueCity" value="${cmsVenue.venueCity}"/>
				</div>
				<div id="locTownDiv">
					<select id="loc_town"style="width: 130px; margin-left: 10px"></select>
					<input type="hidden" name="venueArea" id="venueArea" value="${cmsVenue.venueArea}"/>
				</div>
				<script>
					var userIsManger = '${user.userIsManger}';
					if(userIsManger!=undefined&&userIsManger == 1){ // 省级管理员
						$("#loc_province").attr("disabled", true);
					}else if(userIsManger!=undefined&&userIsManger == 2){ // 市级管理员
						$("#loc_province").attr("disabled", true);
						$("#loc_city").attr("disabled", true);
					}else{ // 区级管理员和场馆级管理员
						$("#loc_province").attr("disabled", true);
						$("#loc_city").attr("disabled", true);
						$("#loc_town").attr("disabled", true);
					}
				</script>
			</td>
		</tr>
		<%--<tr>
			<td width="100" class="td-title"><span class="red">*</span>场馆标签：</td>
			<td class="td-tag" id="venueTagLabel">
				<dl>
					<dt>类型</dt>
					<input id="venueType" name="venueType" style="position: absolute; left: -9999px;" type="hidden" value="${cmsVenue.venueType}"/>
					<dd id="venueTypeLabel">
					</dd>
				</dl>
				&lt;%&ndash;<dl>
					<dt>人群</dt>
					<input id="venueCrowd" name="venueCrowd" style="position: absolute; left: -9999px;" type="hidden" value="${cmsVenue.venueCrowd}"/>
					<dd id="venueCrowdLabel">
					</dd>
				</dl>&ndash;%&gt;
				<dl>
					<dt>位置</dt>
					<input id="venueMood" name="venueMood" style="position: absolute; left: -9999px;" type="hidden" value="${cmsVenue.venueMood}"/>
					<dd id="venueMoodLabel">
					</dd>
				</dl>
			</td>
		</tr>--%>
		<tr>
			<td width="100" class="td-title"><span class="red">*</span>
				选择热区：<input id="venueMoodMessage" style="position: absolute; left: -9999px;"/>
			</td>
			<td class="td-tag">
				<dl>
					<input id="venueMood" name="venueMood" type="hidden" value="${cmsVenue.venueMood}"/>
					<dd id="venueMoodLabel">
					</dd>
				</dl>
			</td>
		</tr>
		<tr>
			<td width="100" class="td-title"><span class="red">*</span>类型(单选)：
				<input id="venueTypeMessage" style="position: absolute; left: -9999px;"/>
			</td>
			<td class="td-tag">
				<dl>
					<input id="venueType" name="venueType" type="hidden" value="${cmsVenue.venueType}"/>
					<dd id="venueTypeLabel">
					</dd>
				</dl>
			</td>
		</tr>
		  <tr>
                <td width="100" class="td-title">标签(多选)：
                    <input id="commonTagMessage" style="position: absolute; left: -9999px;"/>
                </td>
                <td class="td-tag">
                    <dl>
                        <input id="commonTag" name="commonTag" type="hidden" value="${commonTag }"/>
                        <dd id="commonTagLabel">
                        </dd>
                    </dl>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title">
                    <input id="childTagMessage" style="position: absolute; left: -9999px;"/>
                </td>
                <td class="td-tag">
                    <dl>
                        <input id="childTag" name="childTag" type="hidden" value="${childTag }"/>
                        <dd id="childTagLabel">
                        </dd>
                    </dl>
                </td>
            </tr>
		<tr>
			<td width="100" class="td-title"><span class="red">*</span>场馆地址：</td>
			<td class="td-input" id="venueAddressLabel">
				<input id="venueAddress" name="venueAddress" type="text" class="input-text w510" value='<c:out value="${cmsVenue.venueAddress}" escapeXml="true"/>' maxlength="200"/>
			</td>
		</tr>
		<tr>
			<td width="100" class="td-title"><span class="red">*</span>地图坐标：</td>
			<td class="td-input td-coordinate" id="venueMapLabel">
				<input id="venueLon" name="venueLon" type="text" class="input-text w120 lon_value" value="${cmsVenue.venueLon}" maxlength="15" readonly/><span class="txt">X</span>
				<input id="venueLat" name="venueLat" type="text" class="input-text w120 let_value" value="${cmsVenue.venueLat}"  maxlength="15" readonly/><span class="txt">Y</span>
				<input type="button" class="upload-btn" id="getMapAddressPoint" value="查询坐标"/>
				<span class="error-msg"></span>
			</td>
		</tr>
		<!-- <tr>
			<td width="100" class="td-title">联系人：</td>
			<td class="td-input" id="venueLinkmanLabel">
				<input id="venueLinkman" name="venueLinkman" type="text" class="input-text w210" value='<c:out value="${cmsVenue.venueLinkman}" escapeXml="true"/>' maxlength="60"/>
			</td>
		</tr> -->
		<tr>
			<td width="100" class="td-title"><span class="red">*</span>联系电话：</td>
			<td class="td-input" id="venueMobileLabel">
				<input id="venueMobile" name="venueMobile" type="text" class="input-text w210" value="${cmsVenue.venueMobile}"  maxlength="20"/>
				 <span class="td-tip">例如：021-68888888</span>
			</td>
		</tr>
		<!--<tr>
			<td width="100" class="td-title">联系邮箱：</td>
			<td class="td-input">
				<input id="venueMail" name="venueMail" type="text" class="input-text w210" value='<c:out value="${cmsVenue.venueMail}" escapeXml="true"/>' maxlength="100"/>
			</td>
		</tr>
		<tr>
			<td width="100" class="td-title">场馆网址：</td>
			<td class="td-input">
				<input id="venueSites" name="venueSites" type="text" class="input-text w510" value='<c:out value="${cmsVenue.venueSites}" escapeXml="true"/>' maxlength="200"/>
			</td>
		</tr>-->
		<%-- 开始结束时间 --%>
		<tr>
			<td width="100" class="td-title"><span class="red">*</span>开放时间：
				<input id="venueOpenTimeMessage" style="position: absolute; left: -9999px;"/>
			</td>
			<input type="hidden" id="venueOpenTime" name="venueOpenTime" value="${cmsVenue.venueOpenTime}"/>
			<td class="td-select td-select-time" id="venueOpenTimeLabel">
				<div class="select-box w140">
					<input type="hidden" id="venueOpenHour"/>
					<div class="select-text" data-value="">时</div>
					<ul class="select-option" id="venueOpenHourUl">
					</ul>
				</div>
				<span class="time-text">时</span>
				<div class="select-box w140">
					<input type="hidden" id="venueOpenMin"/>
					<div class="select-text" data-value="">分</div>
					<ul class="select-option" id="venueOpenMinUl">
					</ul>
				</div>
				<span class="time-text">分</span>
			</td>
		</tr>
		<tr>
			<td width="100" class="td-title"><span class="red">*</span>结束时间：
				<input id="venueEndTimeMessage" style="position: absolute; left: -9999px;"/>
			</td>
			<input type="hidden" id="venueEndTime" name="venueEndTime" value="${cmsVenue.venueEndTime}"/>
			<td class="td-select td-select-time" id="venueEndTimeLabel">
				<div class="select-box w140">
					<input type="hidden" id="venueEndHour"/>
					<div class="select-text" data-value="">时</div>
					<ul class="select-option" id="venueEndHourUl">
					</ul>
				</div>
				<span class="time-text">时</span>
				<div class="select-box w140">
					<input type="hidden" id="venueEndMin"/>
					<div class="select-text" data-value="">分</div>
					<ul class="select-option" id="venueEndMinUl">
					</ul>
				</div>
				<span class="time-text">分</span>
			</td>
		</tr>
		<tr>
			<td width="100" class="td-title"></td>
			<td class="td-checkbox td-checkbox-70" id="selectAllLabel">
				<label><input type="checkbox" id="selectAll">全选</label>
				<label><input name="venueMon" type="checkbox" value="1" id="venueMon" <c:if test="${cmsVenue.venueMon == 1}">checked="checked"</c:if> >周一</label>
				<label><input name="venueTue" type="checkbox" value="1" id="venueTue" <c:if test="${cmsVenue.venueTue == 1}">checked="checked"</c:if> >周二</label>
				<label><input name="venueWed" type="checkbox" value="1" id="venueWed" <c:if test="${cmsVenue.venueWed == 1}">checked="checked"</c:if> >周三</label>
				<label><input name="venueThu" type="checkbox" value="1" id="venueThu" <c:if test="${cmsVenue.venueThu == 1}">checked="checked"</c:if> >周四</label>
				<label><input name="venueFri" type="checkbox" value="1" id="venueFri" <c:if test="${cmsVenue.venueFri == 1}">checked="checked"</c:if> >周五</label>
				<label><input name="venueSat" type="checkbox" value="1" id="venueSat" <c:if test="${cmsVenue.venueSat == 1}">checked="checked"</c:if> >周六</label>
				<label><input name="venueSun" type="checkbox" value="1" id="venueSun" <c:if test="${cmsVenue.venueSun == 1}">checked="checked"</c:if> >周日</label>
			</td>
		</tr>
		<%-- 开始结束时间 --%>
		<tr>
			<td width="100" class="td-title">开放备注：</td>
			<td class="td-input">
				<input id="openNotice" name="openNotice" type="text" class="input-text w510" value='<c:out value="${cmsVenue.openNotice}" escapeXml="true"/>' maxlength="30"/>
				 <span class="td-tip">例如：每周天上午8:00-11:30</span>
			</td>
		</tr>
		<%--<tr>
			<td width="100" class="td-title">场馆电话：</td>
			<td class="td-input" id="venueTelLabel">
				<input id="venueTel" name="venueTel" type="text" class="input-text w210" value="${cmsVenue.venueTel}"  maxlength="20"/>
			</td>
		</tr>--%>
		<tr>
			<td width="100" class="td-title"><span class="red">*</span>是否收费：</td>
			<td class="td-input td-fees" id="venueIsFreeLabel">
				<label>
					<input type="radio" name="venueIsFree" value="no" <c:if test="${cmsVenue.venueIsFree == 1}">checked="checked"</c:if> /><em>否</em>
				</label>
				<label>
					<input type="radio" name="venueIsFree" value="yes" <c:if test="${cmsVenue.venueIsFree == 2}">checked="checked"</c:if> /><em>是</em>
				</label>
				<div class="extra" <c:if test="${cmsVenue.venueIsFree == 1}">style="display: none;"</c:if><c:if test="${cmsVenue.venueIsFree == 2}">style="display: inline-block;"</c:if>>
					<input id="venuePrice" name="venuePrice" type="text" class="input-text w120" value="${cmsVenue.venuePrice}" maxlength="50"/>元/人
					 <span class="td-tip">建议填写常规票价</span> 
				</div>
				<span class="error-msg"></span>
			</td>
		</tr>
		  <tr class="extra" <c:if test="${cmsVenue.venueIsFree == 1}">style="display: none;"</c:if>>
                <td width="100" class="td-title">收费备注：</td>
                <td class="td-input">
                    <input id="venuePriceNotice" name="venuePriceNotice" type="text" class="input-text w510"
                          value="${cmsVenue.venuePriceNotice }" maxlength="100"/>
                  <span class="td-tip">例如：8:00-12:00，票价30元，18:00-22:00，票价50元 例如：成人：50元/人；老年人（持证）：20元/人</span>
                </td>
            </tr>
		<!--  add by YangHui 2015/10/16   有无地铁，有无公交   start -->
		 <tr>
			<td width="100" class="td-title"><span class="red">*</span>有无地铁：</td>
			<td class="td-input td-fees" id="venueHasMetroLabel">
				<label>
					<input type="radio" name="venueHasMetro" value="1" <c:if test="${cmsVenue.venueHasMetro == 1}">checked="checked"</c:if> /><em>无</em>
				</label>
				<label>
					<input type="radio" name="venueHasMetro" value="2" <c:if test="${cmsVenue.venueHasMetro == 2}">checked="checked"</c:if>/><em>有</em>
				</label>
				  <span <c:if test="${cmsVenue.venueHasMetro != 2}">style="display:none"</c:if> id="metroLine"><input type="text" class="input-text w120" id="venueMetroText" name="venueMetroText" value="${cmsVenue.venueMetroText }"/></span>
			</td>
		</tr>
		
		<tr>
			<td width="100" class="td-title"><span class="red">*</span>有无公交：</td>
			<td class="td-input td-fees" id="venueHasBusLabel">
				<label>
					<input type="radio" name="venueHasBus" value="1" <c:if test="${cmsVenue.venueHasBus == 1}">checked="checked"</c:if> /><em>无</em>
				</label>
				<label>
					<input type="radio" name="venueHasBus" value="2" <c:if test="${cmsVenue.venueHasBus == 2}">checked="checked"</c:if> /><em>有</em>
				</label>
				 <span <c:if test="${cmsVenue.venueHasBus != 2}">style="display:none"</c:if>  id="busLine"><input type="text" class="input-text w120" id="venueBusText" name="venueBusText" value="${ cmsVenue.venueBusText}"/></span>
			</td>
		</tr>
		
		<!--  add by YangHui 2015/10/16   有无地铁，有无公交   end -->
		
		<tr>
			<td width="100" class="td-title"><span class="red">*</span>活动室情况：</td>
			<td class="td-input td-fees" id="venueHasRoomLabel">
				<label>
					<input type="radio" name="venueHasRoom" value="1" <c:if test="${cmsVenue.venueHasRoom == 1}">checked="checked"</c:if> /><em>无</em>
				</label>
				<label>
					<input type="radio" name="venueHasRoom" value="2" <c:if test="${cmsVenue.venueHasRoom == 2}">checked="checked"</c:if> /><em>有</em>
				</label>
			</td>
		</tr> 
		<tr>
			<td width="100" class="td-title"><span class="red">*</span>馆藏情况：</td>
			<td class="td-input td-fees" id="venueHasAntiqueLabel">
				<label>
					<input type="radio" name="venueHasAntique" value="1" <c:if test="${cmsVenue.venueHasAntique == 1}">checked="checked"</c:if> /><em>无</em>
				</label>
				<label>
					<input type="radio" name="venueHasAntique" value="2" <c:if test="${cmsVenue.venueHasAntique == 2}">checked="checked"</c:if> /><em>有</em>
				</label>
			</td>
		</tr>
		<tr>
		<td width="100" class="td-title">配套设施：</td>
            <td class="td-input td-fees">
           			 <input id="venueFacility" name="venueFacility" style="position: absolute; left: -9999px;" type="hidden"  value="${cmsVenue.venueFacility}"/>
                	<div><label><input id="venueFacilityAll" type="checkbox" value="" /><em>全部</em></label></div>
                	<div style="margin-top:47px;"  id="venueFacilityLabel"></div>
            </td>
        </tr>
		<!-- 
		<tr>
			<td width="100" class="td-title">漫游网址：</td>
			<td class="td-input" id="venueRoamUrlLabel">
				<input id="venueRoamUrl" name="venueRoamUrl" type="text" class="input-text w510" value='<c:out value="${cmsVenue.venueRoamUrl}" escapeXml="true"/>'/>
			</td>
		</tr>
		<tr>
			<td width="100" class="td-title">360全景：</td>
			<td class="td-input">
				<input name="venuePanorama" type="text" class="input-text w510" value="${cmsVenue.venuePanorama}"/>
			</td>
		</tr>
<%--		<tr>
			<td width="100" class="td-title">场馆视频：</td>
			<td class="td-input">
				<input name="venueVideoUrl" type="text" class="input-text w510" value="${cmsVenue.venueVideoUrl}"/>
			</td>
		</tr>--%>
		<tr>
			<td width="100" class="td-title">音频文件：</td>
			<td class="td-input td-upload">
				<input type="hidden" name="uploadType" value="Audio" id="uploadType2"/>
				<input type="hidden" name="venueVoiceUrl" id="venueVoiceUrl" value="${cmsVenue.venueVoiceUrl}" class="input-text w400"/>
				<div class="controls" style="display: inline-block; vertical-align: top;">
					<input type="file" name="voiceFile" id="file2">
					<div id="fileContainer2"></div>
					<div id="btnContainer2" style="display: none;">
						<a style="margin-left:335px;" href="javascript:clearQueue2();" class="btn">取消</a>
					</div>
				</div>
				<c:if test="${not empty cmsVenue.venueVoiceUrl}">
					<a href="javascript:;" id="loadVoice" target="_blank">查看音频</a>
				</c:if>
			</td>
		</tr> -->
		<tr>
			<td width="100" class="td-title">场馆描述：</td>
			<td class="td-content" id="venueMemoLabel">
				<div class="editor-box">
					<textarea name="venueMemo" id="venueMemo">${cmsVenue.venueMemo}</textarea>
				</div>
			</td>
		</tr>
		<tr>
			<td width="100" class="td-title"></td>
			<td class="td-btn">
				<input type="hidden" id="venueId" name="venueId" value="${cmsVenue.venueId}"/>
				<input type="hidden" id="venueState" name="venueState" value="${cmsVenue.venueState}"/>

				<c:if test="${cmsVenue.venueState == 6}">
					<input class="btn-save" type="button" value="返回"/>
				</c:if>
				
				<input class="btn-preview btn-publish" type="button" value="预览"/>
				
				<c:if test="${cmsVenue.venueState == 1 || cmsVenue.venueState == 5}">
					<input class="btn-save" type="button" value="保存草稿"/>
				</c:if>

                	<input id="btnPublish" class="btn-publish" type="button" value="保存修改"/>
			</td>
		</tr>
	</table>
</div>
</form>

</body>
</html>