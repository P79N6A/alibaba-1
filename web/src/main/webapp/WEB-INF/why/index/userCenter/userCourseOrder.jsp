<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>个人中心-我的报名--文化云</title>

    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>

    <script type="text/javascript">
    
    $(function(){
            // 得到活动收藏
            getCourseList('${page.countPage}','${page.page}');
            
            $('#userCourseOrderId').addClass('cur').siblings().removeClass('cur');

        });


        function getPagination(){
            //分页
            kkpager.generPageHtml({

                pno :$("#pages").val() ,
                //总页码
                total :$("#countPage").val(),
                //总数据条数
                totalRecords :$("#total").val(),
                mode : 'click',
                click : function(n){
                    this.selectPage(n);
                    $("#reqPage").val(n);
                    getCourseList('${page.countPage}', $("#reqPage").val());
                    return false;
                }
            });
        }
        
        function getTotalTimes(){
        	$(".activity-manage").find("input[name='classTime']").each(function(){
				alert($(this).val());     		
        	})
        }

        // 得到活动
        function getCourseList(countPage,page){
            $("#userCourseOrderList").load("${path}/train/userCourseList.do",{
                countPage:countPage,page:page
            },function(){
                getPagination();
                setScreen();
                //getTotalTimes();
                $(".user-part ul li").on("click", ".cancel_order", function () {
                    var that = $(this);
                    var orderId = $(this).parent().parent().attr("data-orderNum");
                    dialogConfirm("取消报名", "您确定要取消该课程的报名吗？", removeParent);
                    function removeParent() {
                        $.post("${path}/train/cancelUserCourseOrder.do",{'orderId':orderId},function(data){
                        	if(data=='success'){
                       			that.parent().fadeOut(function(){
                           			that.parent().parent().remove(); 
                       			});
                        	}else if(data=='error'){
                        		dialogAlert("提示","操作失败");
                        	}else{
                        		dialogAlert("提示",data);
                        	} 
                        	
                        })
                        
                    }
                });
            });
        }

    </script>
<!-- dialog end -->
  <style>
    .millionTitle{ display:inline-block; color:#ffffff; background:#40b4ff; padding:0 10px; height:38px; line-height:38px; border-radius:5px; -moz-border-radius:5px;-webkit-border-radius:5px; font-size:16px;}
    .millionTitle:hover{ background:#40b4ff;color:#ffffff;}
  </style>
</head>
<body>

<%--引入个人中心头文件--%>
<%@include file="/WEB-INF/why/index/index_top.jsp"%>

<div id="register-content">
<div class="crumb">您所在的位置： <a href="#">个人主页</a> &gt; 我的报名<a href="#"></a></div>
<div class="activity-content user-content clearfix">
    <%@include file="user_center_left.jsp"%>

    <div class="user-right fr">
        <%-- <div class="user-tab" id="webDiv">
            <a href="${path}/userActivity/userActivity.do" class="cur">当前活动</a>
            <a href="${path}/userActivity/userActivityHistory.do">历史活动</a>
        </div>
        <div class="user-tab" id="appDiv">
            <a href="${path}/userActivity/userActivity.do?fromTicket=Y" class="cur">当前活动</a>
            <a href="${path}/userActivity/userActivityHistory.do?fromTicket=Y">历史活动</a>
        </div> --%>
        <a href="http://wrpx.wenhuayun.cn//wrpxFrontUser/login.do" target="_blank" class="millionTitle">万人培训报名</a>
        <div class="user-part user-part-b" id="userCourseOrderList">
        </div>
    </div>
</div>
</div>
<%@include file="../index_foot.jsp"%>

</body>
</html>