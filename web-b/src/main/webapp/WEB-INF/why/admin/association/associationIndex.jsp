<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>社团列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    
    <link rel="Stylesheet" type="text/css" href="${path}/STATIC/css/DialogBySHF.css" />
    <script type="text/javascript" src="${path}/STATIC/js/DialogBySHF.js"></script>
    <script type="text/javascript">

        //搜索
        function formSub(formName){
            var  assnName=$('#assnName').val();
            if(assnName!=undefined&&assnName=='输入社团名称'){
                $('#assnName').val("");
            }
            $(formName).submit();
        }
        
        //确定选择
        function checkAssnData(type){
            var assnId = $('input[type="checkbox"]:checked').val();
            var assnName = $('input[type="checkbox"]:checked').next().val();
            if(type==1){
                $("#assnName", parent.document).val(assnName);
                $("#assnId", parent.document).val(assnId);
                $("body",parent.document).find('#DialogBySHFLayer,#DialogBySHF').remove();
            }else{
            	$("body",parent.document).find('#DialogBySHFLayer,#DialogBySHF').remove();
            }
        }
        
        $(document).ready(function(){
        	//复选框只能单选
            $('.main-content').find('input[type=checkbox]').bind('click', function(){
                $('.main-content').find('input[type=checkbox]').not(this).attr("checked", false);
            });
        	
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
        });
        
      	//申请社团
        function preApplyAssn(){
        	var userId = '${sessionScope.user.userId}';
        	if (userId == null || userId == '') {
                window.location.href = '${path}/admin.do';
                return;
            }
            var winH = parseInt($(window).height() * 0.75);
            $.DialogBySHF.Dialog({
                Width: 640,
                Height: winH,
                URL: '${path}/association/preApplyAssn.do'
            });
        }
    </script>
    <style type="text/css">
        .ui-dialog-title,.ui-dialog-content textarea{ font-family: Microsoft YaHei;}
        .ui-dialog-header{ border-color: #9b9b9b;}
        .ui-dialog-close{ display: none;}
        .ui-dialog-title{ color: #F23330; font-size: 20px; text-align: center;}
        .ui-dialog-content{}
        .ui-dialog-body{}
    </style>
</head>
<body>
	<form id="associationForm" action="${path}/association/associationIndex.do" method="post">
	    <div class="subject-content" style="padding-bottom: 62px;">
		    <input type="hidden" name="assnId" value="${association.assnId}"/>
			<div class="search">
			    <div class="search-box">
			        <i></i><input type="text" id="assnName" name="assnName" value="${association.assnName}" data-val="输入社团名称" class="input-text"/>
			    </div>
			
			    <div class="select-btn">
			        <input type="button" onclick="$('#page').val(1);formSub('#associationForm');" value="搜索"/>
			    </div>
			</div>
			<div class="search menage">
			    <h2>社团一览</h2>
			    <div class="menage-box">
			        <a class="btn-add" href="javascript:preApplyAssn();">新增社团</a>
			    </div>
			</div>
			<div class="main-content">
			    <table width="100%">
			        <thead>
				        <tr>
				            <th width="30">单选</th>
				            <th width="30">ID</th>
				            <th width="120">类型</th>
				            <th class="title">社团名称</th>
				            <th>社团简介</th>
				        </tr>
			        </thead>
			        <tbody>
			        <%int i=0;%>
			        <c:forEach items="${associationList}" var="assn">
			            <%i++;%>
			            <tr>
			                <td>
			                    <input type="checkbox" <c:if test="${assn.assnId eq association.assnId}">checked="checked" </c:if>  value="${assn.assnId}"/>
			                    <input type="hidden"  value="${assn.assnName}" />
			                </td>
			                <td ><%=i%></td>
			                <td>
		                        ${assn.assnType}
		                    </td>
		                    <td class="title">
			                    ${assn.assnName}
			                </td>
			                <td>
		                        ${assn.assnIntroduce}
		                    </td>
			            </tr>
			        </c:forEach>
			
			        <c:if test="${empty associationList}">
			            <tr>
			                <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
			            </tr>
			        </c:if>
			        </tbody>
			    </table>
			
			    <input type="hidden" id="page" name="page" value="${page.page}" />
			    <div id="kkpager"></div>
			</div>
		</div>
	    <div class="form-table form_table_btn" style="position: fixed; bottom: 0; width: 100%; padding: 10px 0 30px; background: #ffffff;">
	        <input class="btn-publish" type="button" onclick="checkAssnData(1)" value="确定"/>
	        <input class="btn-save" type="button" onclick="checkAssnData(2)" value="取消"/>
	    </div>
	</form>
</body>
</html>