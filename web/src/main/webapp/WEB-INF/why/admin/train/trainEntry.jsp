<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>培训预订</title>
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
                        title: "我在“镇江文化云”发现一大波文化活动，快来和我一起预订吧！",
                        desc: '汇聚镇江最全文化活动',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        success: function () {
                            dialogAlert('系统提示', '分享成功！');
                        }
                    });
                    wx.onMenuShareTimeline({
                        title: "我在“镇江文化云”发现一大波文化活动，快来和我一起预订吧！",
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        success: function () {
                            dialogAlert('系统提示', '分享成功！');
                        }
                    });
                    wx.onMenuShareQQ({
                        title: "我在“镇江文化云”发现一大波文化活动，快来和我一起预订吧！",
                        desc: '汇聚镇江最全文化活动',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareWeibo({
                        title: "我在“镇江文化云”发现一大波文化活动，快来和我一起预订吧！",
                        desc: '汇聚镇江最全文化活动',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareQZone({
                        title: "我在“镇江文化云”发现一大波文化活动，快来和我一起预订吧！",
                        desc: '汇聚镇江最全文化活动',
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
<%--<div class="alertMsg" style="width: 100%;height: 100%;background-color: rgba(0,0,0,.5);position: fixed;top: 0;left: 0;z-index: 30;">
    <div style="width: 650px;height: 355px;background-color: #fff;position: absolute;top: 50%;left: 50%;margin-top: -250px;margin-left: -325px;">
        <div class="title">温馨提示</div>
        <div class="msg">您已超出年龄限制！</div>
        <div class="know">我知道了</div>
    </div>
</div>--%>
<div class="main">
    <div class="px-bmForm">
        <form action="" id="jvForm">
            <div class="bmItem clearfix">
                <div class="lab">姓&emsp;&emsp;&emsp;名</div>
                <input class="txt" type="text" placeholder="请输入真实姓名" name="name" id="name" maxlength="10" value="${order.name}"/>
                <input class="txt" type="hidden" value="${train.id}" name="trainId"/>
            </div>
            <div class="bmItem clearfix">
                <div class="lab">性&emsp;&emsp;&emsp;别</div>
                <div class="txt clearfix" style="padding: 0;">
                    <input type="radio" name="sex" id="male" value="1" <c:if test="${order.sex == 1}">checked</c:if>/><label for="male" class="radioBox">男</label>
                    <input type="radio" name="sex" id="female" value="2" <c:if test="${order.sex == 2}">checked</c:if>/><label for="female" class="radioBox">女</label>
                </div>
            </div>
            <div class="bmItem clearfix">
                <div class="lab">年&emsp;&emsp;&emsp;龄</div>
                <input type="hidden"  name="birthday"/>
                <div class="txt txtPla" data-year="" data-month="" data-date="" id="birthday">
                    请输入出生日期
                </div>
            </div>
            <div class="bmItem clearfix cardDiv">
                <div class="lab card">身&nbsp;份&nbsp;证&nbsp;号</div><em></em>
                <div class="choose lab chooseKindNo">
                    <div class="lab">身&nbsp;份&nbsp;证&nbsp;号</div>
                    <div class="lab">港澳通行证</div>
                    <div class="lab">台湾通行证</div>
                </div>
                <input class="txt" type="text" placeholder="请输入证件号码" name="idCard" id="idCard" maxlength="18" value="${order.idCard}"/>
            </div>
            <div class="bmItem clearfix">
                <div class="lab">家&nbsp;庭&nbsp;住&nbsp;址</div>
                <input class="txt" type="text" placeholder="请输入家庭住址" name="homeAddress" id="homeAddress" value="${order.homeAddress}"/>
            </div>
            <div class="bmItem clearfix">
                <div class="lab">联&nbsp;系&nbsp;电&nbsp;话</div>
                <input class="txt" type="text" placeholder="请输入手机号码" name="phoneNum" id="phoneNum" value="${order.phoneNum}"/>
            </div>
            <div class="bmItem clearfix">
                <div class="lab">家庭联系人</div>
                <input class="txt" type="text" placeholder="请输入家庭联系人" name="homeConnector" id="homeConnector" value="${order.homeConnector}"/>
            </div>
            <div class="bmItem clearfix">
                <div class="lab">与本人关系</div>
                <input class="txt" type="text" placeholder="请输入与本人关系" name="connectorRelationship" id="connectorRelationship" value="${order.connectorRelationship}"/>
            </div>
            <div class="bmItem clearfix">
                <div class="lab">联&nbsp;系&nbsp;电&nbsp;话</div>
                <input class="txt" type="text" placeholder="请输入手机号码" name="connectorPhoneNum" id="connectorPhoneNum" value="${order.connectorPhoneNum}"/>
            </div>
        </form>
    </div>
    <a class="px-bmFormBtn" href="javascript:;">确 定</a>
</div>
</body>
<script>
    var showDateDom = $('#birthday');
    // 初始化时间
    var now = new Date();
    var nowYear = now.getFullYear();
    var nowMonth = now.getMonth() + 1;
    var nowDate = now.getDate();
    showDateDom.attr('data-year', nowYear);
    showDateDom.attr('data-month', nowMonth);
    showDateDom.attr('data-date', nowDate);

    // 数据初始化
    function formatYear(nowYear) {
        var arr = [];
        for (var i = nowYear - 100; i <= nowYear; i++) {
            arr.push({
                id: i + '',
                value: i + ''
            });
        }
        return arr;
    }

    function formatMonth() {
        var arr = [];
        for (var i = 1; i <= 12; i++) {
            arr.push({
                id: i + '',
                value: i < 10 ? '0' + i : '' + i
            });
        }
        return arr;
    }

    function formatDate(count) {
        var arr = [];
        for (var i = 1; i <= count; i++) {
            arr.push({
                id: i + '',
                value: i < 10 ? '0' + i : '' + i
            });
        }
        return arr;
    }

    var yearData = function (callback) {
        callback(formatYear(nowYear))
    }
    var monthData = function (year, callback) {
        callback(formatMonth());
    };
    var dateData = function (year, month, callback) {
        if (/^(1|3|5|7|8|10|12)$/.test(month)) {
            callback(formatDate(31));
        } else if (/^(4|6|9|11)$/.test(month)) {
            callback(formatDate(30));
        } else if (/^2$/.test(month)) {
            if (year % 4 === 0 && year % 100 !== 0 || year % 400 === 0) {
                callback(formatDate(29));
            } else {
                callback(formatDate(28));
            }
        } else {
            throw new Error('month is illegal');
        }
    };
    showDateDom.on('click', function () {
        var oneLevelId = showDateDom.attr('data-year');
        var twoLevelId = showDateDom.attr('data-month');
        var threeLevelId = showDateDom.attr('data-date');
        var iosSelect = new IosSelect(3, [yearData, monthData, dateData], {
            title: '日期选择',
            headerHeight: 90,
            itemHeight: 60,
            relation: [1, 1],
            oneLevelId: oneLevelId,
            twoLevelId: twoLevelId,
            threeLevelId: threeLevelId,
            showLoading: true,
            callback: function (selectOneObj, selectTwoObj, selectThreeObj) {
                showDateDom.attr('data-year', selectOneObj.id);
                showDateDom.attr('data-month', selectTwoObj.id);
                showDateDom.attr('data-date', selectThreeObj.id);
                showDateDom.html('<span style="color: #666;">' + selectOneObj.value + ' - ' + selectTwoObj.value + ' - ' + selectThreeObj.value + '</span>');
                $("input[name=birthday]").val(selectOneObj.value + '-' + selectTwoObj.value + '-' + selectThreeObj.value);
            }
        });
    });
    $(function () {
        $("#male").click(function () {
            $("#male").attr("checked", true);
            $("#female").attr("checked", false);
        });
        $("#female").click(function () {
            $("#male").attr("checked", false);
            $("#female").attr("checked", true);
        });
        //关闭弹窗
        $(".know").click(function(){
            $(".alertMsg").hide()
        })
    })
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
        var age = getAge($("input[name=birthday]").val());
        var sex = $('input[name="sex"]:checked').val();
        var maleMinAge = ${train.maleMinAge};
        var maleMaxAge = ${train.maleMaxAge};
        var femaleMinAge = ${train.femaleMinAge};
        var femaleMaxAge = ${train.femaleMaxAge};
        if(sex == 1){
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
    $(function () {
        $(".px-bmFormBtn").on('click', function () {
            var name = $("#name").val();
            var birthday = $("input[name=birthday]").val();
            var idCard = $("#idCard").val();
            var homeAddress = $("#homeAddress").val();
            var phoneNum = $("#phoneNum").val();
            var homeConnector = $("#homeConnector").val();
            var connectorRelationship = $("#connectorRelationship").val();
            var connectorPhoneNum = $("#connectorPhoneNum").val();
            if (!name) {
                dialogAlert("报名提示", "请填写姓名");
                return;
            }
            if (!birthday) {
                dialogAlert("报名提示", "请填写生日");
                return;
            }
            if (!idCard) {
                dialogAlert("报名提示", "请填写身份证");
                return;
            }else{
                if(!/(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/.test(idCard) && !/^[HMhm]{1}([0-9]{10}|[0-9]{8})$/.test(idCard) && !/^[0-9]{8}$/.test(idCard) && !/^[a-zA-Z0-9]{5,17}$/.test(idCard)){
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
            if (!homeAddress) {
                dialogAlert("报名提示", "请填写家庭住址");
                return;
            }
            if (!homeConnector) {
                dialogAlert("报名提示", "请填写家庭联系人");
                return;
            }
            if (!connectorRelationship) {
                dialogAlert("报名提示", "请填写联系人与本人关系");
                return;
            }
            if (!connectorPhoneNum) {
                dialogAlert("报名提示", "请填写联系人手机号码");
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

            $.post('${path}/wechatTrain/saveOrder.do',$('#jvForm').serialize(),function (data) {
                data = JSON.parse(data);
                if(data.status!=200){
                    if(data.status==300){
                        dialogAlert("报名提示", data.data);
                        window.location.href = '${path}/muser/login.do?type=${basePath}wechatTrain/toEntry.do?id=${train.id}';
                    }else{
                        dialogAlert("报名提示", data.data);
                    }
                }else{
                    location.href = '${path}/wechatTrain/entryResult.do?id='+data.data;
                }
            })

        })
    });
    $(function(){
        //关闭弹窗
        $(".know").click(function(){
            $(".alertMsg").hide()
        })
        // 证件选择
        $('.px-bmForm .bmItem .lab.card').click(function () {
            $(".choose").toggleClass("chooseKind chooseKindNo")
            $(".px-bmForm .choose").show()
        });
        $(".px-bmForm .choose .lab").click(function(){
            $('.px-bmForm .bmItem .lab.card').html($(this).text())
            $(".px-bmForm .choose").hide()
        })
    })

</script>
</html>