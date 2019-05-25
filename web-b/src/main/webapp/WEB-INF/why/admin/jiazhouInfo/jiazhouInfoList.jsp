<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>文化志愿者管理--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    
 <script type="text/javascript">                  
    $(function () {
        new Clipboard('.copyButton');
        $("input").focus();
        kkpager.generPageHtml({
            pno: '${page.page}',
            total: '${page.countPage}',
            totalRecords: '${page.total}',
            mode: 'click',//默认值是link，可选link或者click
            click: function (n) {
                this.selectPage(n);
                $("#page").val(n);
                formSub('#form');
                return false;
            }
        });
        
      //跳转至添资讯页面
        $(".btn-add-tag").on('click', function () {
             window.location.href = "${path}/jiazhouInfo/add.do";
          });
        
    });                                             
       //搜索
        function formSub(formName){        	
    	      var jiazhouInfoTitle = $('#jiazhouInfoTitle').val();
           if (jiazhouInfoTitle != undefined && jiazhouInfoTitle == '输入标题名称') {
               $('#jiazhouInfoTitle').val("");
           }           
             $(formName).submit();
         }
        
        //复制URL
        function copyUrl(id) {
            dialogAlert("提示", "复制完成：" + id);
        }   
        
        //删除
        function delJiazhouInfo(id) {
        	  var html = "您确定要删除吗？";
              dialogConfirm("提示", html, function () {
                  $.post("${path}/jiazhouInfo/delJiazhouInfo.do", {"jiazhouInfoId": id}, function (data) {
                      if (data != null && data == 'success') {
                          dialogConfirm("提示","删除成功！",function(){
                        	  window.location.href = "${path}/jiazhouInfo/jiazhouInfoList.do";
                          });
                      }else if (data == "noLogin") {                      	
                    	  dialogConfirm("提示", "请先登录！", function(){
                    		  window.location.href = "${path}/login.do";
    	                    	 });
                       } else {
                          dialogConfirm("提示", "删除失败！")
                      }
                  });
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
	<form id="form" action="" method="post">
	    <div class="site">
		    <em>您现在所在的位置：</em>资讯列表 
		</div>
		<div class="search">
		    <div class="search-box">
		        <i></i><input type="text" id="jiazhouInfoTitle" name="jiazhouInfoTitle" value="${jiazhouInfo.jiazhouInfoTitle}" data-val="输入标题名称" class="input-text"/>
		    </div>
		
		    <div class="select-btn">
		        <input type="button" onclick="$('#page').val(1);formSub('#form');" value="搜索"/>
		    </div>
		    
		    <div class="search-total">
	            <div class="select-btn">
	                <input class="btn-add-tag" type="button" value="新增资讯" style="background:#ED3838; "/>
	            </div>
            </div>
		</div>
	<div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th class="title">标题</th>
                <th>分类</th>
                <th>标签</th>
                <th>作者</th>
                <th>发布者</th>
                <th>最新操作时间</th>
                <th>管理</th>
            </tr>
            </thead>

            <tbody>
            <%int i = 0;%>
            <c:forEach items="${jiazhouInfoLists}" var="info">
                <%i++;%>             
                <tr>
                    <td><%=i%></td>
                    <td class="title">${info.jiazhouInfoTitle}</td>
                    <td>${info.tagName}</td>
                    <td>${info.jiazhouInfoTags}</td>
                    <td>${info.authorName}</td>
                    <td>${info.publisherName}</td>
                    <td><c:if test="${not empty info.jiazhouInfoUpdateTime}">
                        <fmt:formatDate value="${info.jiazhouInfoUpdateTime}" pattern="yyyy-MM-dd HH:mm"/>
                    </c:if></td>
                    <td><a target="main"
                           href="${path}/jiazhouInfo/preAddjiazhouInfo.do?jiazhouInfoId=${info.jiazhouInfoId}">编辑</a> |
                        <a class="copyButton" id="copy${info.jiazhouInfoId}" data-clipboard-text=''
                           href="javascript:copyUrl(getFrontUrl()+'wechatStatic/jiazhouInfoDetail.do?jiazhouInfoId=${info.jiazhouInfoId}');">复制URL</a> |
                        <a target="main"
                           href="javascript:delJiazhouInfo('${info.jiazhouInfoId}')">删除</a>   
                        <script>
                        	$("#copy${info.jiazhouInfoId}").attr("data-clipboard-text",getFrontUrl()+'wechatStatic/jiazhouInfoDetail.do?jiazhouInfoId=${info.jiazhouInfoId}');
                        </script>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty jiazhouInfoLists}">
                <tr>
                    <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <c:if test="${not empty jiazhouInfoLists}">
            <input type="hidden" id="page" name="page" value="${page.page}"/>
            <div id="kkpager"></div>
        </c:if>
    </div>
</form>
</body>
</html>