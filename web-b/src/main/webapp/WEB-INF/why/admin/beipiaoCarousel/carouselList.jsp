<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>文化志愿者管理--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <link rel="Stylesheet" type="text/css" href="${path}/STATIC/css/DialogBySHF.css" />
    <script type="text/javascript" src="${path}/STATIC/js/DialogBySHF.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/location.js"></script>
 <script type="text/javascript">                  
 $(function () {
	 
        //调用下拉列表js
    	$(function() {
    		selectModel();
    	});
    	
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
    	    var infoTitle = $('#infoTitle').val();
           	if (infoTitle!= undefined && infoTitle == '输入标题名称') {
               $('#infoTitle').val("");
           }           
        	$(formName).submit();
         }
        
       //上下架
      function changeInfoStatus(id,status){
    	   
    	   if(status=="0"){
    		   var msg = "上线成功！"; 
    		   var html = "您确定要上线该轮播图吗？";
    		   var error = "上线失败！";
    	   }
    	   if(status=="1"){
    		   var msg = "下线成功！";
    		   var html = "您确定要下线该轮播图吗？";
    		   var error = "下线失败！";
    	   }
    	   dialogConfirm("提示",html,function(){
    		   $.post("${path}/beipiaoCarousel/changeCarouselStatusAndNumber.do",{"carouselId" : id, "carouselStatus" : status},function(data){
    			   if (data != null && data == 'success') {
                       dialogAlert("提示",msg,function(){
                     	  window.location.href = "${path}/beipiaoCarousel/carouselList.do?carouselType=${carousel.carouselType}";
                       });
    			   }else if (data =="nologin"){
    				   dialogConfirm("提示", "请先登录！", function(){
                 		  window.location.href = "${path}/login.do";
 	                   });
    			   }else {
    				   dialogConfirm("提示", error);
    			   }
    		   });
    	   });
       }
        
        //删除
        function delInfo(id) {
        	  var html = "您确定要删除吗？";
              dialogConfirm("提示", html, function () {
                  $.post("${path}/beipiaoCarousel/delCarousel.do", {"carouselId": id}, function (data) {
                      if (data != null && data == 'success') {
                          dialogAlert("提示","删除成功！",function(){
                        	  window.location.href = "${path}/beipiaoCarousel/carouselList.do?carouselType=${carousel.carouselType}";
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
        
        //推荐管理
        //初始化dialog
        seajs.config({
		    alias: {
		        "jquery": "jquery-1.10.2.js"
		    }
		});
		seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
	    	window.dialog = dialog;
		});
		window.console = window.console || {log:function () {}}  
		//添加click事件
        seajs.use(['jquery'], function ($) {
        	 $('._edit').on('click', function () {
                 var tag = $(this).attr("data-tag");
                 var id = $(this).attr("data-id");
                 dialog({
                     url: '${path}/beipiaoInfo/preRecommendInfo.do?infoTag='+tag+'&infoId='+id,
                     title: '运营位排序',
                     width: 460,
                     height:350,
                     fixed: true
                 }).showModal();
                 return false;
             });
        });
		
		//取消推荐
		function confirmDelRecommend(id){
			var html = "您确定要取消推荐吗？";
            dialogConfirm("提示", html, function () {
                $.post("${path}/beipiaoInfo/delRecommendInfo.do", {"infoId": id}, function (data) {
                    if (data != null && data == 'success') {
                        dialogAlert("提示","取消推荐成功！",function(){
                      	  window.location.href = "${path}/beipiaoInfo/infoList.do?carouselType=${carousel.carouselType}";
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
	<form id="form" action="carouselList.do" method="post">
	    <div class="site">
		    <em>您现在所在的位置：</em>动态资讯&gt; 动态资讯轮播图
		</div>
		<div class="search menage">
    
	    <div class="menage-box">
	        <a class="btn-add" href="${path}/beipiaoCarousel/addPage.do?carouselType=${carousel.carouselType}">添加首页轮播图</a>
	    </div>
     
</div>
	<div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th class="title">标题</th>
                <th>操作人</th>
                <th>上架时间</th>
                <th>更新时间</th>
                <th>排序</th>
                <th>管理</th>
            </tr>
            </thead>
            <tbody>
            <%int i = 0;%>
            <c:forEach items="${list}" var="carousel">
                <%i++;%>             
                <tr>
                    <td><%=i%></td>
                    <td class="title">
                    	${carousel.carouselTitle}
                    </td>
                    <td>${carousel.carouselUpdateUser}</td>
                    <td>
                        <fmt:formatDate value="${carousel.carouselCreateTime}" pattern="yyyy-MM-dd HH:mm"/>
                    </td>
                    <td>
                        <fmt:formatDate value="${carousel.carouselUpdateTime}" pattern="yyyy-MM-dd HH:mm"/>
                    </td>
                    <td>
                    	<c:if test="${carousel.carouselNumber==0 }">
                    		未上线
                    	</c:if>
                    	<c:if test="${carousel.carouselNumber!=0 }">
                    		${carousel.carouselNumber }
                    	</c:if>
                    </td>
                    <td>
                    	<c:if test="${carousel.carouselNumber=='0' }">
                        	<a target="main" href="javascript:changeInfoStatus('${carousel.carouselId}','${carousel.carouselStatus}')">上线</a> |
                        </c:if>
                        <c:if test="${carousel.carouselNumber!='0' }">
                        	<a target="main" href="javascript:changeInfoStatus('${carousel.carouselId}','${carousel.carouselStatus}')">下线</a> |
                        </c:if>
                        <a target="main" href="${path}/beipiaoCarousel/preEditCarousel.do?carouselId=${carousel.carouselId}">编辑</a> |
                        <a target="main" href="javascript:delInfo('${carousel.carouselId}')">删除</a> | 
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty list}">
                <tr>
                    <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
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