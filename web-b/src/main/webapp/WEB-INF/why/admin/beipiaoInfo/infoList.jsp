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
<link rel="Stylesheet" type="text/css" href="${path}/STATIC/css/DialogBySHF.css" />
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
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
		
	    infoTitle = $("#infoTitle").val();
	    if(infoTitle=="输入标题名称"){
	    	infoTitle="";
	    }
		infoTag = $("#infoTag").val();
		infoStatus = $("#infoStatus").val();
		infoType = $("#infoType").val();
		
		//加载父标签下拉框
		var infoTag = $("#infoTag").val();
		$.post("${path}/beipiaoInfoTag/queryParentTag.do",
			function(data) {
				if (data != '' && data != null) {
					var list = eval(data);
					var ulHtml = '';
					for (var i = 0; i < list.length; i++) {
						var tag = list[i];
						if(tag.tagName == '艺术鉴赏') {
						    continue ;
						}
						ulHtml += '<li data-option="'+tag.tagId+'">'
						+ tag.tagName + '</li>';
						if (infoTag != '' && tag.tagId == infoTag) {
                            $('#infoTagDiv').html(tag.tagName);
                        }
					}
					$('#tagTypeUl').append(ulHtml);
				}
			})
		
	});                                   
 	
 	//预览
 	function preview(id){
 		window.open(getFrontUrl()+"/wechatChuanzhou/chuanzhouDetail.do?infoId="+id);
 	}
       
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
		   	var msg = "上架成功！"; 
		   	var html = "您确定要发布该资讯吗？";
		   	var error = "上架失败！";
		}
		  	if(status=="1"){
		   	var msg = "下架成功！";
		   	var html = "您确定要下架该资讯吗？";
		   	var error = "下架失败";
		}
	  	dialogConfirm("提示",html,function(){
	   		$.post("${path}/beipiaoInfo/changeInfoStatus.do",{"infoId" : id, "infoStatus" : status},function(data){
			   	if (data != null && data == 'success') {
		            dialogAlert("提示",msg,function(){
		            	formSub('#form');
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
		    $.post("${path}/beipiaoInfo/delInfo.do", {"infoId": id}, function (data) {
		        if (data != null && data == 'success') {
		            dialogAlert("提示","删除成功！",function(){
		            	formSub('#form');
		        	});
		        }else if (data == "noLogin") {                      	
					dialogConfirm("提示", "请先登录！", function(){
						window.location.href = "${path}/login.do";
					});
		         }else {
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
	               		formSub('#form');
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



    function relateMember(id) {
        var winW = parseInt($(window).width() * 0.8);
        var winH = parseInt($(window).height() * 0.95);
        $.DialogBySHF.Dialog({
            Width: winW,
            Height: winH,
            Title:'关联场馆',
            URL: '${index}/member/relationMemberList.do?id='+id
        });
    };



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
	<form id="form" action="infoList.do" method="post">
		<input type="hidden" id="module" name="module" value="${bpInfo.module}" />
	    <div class="site">
		    <em>您现在所在的位置：</em>资讯列表 
		</div>
		<div class="search">
		    <div class="search-box">
		        <i></i><input type="text" id="infoTitle" name="infoTitle" value="${infoTitle}" data-val="输入标题名称" class="input-text"/>
		    </div>
			<c:if test="${empty bpInfo.module}">
			<div class="select-box w135">
				<input type="hidden" id="infoTag" name="infoTag"
					value="${infoTag}" />
				<div id="infoTagDiv" class="select-text" data-value="">
					全部模块
				</div>
				<ul class="select-option" id="tagTypeUl">
					<li data-option="">全部模块</li>
				</ul>
			</div>
			</c:if>
			<div class="select-box w135">
				<input type="hidden" id="infoStatus" name="infoStatus"
					value="${infoStatus}" />
				<div id="bookStatusDiv" class="select-text" data-value="">
					<c:choose>
						<c:when test="${infoStatus==0 }">
							已下架
	            		</c:when>
						<c:when test="${infoStatus==1 }">
	               			已发布
	            		</c:when>
						<c:otherwise>全部状态</c:otherwise>
					</c:choose>
				</div>
				<ul class="select-option">
					<li data-option="">全部状态</li>
					<li data-option="0">已下架</li>
					<li data-option="1">已发布</li>
				</ul>
			</div>
			<div class="select-box w135">
				<input type="hidden" id="infoType" name="infoType"
					value="${infoType}" />
				<div id="bookStatusDiv" class="select-text" data-value="">
					<c:choose>
						<c:when test="${infoType==1 }">
							图片
	            		</c:when>
						<c:when test="${infoType==2 }">
	               			视频
	            		</c:when>
						<c:otherwise>全部状态</c:otherwise>
					</c:choose>
				</div>
				<ul class="select-option">
					<li data-option="">全部形式</li>
					<li data-option="0">图片</li>
					<li data-option="1">视频</li>
				</ul>
			</div>
		    <div class="select-btn">
		        <input type="button" onclick="$('#page').val(1);formSub('#form');" value="搜索"/>
		    </div>
		</div>
	<div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th class="title">标题</th>
                <th>所属模块</th>
                <th>展示形式</th>
                <th>操作人</th>
                <th>创建时间</th>
                <th>最新操作时间</th>
                <th>展示状态</th>
                <th>推荐序号</th>
                <th>管理</th>
            </tr>
            </thead>

            <tbody>
            <%int i = 0;%>
            <c:forEach items="${list}" var="info">
                <%i++;%>             
                <tr>
                    <td><%=i%></td>
                    <td class="title">${info.beipiaoinfoTitle}</td>
                    <td>${info.currentTagName}</td>
                    <td>
                    	<c:if test="${info.beipiaoinfoShowtype==0 }">图片</c:if>
                    	<c:if test="${info.beipiaoinfoShowtype==1 }">视频</c:if>
                    </td>
                    <td>${info.userInfo}</td>
                    <td>
                        <fmt:formatDate value="${info.beipiaoinfoCreateTime}" pattern="yyyy-MM-dd HH:mm"/>
                    </td>
                    <td>
                        <fmt:formatDate value="${info.beipiaoinfoUpdateTime}" pattern="yyyy-MM-dd HH:mm"/>
                    </td>
                    <td><c:if test="${info.beipiaoinfoStatus=='0' }">
                    		已下架
                    	</c:if>
                    	<c:if test="${info.beipiaoinfoStatus=='1' }">
                    		已发布
                    	</c:if>
                    </td>
                    <td>
                    	<c:if test="${info.beipiaoinfoNumber != '0' }">
                    		${info.beipiaoinfoNumber }
                    	</c:if>
                    	<c:if test="${info.beipiaoinfoNumber == '0' }">
                    		未推荐
                    	</c:if>
                    </td>
                    <td><a target="main" onclick="preview('${info.beipiaoinfoId}')" target="_blank" >预览</a> |
                        <%if (infoPutawayButton) {%>
                    	<c:if test="${info.beipiaoinfoStatus=='0' }">
                        	<a target="main" href="javascript:changeInfoStatus('${info.beipiaoinfoId}','${info.beipiaoinfoStatus}')">上架</a> |
                        </c:if>
                        <%}%>
                        <%if (infoSoldoutButton) {%>
                        <c:if test="${info.beipiaoinfoStatus=='1' }">
                        	<a target="main" href="javascript:changeInfoStatus('${info.beipiaoinfoId}','${info.beipiaoinfoStatus}')">下架</a> |
                        </c:if>
                        <%}%>
                        <c:if test="${info.beipiaoinfoNumber=='0' }">
                        	<a target="main" class="_edit" data-tag="${info.beipiaoinfoTag}" data-id="${info.beipiaoinfoId}" href="javascript:;">推荐</a> |
                        </c:if>
                        <c:if test="${info.beipiaoinfoNumber!='0' }">
                        	<a target="main" href="javascript:confirmDelRecommend('${info.beipiaoinfoId}')">取消推荐</a> |
                        </c:if>
                        <a target="main" href="${path}/beipiaoInfo/preEditInfo.do?infoId=${info.beipiaoinfoId}">编辑</a> |
                        <a target="main" href="javascript:delInfo('${info.beipiaoinfoId}')">删除</a> | 
                        <a target="main" href="javascript:relateMember('${info.beipiaoinfoId}')">关联成员</a>
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