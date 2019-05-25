<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
  <title>活动--文化云</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>

  <script type="text/javascript" src="${path}/STATIC/js/jquery.seat-charts.js"></script>

  <!--验证码-->
  <script type="text/javascript" src="${path}/STATIC/js/captcha.js"></script>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/captcha.css"/>

  <!-- dialog start -->
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/ui-dialog.css"/>

  <script type="text/javascript" src="${path}/STATIC/js/index/activity/activityOrder.js"></script>
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
  </script>
</head>
<body>

<%@include file="../list_top.jsp"%>
<%--是否是第三方标记--%>
<input type="hidden" id="mark" value="${sessionScope.terminalUser.userMobileNo}" />
<div id="register-content">
  <div class="register-content">
    <div class="steps steps-room">
      <ul class="clearfix">
        <li class="step_1 visited_pre" >1.填写票务信息<i class="tab_status"></i></li>
        <li class="step_2 active">2.填写取票信息<i class="tab_status"></i></li>
        <%--<li class="step_3 active">3.填写取票手机<i class="tab_status"></i></li>--%>
        <li class="step_3">3.确认订单信息<i class="tab_status"></i></li>
        <li class="step_4">4.完成预订</li>
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

      <div class="room-part1">
        <div class="room-info">
          <h3>${cmsActivity.activityName}</h3>
          <p>地址：<c:out escapeXml="true" value="${cmsActivity.activityAddress}"/></p>
         <%-- <p>活动开始时间 :${cmsActivity.activityStartTime} &nbsp;</p>--%>

        </div>
        <table class="tab1" width="100%">
          <tr>
            <th colspan="3">选择日期场次<span class="lightred">*</span></th>
          </tr>
          <tr>

            <td width="204">
              <div class="date">

                <input type="text" id="date-input" value="${cmsActivity.activityStartTime}"  readonly/>
                <span class="week" id="data-week">星期五</span>
                <i class="data-btn"></i>
              </div>
             <%-- <div class="date">
                &lt;%&ndash;<input type="text" value="2015-06-15"/>&ndash;%&gt;
                &lt;%&ndash;<span class="week">星期三</span>&ndash;%&gt;
                  ${cmsActivity.activityStartTime} &nbsp;
                <i class="data-btn"></i>--%>
              </div>
            </td>
            <td width="170">
              <div class="cate timeList" id="activityTimeList">
                <span class="arrow" >▼</span>

              </div>

            </td>
            <td align="left">

                    剩余票数:<label id="ticketCount"></label>

            </td>
          </tr>
        </table>
      </div>
      <c:if test="${cmsActivity.activitySalesOnline == 'Y'}" >
        <h1>选择座位</h1>
        <div class="room-part1 activity-part1 clearfix">
          <div class="legend-box">
            <%--<span class="tip">票价：</span><div id="legend"></div>--%>
            <div class="tip2">
              <ul>
                <li><div class="seatCharts-seat seatCharts-cell selected"></div><span>已选</span></li>
                <li><div class="seatCharts-seat seatCharts-cell unavailable"></div><span>已售</span></li>
              </ul>
            </div>
          </div>
          <div id="seat-map">
            <div class="front">中心舞台</div>
          </div>
          <div class="ticket-list">
            <div class="caption"><h4>已选座位</h4><span class="red">每单最多可预订5个座位</span></div>
            <div id="selected-seats"></div>
            <%--<table class="seatList" width="100%">
              <thead>
              <tr>
                <th width="68%">座位</th>
                <th>单价</th>
              </tr>
              </thead>
              <tbody id="selected-seats">
              </tbody>
            </table>
            <table class="seatList" width="100%">
              <thead>
              <tr>
                <th width="68%">总票数：</th>
                <th>总价</th>
              </tr>
              </thead>
              <tfoot>
              <tr>
                <input type="hidden" name="orderPrice" id="orderPrice" value="" />
                <td><span id="counter">0</span></td>
                <td><b>￥<span id="total">0</span></b></td>
              </tr>
              </tfoot>
            </table>--%>
          </div>
        </div>
      </c:if>
      <h1>取票信息</h1>
      <div class="room-part1 room-part2">
        <table class="tab1" width="100%">
          <tr>
            <th>为了能顺利取票，请确保您的手机号码无误<span class="lightred">*</span></th>
          </tr>
          <tr>
            <td>
              <div class="input-box showPlaceholder">
                <input class="input-text phoneNum" name="orderPhoneNo" id="orderPhoneNo"  <c:if test="${not empty orderPhoneNo}"> value="${orderPhoneNo}" </c:if> <c:if test="${empty orderPhoneNo}"> value="${sessionScope.terminalUser.userMobileNo}" </c:if> type="text"/>
              </div>
              <span class="error-msg">请填写手机号码</span>
            </td>

          </tr>
          <c:if test="${cmsActivity.activitySalesOnline == 'N'}" >
            <tr>
              <td>
                <div class="input-box showPlaceholder">
                  <input class="input-text phoneNum" name="bookCount" id="bookCount" value="${bookCount}" type="text"/>
                </div>
                <span class="error-msg" id="count">请输入预订数量</span>
              </td>
            </tr>
          </c:if>
          <tr>
            <td >
              <div class="input-box showPlaceholder" style="height: 40px;">
                <input id="captcha" class="input-text phoneNum fl" type="text" style="width: 200px;"/>
                <span id="idcode" style="width: 80px; margin-left: 10px; display: inline-block; vertical-align: middle; *padding-top: 3px;" class="fl"></span>
                <div class="clear"></div>
              </div>
              <span class="error-msg" id="capCodeErr">请输入验证码</span>

            </td>
            </tr>
        <div>
          <!--键盘 start-->
          <ul id="keyboard" style="display:none;z-index:3;">
            <li class="symbol"><span class="off">`</span><span class="on">~</span></li>
            <li class="symbol"><span class="off">1</span><span class="on">!</span></li>
            <li class="symbol"><span class="off">2</span><span class="on">@</span></li>
            <li class="symbol"><span class="off">3</span><span class="on">#</span></li>
            <li class="symbol"><span class="off">4</span><span class="on">$</span></li>
            <li class="symbol"><span class="off">5</span><span class="on">%</span></li>
            <li class="symbol"><span class="off">6</span><span class="on">^</span></li>
            <li class="symbol"><span class="off">7</span><span class="on">&amp;</span></li>
            <li class="symbol"><span class="off">8</span><span class="on">*</span></li>
            <li class="symbol"><span class="off">9</span><span class="on">(</span></li>
            <li class="symbol"><span class="off">0</span><span class="on">)</span></li>
            <li class="symbol"><span class="off">-</span><span class="on">_</span></li>
            <li class="symbol"><span class="off">=</span><span class="on">+</span></li>
            <li class="delete lastitem">delete</li>
            <li class="tab">tab</li>
            <li class="letter">q</li>
            <li class="letter">w</li>
            <li class="letter">e</li>
            <li class="letter">r</li>
            <li class="letter">t</li>
            <li class="letter">y</li>
            <li class="letter">u</li>
            <li class="letter">i</li>
            <li class="letter">o</li>
            <li class="letter">p</li>
            <li class="symbol"><span class="off">[</span><span class="on">{</span></li>
            <li class="symbol"><span class="off">]</span><span class="on">}</span></li>
            <li class="symbol lastitem"><span class="off">\</span><span class="on">|</span></li>
            <li class="capslock">caps lock</li>
            <li class="letter">a</li>
            <li class="letter">s</li>
            <li class="letter">d</li>
            <li class="letter">f</li>
            <li class="letter">g</li>
            <li class="letter">h</li>
            <li class="letter">j</li>
            <li class="letter">k</li>
            <li class="letter">l</li>
            <li class="symbol"><span class="off">;</span><span class="on">:</span></li>
            <li class="symbol"><span class="off">'</span><span class="on">&quot;</span></li>
            <li class="return lastitem">return</li>
            <li class="left-shift">shift</li>
            <li class="letter">z</li>
            <li class="letter">x</li>
            <li class="letter">c</li>
            <li class="letter">v</li>
            <li class="letter">b</li>
            <li class="letter">n</li>
            <li class="letter">m</li>
            <li class="symbol"><span class="off">,</span><span class="on">&lt;</span></li>
            <li class="symbol"><span class="off">.</span><span class="on">&gt;</span></li>
            <li class="symbol"><span class="off">/</span><span class="on">?</span></li>
            <li class="right-shift lastitem">shift</li>
            <li class="space lastitem">&nbsp;</li>
          </ul>
          <!--键盘 end-->
        </div>

        </table>
        <div class="book-notes">
          <div class="book_inner">
            <div class="notes-content">
              <h3 class="caption">预订须知</h3>
              <%--<h4 class="notes-title">退票规则：</h4>--%>
              <%--<p>此门票，一经出票不退不改！预订旋转餐厅的游客，如当日有同行儿童，须同时预订儿童票，景区门口现购儿童票，餐厅将无法安排座位。</p>--%>
              <h4 class="notes-title">使用说明：</h4>
              <%--<p>如预订在线选座活动，且当日有儿童同行，请预订儿童票；</p>--%>
              <p>订票成功后，活动开始当日请提前入场，避免拥堵；</p>
              <p>如需退票，请在活动开始前办理相关手续；</p>
              <p> 每场活动票数有限，退票后再次预订可能遇到票已售完，无法订票的情况，由用户自行负责；</p>
              <p> 如累计超过2次订票却没有到场参加活动者，将取消本年度购票资格。</p>
              <p> 如遇非人为可控因素或重大天气等影响，导致活动无法举办，举办方有权利延后或取消活动，并以短信和站内信形式告知订票人办理相关手续。</p>
              <p> 活动最终解释权归举办方。</p>
            </div>
          </div>
        </div>
      </div>
      <div class="book-agreement">
        <input type="checkbox" id="agreement"  onclick="acceptItem()" />
        <label for="agreement">我已阅读并接受<a href="###">预订须知及</a><a href="#" style="text-decoration: underline;">服务条款</a></label>
      </div>
      <div class="book-control">
        <input type="button" onclick="doBook()"  id="subOrder" value="提交订单" disabled =true class="book-submit" style="background: #808080"/>
      </div>
      <span id="msg"></span>
    </form>
  </div>
</div>
<!-- 导入尾部文件 -->
<%@include file="../index_foot.jsp"%>

<script type="text/javascript">
  function showSeat() {
    $("#seat-map").html('<div class="front">中心舞台</div>');
    //$("#seat-map").empty();
    //显示所有座位信息
    var seatInfo = $("#seatInfo").val();
    if(!seatInfo){
      return;
    }
    var seatInfoArr = seatInfo.split(",");
    for(var i=0; i< seatInfoArr.length; i++){
      seatInfoArr[i] = seatInfoArr[i];
    }

    //显示维修座位信息
    var maintananceInfo = $("#maintananceInfo").val();
    var mtananceInfoArr = maintananceInfo.split(",");
    var cell = seatInfoArr[0].length;
    for(var i=0; i< mtananceInfoArr.length; i++){
      mtananceInfoArr[i] = mtananceInfoArr[i];
    }

    //显示VIP座位信息
    var vipInfo = $("#vipInfo").val();
    var vipInfoArr = vipInfo.split(",");
    for(var i=0; i< vipInfoArr.length; i++){
      vipInfoArr[i] = vipInfoArr[i];
    }
    var $cart = $('#selected-seats'), //座位区
            $counter = $('#counter'), //票数
            $total = $('#total'); //总计金额
    var sc = null;
    var $10 = $;
    sc = $10('#seat-map').seatCharts({
      map:
              seatInfoArr,
      seats: {
        a: {
          price   : ${cmsActivity.activityPrice},
          classes : 'first-level', //your custom CSS class
          category: '一等座'
        },
        b: {
          price   : ${cmsActivity.activityPrice},
          classes : 'second-level', //your custom CSS class
          category: '二等座'
        },
        c: {
          price   : ${cmsActivity.activityPrice},
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
          [ 'a', 'available',   '${cmsActivity.activityPrice}' ],
          [ 'b', 'available',   '${cmsActivity.activityPrice}' ],
          [ 'c', 'available',   '${cmsActivity.activityPrice}' ]
        ]
      },
      click: function () { //点击事件
        if (this.status() == 'available') { //可选座
          $(".ticket-list").fadeIn();
          if((sc.find('selected').length+1) < 6){
            $('<span class="seat-txt"><input type="hidden" name="seatId" value="'+(this.settings.row+1) +'_'+ this.settings.label  +'" /> '+(this.settings.row+1)+'排'+this.settings.label+'座</span>')
                    .attr('id', 'cart-item-'+this.settings.id)
                    .data('seatId', this.settings.id)
                    .appendTo($cart);

            $counter.text(sc.find('selected').length+1);
            $total.text(recalculateTotal(sc)+this.data().price);

            return 'selected';
          }else{
            dialogAlert("提示","每单最多可预订5个座位");
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
    sc.get(vipInfoArr).status('unavailable');
    var cellNum = cell+1;
    if(cell > 20){
      var oRowWidth = Math.min(42*cellNum, 900);
      var cellWidth = Math.min(oRowWidth/cellNum*0.8, 28);
      var cellMargin = cellWidth >= 28
              ? Math.floor((oRowWidth-cellWidth*cellNum)/cellNum/2)
              : Math.min(oRowWidth/cellNum*0.1, 7);
      $("#seat-map .seatCharts-cell").css({"width": cellWidth, "margin": cellMargin});
    }else{
      var oRowWidth = Math.min(42*cellNum, 900);
      $("#seat-map .seatCharts-row").css({"width": oRowWidth, "margin": "0 auto"});
    }
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



  $(document).ready(function() {
    //showSeatInfo();
  });
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
<!-- dialog end -->

</body>
</html>