<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>活动预订--文化云</title>
    <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
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
        
        $("#ticket-btn").click(function(){
        	$.post("${path}/frontActivity/buildTicket.do", $("#successForm").serialize() , function(data) {
        		$(this).attr("disabled", false);
        		var map = eval(data);
                if (map.result=='Y') {
                	$(".ewm img").attr("src",map.codeUrl);
                	window._bd_share_config={
                        "common":{
                            "bdSnsKey":{},
                            "bdText":"",
                            "bdMini":"2",
                            "bdMiniList":false,
                            "bdPic":"",
                            "bdUrl":map.ticketUrl,
                            "bdStyle":"0",
                            "bdSize":"16"
                        },
                        "share":{}
                    };
                    with(document)0[(getElementsByTagName('head')[0]||body).appendChild(createElement('script')).src='http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion='+~(-new Date()/36e5)];
        			$(".ticket-bg").show();
                    $(".ticket-box").show();
        		}
        	});
        });
        $(".ticket-bg").click(function(){
            $(".ticket-bg").hide();
            $(".ticket-box").hide();
        })
    });
</script>
<style type="text/css">.ui-dialog-close{ display: none;}</style>
<!-- dialog end -->
</head>
<body>

<%@include file="/WEB-INF/why/index/index_top.jsp"%>
<form id="successForm">
    <input type="hidden" value="${activityOrderId}" name="activityOrderId" id="activityOrderId" />
    <input type="hidden" value="${activity.activityName}" name="activityName" />
    <input type="hidden" value="${eventDateTime}" name="eventDateTime" />
    <input type="hidden" value="${activity.activityAddress}" name="activityAddress" />
    <input type="hidden" value="${activityOrder.orderSummary}" name="orderSummary" />
    <input type="hidden" value="${seatValues}" name="seatValues" />
    <input type="hidden" value="${fn:substringAfter(activity.activityCity, ',')}" name="activityCity"/>
    <input type="hidden" value="${fn:substringAfter(activity.activityArea, ',')}" name="activityArea"/>
<div id="register-content">
    <div class="register-content">
        <div class="steps steps-activity">
            <ul class="clearfix">
                <li class="step_1 visited_pre">1.填写基本信息<i class="tab_status"></i></li>
                <li class="step_2 visited_pre">2.选择座位<i class="tab_status"></i></li>
                <li class="step_3 visited_pre">3.填写取票信息<i class="tab_status"></i></li>
                <li class="step_4 finish">4.确认订单信息<i class="tab_status"></i></li>
                <li class="step_5 end">5.完成预定</li>
            </ul>
        </div>
        <!--btn start-->
        <div class="register-part part3 clearfix">
            <div class="part3-box1">
                <div class="box1a">
                    <a class="return" href="${path}/frontActivity/frontActivityDetail.do?activityId=${activityId}">&lt;跳转到活动详情页</a>
                    <a class="orange" href="${path}/userActivity/userActivity.do">查看我的活动&gt;</a>
                </div>
                <div class="register-text">
                    <img src="${path}/STATIC/image/transparent.gif"/>
                    <span style="line-height: 36px;">恭喜您<br />${activityName}<br />已预订成功！</span>
                </div>
            </div>
            <input type="button" value="转发电子票" class="elec_ticket fr" id="ticket-btn"/>
        </div>
        <!--btn end-->
    </div>
</div>
</form>
<!-- 导入尾部文件 -->

<!-- 电子票 -->
<div class="ticket-bg"></div>
<div class="ticket-box">
    <div class="top"><img src="../STATIC/image/ticket-top.png" alt=""/></div>
    <div class="cont">
        <h3><c:out escapeXml="true" value="${activity.activityName}"/></h3>
        <p>时间：${eventDateTime}</p>
        <p>地址：<c:out escapeXml="true" value="${activity.activityAddress}"/></p>
        <c:if test="${not empty activityOrder.orderSummary}" >
	        <p>座位：<c:out escapeXml="true" value="${seatValues}"/></p>
        </c:if>
        <c:if test="${empty activityOrder.orderSummary}" >
            <p>票数：${activityOrder.orderVotes}张</p>
        </c:if>
        <div class="ewm" style="width:140px;height:140px;"><img src="" alt=""/></div>
    </div>
    <div class="share">
        <div class="bdsharebuttonbox">
            <span>分享</span>
            <a href="#" class="bds_sqq" data-cmd="sqq" title="分享到QQ好友"></a>
            <a href="#" class="bds_weixin" data-cmd="weixin" title="分享到微信"></a>
        </div>
    </div>
</div>

<%@include file="../index_foot.jsp"%>

</body>
</html>