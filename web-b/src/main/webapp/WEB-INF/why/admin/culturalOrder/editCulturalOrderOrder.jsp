<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>文化云</title>
    <%@include file="../../common/pageFrame.jsp"%>
<script type="text/javascript">
var ifFirst = true;
<c:if test="${culturalOrderAreaLimit == '-1,不限'}">
var ifAreaLimit = -1;
</c:if>
<c:if test="${culturalOrderAreaLimit != '-1,不限'}">
var ifAreaLimit = 0;
</c:if>
$(function(){
	if (ifAreaLimit == -1){
		initArea();
	}
	//初始化街道，并回写数据
    initTown();
	//日期控件
    $(".start-btn").on("click", function(){
        WdatePicker({
        	el:'orderDateHidden',
            dateFmt: 'yyyy-MM-dd',
            minDate: '${startDate}',
            maxDate: '${endDate}',
            doubleCalendar: true,
            position: {left: -224, top: 8},
            isShowClear: false,
            isShowOK: true,
            isShowToday: false,
            onpicked: pickedStartFunc
        })
    });
});
function initArea(){
	var venueProvince = '804,辽宁省';
	var venueCity = '900,安康市';
    var venueArea = '${orderOrder.culturalOrderOrderArea}';
    //省市区
    var loc = new Location();
    var json = loc.find( '0,' + venueProvince.split(",")[0] + ',' + venueCity.split(",")[0]);
    if (json){
		$.each(json , function(k , v) {
			if (k+","+v == venueArea){
				var option = '<option value="'+k+'" selected="selected">'+v+'</option>';
				$('#culturalOrderOrderAreaShow').append(option);
			} else {
				var option = '<option value="'+k+'">'+v+'</option>';
				$('#culturalOrderOrderAreaShow').append(option);
			}
		});
	}
}
function initTown(){
    var area = '${orderOrder.culturalOrderOrderArea}';
    dictLocation(area.split(",")[0]);
}
function changeTown(){
	var town = $('#culturalOrderOrderAreaShow').val();
	dictLocation(town);
}
function dictLocation(code){
	var town = '${orderOrder.culturalOrderOrderTown}';
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
            	if (ifFirst && town == dictId){
	                otherHtml = "<option value='"+dictId+"' selected='selected'>"+dictName+"</option>";
	                ifFirst = false;
            	} else {
            		otherHtml = "<option value='"+dictId+"'>"+dictName+"</option>"; 
            	}
                continue;
            }
            if (ifFirst && town == dictId){
	            dictHtml += "<option value='"+dictId+"' selected='selected'>"+dictName+"</option>";
	            ifFirst = false;
            } else {
            	dictHtml += "<option value='"+dictId+"'>"+dictName+"</option>";
            }
        }
        $("#culturalOrderOrderTown").empty();
        $("#culturalOrderOrderTown").append(dictHtml + otherHtml);
    });
}
function pickedStartFunc() {
	$dp.$('orderDate').value = $dp.cal.getDateStr('yyyy-MM-dd');
}

function saveCulturalOrder(){
	var orderDate = $('#orderDate').val();
	var culturalOrderOrderPeriod = $('#culturalOrderOrderPeriod').val();
	var culturalOrderOrderAddress = $('#culturalOrderOrderAddress').val();
	
	if (orderDate == undefined || orderDate == "") {
        removeMsg("orderDateLabel");
        appendMsg("orderDateLabel", "服务日期为必填项!");
        $('#orderDate').focus();
        return;
    } else {
        removeMsg("orderDateLabel");
    }
	if (culturalOrderOrderPeriod == undefined || culturalOrderOrderPeriod == "") {
        removeMsg("culturalOrderOrderPeriodLabel");
        appendMsg("culturalOrderOrderPeriodLabel", "服务时段为必填项!");
        $('#culturalOrderOrderPeriod').focus();
        return;
    } else {
        removeMsg("culturalOrderOrderPeriodLabel");
    }
	if (culturalOrderOrderAddress == undefined || culturalOrderOrderAddress == "") {
        removeMsg("culturalOrderOrderAddressLabel");
        appendMsg("culturalOrderOrderAddressLabel", "详细地址为必填项!");
        $('#culturalOrderOrderAddress').focus();
        return;
    } else {
        removeMsg("culturalOrderOrderAddressLabel");
    }
	if (ifAreaLimit == -1){
		$('#culturalOrderOrderArea').val($('#culturalOrderOrderAreaShow').val()+","+$("#culturalOrderOrderAreaShow").find("option:selected").text());
	}
	$.post("${path}/culturalOrderOrder/saveCulturalOrderOrder.do",$('#culturalOrderOrderForm').serialize(),function(data){
		switch (data) {
	        case("success"):
	        	 dialogAlert("系统提示", "保存成功！", function () {
	        		 window.location.href ="../culturalOrderOrder/culturalOrderOrderList.do?culturalOrderLargeType="+$('#culturalOrderLargeType').val();
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
	window.location.href="${path}/culturalOrderOrder/culturalOrderOrderList.do?culturalOrderLargeType="+$('#culturalOrderLargeType').val();
}
</script>
</head>
<body>
<form action="" id="culturalOrderOrderForm" method="post">
	<input type="hidden" value="${orderOrder.culturalOrderOrderId}" id="culturalOrderOrderId" name="culturalOrderOrderId"/>
	<input type="hidden" value="${culturalOrderLargeType}" id="culturalOrderLargeType"/>
	<div class="site-title">
		点单列表&gt;修改
	</div>
	<div class="main-publish">
	  	<table width="100%" class="form-table assnResVideos">
	  		<tr>
	            <td width="150" class="td-title"><span class="red">*</span>服务日期：</td>
	            <td class="td-time td-input td-online"id="orderDateLabel">
	            	<div class="starts w340">
	            		<input type="hidden" id="orderDateHidden" value="<fmt:formatDate value='${orderOrder.culturalOrderOrderDate}' pattern='yyyy-MM-dd'/>"/>
	                    <span class="text"></span>
	                    <input type="text" id="orderDate" name="orderDate"
	                    value="<fmt:formatDate value='${orderOrder.culturalOrderOrderDate}' pattern='yyyy-MM-dd'/>" readonly/>
	                    <i class="data-btn start-btn"></i>
	                </div>
	            </td>
        	</tr>
        	<tr>
	            <td width="150" class="td-title"><span class="red">*</span>服务时段：</td>
	            <td class="td-input" id="culturalOrderOrderPeriodLabel">
	            	<input type="text" id="culturalOrderOrderPeriod" name="culturalOrderOrderPeriod" class="input-text w510" value="${orderOrder.culturalOrderOrderPeriod}"/>
	            </td>
	        </tr>
	        <c:if test="${culturalOrderAreaLimit != '-1,不限'}">
	        <tr>
	            <td width="150" class="td-title"><span class="red">*</span>区县：</td>
	            <td class="td-select" id="culturalOrderOrderAreaLabel">
	            	<input type="hidden" id="culturalOrderOrderArea" name="culturalOrderOrderArea" value="${orderOrder.culturalOrderOrderArea}">
	            	${fn:split(culturalOrderAreaLimit,',')[1]}
	            </td>
	        </tr>
	        </c:if>
	        <c:if test="${culturalOrderAreaLimit == '-1,不限'}">
	        <tr>
	            <td width="150" class="td-title"><span class="red">*</span>区县：</td>
	            <td class="td-select" id="culturalOrderOrderAreaLabel">
	            	<input type="hidden" id="culturalOrderOrderArea" name="culturalOrderOrderArea" value="${orderOrder.culturalOrderOrderArea}">
	            	<select id="culturalOrderOrderAreaShow" name="culturalOrderOrderAreaShow" class="ng-select-box" onchange="changeTown()">
					</select>
	            </td>
	        </tr>
	        </c:if>
	        <tr>
	            <td width="150" class="td-title"><span class="red">*</span>街道：</td>
	            <td class="td-select" id="culturalOrderOrderTownLabel">
	            	<select id="culturalOrderOrderTown" name="culturalOrderOrderTown" class="ng-select-box">
					</select>
	            </td>
	        </tr>
	        <tr>
	            <td width="150" class="td-title"><span class="red">*</span>详细地址：</td>
	            <td class="td-input" id="culturalOrderOrderAddressLabel">
	            	<input type="text" id="culturalOrderOrderAddress" name="culturalOrderOrderAddress" class="input-text w510" value="${orderOrder.culturalOrderOrderAddress}"/>
	            </td>
	        </tr>
	        <tr>
	            <td width="150" class="td-title"><span class="red">*</span>用户说明：</td>
	            <td class="td-input" id="userDescriptionLabel">
	            	<textarea id="userDescription" name="userDescription" rows="5" class="dingdTextareaBox"  maxlength="200" style="width: 500px;resize: none">${orderOrder.userDescription}</textarea>
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
