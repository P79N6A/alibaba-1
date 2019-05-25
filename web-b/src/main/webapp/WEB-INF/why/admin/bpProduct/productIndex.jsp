<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>文化商城列表--文化云</title>
    <%@include file="../../common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript">
    //** 日期控件
    $(function () {
        $(".start-btn").on("click", function () {
            WdatePicker({
                el: 'startDateHidden',
                dateFmt: 'yyyy-MM-dd HH:mm:ss',
                doubleCalendar: true,
                minDate: '',
                maxDate: '#F{$dp.$D(\'endDateHidden\')}',
                position: {left: -224, top: 8},
                isShowClear: false,
                isShowOK: true,
                isShowToday: false,
                onpicked: pickedStartFunc
            })
        });
        $(".end-btn").on("click", function () {
            WdatePicker({
                el: 'endDateHidden',
                dateFmt: 'yyyy-MM-dd HH:mm:ss',
                doubleCalendar: true,
                minDate: '#F{$dp.$D(\'startDateHidden\')}',
                position: {left: -224, top: 8},
                isShowClear: false,
                isShowOK: true,
                isShowToday: false,
                onpicked: pickedendFunc
            })
        })
    });
    function pickedStartFunc() {
        $dp.$('createStartTime').value = $dp.cal.getDateStr('yyyy-MM-dd HH:mm:ss');
    }
    function pickedendFunc() {
        $dp.$('createEndTime').value = $dp.cal.getDateStr('yyyy-MM-dd HH:mm:ss');
    }
        //提交表单
        function formSub(formName){
        	var searchKey = $("#searchKey").val();
            if(searchKey == "请输入商品名称"){		//"\\"代表一个反斜线字符\
                $("#searchKey").val("");
            }
            $(formName).submit();
        }
        
      //删除到回收站
        function deleteProduct(productId,name){
            var html = "您确定要删除" + name + "吗？";
            dialogConfirm("提示", html, function(){
                $.post("${path}/bpProduct/deleteProduct.do",{"productId":productId}, function(data) {
                    if (data!=null && data=='success') {
                        dialogSaveDraft("提示", "<h2>已删除</h2>", function(){
                            window.location.href="${path}/bpProduct/productIndex.do";
                        });
                    }else {
                        dialogSaveDraft("提示", "<h2>删除失败,请联系管理员<h2>", function(){
                        });
                    }
                });
            })
        }

        function moveProduct(productId,name) {
        	var productStatus;
        	var type = $("#remove_"+productId).text();
        	var html = "您确定要"+type + name + "吗？";
        	if(type == "上架"){
        		productStatus = "1";
        	}else{
        		productStatus = "3";
        	}
        	dialogConfirm("提示", html, function(){
	            $.post("${path}/bpProduct/removeProduct.do?productId="+productId+"&productStatus="+productStatus,function (data) {
	                if (data != null && data == 'success') {
	                	dialogSaveDraft("提示", "<h2>"+type+"成功</h2>", function(){
	                        
	                    });
	                	 if(type == "上架"){
	                		 $("#remove_"+productId).text("下架");
	                	}else{
	                		$("#remove_"+productId).text("上架");
	                	} 
	                 }
	                else if (data=='failure'){
	                	
	                	 dialogAlert('提示', '操作失败，系统错误！');
	                }
	            });
        	})
     };
        function showInfo(info){
        	dialogSaveDraft("商品简介", info, function(){
                
            });
        }; 
        function toPreview(id){
        	var frontUrl = getFrontUrl();
        	window.open(frontUrl+"wechatBpProduct/preProductDetail.do?productId="+id);
        }
        $(function(){
            kkpager.generPageHtml({
                pno : '${page.page}',
                total : '${page.countPage}',
                totalRecords :  '${page.total}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#productIndexForm');
                    return false;
                }
            });
        });

    </script>

</head>
<body>
	<input id="productTypeCount" type="hidden" value="1"/>
	<%--条件检索--%>
	<form id="productIndexForm" action="${path}/bpProduct/productIndex.do" method="post">
	
	    <div class="site">
	        <em>您现在所在的位置：</em>文化商城&gt; 文化商城列表
	    </div>
	
	    <div class="search">
	
	        <div class="search-box">
	            <i></i><input id="searchKey" name="searchKey" class="input-text" data-val="请输入商品名称" type="text"
	                          value="<c:choose><c:when test="${not empty searchKey}">${searchKey}</c:when><c:otherwise>请输入商品名称</c:otherwise></c:choose>"/>
	        </div>
	
	        <div class="form-table" style="float: left;">
	            <div class="td-time" style="margin-top: 0px;">
	                <div class="start w340" style="margin-left: 8px;">
	                    <span class="text">创建时间</span>
	                    <input type="hidden" id="startDateHidden"/>
	                    <input type="text" id="createStartTime" name="createStartTime" style="width: 120px"
	                           value="${createStartTime}" readonly/>
	                    <i class="data-btn start-btn"></i>
	                </div>
	                <span class="txt" style="line-height: 42px;">至</span>
	                <div class="end w340">
	                    <span class="text">创建时间</span>
	                    <input type="hidden" id="endDateHidden"/>
	                    <input type="text" id="createEndTime" name="createEndTime" value="${createEndTime}"
	                       style="width: 120px" readonly/>
	                    <i class="data-btn end-btn"></i>
	                </div>
	            </div>
	        </div>
	
	        <div class="select-btn">
	            <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#productIndexForm')"/>
	        </div>
	
	    </div>

	<div class="main-content pt10">
	    <table width="100%">
	        <thead>
	        <tr>
	            <th>ID</th>
	            <th class="title">商品名称</th>
	            <th class="info">简介</th>
	            <th>模块</th>
	            <th>操作人</th>
	            <th>创建时间</th>
	            <th>最新操作时间</th>
	            <th>管理</th>
	        </tr>
	
	        </thead>
	        <c:if test="${empty list}">
	            <tr>
	                <td colspan="8"> <h4 style="color:#DC590C">暂无数据!</h4></td>
	            </tr>
	        </c:if>
	
	        <tbody>
	
	        <c:forEach items="${list}" var="c" varStatus="s">
	            <tr>
	                <td>${s.index+1}</td>
	                <td class="title">${c.productName}</td>
	             	<td>
	             		<c:choose >
	             			<c:when test="${fn:length(c.productInfo)>20 }"><a href="javascript:showInfo('${c.productInfo}')">${fn:substring(c.productInfo, 0, 20)}...</a> </c:when>
	             			<c:otherwise><a href="javascript:showInfo('${c.productInfo}')">${c.productInfo}</a></c:otherwise>  
	             		</c:choose> 
	             	</td>
	             	<td>${c.productModule}</td>
	                <td>${c.productUpdateUser}</td>
	                <td><fmt:formatDate value="${c.productCreateTime}" pattern="yyyy-MM-dd HH:mm" /></td>
	                <td><fmt:formatDate value="${c.productUpdateTime}" pattern="yyyy-MM-dd HH:mm" /></td>
	                <td>
	               		<a href="" onclick="toPreview('${c.productId}')">预览</a>| 
	               		<c:choose>
	                        	<c:when test="${c.productStatus== 1 }">
	                        	<a id="remove_${c.productId}" href="javascript:moveProduct('${c.productId}','${c.productName}')">下架</a>|
	                        	</c:when>
	                       	 <c:when test="${c.productStatus== 3 }">
	                        	<a id="remove_${c.productId}" href="javascript:moveProduct('${c.productId}','${c.productName}')">上架</a>|
	                        	</c:when>
	                        </c:choose>
	                    <% 
	               			if(bpProductPreEditButton){
	               		%>
	               		<a href="${path}/bpProduct/preEditProduct.do?&productId=${c.productId}">编辑</a>|
	               		<% 
	               			}
	               		%>
	               		<% 
	               			if(bpProductDeleteButton){
	               		%>
	               		<a class="delete" href="javascript:deleteProduct('${c.productId}','${c.productName}')">删除</a>|	
	               		<% 
	               			}
	               		%>
	               		<a href="${path}/bpProduct/orderIndex.do?&productId=${c.productId}">查看预约信息</a>
	                </td>
	            </tr>
	        </c:forEach>
	        </tbody>
	    </table>
	</div>
	    <c:if test="${not empty list}">
	        <input type="hidden" id="page" name="page" value="${page.page}" />
	        <div id="kkpager"></div>
	    </c:if>
	</form>

</body>
</html>