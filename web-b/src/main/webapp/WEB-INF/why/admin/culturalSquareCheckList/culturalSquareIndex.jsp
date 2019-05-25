<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
      <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${pdath}/STATIC/js/dialog-min.js"></script>
    <!--文本编辑框 end-->
    <!-- dialog start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>

    <script type="text/javascript">
		var userId = '${sessionScope.user.userId}';
		
		seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
	            window.dialog = dialog;
	    });
		
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
                    formSub('#squareInformForm');
                    return false;
                }
            });
            
            selectModel();
            
            //关闭图片预览
  		    $(".imgPreview,.imgPreview>img").click(function() {
  			 	$(".imgPreview").fadeOut("fast");
  			}) 	   
       	 
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
        	var userName=$('#userName').val();
            if(userName != undefined && userName == '用户名'){
            	$('#userName').val("");
            }
            
            $(formName).submit();
        }
        
        //置顶
        function stick(squareId) {
            var html = "您确定要置顶吗？";
            dialogConfirm("提示", html, function () {
                $.post("${path}/culturalSquare/stick.do", {
                    "squareId": squareId
                }, function (data) {
                    if (data != null && data == 'success') {
                        dialogConfirm("提示","置顶成功！",function(){
                        	formSub('#squareInformForm');
                        })
                    }else if (result == "login") {
                       	
                     	 dialogAlert('提示', '请先登录！', function () {
                  			window.location.href = "${path}/login.do";
  	                    	 });
                     } else {
                        dialogConfirm("提示", "置顶失败！")
                    }
                });
            })
        }
        
        //取消置顶
        function unstick(squareId) {
            var html = "您确定要取消置顶吗？";
            dialogConfirm("提示", html, function () {
                $.post("${path}/culturalSquare/stick.do", {"squareId": squareId}, function (data) {
                    if (data != null && data == 'success') {
                    	dialogConfirm("提示","取消置顶成功！",function(){
                    		formSub('#squareInformForm');
                    	})
                    } else if (result == "login") {
                       	
                     	 dialogAlert('提示', '请先登录！', function () {
                  			window.location.href = "${path}/login.do";
  	                    	 });
                     }else {
                        dialogConfirm("提示", "取消置顶失败！", function () {})
                    }
                });
            })
        }
        
        //全选全不选
        function selectAll(allEle) {
        	if($(allEle).is(':checked')) {
        		$('input[name="subcheck"]').prop("checked",true);
        	} else {
        		$('input[name="subcheck"]').prop("checked",false);
        	}
        }
        
        
      //审核通过
        function checkPass(){
        	dialogConfirm("提示", "确定要审核通过吗？",function(){
	        	var subcheck=document.getElementsByName('subcheck');
	        	var squareId=''; 
	        	for(var i=0; i<subcheck.length; i++){ 
	        		if(subcheck[i].checked){
	        			squareId+=subcheck[i].value+","; //如果选中，将value添加到变量s中 
	        		}
	        	}
	        	$.post("${path}/culturalSquare/checkPass.do", {squareId: squareId}, function (data) {
	                if (data == "success") {
	                	dialogConfirm("提示", "审核通过成功！",function(){
	                		formSub('#squareInformForm');
	                	});
	                } else {
	                    dialogAlert('提示', "审核通过失败！");
	                }
	            });
        	});
        }
      
        //审核不通过
        function checkNoPass(){
        	dialogConfirm("提示", "确定要审核不通过吗？",function(){
	        	var subcheck=document.getElementsByName('subcheck');
	        	var squareId=''; 
	        	for(var i=0; i<subcheck.length; i++){ 
	        		if(subcheck[i].checked){
	        			squareId+=subcheck[i].value+","; //如果选中，将value添加到变量s中 
	        		}
	        	}
	        	$.post("${path}/culturalSquare/checkNoPass.do", {squareId: squareId}, function (data) {
	                if (data == "success") {
	                	dialogConfirm("提示", "审核不通过成功！",function(){
	                		formSub('#squareInformForm');
	                	});
	                } else {
	                    dialogAlert('提示', "审核不通过失败！");
	                }
	            });
        	});
        }
        
        //点击看大图
        function showPreview(url){
        	$(".imgPreview img").attr("src",url);
        	$(".imgPreview").fadeIn("fast");
        }
        
        function gradeChange(){
            var objS = document.getElementById("type");
            var grade = objS.selectedIndex;
            if(grade == 1){
            	$("#ext2Id").show();
            }else{
            	$("#ext2Id").hide();
            }
           }
       
    </script>
    <style type="">
    	.entryButton{
    	color: #fff;background-color:rgba(125, 164, 203, 1);border:1px solid rgba(56, 78, 101, 1);font-weight: bolder;border-radius:3px;padding:3px 15px;
    	}
    	.entryReButton{
    	color: #596988;border:1px solid #596988;font-weight: bolder;border-radius:3px;padding:3px 15px;
    	}
    	.housel {width: 98%;height: 40px;border: none;color: #142340;font-family: \5FAE\8F6F\96C5\9ED1;margin-left: 1%;margin-top: 1px;}
    </style>
</head>

<!--点击放大图片imgPreview-->
<div class="imgPreview" style="width:600px;height:400px;position:fixed;top:0;right:0;bottom:0;left:0;margin:auto;z-index:100;display: none;">
	<img src="" style="max-width:100%;max-height:100%;width:auto;height:auto;position:absolute;top:0;right:0;bottom:0;left:0;margin:auto;"/>
</div>

<body>
<form id="squareInformForm" action="${path}/culturalSquare/culturalSquareIndex.do" method="post">
     <input type="hidden" id="squareId" name="squareId"/>
     <input type="hidden" id="outId" name="outId"/>
    <div class="site">
		<em>您现在所在的位置：</em>运维管理 &gt;广场审核列表   
	</div>
	<div class="site-title">
	</div>
    <div class="search">
        <div class="search-box">
	        <i></i><input type="text" id="userName" name="userName" value="${squareInform.userName}" data-val="用户名" class="input-text"/>
	    </div>
	        <div class="select-box w135">
              <select class="housel" id="type" name="type" onchange="gradeChange()">
                <option  value = "1" >活动</option>
                <option  value = "2" >专题C端参与</option>
                <option  value = "3" >通知类</option>
                <option  value = "4" >知识问答</option>
                <option  value = "5" >投票</option>
                <option  value = "6" selected = "selected">直播</option>
             </select>
             <script>
	               $(function(){
	            	   var ty = ${squareInform.type};
	            	   var type = $("#type").val("${squareInform.type}");
	                   $("#type").trigger("change");
	               })
             </script> 
        </div>
        <div class="select-box w135" id="ext2Id" style="display:none;">
            <input type="hidden" value="${squareInform.ext2}" name="ext2"
                   id="ext2"/>
            <div class="select-text" data-value="">
                <c:choose>
                    <c:when test="${squareInform.ext2 == '1'}">
                        城市名片
                    </c:when>
                    <c:when test="${squareInform.ext2 == '2'}">
                       我在现场
                    </c:when>
                    <c:when test="${squareInform.ext2 == '3'}">
                       文化过新年
                    </c:when>
                    <c:when test="${squareInform.ext2 == '4'}">
                       行走故事
                    </c:when>
                    <c:otherwise>
                      城市名片
                    </c:otherwise>
                </c:choose>
            </div>
            <ul class="select-option">
                <li data-option="1">城市名片</li>
                <li data-option="2">我在现场</li>
                <li data-option="3">文化过新年</li>
                <li data-option="4">行走故事</li>
            </ul>
        </div>
        <div class="select-box w135">
            <input type="hidden" value="${squareInform.status}" name="status"
                   id="status"/>
            <div class="select-text" data-value="">
                <c:choose>
                    <c:when test="${squareInform.status == 0}">
                        未审核
                    </c:when>
                    <c:when test="${squareInform.status == 1}">
                       审核通过
                    </c:when>
                    <c:when test="${squareInform.status == 2}">
                        审核不通过
                    </c:when>
                    <c:otherwise>
                        审核状态
                    </c:otherwise>
                </c:choose>
            </div>
            <ul class="select-option">
                <li data-option="" >审核状态</li>
                <li data-option="0">未审核</li>
                <li data-option="1">审核通过</li>
                <li data-option="2">审核不通过</li>
            </ul>
        </div>
        <div class="select-box w135">
            <input type="hidden" value="${squareInform.whiteList}" name="whiteList"
                   id="whiteList"/>
            <div class="select-text" data-value="">
                <c:choose>
                    <c:when test="${squareInform.whiteList == 1}">
                       是
                    </c:when>
                    <c:otherwise>
                        白名单
                    </c:otherwise>
                </c:choose>
            </div>
            <ul class="select-option">
                <li data-option="" >白名单</li>
                <li data-option="1">是</li>
            </ul>
        </div>
        <div class="select-btn">
            <input type="button" onclick="$('#page').val(1);formSub('#squareInformForm');" value="搜索"/>
        </div>
        <div class="select-btn" style="margin:0px 30px;">
	        <input type="button" onclick="checkPass();" value="审核通过"/>
	    </div>
	    <div class="select-btn" style="margin:0px 5px;">
	        <input type="button" onclick="checkNoPass();" value="审核不通过"/>
	    </div>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th width="30"><input type="checkbox" name="SelectAll"  value="全选" onclick="selectAll(this);"/> </th>
                <th>编号</th>
                <th>用户名</th>
                <th>发布类型</th>
                <th>标题</th>
                <th>图片</th>
                <th>状态</th>
                <th>白名单</th>
              	<th>发布时间</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <%int i = 0;%>
            <c:forEach items="${list}" var="squareInform" varStatus="">
            <%i++ ;%>
                <tr>
                    <td><input name="subcheck" type="checkbox" value="${squareInform.squareId }"/></td>
                    <td><%=i%></td>
                    <td>${squareInform.userName }</td>
                  <%--   <td class="title">${squareInform.contextDec}</td> --%>
                  <td>
                    <c:choose>
                       <c:when test="${squareInform.type==1}">活动</c:when>
                       <c:when test="${squareInform.type==2}">
                           <c:choose>
							   <c:when test="${squareInform.ext2 == '1'}">
							                        城市名片
							   </c:when>
							   <c:when test="${squareInform.ext2 == '2'}">
							                       我在现场
							   </c:when>
							   <c:when test="${squareInform.ext2 == '3'}">
							                       文化过新年
							   </c:when>
                           </c:choose>
                       </c:when>
                       <c:when test="${squareInform.type==3}">通知类</c:when>
                       <c:when test="${squareInform.type==4}">知识问答</c:when>
                       <c:when test="${squareInform.type==5}">投票</c:when>
                       <c:otherwise>直播</c:otherwise>
                    </c:choose>
                   </td>
                    <td>${squareInform.ext1}</td>
                    <td>
                        <c:choose>
                          <c:when test="${squareInform.type == 1}">
		                    <c:forEach items="${fn:split(squareInform.ext0, ';')}" var="img">
		                       <img onclick="showPreview('${img}');" src="${img}" width="80" height="50"></img>
		                    </c:forEach>
		                  </c:when>
		                  <c:otherwise>
		                    <c:forEach items="${fn:split(squareInform.ext0, ';')}" var="img">
		                       <img onclick="showPreview('${img}');" src="${img}@600w" width="80" height="50"></img>
		                    </c:forEach>
		                  </c:otherwise>
	                    </c:choose>
                    </td>
                   <td>
                     <c:choose>
                       <c:when test="${squareInform.status==0}">未审核</c:when>
                       <c:when test="${squareInform.status==1}">审核通过</c:when>
                       <c:otherwise>审核不通过</c:otherwise>
                    </c:choose>
                   </td>
                   <td>
                     <c:choose>
                        <c:when test="${squareInform.whiteList == 0}">
                           否
                        </c:when>
                        <c:when test="${squareInform.whiteList == 1}">
                           是
                        </c:when>
                     </c:choose>
                   </td>
                   <td>${squareInform.publishTime}</td>
                   <td>
                   <c:if test="${squareInform.status==1 }">
	                   <c:if test="${squareInform.top == 0}">
	                     <a onclick="stick('${squareInform.squareId}')">置顶</a>
	                   </c:if>
	                   <c:if test="${squareInform.top == 1}">
	                     <a onclick="unstick('${squareInform.squareId}')">取消置顶</a>
	                   </c:if>
                   </c:if>
                   </td>
                </tr>
            </c:forEach>
            <c:if test="${empty list}">
                <tr>
                    <td colspan="14"><h4 style="color:#DC590C">暂无数据!</h4></td>
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
