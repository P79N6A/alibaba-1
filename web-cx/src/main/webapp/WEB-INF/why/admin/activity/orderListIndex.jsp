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
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
  <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
  <!--文本编辑框 end-->
  <!-- dialog start -->
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
  <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/ckeditor/sample.js"></script>

  <script type="text/javascript">
    $(function(){
      seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
      });
      selectModel();
      $("input").focus();
      kkpager.generPageHtml({
        pno : '${page.page}',
        total : '${page.countPage}',
        totalRecords :  '${page.total}',
        mode : 'click',
        click : function(n){
          this.selectPage(n);
          $("#page").val(n);
          formSub('#activityForm');
          return false;
        }
      });
    });

    window.console = window.console || {log:function () {}}
    function cancelUserOrder(activityOrderId) {
      /*var dialogWidth = ($(window).width() * 0.8);*/
      var dialogWidth = ($(window).width() < 800) ? ($(window).width() * 0.6) : 800;
      /* var dialogHeight = ($(window).height() < 600) ? ($(window).height() * 0.6) : 600;*/
      dialog({
        url: '${path}/order/preCancelUserOrder.do?activityOrderId=' + activityOrderId,
        title: '取消用户订单',
        width: dialogWidth,
        /*  height:dialogHeight,*/
        fixed: false,
        data: {
          /*  seatInfo: $("#seatInfo").val()*/
        }, // 给 iframe 的数据
        onclose: function () {
          if(this.returnValue){
            //console.log(this.returnValue);
            windows.reload();
          }
          //dialog.focus();
        }
      }).showModal();
      return false;
    }
    function page(){
      kkpager.generPageHtml({
        pno : '${page.page}',
        total : '${page.countPage}',
        totalRecords :  '${page.total}',
        mode : 'click',
        click : function(n){
          this.selectPage(n);
          $("#page").val(n);
          formSub('#activityForm');
          return false;
        }
      });
    }

    /**
     *  取消订单
     */
    function cancelOrder(id){

      dialogConfirm("取消订单", "您确定要取消该订单吗？", removeParent);
      function removeParent() {
        $.post("${path}/order/updateOrderByActivityOrderId.do", {activityOrderId:id},function (data) {
          if (data == 'success') {
            dialogAlert("提示","订单取消成功",function () {
              location.reload();
            });
          } else {
            dialogAlert("提示","订单取消失败:" + data);
          }
        });
      }
    }

    //提交表单
    function formSub(formName){

      var orderNumber=$('#orderNumber').val();

      var orderPayStatus =$('#orderPayStatus').val();

      var activitySalesOnline =$('#activitySalesOnline').val();

      var activityIsFree = $('#activityIsFree').val();

      var orderVotes = $('#orderVotes').val();

      var orderPhoneNo = $('#orderPhoneNo').val();

      if(orderNumber!=undefined && orderNumber=='输入订单号\\手机号'){
        $('#orderNumber').val("");
      }

      if(orderPayStatus != undefined && orderPayStatus == '全部订单' && orderPayStatus == 0){
        $('#orderPayStatus').val("");
      }
      if(activitySalesOnline != undefined && activitySalesOnline == '全部状态' && activitySalesOnline ==0){
        $('#activitySalesOnline').val("");
      }
      if(orderVotes != undefined && orderVotes == '全部票数'){
        $('#orderVotes').val("");
      }
      if(activityIsFree != undefined && activityIsFree == '全部订单' && activityIsFree == 0){
        $('#activityIsFree').val("");
      }
      if(orderPhoneNo != undefined && orderPhoneNo == '输入订单号\\手机号'){
        $('#orderPhoneNo').val("");
      }
      /*      if(activityArea != undefined && activityArea == '全部订单' && activityArea == 0){
       $('#activityArea').val("");
       }*/

      //场馆
//      $('#venueId').val($('#loc_venue').val());
//      $('#venueType').val($('#loc_category').val());
//      $('#venueArea').val($('#loc_area').val());
      $(formName).submit();
    }
  /**
    * 查看详情
    * @param id
   */
  function checkMessger(id){
    $.post("${path}/userActivity/deleteUserActivityHistory.do",{
      'activityId':id
    })
  }


    /**
     *  发送消息
     */
    function sendMessger(id){
      dialogConfirm("发送短消息", "您确定发送短消息吗？", removeParent);
      function removeParent() {
        $.post("${path}/order/sendSmsMessage.do",{'activityOrderId':id},function(data){
          if(data == "success"){
            dialogAlert("提示","短信发送成功!");
            //$("#activityForm").submit();
          } else {
            dialogAlert("提示","短信发送失败!");
          }
        });
      }
    }
    <%--alert(${activity.orderPhoneNo});--%>
  </script>
</head>
<body>
<form id="activityForm" action="${path}/order/orderList.do" method="post">
<input type="hidden" name="activityId" id="activityId" value="${activityId}"/>
  <div class="site">
    <em>您现在所在的位置：</em>订单管理 &gt;活动订单
  </div>
  <div class="search">
    <div class="search-box">
      <i></i><input type="text" id="orderNumber" name="orderNumber" value="${activity.orderNumber}" data-val="输入订单号\手机号" class="input-text"/>
    </div>
    <%--<div class="select-box w135">--%>
      <%--<input type="hidden" id="activityArea" name="activityArea" value="${activity.activityArea}"/>--%>
      <%--<div id="areaDiv" class="select-text" data-value="">全部区县</div>--%>
      <%--<ul class="select-option" id="areaUl">--%>
      <%--</ul>--%>
    <%--</div>--%>
    <div class="select-box w135">
      <input type="hidden" value="${activity.orderVotes}" name="orderVotes" id="orderVotes"/>
      <div class="select-text" data-value="">
        <c:choose>
          <c:when test="${activity.orderVotes == '1'}">
            1
          </c:when>
          <c:when test="${activity.orderVotes == '2'}">
            2
          </c:when>
          <c:when test="${activity.orderVotes == '3'}">
            3
          </c:when>
          <c:when test="${activity.orderVotes == '4'}">
            4
          </c:when>
          <c:when test="${activity.orderVotes == '5'}">
            5
          </c:when>
          <c:otherwise>
            全部票数
          </c:otherwise>
        </c:choose>
      </div>
      <ul class="select-option">
        <li data-option="">全部票数</li>
        <li data-option="1">1</li>
        <li data-option="2">2</li>
        <li data-option="3">3</li>
        <li data-option="4">4</li>
        <li data-option="5">5</li>
      </ul>
    </div>


    <%--<div class="select-box w135">--%>
      <%--<input type="hidden" value="${activity.activitySalesOnline}" name="activitySalesOnline" id="activitySalesOnline"/>--%>
      <%--<div class="select-text" data-value="">--%>
        <%--<c:choose>--%>
          <%--<c:when test="${activity.activitySalesOnline == 'Y'}">--%>
            <%--在线选座--%>
          <%--</c:when>--%>
          <%--<c:when test="${activity.activitySalesOnline == 'N'}">--%>
            <%--自由入座--%>
          <%--</c:when>--%>
          <%--<c:otherwise>--%>
            <%--全部订单--%>
          <%--</c:otherwise>--%>
        <%--</c:choose>--%>
      <%--</div>--%>
      <%--<ul class="select-option">--%>
        <%--<li data-option="">全部订单</li>--%>
        <%--<li data-option="Y">在线选座</li>--%>
        <%--<li data-option="N">自由入座</li>--%>
      <%--</ul>--%>
    <%--</div>--%>

    <div class="select-box w135">
      <input type="hidden" value="${activity.orderPayStatus}" name="orderPayStatus" id="orderPayStatus"/>
      <div class="select-text" data-value="">
        <c:choose>
          <c:when test="${activity.orderPayStatus==1}">
            未出票
          </c:when>
          <c:when test="${activity.orderPayStatus==2}">
            已取消
          </c:when>
          <c:when test="${activity.orderPayStatus==3}">
            已出票
          </c:when>
          <c:when test="${activity.orderPayStatus==4}">
            已验票
          </c:when>
          <c:when test="${activity.orderPayStatus ==5}">
            已失效
          </c:when>
          <c:otherwise>
            全部状态
          </c:otherwise>
        </c:choose>
      </div>
      <ul class="select-option">
        <li data-option=""  >全部状态</li>
        <li data-option="1"  >未出票</li>
        <li data-option="2"  >已取消</li>
        <li data-option="3"  >已出票</li>
        <li data-option="4"  >已验票</li>
        <li data-option="5"  >已失效</li>
      </ul>
    </div>
    <%--    <div class="select-box w110">
          <input type="hidden" value="${activity.activityIsFree}" name="activityIsFree" id="activityIsFree" />
          <div class="select-text"  data-value="">
            <c:choose>
              <c:when test="${activity.activityIsFree == 1}">
                免费订单
              </c:when>
              <c:when test="${activity.activityIsFree == 2}">
                收费订单
              </c:when>
              <c:otherwise>
                全部订单
              </c:otherwise>
            </c:choose>
          </div>
          <ul class="select-option">
            <li data-option="">全部订单</li>
            <li data-option="1">免费</li>
            <li data-option="2" >收费</li>
          </ul>
        </div>--%>

    <div class="select-btn">
      <input type="button" onclick="$('#page').val(1);formSub('#activityForm');" value="搜索"/>
    </div>
    <%--<div class="search-total">--%>
      <%--<div class="select-btn">--%>
        <%--<input type="button" onclick="exportOrderExcel();" value="导出"/>--%>
      <%--</div>--%>
      <%--待审核活动<span class="red">20</span>条--%>
    </div>
  </div>
  <div class="main-content">
    <table width="100%">
      <thead>
      <tr>
        <th >ID</th>
        <th >订单号</th>
        <%--<th class="venue">所属场馆</th>--%>
        <th>预定号码</th>
        <th  class="free">费用</th>
        <th>票数</th>
        <th >预订人</th>
        <th>操作时间</th>
        <th>订单状态</th>
        <th>验票人</th>
        <th>验票时间</th>
        <th>管理</th>
      </tr>
      </thead>

      <tbody>
      <%int i=0;%>
      <c:forEach items="${activityList}" var="avct">
        <%i++;%>
        <tr>
          <td ><%=i%></td>
          <td >${avct.orderNumber}</td>
          <%--<td class="title">--%>
            <%--<c:if test="${not empty avct.activityName}">--%>
              <%--<c:set var="activityName" value="${avct.activityName}"/>--%>
              <%--<c:out value="${fn:substring(activityName,0,19)}"/>--%>
              <%--<c:if test="${fn:length(activityName) > 19}">...</c:if>--%>
            <%--</c:if>--%>
          <%--</td>--%>

          <%--<td class="venue">--%>
            <%--<c:choose>--%>
              <%--<c:when test="${avct.createActivityCode == 1}">市级自建</c:when>--%>
              <%--<c:when test="${avct.createActivityCode == 2}">区级自建</c:when>--%>
              <%--<c:otherwise>--%>
                <%--<c:if test="${not empty avct.venueName}">--%>
                  <%--<c:out escapeXml="true" value="${avct.venueName}"/>--%>
                <%--</c:if>--%>
                <%--<c:if test="${empty avct.venueName}">--%>
                  <%--未知场馆--%>
                <%--</c:if>--%>
              <%--</c:otherwise>--%>
            <%--</c:choose>--%>
          <%--</td>--%>
          <td>
            ${avct.orderPhoneNo}
              <%--<c:if test="${not empty avct.orderPhoneNo}">--%>
                <%--${avct.orderPhoneNo}--%>
              <%--</c:if>--%>
              <%--<c:if test="${empty avct.orderPhoneNo}">--%>
                <%--未知号码--%>
              <%--</c:if>--%>
          </td>
          <td  class="free">
            <c:choose>
            <c:when test="${avct.activityIsFree == 1}">免费</c:when>
            <c:otherwise>收费</c:otherwise>
            </c:choose>
            </td>
          <td>
          ${avct.orderVotes}
          </td>
          <td >
            <c:if test="${not empty avct.orderName}">
              ${avct.orderName}
            </c:if>
            <c:if test="${empty avct.orderName}">
              未知预订人
            </c:if>
          </td>
          <td >
            <c:if test="${not empty avct.orderCreateTime}">
              <fmt:formatDate value="${avct.orderCreateTime}" pattern="yyyy-MM-dd HH:mm" />
            </c:if>
          </td>
          <td >
            <c:if test="${not empty avct.orderPayStatus}">
              <c:if test="${avct.orderPayStatus ==1}">
                未出票
              </c:if>
              <c:if test="${avct.orderPayStatus ==2}">
                已取消
              </c:if>
              <c:if test="${avct.orderPayStatus ==3}">
                已出票
              </c:if>
              <c:if test="${avct.orderPayStatus ==4}">
                已验票
              </c:if>
              <c:if test="${avct.orderPayStatus ==5}">
                已失效
              </c:if>
            </c:if>
          </td>
          <td >
            <c:if test="${not empty avct.orderCheckUser}">
              ${avct.orderCheckUser}
            </c:if>
          </td>
          <td>
            <c:if test="${not empty avct.orderCheckTime}">
              <fmt:formatDate value="${avct.orderCheckTime}" pattern="yyyy-MM-dd HH:mm" />
            </c:if>
          </td>
          <td>
            <%if(activityOrderDetailButton){%>
              <a  href="${path}/order/viewOrderDetail.do?activityOrderId=${avct.activityOrderId}">查看</a>
            <%}%>
           <c:if test="${avct.orderPayStatus == 1}"> <!--有效-->
             <%if(activityOrderCancelButton){%>
              <%if(activityOrderDetailButton){%> | <%}%>
             <c:if test="${avct.activitySalesOnline == 'Y'}" >
               <a  href="javascript:cancelUserOrder('${avct.activityOrderId}')">取消</a>
             </c:if>
             <c:if test="${avct.activitySalesOnline == 'N'}" >
               <a  href="javascript:cancelOrder('${avct.activityOrderId}')">取消</a>
             </c:if>
             <%}%>
             <%if(activityOrderSendSmsButton){%>
              <%if(activityOrderSendSmsButton){%> | <%}%><a  target="main" onclick="sendMessger('${avct.activityOrderId}')">发消息</a>
             <%}%>
           </c:if>
          </td>
        </tr>
      </c:forEach>

      <c:if test="${empty activityList}">
        <tr>
          <td colspan="12"><h4 style="color:#DC590C">暂无数据!</h4></td>
        </tr>
      </c:if>
      </tbody>
    </table>
    <c:if test="${not empty activityList}" >
      <input type="hidden" id="page" name="page" value="${page.page}" />
      <div id="kkpager" ></div>
    </c:if>
  </div>
</form>
</body>
</html>