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
    });
</script>
<style type="text/css">.ui-dialog-close{ display: none;}</style>
<!-- dialog end -->
</head>
<body>

<%@include file="../list_top.jsp"%>

<div id="register-content">
    <div class="register-content">
        <div class="steps steps-room">
            <ul class="clearfix">
                <li class="step_1 visited_pre">1.填写票务信息<i class="tab_status"></i></li>
                <li class="step_2 visited_pre">2.填写取票信息<i class="tab_status"></i></li>
                <%--<li class="step_3 visited_pre">3.填写取票手机<i class="tab_status"></i></li>--%>
                <li class="step_3 visited_pre">3.确认订单信息<i class="tab_status"></i></li>
                <li class="step_4 active">4.完成预订</li>
            </ul>
        </div>
        <div class="register-part part3">
            <div class="part3-box1">
                <div class="register-text">
                    <i></i>
                    <p>恭喜您，活动: ${activityName}  &nbsp; 已成功预订！</p>
                    <p class="f12"><a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activityId}">< 返回活动页</a><a class="lightred" href="${path}/userActivity/userActivity.do">查看我的活动</a></p>
                </div>
            </div>
            <div class="part3-box2">
                <div class="bdsharebuttonbox">
                    <span>分享：</span>
                    <a href="#" class="bds_qzone" data-cmd="qzone" title="分享到QQ空间"></a>
                    <a href="#" class="bds_tsina" data-cmd="tsina" title="分享到新浪微博"></a>
                    <a href="#" class="bds_tqq" data-cmd="tqq" title="分享到腾讯微博"></a>
                    <a href="#" class="bds_renren" data-cmd="renren" title="分享到人人网"></a>
                    <a href="#" class="bds_weixin" data-cmd="weixin" title="分享到微信"></a>
                    <a href="#" class="bds_more" data-cmd="more"></a>
                </div>
                <script>
                    window._bd_share_config={
                        "common":{
                            "bdSnsKey":{},
                            "bdText":"",
                            "bdMini":"2",
                            "bdMiniList":false,
                            "bdPic":"",
                            "bdStyle":"0",
                            "bdSize":"16"
                        },
                        "share":{}
                    };
                    with(document)0[(getElementsByTagName('head')[0]||body).appendChild(createElement('script')).src='http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion='+~(-new Date()/36e5)];
                </script>
            </div>
        </div>
    </div>
</div>
<!-- 导入尾部文件 -->
<%@include file="../index_foot.jsp"%>


</body>
</html>