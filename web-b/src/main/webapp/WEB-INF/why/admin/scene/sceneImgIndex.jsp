<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>我在现场列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>

    <script type="text/javascript">

        $(function () {
        	
        	selectModel();
        	 //关闭图片预览
  		    $(".imgPreview,.imgPreview>img").click(function() {
  			 	$(".imgPreview").fadeOut("fast");
  			}) 	   
        	
            kkpager.generPageHtml({
                pno: '${page.page}',
                total: '${page.countPage}',
                totalRecords: '${page.total}',
                mode: 'click',//默认值是link，可选link或者click
                click: function (n) {
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#sceneImgForm');
                    return false;
                }
            });
        	 
          //当不是全选时取消全选按钮	 
  		  $('input[name="subcheck"]').click('click', function () {
          	if($(this).is(':checked')) {
          		var sum = 0;
          		$('input[name="subcheck"]').each(function () {
          			if($(this).is(':checked')) {
          				sum++;
          			}
          		});
          		if(sum == $('input[name="subcheck"]').size()) {
          			$('input[name="SelectAll"]').prop("checked",true);
          		}

          	} else {
          		$('input[name="SelectAll"]').prop("checked",false);
          	}
          });
        });
        
      	//提交表单
        function formSub(formName) {
        	var userName = $('#userName').val();
            if (userName != undefined && userName == '输入用户名') {
                $('#userName').val("");
            }
        	var userMobile = $('#userMobile').val();
            if (userMobile != undefined && userMobile == '输入手机号') {
                $('#userMobile').val("");
            }
      		
            $(formName).submit();
        }

        //删除
        function deleteSceneImg(sceneImgId) {
            dialogConfirm("提示", "确定删除该图片？", function(){
            	$.post("${path}/scene/deleteSceneImg.do", {sceneImgId: sceneImgId}, function (data) {
                    if (data == "200") {
                    	dialogConfirm("提示", "删除成功！", function(){
                    		location.reload();
                    	})
                    } else {
                        dialogAlert('提示', "删除失败！");
                    }
                });
            });
        }
        
        function showPreview(url){
        	$(".imgPreview img").attr("src",url);
        	$(".imgPreview").fadeIn("fast");
        }
        

        //全选全部选
        function selectAll(allEle) {
        	if($(allEle).is(':checked')) {
        		$('input[name="subcheck"]').prop("checked",true);
        	} else {
        		$('input[name="subcheck"]').prop("checked",false);
        	}
        }
        
        //审核通过
        function checkPass(){
        	dialogConfirm("提示", "确定要审核通过该图片？",function(){
	        	var subcheck=document.getElementsByName('subcheck');
	        	var sceneImgId=''; 
	        	for(var i=0; i<subcheck.length; i++){ 
	        		if(subcheck[i].checked){
	        			sceneImgId+=subcheck[i].value+","; //如果选中，将value添加到变量s中 
	        		}
	        	}
	        	$.post("${path}/scene/checkPass.do", {sceneImgId: sceneImgId}, function (data) {
	                if (data == "200") {
	                	dialogConfirm("提示", "审核通过！",function(){
	                		formSub('#sceneImgForm');
	                	});
	                	
	                } else {
	                    dialogAlert('提示', "审核通过失败！");
	                }
	            });
        	});
        }
        
        //审核不通过
        function checkNoPass(){
        	dialogConfirm("提示", "确定要审核不通过该图片？",function(){
	        	var subcheck=document.getElementsByName('subcheck');
	        	var sceneImgId=''; 
	        	for(var i=0; i<subcheck.length; i++){ 
	        		if(subcheck[i].checked)
	        		sceneImgId+=subcheck[i].value+","; //如果选中，将value添加到变量s中 
	        	}
	        	$.post("${path}/scene/checkNoPass.do", {sceneImgId: sceneImgId}, function (data) {
	                if (data == "200") {
	                	dialogConfirm("提示", "审核不通过！",function(){
	                		formSub('#sceneImgForm');
	                	});
	                } else {
	                    dialogAlert('提示', "审核不通过失败！");
	                }
	            });
        	});
        }
        
      
        
    </script>
</head>

<body>

<!--点击放大图片imgPreview-->
	
<div class="imgPreview" style="width:800px;height:600px;position:fixed;top:0;right:0;bottom:0;left:0;margin:auto;z-index:100;display: none;">
	<img src="" style="max-width:100%;max-height:100%;width:auto;height:auto;position:absolute;top:0;right:0;bottom:0;left:0;margin:auto;"/>
</div>
<form id="sceneImgForm" action="" method="post">
    <div class="site">
        <em>您现在所在的位置：</em>运维管理 &gt; 我在现场管理
    </div>
    <div class="search">
	    <div class="search-box">
	        <input type="text" id="userName" name="userName" value="${entity.userName}" data-val="输入用户名" class="input-text"/>
	    </div>
	    <div class="search-box">
	        <input type="text" id="userMobile" name="userMobile" value="${entity.userMobile}" data-val="输入手机号" class="input-text"/>
	    </div>
	    <div class="select-box w135">
            <input type="hidden" value="${entity.sceneStatus}" name="sceneStatus"
                   id="sceneStatus"/>
            <div class="select-text" data-value="">
                <c:choose>
                    <c:when test="${entity.sceneStatus == 0}">
                        未审核
                    </c:when>
                    <c:when test="${entity.sceneStatus == 1}">
                       审核通过
                    </c:when>
                    <c:when test="${entity.sceneStatus == 2}">
                        审核不通过
                    </c:when>
                    <c:otherwise>
                        审核状态
                    </c:otherwise>
                </c:choose>
            </div>
            <ul class="select-option">
                <li data-option="">审核状态</li>
                <li data-option="0">未审核</li>
                <li data-option="1">审核通过</li>
                <li data-option="2">审核不通过</li>
            </ul>
        </div>      
	    <div class="select-btn" style="margin:0px 15px;">
	        <input type="button" onclick="$('#page').val(1);formSub('#sceneImgForm');" value="搜索"/>
	    </div>
	    <div class="select-btn" style="margin:0px 15px;">
	        <input type="button" onclick="checkPass();" value="审核通过"/>
	    </div>
	    <div class="select-btn" style="margin:0px 15px;">
	        <input type="button" onclick="checkNoPass();" value="审核不通过"/>
	    </div>
	</div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th width="30"><input type="checkbox" name="SelectAll"  value="全选" onclick="selectAll(this);"/> </th>
                <th width="50">ID</th>
                <th width="170">用户名</th>
                <th width="170">姓名</th>
                <th width="170">手机</th>
                <th width="340">图片</th>
                <th class="title">描述</th>
                <th width="170">状态</th>
                <th width="170">创建时间</th>
                <th width="340">管理</th>
            </tr>
            </thead>
            <tbody>
            <%int i = 0;%>
            <c:forEach items="${list}" var="dom">
                <%i++;%>
                <tr>
                    <td><input name="subcheck" type="checkbox" value="${dom.sceneImgId }"/></td>
                    <td><%=i%></td>
                    <td>${dom.userName}</td>
                    <td>${dom.userRealName}</td>
                    <td>${dom.userMobile}</td>
                    <td><img onclick="showPreview('${dom.sceneImgUrl}');" src="${dom.sceneImgUrl}@400w" width="200" height="160"></img></td>
                    <td class="title">${dom.sceneImgContent}</td>
                    <c:if test="${dom.sceneStatus==0 }">
                    <td>未审核</td>
                    </c:if>
                    <c:if test="${dom.sceneStatus==1 }">
                    <td>审核通过</td>
                    </c:if>
                    <c:if test="${dom.sceneStatus==2 }">
                    <td>审核不通过</td>
                    </c:if>
                    <td><fmt:formatDate value="${dom.createTime}" pattern="yyyy-MM-dd"/></td>
                    <td>
                    	<a target="main" href="javascript:deleteSceneImg('${dom.sceneImgId}');" style="color: red;font-weight: bold;">删除</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty list}">
                <tr>
                    <td colspan="6"><h4 style="color:#DC590C">暂无数据!</h4></td>
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
