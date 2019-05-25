<%@ page language="java" pageEncoding="UTF-8" %>
<%@page import="java.util.*" %>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css">
		<title>6-12月佳作名单</title>
	</head>
	<style>
		html,
		body {
			height: 100%;
		}
		
		td {
			height: 60px;
			font-size: 20px;
			font-family: "微软雅黑";
		}
		
		tr td:first-child {
			width: 165px;
			text-align: center;
		}
		
		tr td:nth-child(2) {
			width: 590px;
			padding: 0 20px;
		}
		
		tr td:nth-child(3) {
			text-align: center;
		}
		
		.NameListMain {
			height: 100%;
			width: 100%;
			margin: auto;
		}
		
		.NameListMain .NameListHead {
			width: 100%;
			background-color: #4a4a4a;
		}
		
		.NameListMain .NameListContent {
			width: 1050px;
			margin: auto;
			padding: 35px 100px;
		}
		
		.NameListMain .NameListHead .whyBackBtn {
			line-height: 60px;
			color: #fff;
		}
		
		.NameListMain .NameListContent .NameListTittle {
			height: 75px;
			width: 100%;
			background-color: #4a4a4a;
			color: #FFFFFF;
			margin-bottom: 5px;
			text-align: center;
			font-size: 22px;
			line-height: 75px;
			font-family: "微软雅黑";
		}
		
		li {
			margin-bottom: 20px;
		}
		.NameListMain .NameListFooter{
			width: 100%;
			background-color: #4a4a4a;
		}
	</style>

	<body>
		<div class="NameListMain">
			<div class="NameListHead">
				<div style="width: 1250px;margin: auto;height: 60px;">
					<a href="http://www.wenhuayun.cn" class="whyBackBtn">
						<&emsp;返回文化云</a>
				</div>
			</div>
			<div style="width: 1250px;margin: auto;">
				<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017222162559KlOWqdiDA32wuV9nqAXwv6APrNu1eX.jpg" style="display: block;margin: auto;" />
			</div>
			<div class="NameListContent">
				<ul>
					<li>
						<div class="NameListTittle">6月佳作</div>
						<table style="width: 100%;" border="1" bordercolor="#e0e0e0">
							<tr>
								<td bgcolor="#f4f4f4">01</td>
								<td>科技精英的摇篮</td>
								<td>胡敏敏</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">02</td>
								<td>汇学博物馆首日开放</td>
								<td>黄幼琳</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">03</td>
								<td>快乐的老年人</td>
								<td>陈晓英</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">04</td>
								<td>敬 礼</td>
								<td>李 俨</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">05</td>
								<td>宜山路马路拓宽施工</td>
								<td>吴士伟</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">06</td>
								<td>红旗颂</td>
								<td>雷 明</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">07</td>
								<td>宣传文明乘车</td>
								<td>高申昌</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">08</td>
								<td>历史遗迹</td>
								<td>姜东莉</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">09</td>
								<td>鏖战正激</td>
								<td>陈鸿钧</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">10</td>
								<td>迎来送往</td>
								<td>石建国</td>
							</tr>
						</table>
					</li>
					<li>
						<div class="NameListTittle">7月佳作</div>
						<table style="width: 100%;" border="1" bordercolor="#e0e0e0">
							<tr>
								<td bgcolor="#f4f4f4">01</td>
								<td>赏 荷</td>
								<td>尤智勇</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">02</td>
								<td>未来足球之星</td>
								<td>缪一琴</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">03</td>
								<td>兴 奋</td>
								<td>王路得</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">04</td>
								<td>美的韵律</td>
								<td>王一鸣</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">05</td>
								<td>开心的一天</td>
								<td>叶 歌</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">06</td>
								<td>感觉正好</td>
								<td>刘金龙</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">07</td>
								<td>有模有样</td>
								<td>韩 文</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">08</td>
								<td>低头族</td>
								<td>陈佩琼</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">09</td>
								<td>为民服务</td>
								<td>汪基筠</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">10</td>
								<td>彩色光轨</td>
								<td>王义华</td>
							</tr>
						</table>
					</li>
					<li>
						<div class="NameListTittle">8月佳作</div>
						<table style="width: 100%;" border="1" bordercolor="#e0e0e0">
							<tr>
								<td bgcolor="#f4f4f4">01</td>
								<td>暴雨排水工</td>
								<td>殷才和</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">02</td>
								<td>一桥飞架两岸</td>
								<td>桑炯华</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">03</td>
								<td>为民服务</td>
								<td>许元英</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">04</td>
								<td>南站游龙</td>
								<td>杨焕敏</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">05</td>
								<td>寻 亲</td>
								<td>许本燮</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">06</td>
								<td>蓝天下的儿童们</td>
								<td>高焕新</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">07</td>
								<td>游览武康路</td>
								<td>李明奇</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">08</td>
								<td>小球星</td>
								<td>陈丽丽</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">09</td>
								<td>交大老图书馆</td>
								<td>金 晖</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">10</td>
								<td>舒服人生</td>
								<td>葛定求</td>
							</tr>
						</table>
					</li>
					<li>
						<div class="NameListTittle">9月佳作</div>
						<table style="width: 100%;" border="1" bordercolor="#e0e0e0">
							<tr>
								<td bgcolor="#f4f4f4">01</td>
								<td>拔河比赛</td>
								<td>曹雪芳</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">02</td>
								<td>枢纽新家园</td>
								<td>王长青</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">03</td>
								<td>国旗下的图书馆 </td>
								<td>徐传达</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">04</td>
								<td>严格训练</td>
								<td>杨 卫</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">05</td>
								<td>聚精会神</td>
								<td>高昇寶</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">06</td>
								<td>红岩精神赞</td>
								<td>黄崇德</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">07</td>
								<td>老外在徐汇</td>
								<td>冯永刚</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">08</td>
								<td>卢浦桥下的万吨轮</td>
								<td>张义山</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">09</td>
								<td>徐汇见闻</td>
								<td>沈 洪</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">10</td>
								<td>急 驰</td>
								<td>朱培凤</td>
							</tr>
						</table>
					</li>
					<li>
						<div class="NameListTittle">10月佳作</div>
						<table style="width: 100%;" border="1" bordercolor="#e0e0e0">
							<tr>
								<td bgcolor="#f4f4f4">01</td>
								<td>美丽的南站</td>
								<td>许 斌</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">02</td>
								<td>马拉松队伍里的癌症铁人</td>
								<td>姚泉耕</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">03</td>
								<td>齐心协力 </td>
								<td>戴 琪</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">04</td>
								<td>马天民的影子</td>
								<td>李金良</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">05</td>
								<td>上海马拉松开赛纪实</td>
								<td>周 洪</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">06</td>
								<td>值勤忙</td>
								<td>俞美玲</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">07</td>
								<td>庆国庆</td>
								<td>杜德发</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">08</td>
								<td>知识的海洋</td>
								<td>徐家荣</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">09</td>
								<td>入 神</td>
								<td>任培莉</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">10</td>
								<td>欢庆锣鼓</td>
								<td>陆蓉蓉</td>
							</tr>
						</table>
					</li>
					<li>
						<div class="NameListTittle">11月佳作</div>
						<table style="width: 100%;" border="1" bordercolor="#e0e0e0">
							<tr>
								<td bgcolor="#f4f4f4">01</td>
								<td>选民覌榜</td>
								<td>华汉云</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">02</td>
								<td>红灯停绿灯行</td>
								<td>杨 爱</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">03</td>
								<td>空 降</td>
								<td>顾志烈</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">04</td>
								<td>依依惜别</td>
								<td>姚恩滇</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">05</td>
								<td>红灯停</td>
								<td>陈惠珍</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">06</td>
								<td>舞动青春</td>
								<td>陈 敏</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">07</td>
								<td>高安路上赏落叶</td>
								<td>张大林</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">08</td>
								<td>成人礼</td>
								<td>厉培豪</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">09</td>
								<td>“斯巴鲁杯”国际公路自行车赛在徐汇滨江</td>
								<td>黄伟助</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">10</td>
								<td>秋之小景</td>
								<td>贾传辉</td>
							</tr>
						</table>
					</li>
					<li>
						<div class="NameListTittle">12月佳作</div>
						<table style="width: 100%;" border="1" bordercolor="#e0e0e0">
							<tr>
								<td bgcolor="#f4f4f4">01</td>
								<td>歌友合唱队</td>
								<td>李志华</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">02</td>
								<td>画家与摄影师</td>
								<td>唐天祥</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">03</td>
								<td>畅想2017</td>
								<td>丛 洁</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">04</td>
								<td>快乐一刻</td>
								<td>钱霞星</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">05</td>
								<td>参 观</td>
								<td>张秀兰</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">06</td>
								<td>回 看</td>
								<td>范忠民</td>
							</tr>
							<tr>
								<td bgcolor="#f4f4f4">07</td>
								<td>各族农民聚会画展</td>
								<td>汤新民</td>
							</tr>
						</table>
					</li>
				</ul>
			</div>
			<div class="NameListFooter">
				<div style="width: 1250px;margin: auto;">
					<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017222162613MOyzzPYdbhPuj3ufmfbSjaZZLhdaqz.jpg" style="display: block;margin: auto;"/>
				</div>
			</div>
		</div>
	</body>
</html>