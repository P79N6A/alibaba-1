<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>文化云</title>
    <%@include file="../../common/pageFrame.jsp"%>
    <link rel="stylesheet" href="${path}/STATIC/js/ossjs/style.css" type="text/css" />
	<link rel="stylesheet" href="${path}/STATIC/css/whyupload.css" type="text/css"/>
    <script type="text/javascript" src="http://culturestore.oss-cn-shanghai.aliyuncs.com/ossFile/js/crypto.js"></script>
	<script type="text/javascript" src="http://culturestore.oss-cn-shanghai.aliyuncs.com/ossFile/js/hmac.js"></script>
	<script type="text/javascript" src="http://culturestore.oss-cn-shanghai.aliyuncs.com/ossFile/js/sha1.js"></script>
	<script type="text/javascript" src="http://culturestore.oss-cn-shanghai.aliyuncs.com/ossFile/js/base64.js"></script>
	<script type="text/javascript" src="http://culturestore.oss-cn-shanghai.aliyuncs.com/ossFile/js/plupload.full.min.js"></script>
	<script type="text/javascript" src="http://culturestore.oss-cn-shanghai.aliyuncs.com/ossFile/js/upload.js"></script>
	<script type="text/javascript" src="http://culturestore.oss-cn-shanghai.aliyuncs.com/ossFile/js/uuid.js"></script>
<style>
	div[name=aliFile]{
	}
	div[name=aliFile] br, div[name=aliFile] b,div[name=aliFile] p,div[name=aliFile] span{
		display:none;
	}
	div[name=aliFile] .imgPack {
		width:200px;
		float:left;
		position: relative;
		overflow: hidden;
		margin-right:10px;
		margin-bottom:10px;
	}
	div[name=aliFile] .imgPack img {
		width:100%;
		height:auto;
	}
	div[name=aliFile] .aliRemoveBtn , div[name=aliFile] .imgPack .aliRemoveBtn {
		width:20px;
		height:20px;
		position: absolute;
		top: 0;
        right: 0;
	}
	.videoBox div[name="aliFile"]{
		width:250px;
		height: 190px;
		float:left;
		position: relative;
		overflow: hidden;
		margin-right:10px;
		margin-bottom:10px;
	}
	div[name=aliFile] .progress {
		position: absolute;
	    left: 0;
	    bottom: 0;
	    z-index: 1;
	}
</style>
<script type="text/javascript">
var townFirst = true,venueIdFirst = true;
$(function(){
	//图片上传
	aliUpload({
		uploadDomId:'webuploadPic',
		fileNum: 1,
		progressBar:false,
		callBackFunc:uploadImgCallback,
		fileFormat:"PSD,PDD,GIF,EPS,RAW,SCT,TJA,VDA,ICB,VST,JPG,JPEG,BMP,RLE,PNG,PCX,PDF,PCT,PIC,PXR,PNG,SVG,TRF",
		upLoadSrc:"H5",
		imgPreview:true
	});
	//富文本编辑器
	var editor = CKEDITOR.replace('culturalOrderServiceDetail',{ height: '300px', width: '900px' });
	//初始化省市区与街道，以及点单区域限制
    initAreaAndTown();
	//日期控件
    $(".start-btn").on("click", function(){
        WdatePicker({
        	el:'startTimeHidden',
            dateFmt: 'yyyy-MM-dd',
            doubleCalendar: true,
            position: {left: -224, top: 8},
            isShowClear: false,
            isShowOK: true,
            isShowToday: false,
            onpicked: pickedStartFunc
        })
    });
    $(".end-btn").on("click", function () {
        WdatePicker({
        	el:'endTimeHidden',
            dateFmt: 'yyyy-MM-dd',
            minDate: '#F{$dp.$D(\'startTimeHidden\')}',
            doubleCalendar: true,
            position: {left: -224, top: 8},
            isShowClear: false,
            isShowOK: true,
            isShowToday: false,
            onpicked: pickedEndFunc
        });
    });
    //加载类型
    $.ajax({
        type: "POST",
        url: "${path}/sysdict/queryChildSysDictByDictCode.do?dictCode=CULTURAL_ORDER_TYPE",
        data: {},
        dataType: "json",
        success: function(data){
        	var culturalOrderType = '${order.culturalOrderType}';
            for (var i=0;i<data.length;i++){
            	if (culturalOrderType == data[i].dictId){
            		$('#culturalOrderType').append("<option value='"+data[i].dictId+"' selected='selected'>"+data[i].dictName+"</option>");
            	} else {
	            	$('#culturalOrderType').append("<option value='"+data[i].dictId+"'>"+data[i].dictName+"</option>");
            	}
            }
        }
    });
    
  	//类型标签
    $.post("${path}/tag/getChildTagByType.do?code=VENUE_TYPE", function (data) {
    	for (var i=0;i<data.length;i++){
    		var culturalOrderVenueType = '${order.culturalOrderVenueType}';
    		if (culturalOrderVenueType == data[i].tagId){
	    		$('#culturalOrderVenueType').append("<option value='"+data[i].tagId+"' selected='selected'>"+data[i].tagName+"</option>");
    		} else {
    			$('#culturalOrderVenueType').append("<option value='"+data[i].tagId+"'>"+data[i].tagName+"</option>");
    		}
    	}
    	//初始化场馆
    	changeVenue();
    },"json");
});
function initAreaAndTown(){
	var venueProvince = '804,辽宁省';
	var venueCity = '900,安康市';
    var venueArea = '${order.culturalOrderArea}';
    var areaLimit = '${order.culturalOrderAreaLimit}';
    //省市区
    var loc = new Location();
    var json = loc.find( '0,' + venueProvince.split(",")[0] + ',' + venueCity.split(",")[0]);
    if (json){
		$.each(json , function(k , v) {
			if (k+","+v == venueArea){
				var option = '<option value="'+k+'" selected="selected">'+v+'</option>';
				$('#culturalOrderAreaShow').append(option);
			} else {
				var option = '<option value="'+k+'">'+v+'</option>';
				$('#culturalOrderAreaShow').append(option);
			}
			if (k+","+v == areaLimit){
				var option = '<option value="'+k+'" selected="selected">'+v+'</option>';
				$('#culturalOrderAreaLimitShow').append(option);
			} else {
				var option = '<option value="'+k+'">'+v+'</option>';
				$('#culturalOrderAreaLimitShow').append(option);
			}
		});
	}
    var firstArea = $('#culturalOrderAreaShow').val();
    dictLocation(firstArea);
}
function dictLocation(code){
    // 位置字典
    $.post("${path}/sysdict/queryChildSysDictByDictCode.do", {dictCode: code}, function (data) {
        var list = eval(data);
        var dictHtml = '';
        var otherHtml = '';
        for (var i = 0; i < list.length; i++) {
            var obj = list[i];
            var dictId = obj.dictId;
            var dictName = obj.dictName;
            if (dictName == '其他') {
                otherHtml = '<a id="town_'+dictId+'" onclick="setVenueDict(\''
                        + dictId + '\',\'culturalOrderTown\')">' + dictName
                        + '</a>';
                continue;
            }
            dictHtml += '<a id="town_'+dictId+'" onclick="setVenueDict(\''
                    + dictId + '\',\'culturalOrderTown\')">' + dictName
                    + '</a>';
        }
        $("#townLabel").html(dictHtml + otherHtml);
        tagSelectDict("townLabel");
        if (townFirst){
        	//初始化，加载选中街道
        	$('#town_${order.culturalOrderTown}').addClass("cur");
        	townFirst = false;
        }
    });
}
function setVenueDict(value, id) {
    $("#" + id).val(value);
    $('#' + id).find('a').removeClass('cur');
}
function tagSelectDict(id) {
    $('#' + id).find('a').click(function () {
        $('#' + id).find('a').removeClass('cur');
        $(this).addClass('cur');
    });
}
//上传图片回调函数
function uploadImgCallback(up, file, info) {
	$('#'+file.id).append("<input type='hidden' name='culturalOrderImg' id='culturalOrderImg' value='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info+"'/>");
}
function pickedStartFunc() {
	$dp.$('startTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
}
function pickedEndFunc() {
	$dp.$('endTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
}
function changeTown(){
	$('#culturalOrderTown').val("");
	dictLocation($('#culturalOrderAreaShow').val());
}
function changeVenue(){
	$.post("${path}/culturalOrder/getVenueListByAreaAndType.do",{area:$('#culturalOrderAreaShow').val()+","+$("#culturalOrderAreaShow").find("option:selected").text(),type:$('#culturalOrderVenueType').val()},function(data){
		$('#culturalOrderVenueId').empty();
		for (var i=0;i<data.length;i++){
			$('#culturalOrderVenueId').append("<option value='"+data[i].venueId+"'>"+data[i].venueName+"</option>");
		}
		if (venueIdFirst){
			var culturalOrderVenueId = '${order.culturalOrderVenueId}';
			$('#culturalOrderVenueId').val(culturalOrderVenueId);
			venueIdFirst = false;
		}
	},"json");
}

function saveCulturalOrder(){
	var culturalOrderName = $('#culturalOrderName').val();
	var culturalOrderImg = $('#culturalOrderImg').val();
	var culturalOrderVenueId = $('#culturalOrderVenueId').val();
	var culturalOrderTown = $('#culturalOrderTown').val();
	var startTime = $('#startTime').val();
	var endTime = $('#endTime').val();
	var culturalOrderDemandLimit = $("input[name='culturalOrderDemandLimit']:checked").val();
	var culturalOrderLinkno = $('#culturalOrderLinkno').val();
	var culturalOrderLinkman = $('#culturalOrderLinkman').val();
	var culturalOrderMustKnow = $('#culturalOrderMustKnow').val();
	var culturalOrderServiceDetail = CKEDITOR.instances.culturalOrderServiceDetail.getData();
	if (culturalOrderName == undefined || culturalOrderName == "") {
        removeMsg("culturalOrderNameLabel");
        appendMsg("culturalOrderNameLabel", "标题为必填项!");
        $('#culturalOrderName').focus();
        return;
    } else {
        removeMsg("culturalOrderNameLabel");
    }
	if (culturalOrderImg == undefined || culturalOrderImg == "") {
		dialogAlert("系统提示","请上传封面！");
        return;
    }
	if (culturalOrderVenueId == undefined || culturalOrderVenueId == "") {
		dialogAlert("系统提示","请选择场馆！");
        return;
    }
	if (culturalOrderTown == undefined || culturalOrderTown == "") {
		dialogAlert("系统提示","请选择位置！");
        return;
    }
	if (startTime == undefined || startTime == ""){
		dialogAlert("系统提示","请选择服务开始日期！");
        return;
	}
	if (endTime == undefined || endTime == ""){
		dialogAlert("系统提示","请选择服务结束日期！");
        return;
	}
	if (culturalOrderDemandLimit == undefined || culturalOrderDemandLimit == ""){
		dialogAlert("系统提示","请选择需求方限制！");
        return;
	}
	if (culturalOrderLinkno == undefined || culturalOrderLinkno == ""){
		removeMsg("culturalOrderLinknoLabel");
        appendMsg("culturalOrderLinknoLabel", "联系电话为必填项!");
		$('#culturalOrderLinkno').focus();
		return;
	} else {
		removeMsg("culturalOrderLinknoLabel");
	}
	if (culturalOrderLinkman == undefined || culturalOrderLinkman == ""){
		removeMsg("culturalOrderLinkmanLabel");
        appendMsg("culturalOrderLinkmanLabel", "联系人为必填项!");
		$('#culturalOrderLinkman').focus();
		return;
	} else {
		removeMsg("culturalOrderLinkmanLabel");
	}
	if (culturalOrderMustKnow == undefined || culturalOrderMustKnow == "") {
        removeMsg("culturalOrderMustKnowLabel");
        appendMsg("culturalOrderMustKnowLabel", "邀请须知为必填项!");
        $('#culturalOrderMustKnow').focus();
        return;
    } else {
        removeMsg("culturalOrderMustKnowLabel");
    }
	if (culturalOrderServiceDetail == undefined || culturalOrderServiceDetail == "") {
        removeMsg("culturalOrderServiceDetailLabel");
        appendMsg("culturalOrderServiceDetailLabel", "服务详情为必填项!");
        $('#culturalOrderServiceDetail').focus();
        return;
    } else {
        removeMsg("culturalOrderServiceDetailLabel");
        //富文本编辑器
        $('#culturalOrderServiceDetail').val(culturalOrderServiceDetail);
    }
	
	$('#culturalOrderArea').val($('#culturalOrderAreaShow').val()+","+$("#culturalOrderAreaShow").find("option:selected").text());
	$('#culturalOrderAreaLimit').val($('#culturalOrderAreaLimitShow').val()+","+$("#culturalOrderAreaLimitShow").find("option:selected").text());
	$.post("${path}/culturalOrder/saveCulturalOrder.do",$('#culturalOrderForm').serialize(),function(data){
		switch (data) {
	        case("success"):
	        	 dialogAlert("系统提示", "保存成功！", function () {
	        		 window.location.href ="../culturalOrder/culturalOrderList.do?culturalOrderLargeType="+$('#culturalOrderLargeType').val();
	             });
	         	break;    		
	        case("noActive"):
	            dialogAlert("系统提示", "请登陆后再进行操作", function () {
	                window.location.href = "../admin.do";
	            });
	        	break;
	        default:
	            dialogAlert("系统提示", "保存发生错误，请查看数据是否完整", function () {
	            });
	            break;
         }
	});
}
function backList(){
	window.location.href="${path}/culturalOrder/culturalOrderList.do?culturalOrderLargeType="+$('#culturalOrderLargeType').val();
}
</script>
</head>
<body>
<form action="" id="culturalOrderForm" method="post">
	<input type="hidden" value="${order.culturalOrderId}" id="culturalOrderId" name="culturalOrderId"/>
	<input type="hidden" value="${order.culturalOrderLargeType}" id="culturalOrderLargeType" name="culturalOrderLargeType"/>
	<div class="site-title">
		<c:if test="${order.culturalOrderLargeType == 1}">
			我要参与
		</c:if>
		<c:if test="${order.culturalOrderLargeType == 2}">
			我要邀请
		</c:if>
		&gt;点单列表&gt;
		<c:if test="${empty order.culturalOrderId}">
			新增
		</c:if>
		<c:if test="${not empty order.culturalOrderId}">
			修改
		</c:if>
	</div>
	<div class="main-publish">
	  	<table width="100%" class="form-table assnResVideos">
	        <tr>
	            <td width="150" class="td-title"><span class="red">*</span>标题：</td>
	            <td class="td-input" id="culturalOrderNameLabel">
	            	<input type="text" id="culturalOrderName" name="culturalOrderName" class="input-text w510" value="${order.culturalOrderName}"/>
	            </td>
	        </tr>
	        <tr>
	            <td width="150" class="td-title"><span class="red">*</span>封面：</td>
	            <td class="td-upload" id="culturalOrderImgLabel">
               		<table>
                  	  <tr>
                       	 <td>                      
	                        <div class="whyUploadVedio" id="webuploadPic">
								<div style="width: 500px;">
									<div id="ossfile">
										<c:if test="${not empty order.culturalOrderImg}">
											<div name="aliFile">
												<div class="imgPack">
													<img class="aliRemoveBtn" onclick="$(this).parent().parent().remove()" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" />
													<img class="upload-img-identify" src="${order.culturalOrderImg}"/>
												</div>
												<input type="hidden" id="culturalOrderImg" name="culturalOrderImg" value="${order.culturalOrderImg}"/>
											</div>
										</c:if>
									</div>
									<div id="container" style="clear:both;">
										<button id="selectfiles" href="javascript:void(0);" class='btn'>选择文件</button>
										<pre style="font-size: 14px;color: #999;line-height: 25px;">Tip：可上传1张图片，格式为jpg、jpeg、png、gif，大小不超过2M</pre>
									</div>
								</div>
							</div>					
                        </td>
                   	 </tr>
               	   </table>
               </td>
	        </tr>
	        <tr>
	            <td width="150" class="td-title"><span class="red">*</span>类型：</td>
	            <td class="td-select" id="culturalOrderTypeLabel">
	            	<select id="culturalOrderType" name="culturalOrderType" class="ng-select-box">
					</select>
	            </td>
	        </tr>
	        <tr>
	            <td width="150" class="td-title"><span class="red">*</span>区域：</td>
	            <td class="td-select">
	            	<input type="hidden" id="culturalOrderArea" name="culturalOrderArea"/>
	            	<select class="ng-select-box" disabled="disabled">
            			<option value="">陕西省</option>
            		</select>
            		<select class="ng-select-box" disabled="disabled">
            			<option value="">安康市</option>
            		</select>
            		<select class="ng-select-box" id="culturalOrderAreaShow" onchange="changeTown();changeVenue();">
            		</select>
            		<select class="ng-select-box" id="culturalOrderVenueType" name="culturalOrderVenueType" onchange="changeVenue();">
            		</select>
            		<select class="ng-select-box" id="culturalOrderVenueId" name="culturalOrderVenueId">
            		</select>
	            </td>
	        </tr>
	        <tr>
                <td width="150" class="td-title"><span class="red">*</span>位置：</td>
                <td class="td-tag" id="culturalTownLabel">
                    <input type="hidden" id="culturalOrderTown" name="culturalOrderTown" value="${order.culturalOrderTown }"/>
                    <dl>
                        <dd id="townLabel">
                        </dd>
                    </dl>
                </td>
            </tr>
            <tr>
            	<td width="150" class="td-title"><span class="red">*</span>服务日期：</td>
            	<td class="td-time td-input td-online">
	            	<div class="starts w340">
	            		<input type="hidden" id="startTimeHidden" value="<fmt:formatDate value='${order.culturalOrderStartDate}' pattern='yyyy-MM-dd'/>"/>
	                    <span class="text">开始日期</span>
	                    <input type="text" id="startTime" name="startTime" 
	                    value="<fmt:formatDate value='${order.culturalOrderStartDate}' pattern='yyyy-MM-dd'/>" readonly/>
	                    <i class="data-btn start-btn"></i>
	                </div>
                	<span class="txt">至</span>
	                <div class="ends w340">
	                	<input type="hidden" id="endTimeHidden" value="<fmt:formatDate value='${order.culturalOrderEndDate}' pattern='yyyy-MM-dd'/>"/>
	                    <span class="text">结束日期</span>
	                    <input type="text" id="endTime" name="endTime" 
	                    value="<fmt:formatDate value='${order.culturalOrderEndDate}' pattern='yyyy-MM-dd'/>" readonly/>
	                    <i class="data-btn end-btn"></i>
	                </div>
	            </td>
            </tr>
            <tr>
            	<td width="150" class="td-title"><span class="red">*</span>需求方限制：</td>
            	<td class="td-input" id="culturalOrderDemandLimitLabel">
            		<input type="radio" name="culturalOrderDemandLimit" value="1" <c:if test="${order.culturalOrderDemandLimit == 1}">checked="checked"</c:if>/>个人用户
            		<input type="radio" name="culturalOrderDemandLimit" value="2" <c:if test="${order.culturalOrderDemandLimit == 2}">checked="checked"</c:if>/>机构用户
            		<input type="radio" name="culturalOrderDemandLimit" value="3" <c:if test="${order.culturalOrderDemandLimit == 3}">checked="checked"</c:if>/>不限
            	</td>
            </tr>
            <tr>
	            <td width="150" class="td-title"><span class="red">*</span>可点单区域限制：</td>
	            <td class="td-select">
	            	<input type="hidden" id="culturalOrderAreaLimit" name="culturalOrderAreaLimit"/>
            		<select class="ng-select-box" id="culturalOrderAreaLimitShow">
            			<c:if test="${order.culturalOrderAreaLimit == '-1,不限'}">
            				<option value="-1" selected="selected">不限</option>
            			</c:if>
            			<c:if test="${order.culturalOrderAreaLimit == '-1,不限'}">
            				<option value="-1">不限</option>
            			</c:if>
            		</select>
	            </td>
	        </tr>
	        <tr>
	            <td width="150" class="td-title"><span class="red">*</span>联系电话：</td>
	            <td class="td-input" id="culturalOrderLinknoLabel">
	            	<input type="text" id="culturalOrderLinkno" name="culturalOrderLinkno" class="input-text w510" value="${order.culturalOrderLinkno}"/>
	            </td>
	        </tr>
	        <tr>
	            <td width="150" class="td-title"><span class="red">*</span>联系人：</td>
	            <td class="td-input" id="culturalOrderLinkmanLabel">
	            	<input type="text" id="culturalOrderLinkman" name="culturalOrderLinkman" class="input-text w510" value="${order.culturalOrderLinkman}"/>
	            </td>
	        </tr>
	        <tr>
	            <td width="150" class="td-title"><span class="red">*</span>邀请须知：</td>
	            <td class="td-input" id="culturalOrderMustKnowLabel">
	            	<input type="text" id="culturalOrderMustKnow" name="culturalOrderMustKnow" class="input-text w510" value="${order.culturalOrderMustKnow}"/>
	            </td>
	        </tr>
	        <tr>
                <td width="100" class="td-title"><span class="red">*</span>服务详情：</td>
                <td class="td-content" id="culturalOrderServiceDetailLabel">
                <div class="editor-box" >
                    <textarea name="culturalOrderServiceDetail" id="culturalOrderServiceDetail">${order.culturalOrderServiceDetail}</textarea>
                </div>               
            	</td>
            </tr>
	  	</table>
	  	<table width="100%" class="form-table"> 	                     
            <tr>
                <td width="150" class="td-title"></td>
                <td class="td-btn">
                    <div class="room-order-info info2" style="position: relative;">
                    	<input class="btn-publish" type="button" onclick="saveCulturalOrder()" value="保存"/>
                    	<input class="btn-publish" type="button" onclick="backList()" value="返回"/>
                    </div>
                </td>
            </tr>           
        </table>
	</div>
</form>
</body>
</html>
