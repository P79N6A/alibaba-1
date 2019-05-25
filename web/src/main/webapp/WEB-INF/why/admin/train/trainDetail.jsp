<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<head>
    <%--<meta charset="utf-8"/>--%>
    <title>文化培训</title>
    <%@include file="/WEB-INF/why/common/frontPageFrame.jsp" %>
    <link type="text/css" rel="stylesheet" href="${path}/STATIC/css/normalize.css" />
    <link rel="stylesheet" href="${path}/STATIC/css/owl.carousel.min.css">
    <link rel="stylesheet" href="${path}/STATIC/css/owl.theme.default.min.css">
    <link rel="stylesheet" href="${path}/STATIC/layui/css/layui.css" media="all">
    <link type="text/css" rel="stylesheet" href="${path}/STATIC/css/zjStyleChild.css" />
    <script type="text/javascript" src="${path}/STATIC/layui/layui.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/owl.carousel.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/index/activity/activityDetail2.js?version=20160603"></script>
    <script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ckplayer/ckplayer.js"></script>
    <style type="text/css">
        .layui-laydate tr td.layui-this {
            background-color: #2c8ae3!important;
            color: #fff!important;
        }
        .peixunCourse{
            position: relative;
        }
        .peixunShare .shares {
            position: absolute;
            right: 0;
            top:4px;
            display: block;
            overflow: hidden;
        }
        .peixunCourse .share_l .zan.love {
            background: url(${path}/STATIC/image/ca_shoucongs.png) no-repeat;
        }
        .peixunCourse .share_l .zan, .peixunCourse .share_l .like, .peixunCourse .share_l .view {
            background: url(${path}/STATIC/image/cq_shoucang.png) no-repeat 0px 0px;
            padding-left: 40px;
            padding-right: 10px;
            height: 32px;
            line-height: 32px;
            display: inline-block;
            width: auto;
            font-size: 14px;
            color: #4a4a4a;
        }
        .share_r.fr{
            line-height: 50px;
        }
        .peixunShare .share_l .zan, .peixunShare .share_l .like, .peixunShare .share_l .view {
            background: url(${path}/STATIC/image/cq_shoucang.png) no-repeat 0px 0px;
            padding-left: 40px;
            padding-right: 10px;
            height: 32px;
            line-height: 32px;
            display: inline-block;
            width: auto;
            font-size: 14px;
            color: #4a4a4a;
        }
        .peixunShare .share_l .share {
            background: url(${path}/STATIC/image/share_icon.png) no-repeat 0px 0px;
            width: 32px;
            height: 32px;
            line-height: 2px;
            cursor: pointer;
            margin: 0px 0px 0px 13px;
            position: inherit;
            margin: 6px;
        }
        .peixunShare .share_r a img {
            vertical-align: middle;
            padding-bottom: 3px;
             padding-right: 10px;
        }
        .peixunIntro{
            margin-bottom:0px!important;
        }
        .the_two{
            margin-bottom:20px;
        }
        .form_enroll{
            margin: 0!important;
        }
        .form_enroll .bmItem {
            margin: 16px 20px 0 50px;
        }
        .send-code{
            border: none;
            width: 103px;
            height: 32px;
            background: #b03a3e;
            margin-left: 10px;
            border-radius: 4px;
            color: #fff;
        }
    </style>
</head>
<body>
<div class="alertTime" id="alertTime" style="display:none;width: 100%;height: 100%;position: fixed;top: 0;left: 0;z-index: 30;">
        <div class="alertTimeContent" style="display:none;width: 380px;height: 245px;background-color: #fff;position: absolute;top: 60%;left: 35%;margin-top: -122px;margin-left: -190px;">
            <div class="title">温馨提示<img class="imgClose clearfix" src="${path}/STATIC/image/alertClose.png" alt="" srcset=""></div>
            <div class="msg">您所报名的课程之间有“培训时间”冲突， 建议您报名其他课程。</div>
            <div class="know">我知道了</div>
        </div>
    </div>
    <div class="alertEnough" id="alertEnough" style="display:none;width: 100%;height: 100%;position: fixed;top: 0;left: 0;z-index: 30;">
        <div class="alertEnoughContent" style="width: 380px;height: 245px;background-color: #fff;position: absolute;top: 60%;left: 35%;margin-top: -122px;margin-left: -190px;">
            <div class="title">温馨提示<img class="imgClose clearfix" src="${path}/STATIC/image/alertClose.png" alt="" srcset=""></div>
            <div class="msg">当前报名时间内可报名活动次数已达上限， 建议您报名其他课程～</div>
            <div class="know">我知道了</div>
        </div>
    </div>
    <div class="alertSuccess" id="alertSuccess" style="display:none;width: 100%;height: 100%;position: fixed;top: 0;left: 0;z-index: 30;">
        <div class="alertSuccessContent" style="width: 380px;height: 290px;background-color: #fff;position: absolute;top: 60%;left: 35%;margin-top: -122px;margin-left: -190px;">
            <div class="title">温馨提示<img class="imgClose clearfix" src="${path}/STATIC/image/alertClose.png" alt="" srcset=""></div>
            <div style="width:42px;height:42px;margin:0 auto;margin-top: 30px"><img src="${path}/STATIC/image/success.png" alt="" srcset=""></div>
            <div class="msg" style="margin:20px 118px 30px 118px;">您的培训报名成功！ 请留意培训时间！</div>
            <div class="know" onclick="reload();">我知道了</div>
    </div>
    </div>
    <div class="alertSuccess" id="alertSuccess2" style="display:none;width: 100%;height: 100%;position: fixed;top: 0;left: 0;z-index: 30;">
        <div class="alertSuccessContent" style="width: 380px;height: 290px;background-color: #fff;position: absolute;top: 60%;left: 35%;margin-top: -122px;margin-left: -190px;">
            <div class="title">温馨提示<img class="imgClose clearfix" src="${path}/STATIC/image/alertClose.png" alt="" srcset=""></div>
            <div style="width:42px;height:42px;margin:0 auto;margin-top: 30px"><img src="${path}/STATIC/image/success.png" alt="" srcset=""></div>
            <div class="msg" style="margin:20px 118px 30px 118px;">您的报名信息提交成功！ 请等待审核！</div>
            <div class="know" onclick="reload();">我知道了</div>
        </div>
    </div>
<!-- start 头部  -->
<div class="alertEnrollContent" id="alertEnrollContent" style="display:none;z-index:111;width: 510px;height: 655px;background-color: #fff;position: absolute;top: 80%;left: 40%;margin-top: -325px;margin-left: -255px;">
    <form id="orderForm">
        <div class="title">报名申请<img class="imgClose clearfix" src="${path}/STATIC/image/alertClose.png" alt="" srcset=""></div>
        <div class="form_enroll">
            <input type="hidden" name="createUser" value="${sessionScope.terminalUser.userId}"/>
            <input type="hidden" name="trainId" value="${train.id}"/>
            <div class="bmItem clearfix">
                <div class="lab">姓&emsp;&emsp;&emsp;名</div>
                <input name="name" id="name" class="txt" type="text" placeholder="" />
            </div>
            <input type="hidden" name="sex" id="sex"/>
            <input type="hidden" name="birthday" id="birthday"/>
            <%--<div class="bmItem clearfix">
                <div class="lab">性&emsp;&emsp;&emsp;别</div>
                <div class="txt clearfix" style="padding: 0;background: none;border:0">
                    <input type="radio" name="sex" id="male" value="1" <c:if test="${empty order.sex}">checked</c:if> <c:if test="${order.sex == 1}">checked</c:if>/><label for="male"  style="margin-right:18px;" class="radioBox">男</label>
                    <input type="radio" name="sex" id="female" value="2" <c:if test="${order.sex == 2}">checked</c:if>/><label for="female" class="radioBox">女</label>
                </div>
            </div>
            <div class="bmItem clearfix">
                <div class="lab">出生年月</div>
                <div class="txt">
                    <input type="text" name="birthday" id="birthday" placeholder="请选择出生年月日">
                    <img class="chooseBirth" src="${path}/STATIC/image/chooseCal.png" alt="">
                </div>
            </div>--%>
            <div class="bmItem clearfix">
                <div class="lab" >身&nbsp;份&nbsp;证&nbsp;号</div>
                <input name="idCard" id="idCard" class="txt" type="text" placeholder="" />
            </div>
            <div class="bmItem clearfix">
                <div class="lab">联&nbsp;系&nbsp;电&nbsp;话</div>
                <input class="txt" type="text" placeholder="" name="phoneNum" id="phoneNum" />
            </div>
            <div class="bmItem clearfix">
                <div class="lab">验证码</div>
                <dd class="showPlaceholder">
                    <input type="text" class="txt" value="" name="code" id="code" maxlength="6"
                           onkeyup="if(this.value!=this.value.replace(/\D/g,'')) this.value=this.value.replace(/\D/g,'')"
                           onafterpaste="this.value=this.value.replace(/\D/g,'')"
                           onblur="this.value=this.value.replace(/\D/g,'')"
                           onfocus="this.value=this.value.replace(/\D/g,'')"
                           ms-duplex="code"  data-duplex-changed="codeChange"  />
                    <input type="button" class="send-code" id="sendCode" onclick="sendSmsCode()" value="获取验证码"/>
                    <span id="codeErr"></span>
                </dd>
            </div>
            <div class="bmItem clearfix">
                <div class="lab">备&nbsp;注&nbsp;</div>
                <textarea class="txt"  placeholder="不能超过100个字" rows="5" cols="20" maxlength="100" name="trainRemark" id="trainRemark" style="margin: 0px; width: 330px; height: 179px;"></textarea>
            </div>
        </div>
    </form>
    <div class="sub" onclick="goRegist();">提交</div>

</div>
<div class="header">
    <!-- 导入头部文件 -->
    <%@include file="/WEB-INF/why/index/header.jsp" %>
</div>
<%
    String userMobileNo = "";
    if (session.getAttribute("terminalUser") != null) {
        CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
        if (StringUtils.isNotBlank(terminalUser.getUserMobileNo())) {
            userMobileNo = terminalUser.getUserMobileNo();
        } else {
            userMobileNo = "0000000";
        }
    }
%>
<div class="zjCenter clearfix">
    <input type="hidden" value="${train.admissionType}" id="admissionType"/>
    <input type="hidden" value="${train.id}" id="trainId"/>
    <input type="hidden" id="userMobileNo" value="<%=userMobileNo%>"/>
    <div class="peixunAddress">
        <p class="lm-breadcrumbs" style="color: #b03a3e;margin-top: 30px; font-size: 13px;">您所在的位置：<a href="${path}/frontIndex/index.do" style="color: #b03a3e;">首页</a> &gt;
            <a href="${path}/cmsTrain/cmsTrainIndex.do"><span style="color: #b03a3e;">培训报名</span></a> &gt;
            <span style="color: #b03a3e;">${train.trainTitle}</span>
        </p>
    </div>
    <div class="mainDetail clearfix">
        <div class="leftDetail">
        <div class="peixunDetail">
            <div style="padding-bottom:30px;position:relative">
                <div class="title" style="margin-bottom:0;width:90%;">
                    ${train.trainTitle}
                </div>

                <div class="peixunShare">
                    <div class="shares">
                        <div class="share_l fl">
                            <div class="icon">
			        <span class="bdsharebuttonbox">
				        <a class="zan" id="zanId" onclick="changeClass()"><span class="likeCount"></span></a>
						<%--<a class="share" data-cmd="count" style="margin: 6px 6px 6px 0px"></a>--%>
					 </span>
                                <!--分享代码 start-->
                                <%--<script type="text/javascript">--%>
                                    <%--with (document)0[(getElementsByTagName('head')[0] || body).appendChild(createElement('script')).src = 'http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion=' + ~(-new Date() / 36e5)];--%>
                                <%--</script>--%>
                                <!--分享代码 end-->
                            </div>
                        </div>
                        <%--<div class="share_r fr">--%>
                            <%--<a href="javascript:void(0)"><img src="${path}/STATIC/image/jb_icon.png" width="20" height="20"/>举报</a>--%>
                        <%--</div>--%>
                    </div>
                </div>
            </div>


            <div class="details">
                <div class="labels">
                    <span style="background: #b03a3e">${train.tagName}</span>
                    <span style="background: #b03a3e">${train.trainTag}</span>
                </div>
                <div class="cont clearfix">
                    <div class="img">
                        <img src="${train.trainImgUrl}" alt="">
                    </div>
                    <div class="msg">
                        <div class="sign" id="sign" style="background-color: #cb5454;"></div>
                        <div class="add">${train.trainAddress}</div>
                        <%--<div class="concreteAdd">${train.trainAddress}</div>--%>
                        <div class="time">报名开始时间：${train.registrationStartTime}</div>
                        <div class="endTime">报名结束时间：${train.registrationEndTime}</div>
                        <div class="trainTime">培训开始时间：${train.trainStartTime}</div>
                        <div class="trainTime">培训结束时间：${train.trainEndTime}</div>
                        <div class="personNum">报名人数：<span style="color: #b03a3e">
                            <c:if test="${not empty train.maxPeople}">${train.admissionsPeoples}/${train.maxPeople}</c:if>
                            <c:if test="${empty train.maxPeople}">${train.admissionsPeoples}</c:if>
                            </span>
                            人</div>
                        <div class="age">适合年龄：男:${train.maleMinAge}岁～${train.maleMaxAge}岁  女：${train.femaleMinAge}岁～${train.femaleMaxAge}岁</div>
                        <div class="price">
                            <c:if test="${train.admissionType == 1}">先到先得</c:if>
                            <c:if test="${train.admissionType == 2}">人工录取</c:if>
                            <c:if test="${train.admissionType == 3}">随机录取</c:if>
                            <c:if test="${train.admissionType == 4}">面试后录取</c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
            <!-- 培训课程 -->
        <div class="peixunCourse">
            <div class="title">培训课程时间表</div>
            <table>
                <tbody>
                <tr style="background:#f6f6f6;font-weight: bold">
                    <th style="width:68px;border-right: 1px solid #eeeeee;line-height: 34px;">序号</th>
                    <td style="width:188px;border-right: 1px solid #eeeeee;padding-left: 40px;line-height: 34px;">课程开始时间</td>
                    <td style="width:188px;border-right: 1px solid #eeeeee;padding-left: 40px;line-height: 34px;">课程结束时间</td>
                </tr>
                <c:forEach items="${fields}" var="field" varStatus="status">
                    <tr>
                        <td style="width:68px;border-right: 1px solid #eeeeee;text-align: center">${status.count}</td>
                        <td style="width:188px;border-right: 1px solid #eeeeee;padding-left: 40px">
                            <fmt:formatDate type="both" dateStyle="medium" timeStyle="medium" value="${field.fieldStartTime}" />
                        </td>
                        <td style="width:188px;border-right: 1px solid #eeeeee;padding-left: 40px">
                            <fmt:formatDate type="both" dateStyle="medium" timeStyle="medium" value="${field.fieldEndTime}" />
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
            <!-- 介绍 -->
            <div class="peixunIntro">
                <div class="introTitle clearfix">
                    <div class="choose">课程简介<i class="line"></i></div>
                    <div>师资介绍<i class="line"></i></div>
                    <div>报名要求<i class="line"></i></div>
                </div>
                <div class="content" id="courseIntroduction">
                    ${train.courseIntroduction}
                </div>
                <div class="content" style="display: none;" id="teachersIntroduction">
                    ${train.teachersIntroduction}
                </div>
                <div class="content" style="display: none;" id="registrationRequirements">
                    ${train.registrationRequirements}
                </div>
            </div>
            <div class="the_two">
                <div class="comment mt20 clearfix" id="divActivityComment" style="display: block;">
                    <a name="comment"></a>
                    <div class="comment-tit">
                        <h3>我要评论</h3><span id="commentCount">${commentCount}条评论</span>
                    </div>
                    <form id="commentForm">
                        <input type="hidden" id="tuserId" name="tuserId" value="${teamUser.tuserId}"/>
                        <input type="hidden" id="commentRkId" name="commentRkId" value="${train.id}"/>
                        <textarea class="text" name="commentRemark" id="commentRemark" maxLength="200"></textarea>
                        <div class="tips">
                            <div class="fl wimg">

                                <input type="hidden" name="commentImgUrl" id="headImgUrl" value=""/>
                                <input type="hidden" name="uploadType" value="Img" id="uploadType"/>
                                <div id="imgHeadPrev" style="position: relative; overflow: hidden;  float: left;">
                                </div>

                                <div style="float: left; margin-top: 0px;">
                                    <div>
                                        <input type="file" name="file" id="file"/>
                                    </div>
                                    <div class="comment_message" style="display: none">(最多三张图片)</div>
                                    <div id="fileContainer" style="display: none;"></div>
                                    <div id="btnContainer" style="display: none;"></div>
                                </div>

                            </div>
                            <div class="fr r_p">
                                <p style="color:#999999;">文明上网理性发言，请遵守新闻评论服务协议</p>
                                <input type="button" class="btn" value="发表评论" id="commentButton" onclick="addComment()"/>
                            </div>
                            <div class="clear"></div>
                        </div>
                    </form>
                    <div class="comment-list" id="comment-list-div">
                        <ul>
                        </ul>
                        <c:if test="${commentCount > 10}">
                            <input type="hidden" id="commentPageNum" value="1"/>
                            <a class="load-more" onclick="loadMoreComment()" id="moreComment"
                               style="display: none;">查看更多...</a>
                        </c:if>
                    </div>
                </div>
            </div>

        </div>


        <div class="rightDetail moreSug">
            <div class="map mb20">
                <div id="map-site"></div>
                <script type="text/javascript"
                        src="http://webapi.amap.com/maps?v=1.3&key=de421f9a41545db0c1c39cbb84f32163"></script>
                <script type="text/javascript">
                    var map, marker;
                    //初始化地图对象，加载地图
                    map = new AMap.Map("map-site", {
                        resizeEnable: true,
                        //二维地图显示视口
                        view: new AMap.View2D({
                            center: new AMap.LngLat(${train.lon}, ${train.lat}),//地图中心点
                            zoom: 19 //地图显示的缩放级别
                        })
                    });
                    //实例化点标记
                    marker = new AMap.Marker({
                        //复杂图标
                        /* icon: new AMap.Icon({
                         //图标大小
                         size:new AMap.Size(32,39),
                         //大图地址
                         image:"image/map-icon1.png"
                         }),
                         position:new AMap.LngLat(121.452481,31.23504)*/
                        position: map.getCenter()
                    });
                    marker.setMap(map);  //在地图上添加点
                </script>
            </div>
            <div class="suggest" style="background: white">
                <div class="sugtitle">推荐培训</div>
                <div class="moreMsg">
                </div>
             </div>
        </div>
    </div>
</div>
<div class="footer">
    <%@include file="/WEB-INF/why/index/footer.jsp" %>
</div>
</body>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/ui-dialog.css"/>
<script type="text/javascript" src="${path}/STATIC/js/dialog/lib/sea.js"></script>
<script type="text/javascript">
    var smsCode;
    seajs.config({
        alias: {
            "jquery": "${path}/STATIC/js/dialog/lib/jquery-1.10.2.js"
        }
    });
    seajs.use(['${path}/STATIC/js/dialog/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });

    window.console = window.console || {
        log: function () {
        }
    };
    seajs.use(['jquery'], function ($) {
        $('.share_r a').on('click', function () {
            if ('${sessionScope.terminalUser}' == null || '${sessionScope.terminalUser}' == "") {
                dialogAlert("提示", "登录之后才能举报");
                return;
            }
            top.dialog({
                url: '${path}/frontActivity/activityReportDialog.do?activityId=${train.id}',
                title: '举报原因',
                width: 420,
                height: 340,
                fixed: true,
                data: $(this).attr("data-name") // 给 iframe 的数据
            }).showModal();
            return false;
        });
    });
    // 冒泡
    function setStopPropagation(evt) {
        var e = evt || window.event;
        if(typeof e.stopPropagation == 'function') {
            e.stopPropagation();
        } else {
            e.cancelBubble = true;
        }
    }
    /*layui.use('laydate', function(){
        var laydate = layui.laydate;

        //执行一个laydate实例
        laydate.render({
            elem: '#birthday' //指定元素
        });
    });*/
    $(function(){
        // 头部显示微信公众号
        $(".headerTop .weixin").hover(function () {
            $(this).find(".ewm_code").toggle();
        });
        $('.selDiv dt').bind('click', function () {
            $(this).parent('.selDiv').find('dd').toggle();
        });
        $('.selDiv dd').on('click', 'a', function () {
            $(this).parent('dd').find('a').removeClass('cur');
            $(this).addClass('cur');
            $(this).parents('.selDiv').find('dt').html($(this).html());
            $(this).parent('dd').hide();
        });
        $('html,body').bind('click', function () {
            $('.selDiv dd').hide();
        })
        $('.selDiv').bind('click', function (evt) {
            setStopPropagation(evt)
        });

        // 弹窗
        // 时间冲突
        $('.alertTime .alertTimeContent').on('click', '.imgClose, .know', function () {
            $('.alertTime').hide()
        })
        // 已报两个课程
        $('.alertEnough .alertEnoughContent').on('click', '.imgClose, .know', function () {
            $('.alertEnough').hide()
        })
        // 报名成功
        $('.alertSuccess .alertSuccessContent').on('click', '.imgClose, .know', function () {
            $('.alertSuccess').hide()
        })
        // 报名申请
        $('.alertEnrollContent').on('click', '.imgClose', function () {
            $('.alertEnrollContent').hide()
        })
        // 介绍
        $('.peixunIntro').on('click', '.introTitle div', function () {
            //alert($(this).index());
            $(this).addClass('choose').siblings().removeClass('choose');
            if($(this).index() == 0){
                $("#registrationRequirements").hide();
                $("#teachersIntroduction").hide();
                $("#courseIntroduction").show();
            }else if($(this).index() == 1){
                $("#registrationRequirements").hide();
                $("#courseIntroduction").hide();
                $("#teachersIntroduction").show();
            }else{
                $("#courseIntroduction").hide();
                $("#teachersIntroduction").hide();
                $("#registrationRequirements").show();
            }
        })
        loadTrainData();
    })
    function loadTrainData(){
        $.post("${path}/cmsTrain/trainList.do",{page:1,pageNum:3},function (data) {
            console.log(data.status);
            if(data.status == 0){
                var html = "";
                for(var i = 0;i<data.data.length;i++){
                    var obj = data.data[i];
                    html += '<div class="moreMsgIntro clearfix" d-id="'+obj.id+'">'+
                            '<div class="img">'+
                            '<img src="'+obj.trainImgUrl+'" alt="">'+
                            '</div>'+
                            '<div class="introWords">'+
                            '<div class="title">'+obj.trainTitle+'</div>'+
                            '<div class="time">报名时间：</div>'+
                            '<div class="time clock">'+obj.registrationStartTime+'</div>'+
                            '</div></div>';
                }
                $(".moreMsg").html(html);
                $(".moreMsgIntro").on('click',function () {
                    location.href='${path}/cmsTrain/trainDetail.do?id='+$(this).attr('d-id');
                })
            }
        }, "json");
    }
    $(function () {
        $("#male").click(function () {
            $("#male").attr("checked", true);
            $("#female").attr("checked", false);
        });
        $("#female").click(function () {
            $("#male").attr("checked", false);
            $("#female").attr("checked", true);
        });

        //地址地图
        $('.preAddressMap').on('click', function () {
            window.location.href = "${path}/wechat/preAddressMap.do?lat=${train.lat}&lon=${train.lon}";
        })

        var regStarttime = '${train.registrationStartTime}';
        var regEndtime = '${train.registrationEndTime}';
        var traStarttime = '${train.trainStartTime}';
        var traEndtime = '${train.trainEndTime}';
        var now = '${now}';

        if(now < traEndtime){
            if (${train.admissionsPeoples >= train.maxPeople}) {
                $('.sign').html('报名名额已满');
            } else {
                if (now < regStarttime) {
                    $('.sign').html('报名未开始');
                } else if (now > regEndtime) {
                    $('.sign').html('<a class="sign">报名已结束</a>');
                } else {
                    $('.sign').html('<a class="sign"  onclick="showForm();">立即报名</a>');
                }
            }
            /*if (${train.isRegistration>=1}) {
                $('.sign').html('您已报名');
            } else {
                if (${train.admissionsPeoples >= train.maxPeople}) {
                    $('.sign').html('报名名额已满');
                } else {
                    if (now < regStarttime) {
                        $('.sign').html('报名未开始');
                    } else if (now > regEndtime) {
                        $('.sign').html('<a class="sign">报名已结束</a>');
                    } else {
                        $('.sign').html('<a class="sign"  onclick="showForm();">立即报名</a>');
                    }
                }
            }*/
        }else{
            $('.sign').html('<a class="sign">培训已结束</a>');
        }
    });

    function showForm() {
        var userId = '${sessionScope.terminalUser.userId}'
        if (userId == null || userId == '') {
            window.location.href = '${path}/frontTerminalUser/userLogin.do';
            return;
        }
        $.post('${path}/cmsTrain/checkEntry.do', {id: '${train.id}',userId:userId}, function (data) {
            data = JSON.parse(data);
            if (data.status != 200) {
                dialogAlert("报名提示", data.data);
            } else {
                $("#alertEnrollContent").show();
            }
        })
    }

    //图片预览
    function previewImage(url, urls) {
        wx.previewImage({
            current: url, // 当前显示图片的http链接
            urls: urls.substring(0, urls.length - 1).split(",")	 // 需要预览的图片http链接列表
        });
    }

    function getAge(str){
        var r = str.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);
        if(r==null)
            return   false;
        var d= new Date(r[1],r[3]-1,r[4]);
        if(d.getFullYear()==r[1] && (d.getMonth()+1)==r[3] && d.getDate()==r[4])
        {
            var Y = new Date().getFullYear();
            return Y-r[1];
        }
    }

    function checkAge(){
        var idCard = $("#idCard").val();
        var ageStr = idCard.substr(6,4)+"-"+idCard.substr(10,2)+"-"+idCard.substr(12,2);
        $("#birthday").val(ageStr);
        var age = getAge(ageStr);
        var sex = parseInt(idCard.substr(16,1));

        $("#sex").val(sex % 2 ==0 ? 2 : 1)

        var maleMinAge = ${train.maleMinAge};
        var maleMaxAge = ${train.maleMaxAge};
        var femaleMinAge = ${train.femaleMinAge};
        var femaleMaxAge = ${train.femaleMaxAge};
        if(sex % 2 == 1){
            if(age >= maleMinAge && age <= maleMaxAge){
                return true;
            }else{
                return false;
            }
        }else{
            if(age >= femaleMinAge && age <= femaleMaxAge){
                return true;
            }else{
                return false;
            }
        }
    }

    function reload(){
        window.location.href = '${path}/cmsTrain/trainDetail.do?id=${train.id}';
    }

    function goRegist(){
        var admissionType = $("#admissionType").val();
        var name = $("#name").val();
        // var birthday = $("input[name=birthday]").val();
        var idCard = $("#idCard").val();
        var phoneNum = $("#phoneNum").val();
        var userSmsCode = $("#code").val();
        var trainRemark=$("#trainRemark").val();
        if (!name) {
            dialogAlert("报名提示", "请填写姓名");
            return;
        }
        /*if (!birthday) {
            dialogAlert("报名提示", "请填写出生年月");
            return;
        }*/
        if (!idCard) {
            dialogAlert("报名提示", "请填写身份证");
            return;
        }else{
            if(!/(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/.test(idCard)){
                dialogAlert("报名提示", "证件格式不合法");
                return;
            }
        }
        if (!phoneNum) {
            dialogAlert("报名提示", "请填写手机号码");
            return;
        }else{
            var _thisReg = (/^1[2345678]\d{9}$/);
            if (!phoneNum.match(_thisReg)) {
                dialogAlert("报名提示", "请填写正确的手机号码");
                return
            }
        }
        if(!checkAge()){
            dialogAlert("报名提示","您的年龄不符合要求");
            return;
        }
        console.log("userSmsCode ==" + userSmsCode);
        console.log("smsCode ==" + smsCode);
        if(userSmsCode != null && userSmsCode != ""){
            if(userSmsCode!=smsCode){
                dialogAlert("提示", "请输入正确的短信验证码！");
                return;
            }
        }else{
            dialogAlert("提示", "请输入短信验证码！");
            return;
        }

        if(trainRemark=='不能超过100个字'){
            $("#trainRemark").val('');
        }

        $.post('${path}/cmsTrain/saveOrder.do',$('#orderForm').serialize(),function (data) {
            data = JSON.parse(data);
            if(data.status!=200){
                if(data.status==300){
                    dialogAlert("报名提示", data.data);
                    window.location.href = '${path}/frontTerminalUser/userLogin.do';
                }else{
                    dialogAlert("报名提示", data.data);
                }
            }else{
                $("#alertEnrollContent").hide();
                if(admissionType != 1){
                    $("#alertSuccess2").show();
                }else{
                    $("#alertSuccess").show();
                }
            }
        })
    };

    $(function () {
        var Img = $("#uploadType").val();
        $("#file").uploadify({
            'formData': {
                'uploadType': Img,
                'type': 10,
                'userMobileNo': $("#userMobileNo").val()
            },//传静态参数
            swf: '${path}/STATIC/js/uploadify.swf',
            uploader: '${path}/upload/frontUploadFile.do;jsessionid=${pageContext.session.id}',
            buttonText: '<a class="shangchuan" style="margin:0;"><h4><font>添加图片</font></h4></a>',
            'buttonClass': "upload-btn",
            /*queueSizeLimit:3,*/
            fileSizeLimit: "2MB",
            'method': 'post',
            queueID: 'fileContainer',
            fileObjName: 'file',
            'fileTypeDesc': '支持jpg、png、gif格式的图片',
            'fileTypeExts': '*.gif; *.jpg; *.png',
            'auto': true,
            'multi': true, //是否支持多个附近同时上传
            height: 21,
            width: 85,
            'debug': false,
            'dataType': 'json',
            'removeCompleted': true,
            onUploadSuccess: function (file, data, response) {
                var json = $.parseJSON(data);
                var url = json.data;

                $("#headImgUrl").val($("#headImgUrl").val() + url + ";");
                getHeadImg(url);

                if ($("#headImgUrl").val().split(";").length > 3) {
                    $("#file").hide();
                    $(".comment_message").show();
                }
            },
            onSelect: function (file) {

            },
            onDialogOpen: function () {

            },
            onQueueComplete: function (queueData) {
                if ('${sessionScope.terminalUser}' == null || '${sessionScope.terminalUser}' == '') {
                    dialogAlert("评论提示", "登录之后才能评论");
                }
            }
        });

        loadWantGo();

        $("#searchSltVal").val("活动");
        $("#searchSltSpan").html("活动");

    });

    function loadWantGo() {
        $.ajaxSetup({cache: false});		//防止ie load();读取缓存数据
        var page = $("#page").val();	//分页数
        //我想去列表加载
        $("#go_head").load("${path}/frontActivity/frontWantGoListLoad.do?page=" + page + "&activityId=${train.id}&userId=${sessionScope.terminalUser.userId}", function () {
            //分页
            kkpager.generPageHtml({
                pno: $("#pages").val(),
                //总页码
                total: $("#countpage").val(),
                //总数据条数
                totalRecords: $("#total").val(),
                mode: 'click',
                isShowFirstPageBtn: false,
                isShowLastPageBtn: false,
                isShowTotalPage: false,
                click: function (n) {
                    this.selectPage(n);
                    $("#page").val(n);
                    loadWantGo();
                    return false;
                }
            });
        });
    }

    function getHeadImg(url) {
        var imgUrl = getImgUrl(url);
        imgUrl = getIndexImgUrl(imgUrl, "_300_300");
        $("#imgHeadPrev").append("<div class='sc_img fl' data-url='" + url + "'><img onload='fixImage(this, 100, 100)' src='" + imgUrl + "'><a href='javascript:;'></a></div>");
        $("#btnContainer").hide();
        $("#fileContainer").hide();
    }

    /*活动评论图片删除*/
    $(function () {
        $(".wimg").on("click", ".sc_img a", function () {
            var url = $(this).parent().attr("data-url");
            var allUrl = $("#headImgUrl").val();
            var newUrl = allUrl.replace(url + ";", "");
            $("#headImgUrl").val(newUrl);

            $(this).parent().remove();
            if ($("#headImgUrl").val().split(";").length <= 3) {
                $("#file").show();
                $(".comment_message").hide();
            }
        });
        $(".wimg").on({
            mouseover: function () {
                $(this).find("a").show();
            },
            mouseout: function () {
                $(this).find("a").hide();
            }
        }, ".sc_img");
    });

    //点击收藏
    function changeClass() {
        if ('${sessionScope.terminalUser}' == null || '${sessionScope.terminalUser}' == "") {
            dialogAlert("提示", "登录之后才能收藏");
            return;
        }

        //判断是收藏还是取消 收藏
        if ($("#zanId").hasClass("love")) {
            $.ajax({
                type: 'POST',
                dataType: "json",
                url: "${path}/collect/deleteUserCollect.do?relateId=${train.id}&type=2",//请求的action路径
                error: function () {//请求失败处理函数
                },
                success: function (data) { //请求成功后处理函数。
                    $(".likeCount").html(data);
                }
            });
            $("#zanId").removeClass("love");
        } else {
            $.ajax({
                type: 'POST',
                dataType: "json",
                url: "${path}/cmsTypeUser/activitySave.do?activityId=${train.id}&operateType=3",//请求的action路径
                error: function () {//请求失败处理函数
                },
                success: function (data) { //请求成功后处理函数。
                    $(".likeCount").html(data);
                }
            });
            $("#zanId").addClass("love");
        }
    }

    //得到喜欢的人数
    $(function () {
        $.ajax({
            type: 'POST',
            dataType: "json",
            url: "${path}/collect/getHotNum.do?relateId=${train.id}&type=2",//请求的action路径
            error: function () {//请求失败处理函数
            },
            success: function (data) { //请求成功后处理函数。
                $(".likeCount").html(data);
            }
        });
    });

    //判断用户是否收藏了该条内容
    $(function () {
        $.ajax({
            type: 'POST',
            dataType: "json",
            url: "${path}/collect/isHadCollect.do?relateId=${train.id}&type=2",//请求的action路径
            error: function () {//请求失败处理函数
            },
            success: function (data) { //请求成功后处理函数。
                if (data > 0) {
                    $("#zanId").addClass("love");
                }
            }
        });
    });

    function addComment() {

        if ('${sessionScope.terminalUser}' == null || '${sessionScope.terminalUser}' == '') {
            dialogAlert("评论提示", "登录之后才能评论");
            return;
        }
        var status = '${sessionScope.terminalUser.commentStatus}';
        if (parseInt(status) == 2) {
            dialogAlert("评论提示", "您的账户已被禁止评论，没有评论权限");
            return;
        }
        var commentRemark = $("#commentRemark").val();
        if (commentRemark == undefined || $.trim(commentRemark) == "") {
            dialogAlert("评论提示", "输入评论内容");
            return;
        }

        var headImgUrl = $("#headImgUrl").val();
        if (headImgUrl != "") {
            if (headImgUrl.lastIndexOf(";") == headImgUrl.length - 1) {
                var url = headImgUrl.substring(0, headImgUrl.lastIndexOf(";"));
                $("#headImgUrl").val(url);
            }
        }

        $.ajax({
            type: "post",
            url: "${path}/cmsTrain/addComment.do",
            data: $("#commentForm").serialize(),
            dataType: "json",
            cache: false,//缓存不存在此页面
            async: false,//异步请求
            success: function (result) {
                if (result == "success") {
                    $("#commentRemark").val("");
                    $("#headImgUrl").val("");
                    $(".sc_img").remove();
                    $("#file").show();
                    dialogAlert("提示", "评论成功!");
                    $(".comment_message").hide();
                    loadCommentList();
                    $.ajax({
                        type: "post",
                        url: "${path}/comment/queryCommentCount.do",
                        data: {commentRkId: $("#commentRkId").val(), commentType: 10},
                        dataType: "json",
                        cache: false,//缓存不存在此页面
                        async: false,//异步请求
                        success: function (result) {
                            $("#commentCount").html(result + "条评论");
                        }
                    });
                } else if (result == "exceedNumber") {
                    dialogAlert("提示", "每天仅能评论1次，请明天再来!");
                } else if (result == "sensitiveWordsExist") {
                    dialogAlert("评论提示", "评论内容有敏感词，不能评论!");
                } else {
                    dialogAlert("提示", "评论失败，请重试!");
                }
            }
        });
    }


    function mySetDisBtn(id,tf){
        $("#"+id).prop("disabled",tf);
    }
    var smsLock = false;
    //发送验证码
    function sendSmsCode() {
        var userId = "${sessionScope.terminalUser.userId}";
        var userMobile = $("#phoneNum").val();
        var telReg = (/^1[3456789]\d{9}$/);
        if (userMobile == "") {
            dialogAlert('系统提示', '请输入手机号码！');
            return false;
        } else if (!userMobile.match(telReg)) {
            dialogAlert('系统提示', '请正确填写手机号码！');
            return false;
        }
        if(!smsLock){
            $.ajax({
                type: 'post',
                url : "${path}/wechatUser/sendAuthCode.do",
                dataType : 'json',
                data: {userId: userId, userTelephone: userMobile},
                success: function (data) {
                    if (data.status == 0) {
                        smsCode = data.data1;
                        smsTimer();
                        //console.log(smsCode);
                        var s = 60;
                        $("#smsCodeBut").attr("onclick", "");
                        $("#smsCodeBut").html(s + "s");
                        smsLock = true;
                        var ss = setInterval(function () {
                            s -= 1;
                            $("#smsCodeBut").html(s + "s");
                            if (s == 0) {
                                clearInterval(ss);
                                smsLock = false;
                                $("#smsCodeBut").attr("onclick", "sendSms();");
                                smsCode = '';
                                $("#smsCodeBut").html("发送验证码");

                            }
                        }, 1000)
                    }
                }
            });
        }
    }
    var timeOut = 60;
    function smsTimer () {
        if (timeOut <= 0) {
            mySetDisBtn("sendCode",false);
            $("#sendCode").val("获取验证码");
            timeOut = 60;
        } else {
            $("#sendCode").val(timeOut+"秒后重新获取");
            timeOut--;
            setTimeout(function () {
                smsTimer();
            }, 1000);
        }
    }
</script>
<style type="text/css">
    #file {
        position: relative;
    }

</style>
</html>