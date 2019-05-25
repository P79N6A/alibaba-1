<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>活动预订--文化云</title>
    <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css">
    <script type="text/javascript" src="${path}/STATIC/js/jquery.countdown.js"></script>
<style type="text/css">
.actOrderBaoInfo-ok {
    padding-top: 20px;
}
.actOrderBaoInfo-ok .aobItem {
	padding-bottom: 20px;
}
.actOrderBaoInfo-ok .wenti {
	font-size: 16px;
	color: #666;
	line-height: 1.5;
	margin-bottom: 6px;
	font-weight: bold;
}
.actOrderBaoInfo-ok .daan {
	font-size: 14px;
	color: #666;
	line-height: 1.5;
}
</style>
    <script type="text/javascript" >
        function doSubmit(){
        	//console.log($("#orderCustomInfo").val());
            $.post("${path}/wechatActivity/wcActivityOrder.do", $("#bookOrder").serialize()+'&'+$.param({orderCustomInfo:$("#orderCustomInfo").val()}) , function(data) {
            	var result=eval(data);
            	if (result.status == "1") {
            		if (result.data.length==10) {
            			var orderValidateCode = result.data;
                        location.href="${path}/frontActivity/saveActivityOderOver.do?activityId=${activity.activityId}&orderValidateCode=" + orderValidateCode + "&seatValues=" + encodeURI(encodeURI('<c:out escapeXml="true" value="${seatValues}"/>')) +"&eventDateTime=${activityOrder.eventDateTime}";
            		}
                } 
            	else if(result.status == "0") {
            		
            		if(result.msg.errmsg)
                   		 dialogAlert("提示", result.msg.errmsg);
            		else
            			 dialogAlert("提示", "下单失败，连接超时！");
                }else if (result.status == 500) {
                    window.location.href = "../../../../timeOut.html";
                }else if(result.status == 300){
                	 dialogAlert("提示", "预订失败，超出预订截止时间！");
                } 
            	
            }, "json");
        }
        $(function() {
            //判断用户是否已经提交订单  子系统和文化云规则一样 需要暂时去掉
/*            if ($("#orderNumber").val() != undefined && $("#orderNumber").val() != '') {
                var formData = {orderNumber:$("#orderNumber").val()};
                $.post("${path}/frontActivity/queryOrderNumber.do", formData , function(data) {
                    if (data > 0) {
                        location.href="${path}/frontActivity/saveActivityOderOver.do?activityId=${activity.activityId}&activityName=" + encodeURI(encodeURI('<c:out escapeXml="true" value="${activity.activityName}"/>'));
                    }
                });
            }*/

            $(".confirm_order").on("click", function(){
                var html = '<div class="btn-loading" id="btn-tip-loading"><h3>正在提交，请稍等...</h3><div class="img"></div></div>';
                $(this).parent().append(html);
                return false;
            });

            //
        });

        //get Img
        $(function() {
            var imgUrl = $("#iconUrl").attr("iconUrl");
            imgUrl= getImgUrl(imgUrl);
            $("#iconUrl").attr("src", imgUrl);
        });
    </script>
    <script type="text/javascript">
        $(function() {
            function nol(h){
                return h>9?h:'0'+h;
            }
            /* "2015/06/25 14:36:40" 为订单时间 */
            var startTime = (new Date("2015/06/25 14:50:40")).getTime();
            var nowTime = new Date().getTime();
            var time = 899 - parseInt((nowTime - startTime)/1000);
            var timeStr = "";
            if(time > 0) {
                var secday = 86400, sechour = 3600,
                    min = parseInt(((time % secday) % sechour) / 60),
                    sec = ((time % secday) % sechour) % 60;
                timeStr = nol(min) + ':' + nol(sec);
                $('#clock').countdown({
                    image: 'image/digit-lg.png',
                    startTime: timeStr,
                    format: 'mm:ss',
                    timerEnd: function () {
                        $(".btn-pay").attr("data-endtime", "true");   /*倒计时结束*/
                    }
                });
            }else{
                $(".btn-pay").attr("data-endtime", "true");   /*倒计时结束*/
                $('#clock').html('<img src="image/end-clock.jpg"/>');
            }

            $(".btn-to-pay").on("click", function(){
                if($(".btn-pay").attr("data-endtime") == "true"){   /*倒计时结束*/
                    dialogAlert("支付提示", "支付超时，您所选的座位已被释放，请重新选择！", function(){
                        window.location.href = "Activity-book.html";
                    });
                }else{
                    $(".layer-bg").show();
                    $(".layer-box").show();
                    window.open("Activity.html");
                }
            });
        });
    </script>
<style type="text/css">.ui-dialog-close{ display: none;}</style>
<!-- dialog end -->
</head>
<body>
<!-- 导入头部文件 -->
<div class="header">
	<%@include file="../header.jsp" %>
</div>
<form action="" name="bookOrder" id="bookOrder" method="post" >

   <input type="hidden" name="activityId" id="activityId" value="${activity.activityId}"/>
   <input type="hidden" name="userId" id="userId" value="${sessionScope.terminalUser.userId}"/>
   <input type="hidden" id="activityEventIds" name="activityEventIds" value="${activityOrder.eventId}" />
   <input type="hidden" name="bookCount" id="bookCount" value="${bookCount }"/>
   <input type="hidden" name="orderMobileNum" id="orderPhoneNo" value="${activityOrder.orderPhoneNo}"/>
	<input type="hidden" name="orderPrice" id="orderPrice" value="0"/>
    <input type="hidden" name="seatIds" id="seatIds" value="${seatIds}"/>
    <input type="hidden" name="seatValues" id="seatValues" value="${saveSeatValues}" />
    <input type="hidden" name="orderName" id="orderName" value="${sessionScope.terminalUser.userName}"/>
    <input type="hidden" id="activityEventimes" name="activityEventimes" value="${activityOrder.eventDateTime}"/>
    <input type="hidden" id="costTotalCredit" name="costTotalCredit" value="${activityOrder.costTotalCredit}"/>
    <input type="hidden" id="orderCustomInfo" value='${activityOrder.orderCustomInfo}'/>

<div id="register-content">
    <div class="register-content">
        <div class="steps steps-activity">
            <ul class="clearfix">
                <li class="step_1 visited_pre">1.填写基本信息<i class="tab_status"></i></li>
                <li class="step_2 visited_pre">2.选择座位<i class="tab_status"></i></li>
                <li class="step_3 visited_pre">3.填写取票信息<i class="tab_status"></i></li>
                <li class="step_4 active">4.确认订单信息<i class="tab_status"></i></li>
                <li class="step_5">5.完成预定</li>
            </ul>
        </div>
            <div class="room-part3">
                <h1>确认订单信息</h1>
                <div class="room-order-info activity-order-info">
                    <%--<div class="info-l fl">--%>
                            <div class="img fl"><img id="iconUrl" iconUrl="${activity.activityIconUrl}" src="" alt="" width="300" height="200"/></div>
                            <div class="details fr">
                                <p><span>订单号：</span> ${activityOrder.orderNumber}</p>
                                <p><span>活动：</span> <c:out escapeXml="true" value="${activity.activityName}"/></p>
                                <p><span>时间：</span> ${activityOrder.eventDateTime}</p>
                                <p><span>地址：</span> <%--${fn:split(activity.activityCity, ',')[1]}&nbsp;<c:if test="${fn:split(activity.activityArea, ',')[1] != fn:split(activity.activityCity, ',')[1]}">${fn:split(activity.activityArea, ',')[1]}&nbsp;</c:if>--%><c:out escapeXml="true" value="${activity.activityAddress}"/></p>
                                <c:if test="${not empty activityOrder.orderSummary}" >
                                    <p><span>座位：</span>
                                            ${seatValues}
                                          <%--  <c:set value="${ fn:split(activityOrder.orderSummary, ',') }" var="str1" />
                                            <c:forEach items="${str1}" var="s">
                                                ${fn:split(s,'_')[0]}排${fn:split(s,'_')[1]}座 &nbsp;&nbsp;
                                            </c:forEach>--%>
                                         <%--${activityOrder.orderSummary}--%>
                                    </p>
                                </c:if>
                                <c:if test="${empty activityOrder.orderSummary}" >
                                    <p><span>订票数：</span>
                                            ${activityOrder.orderVotes}
                                    </p>
                                </c:if>
                                <%--<p><span>总价：</span><b class="lightred">¥${activityOrder.orderPrice}</b></p>--%>
                                <p><span>手机：</span><b>${activityOrder.orderPhoneNo}</b></p>
                                <c:if test="${not empty customInfojson}">
	                            <div class="actOrderBaoInfo-ok">
	                            	<c:forEach items="${customInfojson}" var="customInfovar" varStatus="customInfovarStatus">
									<div class="aobItem">
										<div class="wenti">${customInfovar.title}</div>
										<div class="daan">
											${customInfovar.value}
										</div>
									</div>
									</c:forEach>
								</div>
								</c:if>
                            </div>
                            
                            

                  <%--  </div>--%>
                    <%--<div class="info-r fl">--%>
                        <%--<h4>剩余支付时间</h4>--%>
                        <%--<div class="clock" id="clock"></div>--%>
                        <%--<p>请在15分钟内完成付款<br/>超时系统将自动释放已选座位</p>--%>
                    <%--</div>--%>
                </div>
                <c:choose>
                <c:when test="${list[0].ORDER_PRICE > 0}">
                <h1>支付方式</h1>
                <div class="room-order-info">
                    <div class="pay-method alipay">
                        <label for="alipay"><span class="tit"></span></label>
                        <input type="radio" name="payMethod" id="alipay"/>
                    </div>
                    <div class="pay-method weixin">
                        <label for="weixin"><span class="tit"></span></label>
                        <input type="radio" name="payMethod" id="weixin"/>
                    </div>
                    </c:when>
                    <c:otherwise>
                    </c:otherwise>
                    </c:choose>

                    <script type="text/javascript">
                        function updateActivityBookInfo() {
                            location.href = "${path}/frontActivity/updateActivityBookInfo.do?eventDateTime=${activityOrder.eventDateTime}&activityId=" + '${activity.activityId}' + "&selectSeatInfo=" + '${activityOrder.orderSummary}' + "&bookCount=" + '${activityOrder.orderVotes}' + "&orderPhoneNo=" +'${activityOrder.orderPhoneNo}'+ "&orderCustomInfo=" +'${activityOrder.orderCustomInfo}';
                        }

                    </script>
                        <div class="room-order-info info2" style="position: relative;">
                            <a class="go-back" href="javascript:updateActivityBookInfo();">&lt;返回修改信息</a>
                            <div class="confirm_box">
                                <input class="confirm_order" type="button" onclick="doSubmit();" value="确认"/>
                            </div>
                        </div>
                    <%--<div class="to-pay">--%>
                        <%--<a class="go-back" href="javascript:window.history.go(-1);">返回修改信息</a>--%>
                        <%--<div class="fr"><span class="total">应付：${activityOrder.orderPrice}</span>--%>
                            <%--&lt;%&ndash;<c:choose>&ndash;%&gt;--%>
                                <%--&lt;%&ndash;<c:when test="${activityOrder.orderPrice <= 0}">&ndash;%&gt;--%>
                                    <%--&lt;%&ndash;<a href="javascript:doSubmit();" class="btn-submit-order" data-endtime="false">确定</a>&ndash;%&gt;--%>
                            <%--<input class="btn-submit-order" type="button" onclick="doSubmit();" value="确认"/>--%>
                                <%--&lt;%&ndash;</c:when>&ndash;%&gt;--%>
                                <%--&lt;%&ndash;<c:otherwise>&ndash;%&gt;--%>
                                    <%--&lt;%&ndash;<a href="javascript:;" class="" data-endtime="false">去支付</a>&ndash;%&gt;--%>
                                <%--&lt;%&ndash;</c:otherwise>&ndash;%&gt;--%>
                            <%--&lt;%&ndash;</c:choose>&ndash;%&gt;--%>
                        <%--</div>--%>
                    <%--</div>--%>
                </div>

    </div>
</div>
</form>
<!-- 导入尾部文件 -->
<%@include file="/WEB-INF/why/index/footer.jsp" %>
<!-- 网上支付提示信息 开始 -->


<!-- 网上支付提示 结束 -->

</body>
</html>