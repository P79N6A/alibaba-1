<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>

    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

    <script type="text/javascript">
        $(function(){
            getPage();

            // 冻结
            freeTerminalUser();
            // 激活
            activeTerminalUser();
            
            selectModel();
            
            $(".tuserInfo").on("click",function(){
    			
    			var tuserId=$(this).attr("tuserId");
    			
    			var userId=$("#userId").val();
    			
    			window.location.href="${path}/teamUser/editTeamUserInfo.do?tuserId="+tuserId+"&tuserIsActiviey="+tuserIsActiviey+"&userId="+userId;
    			
    			
    		});
            
  			 $(".tuserAuth").on("click",function(){
    			
    			var tuserId=$(this).attr("tuserId");
    			
    			var userId=$("#userId").val();
    			
    			var tuserIsActiviey=$("#tuserIsActiviey").val();
    			
    			window.location.href="${path}/teamUser/authTeamUserInfo.do?tuserId="+tuserId+"&userId="+userId+"&tuserIsActiviey="+tuserIsActiviey;
    			
    		});
            
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
                    formSub('#teamUserForm');
                    return false;
                }
            });
        }

        //搜索
        function formSub(formName){
            if($("#tuserName").val() == "输入使用者名称关键词"){
                $("#tuserName").val("");
            }
            $(formName).submit();
        }

        function freeTerminalUser(){
            $(".active").on("click", function(){
                var tuserId = $(this).attr("tuserId");
                var tuserIsDisplay=$("#tuserIsDisplay").val();
                var userId=$("#userId").val();
                var name = $(this).parent().siblings(".title").find("a").text();
                var html = "您确定要冻结" + name + "吗？";
                dialogConfirm("提示", html, function(){
                    $.post("${path}/teamUser/freezeTeamUser.do",{tuserId:tuserId},function(data) {
                        if (data == 'success') {
                            window.location.href="${path}/teamUser/teamUserIndex.do?tuserIsDisplay="+tuserIsDisplay+"&userId="+userId;
                        }
                    });
                })
            });
        }

        function activeTerminalUser(){
            $(".freeze").on("click", function(){
                var tuserId = $(this).attr("tuserId");
                var tuserIsDisplay=$("#tuserIsDisplay").val();
                var userId=$("#userId").val();
                var name = $(this).parent().siblings(".title").find("a").text();
                var html = "您确定要激活" + name + "吗？";
                dialogConfirm("提示", html, function(){
                    $.post("${path}/teamUser/activeTeamUser.do",{tuserId:tuserId},function(data) {
                        if (data == 'success') {
                            window.location.href="${path}/teamUser/teamUserIndex.do?tuserIsDisplay="+tuserIsDisplay+"&userId="+userId;
                        }
                    });
                })
            });
        }
    </script>
</head>
<body>

<form id="teamUserForm" action="${path}/teamUser/teamUserIndex.do" method="post">
<input type="hidden" value="${record.userId }" id="userId" name="userId"/>
<input type="hidden" value="${record.tuserIsActiviey }" id="tuserIsActiviey" name="tuserIsActiviey"/>
<div class="site">
    <em>您现在所在的位置：</em>使用者列表
</div>
   
    <div class="search">
     
        <div class="select-box w135" >
				 <input type="hidden" name="tuserIsDisplay" value="${record.tuserIsDisplay}" id="tuserIsDisplay"/>
				<div class="select-text" data-value="tuserIsDisplayDiv">
					<c:choose>
						<c:when test="${record.tuserIsDisplay==0}">
                    	认证中
                </c:when>
						<c:when test="${record.tuserIsDisplay==1}">
                    	认证通过
                </c:when>
						<c:when test="${record.tuserIsDisplay==3}">
                    	认证不通过
                </c:when>
						<c:otherwise>
               		使用者认证状态
               </c:otherwise>
					</c:choose>
				</div>
				<ul class="select-option">
					<li data-option="">使用者认证状态</li>
					<li data-option="0">认证中</li>
					<li data-option="1">认证通过</li>
					<li data-option="3">认证不通过</li>
				</ul>
			</div>
     	  <div class="search-box"  style="float:left;">
            <i></i><input class="input-text" name="tuserName" data-val="输入使用者名称关键词" value="<c:choose><c:when test='${not empty record.tuserName}'>${record.tuserName}</c:when><c:otherwise>输入使用者名称关键词</c:otherwise></c:choose>" type="text" id="tuserName"/>
        </div>
        
        <div class="select-btn" style="float:left;">
            <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#teamUserForm');"/>
        </div>
        <div style="clear:both;"></div>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th width="65">ID</th>
                <th class="title">使用者名称</th>
                <th width="60">类别</th>
                <th width="100">实名认证</th>
                <th width="100">手机号</th>
                <th class="80">所属区县</th>
                <th class="80">使用者认证状态</th>
                <th class="80">认证时间</th>
                <th width="160">管理</th>
            </tr>
            </thead>
            <c:if test="${empty list}">
                <tr>
                    <td colspan="9"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            <tbody>
            <c:forEach items="${list}" var="c" varStatus="s">
                <tr>
                    <td width="65">${s.index+1}</td>
                    <td class="title">${c.tuserName}</td>
                    <td>
                    	<c:choose>
							<c:when test="${c.tuserUserType==0}">
                    		社团
                    		</c:when>
									<c:when test="${c.tuserUserType==1}">
                    		个人
                    		</c:when>
									<c:when test="${c.tuserUserType==2}">
                    		公司
                    		</c:when>
                    		</c:choose>
                    </td>
                    <td width="100">${c.managerName}</td> 
                    <td width="100">${c.userTelephone}</td>
             		<td class="80">${fn:substring(c.tuserCounty, fn:indexOf(c.tuserCounty, ",")+1,fn:length(c.tuserCounty))}</td>
                  	<td><c:choose>
							<c:when test="${c.tuserIsDisplay==0}">
                    		认证中
                    		</c:when>
									<c:when test="${c.tuserIsDisplay==1}">
                    		认证通过
                    		</c:when>
									<c:when test="${c.tuserIsDisplay==3}">
                    		认证不通过
                    		</c:when>
                    		</c:choose>
                    </td>
                     <td class="80"><fmt:formatDate value="${c.tUpdateTime}" pattern="yyyy-MM-dd  HH:mm" /></td>
                    <td width="160" class="td-editing">

                        <c:if test="${c.tuserIsActiviey==1}">
                            <%if(teamFreezeButton){%>
                            <c:if test="${c.tuserIsDisplay==1}">
                                <a class="active" tuserId="${c.tuserId}">冻结</a> |
                              </c:if>
                            <%}%>
                            <%if(teamPreEditButton){%>
                            <c:choose>
                            <c:when test="${c.tuserIsDisplay==0}">
                    		 	<a tuserId="${c.tuserId }" class="tuserAuth" >认证</a>
                    		</c:when>
                    	  
                    		<c:otherwise>
                    		      <a tuserId="${c.tuserId }"  class="tuserInfo">编辑</a>
                    		</c:otherwise>
                    		</c:choose>
                                
                                <%if(teamViewButton){%> | <%}%>
                            <%}%>
                            <%if(teamViewButton){%>
                            <a href="${path}/teamUser/viewTeamUser.do?tuserId=${c.tuserId}">查看</a>
                            <%}%>
                        </c:if>

                        <c:if test="${c.tuserIsActiviey == 2}">
                            <%if(teamActiveButton){%>
                                <a class="freeze" tuserId="${c.tuserId}">激活</a> |
                            <%}%>
                            <%if(teamPreWaiteEditButton){%>
                                <!-- <a href="${path}/teamUser/preEditTeamUser.do?tuserId=${c.tuserId}">编辑</a> --><%if(teamViewButton){%>  <%}%>
                            <%}%>
                            <%if(teamViewWaiteButton){%>
                            <a href="${path}/teamUser/viewTeamUser.do?tuserId=${c.tuserId}">查看</a>
                            <%}%>
                        </c:if>




                            <%--<c:if test="${c.tuserIsDisplay != 0}">--%>
                                <%--<a href="${path}/terminalUser/teamTerminalUserIndex.do?tuserId=${c.tuserId}">成员</a>--%>
                            <%--</c:if>--%>
                    </td>
                </tr>
            </c:forEach>

            </tbody>
        </table>
        <c:if test="${not empty list}">
            <input type="hidden" id="page" name="page" value="${page.page}" />
            <div id="kkpager"></div>
        </c:if>
    </div>
</form>
</body>
</html>