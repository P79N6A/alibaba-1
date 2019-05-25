<%@ page import="org.apache.commons.lang3.StringUtils ,com.sun3d.why.model.CmsTerminalUser" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    String userId = "";
    if (session.getAttribute("terminalUser") != null) {
        CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
        userId = terminalUser.getUserId();
        if (StringUtils.isNotBlank(terminalUser.getUserId())) {
            userId = terminalUser.getUserId();
        } else {
            userId = "";
        }
    }
%>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!-- 导入头部文件 start -->
    <meta charset="UTF-8">
    <%@include file="/WEB-INF/why/common/frontPageFrame.jsp" %>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css"/>
    <title>${cmsActivity.activityName}${listL}_更多免费活动_品质生活-文化云</title>
    <meta name="Keywords" content="${cmsActivity.activityName}、地址、时间、电话、公交、简介、免费、免费预订、免费参与">
    <style>
        .basicDiv{
            width:1200px;
            height:400px;
            margin:0 auto 20px;
            background-color: #fff;
        }
        .volunteerImg{
            float:left;
            height:392px;
            width:490px;
            margin-right:40px;
            border:1px solid #C0EBEF;
        }
        .volunteerDetails{
            float:left;
            height:392px;
            width:620px;
            margin-right:20px;
        }
        .volunteerTitle{
            margin:20px;
        }
        .volunteerDetail{
            margin:30px 20px 20px 20px;
        }
        .volunteerDetail p{
            color:#766e6e;
            margin-bottom:15px;
            font-size: 15px;
        }
        .volunteerDetail a{

        }
        .sign{
            float:left;
            margin-right:20px;
            margin-left:20px;
            width:100px;
            height:30px;
            line-height:30px;
            text-align:center;
            border:1px solid #00a0e9;
            background-color:#00a0e9;
            margin-top:15px;
            border-radius: 5%;
        }
        .otherInform{
            width:100%;
            height:auto;
            margin:0 auto 20px;
            background-color: #fff;
        }
        .otherInform .tabBtn{
            width:100%;
            height:50px;
            border-bottom: 1px solid #c0c0c0;
        }
        .tabMenu li{
            float:left;
            line-height:30px;
            font-size:20px;
            padding:10px;
            cursor: pointer;
        }
        .tabMenu .cur{
            /*border:1px solid #00a0e9;*/
            color:#00a0e9;
        }
        .tabContent{
            padding:10px;
        }
        .tabContent p{
            line-height:20px;
        }
        .volunteerComment{
            width:100%;
            height:200px;
            background-color: #fff;
        }
        .commentBtn{
            margin-left:20px;
            width:100px;
            height:30px;
            line-height:30px;
            text-align:center;
            border:1px solid #00a0e9;
            background-color:#00a0e9;
            margin-top:10px;
            margin-bottom:20px;
            border-radius: 5%;
            float:right;
            margin-right:100px;
        }
        .xqdiv{
            height:auto;
            padding:20px;
        }
        .documentorydiv{
            height:auto;
            padding:20px;
        }
        .annexdiv{
            height:auto;
            padding:20px;
        }
        .showDocumentImg{
            width:300px;
            height:350px;
            text-align: center;
        }
        .showDocumentImg img{
            width:100%;
            height:300px;
        }
        .showDocumentImg audio{
            width:100%;
            height:300px;
        }
        .showDocumentImg video{
            width:100%;
            height:300px;
        }
        .showDocumentImg p{
            width:100%;
            line-height:50px;
        }
    </style>
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
<div class="main">
    <c:set var="volunteerActivity" value="${volunteerActivity}"></c:set>
    <div class="basicDiv">
        <div class="volunteerImg">
            <img style="width:100%;height:100%" src="${volunteerActivity.picUrl}"/>
        </div>
        <div class="volunteerDetails">
            <div class="volunteerTitle">
                <h1>${volunteerActivity.name}</h1>
            </div>
            <div class="volunteerDetail">
                <p>时间：<fmt:formatDate value="${volunteerActivity.startTime}" pattern="yyyy-MM-dd HH:mm:ss" />
                    <c:if test="${volunteerActivity.startTime != volunteerActivity.endTime&&not empty volunteerActivity.endTime}">
                        至 <fmt:formatDate value="${volunteerActivity.endTime}" pattern="yyyy-MM-dd HH:mm:ss" />
                    </c:if>
                </p>
                <p>地址：${volunteerActivity.address}</p>
                <p>电话：${volunteerActivity.phone}</p>
                <p>报名条件：
                    <c:if test="${volunteerActivity.recruitObjectType == null}">
                        <a style="border:1px solid #00a0e9">个人</a>
                    </c:if>
                    <c:if test="${volunteerActivity.recruitObjectType == 1&&not empty volunteerActivity.recruitObjectType}">
                        <a style="border:1px solid #00a0e9">个人</a>
                    </c:if>
                    <c:if test="${volunteerActivity.recruitObjectType == 2&&not empty volunteerActivity.recruitObjectType}">
                        <a style="border:1px solid #00a0e9">团队</a>
                    </c:if>
                </p>
                <p>预计服务时长：${volunteerActivity.serviceTime}小时</p>
                <%--<p>招募人数：${volunteerActivity.limitNum}</p>--%>
            </div>
            <input id="one" type="hidden" value=""/>
            <input id="our" type="hidden" value=""/>
            <c:if test="${volunteerActivity.recruitmentStatus==1&&volunteerActivity.recruitObjectType == null}">
                <div class="sign">
                    <a>个人报名</a>
                </div>
                <div class="sign">
                    <a>团队报名</a>
                </div>
            </c:if>
            <c:if test="${volunteerActivity.recruitmentStatus==1&&volunteerActivity.recruitObjectType == 1&&not empty volunteerActivity.recruitObjectType}">
                <div class="sign">
                    <a>个人报名</a>
                </div>
            </c:if>
            <c:if test="${volunteerActivity.recruitmentStatus==1&&volunteerActivity.recruitObjectType == 2&&not empty volunteerActivity.recruitObjectType}">
                <div class="sign">
                    <a>团队报名</a>
                </div>
            </c:if>


            <div style="padding:20px;"  class="bdsharebuttonbox" data-tag="share_1">
                <a class="share" data-cmd="count">分享</a>
                <!--分享代码 start-->
                <script type="text/javascript">
                    with (document) 0[(getElementsByTagName('head')[0] || body).appendChild(createElement('script')).src = 'http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion=' + ~(-new Date() / 36e5)];
                </script>
                <!--分享代码 end-->
            </div>
        </div>
    </div>
    <div class="otherInform">
        <div class="tabBtn">
            <ul class="tabMenu">
                <li class="cur">活动详情<li>
                <li>相关纪实<li>
                <li>相关附件<li>
            </ul>
        </div>
        <%--<hr style="width:1200px;size:2px;color:#c0c0c0"/>--%>
        <div class="tabContent">
            <div class="xqdiv">
                <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${volunteerActivity.description}</p>
            </div>
            <div class="documentorydiv" style="display:none">
                <span id="noJishi" style="color:red">
                    暂无相关纪实!
                </span>
                <%--<div class="showDocumentImg">
                    <img src=""/>
                    <p>照片名字</p>
                </div>
                <div class="showDocumentImg">
                    <video src="" controls="controls">
                        您的浏览器不支持 video 标签。
                    </video>
                    <p>视频名字</p>
                </div>
                <div class="showDocumentImg" >
                    <audio src="" controls="controls">
                        您的浏览器不支持 audio 标签。
                    </audio>
                    <p>音频名字</p>
                </div>--%>

            </div>
            <div class="annexdiv" style="display:none">
                <c:choose>
                    <c:when test="${not empty volunteerActivity.attachment}">
                        <a style="color:green" href="{volunteerActivity.attachment}" download="">点击下载附件</a>
                    </c:when>
                    <c:otherwise>
                        <span style="color:red">
                          暂无相关附件!
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    <div class="volunteerComment">
        <form id="commentForm">
            <div style="padding:40px">
                <input type="hidden" id="tuserId" name="tuserId" value="<%=userId%>"/>
                <input type="hidden" id="commentRkId" name="commentRkId" value="${volunteerActivity.uuid}"/>
                <textarea rows="3" name="commentRemark" style="width:1000px;" id="commentRemark" maxlength="200"></textarea>
            </div>
            <div class="commentBtn">
                <a onclick="addComment()">发表评论</a>
            </div>
        </form>
    </div>
</div>
<script>
    var userId=$("#tuserId").val();
    $("#volunteerRecruitIndex").addClass('cur').siblings().removeClass('cur');
    function addComment() {

        if (userId == null || userId == '') {
            dialogAlert("评论提示", "登录之后才能评论");
            return;
        }
        /*var status = '${sessionScope.terminalUser.commentStatus}';
        if (parseInt(status) == 2) {
            dialogAlert("评论提示", "您的账户已被禁止评论，没有评论权限");
            return;
        }*/
        var commentRemark = $("#commentRemark").val();
        if (commentRemark == undefined || $.trim(commentRemark) == "") {
            dialogAlert("评论提示", "输入评论内容");
            return;
        }

        /*var headImgUrl = $("#headImgUrl").val();
        if (headImgUrl != "") {
            if (headImgUrl.lastIndexOf(";") == headImgUrl.length - 1) {
                var url = headImgUrl.substring(0, headImgUrl.lastIndexOf(";"));
                $("#headImgUrl").val(url);
            }
        }*/

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
                    dialogAlert("提示", "评论成功");
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


    //报名
    $(".sign").click(function(){
        var userId=$("#tuserId").val();
        if(userId==""||userId==null){
            dialogAlert("提示", '登录之后才能报名', function () { });
            return;
        }

        var volunteerActivityId=$("#commentRkId").val();
        type=$(this).find("a").html();
        var uuid="";
        var uuid1="";
        $.post("${path}/newVolunteer/queryNewVolunteerListByUserId.do?userId="+userId,function (data) {
            if(data.length==0){
                dialogAlert("提示信息","您还不是志愿者",function(){
                    return;
                })
            }
            uuid=data[0].uuid;//个人
            data0=data[0];
            // uuid1=data[1].uuid;//团队
            //data1=data[1];
            uuid1="";
            if(uuid!=""||uuid!=null||uuid!=undefined){
                $("#one").val(uuid);
            }
            if(uuid1!=""||uuid1!=null||uuid1!=undefined){
                $("#our").val(uuid1);
            }
            if(type=="个人报名"){
                var one=$("#one").val();
                if(one==""){
                    dialogAlert("提示信息","不是个人志愿者")
                    return;
                }
                $.post("${path}/newVolunteerActivity/inNewVolunteerActivityJson.do",{"volunteerActivityId":volunteerActivityId,"volunteerId":uuid},function (data) {
                    if(data.status==200){
                        dialogAlert("信息","加入志愿者成功",function(){
                            location.href="${path}/volunteer/volunteerRecruitIndex.do"
                        })
                    }
                });
            }
            if(type=="团队报名"){
                var our=$("#our").val();
                if(our==""){
                    dialogAlert("提示信息","不是团队志愿者")
                    return;
                }
                $.post("${path}/newVolunteerActivity/inNewVolunteerActivityJson.do",{"volunteerActivityId":volunteerActivityId,"volunteerId":uuid1},function (data) {
                    if(data.status==200){
                        dialogAlert("信息","加入志愿者成功",function(){
                            location.href="${path}/volunteer/volunteerRecruitIndex.do"
                        })
                    }
                });
            }

        });
    });
    /*function signDetail(type,data){
        alert(data)
        $.post("${path}/newVolunteer/addNewVolunteer.do",{"volunteerActivityId":data.uuid,"volunteerId"},function (data) {

        });
    }*/
    //相关纪实
    $(".tabMenu li").click(function(){
        $(this).addClass('cur').siblings().removeClass('cur');
        var clickText=$(this).html();
        if(clickText=="活动详情"){
            $(".xqdiv").show();
            $(".xqdiv").siblings().hide();
        }
        if(clickText=="相关纪实"){
            /*<div class="showDocumentImg">
                    <img src=""/>
                    <p>照片名字</p>
                    </div>
                    <div class="showDocumentImg">
                    <video src="" controls="controls">
                    您的浏览器不支持 video 标签。
            </video>
                <p>视频名字</p>
                </div>
                <div class="showDocumentImg" >
                    <audio src="" controls="controls">
                    您的浏览器不支持 audio 标签。
            </audio>
                <p>音频名字</p>
                </div>*/
            //获取纪实
            //VolunteerActivityDemeanorDocumentary/Documentarylist.do
            var ownerId=$("#commentRkId").val();
            $.post("${path}/VolunteerActivityDemeanorDocumentary/Documentarylist.do?ownerId="+ownerId, function (data) {
                    if(data.status==0){
                        if(data.length==0){
                            return;
                        }
                        var str="";
                        $(".documentorydiv").empty()
                        $.each(data.data,function(i,dom){
                            //:1:图片，2:视频，3:音频',
                            if(dom.resourceType="1"){
                                str+='<div class="showDocumentImg"><img src="'+dom.resourceSite+'"><p>'+dom.resourceName+'</p></div>'
                            }else if(dom.resourceType="2"){
                                str+='<div class="showDocumentImg"><video src="'+dom.resourceSite+'" controls="controls"></video><p>'+dom.resourceName+'</p></div>'
                            }else if(dom.resourceType="3"){
                                str+='<div class="showDocumentImg"><audio src="'+dom.resourceSite+'" controls="controls"></audio><p>'+dom.resourceName+'</p></div>'
                            }
                        });
                        $(".documentorydiv").append(str);
                    }
                }
            );

            $(".documentorydiv").show();
            $(".documentorydiv").siblings().hide();
        }
        if(clickText=="相关附件"){
            $(".annexdiv").show();
            $(".annexdiv").siblings().hide();
        }
    });
</script>
<!-- 导入尾部文件 -->
<%@include file="/WEB-INF/why/index/footer.jsp" %>

<!-- dialog start -->
</body>
</html>