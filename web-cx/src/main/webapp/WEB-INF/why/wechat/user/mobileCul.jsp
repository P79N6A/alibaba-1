<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>关于佛山文化云</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
    <script src="${path}/STATIC/js/avalon.js"></script>
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
	  	//分享是否隐藏
	    if(window.injs){
			injs.setAppShareButtonStatus(false);
		}
    
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
		<div class="content padding-bottom0">
			<div class="point-rule-tab2 c262626">
				<h1 style="text-align: center;padding: 70px;">佛山文化云</h1>
				<p>文化引领品质生活</p>
				<p>佛山文化云是一款聚焦公共文化服务领域，提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。</p>
				<div id="waytoapp" style="display: none;">
					<p>您可以通过以下方式访问佛山文化云，获得免费公益文化活动机会。</p>
					<div class="waytoapp margin-bottom50">
						<ul>
							<%-- <li class="border-bottom">
								<p class="f-left">佛山文化云APP</p>
								<div class="f-left waytoapp-botton bg7279a0">
									<p class="cfff w170" onclick="location.href='${path}/appdownload/index.html'">下载APP</p>
								</div>
								<div style="clear: both;"></div>
							</li> --%>
							<li class="border-bottom">
								<p class="f-left">访问微官网</p>
								<div class="f-left waytoapp-botton bg7279a0">
									<p class="cfff" onclick="location.href='${path}/wechat/index.do'">点击进入微官网</p>
								</div>
								<div style="clear: both;"></div>
							</li>
						</ul>
					</div>
				</div>
				<script>
					if(!window.injs){
						$("#waytoapp").show();
					}
				</script>
				<p>想要预定热门免费公益的文化活动，您必须是我们的认证会员：</p>
				<p>无论您是在PC端、微信端发现佛山文化云，只需用手机号码注册，就能成为我们的会员。</p>
			</div>
		</div>
	</div>

<%--<div class="main">
     <div class="header">
		<div class="index-top">
			<span class="index-top-5">
				<img src="${path}/STATIC/wechat/image/arrow1.png"  onclick="history.go(-1);"/>
			</span>
			<span class="index-top-2">关于文化云</span>
		</div>
        <div class="join-logo">
            <img src="${path}/STATIC/wechat/image/logo4.png"/>
            <h1>文化云</h1>
            <h2>Ver:${version}</h2>
            <p>文化云是一个聚合中国传统、促进文化交流的互联网+平台，它不仅提供全国一流的文化场馆信息，包含大量电影、曲艺、讲座、舞蹈、歌剧等文化活动资讯，提供最热门的文化活动预订，建立最全的文化大师交流渠道，更能让用户足不出户的了解天下文化，参与云上文化活动。引领品质生活，从文化云开始。
            </p>
            <div class="joinusMenu" style="display: none;">
				<div class="joinusMenuBtn" onclick="location.href='http://www.wenhuayun.cn/appdownload/index.html'">
					<img src="${path}/STATIC/wechat/image/applogo.png" />
					<p>下载文化云app</p>
				</div>
			</div>
			<script>
				if(!(/wenhuayun/.test(ua))){
					$(".joinusMenu").show();
				}
			</script>
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
</div> --%>
</body>
</html>