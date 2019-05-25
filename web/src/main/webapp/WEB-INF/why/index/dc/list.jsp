<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
   
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/dc/css/whyupload.css"/>
   
    <title>视频上传系统</title>
    
<script type="text/javascript">

	$(function() {
		
		var userId = '${sessionScope.dcUser.userId}';
		if (userId == null || userId == '') {
		    window.location.href = '../dcFront/login.do';
		    return;
		}
		
		kkpager.generPageHtml({
			pno : '${page.page}',
			total : '${page.countPage}',
			totalRecords : '${page.total}',
			mode : 'click',//默认值是link，可选link或者click
			click : function(n) {
				this.selectPage(n);
				$("#page").val(n);
				doSearchUser('#form');
				return false;
			}
		});
		
		$(".whyUploadBtn").click(function(){
			
			  window.location.href = '../dcFront/uploadDcVideo.do';
		})
		
		$(".editBtn").click(function(){
			
			var videoId=$(this).attr("videoId");
			
			if(videoId)
			window.location.href = '../dcFront/uploadDcVideo.do?videoId='+videoId;
		})
		
		$(".delBtn").click(function(){
			
			var videoId=$(this).attr("videoId");
			
			 var name = $(this).parents("li").find(".videoName").html();
	            var html = "您确定要删除“" + name + "”吗？";
	            dialogConfirm("提示", html, function(){
	                $.post("${path}/dcFront/deleteDcVideo.do",{videoId:videoId},function(data) {
	                    if (data == 'success') {
	                    	 dialogTypeSaveDraft("提示", "删除成功", function(){
	                    		 doSearchUser('#form');
	                         });
	                    }
	                    else if (result == "login") {
	                        dialogTypeSaveDraft("提示", "请先登录", function(){
	                       	 window.location.href = '../dcFront/login.do';
	                        });
	                    }else{
	                        dialogTypeSaveDraft("提示", "删除失败");
	                    }
	                });
	            })       
		})
		
		function doSearchUser(formName){
			
			$(formName).submit();
		}
		
		
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

	});

	function logout(){
		 $.post("${path}/dcFront/logout.do",function(){
			 
			 window.location.href = '../dcFront/login.do';
		 });
	}
	
</script>
</head>
<body style="background-color: #ffffff;" ms-important="Login">
<form id="form" action="${path}/dcFront/dcVideoList.do" method="post">
<input type="hidden" id="userId" name="userId" value="${sessionScope.dcUser.userId}"/>
<!-- 导入头部文件  无搜索按钮 -->
<div class="hp_navbg">
    <div class="hp_nav clearfix">
        <div class="logo fl"><img alt="文化云"  src="${path}/STATIC/image/baiduLogo.png" width="80" height="48"/>
        </div>
        <ul class="fl">
        </ul>
        <div class="fr">
			<ul class="fl">
	            <li data-url="frontIndex"><a href="#" onclick="logout();">退出</a></li>
	        </ul>
   		 </div>
</div>
<!--上传登录-->

<div class="whyuploadMain">
    <div class="whyUploadDiv">
        <p class="nowPlace">您所在的位置：视频上传列表</p>
        <div class="whyUserLogin" style="height: 970px;">
            <div class="whyUploadName">
                <div class="whyUploadNameDiv" style="float: left;margin-left: 70px;">
                    <p>报送人姓名</p>
                    <div>${sessionScope.dcUser.userName}</div>
                    <div style="clear: both;"></div>
                </div>
                <div class="whyUploadNameDiv" style="float: right;margin-right: 70px;">
                    <p>报送人所属区域</p>
                    <div>${fn:split(sessionScope.dcUser.userArea,',')[1]}</div>
                    <div style="clear: both;"></div>
                </div>
                <div style="clear: both;"></div>
            </div>
            <!-- <div class="whyUploadBtn">+&nbsp;上传视频</div> -->
            <div style="clear: both;"></div>
            <div class="whyUploadList">
                <ul>
                    <li style="background-color: #00afec;color: #fff;height: 40px;">
                        <div class="whyUploadListFl">ID</div>
                        <div class="whyUploadListFl">作品名称</div>
                        <div class="whyUploadListFl">作品时长</div>
                        <div class="whyUploadListFl">指导员</div>
                        <div class="whyUploadListFl">参演类别</div>
                        <div class="whyUploadListFl">参演团队</div>
                        <div class="whyUploadListFl">人数</div>
                        <div class="whyUploadListFl">提交时间</div>
                        <div class="whyUploadListFl">状态</div>
                        <div class="whyUploadListFl">操作</div>
                        <div style="clear: both;"></div>
                    </li>
                    <c:choose>
                    	<c:when test="${empty list}">
                    	  <li style="text-align: center;line-height: 60px;">暂无数据</li>
                    	</c:when>
                    	<c:otherwise>
                    	
                    	<c:forEach items="${list}" var="dataList" varStatus="status">
                    	  <li>
                        <div class="whyUploadListFl">${status.index+1 }</div>
                        <div class="whyUploadListFl videoName">${dataList.videoName }</div>
                        <div class="whyUploadListFl">${dataList.videoLength }</div>
                        <div class="whyUploadListFl">${dataList.videoGuide}</div>
                        <div class="whyUploadListFl">
                        	<c:choose>
	                        	<c:when test="${dataList.videoType=='沪剧'||dataList.videoType=='越剧'||dataList.videoType=='京剧'||dataList.videoType=='其他'}">
	                        		戏曲/曲艺(${dataList.videoType})
	                        	</c:when>
								<c:otherwise>
									${dataList.videoType}
								</c:otherwise>
							</c:choose>
                        </div>
                        <div class="whyUploadListFl">${dataList.videoTeamName}</div>
                        <div class="whyUploadListFl">${dataList.videoTeamCount}</div>
                        <div class="whyUploadListFl"><fmt:formatDate value="${dataList.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></div>
                        <div class="whyUploadListFl">
                        
                        <c:choose>
                        	<c:when test="${dataList.videoStatus==1 }">
								提交成功
                        	</c:when>
                        	<c:when test="${dataList.videoStatus==2 }">
								技术评审未通过，请重新上传视频
                        	</c:when>
                        	<c:when test="${dataList.videoStatus==3 }">
								技术评审通过，进入海选
                        	</c:when>
                        	<c:when test="${dataList.videoStatus==4 && empty dataList.videoSreviewReason}">
								海选进行中
                        	</c:when>
                        	<c:when test="${dataList.videoStatus==4 && not empty dataList.videoSreviewReason}">
								海选未通过
                        	</c:when>
                        	<c:when test="${dataList.videoStatus==5 }">
								海选通过
                        	</c:when>
                        </c:choose>
                        
                      	</div>
                        <div class="whyUploadListFl">
                        <%-- <c:if test="${dataList.videoStatus==1 || dataList.videoStatus==2 }">
                        <span videoId="${dataList.videoId}" class="editBtn">编辑</span>&nbsp;&nbsp;|&nbsp;&nbsp;
                        <span videoId="${dataList.videoId}" class="delBtn">删除</span></div>
                        </c:if> --%>
                        <div style="clear: both;"></div>
                    </li>
                   
                    	</c:forEach>
                    	
                    	</c:otherwise>
                    </c:choose>
                    
                </ul>
            </div>
            	<c:if test="${not empty list}">
             <input type="hidden" id="page" name="page" value="${page.page}" />
				<div id="kkpager"></div>
				</c:if>
        </div>
       
    </div>
</div>
</form>
</body>
<!-- 导入头部文件 -->

</html>
