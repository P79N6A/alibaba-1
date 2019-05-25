<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>

    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    
     <script type="text/javascript"
	src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
	<script type="text/javascript">
		seajs.use([ '${path}/STATIC/js/dialogBack/src/dialog-plus' ], function(
				dialog) {
			window.dialog = dialog;
		});
	</script>

    <script type="text/javascript">
        $(function(){
            getPage();

        });

        // 分页
        function getPage(){
            kkpager.generPageHtml({
                pno : '${page.page}',
                total : '${page.countPage}',
                totalRecords :  '${page.total}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    $("#form").submit();
                    return false;
                }
            });
        }

		function cloudInt(){
			
			var id=$("#userId").val();
				
				dialog(
	    				{
	    					url : '${path}/userIntegral/cloudIntegral.do?userId='+id,
	    					title : '云叔积分',
	    					width : 520,
	    					height : 360,
	    					fixed : true

	    				}).showModal();
	    		return false;
			
		}
       
    </script>
</head>
<body>

<form id="form" action="${path}/userIntegral/userIntegralIndex.do" method="post">
<div class="site">
   <em>您现在所在的位置：</em>会员管理 &gt;用户管理 &gt;积分管理
</div>
    <input type="hidden" name="userId" value="${userId}" id="userId"/>
    <div class="search">
        <div class="form-table" style="float: left;width:480px">
        <p style="float: left; line-height: 42px"> 总积分：${integralNow }</p>
       </div>
        <div class="select-btn" style="float:right;" >
					<input type="button"
					onclick="cloudInt();" id="cloudBtn" value="云叔积分" />
					</div>			
		</div>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th width="180">时间</th>
                <th width="100">积分</th>
                <th width="200">事项</th>
               
            </tr>
            </thead>
            <c:if test="${empty userIntegralDetailList}">
                <tr>
                    <td colspan="8"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            <tbody>
            <c:forEach items="${userIntegralDetailList}" var="c" varStatus="s">
                <tr>
                    <td> <fmt:formatDate value="${ c.createTime}" pattern="yyyy年MM月dd日 HH:mm"/></td>
                   	<td>
                   	<c:choose>
                   		<c:when test="${c.changeType==0 }">
                   			+
                   		</c:when>
                   		<c:otherwise>
                   		-
                   		</c:otherwise>
                   	</c:choose>
                   	
                   	${c.integralChange}</td> 
                   	<td>${c.integralFrom}</td> 
                </tr>
            </c:forEach>

            </tbody>
        </table>
        <c:if test="${not empty userIntegralDetailList}">
            <input type="hidden" id="page" name="page" value="${page.page}" />
            <div id="kkpager"></div>
        </c:if>
    </div>
</form>
</body>
</html>