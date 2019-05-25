<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%
  String path = request.getContextPath();
  request.setAttribute("path", path);
  String basePath = request.getScheme() + "://"
          + request.getServerName() + ":" + request.getServerPort()
          + path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <title>添加模板</title>
  <%--<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>--%>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/reset.css"/>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/main.css"/>

  <%--<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/main-ie.css"/>--%>
  <script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/base.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/DatePicker/WdatePicker.js"></script>
  <!-- dialog start -->
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
  <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
  <script type="text/javascript">
    var seatHeight = 0;
    function selectTemplate(templateId) {
      $.post("${path}/activitySeat/activityVenueSeat.do?templateId=" + templateId, function(data) {
        var map = eval(data);
        $("#seatInfo").val(map.seatInfo);
        showTemplate();
      });
    }

    //获取座位状态A U D 数据
    function getSeatStatus2(){
      var allCell = $("#seat-map .seatCharts-container .seatCharts-seat");
      //var seatArr = [];
      var tempStr = "";

      var seatInfo = $("#seatInfo").val();
      var seatInfoArr = seatInfo.split("*");
      var len = seatInfoArr[0].split(",").length;
      var i = 1;
      allCell.each(function(){
        var that = $(this);
        var cellStatus = that.attr("data-status").substr(0,1).toLocaleUpperCase();
        var cellTit = that.attr("title");
        var cellTit = that.attr("title");
        var cellTime = that.attr("data-time");
        if (cellTime == undefined) {
          cellTime = "";
        }
        //seatArr.push(cellStatus+"-"+cellId);
        tempStr  = tempStr + cellStatus + "-" + cellTit + "-" + cellTime  + ",";
        if ((i%len) == 0){
          tempStr = tempStr.substring(0,tempStr.length - 1)
          tempStr += "*";
        }
        i = i +1;
      });

      return tempStr.substring(0,tempStr.length - 1);
    }

    function getSeatData(){
      var allCell = $("#seat-map .seatCharts-container .seatCharts-seat");
      var seatArr = [];
      allCell.each(function(){
        var that = $(this);
        var cellStatus = that.attr("data-status").substr(0,1).toLocaleUpperCase();
        var cellId = that.attr("id");
        var cellTit = that.attr("title");
        var cellTime = that.attr("data-time");
        if (cellTime == undefined) {
          cellTime = "";
        }
        seatArr.push(cellStatus+"-"+cellId + "-"+cellTit+ "-"+cellTime);
      });
      var dataStr = seatArr.join(",");
    }

    //获取有效座位数量
    function getValidCount(){
      var allCell = $("#seat-map .seatCharts-container .seatCharts-seat");
      var validCount = 0;
      allCell.each(function(){
        var that = $(this);
        var cellStatus = that.attr("data-status");
        if(cellStatus == "available"){
          validCount++;
        }
      });
      return validCount;
    }
    seajs.config({
      alias: {
        "jquery": "${path}/STATIC/js/dialog/lib/jquery-1.10.2.js"
      }
    });

    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
      window.dialog = dialog;
    });

    function addTemplate(venueId) {
      location.href= "${path}/venueSeatTemplate/venueSeatTemplateIndex.do?venueId=" + venueId;
    }

    window.console = window.console || {log:function () {}}
    seajs.use(['jquery'], function ($) {
      $(function () {
        var dialog = parent.dialog.get(window);
        var data = dialog.data; // 获取对话框传递过来的数据
        $("#seatInfo").val(data.seatInfo);
        $("#activityStartTime").val(data.activityStartTime);
        if($("#seatInfo").val() != '' && $("#seatInfo").val() != undefined) {
          showTemplate();
        }

        /*点击确定按钮*/
        $(".btn-save").on("click", function(){
          var dataStr = getSeatData();
          var validCount = getValidCount();
          var seatInfo = getSeatStatus2();
          $("#seatIds").val(dataStr);
          $("#validCount").val(validCount);
          var valData = {"dataStr": dataStr, "validCount": validCount, "seatInfo" :seatInfo};
          //  }
          dialog.close(valData).remove();
        });
        /*点击取消按钮，关闭登录框*/
        $(".btn-cancel").on("click", function(){
          dialog.close().remove();
        });
        $(".main-publish .template-select").on("click", "a" ,function(){
          var templateId = $(this).attr("data-id");
          $.post("${path}/activitySeat/activityVenueSeat.do?templateId=" + templateId, function(data) {
            var map = eval(data);
            $("#seatInfo").val(map.seatInfo);
            showTemplate();
            dialog.height($("body").height());
            dialog.reset();     // 重置对话框位置
          });
          $(this).addClass("cur").siblings().removeClass("cur");
        });


        $(".data-btn").on("click", function(){
          WdatePicker({el:'startTicketTime',dateFmt:'yyyy-MM-dd HH:00',doubleCalendar:true,maxDate:$("#activityStartTime").val(),position:{left:-70,top:8},isShowClear:false,isShowOK:true,isShowToday:false,onpicked:pickedStartFunc})
        });
        /*取消时间设置*/
        $("#cancel-time").on("click", function(){
          $(".seatCharts-container .selected").each(function(){
            var $this = $(this);
            var status = $this.attr("data-status");
            updateTimeArr($this);
            setTicketList(timeArr);
            $this.find("p").remove();
            $this.removeClass("selected").addClass(status).attr("data-time","").css({"height": "28px"});
            dialog.height($("body").height());
            dialog.reset();     // 重置对话框位置
          });
          /**2015 11 9 取消全选状态*/
          checkall();
        });

        function pickedStartFunc(){
          var timeValue = $dp.cal.getDateStr('MM/dd HH')+":00";
          $dp.$('startTicketTime').value = $dp.cal.getDateStr('yyyy-MM-dd HH')+":00";
          /*设置座位日期*/
          $(".seatCharts-container .selected").each(function(){
            var $this = $(this);
            var status = $this.attr("data-status");
            var timeDiv = $("<p></p>").text(timeValue);
            $this.find("p").remove();
            var oldTime = $this.attr("data-time");
            if(status == "available") {
              /*统计改变前的时间*/
              for (var i in timeArr) {
                if (timeArr[i].time == oldTime) {
                  timeArr[i].num--;
                  if (timeArr[i].num == 0) {
                    timeArr.splice(i, 1);
                  }
                  break;
                }
              }
              /**2015 11 9 取消全选状态*/
              checkall();
              /*统计改变后的时间*/
              for (var i in timeArr) {
                if (timeArr[i].time == timeValue) {
                  timeArr[i].num++;
                  break;
                } else if (i == timeArr.length - 1) {
                  timeArr.push({"time": timeValue, "num": 1});
                  break;
                }
              }
              if(timeArr.length == 0){
                timeArr.push({"time": timeValue, "num": 1});
              }
              setTicketList(timeArr);
            }
            $this.removeClass("selected").addClass(status).attr("data-time", timeValue).css({"height": "60px"}).append(timeDiv);
            //$this.parents(".seatCharts-row").css({"height": "58px"});
            dialog.height($("body").height());
            dialog.reset();     // 重置对话框位置
          });
        }

      });
    });
  </script>
  <!-- dialog end -->
</head>
<body style="background: none;">
<form action="" name="seatForm" id="seatForm">
  <input type="hidden" id="templateId" name="templateId" value="${record.templateId}"/>
  <input type="hidden" id="seatIds" name="seatIds"/>
  <input type="hidden" id="venueId" name="venueId" value="${venueId}"/>
  <input type="hidden" id="seatInfo" name="seatInfo" value="${seatInfo}"/>
  <%--<input type="hidden" id="allInfo" name="allInfo" value="${allInfo}" />--%>
  <input type="hidden" id="validCount" name="validCount" value="${record.validCount}"/>
  <div class="main-publish" style="padding: 30px 20px;">
    <style type="text/css">
      .seatCharts-row{ overflow: hidden;}
      .seatCharts-row .seatCharts-cell:first-child{ margin-right: 7px;}
      .seatCharts-container{ overflow: hidden;}
      .legend-box .seatCharts-seat.available{ background-color: #FFB973;}
      .legend-box .seatCharts-seat.deleted{ background-color: #FF4D4D;}
      .legend-box .seatCharts-seat.unavailable{ cursor: pointer;}
      .legend-box .seatCharts-seat.gift{ background-color: #5CC0CD;}
      .seatCharts-seat.available span{ background-color: #FFB973;}
      .seatCharts-seat.deleted span{ background-color: #FF4D4D;}
      .seatCharts-seat.gift span{ background-color: #5CC0CD;}
      .seatCharts-seat .editTit{ display: block; height:26px; line-height: 26px; width:30px; padding:0; margin:0; *margin-left:-7px; font-size:12px; border:1px #7EC4CC solid; text-align: center; vertical-align: top;}
      #map-tip{ display: block; height: 20px; line-height: 20px; padding: 5px; position: absolute; color: #ff0000; font-size: 12px; background: #FFFFFF; border: solid 1px #cccccc;}
      .seatCharts-seat.selected{ background-color: none;}
      .seatCharts-seat.deleted{ cursor: not-allowed;}
      .seatCharts-seat.deleted  span{ background-color: #ffffff;}
      .seatCharts-seat.unavailable span{ cursor: pointer;}
      .seatCharts-seat.selected{ background-color: #67AF22;}
    </style>
    <table width="100%" class="form-table">
      <tr>
        <td class="td-title">模板选择：</td>
        <td class="td-seat bt-line">
          <c:if test="${not empty list}">
            <div class="template-select">
              <c:forEach items="${list}" var="bean" >
                <a data-id="${bean.templateId}" >${bean.templateName} </a>
              </c:forEach>
            </div>
          </c:if>
          <c:if test="${empty list}">
            <div class="template-select template-add">
              <a href="${path}/venueSeatTemplate/venueSeatTemplateIndex.do?venueId=${venueId}" target="_blank"> 添加模板 </a>
            </div>
          </c:if>
        </td>
      </tr>
      <tr>
        <td width="100" class="td-title">颜色描述：</td>
        <td class="td-seat bt-line">
          <div class="legend-box">
            <ul>
              <li><div class="seatCharts-seat seatCharts-cell deleted"></div><span>删除</span></li>
              <li><div class="seatCharts-seat seatCharts-cell unavailable"></div><span>占用</span></li>
             <%-- <li><div class="seatCharts-seat seatCharts-cell gift"></div><span>赠票</span></li>--%>
              <li><div class="seatCharts-seat seatCharts-cell available"></div><span>可选</span></li>
              <li><div class="seatCharts-seat seatCharts-cell selected"></div><span>已选</span></li>
              <%--<li><div class="seatCharts-seat seatCharts-cell selected"></div><span>已选</span></li>--%>
            </ul>
          </div>
        </td>
      </tr>
      <tr>
        <td width="100" class="td-title">操作：</td>
        <td class="td-seat bt-line">
          <div class="legend-box">
            <a class="btn-seat seat-deleted" id="deleted">删除</a>
            <a class="btn-seat seat-unavailable" id="unavailable">已占用</a>
            <%--<a class="btn-seat seat-gift" id="gift">赠票</a>--%>
            <a class="btn-seat seat-available" id="available">恢复可用</a>
          </div>
        </td>
      </tr>

<%--      <tr>
        <td width="100" class="td-title">设置放票时间：</td>
        <input type="hidden" name="activityStartTime" id="activityStartTime" value="${activityStartTime}" />
        <td class="td-time">
          <div class="end w240">
            <span class="text">放票时间</span>
            <input type="text" id="startTicketTime" readonly/>
            <i class="data-btn"></i>
          </div>
          <a class="cancel-time-btn" id="cancel-time">取消时间设置</a>
        </td>
      </tr>--%>

      <tr>
        <td width="100" class="td-title">票数统计：</td>
        <td>
          <ul class="ticket-list" id="ticket-list">
            <li id="total-ticket">总票数<em></em></li>
            <%--<li id="gift-ticket">赠票数：<em></em></li>--%>
            <!--<li>8/20：<em>20</em></li>-->
          </ul>
        </td>
      </tr>
      <tr>
        <td width="100" class="td-title">座位表：</td>
        <td class="td-seat">
          <div id="seat-map">

          </div>
        </td>
      </tr>
      <tr>
        <td class="td-title"></td>
        <td class="td-btn">
          <input class="btn-publish btn-save" type="button" value="确定选择"/>
        </td>
      </tr>
    </table>
  </div>
  <script type="text/javascript">
    var timeArr = [];  //时间数组
    var totalNum = 0;  //总票数
    var giftNum = 0;   //赠票数
    var classDefault = "seatCharts-seat seatCharts-cell ";
    function showTemplate() {
      totalNum = 0, giftNum = 0;

      //显示所有座位信息
      var seatInfo = $("#seatInfo").val();
      var seatDataInfo = seatInfo.split("*");
      var seatData = [];
      var seatDataArr = [];
      for(var i=0; i < seatDataInfo.length; i++){
        var seatDataVal = seatDataInfo[i].split(",");
        for(var j=0; j<seatDataVal.length; j++){
          seatDataArr.push(seatDataVal[j]);
        }
        seatData.push(seatDataArr);
        seatDataArr = [];
      }
      if(seatInfo == undefined || seatInfo == null || seatInfo == ""){
        return;
      }
      var classDefault = "seatCharts-seat seatCharts-cell ";
      var row = seatData.length;
      var column = seatData[0].length;
      $("#seat-map").html('<div class="front">中心舞台</div><div class="seatCharts-container"></div>');
      var seatContainer = $("#seat-map .seatCharts-container");
      var boxWidth = Math.min(44*column+64, $("#seat-map").width());
      seatContainer.css({"width": boxWidth, "overflow": "auto"});
      $(".td-seat .front").css("width", boxWidth);
      var aColumnWidth = 32;
//    var cellMargin = parseInt((boxWidth/(column+1)*0.1 > 2 ? (boxWidth/(column+1)*0.1) : 2));
      var cellMargin = parseInt((boxWidth/(column+2)*0.1 > 2 ? (boxWidth/(column+2)*0.1) : 2));
      var aColumnTitWidth = "50px";
      var cellMarginStr = "6px " + cellMargin+"px";
//    var oRowWidth = (aColumnWidth+cellMargin*2)*column + 50+cellMargin*2;
      var oRowWidth = (aColumnWidth+cellMargin*2)*(column+1) + 50+cellMargin*2;
      for(var i = 1; i < row+1; i++){
        if(i == 1) {
          var oRowTitleBox = $("<div>").addClass("seatCharts-row").css({"width": oRowWidth}).appendTo(seatContainer);
          var oColumnSpace = $('<div>').addClass("seatCharts-cell seatCharts-space").css({"width": aColumnTitWidth, "margin": cellMarginStr}).appendTo(oRowTitleBox);

          for(var j = 1; j < column+1; j++){
            var oRowTitle = $("<div>").addClass("seatCharts-cell seatCharts-space").css({"width": aColumnWidth, "margin": cellMarginStr}).text(j).appendTo(oRowTitleBox);
          }
          var oRowTitle = $("<div>").addClass("seatCharts-cell seatCharts-space").css({"width": aColumnWidth, "margin": cellMarginStr}).text('全选').appendTo(oRowTitleBox);
        }
        var oRow = $("<div>").addClass("seatCharts-row").css("width", oRowWidth).appendTo(seatContainer);

        for(var j = 1; j < column+1; j++){
          var oColumnTitle = "";

          if(j == 1){
            /*行标题*/
            oColumnTitle = $("<div>").addClass("seatCharts-cell seatCharts-space").css({"width": aColumnTitWidth, "margin": cellMarginStr}).text("第"+ i +"排").appendTo(oRow);
          }

          /*座位号*/

          var oColumnNum = seatData[i-1][j-1].split("-")[1];
          var status = seatData[i-1][j-1].split("-")[0];
          var oColumnTime = seatData[i-1][j-1].split("-")[2];
          if(status == "A"){ totalNum++;}
          if(status == "G"){ giftNum++;}
          /*页面初始化构建所有时间的数组对象*/
          if(oColumnTime != "" && oColumnTime != null && status == "A"){
            for (var item in timeArr) {
              if (timeArr[item].time == oColumnTime) {
                timeArr[item].num++;
                break;
              } else if(item == (timeArr.length-1)){
                timeArr.push({"time": oColumnTime, "num": 1});
                break;
              }
            }
            if(timeArr.length == 0){
              timeArr.push({"time": oColumnTime, "num": 1});
            }
          }
          var oColumnHeight = oColumnTime == "" ? 28 : 60;
          var statusStr = seatStatus(status) == "deleted" ? "deleted disabled" : seatStatus(status);
          var oColumn = $("<div>").addClass(classDefault + statusStr).attr({"id": i+"_"+j, "data-status": seatStatus(status), "title": oColumnNum,"data-time": oColumnTime}).css({"width": aColumnWidth, "margin": cellMarginStr, "height": oColumnHeight}).html("<span>"+oColumnNum+"</span><p>"+oColumnTime+"</p>").appendTo(oRow);
          //oRow.css({"height": (oColumnHeight > oRow.height() ? oColumnHeight : oRow.height())});
          oColumn.on({
            "click": function(){
              if($(this).hasClass("selected")){
                $(this).attr("class", classDefault + $(this).attr("data-status"));
              }
              else if($(this).hasClass("deleted")){

              }else {
                $(this).attr("class", classDefault + "selected");
              }
            }/*,
             "dblclick": function(){ *//*双击编辑事件*//*
             var $this = $(this);
             var txt = $this.find("span").text();
             $this.find("span").remove();
             $this.prepend("<input type='text' class='editTit' value='"+ txt +"'/>");
             var inputObj = $this.find("input");
             var inputTxt;
             var tools = _tools;
             tools.inputFocus(inputObj);

             inputObj.bind('blur', function(event) {
             inputTxt = inputObj.val();
             if(tools.validateFun(inputObj)) {
             $this.find("input").remove();
             inputObj.unbind();
             $this.attr({"title": inputTxt}).prepend("<span>"+inputTxt+"</span>");
             }
             }).bind('keydown', function(event) {
             event = event || window.event;
             if (event.keyCode=="13") {
             inputTxt = inputObj.val();
             if(tools.validateFun(inputObj)) {
             $this.find("input").remove();
             inputObj.unbind();
             $this.attr({"title": inputTxt}).prepend("<span>"+inputTxt+"</span>");
             }
             } else if (event.keyCode=="27") {
             inputTxt = $this.attr("title");
             $this.find("input").remove();
             inputObj.unbind();
             $this.prepend("<span>"+inputTxt+"</span>");
             } else{
             $("#map-tip").remove();
             inputObj.css("border","solid 1px #7EC4CC");
             }
             }).bind('click', function(event) {
             return false;
             }).bind('dblclick', function(event) {
             return false;
             });
             }*/
          })

        }
        oColumnselect = $("<div>").addClass("seated").css({"width": "30px", "margin": cellMarginStr,"float":"left","height":"28px","line-height":"28px","background":"#FFB973","color":"#ffffff","text-align":"center"}).html("<span>全选</span>").appendTo(oRow);
        var pre_delete=oColumnselect.siblings(".deleted");
        if(pre_delete.length==column){
          oColumnselect.css("visibility","hidden");
        }
        oColumnselect.on({
          "click": function(){
            var seat=$(this).siblings(".seatCharts-seat");
            var len=seat.length;

            if(seat.hasClass("selected")){

              //$(this).siblings(".seatCharts-seat").attr("class", classDefault + $(this).siblings(".seatCharts-seat").attr("data-status"));
              seat.each(function(){
                $(this).attr("class", classDefault + $(this).attr("data-status"));

              })
              $(this).css("background","#FFB973")

            }
            else if(seat.hasClass("deleted")){
              seat.each(function(){
                if($(this).hasClass("deleted")){

                }
                else{
                  $(this).attr("class", classDefault + "selected");
                  $(this).siblings(".seated").css("background","#67AF22")
                }
              })
            }

            else {
              seat.attr("class", classDefault + "selected");
              $(this).css("background","#67AF22")

            }
          }
        })

      }

      seatHeight = $("#seat-map").height(); //座位加载后,获取seat-map的高度

      setTicketList(timeArr);
      $("#total-ticket em").text(totalNum);
      $("#gift-ticket em").text(giftNum);

      $("#deleted").on("click", function(){
       $(".seatCharts-container .selected").each(function(){
       var $this = $(this);
       updateTimeArr($this);
       updateTotalNum($this);
       updateGiftNum($this);
       setTicketList(timeArr);
       $(this).attr({"class": classDefault+"deleted", "data-status": "deleted"});
       });
       });

      $("#unavailable").on("click", function(){
        $(".seatCharts-container .selected").each(function(){
          var $this = $(this);
          updateTimeArr($this);
          updateTotalNum($this);
          updateGiftNum($this);
          setTicketList(timeArr);
          $this.attr({"class": classDefault+"unavailable", "data-status": "unavailable"});
        });
        /**2015 11 9 取消全选状态*/
        checkall();
      });
      $("#gift").on("click", function(){
        $(".seatCharts-container .selected").each(function(){
          var $this = $(this);
          if($this.attr("data-status") != "gift") {
            giftNum++;
          }
          $("#gift-ticket em").text(giftNum);
          updateTimeArr($this);
          updateTotalNum($this);
          setTicketList(timeArr);
          $this.attr({"class": classDefault+"gift", "data-status": "gift"});
        });
        /**2015 11 9 取消全选状态*/
        checkall();
      });
      $("#available").on("click", function(){
        $(".seatCharts-container .selected").each(function(){
          var $this = $(this);
          if($this.attr("data-status") != "available"){
            totalNum++;
            for(var i in timeArr){
              if(timeArr[i].time == $this.attr("data-time")){
                timeArr[i].num++;
                break;
              }
            }
          }
          if($this.attr("data-status") == "gift"){
            giftNum--;
          }
          $("#total-ticket em").text(totalNum);
          $("#gift-ticket em").text(giftNum);
          setTicketList(timeArr);
          $this.attr({"class": classDefault+"available", "data-status": "available"});
        });
        /**2015 11 9 取消全选状态*/
        checkall();
      })
    }
    /**2015 11 9 取消全选状态*/
    function checkall(){
      $(".seated").each(function(){
        $(this).css("background","#FFB973")
      })
    }
    /*操作状态时，更新总票数*/
    function updateTotalNum(obj){
      if(obj.attr("data-status") == "available"){
        totalNum--;
      }
      $("#total-ticket em").text(totalNum);
    }
    /*操作状态时，更新赠票数*/
    function updateGiftNum(obj){
      if(obj.attr("data-status") == "gift"){
        giftNum--;
      }
      $("#gift-ticket em").text(giftNum);
    }
    /*执行删除 占用 赠票操作时，更新时间数组*/
    function updateTimeArr(obj){
      if(obj.attr("data-status") == "available"){
        for(var i in timeArr){
          if(timeArr[i].time == obj.attr("data-time")){
            timeArr[i].num--;
            if(timeArr[i].num == 0){
              timeArr.splice(i, 1);
            }
            break;
          }
        }
      }
    }
    /*将统计出的票数显示到界面*/
    function setTicketList(arr){
      $("#ticket-list li:gt(1)").remove();
      arr.sort(sortObject('time'));
      for(var i in arr){
        var oLi =  $("<li></li>").html(arr[i].time + "：<em>"+ arr[i].num +"</em>");
        $("#ticket-list").append(oLi);
      }
    }
    /*数组对象排序*/
    function sortObject(name){
      return function(object1, object2){
        var value1 = object1[name];
        var value2 = object2[name];
        if(value1 < value2){
          return -1;
        }else if(value1 > value2){
          return 1;
        }else{
          return 0;
        }
      }
    }

    //返回座位的状态
    function seatStatus(status){
      if(status == "A"){ return "available";}
      else if(status == "U"){ return "unavailable";}
      else if(status == "D"){ return "deleted";}
      else if(status == "G"){ return "gift";}
    }
    var _tools = {
      inputFocus: function(inputObj){
        inputObj.focus();
        inputObj.select();
      },
      validateFun: function(inputObj){
        var siteMap = $("#seat-map");
        var inputTxt = inputObj.val();
        if(this.setTipText(inputTxt) == "" || this.setTipText(inputTxt) == null){
          $("#map-tip").remove();
          return true;
        }else{
          inputObj.css("border", "solid 1px #ff0000");
          var posTop = inputObj.position().top;
          var posLeft = inputObj.position().left;
          $("#map-tip").remove();
          var oTip = $("<span id='map-tip'></span>").css({"top": posTop-40}).animate({"top": posTop-34});
          oTip.text(this.setTipText(inputTxt)).appendTo(siteMap);
          oTip.css("left", (posLeft - (oTip.width()-30)/2));
          this.setCursorPosition(inputObj, inputTxt.length);
        }
      },
      setTipText: function(inputTxt){
        if(inputTxt == null || inputTxt == ""){
          return "请输入座位号";
        }else if(isNaN(Number(inputTxt))){
          return "请输入正确的座位号";
        }else if(Number(inputTxt) > 999){
          return "座位号最大为三位数";
        } else if(inputTxt.indexOf(".") > 0){
          return "请输入正确的座位号";
        }  else{
          return "";
        }
      },
      setCursorPosition: function(obj, pos){
        if(obj.setSelectionRange) {
          obj.focus();
          obj.setSelectionRange(pos,pos);
        } else if (obj.createTextRange) {
          var range = obj.createTextRange();
          range.collapse(true);
          range.moveEnd('character', pos);
          range.moveStart('character', pos);
          range.select();
        }
      }
    };


    function getSeatData(){
      var allCell = $("#seat-map .seatCharts-container .seatCharts-seat");
      var seatArr = [];
      allCell.each(function(){
        var that = $(this);
        var cellStatus = that.attr("data-status").substr(0,1).toLocaleUpperCase();
        var cellId = that.attr("id");
        var cellTit = that.attr("title");
        var cellTime = that.attr("data-time");
        if (cellTime == undefined) {
          cellTime = "";
        }
        seatArr.push(cellStatus+"-"+cellId + "-"+cellTit+ "-"+cellTime);
      });
      var dataStr = seatArr.join(",");
      return dataStr;
      //alert(dataStr);
    }


    $("#subTemplate").on("click",function(){
      //点击后onclick时间失效
      $("#subTemplate").unbind("click");

      //var result = checkData();
      if(result){
        var dataStr = getSeatData();
        var validCount = getValidCount();

        $("#seatIds").val(dataStr);
        $("#validCount").val(validCount);

        //富文本
        $('#templateDesc').val(CKEDITOR.instances.templateDesc.getData());
      }
    });

    //获取有效座位数量
    function getValidCount(){
      var allCell = $("#seat-map .seatCharts-container .seatCharts-seat");
      var validCount = 0;
      allCell.each(function(){
        var that = $(this);
        var cellStatus = that.attr("data-status");
        if(cellStatus == "available"){
          validCount++;
        }
      });
      return validCount;
    }
  </script>
</form>
</body>
</html>