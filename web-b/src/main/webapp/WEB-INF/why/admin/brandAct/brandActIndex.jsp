<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>文化云</title>
<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
<%@include file="/WEB-INF/why/common/limit.jsp"%>
<!--文本编辑框 end-->
<!-- dialog start -->
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css" />
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>

	
<script type="text/javascript">

	var userId = '${sessionScope.user.userId}';

	if (userId == null || userId == '') {
		location.href = '${path}/admin.do';
	}

	$(function() {
		kkpager.generPageHtml({
			pno : '${page.page}',
			total : '${page.countPage}',
			totalRecords : '${page.total}',
			mode : 'click',
			click : function(n) {
				this.selectPage(n);
				$("#page").val(n);
				formSub('#lawnActForm');
				return false;
			}
		});
		selectModel();
	
		
	});

	seajs.config({
		alias : {
			"jquery" : "jquery-1.10.2.js"
		}
	});

	seajs.use([ '${path}/STATIC/js/dialogBack/src/dialog-plus' ], function(
			dialog) {
		window.dialog = dialog;
	});
	
	seajs.use(['jquery'], function ($) {
		$(function() {
        //删除
        $(".btn-del").click(function () {
            var enterId = $(this).attr("enterId");
            var name = $(this).parent().siblings(".title").text();
            var html = "您确定要删除" + name + "吗？";
            dialogConfirm("提示", html, function(){
                $.post("${path}/activityBrand/cmsActivityBrandDel.do",{id:enterId},function(data) {
                    if (data.status == 'ok') {
                 	   formSub('#lawnActForm');
                    }
                });
            })
        });
        
    });
	});
	

	//提交表单
	function formSub(formName) {
		$(formName).submit();
	}
	
	
	
	
	
	function changeFlag(ID,actFlag){
		if(actFlag==1){
			var info = '确定要下架？'
		}else{
			var info = '确定要上架？'
		}
		dialogConfirm("提示", info,function(){
    		$.post("${path}/activityBrand/cmsActivityBrandDownOrUp.do",{id:ID,actFlag:actFlag},function(data){
    			if(data.status=="ok"){
    				dialogTypeSaveDraft("提示",data.msg,function(){
    					location.reload();
    				});
    			}else{
    				dialogTypeSaveDraft("提示",data.msg,'');
    			}
    		})
    	});
	}
	
	
	
	
	
	function changeOrder(ID,flag){
		var actName = $('#actName').val();
		var actText = $('#actText').val();
		var actType = $('#actType').val();
		var actFlag = $('#actFlag').val();
		$.post("${path}/activityBrand/changeOrder.do",{id:ID,flag:flag,actName:actName,actText:actText,actType:actType,actFlag:actFlag},function(data){
			if(data=='success'){
				location.reload();	
			}else{
				dialogTypeSaveDraft("提示",data,'');
			}
   		});
	}
	
	
	
	

	
	
	
	 //内容查看
    function look(ID,flag){
		 var str;
		 if(flag==0){
			 str = '活动描述'
		 }else if(flag==1){
			 str = '图片路径'
		 }else{
			 str = '链接路径'
		 }
         dialog({
             url: '${path}/activityBrand/cmsActivityBrandLook.do?id='+ID+'&flag='+flag,
             title: str,
             width: 500,
             fixed: true
         }).showModal();
         return false;
     }
	
	
	function dialogTypeSaveDraft(title, content, fn){
        var d = dialog({
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

</head>
<body>
	<form id="lawnActForm" action="" method="post">
		<div class="site">
			<em>您现在所在的位置：</em>运维管理 &gt; 大活动管理
		</div>
		<div class="site-title"></div>

		<div class="search">
			<div class="search-box">
				<i></i><input type="text" id="actName" name="actName"
					value="${cmsActivityBrand.actName}" placeholder="输入活动名称"
					class="input-text" />
			</div>
			<div class="search-box">
				<i></i><input type="text" id="actText" name="actText"
					value="${cmsActivityBrand.actText}" placeholder="输入活动内容"
					class="input-text" />
			</div>
		 	<div class="select-box w135">
				<input type="hidden" value="${cmsActivityBrand.actType}"
					name="actType" id="actType" />
				<div class="select-text" data-value="">
					<c:choose>
						<c:when test="${cmsActivityBrand.actType==0}">
	                      	重大活动
	                    </c:when>
						<c:otherwise>
	                      	区县类型
	                    </c:otherwise>
					</c:choose>
				</div>
				<ul class="select-option">
					<li data-option="">活动类型</li>
					<li data-option="0">重大活动</li>
					<li data-option="1">区县类型</li>
				</ul>
			</div>


			<div class="select-box w135">
				<input type="hidden" value="${cmsActivityBrand.actFlag}"
					name="actFlag" id="actFlag" />
				<div class="select-text" data-value="">
					<c:choose>
						<c:when test="${cmsActivityBrand.actFlag==1}">
	                      	未下架
	                    </c:when>
						<c:when test="${cmsActivityBrand.actFlag==2}">
	                      	已下架
	                    </c:when>
						<c:otherwise>
	                      	活动状态
	                    </c:otherwise>
					</c:choose>
				</div>
				<ul class="select-option">
					<li data-option="">活动状态</li>
					<li data-option="1">未下架</li>
					<li data-option="2">已下架</li>
				</ul>
			</div>


			<div class="select-btn">
				<input type="button"
					onclick="$('#page').val(1);formSub('#lawnActForm');" value="搜索" />
			</div>
			
			
			
			<div class="search menage">
				<div class="menage-box">
					<a target="main" class="btn-add"  href='${path}/activityBrand/cmsActivityBrandAddFrame.do?actType=0'>新增大活动</a>	
					<a target="main" class="btn-add"  href='${path}/activityBrand/cmsActivityBrandAddFrame.do?actType=1'>新增区县活动</a>	
			    </div>
			</div>
		</div>



		<div class="main-content">
			<table width="100%">
				<thead>
					<tr>
						<th>编号</th>
						<th>活动名称</th>
						<th>活动标签</th>
						<th>活动正文</th>
						<th>图片路径</th>
						<th>活动外链路径</th>
						<th>活动创建时间</th>
						<th>最新修改时间</th>
						<th>操作人</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<%
						int i = 0;
					%>
					<c:forEach items="${list}" var="lawnAct">
						<%
							i++;
						%>
						<tr>
							<td><%=i%></td>
							<td class="title" style="text-align:center;">
								<c:choose>
									<c:when test="${empty lawnAct.actName}">
				                      	-
				                    </c:when>
									<c:otherwise>
				                      	${lawnAct.actName }
				                    </c:otherwise>
								</c:choose>
							</td>
							<td>
								<c:choose>
									<c:when test="${empty lawnAct.actTag}">
				                      	-
				                    </c:when>
									<c:otherwise>
				                      	${lawnAct.actTag }
				                    </c:otherwise>
								</c:choose>
							</td>
							<td>
							
								<c:choose>
										<c:when test="${empty lawnAct.actText}">
					                      	-
					                    </c:when>
										<c:otherwise>
					                      	<a href="#" onclick="look('${lawnAct.id}',0)" >查看</a>
					                    </c:otherwise>
								</c:choose>
							</td>
							<td>
								<a href="#" onclick="look('${lawnAct.id}',1)" >查看</a>
							</td>
							<td>
								<a href="#" onclick="look('${lawnAct.id}',2)" >查看</a>
							</td>
							<td><fmt:formatDate value="${lawnAct.createTime}"
									pattern="yyyy-MM-dd HH:mm:ss" />
							</td>
							<td><fmt:formatDate value="${lawnAct.updateTime}"
									pattern="yyyy-MM-dd HH:mm:ss" />
							</td>
							<td>${lawnAct.operator }</td>
							<td>
								<a target="main" enterId=${lawnAct.id}  href="${path}/activityBrand/cmsActivityBrandAddFrame.do?id=${lawnAct.id}&actType=${lawnAct.actType}">编辑</a>
								<c:if test="${lawnAct.actFlag==1 }">
										<a target="main"
											href="javascript:changeFlag('${lawnAct.id}','${lawnAct.actFlag}');"
											style="color: red; font-weight: bold;" >下架</a> |
		                      	</c:if> <c:if test="${lawnAct.actFlag==2 }">
										<a target="main"
											href="javascript:changeFlag('${lawnAct.id}','${lawnAct.actFlag}');"
											style="color: red; font-weight: bold;" >上架</a> |
		                        </c:if> 
		                        <a target="main" enterId=${lawnAct.id} href="javascript:void(0)" class="btn-del">删除</a>
		                        <a target="main"  href="javascript:changeOrder('${lawnAct.id}','0');">下移</a>
		                        <a target="main"  href="javascript:changeOrder('${lawnAct.id}','1');">上移</a>
							</td>
						</tr>
					</c:forEach>
					<c:if test="${empty list}">
						<tr>
							<td colspan="14"><h4 style="color: #DC590C">暂无数据!</h4></td>
						</tr>
					</c:if>
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