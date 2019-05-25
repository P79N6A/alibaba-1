<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>2016年上海市民文化节公共文化配送产品设计大赛百强目录</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<style type="text/css">
html , body {height: 100%;}
.ggwhtop100 {width: 750px;min-height: 100%;margin: 0 auto;background:url(${path}/STATIC/wxStatic/image/pszx/ban1.jpg) no-repeat top center #3c1d4c;padding: 1px 0;}
.ggwhtop100 .divTab {background-color: rgba(60,29,76,0.6);margin-top: 316px;padding: 40px 0;}
.ggwhtop100 .divTab .tit {font-size: 28px;color: #df954e;text-align: center;margin-bottom: 35px;}
.ggwhtop100 .divTab .tit em {display: inline-block;width: 40px;height: 1px;background-color: #df954e;vertical-align: middle;margin: 0 30px;}
.ggwhtop100 .table {width: 700px;margin: 0 auto;border-collapse: collapse;margin-bottom: 60px; font-size: 26px;color: #c3a0e4;}
.ggwhtop100 .table , .ggwhtop100 .table th , .ggwhtop100 .table td {border: 1px solid #724b97;}
.ggwhtop100 .table th {color: #df954e;padding: 20px 0;background-color: rgba(51,15,85,0.5);}
.ggwhtop100 .table td {padding: 20px 10px;}
.ggwhtop100 .table .td1 {width: 80px;color: #df954e;text-align: center;}
.ggwhtop100 .table .td2 {width: 350px;}
.ggwhtop100 .table .td3 {width: 210px;}
.ggwhtop100 .wenz {width: 690px;margin: 0 auto;font-size: 24px;color:  #c3a0e4;line-height: 38px;text-align: center;margin-bottom: 30px;}
.ggwhfoot {background-color: #2a0e38;font-size: 24px;color: #90659f;line-height: 38px;padding: 35px 0;border-bottom: 1px solid #5d2e76;}
.ggwhfoot .nc {width: 690px;margin: 0 auto;}
.hdtop {position: fixed;right: 20px;bottom: 130px;z-index: 2;display: none;}
</style>
<script type="text/javascript">

//分享是否隐藏
if(window.injs){
	//分享文案
	appShareTitle = '2016年上海市民文化节公共文化配送产品设计大赛百强目录';
	appShareDesc = '2016年上海市民文化节公共文化配送产品设计大赛“百强公共文化配送创新产品”目录，点击详情……';
	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/pszx/shareIcon2016.png';
	
	injs.setAppShareButtonStatus(true);
}

//判断是否是微信浏览器打开
if (is_weixin()) {
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
			title: "2016年上海市民文化节公共文化配送产品设计大赛百强目录",
			desc: '2016年上海市民文化节公共文化配送产品设计大赛“百强公共文化配送创新产品”目录，点击详情……',
			link: '${basePath}wechatQyg/qygList2016.do',
			imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon2016.png'
		});
		wx.onMenuShareTimeline({
			title: "2016年上海市民文化节公共文化配送产品设计大赛百强目录",
			imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon2016.png',
			link: '${basePath}wechatQyg/qygList2016.do'
		});
		wx.onMenuShareQQ({
			title: "2016年上海市民文化节公共文化配送产品设计大赛百强目录",
			desc: '2016年上海市民文化节公共文化配送产品设计大赛“百强公共文化配送创新产品”目录，点击详情……',
			imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon2016.png'
		});
		wx.onMenuShareWeibo({
			title: "2016年上海市民文化节公共文化配送产品设计大赛百强目录",
			desc: '2016年上海市民文化节公共文化配送产品设计大赛“百强公共文化配送创新产品”目录，点击详情……',
			imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon2016.png'
		});
		wx.onMenuShareQZone({
			title: "2016年上海市民文化节公共文化配送产品设计大赛百强目录",
			desc: '2016年上海市民文化节公共文化配送产品设计大赛“百强公共文化配送创新产品”目录，点击详情……',
			imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon2016.png'
		});
	});
}


$(function () {
    // 回到顶部
    var topH = $(".hdtop").offset().top;
    $(window).scroll(function(){
        var scroH = $(this).scrollTop();
        if(scroH>topH){
            $(".hdtop").fadeIn(300);
        }else{
            $(".hdtop").fadeOut(300);
        }
    });
    $(".hdtop").click(function(){
        $("html,body").animate({scrollTop:0},400);
    });
});
</script>
</head>

<body>

<div class="ggwhtop100">
	<!-- 回答顶部 -->
    <img class="hdtop" src="${path}/STATIC/wxStatic/image/pszx/top.png">
    <div class="divTab">
        <div class="wenz">（目录按产品名称字母先后为序排列）</div>
        <div class="tit"><em></em>文艺演出A类<em></em></div>
        <table class="table">
        	<tr>
        		<th class="td1">序号</th>
        		<th class="td2">产品名称</th>
        		<th class="td3">申报主体</th>
        	</tr>
        	<tr>
        		<td class="td1">001</td>
        		<td class="td2">大型室内乐音乐会《畅响中国——中国传统作品与西方古典名曲的对话》</td>
        		<td class="td3">上海寿昌文化传播有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">002</td>
        		<td class="td2">儿童剧《狮子王的故事》</td>
        		<td class="td3">上海谷都文化演出有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">003</td>
        		<td class="td2">淮剧《铡刀下的红梅》</td>
        		<td class="td3">上海淮剧艺术传习所（上海淮剧团）</td>
        	</tr>
        </table>
        <div class="tit"><em></em>文艺演出B类<em></em></div>
        <table class="table">
            <tr>
        		<th class="td1">序号</th>
        		<th class="td2">产品名称</th>
        		<th class="td3">申报主体</th>
        	</tr>
        	<tr>
        		<td class="td1">004</td>
        		<td class="td2">“澎湃的力量”激情杂技专场</td>
        		<td class="td3">上海智准文化传播有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">005</td>
        		<td class="td2">“丝竹雅韵”江南丝竹音乐会</td>
        		<td class="td3">上海民族乐团</td>
        	</tr>
        	<tr>
        		<td class="td1">006</td>
        		<td class="td2">百老汇爆笑音乐剧《两个人的谋杀》</td>
        		<td class="td3">上海话剧艺术中心有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">007</td>
        		<td class="td2">独脚戏专场《金鸡爆“笑”》</td>
        		<td class="td3">上海市人民滑稽剧团</td>
        	</tr>
        	<tr>
        		<td class="td1">008</td>
        		<td class="td2">多媒体动画剧《我要飞，去月球》</td>
        		<td class="td3">上海儿童国际文化发展有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">009</td>
        		<td class="td2">多媒体儿童京剧 《关不住的童心》</td>
        		<td class="td3">上海徐汇燕萍京剧团</td>
        	</tr>
        	<tr>
        		<td class="td1">010</td>
        		<td class="td2">儿童剧《梦境小镇之塔塔与火焰圣石》</td>
        		<td class="td3">潮宗文化传媒（上海）有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">011</td>
        		<td class="td2">儿童剧《图书馆奇妙夜》</td>
        		<td class="td3">上海万合品欢影视文化有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">012</td>
        		<td class="td2">海派喜剧《一孝成名》</td>
        		<td class="td3">上海申江艺术团</td>
        	</tr>
        	<tr>
        		<td class="td1">013</td>
        		<td class="td2">沪剧《绿岛情歌》</td>
        		<td class="td3">上海文慧沪剧团</td>
        	</tr>
        	<tr>
        		<td class="td1">014</td>
        		<td class="td2">沪剧《亲人》</td>
        		<td class="td3">上海勤苑沪剧团</td>
        	</tr>
        	<tr>
        		<td class="td1">015</td>
        		<td class="td2">沪剧《情与法》</td>
        		<td class="td3">上海海梅艺术团</td>
        	</tr>
        	<tr>
        		<td class="td1">016</td>
        		<td class="td2">沪剧《许浦深情》</td>
        		<td class="td3">上海紫华沪剧团</td>
        	</tr>
        	<tr>
        		<td class="td1">017</td>
        		<td class="td2">话剧《起飞在即》</td>
        		<td class="td3">上海话剧艺术中心有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">018</td>
        		<td class="td2">交响乐音乐会《永恒的信念》</td>
        		<td class="td3">上海大众乐团</td>
        	</tr>
        	<tr>
        		<td class="td1">019</td>
        		<td class="td2">经典独唱、重唱歌曲音乐会《情牵中华》</td>
        		<td class="td3">上海歌剧院</td>
        	</tr>
        	<tr>
        		<td class="td1">020</td>
        		<td class="td2">木偶剧《海的女儿》</td>
        		<td class="td3">上海木偶剧团有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">021</td>
        		<td class="td2">人偶音乐剧《灰姑娘与水晶鞋》</td>
        		<td class="td3">上海木偶剧团有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">022</td>
        		<td class="td2">现代京剧《社区仁医》</td>
        		<td class="td3">上海李军文化艺术有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">023</td>
        		<td class="td2">音乐剧《我在你的未来》</td>
        		<td class="td3">上海安可艺术团</td>
        	</tr>
        </table>
        <div class="tit"><em></em>文艺演出C类<em></em></div>
        <table class="table">
            <tr>
        		<th class="td1">序号</th>
        		<th class="td2">产品名称</th>
        		<th class="td3">申报主体</th>
        	</tr>
        	<tr>
        		<td class="td1">024</td>
        		<td class="td2">鼓乐诗剧《鼓起中国梦》</td>
        		<td class="td3">上海鼓鼓文化传播有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">025</td>
        		<td class="td2">郭德纲弟子高鹤彩相声专场</td>
        		<td class="td3">笑苑（上海）文化传播有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">026</td>
        		<td class="td2">沪剧《半把剪刀》</td>
        		<td class="td3">上海松江璐艺沪剧团</td>
        	</tr>
        	<tr>
        		<td class="td1">027</td>
        		<td class="td2">沪剧《泖田新故事》</td>
        		<td class="td3">上海勤怡沪剧团</td>
        	</tr>
        	<tr>
        		<td class="td1">028</td>
        		<td class="td2">滑稽戏《行善·缺德》</td>
        		<td class="td3">上海滑稽剧团有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">029</td>
        		<td class="td2">话剧《和和小区那点事儿》（方言版）</td>
        		<td class="td3">上海光启剧社</td>
        	</tr>
        	<tr>
        		<td class="td1">030</td>
        		<td class="td2">淮剧《孔乙己》</td>
        		<td class="td3">上海淮剧艺术传习所（上海淮剧团）</td>
        	</tr>
        	<tr>
        		<td class="td1">031</td>
        		<td class="td2">军歌演唱会《我们曾经当过兵》</td>
        		<td class="td3">上海名仕歌舞团</td>
        	</tr>
        	<tr>
        		<td class="td1">032</td>
        		<td class="td2">亲子魔术儿童剧《魔法英雄》</td>
        		<td class="td3">上海爪玛文化艺术传播有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">033</td>
        		<td class="td2">神话越剧《劈山救母》</td>
        		<td class="td3">上海如意越剧团</td>
        	</tr>
        	<tr>
        		<td class="td1">034</td>
        		<td class="td2">舞台剧《嘻游记新传》</td>
        		<td class="td3">上海树信文化传播有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">035</td>
        		<td class="td2">音乐剧《致命咖啡》瘾藏者系列</td>
        		<td class="td3">上海安可艺术团</td>
        	</tr>
        </table>
        <div class="tit"><em></em>文艺演出D类<em></em></div>
        <table class="table">
         	<tr>
        		<th class="td1">序号</th>
        		<th class="td2">产品名称</th>
        		<th class="td3">申报主体</th>
        	</tr>
        	<tr>
        		<td class="td1">036</td>
        		<td class="td2">“品传统，送欢笑”相声曲艺专场</td>
        		<td class="td3">上海万合品欢影视文化有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">037</td>
        		<td class="td2">“七个蝌蚪”亲子音乐会</td>
        		<td class="td3">热浪文化传播发展（上海）有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">038</td>
        		<td class="td2">俄罗斯优秀歌曲音乐会</td>
        		<td class="td3">杭州荣音堡文化传播有限公司</td>
        	</tr>
        </table>
        <div class="tit"><em></em>艺术导赏<em></em></div>
        <table class="table">
        	<tr>
        		<th class="td1">序号</th>
        		<th class="td2">产品名称</th>
        		<th class="td3">申报主体</th>
        	</tr>
        	<tr>
        		<td class="td1">039</td>
        		<td class="td2">“党旗、军旗、国旗”军旅经典音乐赏析</td>
        		<td class="td3">上海馨田交响乐团有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">040</td>
        		<td class="td2">“滚灯”表演艺术导赏</td>
        		<td class="td3">上海市奉贤区滚灯艺术协会</td>
        	</tr>
        	<tr>
        		<td class="td1">041</td>
        		<td class="td2">“海派滑稽又一春·曲艺名家进社区”艺术导赏</td>
        		<td class="td3">上海市人民滑稽剧团</td>
        	</tr>
        	<tr>
        		<td class="td1">042</td>
        		<td class="td2">“沪语故事、小品的创作与表演”艺术导赏</td>
        		<td class="td3">上海星妍文化服务中心</td>
        	</tr>
        	<tr>
        		<td class="td1">043</td>
        		<td class="td2">“沪剧杨派艺术传承和创新发展”艺术导赏</td>
        		<td class="td3">上海勤怡沪剧团</td>
        	</tr>
        	<tr>
        		<td class="td1">044</td>
        		<td class="td2">“军旗飘扬·军歌嘹亮”——交响音乐艺术导赏</td>
        		<td class="td3">上海金秋文化传播有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">045</td>
        		<td class="td2">“魔术的魅力”艺术导赏</td>
        		<td class="td3">上海乾韵文化传播有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">046</td>
        		<td class="td2">“评弹流派及知识”艺术导赏</td>
        		<td class="td3">上海评弹艺术传习所（上海评弹团）</td>
        	</tr>
        	<tr>
        		<td class="td1">047</td>
        		<td class="td2">“奇奇怪怪打击乐”艺术导赏</td>
        		<td class="td3">上海李军文化艺术有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">049</td>
        		<td class="td2">“体验周派艺术魅力·走进淮剧非遗文化”艺术导赏</td>
        		<td class="td3">上海市静安淮剧艺术家周筱芳流派促进中心</td>
        	</tr>
        	<tr>
        		<td class="td1">049</td>
        		<td class="td2">“我与麒派结缘”艺术导赏</td>
        		<td class="td3">上海青果巷子传统文化促进中心</td>
        	</tr>
        	<tr>
        		<td class="td1">050</td>
        		<td class="td2">《何为适合群众团队的古典舞——“接地气”的中年古典舞蹈》艺术导赏</td>
        		<td class="td3">上海雅言文化传播有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">051</td>
        		<td class="td2">大雅清音——古琴艺术导赏</td>
        		<td class="td3">上海炳蔚文化发展股份有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">052</td>
        		<td class="td2">根源——沪剧艺术赏析</td>
        		<td class="td3">上海雁韵文化艺术中心</td>
        	</tr>
        	<tr>
        		<td class="td1">053</td>
        		<td class="td2">沪剧名家汪华忠专题导赏</td>
        		<td class="td3">上海星妍文化服务中心</td>
        	</tr>
        	<tr>
        		<td class="td1">054</td>
        		<td class="td2">黄梅戏艺术导赏</td>
        		<td class="td3">上海棠弥投资有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">055</td>
        		<td class="td2">李玮捷电影音乐导赏音乐会 </td>
        		<td class="td3">上海上体文化传媒有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">056</td>
        		<td class="td2">两根弦的歌唱——二胡艺术赏析</td>
        		<td class="td3">上海民族乐团</td>
        	</tr>
        	<tr>
        		<td class="td1">057</td>
        		<td class="td2">聆羽之音——民族音乐艺术导赏</td>
        		<td class="td3">上海鹤音文化传媒有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">058</td>
        		<td class="td2">美国电光火线工作坊“儿童发光肢体表演艺术导赏”</td>
        		<td class="td3">上海儿童国际文化发展有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">059</td>
        		<td class="td2">奇妙的和谐——人声艺术魅力专题导赏</td>
        		<td class="td3">上海歌剧院</td>
        	</tr>
        	<tr>
        		<td class="td1">060</td>
        		<td class="td2">旗袍文化导赏</td>
        		<td class="td3">上海赋星文化传播有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">061</td>
        		<td class="td2">“王洛宾的情与歌”艺术导赏</td>
        		<td class="td3">上海名仕歌舞团</td>
        	</tr>
        	<tr>
        		<td class="td1">062</td>
        		<td class="td2">王作欣与她的学生们——音乐剧艺术导赏</td>
        		<td class="td3">上海上体文化传媒有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">063</td>
        		<td class="td2">壹堂•音乐课——萨克斯重奏音乐导赏</td>
        		<td class="td3">上海宜音文化传播有限公司</td>
        	</tr>
        </table>
        <div class="tit"><em></em>展览展示A类<em></em></div>
        <table class="table">
        	<tr>
        		<th class="td1">序号</th>
        		<th class="td2">产品名称</th>
        		<th class="td3">申报主体</th>
        	</tr>
        	<tr>
        		<td class="td1">064</td>
        		<td class="td2">“非遗进社区”体验展</td>
        		<td class="td3">上海凯福文化创意发展有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">065</td>
        		<td class="td2">“历史·回顾·轶文”图片展</td>
        		<td class="td3">上海圣町市场营销策划有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">066</td>
        		<td class="td2">“绿色生活”体验展</td>
        		<td class="td3">上海市黄浦区文化公益促进会</td>
        	</tr>
        	<tr>
        		<td class="td1">067</td>
        		<td class="td2">“陶瓷72道工序立体雕塑”互动体验展</td>
        		<td class="td3">上海陶院艺术品投资管理有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">068</td>
        		<td class="td2">“永不干涸的文明长河——镜像中的中国备选世界文化与自然遗产”图片展</td>
        		<td class="td3">上海润荷文化传播有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">069</td>
        		<td class="td2">“永续的愿景——走进‘我们的节日’”立体文化展</td>
        		<td class="td3">上海星宇旅游发展有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">070</td>
        		<td class="td2">“指尖上的国粹”精品联展</td>
        		<td class="td3">上海市收藏协会</td>
        	</tr>
        	<tr>
        		<td class="td1">071</td>
        		<td class="td2">“中国梦·旗袍情”老上海白领旗袍展</td>
        		<td class="td3">上海衣谱文化传播有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">072</td>
        		<td class="td2">生态土布创意设计展</td>
        		<td class="td3">上海三民文化艺术中心</td>
        	</tr>
        </table>
        <div class="tit"><em></em>展览展示B类<em></em></div>
        <table class="table">
        	<tr>
        		<th class="td1">序号</th>
        		<th class="td2">产品名称</th>
        		<th class="td3">申报主体</th>
        	</tr>
        	<tr>
        		<td class="td1">073</td>
        		<td class="td2">“百年上海”大型主题图片展</td>
        		<td class="td3">上海广播电视台（上海文化广播影视集团有限公司）</td>
        	</tr>
        	<tr>
        		<td class="td1">074</td>
        		<td class="td2">“布衣情怀”吕巷民间土布衍生品文化展</td>
        		<td class="td3">上海吕巷旅游管理发展有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">075</td>
        		<td class="td2">“麦秆画”手工特色作品展示</td>
        		<td class="td3">上海金山区石化街道社区体育健身俱乐部</td>
        	</tr>
        	<tr>
        		<td class="td1">076</td>
        		<td class="td2">“乾隆号，下一个江南”创意展</td>
        		<td class="td3">上海飞麟文化传媒发展股份有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">077</td>
        		<td class="td2">“艺术万花筒”收藏展</td>
        		<td class="td3">上海海派连环画中心</td>
        	</tr>
        	<tr>
        		<td class="td1">078</td>
        		<td class="td2">上海老电影艺术家肖像摄影展</td>
        		<td class="td3">上海电影评论学会</td>
        	</tr>
        	<tr>
        		<td class="td1">079</td>
        		<td class="td2">上海老字号“工匠精神”专题展</td>
        		<td class="td3">上海五岳画院</td>
        	</tr>
        </table>
        <div class="tit"><em></em>特色活动<em></em></div>
        <table class="table">
        	<tr>
        		<th class="td1">序号</th>
        		<th class="td2">产品名称</th>
        		<th class="td3">申报主体</th>
        	</tr>
        	<tr>
        		<td class="td1">080</td>
        		<td class="td2">“DIY制作达人”特色活动</td>
        		<td class="td3">上海逸申文化传播有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">081</td>
        		<td class="td2">“草木扎染”特色活动</td>
        		<td class="td3">上海释凡文化传播有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">082</td>
        		<td class="td2">“观察力”亲子活动</td>
        		<td class="td3">上海东方数字社区发展有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">083</td>
        		<td class="td2">“老有所依•老有所艺”特色活动</td>
        		<td class="td3">上海好瓷信息科技有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">084</td>
        		<td class="td2">“立体剪折纸”非遗体验活动</td>
        		<td class="td3">上海市东方城市历史文化收藏交流中心</td>
        	</tr>
        	<tr>
        		<td class="td1">085</td>
        		<td class="td2">“零基础都能唱”特色活动</td>
        		<td class="td3">上海即创戏剧文化发展促进中心</td>
        	</tr>
        	<tr>
        		<td class="td1">086</td>
        		<td class="td2">“流动艺术馆进社区”艺术品展示特色活动</td>
        		<td class="td3">上海特锐艺术展览服务股份有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">087</td>
        		<td class="td2">“亲子绿色游乐场”特色活动</td>
        		<td class="td3">上海市黄浦区文化公益促进会</td>
        	</tr>
        	<tr>
        		<td class="td1">088</td>
        		<td class="td2">“青年手工匠人”特色活动</td>
        		<td class="td3">上海青果巷子传统文化促进中心</td>
        	</tr>
        	<tr>
        		<td class="td1">089</td>
        		<td class="td2">“神秘的火山世界”亲子活动</td>
        		<td class="td3">上海山上石影业有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">090</td>
        		<td class="td2">“唐卡心灵——舒压的唐卡绘制体验”特色活动</td>
        		<td class="td3">上海圣町市场营销策划有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">091</td>
        		<td class="td2">“听妈妈讲过去的事”系列活动</td>
        		<td class="td3">上海广播电视台（上海文化广播影视集团有限公司）</td>
        	</tr>
        	<tr>
        		<td class="td1">092</td>
        		<td class="td2">“我们的中国梦”中福会少年宫小伙伴艺术团文化艺术传播系列活动</td>
        		<td class="td3">中国福利会少年宫</td>
        	</tr>
        	<tr>
        		<td class="td1">093</td>
        		<td class="td2">“小小武魁”青少儿武术国学特色活动</td>
        		<td class="td3">上海东方广播有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">094</td>
        		<td class="td2">“新上海人学沪语”特色体验</td>
        		<td class="td3">上海东方数字社区发展有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">095</td>
        		<td class="td2">“优音荟——让声音定义你的完美”特色活动</td>
        		<td class="td3">上海迪声文化传播有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">096</td>
        		<td class="td2">海派非遗手作特色活动</td>
        		<td class="td3">上海海派连环画中心</td>
        	</tr>
        	<tr>
        		<td class="td1">097</td>
        		<td class="td2">奇幻艺术之旅“炫酷多米诺”特色活动</td>
        		<td class="td3">上海怡莲文化传播有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">098</td>
        		<td class="td2">日常公共安全应急防护结绳DIY特色活动</td>
        		<td class="td3">上海舜元文化传播有限公司</td>
        	</tr>
        	<tr>
        		<td class="td1">099</td>
        		<td class="td2">小荧星涂鸦特色活动</td>
        		<td class="td3">上海上视小荧星文化艺术培训学校</td>
        	</tr>
        	<tr>
        		<td class="td1">100</td>
        		<td class="td2">音乐启蒙活动</td>
        		<td class="td3">上海石娃社区艺术服务中心</td>
        	</tr>
        </table>
    </div>
    <div class="ggwhfoot">
        <div class="nc">
            指导单位：上海市民文化节指导委员会<br>
            主办单位：上海市群众艺术馆　　各区文化（广）局<br>
            承办单位：上海市东方公共文化配送中心（筹）<br>
            　　　　　上海市民文化协会      各区公共文化配送中心<br>
            技术平台：文化上海云
        </div>
    </div>
</div>

</body>

</html>