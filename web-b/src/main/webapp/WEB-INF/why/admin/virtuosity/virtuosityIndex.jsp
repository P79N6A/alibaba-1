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

        //搜索
       function formSub(formName){
        	
   	      var antiqueName = $('#antiqueName').val();
          if (antiqueName != undefined && antiqueName == '按名称搜索') {
              $('#antiqueName').val("");
          }
           
            $(formName).submit();
        }
        
       //删除方法 
       function deleteVolunteer(ID){
    	   dialogConfirm("提示","您确定要删除吗？",function(){
    		   $.post("${path}/virtuosity/deleteVirtuosity.do",{"antiqueId":ID},function(data){
	   	       		if(data == "success"){
	   	       		   dialogConfirm("提示","删除成功！",function(){
	   	       			  formSub('#form'); 
	   	       		   })
	   	       		}else if(data == "login"){
	   	       		      window.location.href = "${path}/login.do";
	   	       		}else{
	   	       		    dialogConfrim("提示","删除失败！");
	   	       		}
	   	       	})		
    	   })
       } 
       
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
                    formSub('#form');
                    return false;
                }
            });
            
            //跳转至添加志愿者页面
            $('.btn-add-tag').on('click', function () {
                window.location.href = "${path}/virtuosity/add.do";

            });
            
            //加载分类
        	$.post("${path}/antiqueType/queryAntiqueType.do",function(data){
        		var antiqueTypeName = '${antiqueTypeName}';
        		$.each(data,function(i,dom){
        			if((antiqueTypeName !=null || antiqueTypeName !='') && antiqueTypeName == dom.antiqueTypeName ){
        				$("#antiqueTypeName").append("<option selected = 'selected'>"+dom.antiqueTypeName+"</option>")
        			}else{
        				$("#antiqueTypeName").append("<option>"+dom.antiqueTypeName+"</option>")
        			}
        			
        		})
        	})
        	//加载朝代
        	$.post("${path}/sysdict/queryChildSysDictByDictCode.do?dictCode=DYNASTY",function(data){
        		var sessionDictName = '${dictName}';
        		var list = eval(data);
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var dictId = obj.dictId;
                    var dictName = obj.dictName;
                    if((sessionDictName != null || sessionDictName != '') && sessionDictName == dictName){
        				$("#dictName").append("<option selected = 'selected'>"+dictName+"</option>")
        			}else{
        				$("#dictName").append("<option>"+dictName+"</option>")
        			}
                }
        	})
            
        });
        
    </script>
    <style type="text/css">
        .ui-dialog-title,.ui-dialog-content textarea{ font-family: Microsoft YaHei;}
        .ui-dialog-header{ border-color: #9b9b9b;}
        .ui-dialog-close{ display: none;}
        .ui-dialog-title{ color: #F23330; font-size: 20px; text-align: center;}
        .ui-dialog-content{}
        .ui-dialog-body{}
    	.housel {width: 98%;height: 40px;border: none;color: #142340;font-family: \5FAE\8F6F\96C5\9ED1;margin-left: 1%;margin-top: 1px;}
    </style>
</head>
<body>
	<form id="form" action="" method="post">
	    <div class="site">
		    <em>您现在所在的位置：</em>艺术鉴赏管理列表 
		</div>
		<div class="search">
		    <div class="search-box">
		        <i></i><input type="text" id="antiqueName" name="antiqueName" value="${antique.antiqueName }" data-val="按名称搜索" class="input-text"/>
		    </div>
		    <div class="select-box w135">
	              <select class="housel" id="antiqueTypeName" name="antiqueTypeName" >
	                 <option value=" ">----请选择分类----</option>
	              </select>
            </div>
            <div class="select-box w135">
	              <select class="housel" id="dictName" name="dictName" >
	                 <option value=" ">----请选择年代----</option>
	              </select>
            </div>
		    <div class="select-btn">
		        <input type="button" onclick="$('#page').val(1);formSub('#form');" value="搜索"/>
		    </div>
		    
		    <div class="search-total">
	            <div class="select-btn">
	                <input class="btn-add-tag" type="button" value="添加艺术鉴赏" style="background:#ED3838; "/>
	            </div>
            </div>
		</div>
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			            <th width="30">ID</th>
			            <th width="150">名称</th>
			            <th width="150">分类</th>
			            <th width="150">年代</th>
			            <th width="120">最近操作时间</th>
			            <th width="80">操作</th>
			        </tr>
		        </thead>
		        <tbody>
		        <%int i=0;%>
		        <c:forEach items="${list}" var="virtuosity">
		            <%i++;%>
		            <tr>
		                <td ><%=i%></td>
		                <td>${virtuosity.antiqueName}</td>
		                <td>${virtuosity.antiqueTypeName}</td>
		                <td>${virtuosity.dictName}</td>
		                <td><fmt:formatDate value="${virtuosity.antiqueUpdateTime}"  pattern="yyyy-MM-dd HH:mm" type="both"/></td>
		                <td>
		                   <a target="main" href="${path}/virtuosity/edit.do?antiqueId=${virtuosity.antiqueId}">编辑</a>
		                   <a target="main" href="javascript:;" onclick="deleteVolunteer('${virtuosity.antiqueId}')">删除</a>
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
	            <input type="hidden" id="page" name="page" value="${page.page}" />
		    	<div id="kkpager"></div>
	        </c:if>
		</div>
	</form>
</body>
</html>