<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

    <script type="text/javascript" src="${path}/STATIC/js/admin/activity/UploadActivityFile.js?version=20151230"></script>
    <%--<script type="text/javascript" src="${path}/STATIC/js/admin/activity/getActivityFile.js"></script>--%>
    <script type="text/javascript" src="${path}/STATIC/js/area.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/area-venues-admin.js?version=20151125"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <!--文本编辑框 end-->
    <!-- dialog start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ckeditor/sample.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/admin/activity/addActivity.js?version=20160302"></script>
    <script type="text/javascript">
        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        window.console = window.console || {log:function () {}}
        //弹出座位编辑框
        $(function(){

            $("#activityPrice").keyup(function(){
                $(this).val($(this).val().replace(/[^0-9.]/g,''));
            }).bind("paste",function(){  //CTR+V事件处理
                $(this).val($(this).val().replace(/[^0-9.]/g,''));
            }).css("ime-mode", "disabled"); //CSS设置输入法不可用

            //var dialogWidth = ($(window).width() < 800) ? ($(window).width() * 0.8) : 800;
            var dialogWidth = ($(window).width() * 0.8);
            $('.set-ticket').on('click', function () {
                if ($('#loc_venue').val() == null || $('#loc_venue').val() == '') {
                    dialogAlert('系统提示', '请先选择场馆');
                    return;
                }
                dialog({
                    url: '${path}/activity/queryVenueSeatTemplateList.do?venueId=' + $('#loc_venue').val(),
                    title: '设置座位模板',
                    width: dialogWidth,
                    fixed: false,
                    data: {
                        seatInfo: $("#seatInfo").val()
                    }, // 给 iframe 的数据
                    onclose: function () {
                        if(this.returnValue){
                            //console.log(this.returnValue);
                            $('#seatIds').val(this.returnValue.dataStr);
                            $("#seatInfo").val(this.returnValue.seatInfo);
                            $('#validCount').val(this.returnValue.validCount);
                            $("#onlineText").val(this.returnValue.validCount);
                            $("#reservationSpan").show();
                            $("#notOnlineTicket").hide();
                            $("#onlineTicket").show();
                            $("#onlineTicket").html(this.returnValue.validCount);
                            $("#notOnlineText").val(this.returnValue.validCount);
                            getTotalTicketCount();
                            removeMsg("activityReservationCountLabel");
                        }
                        //dialog.focus();
                    }
                }).showModal();
                return false;
            });

            //获取经纬度
            $('#getMapAddressPoint').on('click', function () {
                var address =$('#activityAddress').val();
                dialog({
                    url: '${path}/activity/queryMapAddressPoint.do?address='+encodeURI(encodeURI(address)),
                    title: '获取经纬度',
                    width: 700,
                    fixed: true,
                    onclose: function () {
                        if(this.returnValue){

                            $('#activityLon').val(this.returnValue.xPoint);
                            $("#activityLat").val(this.returnValue.yPoint);

                        }
                        //dialog.focus();
                    }
                }).showModal();
                return false;
            });


        });


        $(function() {
            $.post("../activityTemplate/queryTemplateList.do",function(data) {

                if (data != '' && data != null) {
                    var list = eval(data);
                    var ulHtml = '<li data-option="">基础模板</li>';
                    for (var i = 0; i <list.length; i++) {
                        var template = list[i];
                        ulHtml += '<li data-option="'+template.templId+'">'+ template.templName+ '</li>';
                    }
                    $('#templIdUl').html(ulHtml);
                }
            }).success(function() {
                selectModel();
            });
        });

    </script>
</head>

<body >

<form action="${path}/activity/addActivity.do" id="activityForm" method="post">
    <input type="hidden" id="userCounty" name="userCounty" value="${sessionScope.user.userCounty}">
    <input type="hidden" id="activityIsDel" name="activityIsDel" value="1">
    <input type="hidden" id="activityState" name="activityState" value="1"/>
    <input type="hidden" id="seatIds" name="seatIds" value=""/>
    <input type="hidden" id="validCount" name="validCount" value=""/>
    <input type="hidden" id="seatInfo" name="seatInfo" value=""/>
    <input type="hidden" id="activityArea" name="activityArea" value=""/>
    <input type="hidden" id="sessionId" value="${pageContext.session.id}"/>
    <input type="hidden" name="eventStartTimes" value="" id="eventStartTimes" />
    <input type="hidden" name="eventEndTimes" value="" id="eventEndTimes" />
    <input type="hidden" id="createActivityCode" name="createActivityCode">

    <input type="hidden" id="isCutImg" value="N"/>
    <div class="site">
        <em>您现在所在的位置：</em>活动管理 &gt; 发布活动
    </div>
    <div class="site-title">活动发布</div>
    <input type="hidden" value="${sessionScope.user.userIsManger}" id="userIsManager"/>
    <div class="main-publish">
        <table width="100%" class="form-table">
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动名称：</td>
                <td class="td-input" id="activityNameLabel"><input type="text" id="activityName" name="activityName" class="input-text w510" maxlength="20"/></td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>上传封面：</td>
                <td class="td-upload" id="activityIconUrlLabel">
                    <table>
                        <tr>
                            <td>
                                <input type="hidden"  name="activityIconUrl" id="activityIconUrl" value="">
                                <input type="hidden" name="uploadType" value="Img" id="uploadType"/>

                                <div class="img-box">
                                    <div  id="imgHeadPrev" class="img"> </div>
                                </div>
                                <div class="controls-box">
                                    <div class="dot" style="margin-bottom:10px; height: 20px;line-height:20px;"><img src="/STATIC/html/images/ask.png"  alt="" style="vertical-align:middle;padding-bottom:3px;margin-right:5px;"/><a style="color:red;font-size: 12px;display:none;" href="${path}/help.do?link=" target="_blank">封面图上传失败怎么办？</a></div>
                                    <div style="height: 46px;">
                                        <div class="controls" style="float:left;">
                                            <input type="file" name="file" id="file">
                                        </div>
                                        <%--<input type="button" class="upload-cut-btn" id="" value="裁剪图片"/>--%>
                                        <span class="upload-tip">可上传1张图片，建议尺寸750*500像素，格式为jpg,jpeg,png,gif，大小不超过2M</span>
                                    </div>
                                    <div id="fileContainer"></div>
                                    <div id="btnContainer" style="display: none;">
                                        <a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>发布者：</td>
	              <td class="td-select" id="venueIdLabel">
	                  <input type="text" style="position: absolute; left: -9999px;" id="venueId" name="venueId"/>
	                  <c:if test="${sessionScope.user.userIsManger<=2}" >
	                  	<select id="create_activity_code" style="width:142px; margin-right: 8px"></select>
	                  	<script>
					    	$('#create_activity_code').append('<option value=2>上海市</option>');
					    	$('#create_activity_code').append('<option value=1>市级自建活动</option>');
							$('#create_activity_code').select2();
							$('#create_activity_code').change(function() {
								if($(this).val()==2){
									$("#loc_s").css("display", 'block');
									$("#createActivityCode").val("2");
                                    $("#onlineSelect").show();
								}else if($(this).val()==1){
									$("#loc_s").css("display", 'none');
									$('#loc_area').empty();
									$('#loc_area').append('<option value="">所有区县</option>');
                                    $("#onlineSelect").hide();
									loadingVenueData('loc_area');
									$('#loc_category').empty();
									$('#loc_category').append('<option value="">场馆类型</option>');
									$('#loc_category').select2("val", "");
									$('#loc_venue').empty();
									$('#loc_venue').append('<option value="">所有场馆</option>');
									$('#loc_venue').select2("val", "");
						            $("#activityArea").val("");
									$('#venueId').val("");
									$("#createActivityCode").val("1");
									dictLocation($("#loc_area").find("option:selected").val());		//位置重置
									$("#activityLocation").val("0");
								}
							})
						</script>
	                  </c:if>
	                  <div id="loc_s">
		                  <select id="loc_area" style="width:142px; margin-right: 8px"></select>
		                  <select id="loc_category" style="width:142px; margin-right: 8px"></select>
		                  <div id="loc_q">
		                  	<select id="loc_venue"  style="width:142px; margin-right: 8px"></select>
		                  </div>
	                  </div>
                      <script type="text/javascript">
                          $(function(){
                              //场馆
                              if($("#userIsManager").val() == 4){
                                  $.ajax({
                                      type:"get",
                                      url:"${path}/venue/getActivityArea.do",
                                      dataType: "json",
                                      cache:false,//缓存不存在此页面
                                      async: false,//异步请求
                                      success: function (result1) {
                                          var json1 = eval(result1);
                                          var data1 = json1.data;
                                          if (data1) {
                                              $("#loc_area").append('<option value="' + data1[0].id + '">' + data1[0].text + '</option>');

                                              $.ajax({
                                                  type:"get",
                                                  url:"${path}/venue/getVenueType.do?areaId="+data1[0].id,
                                                  dataType: "json",
                                                  cache:false,//缓存不存在此页面
                                                  async: false,//异步请求
                                                  success: function (result2) {
                                                      var json2 = eval(result2);
                                                      var data2 = json2.data;
                                                      if (data2) {
                                                          $("#loc_category").append('<option value="' + data2[0].id + '">' + data2[0].text + '</option>');

                                                          $.ajax({
                                                              type:"get",
                                                              url:"${path}/venue/getVenueName.do?areaId="+data1[0].id+"&venueType="+data2[0].id,
                                                              dataType: "json",
                                                              cache:false,//缓存不存在此页面
                                                              async: false,//异步请求
                                                              success: function (result3) {
                                                                  var json3 = eval(result3);
                                                                  var data3 = json3.data;
                                                                  if (data3) {
                                                                      $("#loc_venue").append('<option value="' + data3[0].id + '">' + data3[0].text + '</option>');
                                                                  }
                                                              }
                                                          });
                                                      }
                                                  }
                                              });

                                              dictLocation(data1[0].id);
                                          }
                                          $("#loc_area").select2();
                                          $("#loc_category").select2();
                                          $("#loc_venue").select2();
                                      }
                                  });
                              }else{
                                  showVenueData();
                              }
                          });
                          if($("#userIsManager").val() == 4){
                              $("#loc_area").prop("disabled", true);
                              $("#loc_category").prop("disabled", true);
                              $("#loc_venue").prop("disabled", true);
                          }
                      </script>
	              </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>位置：</td>
                <td class="td-tag">
                        <input id="activityLocation" name="activityLocation" style="position: absolute; left: -9999px;" type="hidden"/>
                        <dd id="activityLocationLabel">
                        </dd>

                    </dl>
                </td>
                <td>
                    <div style="margin-left:-223px;"  class="dot"><img src="/STATIC/html/images/ask.png" alt="" style="vertical-align:middle;padding-bottom:3px;margin-right:5px;"/><a style="color:red;font-size: 12px;display:none;" href="${path}/help.do?link=fail2" target="_blank">没有对应的热区位置怎么办？</a></div>

                </td>


            </tr>

            <tr>
                <td width="100" class="td-title">主办方：</td>
                <td class="td-input" id="activityHostLabel">
                    <input type="text" id="activityHost" name="activityHost" class="input-text w210" maxlength="100"/>
                    &nbsp; &nbsp;承办单位：
                    <input type="text" id="activityOrganizer" name="activityOrganizer" class="input-text w210" maxlength="100"/>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title">协办单位：</td>
                <td class="td-input" id="activityCoorganizerLabel">
                    <input type="text" id="activityCoorganizer" name="activityCoorganizer" class="input-text w210" maxlength="100"/>
                &nbsp; &nbsp;演出单位：
                    <input type="text" id="activityPerformed" name="activityPerformed" class="input-text w210" maxlength="100"/>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title">主讲人：</td>
                <td class="td-input" id="activitySpeakerLabel"><input type="text" id="activitySpeaker" name="activitySpeaker" class="input-text w210" maxlength="20"/></td>
            </tr>


            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动模板：</td>
                <td class="td-input search" id="templIdLabel">

                    <div class="select-box w230" style="margin-left: 0px;">
                        <input type="hidden" value="" name="templId" id="templId"/>
                        <div class="select-text" data-value="" id="templIdDiv">基础模板</div>
                        <ul class="select-option" style="display: none"  id="templIdUl">
                        </ul>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title">友情提示：</td>
                <td class="td-input" id="activityPromptLabel"><input type="text" id="activityPrompt" name="activityPrompt" class="input-text w510" maxlength="100"/></td>
            </tr>




            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动标签：</td>
                <td class="td-tag">
                    <%--<dl>--%>
                    <%--<dt>人群</dt>--%>
                    <%--<input id="activityCrowd" name="activityCrowd" style="position: absolute; left: -9999px;" type="hidden" value=""/>--%>
                    <%--<dd id="activityCrowdLabel">--%>
                    <%--</dd>--%>
                    <%--</dl>--%>
                    <%--<dl>--%>
                    <%--<dt>心情</dt>--%>
                    <%--<input id="activityMood" name="activityMood" style="position: absolute; left: -9999px;" type="hidden" value=""/>--%>
                    <%--<dd id="activityMoodLabel">--%>
                    <%--</dd>--%>
                    <%--</dl>--%>

                        <dl>
                            <dt>类型</dt>
                            <input id="activityType" name="activityType"  style="position: absolute; left: -9999px;" type="hidden" value=""/>
                            <dd id="activityTypeLabel">
                            </dd>
                        </dl>
                        <%--<dl>--%>
                            <%--<dt>主题</dt>--%>
                            <%--<input id="activityTheme" name="activityTheme"  style="position: absolute; left: -9999px;" type="hidden" value=""/>--%>
                            <%--<dd id="activityThemeLabel">--%>
                            <%--</dd>--%>
                        <%--</dl>--%>
<%--                    <dl>
                        <dt>位置</dt>
                        <input id="activityLocation" name="activityLocation" style="position: absolute; left: -9999px;" type="hidden"/>
                        <dd id="activityLocationLabel">
                        </dd>
                    </dl>--%>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>主题：</td>
                <td class="td-input" id="activitySubjectLabel">
                    <input type="text" id="activitySubject" name="activitySubject" class="input-text w510" maxlength="7"/>
                    <span class="upload-tip" style="color:#ff0000" id="activitySubjectTipLabel">主题请在7个字以内</span>
                </td>
                <td>
                    <div style="margin-left:-860px;"  class="dot"><img src="/STATIC/html/images/ask.png" alt="" style="vertical-align:middle;padding-bottom:3px;margin-right:5px;"/><a style="color:red;font-size: 12px;display:none;" href="${path}/help.do?link=fail3" target="_blank">主题位置是什么？</a></div>


                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动日期：</td>
                <td class="td-time" id="activityStartTimeLabel">
                    <div class="start w340">
                        <span class="text">开始日期</span>
                        <input type="hidden" id="startDateHidden"/>
                        <input type="text" id="activityStartTime" name="activityStartTime" value="" readonly/>
                        <span class="week" id="startWeek"></span>
                        <i class="data-btn start-btn"></i>
                    </div>
                    <span class="txt">至</span>
                    <div class="end w340">
                        <span class="text">结束日期</span>
                        <input type="hidden" id="endDateHidden"/>
                        <input type="text" id="activityEndTime" name="activityEndTime" value="" readonly/>
                        <span class="week" id="endWeek"></span>
                        <i class="data-btn end-btn"></i>
                    </div>
                    <span class="txt des">具体描述</span>
                    </div><input type="text" maxlength="100" class="input-text w210" value="" id="activityTimeDes" name="activityTimeDes" data-val="例如：每周三上午8:00-11:30" /></td>
                    <td><div style="float:left; margin-left: -700px;"  class="dot"><img src="/STATIC/html/images/ask.png" alt="" style="vertical-align:middle;padding-bottom:3px;margin-right:5px;"/><a style="color:red;font-size: 12px;display:none;" href="${path}/help.do?link=fail4" target="_blank">为什么日期选择不成功？</a></div>
                    </td>

            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动时间：</td>
                <td class="td-input">
                    <div id="free-time-set">
                        <div id="put-ticket-list" style="width: 800px;">
                            <div class="ticket-item"  id="activityTimeLabel1">
                                <input onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"  type="text" id="startHourTime1"  name="eventStartHourTime" data-type="hour" class="input-text w64" maxlength="2" value="00"/><em>：</em>
                                <input onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"  type="text" id="startMinute1" name="eventStartMinuteTime" data-type="minute" class="input-text w64" maxlength="2" value="00"/><span class="zhi">至</span>
                                <input onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"  type="text" id="endHourTime1" name="eventEndHourTime" data-type="hour" class="input-text w64" maxlength="2" value="00"/><em>：</em>
                                <input onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"  type="text" id="endMinuteTime1" name="eventEndMinuteTime" data-type="minute" class="input-text w64" maxlength="2" value="00"/>
                                <a href="javascript:void(0)" class="timeico tianjia"></a>

                            </div>
                        </div>
                    </div>
                </td>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动地点：</td>
                <td class="td-input" id="activitySiteLabel">
                    <input type="text" id="activitySite" name="activitySite" class="input-text w510"/>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动地址：</td>
                <td class="td-input" id="activityAddressLabel">
                    <input type="text" id="activityAddress" name="activityAddress" data-val="输入详细地址" class="input-text w510"/>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>地图坐标：</td>
                <td class="td-input td-coordinate" id="LonLabel">
                    <input type="text" value="" data-val="X" id="activityLon" name="activityLon" class="input-text w120" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" readonly="readonly"/>
                    <span class="txt">X</span>
                    <input type="text" value="" data-val="Y" id="activityLat" name="activityLat" class="input-text w120" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" readonly="readonly"/>
                    <span class="txt">Y</span>
                    <input type="button" class="upload-btn" id="getMapAddressPoint" value="查询坐标"/>
                </td>
                <td>
                    <div style="float:left; margin-left: -1000px;"  class="dot"><img src="/STATIC/html/images/ask.png" alt="" style="vertical-align:middle;padding-bottom:3px;margin-right:5px;"/><a style="color:red;font-size: 12px;display:none;" href="${path}/help.do?link=fail5" target="_blank">如何添加地图坐标？</a></div>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动电话：</td>
                <td class="td-input" id="activityTelLabel">
                    <input type="text" class="input-text w210" id="activityTel" name="activityTel" value="" maxlength="50"/>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>是否收费：</td>
                <td class="td-input td-fees" id="activityPriceLabel">
                    <label><input type="radio"  checked="checked" name="activityIsFree" value="1" /> <em>免费</em></label>
                    <label><input type="radio"  name="activityIsFree" value="2" /><em>收费</em></label>
                    <div class="extra">
                        <input type="text" id="activityPrice" name="activityPrice"  maxlength="10" class="input-text w60"/>￥
                        <em></em>
                        收费说明：<input type="text" id="priceDescribe" name="priceDescribe"  maxlength="100"  class="input-text "  style="width:140px;"/>
                    </div>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>在线售票：</td>
                <td class="td-input td-fees td-online" id="activityReservationCountLabel">
                    <label><input type="radio" name="activityIsReservation" checked value="1"/><em>不可预订</em></label>
                    <label><input id="activityReservation3" type="radio" name="activityIsReservation"   value="3"/><em>自由入座</em></label>
                    <label id="onlineSelect"><input type="radio" name="activityIsReservation" value="2"/><em>在线选座</em></label>
                    <div class="extra">
                        <%--在线选座<input type="checkbox" name="activitySalesOnline"  onclick="seatSeat()" id="onlineSeat" value="Y"/>--%>
                        <input type="button" id="setSeat"  class="set-ticket" value="设置座位">
                      <span id="reservationSpan">
                          <em>每场次售票数</em>
                          <span id="notOnlineTicket" >
                              <input type="hidden" name="activityReservationCount" id="activityReservationCount"/>
                              <input type="text" id="notOnlineText" class="input-text w120" onkeyup="this.value=this.value.replace(/\D/g,'')"/>
                              <input type="hidden" id="onlineText"/>
                          </span>
                          <span id="onlineTicket" style="display:inline-block;"></span>
                          <em>张</em>
                      </span>
                            <em style="margin-top:13px;">总售票数:<span  id="totalEventCount" style="display:inline-block;"></span> 张</em>

                    </div>

                </td>
                <td>
                    <div style="float:left; margin-left: -840px;" class="dot"><img src="/STATIC/html/images/ask.png" alt="" style="vertical-align:middle;padding-bottom:3px;margin-right:5px;"/><a style="color:red;font-size: 12px; display: none;" href="${path}/help.do?link=fail6" target="_blank">如何选择售票类型？</a></div>
                </td>
            </tr>

    <tr id="ticketlabel" style="display: none;">
        <td width="130" class="td-title"><span class="red">*</span>单个账号预定设置：</td>
        <td class="td-input td-ticket" id="ticketSettingsLabel">
            <label><input type="radio"  checked="checked" name="ticketSettings" value="Y" /> <em>默认</em>
            <span>(每场最多订5张)</span>
            </label>
            <%if(activityTicketSettings){%>
            <br>
            <label><input type="radio"  name="ticketSettings" value="N" /><em>自定义</em></label>
            <br>
            <div class="extra" style="display: none">
                <input type="checkbox" id="ticketNumberCheck" name="ticketNumberCheck">
                限制<input type="text" id="ticketNumber" name="ticketNumber"  maxlength="8" class="input-text w60" onkeyup="this.value=this.value.replace(/\D/g,'')"/>次
                <em></em>
                <input type="checkbox" id="ticketCountCheck" name="ticketCountCheck">
                单次最多预订 <input type="text" id="ticketCount" name="ticketCount"  maxlength="8"  class="input-text w60"  onkeyup="this.value=this.value.replace(/\D/g,'')"/>张
            </div>
            <%}%>

        </td>
    </tr>

            <tr>
                <td width="100" class="td-title">购票须知：</td>
                <td class="td-input">
                    <div class="editor-box">
                        <textarea name="activityNotice" rows="4" class="textareaBox"  maxlength="300" style="width: 500px;resize: none"></textarea>
                    </div>
                </td>
            </tr>

            <%--<tr>--%>
                <%--<td width="100" class="td-title">视频地址：</td>--%>
                <%--<td class="td-input" id="activityVideoURLLabel">--%>
                    <%--<input type="text" id="activityVideoURL" name="activityVideoURL" data-val="" class="input-text w510"/>--%>
                <%--</td>--%>
            <%--</tr>--%>
            <tr class="">
                <td width="100" class="td-title">活动描述：</td>
                <td class="td-content">
                    <div class="editor-box">
                        <textarea name="activityMemo" id="activityMemo"></textarea>
                    </div>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-input td-upload">
                    <input type="hidden" name="uploadType" value="Attach" id="uploadType2"/>
                    <input type="hidden" name="activityAttachment" id="activityAttachment"/>

                    <div class="controls" style="float: left;">
                        <input type="button" id="file2" class="upload-btn"/>
                    </div>
                    <span class="upload-tip">附件格式支持.doc\.docx\.xls\.xlsx\.txt\.pdf，不支持压缩文件和.exe等可运行文件</span>

                    <div class="controls">
                        <div id="fileContainer2">
                        </div>
                    </div>
                    <div id="btnContainer2" style="display: none;">
                        <a style="margin-left:335px;" href="javascript:clearQueue2();" class="btn">取消</a>
                    </div>
                </td>

            </tr>


            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-btn">
                    <div class="room-order-info info2" style="position: relative;">
                            <input class="btn-save" type="button" onclick="saveActivity(1)" value="保存草稿"/>
                            <c:if test="${sessionScope.user.userIsManger<=3}" >
                                <input class="btn-publish" type="button" onclick="saveActivity(6)" value="发布信息"/>
                            </c:if>
                            <c:if test="${sessionScope.user.userIsManger == 4}" >
                                <input class="btn-publish" type="button" onclick="saveActivity(6)" value="发布信息"/>
                            </c:if>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</form>

    <script type="text/javascript">
        $("#setSeat").hide();
        $("#reservationSpan").show();
        $("#notOnlineTicket").show();
        $("#onlineTicket").hide();
        $("#onlineText").val("");
        $("#activityReservation3").parents(".td-fees").find(".extra").css("display", "inline-block");
    </script>
<script type="text/javascript">
  $(".dot").hover(function(){
      $(this).children("a").toggle();
  })
</script>
</body>
</html>