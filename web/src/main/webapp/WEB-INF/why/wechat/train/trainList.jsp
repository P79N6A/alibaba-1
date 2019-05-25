<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
	<title>文化培训</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.lazyload.min.js"></script>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/peixun.css" />
	<script type="text/javascript" src="${path}/STATIC/wechat/js/jquery-2.1.4.min.js"></script>
    <script src="${path}/STATIC/js/avalon.js"></script>
	<script type="text/javascript">
        var startIndex = 0;		//页数
		getAppUserId();
        $(function () {
            if(window.injs){
                //分享文案
                appShareTitle = '“文化培训”精彩课程等你报名！';
                appShareDesc = '欢迎进入安康群众文化云·文化培训';
                appShareImgUrl = '${basePath}/STATIC/wx/image/share_120.png';
                appShareLink = '${basePath}wechatTrain/index.do';
                injs.setAppShareButtonStatus(true);
            }
            //loadTrainType();
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
                        title: "“文化培训”精彩课程等你报名！",
                        desc: '欢迎进入安康群众文化云·文化培训',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        success: function () {
                            dialogAlert('系统提示', '分享成功！');
                        }
                    });
                    wx.onMenuShareTimeline({
                        title: "“文化培训”精彩课程等你报名！",
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        success: function () {
                            dialogAlert('系统提示', '分享成功！');
                        }
                    });
                    wx.onMenuShareQQ({
                        title: "“文化培训”精彩课程等你报名！",
                        desc: '欢迎进入安康群众文化云·文化培训',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareWeibo({
                        title: "“文化培训”精彩课程等你报名！",
                        desc: '欢迎进入安康群众文化云·文化培训',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareQZone({
                        title: "“文化培训”精彩课程等你报名！",
                        desc: '欢迎进入安康群众文化云·文化培训',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                });
            }
            $("#loadingDiv").show();
			loadDate(0,20);
        });

        var loadDataLock = true;
        //滑屏分页
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 100)) {
                if(loadDataLock){
					loadDataLock = false;
                    startIndex += 20;
                    var index = startIndex;
                    setTimeout(function () {
                        loadDate(index, 20);
                    },1000);
                }
            }
        });

        function loadDate (index, pagesize) {
            $("#loadingDiv").show();
            var nowIndex = index;
            $.post("${path}/wechatTrain/trainList.do", {
                pageIndex: index,
                pageNum: pagesize,
				trainArea:$('#trainLocation').val(),
				trainType:$('#trainType').val(),
				order:$('#order').val(),
				userId:userId
            }, function (data) {
                $("#loadingDiv").hide();
                if (data.status == 0) {
					var html = "";
					console.log("length====" + data.data.length);
                    if(data.data.length < 1 && nowIndex == 0){
                        $(".peixunList").html('<img style="display: block;position: absolute; top: 0;right: 0;bottom: 0;left: 0; margin: auto;" src="${path}/STATIC/wechat/image/dl-px/kong.png" />');
                        return;
                    }
                    var now = '${now}'
                    for(var i=0;i<data.data.length;i++){
                        var obj = data.data[i];
                        //var tag = obj.trainTag.substring(start,',');
                        html +='<li>' +
                            '<div class="pic" d-id="'+obj.id+'">' +
							'<div class="shadow"></div>'+
                            '<img src="'+data.data[i].trainImgUrl+'" />';
                        html +='<div class="pxLabel clearfix">';
                        var tag;
                        if(data.data[i].trainTag.indexOf(",")>-1){
                            var tag = data.data[i].trainTag.split(",")[0];
                        }else{
                            tag = data.data[i].trainTag;
                        }
                        html +='<span>'+tag+'</span></div>'+
							'<div class="culInfo">'+
                        '<div class="title">'+data.data[i].trainTitle+'</div>' ;
                        if(now <= obj.registrationEndTime){
                            if(obj.maxPeople != null && obj.maxPeople > 0){
                                html += '<div class="people"><i>'+obj.admissionsPeoples+'</i>/'+obj.maxPeople+'人</div>';
                            }else{
                                html += '<div class="people"><i>'+obj.admissionsPeoples+'</i>人</div>';
                            }
                        }

                        html += '</div>';


                       /* $(obj.trainTag.split(',')).each(function(i,n){
                            html +='<span>'+n+'</span>'
                        });*/

                        html +='</div>';
                        var registrationStartTime = obj.registrationStartTime.replace(/-/g,'.');
                        var registrationEndTime = obj.registrationEndTime.replace(/-/g,'.');
                        var trainStartTime = obj.trainStartTime.replace(/-/g,'.');
                        var trainEndTime = obj.trainEndTime.replace(/-/g,'.');

                        html +='<div class="culMsg">'+
							'<div d-id="'+obj.id+'" class="char">' +
                            '<div class="time">报名时间：'+registrationStartTime+' - '+registrationEndTime+'</div>' +
                            '<div class="time">开课时间：'+trainStartTime+' - '+trainEndTime+'</div>' +
                            '</div>' ;
                            //'<div id="bottBox" d-id="'+obj.id+'" class="bottBox">';
							//html += '<div class="colImg"></div>';
                        if(obj.isCollect==1){
                            html += '<div id="bottBox" d-id="'+obj.id+'" class="bottBox bottBoxChoose">';
                            html += '<div class="colImg"></div>';
                            html += '<div class="collect">已收藏</div></div>';
                        }else{
                            html += '<div id="bottBox" d-id="'+obj.id+'" class="bottBox">';
                            html += '<div class="colImg"></div>';
                            html += '<div class="collect">收藏</div></div>';
                        }

							html += '</div>';

                            '</li>';
					}
					if(index==0){
                        $(".peixunList").html(html);
					}else{
                    	$(".peixunList").append(html);
					}

                    $(".peixunList li .pic,.peixunList li .char").on('click',function () {
						location.href='${path}/wechatTrain/trainDetail.do?id='+$(this).attr('d-id')+"&userId="+userId;
                    })
                    $(".peixunList li .bottBox").on('click',function () {
                        collect(this)
                    })
                }
                loadDataLock = true;
            }, "json");
		}

        function loadTrainType() {
           /*var html = "";
            $.post("${path}/tag/getChildTagByType.do?code=TRAIN_TYPE", function (data) {
                var list = eval(data);
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    html +='<div v="' + obj.tagId + '" class="item clearfix">';
                    html +='<div class="mz">' + obj.tagName + '</div>';
                    html +='</div>';
                }
                $("#type").append(html);
            });*/

/*            $.post("../tag/getCommonTag.do?type=10", function (data) {
                var html = "";
                var list = eval(data);
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    html +='<div v="' + obj.tagName + '" class="item clearfix">';
                    html +='<div class="mz">' + obj.tagName + '</div>';
                    html +='</div>';
                }
                $("#type").append(html);
            })*/
        }

        function collect(obj){
            if (userId == null || userId == '') {
                publicLogin('${basePath}wechatTrain/index.do');
                return;
            }
            var relateId = $(obj).attr('d-id');
            console.log($(obj));
            if($(obj).hasClass('bottBoxChoose')){
                $.post("${path}/wechat/wcDelCollect.do", {
                    relateId: relateId,
                    userId: userId,
                    type: 2,
                }, function (data) {
                    if (data.status == 0) {
                        $(obj).removeClass('bottBoxChoose')
                        $(obj).find(".collect").html('收藏')
                        //dialogAlert("收藏提示", "已取消收藏！");
                    }
                }, "json");

            }else{
                $.post("${path}/wechat/wcCollect.do", {
                    relateId: relateId,
                    userId: userId,
                    type: 2,
                }, function (data) {
                    if (data.status == 0) {
                        $(obj).addClass('bottBoxChoose')
                        $(obj).find(".collect").html('已收藏')
                        //dialogAlert("收藏提示", "收藏成功！");
                    }
                }, "json");
            }
        }
	</script>
    <style>
    	html,body,.main{height:100%;background-color:#f3f3f3}
        .content {padding-top: 100px;padding-bottom: 18px;}
    </style>
</head>
<body>
<div class="main">
	<div class="pxFilterWc">
		<div class="pxFilter">
			<ul class="shaiBox clearfix">
				<li>类型<em></em><i class="x"></i></li>
				<li>区域<em></em><i class="x"></i></li>
				<li>排序<em></em><i class="x"></i></li>
			</ul>
			<div class="shaiErjiWc">
				<div class="shaiErji" id="type">
					<input type="hidden" id="trainType"/>
					<div class="item clearfix cur" v="">
						<div class="mz">全部</div>
					</div>
					<c:forEach items="${tagList}" var="tag">
						<div v="${tag.tagId}" class="item clearfix">
							<div class="mz">${tag.tagName}</div>
						</div>
					</c:forEach>
				</div>
				<div class="shaiErji" id="area">
					<input type="hidden" id="trainLocation"/>
					<div class="item clearfix cur" v="">
						<div class="mz">全部</div>
					</div>
					<div v="be4cb27979a845c1b42153adc442b117" class="item clearfix">
						<div class="mz">安康</div>
					</div>
					<c:forEach items="${deptList}" var="dept">
						<div v="${dept.deptId}" class="item clearfix">
							<div class="mz">${dept.deptName}</div>
						</div>
					</c:forEach>
				</div>
				<div class="shaiErji">
					<input type="hidden" id="order"/>
					<div class="item clearfix cur" v="">
						<div class="mz">全部</div>
					</div>
					<div class="item clearfix" v="1">
						<div class="mz">智能排序</div>
					</div>
					<div class="item clearfix" v="2">
						<div class="mz">最新发布</div>
					</div>
					<div class="item clearfix" v="3">
						<div class="mz">即将开始</div>
					</div>
					<div class="item clearfix" v="4">
						<div class="mz">即将结束</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="picLists">
		<ul class="peixunList">

		</ul>
	</div>
	<div id="loadingDiv" style="display: none;" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
</div>
	<script type="text/javascript">

        $(function () {
            $('.pxFilter .shaiBox').on('click', 'li', function () {
                $(this).siblings('li').removeClass('cur');
                if($(this).hasClass('cur')) {
                    $(this).removeClass('cur');
                    $('.pxFilter .shaiErjiWc').hide();
                } else {
                    $(this).addClass('cur');
                    $('.pxFilter .shaiErjiWc').show();
                }
                $('.pxFilter .shaiErjiWc .shaiErji').hide();
                $('.pxFilter .shaiErjiWc .shaiErji').eq($(this).index()).show();
            });
            $('.pxFilter .shaiErji').on('click', '.item', function () {
                $(this).addClass('cur').siblings('.item').removeClass('cur');
                var v = $(this).attr('v');
                $(this).parent().find('input').val(v);
                loadDate(0,20);

                $('.pxFilter .shaiBox li.cur').html($(this).find('.mz').html()+"<em></em><i class=\"x\"></i>");

                $('.pxFilter .shaiBox li').removeClass('cur');
                $('.pxFilter .shaiErjiWc').hide();



            });
            $('.pxFilter').on('click touchstart', function (e) {
                e = e || e.event;
                e.stopPropagation();
            });
            $('html, body').on('click touchstart', function () {
                $('.pxFilter .shaiBox li').removeClass('cur');
                $('.pxFilter .shaiErjiWc').hide();
            });

            //春秋季弹窗点击
            $('.kindsUl').on('click', 'li', function () {
                $(this).addClass('cur').siblings('li').removeClass('cur');
                $('.course .course_num').hide();
                $('.course .course_num').eq($(this).index()).show();
            });

            $(".know").click(function(){
                $(".alertWindow").hide();
            })
        });
	</script>
</body>
</html>