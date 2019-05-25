<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>场馆列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">
        $(function() {
         //导出excel表格
			selectModel();
        });

    </script>
    <style>
      .export{
          float: right;
	    display: inline-block;
	    width: 100px;
	    height: 42px;
	    line-height: 42px;
	    overflow: hidden;
	    color: #ffffff;
	    font-size: 18px;
	    border-radius: 5px;
	    -moz-border-radius: 5px;
	    -webkit-border-radius: 5px;
	    background: #1882FC;
	    text-align: center;

      }
      .export:hover{color: #ffffff; }
      .search .menage-box{ margin-top:0;}
      .search .menage-box .btn-add{ height:42px; line-height:42px; margin-right:10px;}
    </style>
</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>培训管理 &gt; 报名列表
</div>
<form id="courseViewForm" method="post" action="${path}/peopleTrain/courseView.do">
    <div class="search">
        <div class="search-box">
            <i></i><input id="searchKey" name="searchKey" class="input-text" placeholder="请输入报名人\单位名称" type="text"
                          value="<c:choose><c:when test="${not empty searchKey}">${searchKey}</c:when><c:otherwise></c:otherwise></c:choose>"/>
        </div>
        <div class="select-box w135">
	        <input type="hidden" value="${status}" name="status" id="statusUnit"/>
	        <div class="select-text" data-value="0">
            <c:choose>
                <c:when test="${status == 1}">
                    待确认
                </c:when>
                <c:when test="${status == 2}">
                        已确认
                </c:when>
                <c:otherwise>
                    全部
                </c:otherwise>
            </c:choose>
        	</div>
	        <ul class="select-option">
	            <li>全部</li>
	            <li id="1" data-option="1">待确认</li>
	            <li id="2" data-option="2">已确认</li>
	        </ul>
    	</div>
        <div class="select-btn">
            <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#courseViewForm')"/>
        </div>
         
       <a class="export" onclick="exportExcel();">导出</a>
       <div class="menage-box">
        <a class="btn-add" id="btn-add" href="#">添加报名人</a>
        </div>
        <div class="menage-box">
        <a class="btn-send btn-add" onclick="send()" id="btn-send" href="#">群发短信</a>
        </div>
    </div>
    <div class="main-content">
        <table width="100%" id="tableSend">
            <thead>
            <tr>
                <th width="68"><input id="selsect_all" data_on="false" type="checkbox"/><label for="selsect_all"><!-- <span id="sel_txt">全选</span> --></label></th>
                <th>ID</th>
                <th class="title">真实姓名</th>
                <th>性别</th>
                <th>手机号码</th>
                <!-- <th>身份证号</th> -->
                <th>单位名称</th>
                <th>课程</th>
                <th>报名时间</th>
                <th>报名状态</th>
                <th>参加培训确认</th>
                <th>学时</th>
               <th>操作</th>
            </tr>
            </thead>
            <c:if test="${empty list}">
                <tr>
                    <td colspan="12"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            <tbody>

            <c:forEach items="${list}" var="c" varStatus="s">
                <tr>
                    <td><input name="message" type="checkbox" value="${c.orderId}"/></td>
                    <td>${s.index+1}</td>
                    <td class="title">${c.realName}</td>
                    <td> <c:if test="${c.userSex ==1}">男</c:if> 
                    <c:if test="${c.userSex ==2}">女</c:if></td>
                    <td>${c.userMobileNo}</td>
                    <%-- <td>${c.idNumber }</td> --%>
                    <td>${c.unitName }</td>
                    <td>${c.courseTitle }</td>
                    <td>${fn:substring(c.createTime, 0, 19)}</td>
                      <td> <c:if test="${c.orderStatus==1}">待确认</c:if> 
                    <c:if test="${c.orderStatus==2}">已确认</c:if>
                    </td>
                    <td>
                    <c:if test="${c.attendState==1}">未参加</c:if>
                    <c:if test="${c.attendState==2}">已参加</c:if>
                
                    </td>
                    <td>${c.classTimes}</td>
                    <td>
                    <c:if test="${c.attendState==1 and c.orderStatus==1}"><a href="javascript:sendMessage('${c.orderId}','2','1');">报名确认</a>|</c:if>
                    <c:if test="${c.attendState==1 and c.orderStatus==2}"><a href="javascript:sendMessage('${c.orderId}','1','1');">取消报名</a>|</c:if>
                    <a href="${path}/peopleTrain/viewTrainUser.do?userId=${c.userId}">查看</a>
                   <c:if test="${(empty c.classTimes or c.classTimes==0) and c.attendState==1 and c.orderStatus==2}">|<a href="javascript:attendCourse('${c.orderId}',2);">课时验证</a></c:if> 
                   <%--<c:if test="${not empty c.attendState and c.attendState!=1 }">|<a href="javascript:attendCourse('${c.orderId}',1);">取消验证</a></c:if>
                    
                        <%-- <c:if test="${c.classTimes==null}">|<a href="javascript:addScore('${c.orderId}','${c.courseId}');">课时验证</a></c:if> --%>
                    </td> 
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <input type="hidden" id="courseId" name="courseId" value="${courseId}" />
        <c:if test="${not empty list}">
            <input type="hidden" id="page" name="page" value="${page.page}" />
            <div id="kkpager"></div>
        </c:if>
        <script type="text/javascript">
            $(function(){
                kkpager.generPageHtml({
                    pno : '${page.page}',
                    total : '${page.countPage}',
                    totalRecords :  '${page.total}',
                    isShowTotalRecords : true,
                    mode : 'click',//默认值是link，可选link或者click
                    click : function(n){
                        this.selectPage(n);
                        $("#page").val(n);
                        formSub('#courseViewForm');
                        return false;
                    }
                });
            });

            //提交表单
            function formSub(formName){
                $(formName).submit();
            }
            function attendCourse(orderId,state){
                $.ajax({
                    url:'${path}/peopleTrain/attendCourse.do',
                    type:"POST",
                    data:{orderId:orderId,state:state},
                    dataType:"json",
                    success:function(re){
                        formSub('#courseViewForm');
                    }
                });
            }
            /* function attendCourse(orderId){
                $.ajax({
                    url:'${path}/peopleTrain/attendCourse.do',
                    type:"POST",
                    data:{orderId:orderId,state:state},
                    dataType:"json",
                    success:function(re){
                        formSub('#courseViewForm');
                    }
                });
            } */
        </script>
        <script type="text/javascript">
		    //删除

		    //
		    seajs.config({
		        alias: {
		            "jquery": "jquery-1.10.2.js"
		        }
		    });
		    seajs.use(['/why/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
		        window.dialog = dialog;
		    });
		
		    window.console = window.console || {
		        log:function () {
		
		        }
		    }
		    var courseId="${courseId}";
		    seajs.use(['jquery'], function ($) {
		        $("#btn-add").on('click', function () {
		            dialog({
		                url: '${path}/peopleTrain/addCourseUser.do?courseId='+courseId,
		                title: '添加报名人',
		                width: 560,
		                //height:400,
		                fixed: true
		            }).showModal();
		            return false;
		        });
		        $("#btn-send").on('click', function () {
		        	  var courseId=$("#courseId").val();
		              var inputs=$("#tableSend").find("input[name='message']");
		              var account=0;
		              var arr =[];
		              inputs.each(function(){
		                 if($(this).prop("checked")){
		                   account=account+1;
		                   arr.push($(this).val());
		                 }
		              })
		               if(account<=0){
		                 dialogAlert("提示","至少选择一项！");
		                 return;
		              }
		              var ids = arr.join(",");
		            dialog({
		                url: '${path}/peopleTrain/messageView.do?courseId='+courseId+'&orderId='+ids+'&type='+2+'&state='+2,
		                title: '短信预览',
		                width: 560,
		                //height:400,
		                fixed: true
		            }).showModal();
		            return false;
		        });
		
		    });

		    
		    function sendMessage(orderId,state,type){
		    	var courseId=$("#courseId").val();

	                var html = "您确定要发送短信吗？";
					dialogConfirm("提示", html, function(){
						$.ajax({
		                    url:'${path}/peopleTrain/sendMessage.do',
		                    type:"POST",
		                    data:{orderId:orderId,state:state,type:type},
		                    dataType:"json",
		                    success:function(re){
		                        var map = eval(re);
		                    	if(map.sucess='Y'){
		                    	//	location.href = "${path}/peopleTrain/courseView.do?courseId="+courseId;
		                    		formSub('#courseViewForm');
		                    	}else{
		                    		dialogAlert("提示","短信发送失败");
		                    	}
		                    }
		                });
					})
		    	
		    }
		
   	   //群发短信
  <%--     function send(){
    	  var courseId=$("#courseId").val();
         var inputs=$("#tableSend").find("input[name='message']");
         var account=0;
         var arr =[];
         inputs.each(function(){
            if($(this).prop("checked")){
              account=account+1;
              arr.push($(this).val());
            }
         })
          if(account<=0){
            dialogAlert("提示","至少选择一项！");
            return;
         }
         var ids = arr.join(",");
         $.ajax({
                    url:'${path}/peopleTrain/sendMessage.do',
                    type:"POST",
                    data:{orderId:ids,type:'2',state:'2'},
                    dataType:"json",
                    success:function(re){
                    	var map = eval(re);
                    	if(map.sucess='Y'){
                    		dialogAlert("提示","短信群发成功",function(){
                    			//location.href = "${path}/peopleTrain/courseView.do?courseId="+courseId;
                    			formSub('#courseViewForm');
                    		});
                    		//formSub('#courseViewForm')
                    	}else{
                    		dialogAlert("提示","短信群发失败");
                    	}
                    }
                });
      }
   	   --%>
    //全选
    var inputCount=$("#tableSend").find("input[name='message']");
    $("#selsect_all").click(function(){
          var btn=$(this).prop("checked");
          if(!btn){
             inputCount.prop("checked",false);
          }else{
            inputCount.prop("checked",true);
          }
          
    })
    inputCount.click(function(){
        var mount=Mount();
        if(mount<inputCount.length){
            $("#selsect_all").prop("checked",false);
        }
    })
    function Mount(){
      var count=0;
      inputCount.each(function(){
            if($(this).prop("checked")){
              count=count+1;
            }
          })
         return count;
         }
    function exportExcel() {
  	  var courseId = $("#courseId").val();
  	  var searchKey = $("#searchKey").val();
     location.href = "${path}/peopleTrain/exportByCourseIdExcel.do?courseId="+courseId+"&searchKey="+searchKey;
    }
  
</script>
    </div>
</form>

</body>
</html>