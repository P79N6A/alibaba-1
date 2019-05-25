<%@ page import="org.apache.commons.lang3.StringUtils ,com.sun3d.why.model.CmsTerminalUser" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/frontPageFrame.jsp" %>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/index/activity/activityDetail.js?version=20160603"></script>
    <script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ckplayer/ckplayer.js"></script>
    <script type="text/javascript">
        var listL = "";
        $(function () {
            $.post("${path}/frontActivity/queryActivityLabelById.do?activityId=${cmsActivity.activityId}", function (data) {
                var list = eval(data);
                var tagHtml = '';
                var otherHtml = '';
                var tagIds = $("#tagIds").val();
                var ids = '';
                if (tagIds.length > 0) {
                    ids = tagIds.substring(0, tagIds.length - 1).split(",");
                }

                for (var i = 0; i < list.length; i++) {
                    var result = false;
                    if (ids != '') {

                        for (var j = 0; j < ids.length; j++) {
                            if (list[i].tagId == ids[j]) {
                                result = true;
                                break;
                            }
                        }
                    }
                    var cl = '';
                    if (result) {
                        cl = 'class="cur"';
                    }

                    if (list[i].tagName == '其他') {
                        otherHtml = '<a' + cl + ' onclick="setTag(\''
                            + list[i].tagId + '\')">' + list[i].tagName
                            + '</a>';
                        continue;
                    }
                    tagHtml += '<a' + cl + ' onclick="setTag(\''
                        + list[i].tagId + '\')">' + list[i].tagName
                        + '</a>';
                    listL = listL + "_" + list[i].tagName;
                }
                $("#tag").html(tagHtml + otherHtml);

            });
            
            wantGoTotal();
        });
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
            $("#go_head").load("${path}/frontActivity/frontWantGoListLoad.do?page=" + page + "&activityId=${cmsActivity.activityId}&userId=${sessionScope.terminalUser.userId}", function () {
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
                    url: "${path}/collect/deleteUserCollect.do?relateId=${cmsActivity.activityId}&type=2",//请求的action路径
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
                    url: "${path}/cmsTypeUser/activitySave.do?activityId=${cmsActivity.activityId}&operateType=3",//请求的action路径
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
                url: "${path}/collect/getHotNum.do?relateId=${cmsActivity.activityId}&type=2",//请求的action路径
                error: function () {//请求失败处理函数
                },
                success: function (data) { //请求成功后处理函数。
                    $(".likeCount").html(data);
                }
            });
        });

        //判断用户是否收藏了该条内容
        $(function () {
            /* $.ajax({
                type: 'POST',
                dataType: "json",
                url: "${path}/collect/isHadCollect.do?relateId=${cmsActivity.activityId}&type=2",//请求的action路径
                error: function () {//请求失败处理函数
                },
                success: function (data) { //请求成功后处理函数。
                    if (data > 0) {
                        $("#zanId").addClass("love");
                    }
                }
            }); */
        });

        //统计数据
        $(function () {
            //默认选中当前label
            $('#activityLabel').addClass('cur').siblings().removeClass('cur');
            $.ajax({
                type: 'POST',
                dataType: "json",
                url: "${path}/cmsTypeUser/activitySave.do?activityId=${cmsActivity.activityId}&operateType=1",//请求的action路径
                error: function () {//请求失败处理函数
                },
                success: function (data) { //请求成功后处理函数。
                }
            });
        });

        //异步加载图片
        $(function () {
            $("#allInfo li").each(function (index, item) {
                var imgUrl = $(this).attr("activity-icon-url");
                if (imgUrl == undefined || imgUrl == "") {
                    $(item).find("img").attr("src", "../STATIC/image/default.jpg");
                } else {
                    var trueImgUrl;
                    var index = imgUrl.lastIndexOf("http:");
                    if (index > -1) {
                        trueImgUrl = imgUrl;
                    }
                    else
                        trueImgUrl = getIndexImgUrl(getImgUrl(imgUrl), "_300_300");

                    $(item).find("img").attr("src", trueImgUrl);
                }
            });

            //异步加载附件
            var attachmentUrl = $(".download_fj").attr("activityAttachment");
            if (attachmentUrl != null && attachmentUrl != "") {
                var attachments = attachmentUrl.split(",");
                for (var i = 0; i < attachments.length; i++) {
                    attachmentUrl = getImgUrl(attachments[i]);
                    $(".download_fj").append("<a href='" + attachmentUrl + "'>下载附件" + (i + 1) + "</a><br/>");
                }
            }

            //选中当前label
            $('#activityListLabel').addClass('cur').siblings().removeClass('cur');
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
                url: "${path}/frontActivity/addComment.do",
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
                            data: {commentRkId: $("#commentRkId").val(), commentType: 2},
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

        function bookActivity(activityId) {
            if ('${sessionScope.terminalUser}' == null || '${sessionScope.terminalUser}' == "") {
                dialogAlert("提示", "登录之后才能预订");
                return;
            }
            var localUrl = top.location.href;
            if (localUrl.indexOf("collect_info.jsp") == -1) {
                location.href = "${path}/frontActivity/frontActivityBook.do?activityId=" + activityId;
            } else {
                location.href = "${path}/userTicket/frontActivityBook.do?activityId=" + activityId;
            }
        }

        function wantGo(activityId, userId) {
            $("#wantGoA").attr("href", "javascript:void(0);");
            if ('${sessionScope.terminalUser}' == null || '${sessionScope.terminalUser}' == "") {
                dialogAlert("提示", "登录之后才能点击！");
                loadWantGo();
                return;
            }
            $.post("${path}/frontActivity/addActivityUserWantgo.do?activityId=" + activityId + "&userId=" + userId, function (data) {
                if (data == "success") {
                    loadWantGo();
                } else {
                    dialogAlert("提示", "操作失败！");
                    loadWantGo();
                }
            });
        }

        /*跳转到列表*/

        document.onkeydown = keyDownLogin;

        function keyDownLogin(e) {
            var theEvent = e || window.event;
            var code = theEvent.keyCode || theEvent.which || theEvent.charCode;
            if (code == 13) {
                toList();
                return false;
            }
            return true;
        }

        function toList() {
            var key = $("#keyword").val() == "请输入关键词" ? "" : $("#keyword").val();
            if ($.trim(key) != "") {
                window.location.href = "${path}/frontActivity/frontActivityList.do?activityName=" + encodeURI(key);
            }
        }

        $(function () {
            $('#keyword').blur(function () {
                toList();
            });
        });


        /*    function starts(obj,n){
         var $obj = $(obj);
         $obj.each(function(index, element) {
         var num=parseFloat($(this).attr("tip"));
         var width=num*n;
         $(this).children("p").css("width",width);
         });
         }*/
        /*    function setScore(){
         var num = 0,starW = 0, scoreNum = 0;
         $("#star-score a").each(function(index, element) {
         $(this).click(function(){
         $("#star-score a").removeClass("cur");
         $(this).addClass("cur");
         $(this).css({"width":starW,"left":"0"});
         $("#score-num").text(scoreNum);
         $("#activityScore").val(scoreNum);
         });
         $(this).hover(function(){
         scoreNum = $(this).text();
         num = parseInt(index)+1;
         starW = 14*num;
         });
         });
         }
         $(function(){
         setScore();
         });*/

       	 //点赞
         function addWantGo() {
        	 if ('${sessionScope.terminalUser}' == null || '${sessionScope.terminalUser}' == "") {
                 dialogAlert("提示", "登录之后才能点赞");
                 return;
             }

             $.post("${path}/wechatActivity/wcAddActivityUserWantgo.do", {
                 activityId: '${cmsActivity.activityId}',
                 userId: '${sessionScope.terminalUser.userId}'
             }, function (data) {
                 if (data.status == 0) {
                	 wantGoTotal();
                	 $("#zanId").addClass("love");
                 } else if (data.status == 14111) {
                     $.post("${path}/wechatActivity/deleteActivityUserWantgo.do", {
                    	 activityId: '${cmsActivity.activityId}',
                         userId: '${sessionScope.terminalUser.userId}'
                     }, function (data) {
                         if (data.status == 0) {
                        	 wantGoTotal();
                        	 $("#zanId").removeClass("love");
                         }
                     }, "json");
                 }
             }, "json");
         }     
         
       	//点赞数
         function wantGoTotal() {
             var data = {
                 activityId: '${cmsActivity.activityId}',
                 pageIndex: 0,
                 pageNum: 10
             };
             $.post("${path}/wechatActivity/wcActivityUserWantgoList.do", data, function (data) {
                 if (data.status == 0) {
                 	$(".wantgoCount").html(data.pageTotal);
                 }
             }, "json");
 		}
    </script>


    <style type="text/css">
        #file {
            position: relative;
        }

    </style>
    <title>${cmsActivity.activityName}${listL}_更多免费活动_品质生活-文化云</title>
    <meta name="description"
          content="${cmsActivity.activityName}/${createTime}/<c:if test="${cmsActivity.activityIsReservation==2}" >可预定</c:if><c:if test="${cmsActivity.activityIsReservation!=2}" >不预定</c:if>_文化云为您提供活动在线预订，购票等服务
">
    <meta name="Keywords" content="${cmsActivity.activityName}、地址、时间、电话、公交、简介、免费、免费预订、免费参与">
</head>
<body>
<!-- 导入头部文件 -->
<div class="header">
    <%@include file="../header.jsp" %>
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
<input type="hidden" id="wantGoFlag" value="1"/>
<input type="hidden" id="userMobileNo" value="<%=userMobileNo%>"/>
<input type="hidden" id="page" name="page" value="1"/>
<div class="crumb"><i></i>您所在的位置：<a href="${path}/frontIndex/index.do">活动</a> &gt; <c:out escapeXml="true"
                                                                                          value="${cmsActivity.activityName}"/>
</div>
<div class="detail-content" id="allInfo">
    <div class="detail-left fl">
        <div class="the_one">
            <div class="a_time">
                <div class="time"> ${createTime} / 收藏：<span class="likeCount"></span> <%--/
                    浏览：<span>${cmsActivity.yearBrowseCount==null?0:cmsActivity.yearBrowseCount}</span>--%>
                </div>
            </div>
            <div class="a_note">
                <div class="title">
                    <h1><c:out escapeXml="true" value="${cmsActivity.activityName}"/></h1>
                </div>
                <div class="tag">
                    <input type="hidden" value="${tagIds}" name="tagIds" id="tagIds"/>
                    <div class="tag" id="tag"></div>
                </div>
                <div class="address">
                    <div class="al_img fl">
                        <li activity-icon-url="${cmsActivity.activityIconUrl}">
                            <img src="" alt="" style="width: 320px;height: 213px;"/>
                            <a style="visibility: hidden"><img alt="文化云" src="" width="121" height="75"/></a>
                        </li>
                    </div>
                    <div class="al_r fl">
                        <c:if test="${cmsActivity.activityIsReservation==2 and cmsActivity.activityIsDel == 1 and cmsActivity.activityState == 6}">
                            <div class="yd_btn" style="width: 396px;">
                                <c:if test="${isOver == 'Y'}">
                                    <a class="book-btn" style="background: #808080;cursor:default;margin-right:12px;"
                                       href="#">活动已结束</a>
                                </c:if>
                                <c:if test="${isOver == 'N'}">
                                    <c:if test="${empty cmsActivity.activityReservationCount || cmsActivity.activityReservationCount == 0 }">
                                        <a class="book-btn"
                                           style="background: #808080;cursor:default;margin-right:12px;"
                                           href="#">预订人数已满</a>
                                        余票：
                                        <span>
				                <c:if test="${empty cmsActivity.activityReservationCount}"> 0</c:if>
				                <c:if test="${not empty cmsActivity.activityReservationCount}"> ${cmsActivity.activityReservationCount}</c:if>
			                </span>
                                        张
                                    </c:if>
                                    <c:if test="${cmsActivity.activityReservationCount > 0}">
                                        <c:choose>
                                            <c:when test="${cmsActivity.activityIsFree == 3}">
                                                <a class="book-btn" style="margin-right:12px;"
                                                >请至公众号预订</a>
                                            </c:when>
                                            <c:otherwise>
                                                <c:if test="${empty cmsActivity.sysId && orderLimit!=1}">
                                                    <c:choose>
                                                        <%--需要积分的活动--%>
                                                        <c:when test="${not empty cmsActivity.lowestCredit || not empty cmsActivity.costCredit}">
                                                            <a class="book-btn" style="margin-right:12px;"
                                                               href="javascript:bookActivity('${cmsActivity.activityId}')"
                                                            >我要预订</a>
                                                        </c:when>
                                                        <%--秒杀和付费活动--%>
                                                        <c:when test="${cmsActivity.spikeType == 1 || cmsActivity.activityIsFree == 3}">
                                                            <a class="book-btn" style="margin-right:12px;"
                                                            >请至公众号预订</a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a class="book-btn" style="margin-right:12px;"
                                                               href="javascript:bookActivity('${cmsActivity.activityId}')">我要预订</a>
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <%-- <a class="book-btn" style="margin-right:12px;padding: 0 10px;width: 340px;"
                                                       href="${path}/frontIndex/phone.do">订票系统维护中 请先使用文化云移动端预订</a> --%>
                                                </c:if>
                                                <c:if test="${not empty cmsActivity.sysId || orderLimit==1}">
                                                    <a class="book-btn" style="margin-right:12px;"
                                                    >请至公众号预订</a>
                                                </c:if>
                                            </c:otherwise>
                                        </c:choose>

                                        <!-- 余票：
                                        <span>
                                        <c:if test="${empty cmsActivity.activityReservationCount}"> 0</c:if>
                                        <c:if test="${not empty cmsActivity.activityReservationCount}"> ${cmsActivity.activityReservationCount}</c:if>
                                        </span>
                                        张 -->
                                        <%-- </c:if>	--%>
                                    </c:if>
                                </c:if>
                            </div>
                        </c:if>
                        <div class="list">
                            <p class="site">
		            <span>
		              <%--${fn:split(cmsActivity.activityCity, ',')[1]}&nbsp;<c:if test="${fn:split(cmsActivity.activityArea, ',')[1] != fn:split(cmsActivity.activityCity, ',')[1]}">${fn:split(cmsActivity.activityArea, ',')[1]}&nbsp;</c:if><c:out  value="${cmsActivity.activityAddress}" escapeXml="true" />--%>
                      <c:out value="${cmsActivity.activityAddress}" escapeXml="true"/>
                    </span>
                            </p>
                            <p class="time">
		          	<span>
			            <fmt:parseDate value="${cmsActivity.activityStartTime}" pattern="yyyy-MM-dd" var="startTime"/>
			            <fmt:parseDate value="${cmsActivity.activityEndTime}" pattern="yyyy-MM-dd" var="endTime"/>

			            <fmt:formatDate value="${startTime}" pattern="yyyy年MM月dd日"/>
                        <c:if test="${startTime eq endTime}">

                        </c:if>
			            <c:if test="${not empty endTime && startTime != endTime}">
                            - <fmt:formatDate value="${endTime}" pattern="yyyy年MM月dd日"/>&nbsp;
                        </c:if>
		            </span>
                            </p>
                            <c:if test="${not empty activityEventList}">
                                <p class="period">
                                        <%--<fmt:formatDate value="${startTime}" pattern="HH:mm"/> - <fmt:formatDate value="${endTime}" pattern="HH:mm"/>--%>
                                    <c:forEach items="${activityEventList}" var="event">
                                        <span>${event.eventTime}</span>
                                    </c:forEach>
                                </p>
                            </c:if>
                            <!-- 历史数据 -->
                            <c:if test="${empty activityEventList}">
                                <c:if test='${fn:contains(cmsActivity.activityEndTime,":")}'>
                                    <p class="period">
		              <span style="max-width: 592px;">
		                    <fmt:parseDate value="${cmsActivity.activityStartTime}" pattern="yyyy-MM-dd HH:mm"
                                           var="startHourTime"/>
		                    <fmt:parseDate value="${cmsActivity.activityEndTime}" pattern="yyyy-MM-dd HH:mm"
                                           var="endHourTime"/>
		                 <fmt:formatDate value="${startHourTime}" pattern="HH:mm"/> - <fmt:formatDate
                              value="${endHourTime}" pattern="HH:mm"/>
		              </span>
                                    </p>
                                </c:if>
                            </c:if>
                            <c:if test="${not empty cmsActivity.activityTimeDes}">
                                <p style="height: auto;">注： <c:out escapeXml="true"
                                                                   value="${cmsActivity.activityTimeDes}"/></p>
                            </c:if>
                            <p class="phone">
                                <span><c:out value="${cmsActivity.activityTel}" escapeXml="true"/></span>
                            </p>
                        </div>
                    </div>
                </div>
                <div class="line"></div>
                <div class="ad_intro">
                    <p style="color: #F00;">
                        <c:if test="${cmsActivity.activityIsReservation == 1}">
                            <c:if test="${cmsActivity.activityIsFree == 1}">
                                温馨提示：本活动无需在佛山文化云预约，具体参与方式请以主办方公布为准，您可拨打电话（<c:out value="${cmsActivity.activityTel}"
                                                                                 escapeXml="true"/>）进行咨询
                            </c:if>
                            <c:if test="${cmsActivity.activityIsFree == 2}">
                                温馨提示：本活动无需在佛山文化云预约，需要收费，具体参与方式请以主办方公布为准，您可拨打电话（<c:out value="${cmsActivity.activityTel}"
                                                                                      escapeXml="true"/>）进行咨询
                            </c:if>
                        </c:if>
                        <c:if test="${cmsActivity.activityIsReservation == 2}">
                            <c:if test="${cmsActivity.activityIsFree == 1}">
                                温馨提示：需要事先预订，请点击“我要预订”按钮进行票务预订。有任何问题欢迎拨打电话咨询（<c:out value="${cmsActivity.activityTel}"
                                                                                   escapeXml="true"/>）
                            </c:if>
                            <c:if test="${cmsActivity.activityIsFree == 2}">
                                温馨提示：需要事先预订，需要付费,请点击“我要预订”按钮进行票务预订。有任何问题欢迎拨打电话咨询（<c:out
                                    value="${cmsActivity.activityTel}" escapeXml="true"/>）
                            </c:if>
                        </c:if>
                    </p>
                    <p> ${cmsActivity.activityMemo}</p>
                </div>

                <div class="extra">
                    <%--<c:if test="${not empty cmsActivity.createActivityCode}" >--%>
                    <%--<p>--%>
                    <%--发布者：--%>


                    <%--<c:choose>--%>
                    <%--<c:when test="${not empty cmsActivity.venueName}">--%>
                    <%--${cmsActivity.venueName}--%>
                    <%--</c:when>--%>
                    <%--<c:otherwise>--%>
                    <%--<c:choose>--%>
                    <%--<c:when test="${cmsActivity.createActivityCode == 0}">--%>
                    <%--${fn:split(cmsActivity.activityProvince, ',')[1]}&nbsp;市自建活动--%>
                    <%--</c:when>--%>
                    <%--<c:when test="${cmsActivity.createActivityCode == 1}">--%>
                    <%--${fn:split(cmsActivity.activityCity, ',')[1]}&nbsp;市自建活动--%>
                    <%--</c:when>--%>
                    <%--<c:when test="${cmsActivity.createActivityCode == 2}">--%>
                    <%--${fn:split(cmsActivity.activityArea, ',')[1]}&nbsp;区自建活动--%>
                    <%--</c:when>--%>
                    <%--</c:choose>--%>
                    <%--</c:otherwise>--%>
                    <%--</c:choose>--%>
                    <%--</p>--%>
                    <%--</c:if>--%>
                    <c:if test="${not empty cmsActivity.activityHost}">
                        <p>
                            主办方：<c:out value="${cmsActivity.activityHost}" escapeXml="true"/>
                        </p>
                    </c:if>
                    <c:if test="${not empty cmsActivity.activityOrganizer}">
                        <p>
                            承办单位：<c:out value="${cmsActivity.activityOrganizer}" escapeXml="true"/>
                        </p>
                    </c:if>
                    <c:if test="${not empty cmsActivity.activityCoorganizer}">
                        <p>
                            协办单位：<c:out value="${cmsActivity.activityCoorganizer}" escapeXml="true"/>
                        </p>
                    </c:if>
                    <c:if test="${not empty cmsActivity.activityPerformed}">
                        <p>
                            演出单位：<c:out value="${cmsActivity.activityPerformed}" escapeXml="true"/>
                        </p>
                    </c:if>
                    <c:if test="${not empty cmsActivity.activitySpeaker}">
                        <p>
                            主讲人：<c:out value="${cmsActivity.activitySpeaker}" escapeXml="true"/>
                        </p>
                    </c:if>
                    费用：<c:if test="${cmsActivity.activityIsFree == 1}">免费</c:if>
                    <c:if test="${cmsActivity.activityIsFree == 2}">
                        <c:choose>
                            <c:when test="${not empty cmsActivity.activityPrice and cmsActivity.activityPrice != 0}">
                                ${cmsActivity.activityPrice}元 ${cmsActivity.priceDescribe}
                            </c:when>
                            <c:otherwise>${cmsActivity.priceDescribe}</c:otherwise>
                        </c:choose>
                    </c:if>
                    <c:if test="${not empty cmsActivity.activityPrompt}">
                        <p>
                            友情提示：<c:out value="${cmsActivity.activityPrompt}" escapeXml="true"/>
                        </p>
                    </c:if>
                </div>

                <div class="download_fj" activityAttachment="${cmsActivity.activityAttachment}">
                </div>
                <div class="shares">
                    <div class="share_l fl">
                        <div class="icon">
			        <span class="bdsharebuttonbox">
			        	<%--<c:if test="${not empty sessionScope.terminalUser}">--%>
				        <a class="zan ${wantdoCount>0?'love':''}" id="zanId" onclick="addWantGo()"><span class="wantgoCount"></span></a>
				        <%--</c:if>--%>
						<a class="share" data-cmd="count" style="margin: 6px 6px 6px 0px"></a>
					 </span>
                            <!--分享代码 start-->
                            <script type="text/javascript">
                                with (document) 0[(getElementsByTagName('head')[0] || body).appendChild(createElement('script')).src = 'http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion=' + ~(-new Date() / 36e5)];
                            </script>
                            <!--分享代码 end-->
                        </div>
                    </div>
                    <div class="share_r fr">
                        <a href="javascript:void(0)"><img src="${path}/STATIC/image/jb_icon.png" width="20"
                                                          height="20"/>举报</a>
                    </div>
                </div>


                <div class="go_head" id="go_head">
                </div>
            </div>
        </div>

        <div class="the_two">
            <div class="comment mt20 clearfix" id="divActivityComment" style="display: block;">
                <a name="comment"></a>
                <div class="comment-tit">
                    <h3>我要评论</h3><span id="commentCount">${commentCount}条评论</span>
                </div>
                <form id="commentForm">

                    <%--            <div class="score-box">
                                  <span class="txt">活动评分</span>
                                  <div class="star-list">
                                    <div class="star-score" id="star-score">
                                      <a class="star1">0.5</a>
                                      <a class="star2">1</a>
                                      <a class="star3">1.5</a>
                                      <a class="star4">2</a>
                                      <a class="star5">2.5</a>
                                      <a class="star6">3</a>
                                      <a class="star7">3.5</a>
                                      <a class="star8">4</a>
                                      <a class="star9">4.5</a>
                                      <a class="star10">5</a>
                                    </div>
                                    <span><em id="score-num">0</em>分</span>
                                    <input type="hidden" name="commentStar" id="activityScore"/>
                                  </div>
                                </div>--%>

                    <input type="hidden" id="tuserId" name="tuserId" value="${teamUser.tuserId}"/>
                    <input type="hidden" id="commentRkId" name="commentRkId" value="${cmsActivity.activityId}"/>
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

    <div class="detail_right fr">
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
                        center: new AMap.LngLat(${cmsActivity.activityLon}, ${cmsActivity.activityLat}),//地图中心点
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

        <div class="recommend video mb20" <c:if test="${fn:length(cmsVideoList)==0}">style="display:none;"</c:if>>
            <div class="tit"><i></i>视频点播</div>
            <ul class="video-list">
                <c:forEach items="${cmsVideoList}" var="video" varStatus="s">
                    <c:if test="${s.index<3}">
                        <li activity-icon-url="${video.videoImgUrl}"
                            onclick="showVideo('${video.videoId}','${cmsActivity.activityId}');">
                            <a class="img"><img src="" width="136" height="100"/><span></span></a>
                            <div class="info">
                                <h3><a><c:out value="${video.videoTitle}" escapeXml="true"/></a></h3>
                            </div>
                        </li>
                    </c:if>
                </c:forEach>
                <script>
                    function showVideo(videoId, activityId) {
                        window.open("${path}/frontActivity/frontActivityVideo.do?videoId=" + videoId + "&activityId=" + activityId);
                    }
                </script>
            </ul>
            <c:if test="${fn:length(cmsVideoList)>3}">
                <a class="load-more" target="_blank"
                   onclick="showVideo('${cmsVideoList[0].videoId}','${cmsActivity.activityId}');">查看更多></a>
            </c:if>
        </div>

        <div class="recommend mb20">
            <div class="tit"><i></i>相关活动推荐</div>
            <ul class="recommend-list">
                <c:forEach items="${cmsActivityList}" var="activity">
                    <li activity-icon-url="${activity.activityIconUrl}">
                        <a target="_blank"
                           href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}"
                           class="img">
                            <img src="" alt="" onload="fixImage(this, 280, 210)"/>
                        </a>
                        <div class="info">
                            <h3><a target="_blank"
                                   href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}">
                                <c:out escapeXml="true" value="${activity.activityName}"/></a></h3>
                            <p title="${fn:split(activity.activityCity, ',')[1]}&nbsp;<c:if test="${fn:split(activity.activityArea, ',')[1] != fn:split(activity.activityCity, ',')[1]}">${fn:split(activity.activityArea, ',')[1]}&nbsp;</c:if><c:out value="${activityAddress}" escapeXml="true"/>">
                                地址：<c:set var="activityAddress" value="${activity.activityAddress}"/>
                                <c:out value="${fn:substring(activityAddress,0,22)}" escapeXml="true"/>
                            </p>
                            <p>时间：
                                    <%--                ${activity.activityStartTime}
                                                    <c:if test="${not empty activity.activityEndTime}">&nbsp;至&nbsp;${activity.activityEndTime}</c:if>--%>

                                <fmt:parseDate value="${activity.activityStartTime}" pattern="yyyy-MM-dd"
                                               var="startTime"/>
                                <fmt:parseDate value="${activity.activityEndTime}" pattern="yyyy-MM-dd" var="endTime"/>
                                <fmt:formatDate value="${startTime}" pattern="yyyy-MM-dd"/>
                                <c:if test="${startTime eq endTime}"></c:if>
                                <c:if test="${not empty endTime && startTime != endTime}">
                                    至 <fmt:formatDate value="${endTime}" pattern="yyyy-MM-dd"/>&nbsp;
                                </c:if>

                            </p>
                        </div>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>
</div>


<!-- 导入尾部文件 -->
<%@include file="/WEB-INF/why/index/footer.jsp" %>

<!-- dialog start -->
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/ui-dialog.css"/>
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
                url: '${path}/frontActivity/activityReportDialog.do?activityId=${cmsActivity.activityId}',
                title: '举报原因',
                width: 420,
                height: 340,
                fixed: true,
                data: $(this).attr("data-name") // 给 iframe 的数据
            }).showModal();
            return false;
        });
    });
    $(function () {
        $('img').each(function () {
            if ($(this).attr('alt') == undefined || $(this).attr('alt') == '') {
                $(this).attr('alt', '文化云');
            }
        });
    });
</script>
<!-- dialog end -->
</body>
</html>