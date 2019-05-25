<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>培训订单</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.lazyload.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/peixun.css"/>
    <link rel="stylesheet" href="${path}/STATIC/wechat/css/iosSelect.css"/>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/iscroll.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/iosSelect.js"></script>

    <script src="${path}/STATIC/js/avalon.js"></script>
    <script type="text/javascript">
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
                    jsApiList: ['getLocation', 'onMenuShareAppMessage', 'onMenuShareTimeline', 'onMenuShareQQ', 'onMenuShareWeibo', 'onMenuShareQZone']
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
            }
        });
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
    <div class="pxFilterWc">
        <div class="pxFilter">
            <input type="hidden" id="queryType" value="1"/>
            <ul class="shaiBox clearfix">
                <li class="cur" data-v="1" style="width: 50%;">当前培训<i class="x"
                                                                      style="width: 200px;margin-left: -100px;"></i>
                </li>
                <li style="width: 50%;" data-v="2">历史培训<i class="x" style="width: 200px;margin-left: -100px;"></i></li>
            </ul>
        </div>
    </div>
    <ul class="pxOrderList">
    </ul>
    <div id="loadingDiv" class="loadingDiv" style=""><img class="loadingImg"
                                                          src="${path}/STATIC/wechat/image/loading.gif"/><span
            class="loadingSpan">加载中。。。</span>
        <div style="clear:both"></div>
    </div>
    <div class="pxPopBlack" style="display: none;">
        <!-- 是否退订 -->
        <div class="pxPopBox" id="wenTuiding" style="display: none;">
            <div class="wz"><p style="padding-top: 60px;" id="un_tips">是否退订“课程名称”课程？</p></div>
            <div class="pxpBtn">
                <a class="cancel" href="javascript:;">否</a>
                <a class="ok" href="javascript:;">是</a>
            </div>
        </div>
        <!--退订成功-->
        <div class="pxPopBox" id="sucTuiding" style="display: none;">
            <div class="wz"><p style="color: #f9c663;padding-top: 100px;">退订成功！</p></div>
        </div>

    </div>

</div>
</body>
<script type="text/javascript">
    getAppUserId();
    $(function () {
        var orderId='';
        var trainTitle = '';
        var orderName = '';
        var phoneNum = '';
        $('.pxOrderList').on('click', '.outOrder', function () {
            orderId = $(this).attr('id');
            trainTitle = $(this).attr("data_title");
            orderName = $(this).attr("orderName");
            phoneNum = $(this).attr("phoneNum");
            $("#un_tips").html("是否退订“"+trainTitle+"”课程？");
            $('.pxPopBlack').show();
            $('#wenTuiding').show();
        });

        $('.pxOrderList').on('click', '.pic,.tit', function () {
            window.location.href='${path}/wechatTrain/trainDetail.do?id='+ $(this).attr('v-id')+'&userId='+userId;
        });

        $('.pxPopBox .pxpBtn').on('click', '.cancel', function () {
            $('#wenTuiding').hide();
            $('.pxPopBlack').hide();
        });
        $('.pxPopBox .pxpBtn').on('click', '.ok', function () {
            $('#wenTuiding').hide();
            $.ajax({
                type: 'POST',
                dataType: "json",
                url: "${path}/wechatTrain/saveOrder.do",//请求的action路径
                async: false,
                data: {id:orderId, state: 2,trainTitle:trainTitle,name:orderName,phoneNum:phoneNum,userId:userId},
                error: function () {//请求失败处理函数
                    alert('请求失败');
                },
                success: function (data) { //请求成功后处理函数。
                    data = JSON.parse(data);
                    if(data.status==300){
                        window.location.href = '${path}/muser/login.do?type=${basePath}wechatTrain/trainOrder.do';
                    }else if(data.status==200){
                        $('#sucTuiding').show();
                        page = 1;
                        loadOrderList();
                    }else{
                        dialogAlert("提示","操作失败");
                    }
                    setTimeout(function () {
                        $('#sucTuiding').hide();
                        $('.pxPopBlack').hide();
                    }, 1000);
                }
            });
        });

        $(".shaiBox").on('click', 'li', function () {
            $(".shaiBox li").removeClass('cur');
            $(this).addClass("cur");
            $("#queryType").val($(this).attr('data-v'));
            page = 1;
            loadOrderList();
        })
        loadOrderList();
    });

    var page = 1;
    var dataLength = 10;
    //滑屏分页
    $(window).on("scroll", function () {
        var scrollTop = $(document).scrollTop();
        var pageHeight = $(document).height();
        var winHeight = $(window).height();
        if (scrollTop >= (pageHeight - winHeight - 100) && dataLength == 10) {
            setTimeout(function () {
                loadOrderList();
            }, 1000);
        }
    });


    function loadOrderList() {
        var queryType = $("#queryType").val();
        $("#loadingDiv").show();
        var html = '';
        $.ajax({
            type: 'POST',
            dataType: "json",
            url: "${path}/wechatTrain/trainOrderList.do",//请求的action路径
            async: false,
            async: false,
            data: {page: page, queryType: $("#queryType").val(),userId:userId},
            error: function () {//请求失败处理函数
                alert('请求失败');
            },
            success: function (data) { //请求成功后处理函数。
                dataLength = data.length;
                for (var i = 0; i < data.length; i++) {
                    var obj = data[i];
                    html += '<li>' +
                        '        <div class="topBox clearfix">' +
                        '            <div class="hao">订单号：' + obj.orderNum + '</div>' +
                        '            <div class="shi">' + obj.createTime.substring(0,16) + '</div>' +
                        '        </div>' +
                        '        <div class="words clearfix">';
                    html += '<div class="pic" v-id="'+obj.trainId+'"><img src="' + obj.trainImgUrl + '" />';
                    if (obj.state == 1) {
                        html += '<div class="type">报名成功</div>';
                    } else if (obj.state == 2) {
                        html += '<div class="type">已退订</div>';
                    } else if (obj.state == 3) {
                        if(queryType==2){
                            html += '<div class="type">审核未通过</div>';
                        }else{
                            html += '<div class="type">审核中</div>';
                        }
                    } else if (obj.state == 4) {
                        html += '<div class="type">审核未通过</div>';
                    }
                    console.log(obj.trainStartTime.substring(0,10));
                    console.log(obj.trainStartTime.substring(0,10).replace("-","."));
                    html += '</div><div class="char">\n' +
                        '<div class="tit" v-id="'+obj.trainId+'">' + obj.trainTitle + '</div>\n' +
                        '<div class="wz">开课时间：' + obj.trainStartTime.substring(0,10).replace(/-/g,'.')+ '-' + obj.trainEndTime.substring(0,10).replace(/-/g,'.')+ '</div>\n' +
                        '<div class="wz">上课地址：' + obj.trainAddress + '</div>\n';

                    html += '                <div class="tuid clearfix">\n';
                    if (queryType==1 && ((obj.state == 1&& obj.admissionType==1) || obj.state == 3)) {// 1:录取通过，2：退订，3：审核中，4：审核未通过
                        html += '<a orderName="'+obj.name+'" data_title="'+obj.trainTitle+'" phoneNum="'+obj.phoneNum+'" class="outOrder" id="'+obj.id+'">退订</a>\n';
                    }
                    html += '                </div>\n' +
                        '            </div>\n' +
                        '        </div>\n' +
                        '    </li>';
                }
                if (page == 1) {
                    $(".pxOrderList").html(html);
                } else {
                    $(".pxOrderList").append(html);
                }
                $("#loadingDiv").hide();
                page = page + 1;
            }
        });
    }

    function unsubscribe(id) {

    }
</script>
</html>