<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head lang="en">
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <!-- <title>投票详情</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/reset-mc.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css"/>
    <script src="${path}/STATIC/js/common.js"></script>
    
    <script>
    	var voteTitel = '${data.voteTitel}';
    	var voteCoverImgUrl = getImgUrl('${data.voteCoverImgUrl}');
    	var voteDescribe = '${data.voteDescribe}';
    	voteDescribe = voteDescribe.length>20?voteDescribe.substring(0,19)+"...":voteDescribe;
    
        $(function () {
	
            //通过config接口注入权限验证配置
            wx.config({
                debug: false,
                appId: '${sign.appId}',
                timestamp: '${sign.timestamp}',
                nonceStr: '${sign.nonceStr}',
                signature: '${sign.signature}',
                jsApiList: ['onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
            });
            wx.ready(function () {
                wx.onMenuShareAppMessage({
                    title: voteTitel,
                    imgUrl: voteCoverImgUrl,
                    desc: voteDescribe,
                    success: function () { 
                    	dialogAlert('系统提示', '分享成功！');
                    }
                });
                wx.onMenuShareTimeline({
                    title: voteTitel,
                    imgUrl: voteCoverImgUrl,
                    success: function () { 
                    	dialogAlert('系统提示', '分享成功！');
                    }
                });
                wx.onMenuShareQQ({
                	title: voteTitel,
                    imgUrl: voteCoverImgUrl,
                    desc: voteDescribe
                });
                wx.onMenuShareWeibo({
                	title: voteTitel,
                    imgUrl: voteCoverImgUrl,
                    desc: voteDescribe
                });
                wx.onMenuShareQZone({
                	title: voteTitel,
                    imgUrl: voteCoverImgUrl,
                    desc: voteDescribe
                });
            });
        	
            var voteId = '${data.voteId}';
            $(".M_vote_con .list li").on("click", "a", function () {
                var userId = window.localStorage.getItem("userId");
                if (!userId) {
                    toast("请先登录!");
                    var reqFrom = '${reqFrom}';
                    if (!reqFrom) {
                        setTimeout(function () {
                            window.location.href = "${path}/muser/login.do?type=${basePath}frontVote/detail.do?dataId=" + voteId;
                            return;
                        }, 1500)
                    }
                    return;
                }
                if ($(this).hasClass("likeme")) {
                    toast("已参与过投票!");
                    return;
                } else {
                    var domEl = $(this);
                    var relateId = $(this).attr("data-id");
                    $.ajax({
                        type: "POST",
                        data: {
                            userId: userId,
                            voteId: voteId
                        },
                        url: "${path}/userVote/isVote.do?" + new Date().getTime(),
                        dataType: "json",
                        success: function (data) {
                            if (data.code === 404) {
                                $.ajax({
                                    type: "POST",
                                    data: {
                                        userId: userId,
                                        voteId: voteId,
                                        voteRelateId: relateId
                                    },
                                    url: "${path}/userVote/addVote.do?" + new Date().getTime(),
                                    dataType: "json",
                                    success: function (res) {
                                        if (res.code === 200) {
                                            domEl.addClass("likeme");
                                            var count = $("#d" + relateId + " ._voteCountClass").html();
                                            $("#d" + relateId + " ._voteCountClass").html(count * 1 + 1);
                                            toast("投票成功")
                                        } else {
                                            toast("已参与过投票!")
                                        }
                                    }
                                });
                            } else {
                                toast("已参与过投票!");
                            }
                        }
                    });
                }
            })
        });
        //加载图片
        $(function () {
            $("#dataList img").each(function () {
                $(this).attr("src", getImgUrl(getIndexImgUrl($(this).attr("data-src"), "_300_300")));
            });
        });

        //显示用户投票
        $(function () {
            var _thisUserId = '${userId}';
            if (_thisUserId) {
                window.localStorage.setItem("userId", _thisUserId);
            }
            var userId = window.localStorage.getItem("userId");
            if (!userId) {
                return;
            }
            $.ajax({
                type: "POST",
                data: {
                    userId: userId,
                    voteId: '${data.voteId}'
                },
                url: "${path}/userVote/isVote.do?" + new Date().getTime(),
                dataType: "json",
                success: function (res) {
                    if (res.code == 200) {
                        var relateId = res.data.voteRelateId;
                        $("#d" + relateId + " a").addClass("likeme");
                    }
                }
            });
        });

        $(function () {
            var reqFrom = '${reqFrom}';
            if (reqFrom) {
                window.localStorage.setItem("reqFrom", reqFrom);
            }
        });

        //后退
        function myBack() {
            var reqFrom = window.localStorage.getItem("reqFrom");
            if (reqFrom) {
                if (reqFrom == "android") {
                    injs.onAndroidBack();
                } else if (reqFrom == "ios") {
                    document.location.href = "objc://runOnIosBack";
                }
            } else {
                window.history.go(-1);
            }
        }

        //分享
        /*    function myShare(){

         var title ='${data.voteTitel}';
         var imgUrl=getImgUrl('${data.voteCoverImgUrl}');
         var des = '${data.voteDescribe}';
         if(des.length>20){
         des=des.substr(0,20);
         }
         var _thisUrl = '${basePath}'+"frontVote/detail.do?dataId="+'${data.voteId}';
         var obj ={
         };
         obj.title=title;
         obj.imgUrl=imgUrl;
         obj.des=des;
         obj.pageUrl=_thisUrl;

         var reqFrom = window.localStorage.getItem("reqFrom");

         if(reqFrom){
         if(reqFrom=="android"){
         injs.onAndroidShare(_thisUrl);
         }else if(reqFrom=="ios"){
         document.location.href="objc://runOnIosShare:/"+JSON.stringify(obj);
         }
         }else{
         //alert("微信分享");
         }
         }*/

        function dialogAlert(title, content, fn){
            if(top.dialog){
                dialog = top.dialog;
            }
            var d = dialog({
                width: 500,
                title:title,
                content:content,
                fixed: true
            });
            d.show();
    	    
    	    setTimeout(function(){
    			d.removeSlow();
    		},1500);
        }

        function toast(txt, fun) {
            var reqFrom = window.localStorage.getItem("reqFrom");
            if (reqFrom) {
                if (reqFrom == "ios") {
                    document.location.href = "objc://runOnIosToast:/" + txt;
                    return;
                } else if (reqFrom == "android") {
                    alert(txt);
                    return;
                }
            }else{
                //微信环境
                dialogAlert("提示",txt);
                return;
            }
            $('.tips-text').remove();
            $('.tips-mask').remove();
            var div = $('<div class="tips-text" style="background-color:rgba(0,0,0,.8);max-width:240px;min-height: 20px;padding:12px 0;position: absolute;left: -1000px;top: -1000px;text-align: center;border-radius:6px;z-index:44;"><span style="color: #fff;line-height: 20px;padding:0 15px; min-height: 20px; dispaly:inline-block; font-size: 14px;">' + txt + '</span></div>');
            $('body').append(div);
            div.css('width', div.find("span").width() + 30);
            div.css('zIndex', 9999999);
            div.css('left', parseInt(($(window).width() - div.width()) / 2));
            var top = parseInt($(window).scrollTop() + ($(window).height() - div.height()) / 2);
            div.css('top', top);
            $('body').append('<div class="tips-mask" style="position:fixed;top:0;left:0;width:100%;height:100%;z-index:33;background-color:rgba(0,0,0,.5);"></div>');
            setTimeout(function () {
                $('.tips-text').fadeOut(300);
                $('.tips-mask').fadeOut(300);
                if (fun) {
                    fun();
                }
            }, 2000);
            $(window).resize(function () {
                $('.tips-text').css('left', parseInt(($(window).width() - $('.tips-text').width()) / 2));
                var top = parseInt($(window).scrollTop() + ($(window).height() - $('.tips-text').height()) / 2);
                $('.tips-text').css('top', top);
            })
            $(".tips-mask,.tips-text").click(function () {
                $('.tips-text').fadeOut(300);
                $('.tips-mask').fadeOut(300);
            });
        }
    </script>
</head>
<body>
	<div class="M_vote_con">
	    <div class="con">
	        <h1>${data.voteTitel}</h1>
	        <p>${data.voteDescribe}</p>
	    </div>
	    <div class="list">
	        <ul id="dataList">
	            <c:forEach items="${data.relateList}" var="t" varStatus="st">
	                <li id="d${t.voteRelevanceId}">
	                    <div class="top">
	                        <img data-src="${t.voteImgUrl}" width="220" height="220">
	                        <div class="num_name clearfix"><span class="num fl">第<em>${st.index+1}</em>名</span></div>
	                        <div class="name">${t.voteContent}</div>
	                        <p><em class="_voteCountClass">${t.voteCount}</em>票</p>
	                    </div>
	                        <%--前三且票数大于0--%>
	                    <c:if test="${st.index<3 && t.voteCount>0}">
	                        <div class="ranking">第${st.index+1}名</div>
	                    </c:if>
	                    <a data-id="${t.voteRelevanceId}" href="javascript:void(0)">投一票</a>
	                </li>
	            </c:forEach>
	        </ul>
	    </div>
	
	</div>
</body>
</html>