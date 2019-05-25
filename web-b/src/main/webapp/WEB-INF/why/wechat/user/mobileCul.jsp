<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <!-- <title>关于文化云</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
    <style>
        .content {
            padding: 0;
        }

        .header {
            position: relative;
        }

        .footer {
            position: relative;
        }
    </style>
    <script type="text/javascript">

        var dataForm = avalon.define({
            $id: "dataForm",
            contactName: "",
            contact: "",
            corporation: ""
        });
        function send() {
            var name = dataForm.contactName;
            var contact = dataForm.contact;
            var corporation = dataForm.corporation;

            if (name == "" || name == "请输入您称呼") {
                dataForm.contactName = "请输入您称呼";
                return
            }
            if (corporation == "" || corporation == "请输入您公司名称") {
                dataForm.corporation = "请输入您公司名称";
                return
            }
            if (contact == "" || contact == "请输入您的联系方式") {
                dataForm.contact = "请输入您的联系方式";
                return
            }

            $.ajax({
                type: "POST",
                url: '${path}/contactUs/saveContact.do?' + new Date().getTime(),
                data: dataForm.$model,
                dataType: "json",
                success: function (data) {
                    if (data.status!=undefined&&data.status == 200) {
                        dataForm.contactName = "";
                        dataForm.corporation = "";
                        dataForm.contact = "";
                        dialogAlert('系统提示', '联系我们成功！');

                    }else if(data.status!=undefined&&data.status==403){
                        dialogAlert('系统提示', '您已经提交过信息无需重复提交！');
                    } else {
                        dialogAlert('系统提示', '联系我们失败！');
                    }
                },
                error: function () {
                }
            });
        }
    </script>
</head>
<body>
<div class="main">
    <div class="header">
        <c:if test="${type!='app'}">
            <div class="index-top">
					<span class="index-top-5">
						<img src="${path}/STATIC/wechat/image/arrow1.png"  onclick="history.go(-1);"/>
					</span>
                <span class="index-top-2">关于文化云</span>
            </div>
        </c:if>
        <div class="join-logo">
            <img src="${path}/STATIC/wechat/image/logo.png"/>
            <h1>文化上海云</h1>
            <h2>Ver:3.5.3</h2>
            <p>文化上海云是为了用户提供免费看演出、听讲座、参加培训、举办展览的互联网平台，它包含了大量的亲子、电影、戏剧、养生、聚会等活动信息。<br/>他汇聚了上海16个区县、各市级场馆的活动及场地设施资源，实现了上海每年22万场公共文化活动和5500个公共文化场所的预定预约功能，为市民提供了最丰富、最便捷、家门口的公共服务资源。
            </p>
        </div>
    </div>
    <div class="content" ms-controller="dataForm">
        <div class="join-detail">
            <p>如果有机构入驻、发布活动、发布场馆的需求<br/>请留下您的联系方式：</p>
            <ul>
                <li class="join-detail-lbb">
                    <label>称呼</label>
                    <input type="text" ms-duplex="contactName" value="" maxlength="10" placeholder="请输入您称呼"/>
                    <div style="clear: both;"></div>
                </li>
                <li class="join-detail-lbb">
                    <label>公司</label>
                    <input type="text" ms-duplex="corporation" maxlength="30" placeholder="请输入您公司名称"/>
                    <div style="clear: both;"></div>
                </li>
                <li>
                    <label>电话</label>
                    <input type="text" ms-duplex="contact" maxlength="30" placeholder="请输入您的联系方式"/>
                    <div style="clear: both;"></div>
                </li>
            </ul>
            <button type="button" onclick="send()">提交</button>
        </div>
    </div>
    <div class="footer">
        <div class="join-footer">
            <p>合作电话：400-018-2346</p>
            <p>合作邮箱：business@sun3d.com</p>
        </div>
    </div>
</div>
</body>
</html>