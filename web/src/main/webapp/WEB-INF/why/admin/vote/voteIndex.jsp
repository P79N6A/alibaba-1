<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>投票项目管理--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">
        $(function(){
        	//分页
            kkpager.generPageHtml({
                pno : '${page.page}',
                total : '${page.countPage}',
                totalRecords :  '${page.total}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    searchvote();
                    return false;
                }
            });
        	

            new Clipboard('.copyButton');
            
        });

        
        function copy(voteId){
        	var clipBoardContent='hs.hb.wenhuayun.cn/wechatFunction/voteIndex.do?voteId=';
        	clipBoardContent+=voteId;
        	
        	//if(window.clipboardData && window.clipboardData.setData){  
        		  
           //     window.clipboardData.setData("Text",clipBoardContent);
                
            //    dialogAlert('提示', '复制成功');
          
           // }else{  
          
            	  dialogAlert('复制成功', clipBoardContent);
          
          //  }  
        
        }
        
        function deleteVote(voteId){
        	dialogConfirm("提示", "您确定要进行此操作吗？", function(){
                $.post("${path}/vote/saveVote.do",{"voteId":voteId,"voteIsDel":2}, function(data) {
                    if (data!=null && data=='success') {
                    	 $("#backForm").submit();
                    }else{
		                dialogAlert('系统提示', '删除失败！');
		            }
                });
            }) 
        }
        
    </script>
</head>
<body>

 
<form id="backForm" method="post" action="">
<div class="site">
    <em>您现在所在的位置：</em>运维管理 &gt; 线上投票
</div>
<div class="search">
    
	    <div class="menage-box">
	        <a class="btn-add" href="${path}/vote/preAddVote.do">添加投票项目</a>
	        <a class="btn-add" href="#" onclick="javascript:window.open('/why/STATIC/html/help1.html');">帮助说明</a>
	    </div>
</div>
<div class="main-content">
   <table width="100%">
        <thead>
        <tr>
            <th>投票项目名称</th>
            <th>封面主标题</th>
            <th>封面副标题</th>
            <th>封面图</th>
            <th>参加人数</th>
            <th>创建时间</th>
            <th >管理</th>
        </tr>
        </thead>
        <tbody id="questionAnwser">
        <c:if test="${!empty voteList}">
            <c:forEach items="${voteList}" var="vote" varStatus="status">
                <tr>
                 	<td class="title">${vote.voteName }</td>
 					<td width="170">${vote.voteTitle }</td>
 					<td width="170">${vote.voteSecondTitle }</td>
					<c:choose>
					<c:when test="${empty vote.coverImgUrl}">
						<td>无</td>
					</c:when>
					<c:otherwise> 
					<td data-id="${vote.coverImgUrl}">
	                    <img src="${vote.coverImgUrl}@150w" data-url=""  width="60" height="30"/>
	                </td>
	                </c:otherwise>
	                </c:choose>
					 <td>${vote.userCount }</td>
                      <td >
                    	<fmt:formatDate value="${vote.voteCreateTime}" pattern="yyyy-MM-dd HH:mm"/>
                      </td>
                     
                    <td>
                    		<a target="main" href="${path}/vote/preEditVote.do?voteId=${vote.voteId}">编辑</a> |
                    		<a target="main" data-clipboard-text='hs.hb.wenhuayun.cn/wechatFunction/voteIndex.do?voteId=${vote.voteId}' class="copyButton" onclick="copy('${vote.voteId}')">复制链接</a> |
                    		<a target="main" href="${path}/voteItem/managerVoteItem.do?voteId=${vote.voteId}">管理选项</a> |
                    		<c:if test="${vote.isUserInfo==2 }">
                    		<a target="main" href="${path}/vote/userList.do?voteId=${vote.voteId}">用户信息</a> |
                    		</c:if>
                    		<a style="color:red;" onclick="deleteVote('${vote.voteId}')" href="#">
                    			删除
                    		</a>
                    		
                	</td>
                </tr>
            </c:forEach> 
        </c:if>
        <c:if test="${empty voteList}">
            <tr>
                <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
            </tr>
        </c:if>
        </tbody>
    </table>
    </div>
    <c:if test="${not empty voteList}">
        <input type="hidden" id="page" name="page" value="${page.page}" />
        <div id="kkpager"></div>
    </c:if>
</form>
</body>
</html>