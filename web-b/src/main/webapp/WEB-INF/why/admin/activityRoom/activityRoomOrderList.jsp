<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>订单列表--文化云</title>
  <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
  <%@include file="/WEB-INF/why/common/limit.jsp"%>

  <script type="text/javascript">
    $(function(){

      kkpager.generPageHtml({
        pno : '${page.page}',
        total : '${page.countPage}',
        totalRecords :  '${page.total}',
        mode : 'click',
        click : function(n){
          this.selectPage(n);
          $("#page").val(n);
          formSub('#roomOrderForm');
          return false;
        }
      });
    });

    //提交表单
    function formSub(formName){
      $(formName).submit();
    }

    $(function() {
        $(".btn-cancel").on("click",function(){

          var roomOrderId = $(this).attr("id");
      		var venueId=$("#venueId").val();
          var html = "您确定要取消该订单吗？";
          dialogConfirm("提示", html, function(){
            $.post("${path}/cmsRoomOrder/cancelRoomOrder.do",{"roomOrderId":roomOrderId}, function(data) {
              if (data!=null && data=='success') {
                window.location.href="${path}/cmsRoomOrder/queryAllRoomOrderList.do?roomId=${roomId}&venueId="+venueId;
              }else{
                dialogAlert("提示","取消活动室预订订单失败!");
              }
            });
          })
        });
    });

    function deleteRoomOrder(roomOrderId){
        var html = "您确定要删除该订单吗？";
        dialogConfirm("提示", html, function(){
            $.post("${path}/cmsRoomOrder/logicalDeleteRoomOrder.do",{"roomOrderId":roomOrderId}, function(data) {
                if (data!=null && data=='success') {
                    window.location.href="${path}/cmsRoomOrder/queryAllRoomOrderList.do?roomId=${roomId}";
                }else{
                    dialogAlert("提示","删除活动室预订订单失败!");
                }
            });
        })
    }
    
    /**
     *  发送消息
     */
    function sendMessger(id){
      dialogConfirm("发送短消息", "您确定发送短消息吗？", removeParent);
      function removeParent() {
        $.post("${path}/cmsRoomOrder/sendSmsMessage.do",{'roomOrderId':id},function(data){
          if(data == "success"){
            dialogAlert("提示","短信发送成功!");
          } else {
            dialogAlert("提示","短信发送失败!");
          }
        });
      }
    }
  </script>
</head>
<body>
<form id="roomOrderForm" action="${path}/cmsRoomOrder/queryAllRoomOrderList.do" method="post">
<input id="roomId" value="${roomId}" name="roomId" type="hidden"/>
<input name="venueId" id="venueId" type="hidden" value="${venueId}"/>
  <div class="site">
    <c:choose>
	<c:when test="${empty venueId }">
	 <em>您现在所在的位置：活动室管理 &gt;预订详情
	</c:when>
	<c:otherwise>
		 <em>您现在所在的位置：</em>场馆管理 &gt;</em>场馆信息管理 &gt;场馆列表 &gt;</em>活动室管理 &gt;预订详情
	</c:otherwise>
</c:choose>
  </div>
  <div class="search">
    <div class="search-box">
      <input type="text" id="orderNo" name="orderNo" value="${cmsRoomOrder.orderNo}" class="input-text"/>
    </div>

    <div class="select-btn">
      <input type="button" onclick="$('#page').val(1);formSub('#roomOrderForm');" value="搜索"/>
    </div>
  </div>
  <div class="main-content">
    <table width="100%">
      <thead>
      <tr>
          <th width="110">订单号</th>
          <th class="title">预订团体</th>
          <th>预订人</th>
          <th>预订人手机号码</th>
          <th>开始时间</th>
          <th width="80">使用场次</th>
          <th>取票码</th>
          <th>下单时间</th>
          <th>订单状态</th>
          <th>验证人</th>
          <th>管理</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach items="${cmsRoomOrderList}" var="c" varStatus="s">
        <tr>
          <td >${c.orderNo}</td>
          <td class="title">${c.tuserTeamName}</td>
          <td>${c.userName}</td>
          <td>${c.userTel}</td>
          <td>${c.roomOpenTime}</td>
          <td>${c.openPeriod}</td>
          <td>${c.validCode}</td>
          <td width="100"><fmt:formatDate value="${c.orderCreateTime}" pattern="yyyy-MM-dd HH:mm"/></td>
          <td>
              <c:choose>
                  <c:when test="${c.bookStatus == 1}">
                      <c:if test="${ now <= c.roomOpenTime}">
                          未使用
                      </c:if>
                      <c:if test="${ now > c.roomOpenTime}">
                          已失效
                      </c:if>
                  </c:when>
                  <c:when test="${c.bookStatus == 2}">
                      已取消
                  </c:when>
                  <c:when test="${c.bookStatus == 3}">
                      已使用
                  </c:when>
                  <c:when test="${c.bookStatus == 4}">
                      已删除
                  </c:when>
                  <c:when test="${c.bookStatus == 5}">
                      已使用
                  </c:when>
              </c:choose>
          </td>
          <td>${c.sysUserName}</td>
          <td>
              <c:choose>
                  <c:when test="${c.bookStatus == 1 &&  now <= c.roomOpenTime}">
                  	<%
				      if(activityRoomOrderCancleButton){
				     %>
	                      <a class="btn-cancel" id="${c.roomOrderId}" style="color: red;">取消订单</a></span>
				     <%
				        }
				     %>
				     <%
				      if(activityRoomOrderSendSmsButton){
				     %>
				     	  <a target="main" onclick="sendMessger('${c.roomOrderId}')">发消息</a>
				     <%
				        }
				     %>
                  </c:when>
                  <c:when test="${c.bookStatus == 4}">
                      <%--<a href="javascript:;" style="cursor: default;">无操作</a></span>--%>
                  </c:when>
                  <c:when test="${c.bookStatus == 2}">
                  	<%
				      if(activityRoomOrderDeleteButton){
				     %>
	                      <a href="javascript:;" onclick="deleteRoomOrder('${c.roomOrderId}')" style="color: red;">删除</a></span>
				     <%
				        }
				     %>
                  </c:when>
              </c:choose>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty cmsRoomOrderList}">
        <tr>
          <td colspan="11"> 暂无数据!</td>
        </tr>
      </c:if>
      </tbody>
    </table>
    <c:if test="${not empty cmsRoomOrderList}">
      <input type="hidden" id="page" name="page" value="${page.page}" />
      <div id="kkpager"></div>
    </c:if>
  </div>
</form>
</body>
</html>