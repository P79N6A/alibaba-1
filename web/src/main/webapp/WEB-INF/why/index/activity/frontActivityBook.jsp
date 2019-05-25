<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
  <title>活动--文化云</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css">
  <!--验证码-->
  <script type="text/javascript" src="${path}/STATIC/js/captcha.js"></script>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/captcha.css"/>
  <script type="text/javascript" src="${path}/STATIC/js/index/activity/activityOrder.js"></script>
  <!-- dialog start -->
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/ui-dialog.css"/>
  <script type="text/javascript" src="${path}/STATIC/js/jquery.seat-charts-aisle.js"></script>
<style type="text/css">
.actOrderBaoInfo {
	width: 615px;
}
.actOrderBaoInfo .aobItem {
	padding-bottom: 20px;
}
.actOrderBaoInfo .wenti {
	font-size: 16px;
	color: #000;
	line-height: 1.5;
	margin-bottom: 10px;
}
.actOrderBaoInfo textarea {
	width: 613px;
	border: 1px solid #ccc;
	font-size: 16px;
	color: #000;
	line-height: 24px;
	height: 96px;
	resize: none;
}
.room-part1 .tab1 .actOrderBaoInfo .error-msg {
	float: none;
	margin-left:0;
}
</style>
  <script type="text/javascript">
    $(function () {
      var weekDay = ["星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
      var dateStr = $("#date-input").val();
      var myDate = new Date(Date.parse(dateStr.replace(/-/g, "/")));

      $("#data-week").html(weekDay[myDate.getDay()]);

      if ($("#canNotEventStrs").val() != undefined && $("#canNotEventStrs").val() != '') {
        var canNotEventStrs = $("#canNotEventStrs").val().split(",");
        //日期变化时
        $(".data-btn").on("click", function(){
          WdatePicker({el:'minDateHidden',dateFmt:'yyyy-MM-dd',disabledDates:canNotEventStrs,
          doubleCalendar:true,minDate:'#F{$dp.$D(\'minDate\')}',
            maxDate:'#F{$dp.$D(\'maxDateHidden\')}',position:{left:-129,top:4},
            isShowClear:false,isShowOK:false,isShowToday:false,onpicked:pickedFunc})
        });
      } else {
        //日期变化时
        $(".data-btn").on("click", function(){
          WdatePicker({el:'minDateHidden',dateFmt:'yyyy-MM-dd',
            doubleCalendar:true,minDate:'#F{$dp.$D(\'minDate\')}',maxDate:'#F{$dp.$D(\'maxDateHidden\')}',position:{left:-129,top:4},isShowClear:false,isShowOK:false,isShowToday:false,onpicked:pickedFunc})
        });
      }
    });

    var lowestCredit = '${cmsActivity.lowestCredit}';
    var costCredit = '${cmsActivity.costCredit}';

  </script>
</head>
<body>

<!-- 导入头部文件 -->
<div class="header">
	<%@include file="../header.jsp" %>
	</div>
<%--是否是第三方标记--%>
<input type="hidden" id="mark" value="${sessionScope.terminalUser.userMobileNo}" />


<div id="register-content">
  <div class="register-content">
    <div class="steps steps-activity">
      <ul class="clearfix">
        <li class="step_1 visited_pre">1.填写基本信息<i class="tab_status"></i></li>
        <li class="step_2 visited_pre">2.选择座位<i class="tab_status"></i></li>
        <li class="step_3 active">3.填写取票信息<i class="tab_status"></i></li>
        <li class="step_4">4.确认订单信息<i class="tab_status"></i></li>
        <li class="step_5">5.完成预定</li>
      </ul>
    </div>
    <form action="${path}/frontActivity/preSaveActivityOder.do" name="bookForm" id="bookForm" method="post">
      <input type="hidden" name="seatInfo" id="seatInfo" value="${seatInfo}" />
      <input type="hidden" name="maintananceInfo" id="maintananceInfo" value="${maintananceInfo}" />
      <input type="hidden" name="vipInfo" id="vipInfo" value="${vipInfo}" />
      <input type="hidden" name="activityId" id="activityId" value="${activityId}" />

      <input type="hidden" name="selectSeatInfo" id="selectSeatInfo" value="${selectSeatInfo}"/>

      <input type="hidden" id="maxDateHidden" value="${cmsActivity.activityEndTime}"/>
      <input type="hidden" id="minDateHidden" value="${cmsActivity.activityStartTime}"/>
      <input type="hidden" id="minDate" value="${cmsActivity.activityStartTime}"/>
      <input type="hidden" id="eventId" name="eventId" value="" />
      <input type="hidden" id="eventDateTime" name="eventDateTime" value="${eventDateTime}"/>
      <input type = "hidden" id="canNotEventStrs" name="canNotEventStrs" value="${canNotEventStrs}" />
      <input type = "hidden" id="maxColumn" name="maxColumn" value="${maxColumn}" />
      <input type="hidden" id="ticketSettings" value="${cmsActivity.ticketSettings}">
      <input type="hidden" id="ticketCountInfo" value="${cmsActivity.ticketCount}">
      <input type="hidden" id="eventEndDate" value="">
      <input type="hidden" id="ticketNumberInfo" value="${cmsActivity.ticketNumber}">

      <input type="hidden" id="costTotalCredit" name="costTotalCredit" value=""/>
      <input type="hidden" id="orderCustomInfo" name="orderCustomInfo" value=""/>

      <div class="room-part1">
        <!--info start-->
        <div class="library_info clearfix">
          <div class="library_img fl"><img  id="iconUrl" iconUrl="${cmsActivity.activityIconUrl}" src="" width="136" height="101"></div>
          <div class="room-info fl">
            <h3><c:out escapeXml="true" value="${cmsActivity.activityName}"/></h3>
            <p class="site"><%--${fn:split(cmsActivity.activityCity, ',')[1]}&nbsp;<c:if test="${fn:split(cmsActivity.activityArea, ',')[1] != fn:split(cmsActivity.activityCity, ',')[1]}">${fn:split(cmsActivity.activityArea, ',')[1]}&nbsp;</c:if>--%><c:out escapeXml="true" value="${cmsActivity.activityAddress}"/></p>
            <%--<p><img src="${path}/STATIC/image/hd_icon1.png" width="20" height="23">地址：${fn:split(cmsActivity.activityCity, ',')[1]}&nbsp;<c:if test="${fn:split(cmsActivity.activityArea, ',')[1] != fn:split(cmsActivity.activityCity, ',')[1]}">${fn:split(cmsActivity.activityArea, ',')[1]}&nbsp;</c:if><c:out escapeXml="true" value="${cmsActivity.activityAddress}"/></p>--%>
          </div>
        </div>
        <!--info end-->
        <table class="tab1" width="100%">
          <tbody><tr>
            <th colspan="2">选择日期场次</th>
          </tr>
          <tr>
            <td class="w500">
              <span class="date_name fl">选择日期</span>
              <div class="date fl">
                <input type="hidden" id="dateHidden">
                <input type="text" id="date-input" value="${cmsActivity.activityStartTime}" readonly="">
                <span class="week" id="data-week">星期五</span>
                <i class="data-btn"></i>
              </div>
            </td>
          </tr>
          <tr>
            <td class="clearfix">
              <span class="date_name fl">选择场次</span>
              <div class="cate fl" id="activityTimeList">
              </div>
            </td>
          </tr>
          <tr>
            <td class="clearfix">
              <span class="date_name fl">剩余票数</span>
              <label id="ticketCount" style="line-height: 36px;color: #e63917"></label>
            </td>
          </tr>

          <c:if test="${not empty cmsActivity.costCredit}">
            <tr>
              <td class="clearfix">
                <span class="date_name fl" style="width: 114px;">预订消耗（积分）</span>
                <label id="积分" style="line-height: 36px">
                  预订需要达到<label style="color: #e63917">${cmsActivity.lowestCredit}</label>积分，
                  且每张需抵扣<label style="color: #e63917">${cmsActivity.costCredit}</label>积分
                </label>
              </td>
            </tr>
          </c:if>

          </tbody></table>
      </div>
      <c:if test="${cmsActivity.activitySalesOnline == 'Y'}" >
        <h1>选择座位</h1>
        <div class="room-part1 activity-part1 clearfix">
          <div class="clearfix">
            <div class="legend-box">
              <div class="tip2">
                <ul>
                  <li><div class="seatCharts-seat seatCharts-cell unavailable"></div><span>已售</span></li>
                  <li><div class="seatCharts-seat seatCharts-cell selected"></div><span>已选</span></li>
                  <li><div class="seatCharts-seat seatCharts-cell available"></div><span>可选</span></li>
                </ul>
              </div>
            </div>
            <div class="seat-box">
              <div class="front"></div>
              <div class="seat-wrap">
                <div class="seat-tit" id="seat-tit"></div>
                <div class="seat-container">
                  <div id="seat-map"></div>
                </div>
              </div>
            </div>
          </div>
          <div class="ticket-list">
            <div class="caption"><h4>已选座位</h4><span class="red">
        <c:if test="${cmsActivity.ticketSettings=='Y'}"> 每单最多可预订5个座位</c:if>
         <c:if test="${cmsActivity.ticketSettings=='N'}">
           <c:if  test="${not empty cmsActivity.ticketCount&&empty cmsActivity.ticketNumber}">
             本场活动单次最多预定${ cmsActivity.ticketCount}张票
           </c:if>
           <c:if  test="${not empty cmsActivity.ticketNumber&&empty cmsActivity.ticketCount}">
             本场活动最多可预定${ cmsActivity.ticketNumber}次
           </c:if>
           <c:if  test="${not empty cmsActivity.ticketNumber&&not empty cmsActivity.ticketCount}">
             本场活动单次最多预定${ cmsActivity.ticketCount}张票,最多可预定${ cmsActivity.ticketNumber}次
           </c:if>
         </c:if>
            </span></div>
            <div id="selected-seats"></div>
          </div>
        </div>
      </c:if>
      
      <c:if test="${not empty customInfojson}">
	      <h1>报名信息</h1>
	      <div class="room-part1 room-part2">
	       <div class="tab1">
		      <div class="actOrderBaoInfo" id="orderCustomInfodiv">
		      	<c:forEach items="${customInfojson}" var="customInfovar" varStatus="customInfovarStatus">
				<div class="aobItem" id="customInfotd${customInfovarStatus.index}">
					<div class="wenti" text="${customInfovar.title}">${customInfovar.title}</div>
					<textarea maxlength="${customInfovar.desc}">${customInfovar.value}</textarea>
				</div>
				</c:forEach>
			  </div>
			</div>
		  </div>
	     <%--  <div class="room-part1 room-part2">
	        <table class="tab1" width="100%" id="orderCustomInfoTable">
		        <c:forEach items="${customInfojson}" var="customInfovar" varStatus="customInfovarStatus">
		          <tr>
		            <td id="customInfotd${customInfovarStatus.index}">
		            	<span class="textareaspanclass" text="${customInfovar.title}">${customInfovar.title}</span>
			             <div class="textareadivclass">
			               <textarea maxlength="${customInfovar.desc}"></textarea>
			             </div>
		            </td>
		          </tr>
				</c:forEach>
	        </table>
	      </div> --%>
      </c:if>
      
      
      <h1>取票信息</h1>
      <div class="room-part1 room-part2">
        <table class="tab1" width="100%">
          <tr>
            <th style="border-bottom:1px solid #e3e3e3;">为了能顺利取票，请确保您的手机号码无误</th>
          </tr>
          <tr>
            <td id="orderPhoneNoMsg">
              <span class="fl tab_label">手机号</span>
              <div class="input-box showPlaceholder fl">
                <input class="input-text phoneNum w243" name="orderPhoneNo" id="orderPhoneNo"  <c:if test="${not empty orderPhoneNo}"> value="${orderPhoneNo}" </c:if> <c:if test="${empty orderPhoneNo}"> value="${sessionScope.terminalUser.userMobileNo}" </c:if> type="text"/>
              </div>
            </td>
          </tr>
          <c:if test="${cmsActivity.activitySalesOnline == 'N'}" >
            <tr>
              <td id="bookCountMsg">
                <span class="fl tab_label">数量</span>
                <div class="input-box showPlaceholder fl">
                  <input class="input-text phoneNum" name="bookCount" id="bookCount" value="${bookCount}" type="text"/>
                </div>
              </td>
            </tr>
            <tr>
              <td id="" style="padding: 0px;color: red;height: 20px">
                <span class="fl tab_label" style="height: 19px"></span>
                <div class="input-box showPlaceholder fl" style="height: 19px;margin-top: 10px">


                  <c:if test="${cmsActivity.ticketSettings=='N'}">
                    <c:if  test="${not empty cmsActivity.ticketCount&&empty cmsActivity.ticketNumber}">
                      （本场活动单次最多预定 ${ cmsActivity.ticketCount} 张票）
                    </c:if>
                    <c:if  test="${not empty cmsActivity.ticketNumber&&empty cmsActivity.ticketCount}">
                      （本场活动最多可预定 ${ cmsActivity.ticketNumber} 次）
                    </c:if>
                    <c:if  test="${not empty cmsActivity.ticketNumber&&not empty cmsActivity.ticketCount}">
                      （本场活动单次最多预定 ${ cmsActivity.ticketCount} 张票, 最多可预定 ${ cmsActivity.ticketNumber} 次）
                    </c:if>
                  </c:if>
                </div>
                  <%-- <span class="error-msg fl" id="count">请输入预订数量</span>--%>
              </td>
            </tr>
          </c:if>
          <tr>
            <td id="idcodeMsg">
              <span class="fl tab_label">验证码</span>
             <%-- <div class="input-box showPlaceholder fl" style="height: 40px;">--%>
                <input id="captcha" class="input-text yzm_input fl" type="text"/>
                <span id="idcode" style="width: 80px; margin-left: 10px; display: inline-block; vertical-align: middle; *padding-top: 3px;" class="fl"></span>
               <%-- <div class="clear"></div>--%>
             <%-- </div>--%>
              <%--<span class="error-msg fl" id="capCodeErr">请填写验证码</span>--%>

            </td>
            </tr>
        <div>
        </div>

        </table>
        <div class="book-notes">
          <div class="book_inner">
            <div class="notes-content">
              <h3 class="caption">预订须知</h3>
              <h4 class="notes-title">使用说明：</h4>
              <p>订票成功后，活动开始当日请提前入场，避免拥堵；</p>
              <p>如需退票，请在活动开始前办理相关手续；</p>
              <p> 每场活动票数有限，退票后再次预订可能遇到票已售完，无法订票的情况，由用户自行负责；</p>
              <p> 如遇非人为可控因素或重大天气等影响，导致活动无法举办，举办方有权利延后或取消活动，并以短信和站内信形式告知订票人办理相关手续。</p>
              <p> 活动最终解释权归举办方。</p>
            </div>
          </div>
        </div>
      </div>
      <div class="book-agreement">
        <input type="checkbox" id="agreement"  onclick="acceptItem()" />
        <label for="agreement">我已阅读并接受<a>预订须知及</a><a style="text-decoration: underline;">服务条款</a></label>
      </div>
      <div class="book-control">
        <input type="button" onclick="doBook()"  id="subOrder" value="提交订单" disabled =true class="btn-submit book-submit" style="background: #808080"/>
      </div>
      <span id="msg"></span>
    </form>
  </div>
</div>
<!-- 导入尾部文件 -->
<%@include file="/WEB-INF/why/index/footer.jsp" %>

<script type="text/javascript">
  function showSeat() {
    var seatInfo = $("#seatInfo").val();
    if (seatInfo != "" && seatInfo != undefined) {
      var seatInfoArr = seatInfo.split(",");
      var column = parseInt($("#maxColumn").val());
      var reg=new RegExp("-","g"); //创建正则RegExp对象
      for(var i=0; i< seatInfoArr.length; i++){
        seatInfoArr[i] = seatInfoArr[i].replace(reg,"\,");
      }

      //显示VIP座位信息
      var vipInfo = $("#vipInfo").val();
      if (vipInfo != '' && vipInfo != undefined) {
        var vipInfoArr = vipInfo.split(",");
        for(var i=0; i< vipInfoArr.length; i++){
          vipInfoArr[i] = vipInfoArr[i];
        }
      }


      var $cart = $('#selected-seats'), //座位区
              $counter = $('#counter'), //票数
              $total = $('#total'); //总计金额

      var sc = $('#seat-map').seatCharts({
        map: seatInfoArr,
        columnNum: column,
        seats: {
          a: {
            price   : 20,
            classes : 'first-level', //your custom CSS class
            category: '一等座'
          },
          b: {
            price   : 15,
            classes : 'second-level', //your custom CSS class
            category: '二等座'
          },
          c: {
            price   : 10,
            classes : 'third-level', //your custom CSS class
            category: '三等座'
          }

        },
        naming : {
          top : false,
          getLabel : function (character, row, column) {
            return column;
          }
        },
        legend : { //定义图例
          node : $('#legend'),
          items : [
            [ 'a', 'available',   '¥20' ],
            [ 'b', 'available',   '¥15' ],
            [ 'c', 'available',   '¥10' ]
          ]
        },
        click: function () { //点击事件
          if (this.status() == 'available') { //可选座
            $(".ticket-list").fadeIn();
            if((sc.find('selected').length+1) < 6){
              $('<span class="seat-txt"><input type="hidden" name="seatValues" value="'+(this.settings.row+1)+'排'+this.settings.label+'座'+'" /><input type="hidden" name="seatId" value="'+ this.settings.id +'" /> '+(this.settings.row+1)+'排'+this.settings.label+'座</span>')
              /*$('<span class="seat-txt"><input type="hidden" name="seatId" value="'+(this.settings.row+1) +'_'+ this.settings.label  +'" /> '+this.settings.colname+'</span>')*/
                      .attr('id', 'cart-item-'+this.settings.id)
                      .data('seatId', this.settings.id)
                      .appendTo($cart);

              $counter.text(sc.find('selected').length+1);
              $total.text(recalculateTotal(sc)+this.data().price);

              return 'selected';
            }else{
              alert("每单最多可预订5个座位");
              return 'available';
            }
          } else if (this.status() == 'selected') { //已选中
            //更新数量
            $counter.text(sc.find('selected').length-1);
            //票数小于1，隐藏票数列表
            if((sc.find('selected').length-1) <= 0){
              $(".ticket-list").fadeOut();
            }
            //更新总计
            $total.text(recalculateTotal(sc)-this.data().price);

            //删除已预订座位
            $('#cart-item-'+this.settings.id).remove();
            //可选座
            return 'available';
          } else if (this.status() == 'unavailable') { //已售出
            return 'unavailable';
          } else {
            return this.style();
          }
        }
      });
      //已售出的座位
      //sc.get(['1_2', '4_4','4_5','6_6','6_7','8_5','8_6','8_7','8_8', '10_1', '10_2']).status('unavailable');
      if (vipInfo != '' && vipInfo != undefined) {
        sc.get(vipInfoArr).status('unavailable');
      }
      var columnNum = column+1;
      var oRowWidth, columnWidth = 36;
      oRowWidth = (columnWidth+8)*column;
      $("#seat-map .seatCharts-row").css({"width": oRowWidth, "margin": "0 auto"});
      var maxWidth = Math.min(Math.max(oRowWidth,222), 660);
      $(".seat-container").css({"width": maxWidth});
      $(".seat-wrap").css({"width": Math.min(maxWidth+46,706)});

      if ($("#selectSeatInfo").val() != undefined && $("#selectSeatInfo").val() != '') {
        var selectSeatInfo =  $("#selectSeatInfo").val();
        var arr=new Array();
        arr =  selectSeatInfo.split(",");
        for(var i=0;i<arr.length;i++)
        {
          $("#" + arr[i]).trigger("click");
        }
      }
    }
  }

  //计算总金额
  function recalculateTotal(sc) {
    var total = 0;

    sc.find('selected').each(function () {
      total += this.data().price;
    });
    $("#orderPrice").val(total);
    return total;
  }
</script>

<script type="text/javascript" src="${path}/STATIC/js/dialog/lib/sea.js"></script>
<script type="text/javascript">
  seajs.config({
    alias: {
      "jquery": "${path}/STATIC/js/dialog/lib/jquery-1.10.2.js"
    }
  });
  seajs.use(['${path}/STATIC/js/dialog/src/dialog-plus'], function (dialog) {
    window.dialog = dialog;
  });

  window.console = window.console || {log:function () {}}
  seajs.use(['jquery'], function ($jq) {

/*    $('.book-submit').on('click', function () {

      top.dialog({
        url: '${path}/frontActivity/dialog.do',
        title: '验证手机',
        width: 560,
        height: 180,
        fixed: true,
        data: $(this).attr("data-name")
      }).showModal();

      return false;
    });*/



  });
</script>
</body>
</html>