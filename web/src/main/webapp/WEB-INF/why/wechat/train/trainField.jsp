<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
	<title>课程表</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.lazyload.min.js"></script>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/peixun.css" />

    <script src="${path}/STATIC/js/avalon.js"></script>
	<script type="text/javascript">
        var startIndex = 0;		//页数
        $(function () {
            //判断是否是微信浏览器打开
            if (is_weixin()) {
                //通过config接口注入权限验证配置
                wx.config({
                    debug: false,
                    appId: '${sign.appId}',
                    timestamp: '${sign.timestamp}',
                    nonceStr: '${sign.nonceStr}',
                    signature: '${sign.signature}',
                    jsApiList: ['getLocation','onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
                });
                wx.ready(function () {
                    wx.onMenuShareAppMessage({
                        title: "我在“安康群众文化云”发现一大波文化活动，快来和我一起预订吧！",
                        desc: '汇聚安康最全文化活动',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        success: function () {
                            dialogAlert('系统提示', '分享成功！');
                        }
                    });
                    wx.onMenuShareTimeline({
                        title: "我在“安康群众文化云”发现一大波文化活动，快来和我一起预订吧！",
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        success: function () {
                            dialogAlert('系统提示', '分享成功！');
                        }
                    });
                    wx.onMenuShareQQ({
                        title: "我在“安康群众文化云”发现一大波文化活动，快来和我一起预订吧！",
                        desc: '汇聚安康最全文化活动',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareWeibo({
                        title: "我在“安康群众文化云”发现一大波文化活动，快来和我一起预订吧！",
                        desc: '汇聚安康最全文化活动',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareQZone({
                        title: "我在“安康群众文化云”发现一大波文化活动，快来和我一起预订吧！",
                        desc: '汇聚安康最全文化活动',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                });
            } else {
                loadDate(0,20);
            }
        });


        //滑屏分页
        $(window).on("scroll", function () {
            $("#loadingDiv").show();
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 100)) {
                startIndex += 20;
                var index = startIndex;
                setTimeout(function () {
                    loadDate(index, 20);
                },1000);
            }
        });

        function loadDate (index, pagesize) {
            $.post("${path}/wechatTrain/trainList.do", {
                pageIndex: index,
                pageNum: pagesize
            }, function (data) {
                $("#loadingDiv").hide();
                if (data.status == 0) {
					var html = "";
					console.log(data.data.length);
                    for(var i=0;i<data.data.length;i++){
                        var obj = data.data[i];
                        var tags = obj.trainTag;
                        html +='<li id="'+obj.id+'">' +
                            '<div class="pic">' +
                            '<img src="'+data.data[i].trainImgUrl+'" />';
                        html +='<div class="pxLabel clearfix">';

                        $(obj.trainTag.split(',')).each(function(i,n){
                            html +='<span>'+n+'</span>'
                        });

                        html +='</div></div>';
                        html +='<div class="char">' +
                            '<div class="tit">'+data.data[i].trainTitle+'</div>' +
                            '<div class="time">'+data.data[i].registrationStartTime+'—'+data.data[i].registrationEndTime+'（报名时间）</div>' +
                            '<div class="time">'+data.data[i].trainStartTime+'—'+data.data[i].trainEndTime+'（开课时间）</div>' +
                            '</div>' +
                            '<div class="bottBox clearfix">';
                        html +='<div class="collect">收藏</div>';
                        html +='<div class="people"><i>'+obj.admissionsPeoples+'</i>/'+obj.maxPeople+'人</div>' +
                            '</div>' +
                            '</li>';
					}
                    $(".peixunList").append(html);
                    $(".peixunList li").on('click',function () {
						location.href='${path}/wechatTrain/detail.do?id='+$(this).attr('id');
                    })
                }
            }, "json");
		}

	</script>
	<style type="text/css">
		html, body {
			height: 100%;
			background-color: #ededed;
		}
		.main {
			width: 750px;
			min-height: 100%;
			margin: 0 auto;
		}
	</style>
</head>
<body>
<div class="main">
	<c:forEach items="${fields}" var="field">
		<table class="px-courseTab">
			<tr>
				<td class="td1" rowspan="${fn:length(field.times)}">
						${fn:substring(field.dateStr,0,4)}<br>${fn:substring(field.dateStr,5,12)}
				</td>
				<td class="td2"><div class="wz ${field.times[0].flag==0?'':'gray'}">${field.times[0].str}</div></td>
			</tr>

			<c:forEach items="${field.times}" begin="1" end="${fn:length(field.times)}" var="time">
				<tr>
					<td class="td2"><div class="wz ${time.flag==0?'':'gray'}">${time.str}</div></td>
				</tr>
			</c:forEach>
		</table>

	</c:forEach>
</div>
</body>
<script type="text/javascript">

</script>
</html>