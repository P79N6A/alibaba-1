<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>

    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em>${infoModule.informationModuleName}管理 &gt; ${infoModule.informationModuleName}列表
</div>
<form id="informationForm" action="${path}/ccpInformation/informationIndex.do?informationModuleId=${information.informationModuleId}" method="post">
    <input type="hidden" id="informationModuleId" value="${information.informationModuleId}"/>
    <div class="search">
        <div class="search-box">
            <i></i><input class="input-text" name="informationTitle" data-val="输入关键词" value="<c:choose><c:when test="${not empty information.informationTitle}">${information.informationTitle}</c:when><c:otherwise>输入关键词</c:otherwise></c:choose>" type="text" id="informationTitle"/>
        </div>
        <div class="select-btn">
            <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#informationForm');"/>
        </div>
            <div class="search menage">
                <div class="menage-box">
                    <a class="btn-add">新增</a>
                </div>
            </div>

    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th class="title">标题</th>
                <th>${infoModule.informationModuleName}类型</th>
                <th>分类</th>
                <th>标签</th>
                <th>作者</th>
                <th>发布者</th>
                <th>最新操作时间</th>
                <th>最新操作人</th>
                <th>管理</th>
            </tr>
            </thead>
            <tbody>
            <c:if test="${fn:length(informationList) gt 0}">
                <tbody>
                <%int i=0;%>
                <c:forEach items="${informationList}" var="info">
                    <%i++;%>
                    <tr>
                       <td><%=i%></td>
                       <td class="title">${info.informationTitle}</td>
                       <td>${info.informationTypeName}</td>
                        <td>
                       	<c:choose>
                       		<c:when test="${info.informationSort==1}">
                       		图文版
                       		</c:when>
                       		<c:when test="${info.informationSort==2}">
                       		大图版
                       		</c:when>
                       		<c:when test="${info.informationSort==3}">
                       		视频版
                       		</c:when>
                            <c:when test="${info.informationSort==4}">
                                直播或回放
                            </c:when>
                            <c:when test="${info.informationSort==5}">
                                列表跳转
                            </c:when>
                       	</c:choose>
                       </td>
                       <td>${info.informationTags}</td>
                       <td>${info.publisherName}</td>
                       <td>${info.createUserName}</td>
                       <td>
                       	<c:choose>
                       		<c:when test="${!empty info.informationUpdateTime}">
                       		<fmt:formatDate value="${info.informationUpdateTime}"  pattern="yyyy-MM-dd HH:mm" type="both"/>
                       		</c:when>
                       		<c:otherwise>
                       			<fmt:formatDate value="${info.informationCreateTime}"  pattern="yyyy-MM-dd HH:mm" type="both"/>
                       		</c:otherwise>
                       	</c:choose>
                       </td>
                       <td>
                       	<c:choose>
                       		<c:when test="${not empty info.updateUserName}">
                       			${info.updateUserName}
                       		</c:when>
                       		<c:otherwise>
                       			${info.createUserName}
                       		</c:otherwise>
                       	</c:choose>
                       </td>
                       <td>
                       <a target="main" class="delete"
                         informationId="${info.informationId}"><font color="red">删除</font></a> |
                       		<a target="main"
                          class="information-edit"  informationId="${info.informationId}">编辑</a> |
                          
                          <c:choose>
                          	<c:when test="${info.informationIsRecommend==1 }">
                          	<a  onclick="isRecommend('${info.informationId}',0)" >取消推荐</a> |
                          	</c:when>
                          	<c:otherwise>
                          		<a  onclick="isRecommend('${info.informationId}',1)" >推荐</a> |
                          	</c:otherwise>
                          </c:choose>
                          
                          
                         <c:if test="${info.informationSort==2||info.informationSort==1||info.informationSort==4}">
                         	<a target="main"
                          class="information-manager"  informationId="${info.informationId}">管理详情</a> |
                         </c:if>
                          
                        <a class="copyButton" id="copy${info.informationId}" data-clipboard-text=''
                           href="javascript:copyUrl(getFrontUrl()+'/wechatInformation/informationDetail.do?informationId=${info.informationId}');">复制URL</a>
                           
                        <script>
                        	$("#copy${info.informationId}").attr("data-clipboard-text",getFrontUrl()+'wechatInformation/informationDetail.do?informationId=${info.informationId}');
                        </script>
                       
                       </td>
                    </tr>
                </c:forEach>
                </tbody>
            </c:if>
            <c:if test="${empty informationList}">
                <tr>
                    <td colspan="10"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <c:if test="${not empty informationList}">
            <input type="hidden" id="page" name="page" value="${page.page}" />
            <div id="kkpager"></div>
        </c:if>
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
    	$(".btn-edit").on("click", function(){
			var contentId = $(this).attr("data-id");
			//推荐
			var isRecommend = 1;
			//内容推荐
			var type = 1;
			var entityType = 2;
		    dialog({
             url: '${path}/personalize/recommendPersonalize.do?recommendId='+contentId+'&isRecommend='+isRecommend+'&type='+type+'&entityType='+entityType,
             title: '选择标签',
             width: 500,
             height:250,
             fixed: true
         }).showModal();
         return false;
		});
		/*点击取消按钮，关闭登录框*/
		$(".btn-cancel").on("click", function(){
			dialog.close().remove();
		});
    });

    $(function(){
        kkpager.generPageHtml({
            pno : '${page.page}',
            total : '${page.countPage}',
            totalRecords :  '${page.total}',
            mode : 'click',//默认值是link，可选link或者click
            click : function(n){
                this.selectPage(n);
                $("#page").val(n);
                formSub('#informationForm');
                return false;
            }
        });

        $(function () {
            new Clipboard('.copyButton');
            
         // 新增资讯
            $('.btn-add').on('click', function () {
                   var informationModuleId = $("#informationModuleId").val();
                   window.location.href = "${path}/ccpInformation/preAddInformation.do?informationModuleId="+informationModuleId;
            });

            //编辑资讯
            $('.information-edit').on('click', function () {
                var informationId = $(this).attr("informationId");
                var informationModuleId = $("#informationModuleId").val();
                window.location.href = "${path}/ccpInformation/preEditInformation.do?informationId="+informationId+'&informationModuleId='+informationModuleId;
            });
            
           	$(".information-manager").on('click', function () {
                var informationId = $(this).attr("informationId");
              
                window.location.href = "${path}/ccpInformationDetail/ccpInformationDetailIndex.do?informationId="+informationId;
            });
            
            $(".delete").on("click", function(){
                var informationId = $(this).attr("informationId");
                var informationModuleId = $("#informationModuleId").val();
                var name = $(this).parent().siblings(".title").text();
                var html = "您确定要删除" + name + "吗？";
                dialogConfirm("提示", html, function(){
                    $.post("${path}/ccpInformation/deleteinformation.do",{informationId:informationId},function(result) {
                        if (result == "success") {
                            dialogTypeSaveDraft("提示", "删除成功", function(){
                                window.location.href="${path}/ccpInformation/informationIndex.do?informationModuleId="+informationModuleId;
                            });
                        }else if (result == "login") {
                        	
                          	 dialogAlert('提示', '请先登录！', function () {
                          		window.location.href = "${path}/login.do";
        	                    	 });
                          }else{
                            dialogTypeSaveDraft("提示", "删除失败");
                        }
                    });
                })
            });
       
        });                  
    });
    
    function isRecommend(informationId,value){
        var informationModuleId = $("#informationModuleId").val();
    	$.post("${path}/ccpInformation/saveInformation.do", {informationId:informationId,informationIsRecommend:value}, function(result) {
            if (result == "success") {
                 dialogTypeSaveDraft("提示", "操作成功", function(){
                     window.location.href="${path}/ccpInformation/informationIndex.do?informationModuleId="+informationModuleId;
                 });
             }else if (result == "login") {
             	
               	 dialogAlert('提示', '请先登录！', function () {
               		window.location.href = "${path}/login.do";
	                    	 });
               }else{
                 dialogTypeSaveDraft("提示", "操作失败");
             }
         });
    }

    function dialogTypeSaveDraft(title, content, fn) {
        var d = window.dialog({
            width: 400,
            title: title,
            content: content,
            fixed: true,
            okValue: '确 定',
            ok: function () {
                if (fn)  fn();
            }
        });
        d.showModal();
    }
    
    function copyUrl(id) {
        dialogAlert("提示", "复制完成：" + id);
    }
    
    function formSub(formName){
        if($("#informationTitle").val() == "输入关键词"){
            $("#informationTitle").val("");
        }
        $(formName).submit();
    }
    
    
    function personalizeRecommend(activityId,isRecommend){
    	
    	var html = "您确定要取消推荐该${infoModule.informationModuleName}吗？";
    	
    	if(isRecommend==1){
    		html = "您确定要推荐该${infoModule.informationModuleName}吗？";
    	}
    	 dialogConfirm("提示", html, function () {
             $.post("${path}/personalize/contentRecommend.do", {entityId: activityId,isRecommend:isRecommend,entityType:2}, function (data) {
                 if (data != null && data == 'success') {
                	 
                	   dialogTypeSaveDraft("提示", "操作成功", function(){
                           window.location.reload();
                       });
                	 
                 }else if (data == 'used'){
                	 
                	  dialogAlert("提示", "内容已被使用，无法取消推荐！");
                	 
                 } else {
                     dialogConfirm("提示", "操作失败，系统异常", function () {
                    	 window.location.reload();
                     })
                 }
             });
         })
    }

       
</script>
</body>
</html>