<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>配送中心列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>

    <script type="text/javascript">
		var userId = '${sessionScope.user.userId}';
		
		if (userId == null || userId == '') {
			location.href = '${path}/admin.do';
		}
    
        $(function () {
            kkpager.generPageHtml({
                pno: '${page.page}',
                total: '${page.countPage}',
                totalRecords: '${page.total}',
                mode: 'click',//默认值是link，可选link或者click
                click: function (n) {
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#dcVideoForm');
                    return false;
                }
            });
            
            loadArea();
            selectModel();
        });

        //提交表单
        function formSub(formName) {
        	var searchKey=$('#searchKey').val();
            if(searchKey!=undefined&&searchKey=='输入关键词'){
            	$('#searchKey').val("");
            }
            $(formName).submit();
        }
        
        //加载区域
        function loadArea(){
    		var areaData = {areaList:['46,黄浦区','48,徐汇区','49,长宁区','50,静安区','51,普陀区','53,虹口区','54,杨浦区',
    		                          '55,闵行区','56,宝山区','57,嘉定区','58,浦东新区','59,金山区','60,松江区','61,青浦区',
    		                          '63,奉贤区','64,崇明县']}
            var ulHtml = '';
            $.each(areaData.areaList,function(i,dom){
            	ulHtml += '<li data-option="'+dom+'">'+dom.split(',')[1]+'</li>';
            })
            $('#userAreaUl').html(ulHtml);
    	}

    </script>
    <style type="">
    	.videoButton{
    	color: #fff;background-color:rgba(125, 164, 203, 1);border:1px solid rgba(56, 78, 101, 1);font-weight: bolder;border-radius:3px;padding:3px 15px;
    	}
    	.videoReButton{
    	color: #596988;border:1px solid #596988;font-weight: bolder;border-radius:3px;padding:3px 15px;
    	}
    	
    	
    </style>
</head>
<body>
<form id="dcVideoForm" action="${path}/dcVideo/dcVideoIndex.do" method="post">
	<input type="hidden" name="reviewType" value="${dcVideo.reviewType}"/>
    <div class="site">
		<em>您现在所在的位置：</em>配送中心 &gt; 
		<c:if test="${dcVideo.reviewType==1}">技术审核</c:if>
		<c:if test="${dcVideo.reviewType==2}">海选评审</c:if>
		<c:if test="${dcVideo.reviewType==3}">海选复审</c:if>
		<c:if test="${dcVideo.reviewType==4}">专家评审</c:if>
		<c:if test="${dcVideo.reviewType==5}">评分汇总</c:if>
	</div>
	<div class="site-title">
		<c:if test="${dcVideo.reviewType==1}">技术审核</c:if>
		<c:if test="${dcVideo.reviewType==2}">海选评审</c:if>
		<c:if test="${dcVideo.reviewType==3}">海选复审</c:if>
		<c:if test="${dcVideo.reviewType==4}">专家评审</c:if>
		<c:if test="${dcVideo.reviewType==5}">评分汇总</c:if>
	</div>
    <div class="search">
        <div class="select-box w135">
            <input type="hidden" id="userArea" name="userArea" value="${dcVideo.userArea}"/>
            <div id="userAreaDiv" class="select-text" data-value="">全部区域</div>
            <ul class="select-option" id="userAreaUl"></ul>
        </div>
        <c:if test="${dcVideo.reviewType==1 || dcVideo.reviewType==3 || dcVideo.reviewType==5}">
        	<div class="select-box w135">
        		<input type="hidden" id="videoType" name="videoType" value="${dcVideo.videoType}"/>
	            <div id="videoTypeDiv" class="select-text" data-value="">全部参演类别</div>
	            <ul class="select-option">
	            	<li data-option="舞蹈">舞蹈</li>
	            	<li data-option="合唱">合唱</li>
	            	<li data-option="时装">时装</li>
	            	<li data-option="戏曲/曲艺">戏曲/曲艺(全部)</li>
	            	<li data-option="沪剧">戏曲/曲艺(沪剧)</li>
	            	<li data-option="越剧">戏曲/曲艺(越剧)</li>
	            	<li data-option="京剧">戏曲/曲艺(京剧)</li>
	            	<li data-option="其他">戏曲/曲艺(其他)</li>
	            </ul>
	        </div>
        </c:if>
        <c:if test="${dcVideo.reviewType==2 || dcVideo.reviewType==4}">
        	<c:if test="${dcVideo.videoType=='戏曲/曲艺' || dcVideo.videoType=='沪剧' || dcVideo.videoType=='越剧' || dcVideo.videoType=='京剧' || dcVideo.videoType=='其他'}">
        		<div class="select-box w135">
	        		<input type="hidden" id="videoType" name="videoType" value="${dcVideo.videoType}"/>
		            <div id="videoTypeDiv" class="select-text" data-value="">全部戏曲/曲艺</div>
		            <ul class="select-option">
		            	<li data-option="戏曲/曲艺">全部戏曲/曲艺</li>
		            	<li data-option="沪剧">沪剧</li>
		            	<li data-option="越剧">越剧</li>
		            	<li data-option="京剧">京剧</li>
		            	<li data-option="其他">其他</li>
		            </ul>
		        </div>
        	</c:if>
        	<c:if test="${dcVideo.videoType=='舞蹈' || dcVideo.videoType=='合唱' || dcVideo.videoType=='时装'}">
	        	<input type="hidden" id="videoType" name="videoType" value="${dcVideo.videoType}"/>
        	</c:if>
        </c:if>
        <c:if test="${dcVideo.reviewType!=5&&dcVideo.reviewType!=4&&dcVideo.reviewType!=2}">
        	<div class="select-box w135">
	            <input type="hidden" id="videoStatus" name="videoStatus" value="${dcVideo.videoStatus}"/>
	            <div id="videoStatusDiv" class="select-text" data-value="">全部状态</div>
	            <ul class="select-option">
	            	<c:if test="${dcVideo.reviewType==1}">
	            		<li data-option="1">待评审</li>
		            	<li data-option="2">不通过</li>
		            	<li data-option="3">通过</li>
	            	</c:if>
	            	<c:if test="${dcVideo.reviewType==3}">
		            	<li data-option="4">不通过</li>
		            	<li data-option="5">通过</li>
	            	</c:if>
	            </ul>
	        </div>
        </c:if>
        <div class="select-box w135">
            <input type="hidden" id="searchType" name="searchType" value="${dcVideo.searchType}"/>
            <div id="searchTypeDiv" class="select-text" data-value="">作品名称</div>
            <ul class="select-option">
            	<li data-option="1">作品名称</li>
            	<li data-option="2">指导员</li>
            	<li data-option="3">参演团队</li>
            </ul>
        </div>
        <div class="search-box">
	        <i></i><input type="text" id="searchKey" name="searchKey" value="${dcVideo.searchKey}" data-val="输入关键词" class="input-text"/>
	    </div>
        <div class="select-btn">
            <input type="button" onclick="$('#page').val(1);formSub('#dcVideoForm');" value="搜索"/>
        </div>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th width="24">ID</th>
                <th class="title">作品名称</th>
                <th width="140">区域</th>
                <th width="140">参演类别</th>
                <th width="140">指导员</th>
                <th width="140">参演团队</th>
                <c:choose>
                	<c:when test="${dcVideo.reviewType==5}">
                		<th width="140">联系电话</th>
                		<th width="140">人数</th>
                		<th width="100">专家评分</th>
                		<th width="100">大众评分</th>
                		<th width="100">总分</th>
                		<th width="100">排名</th>
                	</c:when>
                	<c:otherwise>
                		<th width="140">人数</th>
                		<th width="140">状态</th>
		                <!-- <th width="140">评审人</th>
		                <th width="140">评审时间</th> -->
                	</c:otherwise>
                </c:choose>
                <th width="140">管理</th>
            </tr>
            </thead>
            <tbody>
            <%int i = 0;%>
            <c:forEach items="${list}" var="video" varStatus="i">
                <%i++;%>
                <tr>
                    <td><%=i%></td>
                    <td class="title">${video.videoName}</td>
                    <td>${fn:substringAfter(video.userArea, ',')}</td>
                    <td>
                    	<c:choose>
                        	<c:when test="${video.videoType=='沪剧'||video.videoType=='越剧'||video.videoType=='京剧'||video.videoType=='其他'}">
                        		戏曲/曲艺(${video.videoType})
                        	</c:when>
							<c:otherwise>
								${video.videoType}
							</c:otherwise>
						</c:choose>
					</td>
                    <td>${video.videoGuide}</td>
                    <td>${video.videoTeamName}</td>
                    <c:choose>
	                	<c:when test="${dcVideo.reviewType==5}">
	                		<td>${video.videoTelephone}</td>
	                		<td>${video.videoTeamCount}</td>
	                		<td>${video.videoExpertScore}</td>
	                		<td>${video.videoPublicScore}</td>
	                		<td>${video.videoTotalScore}</td>
	                		<td>${(page.page-1)*10+i.index+1}</td>
	                	</c:when>
	                	<c:otherwise>
	                		<td>${video.videoTeamCount}</td>
	                		<td>
		                    	<c:if test="${dcVideo.reviewType==1}">
		                    		<c:if test="${video.videoStatus==1}"><span style="color:#338FCC">待评审</span></c:if>
			                    	<c:if test="${video.videoStatus==2}">技术评审未通过，请重新上传视频</c:if>
			                    	<c:if test="${video.videoStatus==3}">技术评审通过，进入海选</c:if>
		                    	</c:if>
		                    	<c:if test="${dcVideo.reviewType==2}">
		                    		<c:if test="${empty video.videoReviewResult}">
		                    			<span style="color:#338FCC">待评审</span>
		                    		</c:if>
		                    		<c:if test="${not empty video.videoReviewResult}">
		                    			<c:if test="${video.videoReviewResult==1}">海选通过</c:if>
		                    			<c:if test="${video.videoReviewResult==0}">海选未通过</c:if>
		                    		</c:if>
		                    	</c:if>
		                    	<c:if test="${dcVideo.reviewType==3}">
		                    		<c:if test="${video.videoStatus==4}">海选未通过</c:if>
			                    	<c:if test="${video.videoStatus==5}">海选通过</c:if>
		                    	</c:if>
		                    	<c:if test="${dcVideo.reviewType==4}">
		                    		<c:if test="${empty video.videoReviewResult}"><span style="color:#338FCC">待评分</span></c:if>
			                    	<c:if test="${not empty video.videoReviewResult}">已评分（${video.videoReviewResult}分）</c:if>
		                    	</c:if>
		                    </td>
		                    <%-- <td>
		                    	<c:if test="${dcVideo.reviewType==1}">${video.videoTreviewUser}</c:if>
		                    	<c:if test="${dcVideo.reviewType==2||dcVideo.reviewType==4}">${video.videoReviewUser}</c:if>
		                    	<c:if test="${dcVideo.reviewType==3}">${video.videoSreviewUser}</c:if>
		                    </td>
		                    <td>
		                    	<c:if test="${dcVideo.reviewType==1}">
		                    		<fmt:formatDate value="${video.videoTreviewTime}" pattern="MM-dd"/>
		                    	</c:if>
		                    	<c:if test="${dcVideo.reviewType==2||dcVideo.reviewType==4}">${video.videoReviewTime}</c:if>
		                    	<c:if test="${dcVideo.reviewType==3}">
		                    		<fmt:formatDate value="${video.videoSreviewTime}" pattern="MM-dd"/>
		                    	</c:if>
		                    </td> --%>
	                	</c:otherwise>
	                </c:choose>
                    <td>
                    	<c:if test="${dcVideo.reviewType==1}">
                    		<c:if test="${video.videoStatus==1}">
	                    		<a target="main" href="${path}/dcVideo/preEditDcVideo.do?videoId=${video.videoId}&reviewType=${dcVideo.reviewType}" class="videoButton">评审</a>
	                    	</c:if>
	                    	<c:if test="${video.videoStatus==2}">
	                    		<a target="main" href="${path}/dcVideo/preEditDcVideo.do?videoId=${video.videoId}&reviewType=${dcVideo.reviewType}" class="videoReButton">重评</a>
	                    	</c:if>
	                    	<c:if test="${video.videoStatus==3}">无</c:if>
                    	</c:if>
                    	<c:if test="${dcVideo.reviewType==2}">
                    		<c:if test="${empty video.videoReviewResult}">
                    			<a target="main" href="${path}/dcVideo/preEditDcVideo.do?videoId=${video.videoId}&reviewType=${dcVideo.reviewType}&videoType=${dcVideo.videoType}" class="videoButton">评审</a>
                    		</c:if>
                    		<c:if test="${not empty video.videoReviewResult}">无</c:if>
                    	</c:if>
                    	<c:if test="${dcVideo.reviewType==3}">
                    		<c:if test="${video.videoStatus==4&& empty video.videoSreviewReason}">
                    			<a target="main" href="${path}/dcVideo/preEditDcVideo.do?videoId=${video.videoId}&reviewType=${dcVideo.reviewType}" class="videoButton">评审</a>
                    		</c:if>
                    		<c:if test="${video.videoStatus==5||(video.videoStatus==4&& not empty video.videoSreviewReason)}">无</c:if>
                    	</c:if>
                    	<c:if test="${dcVideo.reviewType==4}">
                    		<c:if test="${empty video.videoReviewResult}">
                    			<a target="main" href="${path}/dcVideo/preEditDcVideo.do?videoId=${video.videoId}&reviewType=${dcVideo.reviewType}&videoType=${dcVideo.videoType}" class="videoButton">评审</a>
                    		</c:if>
                    		<c:if test="${not empty video.videoReviewResult}">
								<a target="main" href="${path}/dcVideo/preEditDcVideo.do?videoId=${video.videoId}&reviewType=${dcVideo.reviewType}&videoType=${dcVideo.videoType}" class="videoReButton">重评</a>
							</c:if>
                    	</c:if>
                    	<c:if test="${dcVideo.reviewType==5}">
                    		<a target="main" href="${path}/dcVideo/preEditDcVideo.do?videoId=${video.videoId}&reviewType=${dcVideo.reviewType}" class="videoButton">查询</a>
                    	</c:if>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty list}">
                <tr>
                    <td colspan="11"><h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <c:if test="${not empty list}">
            <input type="hidden" id="page" name="page" value="${page.page}"/>
            <div id="kkpager"></div>
        </c:if>
    </div>
</form>
</body>
</html>
