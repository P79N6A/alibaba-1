<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化云</title>
    <%@include file="../../common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript">
        //提交表单
        function formSub(formName){
        	var searchKey = $("#searchKey").val();
            if(searchKey == "请输入文物名称"){		//"\\"代表一个反斜线字符\
                $("#searchKey").val("");
            }
            $(formName).submit();
        }
        
      //删除到回收站
        function deleteAntique(antiqueId,name){
            var html = "您确定要删除" + name + "吗？";
            dialogConfirm("提示", html, function(){
                $.post("${path}/bpAntique/deleteAntique.do",{"antiqueId":antiqueId}, function(data) {
                    if (data!=null && data=='success') {
                        dialogSaveDraft("提示", "<h2>已删除</h2>", function(){
                            window.location.href="${path}/bpAntique/antiqueIndex.do";
                        });
                    }else {
                        dialogSaveDraft("提示", "<h2>删除失败,请联系管理员<h2>", function(){
                        });
                    }
                });
            })
        }

        function moveAntique(antiqueId,name){
        	var antiqueIsDel;
        	var type = $("#remove_"+antiqueId).text();
        	var html = "您确定要"+type + name + "吗？";
        	if(type == "上架"){
        		antiqueIsDel = "1";
        	}else{
        		antiqueIsDel = "3";
        	}
        	dialogConfirm("提示", html, function(){
	            $.post("${path}/bpAntique/removeAntique.do?antiqueId="+antiqueId+"&antiqueIsDel="+antiqueIsDel,function (data) {
	                if (data != null && data == 'success') {
	                	dialogSaveDraft("提示", "<h2>"+type+"成功</h2>", function(){
                            
                        });
	                	 if(type == "上架"){
	                		 $("#remove_"+antiqueId).text("下架");
	                	}else{
	                		$("#remove_"+antiqueId).text("上架");
	                	} 
	                 }
	                else if (data=='failure'){
	                	
	                	 dialogAlert('提示', '操作失败，系统错误！');
	                }
	            });
        	})
     };
        function showInfo(info){
        	dialogSaveDraft("文物简介", info, function(){
                
            });
        };
        function toPreview(id){
        	var frontUrl = getFrontUrl();
        	window.open(frontUrl+"wechatBpAntique/preAntiqueDetail.do?antiqueId="+id);
        }
        //加载分类 加载年代  查询子数据  selectModel();只能执行一次
        $(function() {
            $.post(
            		"${path}/sysdict/queryChildSysDictByDictCode.do",
                    {
            			'dictCode' : 'ANTIQUE'
                    },
                    function(data) {
                        if (data != '' && data != null) {
                            var list = eval(data);
                            var ulHtml = '<li data-option="">全部种类</li>';
                            for (var i in data) {
                                var dict = list[i];
                                ulHtml += '<li data-option="'+dict.dictId+'">'
                                + dict.dictName + '</li>'; 
                                $('#tagTypeDiv').html(dict.dictName);
                            }
                            $('#tagType').html(ulHtml);
                        }else{
                            $("#antiqueTypeCount").val(0);
                        }
                    }).success(function() {
                        $.post(
                                "${path}/sysdict/queryChildSysDictByDictCode.do",
                                {
                                    'dictCode' : 'DYNASTY'
                                },
                                function(data) {
                                    if (data != '' && data != null) {
                                        var sty ='${record.antiqueDynasty}';
                                        //alert(sty);
                                        var list = eval(data);
                                        var ulHtml = '<li data-option="">全部年代</li>';
                                        for (var i in data) {
                                            var dict = list[i];
                                            ulHtml += '<li data-option="'+dict.dictId+'">'
                                            + dict.dictName + '</li>';
                                            if(sty!=""&&sty==dict.dictId){
                                                $('#tagDynastyDiv').html(dict.dictName);
                                            }
                                        }
                                        $('#tagDynasty').html(ulHtml);
                                    }
                                }).success(function() {
                                    selectModel();
                                });
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
                    formSub('#antiqueIndexForm');
                    return false;
                }
            });
        });

    </script>

</head>
<body>
	<input id="antiqueTypeCount" type="hidden" value="1"/>
	<%--条件检索--%>
	<form id="antiqueIndexForm" action="${path}/bpAntique/antiqueIndex.do" method="post">
	    <div class="site">
	        <em>您现在所在的位置：</em>文化文物&gt; 文化文物列表
	    </div>	
	    <div class="search">
	        <div class="search-box">
	            <i></i><input id="searchKey" name="searchKey" class="input-text" data-val="请输入文物名称" type="text"
	                          value="<c:choose><c:when test="${not empty searchKey}">${searchKey}</c:when><c:otherwise>请输入文物名称</c:otherwise></c:choose>"/>
	        </div>
	
	        <div class="select-box w135">
	            <input type="hidden" name="antiqueDynasty" value="${record.antiqueDynasty}" />
	            <div class="select-text" data-value=""  id="tagDynastyDiv" >全部年代</div>
	            <ul class="select-option" id="tagDynasty"  id="antiqueDynasty" >
	
	            </ul>
	        </div>
	
	        <div class="select-box w135">
	            <input type="hidden" name="antiqueType" value="${record.antiqueType}"/>
	            <div class="select-text" data-value="" id="tagTypeDiv" >全部种类</div>
	            <ul class="select-option" id="tagType">
	
	            </ul>
	        </div>
	
	        <div class="select-btn">
	            <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#antiqueIndexForm')"/>
	        </div>
	
	    </div>
		
		<div class="main-content pt10">
		    <table width="100%">
		        <thead>
		        <tr>
		            <th>ID</th>
		            <th class="title">文物名称</th>
		            <th class="info">简介</th>
		            <th>年代</th>
		            <th>种类</th>
		            <th>操作人</th>
		            <th>发布时间</th>
		            <th>最新操作时间</th>
		            <th>管理</th>
		        </tr>
		
		        </thead>
		        <c:if test="${empty list}">
		            <tr>
		                <td colspan="7"> <h4 style="color:#DC590C">暂无数据!</h4></td>
		            </tr>
		        </c:if>
		
		        <tbody>
		
		        <c:forEach items="${list}" var="c" varStatus="s">
		            <tr>
		                <td>${s.index+1}</td>
		                <td class="title">${c.antiqueName}</td>
		             	<td>
		             		<c:choose >
		             			<c:when test="${fn:length(c.antiqueInfo)>20 }"><a href="javascript:showInfo('${c.antiqueInfo}')">${fn:substring(c.antiqueInfo, 0, 20)}...</a> </c:when>
		             			<c:otherwise><a href="javascript:showInfo('${c.antiqueInfo}')">${c.antiqueInfo}</a></c:otherwise>  
		             		</c:choose> 		
		             	</td>
		                <td>${c.antiqueDynasty}</td>
		                <td>${c.antiqueType}</td>
		                <td>${c.antiqueUpdateUser}</td>
		                <td><fmt:formatDate value="${c.antiqueCreateTime}" pattern="yyyy-MM-dd HH:mm" /></td>
		                <td><fmt:formatDate value="${c.antiqueUpdateTime}" pattern="yyyy-MM-dd HH:mm" /></td>
		                <td>
		               		<a href="" onclick="toPreview('${c.antiqueId}')">预览</a>| 
		               		<c:choose>
		                        	<c:when test="${c.antiqueIsDel== 1 }">
		                        	<a id="remove_${c.antiqueId}" href="javascript:moveAntique('${c.antiqueId}','${c.antiqueName}')">下架</a>|
		                        	</c:when>
		                       	 <c:when test="${c.antiqueIsDel== 3 }">
		                        	<a id="remove_${c.antiqueId}" href="javascript:moveAntique('${c.antiqueId}','${c.antiqueName}')">上架</a>|
		                        	</c:when>
		                        </c:choose>
		                    <% 
		               			if(antiquePreEditButtonT1){
		               		%>
		               		<a href="${path}/bpAntique/preEditAntique.do?&antiqueId=${c.antiqueId}">编辑</a>|
		               		<% 
		               			}
		               		%>
		               		<% 
		               			if(antiqueDeleteButtonT1){
		               		%>
		               		<a class="delete" href="javascript:deleteAntique('${c.antiqueId}','${c.antiqueName}')">删除</a>	
		               		<% 
		               			}
		               		%>
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