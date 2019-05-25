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
var startIndex,endIndex;
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
	//初始化省市区与街道，并回写数据
    initAreaAndTown();
	//日期控件
    $(".start-btn").on("click", function(){
    	startIndex = $('.start-btn').index(this);
        WdatePicker({
        	el:'timeTemp',
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
    	endIndex = $('.end-btn').index(this);
        WdatePicker({
        	el:'timeTemp',
            dateFmt: 'yyyy-MM-dd',
            doubleCalendar: true,
            position: {left: -224, top: 8},
            isShowClear: false,
            isShowOK: true,
            isShowToday: false,
            onpicked: pickedEndFunc
        });
    });
    $("input[name='startHour']").on("keyup change",function(){
    	if ($(this).val() > 23){
    		$(this).val(23);
    	}
    });
    $("input[name='startMinute']").on("keyup change",function(){
    	if ($(this).val() > 59){
			$(this).val(59);    		
    	}
    });
    $("input[name='endHour']").on("keyup change",function(){
    	if ($(this).val() > 23){
    		$(this).val(23);
    	}
    });
    $("input[name='endMinute']").on("keyup change",function(){
    	if ($(this).val() > 59){
			$(this).val(59);    		
    	}
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
	var startDate = $dp.cal.getDateStr('yyyy-MM-dd');
	$("tr.eventTr").eq(startIndex).find('#startTimeHidden').val(startDate);
	$("tr.eventTr").eq(startIndex).find('#startTime').val(startDate);
}
function pickedEndFunc() {
	var endDate = $dp.cal.getDateStr('yyyy-MM-dd');
	$("tr.eventTr").eq(endIndex).find('#endTimeHidden').val(endDate);
	$("tr.eventTr").eq(endIndex).find('#endTime').val(endDate);
}
function addEvent(){
	var eventTr = $('tr.eventTr').eq(0).clone(true);
	$(eventTr).find("td").eq(0).html("");
	$(eventTr).find('#startTimeHidden').val("");
	$(eventTr).find('#startTime').val("");
	$(eventTr).find('#endTimeHidden').val("");
	$(eventTr).find('#endTime').val("");
	$(eventTr).find('#addIcon').hide();
	$(eventTr).find('#delIcon').css("display","inline-block");
	$(eventTr).find('#startHour').val("");
	$(eventTr).find('#startMinute').val("");
	$(eventTr).find('#endHour').val("");
	$(eventTr).find('#endMinute').val("");
	$(eventTr).find('#ticketNum').val("");
	$(eventTr).insertAfter('tr.eventTr:last');
}
function delEvent(obj){
	$(obj).parent().parent().remove();
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
	var culturalOrderAddress = $('#culturalOrderAddress').val();
	var culturalOrderMustKnow = $('#culturalOrderMustKnow').val();
	var culturalOrderAreaShow = $('#culturalOrderAreaShow').val();
	
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
	if (culturalOrderAddress == undefined || culturalOrderAddress == "") {
        removeMsg("culturalOrderAddressLabel");
        appendMsg("culturalOrderAddressLabel", "详细地址为必填项!");
        $('#culturalOrderAddress').focus();
        return;
    } else {
        removeMsg("culturalOrderAddressLabel");
    }
	var eventFlag = true;
	$("input[name='startTime'],input[name='endTime'],input[name='startHour'],input[name='endHour'],input[name='startMinute'],input[name='endMinute'],input[name='ticketNum']").each(function(){
		if (eventFlag){
			if ($(this).val() == ""){
				dialogAlert("系统提示","请输入正确的场次信息！");
				eventFlag = false;
				return;
			}
		}
	});
	if (!eventFlag){
		return;
	}
	if (culturalOrderMustKnow == undefined || culturalOrderMustKnow == "") {
        removeMsg("culturalOrderMustKnowLabel");
        appendMsg("culturalOrderMustKnowLabel", "详细地址为必填项!");
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
	        case("hasOrder"):
	            dialogAlert("系统提示", "已存在订单，不能修改！  ", function () {
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
<!-- 该hidden仅用于时间控件的临时过渡 -->
<input type="hidden" id="timeTemp"/>
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
            			<option value="">江苏省</option>
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
                    <input type="hidden" id="culturalOrderTown" name="culturalOrderTown" value="${order.culturalOrderTown}"/>
                    <dl>
                        <dd id="townLabel">
                        </dd>
                    </dl>
                </td>
            </tr>
            <tr>
	            <td width="150" class="td-title"><span class="red">*</span>详细地址：</td>
	            <td class="td-input" id="culturalOrderAddressLabel">
	            	<input type="text" id="culturalOrderAddress" name="culturalOrderAddress" class="input-text w510" value="${order.culturalOrderAddress}"/>
	            </td>
	        </tr>
	        <c:forEach items="${eventList}" var="event" varStatus="st">
	        	<c:if test="${st.index == 0}">
		        	<tr class="eventTr">
			            <td width="150" class="td-title"><span class="red">*</span>服务日期：</td>
			            <td class="td-time td-input td-online">
			            	<div class="starts w340">
			                    <span class="text">开始日期</span>
			                    <input type="text" id="startTime" name="startTime" 
			                    value="<fmt:formatDate value='${event.culturalOrderEventDate}' pattern='yyyy-MM-dd'/>" readonly/>
			                    <i class="data-btn start-btn"></i>
			                </div>
		                	<span class="txt">至</span>
			                <div class="ends w340">
			                    <span class="text">结束日期</span>
			                    <input type="text" id="endTime" name="endTime" 
			                    value="<fmt:formatDate value='${event.culturalOrderEventDate}' pattern='yyyy-MM-dd'/>" readonly/>
			                    <i class="data-btn end-btn"></i>
			                </div>
			                <input value="${fn:substring(event.culturalOrderEventTime,0,2)}" id="startHour" name="startHour" min="0" type="number" class="input-text w64" maxlength="2"/>：
			                <input value="${fn:substring(event.culturalOrderEventTime,3,5)}" id="startMinute" name="startMinute" min="0" type="number" class="input-text w64" maxlength="2"/>至
			                <input value="${fn:substring(event.culturalOrderEventTime,6,8)}" id="endHour" name="endHour" min="0" type="number" class="input-text w64" maxlength="2"/>：
			                <input value="${fn:substring(event.culturalOrderEventTime,9,11)}" id="endMinute" name="endMinute" min="0" type="number" class="input-text w64" maxlength="2"/>
		                	<em>票数：</em><input value="${event.eventTicketNum}" id="ticketNum" name="ticketNum" type="number" min="0" class="input-text w64"/>
		                	<a id="addIcon" href="javascript:addEvent();" class="timeico tianjia" style="background: url(${path}/STATIC/image/add.png) no-repeat center center;width: 25px;"></a>
		                	<a id="delIcon" href="javascript:void(0);" onclick="delEvent(this);" class="timeico jianhao" style="display:none;background: url(${path}/STATIC/image/remove.png) no-repeat center center;width: 25px;"></a>
			            </td>
		        	</tr>
	        	</c:if>
	        	<c:if test="${st.index > 0}">
		        	<tr class="eventTr">
			            <td width="150" class="td-title"></td>
			            <td class="td-time td-input td-online">
			            	<div class="starts w340">
			                    <span class="text">开始日期</span>
			                    <input type="text" id="startTime" name="startTime" 
			                    value="<fmt:formatDate value='${event.culturalOrderEventDate}' pattern='yyyy-MM-dd'/>" readonly/>
			                    <i class="data-btn start-btn"></i>
			                </div>
		                	<span class="txt">至</span>
			                <div class="ends w340">
			                    <span class="text">结束日期</span>
			                    <input type="text" id="endTime" name="endTime" 
			                    value="<fmt:formatDate value='${event.culturalOrderEventDate}' pattern='yyyy-MM-dd'/>" readonly/>
			                    <i class="data-btn end-btn"></i>
			                </div>
			                <input value="${fn:substring(event.culturalOrderEventTime,0,2)}" id="startHour" name="startHour" min="0" type="number" class="input-text w64" maxlength="2"/>：
			                <input value="${fn:substring(event.culturalOrderEventTime,3,5)}" id="startMinute" name="startMinute" min="0" type="number" class="input-text w64" maxlength="2"/>至
			                <input value="${fn:substring(event.culturalOrderEventTime,6,8)}" id="endHour" name="endHour" min="0" type="number" class="input-text w64" maxlength="2"/>：
			                <input value="${fn:substring(event.culturalOrderEventTime,9,11)}" id="endMinute" name="endMinute" min="0" type="number" class="input-text w64" maxlength="2"/>
		                	<em>票数：</em><input value="${event.eventTicketNum}" id="ticketNum" name="ticketNum" type="number" min="0" class="input-text w64"/>
		                	<a id="addIcon" href="javascript:addEvent();" class="timeico tianjia" style="display:none;background: url(${path}/STATIC/image/add.png) no-repeat center center;width: 25px;"></a>
		                	<a id="delIcon" href="javascript:void(0);" onclick="delEvent(this);" class="timeico jianhao" style="display:inline-block;background: url(${path}/STATIC/image/remove.png) no-repeat center center;width: 25px;"></a>
			            </td>
		        	</tr>
	        	</c:if>
	        </c:forEach>
	        <tr>
	            <td width="150" class="td-title"><span class="red">*</span>报名须知：</td>
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
