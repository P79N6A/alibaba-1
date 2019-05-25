<%@ page language="java" pageEncoding="UTF-8" %>
<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
<%--<script type="text/javascript" src="${path}/STATIC/js/frontJs/jquery-1.11.1.js"></script>--%>
<!-- foot start -->
<script type="text/javascript" src="${path}/STATIC/js/frontBp/jquery.qrcode.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/frontBp/qrcode.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/frontBp/utf.js"></script>
<style>
    a{
        cursor: pointer;
    }
    .footLeft{
        margin-top:20px;
        float:left;
        width:550px;
        margin-left:381px;

    }
    .footright{
        float:right;
        margin-left:20px;
        /*width:650px;*/
        width:500px;
        font-size:12px;
        color:#c0c0c0;
    }
    .footEwm{
        float:left;
        margin-left:30px;
        width:100px;
        height:170px;
    }
    .footEwm img{
        width:100px;
        height:100px;
    }
    .footEwm p{
        text-align: center;
        height:20px;
        font-size:13px;
        line-height: 20px;
    }
    .footShare{
        width:120px;
        height:20px;
        line-height: 20px;
        text-align: center;

    }
    .footShare a{
        font-size:12px;
        color:#c0c0c0;
    }
    .wb{
        background-image: url("/STATIC/image/wb.png") !important;
        background-position: 0 0 !important;
         margin:0px !important;
         padding-left: 35px !important;
         height: 20px !important;
         line-height: 20px !important;
        }
        .wx{
            background-image: url("/STATIC/image/wx.png")!important;
            background-position: 0 0 !important;
            margin:0px !important;
            padding-left: 35px !important;
            height: 20px !important;
            line-height: 20px !important;
        }
        .bdshare-button-style0-16 a, .bdshare-button-style0-16 .bds_more{
            /*background-image: url('/STATIC/image/wx.png');*/

    }
</style>
<div class="footer">
    <div class="footLeft">
        <div class="footWen">版权所有：安康市文化和旅游广电局 &nbsp&nbsp&nbsp地址：安康市江北大道 &nbsp&nbsp&nbsp邮编：725000</div>
        <div class="footWen">电话：0915-3358100&nbsp&nbsp&nbsp邮箱：ankangguangdian@163.com</div>
        <div class="footWen">备案编号：陕ICP备19009470号&nbsp&nbsp&nbsp<%--网站标识码XXXXXXXXXXXX&nbsp&nbsp&nbsp陕公安网备XXXXXXXXXXXX号--%></div>
        <div class="footWen" style="background: url('/STATIC/image/wb.png') no-repeat left; padding-left:30px;">
            官方新浪微博：<a target="_blank" style="color: #666666;" href="https://weibo.com/u/3229805392">https://weibo.com/u/3229805392</a>
        </div>
    </div>
    <div class="footright">
        <div class="footEwm">
            <div id="qrcodeCanvas"></div>
            <p>安康文化云</p>
            <div class="bdsharebuttonbox" data-tag="share_1">
                <a href="javascript:void(0)" class="bds_tsina wb" data-cmd="tsina">
                </a>分享到微博
            </div>
        </div>
        <div class="footEwm">
            <div id="qrcodeMobile"></div>
            <p>移动端</p>
            <div class="bdsharebuttonbox" data-tag="share_1">
                <a href="javascript:void(0)" class="bds_weixin wx" data-cmd="weixin">
                </a>分享到微信
            </div>
            <%--<a href="#" class="bds_weixin" data-cmd="weixin">分享到微信</a>--%>
            <script>
                window._bd_share_config = {
                    common:{
                        "bdSnsKey":{},
                        "bdText":"",
                        "bdMini":"2",
                        "bdMiniList":false,
                        "bdPic":"",
                        "bdStyle":"0",
                        "bdSize":"16"
                    },
                    share : {
                        "bdSize":"18",
                        "bdCustomStyle":""
                    },
                }
                /*window._bd_share_config={
                    "common":{
                        "bdSnsKey":{},
                        "bdText":"",
                        "bdMini":"2",
                        "bdMiniList":['qzone','tsina','sqq','weixin'],
                        "bdPic":"",
                        "bdStyle":"0"
                        ,"bdSize":"16"
                    },
                    "share":{
                        "bdSize":"18"
                    },
                    "image":{
                        "viewList":["qzone","tsina","tqq","renren","weixin"],
                        "viewText":"分享到：",
                        "viewSize":"16"
                    },
                    "selectShare":{
                        "bdContainerClass":null,
                        "bdSelectMiniList":["qzone","tsina","tqq","renren","weixin"]
                    }
                };*/
                with (document) 0[(getElementsByTagName('head')[0] || body).appendChild(createElement('script')).src = 'http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion=' + ~(-new Date() / 36e5)];
            </script>
        </div>
        <div style="clear:both"></div>
    </div>
    <div style="clear:both"></div>

</div>
<script>
    //pc二维码
    jQuery('#qrcodeCanvas').qrcode({
        render    : "canvas",
        text    : "https://weibo.com/u/3229805392",
        width : "110",               //二维码的宽度
        height : "110",              //二维码的高度
        background : "#ffffff",       //二维码的后景色
        foreground : "#000000",        //二维码的前景色
        src: '${path}/STATIC/image/footTest.png'             //二维码中间的图片
    });
    //微信二维码
    jQuery('#qrcodeMobile').qrcode({
        render    : "canvas",
        text    : "http://t-akwhy.venlvcloud.com/wechat/index.do",
        width : "110",               //二维码的宽度
        height : "110",              //二维码的高度
        background : "#ffffff",       //二维码的后景色
        foreground : "#000000",        //二维码的前景色
        src: '${path}/STATIC/image/footTest.png'             //二维码中间的图片
    });
    function outLogin(){var a="${sessionScope.terminalUser}";if(a){$.post("${path}/frontTerminalUser/outLogin.do?asm="+new Date().getTime(),function(b){window.location.reload(true)})}else{window.location.reload(true)}};
function feedBack(){
  if('${sessionScope.terminalUser}' == null || '${sessionScope.terminalUser}' == ""){
    dialogAlert("提示","登录之后才能反馈！");
    return;
  }else{
	  window.location.href="${path}/frontIndex/feedBack.do";
  }
}
</script>

<!-- foot end -->	