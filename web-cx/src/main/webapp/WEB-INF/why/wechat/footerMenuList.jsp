<%@ page language="java" pageEncoding="UTF-8" %>
<!-- foot start -->
<div class="footer" style="background-color: transparent;bottom: 40px;border:none;">
    <div class="totop" onclick="$('html,body').animate({scrollTop: 0}, 1000);"><img class="menuBtnShadow" src="${path}/STATIC/wechat/image/newmenu/top.png" /></div>
    <div style="clear: both;"></div>
    <div class="newMenuBTN">
        <img class="menuBtnShadow" src="${path}/STATIC/wechat/image/newmenu/btn.png" />
    </div>
</div>
<div class="newMenuList">
    <div class="swiper-container4 swiper-container-horizontal">
        <div class="swiper-wrapper">
            <div class="swiper-slide">
                <ul>
                    <li onclick="location.href='${path}/wechat/index.do'"><img src="${path}/STATIC/wechat/image/newmenu/index.png" /></li>
                    <li onclick="location.href='${path}/wechatActivity/index.do'"><img src="${path}/STATIC/wechat/image/newmenu/act.png" /></li>
                    <li onclick="location.href='${path}/wechatVenue/toSpace.do'"><img src="${path}/STATIC/wechat/image/newmenu/kongjian.png" /></li>
                    <li onclick="location.href='${path}/wechatActivity/activitySearchIndex.do'"><img src="${path}/STATIC/wechat/image/newmenu/search.png" /></li>
                    <!--<li onclick="location.href='${path}/wechatChuanzhou/chuanzhouIndex.do'"><img src="${path}/STATIC/wechat/image/newmenu/rwhs.png" /></li>
                    <li onclick="location.href='${path}/wechatChuanzhou/chuanzhouIndex.do'"><img src="${path}/STATIC/wechat/image/newmenu/qzty.png" /></li>
                    <li onclick="location.href='${path}/wechatChuanzhou/chuanzhouIndex.do'"><img src="${path}/STATIC/wechat/image/newmenu/szyd.png" /></li>-->
                    <li onclick="location.href='${path}/wechatUser/preTerminalUser.do'"><img src="${path}/STATIC/wechat/image/newmenu/gerenzhongxin.png" /></li>

                    <%--<li onclick="location.href='${path}/wechatBpProduct/preProductList.do'"><img src="${path}/STATIC/wechat/image/newmenu/shangcheng.png" /></li>--%>
                    <%--<li onclick="location.href='${path}/wechatBpAntique/preAntiqueList.do'"><img src="${path}/STATIC/wechat/image/newmenu/wenwu.png" /></li>--%>
                    <%-- <li onclick="location.href=''"><img src="${path}/STATIC/wechat/image/newmenu/canyu.png" /></li> --%>


                    <div style="clear: both;"></div>
                </ul>
            </div>
        </div>
        <%--<div id="swiperPage" class="swiper-pagination"></div>--%>

    </div>
    <div class="newMenuCloseBTN">
        <img src="${path}/STATIC/wechat/image/newmenu/closeBTN.png" />
    </div>
</div>
<!-- foot end -->