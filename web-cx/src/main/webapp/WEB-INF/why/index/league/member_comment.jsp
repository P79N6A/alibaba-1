<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" pageEncoding="UTF-8" %>

<div class="unionComWrite">

 <form id="commentForm">
    <input type="hidden" name="commentRkId" value="${member.id}"/>
    <input type="hidden" id="commentRkName" name="commentRkName" value=""/>
    <input type="hidden" id="commentType" name="commentType" value="21"/>
    <input type="hidden" id="commentImgUrl" name="commentImgUrl" value=""/>
    <div class="wTit">全部评论 ${page.total}条</div>
    <textarea class="txtArea" name="commentRemark" id="commentRemark" maxLength="200"></textarea>
    <div class="clearfix" style="margin-top: 20px;">
        <div class="wBtnRed" onclick="addComment()">发布</div>

        <div class="wShangBox clearfix">
            <div class="wBtnGray" onclick="$('.wUploadDiv').toggle()">选择图片</div>
            <div class="wUploadDiv">
                <span class="sjx"></span>
                <div class="tit">限传图片9张</div>
                <div id="webUpload" class="uploadBoxPop clearfix">
                    <div id="ossfile"></div>
                    <div id="container" style="position: relative;">
                        <button id="selectfiles" href="javascript:void(0);" class="uploadBtn" style="position: relative; z-index: 1;"></button>
                        <div id="html5_1cfrium9o1fd0kkjc2pd7b1tlr4_container" class="moxie-shim moxie-shim-html5" style="position: absolute; top: 0px; left: 0px; width: 0px; height: 0px; overflow: hidden; z-index: 0;">
                            <input id="html5_1cfrium9o1fd0kkjc2pd7b1tlr4" type="file" style="font-size: 999px; opacity: 0; position: absolute; top: 0px; left: 0px; width: 100%; height: 100%;" multiple="" accept="" tabindex="-1"></div></div>
                </div>
            </div>
        </div>

    </div>
 </form>
</div>

<div class="unionComList">
    <c:forEach items="${list}" var="comment">
    <div class="item clearfix">
        <div class="topBox clearfix">
            <div class="avatar">
                <c:if test="${empty comment.userHeadImgUrl}">
                    <c:choose>
                        <c:when test="${comment.userSex==1}">
                            <img src="${path}/STATIC/image/face_boy.png">
                        </c:when>
                        <c:when test="${comment.userSex==2}">
                            <img src="${path}/STATIC/image/face_girl.png">
                        </c:when>
                        <c:otherwise>
                            <img src="${path}/STATIC/image/face_secrecy.png">
                        </c:otherwise>
                    </c:choose>
                </c:if>
                <c:if test="${not empty comment.userHeadImgUrl}">
                        <img class="userHeadImg" data-src="${comment.userHeadImgUrl}">
                </c:if>
            </div>
            <div class="char">
                <div class="name">${comment.commentUserName}</div>
                <div class="time"><fmt:formatDate value="${comment.commentTime}" pattern="yyyy-MM-dd HH:mm:ss"/> </div>
            </div>
        </div>
        <div class="cont">
            ${comment.commentRemark}
        </div>
        <div class="picListWc">
            <c:if test="${not empty comment.commentImgUrl}">
            <ul class="picList clearfix">
                <c:forEach items="${comment.commentImgUrl.split(';')}" var="img">
                    <li><img src="${img}"></li>
                </c:forEach>
            </ul>
            </c:if>
        </div>
    </div>
    </c:forEach>
    <c:if test="${fn:length(list) gt 10}">
        <input type="hidden" id="page" name="page" value="${page.page}" />
        <div id="kkpager" ></div>
    </c:if>
</div>


<script type="text/javascript">
    $(function () {
        $('.unionOrderNavOne').on('click', 'span', function () {
            $(this).addClass('cur').siblings().removeClass('cur');
            $('.diandanWc .unionUlList-san').hide();
            $('.diandanWc .unionUlList-san').eq($(this).index()).show();
        });
        
        $(".userHeadImg").each(function () {
            var userHeadImgUrl = $(this).attr('data-src');
            if(userHeadImgUrl.indexOf("http")==-1){
                userHeadImgUrl = getUserImgUrl(userHeadImgUrl);
            }
            $(this).attr('src',userHeadImgUrl);
        })
    });

    $(function(){
        kkpager.generPageHtml({
            pno : '${page.page}',
            total : '${page.countPage}',
            totalRecords :  '${page.total}',
            mode : 'click',//默认值是link，可选link或者click
            isShowFirstPageBtn	: true, //是否显示首页按钮
            isShowLastPageBtn	: true, //是否显示尾页按钮
            isShowPrePageBtn	: true, //是否显示上一页按钮
            isShowNextPageBtn	: true, //是否显示下一页按钮
            isShowTotalPage 	: false, //是否显示总页数
            isShowCurrPage		: false,//是否显示当前页
            isShowTotalRecords 	: false, //是否显示总记录数
            isGoPage 			: false,	//是否显示页码跳转输入框
            click : function(n){
                $("#page").val(n);
                $("#content_div").load("../member/memberComment.do?id=${member.id}&rows=10&page="+n,function () {
                });
                return false;
            }
        });
    });

    $(function () {
        /*
         * uploadDomId 上传ID，默认为webUpload
         * fileFormat 格式限制，默认不限制，参数为字符串逗号分割
         * upLoadSrc 上传径，默认为H5文件夹
         * fileNum 上传数量限制，默认为false，不限制
         * callBackFunc 上传回调函数，默认无回调
         * progressBar 进度条显示，默认为不显示 false
         * fileSize 文件大小限制，默认不限制
         * imgPreview 预览图，默认没有
         * callBackFunc 报错回调
         *
         * */
        aliUpload({
            uploadDomId: 'webUpload',
            fileNum: 9,
            progressBar: false,
            callBackFunc: function (up, file, fileName) {
                //$("#commentImgUrl").val($("#commentImgUrl").val()+'http://culturecloud.img-cn-hangzhou.aliyuncs.com/' + fileName+";");
                app.form.marketImgUrl = 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/' + fileName;
            },
            imgPreview: true,
            upLoadSrc: "H5",
            /*fileSize:'1kb',*/
        });

        $('html,body').on('click', function () {
            $('.wUploadDiv').hide();
        });
        $('.wShangBox').on('click', function (evt) {
            setStopPropagation(evt)
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
        var img = "";
        $("#ossfile .upload-img-identify").each(function (index) {
            img += $(this).attr("src")+";";
        })
            $("#commentImgUrl").val(img);

        var headImgUrl = $("#commentImgUrl").val();
        if (headImgUrl != "") {
            if (headImgUrl.lastIndexOf(";") == headImgUrl.length - 1) {
                var url = headImgUrl.substring(0, headImgUrl.lastIndexOf(";"));
                $("#commentImgUrl").val(url);
            }
        }
        $("#commentRkName").val($("#memberName").val());
        $.ajax({
            type: "post",
            url: "${path}/comment/addComment.do",
            data: $("#commentForm").serialize(),
            dataType: "json",
            cache: false,//缓存不存在此页面
            async: false,//异步请求
            success: function (result) {
                if (result == "success") {
                    dialogAlert("提示", "评论成功!");
                    $("#content_div").load("../member/memberComment.do?id=${member.id}&page=1",function () {
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


</script>
