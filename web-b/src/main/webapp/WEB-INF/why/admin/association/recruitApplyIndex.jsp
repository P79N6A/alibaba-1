<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
   <%-- <link rel="stylesheet" type="text/css" href="${path}/STATIC/select2/normalize.css"/>
    <script type="text/javascript" src="${path}/STATIC/select2/jquery-2.1.4.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/select2/select2.min.css"/>
    <script type="text/javascript" src="${path}/STATIC/select2/select2.full.min.js" ></script> --%>
    
    <script type="text/javascript">
	    var userId = '${sessionScope.user.userId}';
		if (userId == null || userId == '') {
	        window.location.href = '${path}/admin.do';
	    }
    
        //搜索
        function formSub(formName){
            
            $(formName).submit();
        }
        
        $(document).ready(function(){
            //分页
            kkpager.generPageHtml({
                pno : '${page.page}',
                total : '${page.countPage}',
                totalRecords :  '${page.total}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#associationForm');
                    return false;
                }
            });
            
            $.ajaxSetup({
            	  async: false
            });
        });
        
      	//删除
		function deleteAssn(recruitApplyId){
			dialogConfirm("提示", "您确定要删除此招募会员吗？", function(){
                $.get("${path}/association/deleteRecruitApply.do",{"recruitApplyId":recruitApplyId}, function(data) {
                    if (data == 'success') {
                    	dialogConfirm("提示", "删除成功！", function(){
                    		//location.reload();
                    		$("#associationForm").submit();
                    	})
                    }else{
		                dialogAlert('提示', '删除失败！');
		            }
                });
            }) 
		}
      	
		//** 日期控件
        $(function () {
            $(".start-btn").on("click", function () {
                WdatePicker({
                    el: 'startDateHidden',
                   /*  dateFmt: 'yyyy-MM-dd  HH:mm', */
                    dateFmt: 'yyyy-MM-dd',
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
                    dateFmt: 'yyyy-MM-dd',
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
            $dp.$('applyStartTimeString').value = $dp.cal.getDateStr('yyyy-MM-dd');
        }
        function pickedendFunc() {
            $dp.$('applyEndTimeString').value = $dp.cal.getDateStr('yyyy-MM-dd');
        }
        $(function(){
			$("select").select2({
				width: "300",
			});
		})
		function func(){  
        	//获取被选中的option标签  
        	var vs = $('select option:selected').val();
        	$("#assnName").val(vs);
		 } 

    </script>
</head>
<body>
	<form id="associationForm" action="${path}/association/recruitApplyIndex.do" method="post">
	<input type="hidden" id="assnId" name="assnId" value="${recruitApply.assnId}"/>
		<div class="site">
		    <em>您现在所在的位置：</em>社团管理 &gt;社团招募列表
		</div>
	    <div class="subject-content" style="padding-bottom: 62px;">
			<div class="search">
			    <div class="search-box">
			        <i></i><input type="text" id="selectinput" name="selectinput" value="${recruitApply.selectinput}" placeholder="请搜素用户名/姓名/身份证号/手机号" class="input-text"/>
			    </div>
			    <%-- <div class="search-box">
			        <i></i><input type="text" id="assnName" name="assnName" value="${recruitApply.assnName}" placeholder="请输入社团名称" class="input-text"/>
			    </div> --%>
			    <div class="main">
			    	<input type="hidden" id="assnName" name="assnName" value="${recruitApply.assnName}"/>
					<select onchange="func()">
						<option value="">社团名称</option>
					<c:forEach items="${assnlist}" var="as">
						<option value="${as.assnName}" <c:if test="${recruitApply.assnName== as.assnName}">selected="true"</c:if>>${as.assnName}</option>
					</c:forEach>
					</select>
				</div>
			    <div class="form-table" style="float: left;">
		            <div class="td-time" style="margin-top: 0px;">
		                <div class="start w240" style="margin-left: 8px;width: 200px;">
		                    <span class="text">申请开始时间</span>
		                    <input type="hidden" id="startDateHidden"/>
		                    <input type="text" id="applyStartTimeString" name="applyStartTimeString"
		                           value="${recruitApply.applyStartTimeString}" readonly/>
		                    <i class="data-btn start-btn"></i>
		                </div>
		                <span class="txt" style="line-height: 42px;">至</span>
		                <div class="end w240" style="width: 200px;">
		                    <span class="text">申请结束时间</span>
		                    <input type="hidden" id="endDateHidden"/>
		                    <input type="text" id="applyEndTimeString" name="applyEndTimeString" value="${recruitApply.applyEndTimeString}"
		                           readonly/>
		                    <i class="data-btn end-btn"></i>
		                </div>
		            </div>
	        	</div>
			
			    <div class="select-btn">
			        <input type="button" onclick="$('#page').val(1);formSub('#associationForm');" value="搜索"/>
			    </div>
			</div>
			<div class="main-content">
			    <table width="100%">
			        <thead>
				        <tr>
				            <th width="30">ID</th>
				            <th width="100">用户名</th>
				            <th width="100">姓名</th>
				            <th width="200">身份证号码</th>
				            <th width="100">联系方式</th>
				            <th width="200">申请社团</th>
				            <th width="200">申请时间</th>
	                		<th width="200">管理</th>
				        </tr>
			        </thead>
			        <tbody>
			        <%int i=0;%>
			        <c:forEach items="${recruitApplyList}" var="assn">
			            <%i++;%>
			            <tr>
			                <td ><%=i%></td>
		                    <td>${assn.userName}</td>
		                    <td>${assn.applyName}</td>
		                    <td>${assn.applyCard}</td>
			                <td>${assn.moblie}</td>
			                <td>${assn.assnName}</td>
			                <td><fmt:formatDate value="${assn.applyTime}" pattern="yyyy-MM-dd HH:mm"/></td>
		                    <td>
		                    	<a target="main" href="${path}/association/recruitApplyInfo.do?recruitApplyId=${assn.recruitApplyId}">查看</a> |
	                    	 	<a href="javascript:deleteAssn('${assn.recruitApplyId}')" style="color: red;font-weight: bold;">删除</a>
		                    </td>
			            </tr>
			        </c:forEach>
			
			        <c:if test="${empty recruitApplyList}">
			            <tr>
			                <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
			            </tr>
			        </c:if>
			        </tbody>
			    </table>
				<c:if test="${not empty recruitApplyList}">
		            <input type="hidden" id="page" name="page" value="${page.page}"/>
		            <div id="kkpager"></div>
		        </c:if>
			</div>
		</div>
	</form>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
<script type="text/javascript">
    seajs.config({
        alias: {
            "jquery": "jquery-1.10.2.js"
        }
    });

    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });

    window.console = window.console || {log:function () {}}

    seajs.use(['jquery'], function ($) {
        // 查看
        $('.role-view').on('click', function () {
            var roleId = $(this).attr("roleId");
            dialog({
                url: '${path}/role/viewRole.do?roleId='+roleId,
                title: '角色详情',
                width: 500,
                fixed: true
            }).showModal();
            return false;
        });
    });
    
    function dialogTypeSaveDraft(title, content, fn){
        var d = parent.dialog({
            width:400,
            title:title,
            content:content,
            fixed: true,
            okValue: '确 定',
            ok: function () {
                if(fn)  fn();
            }
        });
        d.showModal();
    }
    </script>
</body>
</html>