<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>2017年上海市公共文化配送产品目录</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<style type="text/css">
html , body {height: 100%;}
.ggwhtop100 {width: 750px;min-height: 100%;margin: 0 auto;background:url(${path}/STATIC/wxStatic/image/pszx/ban2.jpg) no-repeat top center #3c1d4c;padding: 1px 0;}
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
	appShareTitle = '2017年上海市公共文化配送产品目录';
	appShareDesc = '2017年上海市公共文化配送产品目录，共计360个作品，点击详情……';
	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/pszx/shareIcon2017.png';
	
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
			title: "2017年上海市公共文化配送产品目录",
			desc: '2017年上海市公共文化配送产品目录，共计360个作品，点击详情……',
			link: '${basePath}wechatQyg/qygList2017.do',
			imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon2017.png'
		});
		wx.onMenuShareTimeline({
			title: "2017年上海市公共文化配送产品目录",
			imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon2017.png',
			link: '${basePath}wechatQyg/qygList2017.do'
		});
		wx.onMenuShareQQ({
			title: "2017年上海市公共文化配送产品目录",
			desc: '2017年上海市公共文化配送产品目录，共计360个作品，点击详情……',
			imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon2017.png'
		});
		wx.onMenuShareWeibo({
			title: "2017年上海市公共文化配送产品目录",
			desc: '2017年上海市公共文化配送产品目录，共计360个作品，点击详情……',
			imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon2017.png'
		});
		wx.onMenuShareQZone({
			title: "2017年上海市公共文化配送产品目录",
			desc: '2017年上海市公共文化配送产品目录，共计360个作品，点击详情……',
			imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon2017.png'
		});
	});
}

	var phoneWidth = parseInt(window.screen.width);
	var phoneScale = phoneWidth / 750;
	var ua = navigator.userAgent; //浏览器类型
	if(/Android (\d+\.\d+)/.test(ua)) { //判断是否是安卓系统
		var version = parseFloat(RegExp.$1); //安卓系统的版本号
		if(version > 2.3) {
			document.write('<meta name="viewport" content="width=750,user-scalable=no, minimum-scale = ' + phoneScale + ', maximum-scale = ' + (phoneScale) + ', target-densitydpi=device-dpi">');
		} else {
			document.write('<meta name="viewport" content="width=750,user-scalable=no, target-densitydpi=device-dpi">');
		}
	} else {
		document.write('<meta name="viewport" content="width=750,user-scalable=no, target-densitydpi=device-dpi">');
	}
</script>
<script type="text/javascript">
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
        <div class="tit"><em></em>文艺演出B类<em></em></div>
        <table class="table">
            <tr>
                <th class="td1">序号</th>
                <th class="td2">产品名称</th>
                <th class="td3">申报主体</th>
            </tr>
            <tr>
                <td class="td1">001</td>
                <td class="td2">“The Moments精彩的瞬间”专场演出</td>
                <td class="td3">上海舞筝文化策划有限公司</td>
            </tr>
            <tr>
                <td class="td1">002</td>
                <td class="td2">“爱的致意”中外名曲室内乐音乐会</td>
                <td class="td3">上海音韵室内乐团</td>
            </tr>
            <tr>
                <td class="td1">003</td>
                <td class="td2">“共圆中国梦”综艺演出</td>
                <td class="td3">上海万方文化艺术发展有限公司</td>
            </tr>
            <tr>
                <td class="td1">004</td>
                <td class="td2">“共筑中国梦”独唱重唱精品音乐会</td>
                <td class="td3">上海歌剧院</td>
            </tr>
            <tr>
                <td class="td1">005</td>
                <td class="td2">“鼓舞中国梦”鼓乐专场演出</td>
                <td class="td3">上海绛州鼓乐团</td>
            </tr>
            <tr>
                <td class="td1">006</td>
                <td class="td2">“惠风和畅”综艺专场演出</td>
                <td class="td3">上海李军文化艺术有限公司</td>
            </tr>
            <tr>
                <td class="td1">007</td>
                <td class="td2">“人生·收藏——与快乐同行”文艺汇演</td>
                <td class="td3">上海新影轻音乐团有限公司</td>
            </tr>
            <tr>
                <td class="td1">008</td>
                <td class="td2">“赏音悦目”女子弦乐四重奏音乐舞蹈音乐会</td>
                <td class="td3">上海音韵室内乐团</td>
            </tr>
            <tr>
                <td class="td1">009</td>
                <td class="td2">“喜乐相逢”综艺演出</td>
                <td class="td3">上海树信文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">010</td>
                <td class="td2">“喜乐相逢”综艺演出</td>
                <td class="td3">上海娱涵魔术杂技团</td>
            </tr>
            <tr>
                <td class="td1">011</td>
                <td class="td2">“献给祖国母亲的歌”陈剑波师生音乐会</td>
                <td class="td3">上海上体文化传媒有限公司</td>
            </tr>
            <tr>
                <td class="td1">012</td>
                <td class="td2">“相亲相爱一家人”综艺演出</td>
                <td class="td3">上海树信文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">013</td>
                <td class="td2">“向着伟大梦想·构筑中国梦”综艺演出</td>
                <td class="td3">上海新运星文化传媒有限公司</td>
            </tr>
            <tr>
                <td class="td1">014</td>
                <td class="td2">“向着伟大梦想·热血铸军魂”庆祝建军90周年文艺演出</td>
                <td class="td3">上海新运星文化传媒有限公司</td>
            </tr>
            <tr>
                <td class="td1">015</td>
                <td class="td2">“笑满人间”综合性滑稽说唱专场演出</td>
                <td class="td3">上海徐世利喜剧艺术团</td>
            </tr>
            <tr>
                <td class="td1">016</td>
                <td class="td2">“鱼水情深”大型军歌演唱会</td>
                <td class="td3">上海名仕歌舞团</td>
            </tr>
            <tr>
                <td class="td1">017</td>
                <td class="td2">芭蕾艺术精品品鉴演出</td>
                <td class="td3">上海芭蕾舞团</td>
            </tr>
            <tr>
                <td class="td1">018</td>
                <td class="td2">蔡嘎亮音乐脱口秀综艺演出专场</td>
                <td class="td3">上海市和德社区文化促进中心</td>
            </tr>
            <tr>
                <td class="td1">019</td>
                <td class="td2">传统经典沪剧《恩怨情未了》</td>
                <td class="td3">上海市长宁区沪剧传承中心（长宁沪剧团）</td>
            </tr>
            <tr>
                <td class="td1">020</td>
                <td class="td2">创新融合鼓武剧《兵马俑复活》</td>
                <td class="td3">上海鼓舞东方文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">021</td>
                <td class="td2">大型沪剧《法之魂》</td>
                <td class="td3">上海兰博沪剧团</td>
            </tr>
            <tr>
                <td class="td1">022</td>
                <td class="td2">大型黄梅戏舞台剧《梁祝》</td>
                <td class="td3">上海徽苑文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">023</td>
                <td class="td2">大型黄梅戏舞台剧《女驸马》</td>
                <td class="td3">上海徽苑文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">024</td>
                <td class="td2">大型经典传统沪剧《陆雅臣》</td>
                <td class="td3">上海紫华沪剧团</td>
            </tr>
            <tr>
                <td class="td1">025</td>
                <td class="td2">大型经典沪剧《大雷雨》</td>
                <td class="td3">上海闵行七一艺社</td>
            </tr>
            <tr>
                <td class="td1">026</td>
                <td class="td2">大型抗战话剧《灵魂拒葬》</td>
                <td class="td3">上海东八剧团</td>
            </tr>
            <tr>
                <td class="td1">027</td>
                <td class="td2">大型新编沪剧《两代恩怨》</td>
                <td class="td3">上海市长宁区沪剧传承中心（长宁沪剧团）</td>
            </tr>
            <tr>
                <td class="td1">028</td>
                <td class="td2">大型原创沪剧《板桥霜》</td>
                <td class="td3">上海闵行区新虹民乐沪剧文化服务中心</td>
            </tr>
            <tr>
                <td class="td1">029</td>
                <td class="td2">多媒体人偶剧《世界上所有的时间》</td>
                <td class="td3">上海话剧艺术中心有限公司</td>
            </tr>
            <tr>
                <td class="td1">030</td>
                <td class="td2">儿童剧《大红豆·变变变》</td>
                <td class="td3">中国福利会儿童艺术剧院</td>
            </tr>
            <tr>
                <td class="td1">031</td>
                <td class="td2">儿童剧《小魔盒》童话梦第二季</td>
                <td class="td3">中国福利会儿童艺术剧院</td>
            </tr>
            <tr>
                <td class="td1">032</td>
                <td class="td2">儿童剧《小魔盒》童话梦第三季</td>
                <td class="td3">中国福利会儿童艺术剧院</td>
            </tr>
            <tr>
                <td class="td1">033</td>
                <td class="td2">儿童情感儿童剧《外星人总动员》</td>
                <td class="td3">烁歆（上海）文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">034</td>
                <td class="td2">过佳节听民乐</td>
                <td class="td3">上海民族乐团</td>
            </tr>
            <tr>
                <td class="td1">035</td>
                <td class="td2">海派魔术梦幻秀《梦圆春申》  </td>
                <td class="td3">上海虹影魔幻艺术团（普通合伙）</td>
            </tr>
            <tr>
                <td class="td1">036</td>
                <td class="td2">韩版萌系亲子音乐剧《YooHoo带你环游世界》</td>
                <td class="td3">上海聚橙文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">037</td>
                <td class="td2">红色民乐经典</td>
                <td class="td3">上海民族乐团</td>
            </tr>
            <tr>
                <td class="td1">038</td>
                <td class="td2">沪剧《庵堂相会》</td>
                <td class="td3">上海沪剧艺术传习所（上海沪剧院）</td>
            </tr>
            <tr>
                <td class="td1">039</td>
                <td class="td2">沪剧经典折子戏</td>
                <td class="td3">上海市长宁区沪剧传承中心（长宁沪剧团）</td>
            </tr>
            <tr>
                <td class="td1">040</td>
                <td class="td2">沪剧折子戏专场演出</td>
                <td class="td3">上海沪剧艺术传习所（上海沪剧院）</td>
            </tr>
            <tr>
                <td class="td1">041</td>
                <td class="td2">话剧《老鼠的喜剧》</td>
                <td class="td3">上海现代人剧社</td>
            </tr>
            <tr>
                <td class="td1">042</td>
                <td class="td2">欢乐马戏（社区版）</td>
                <td class="td3">上海杂技团有限公司</td>
            </tr>
            <tr>
                <td class="td1">043</td>
                <td class="td2">黄梅戏《天仙配》</td>
                <td class="td3">上海演出家艺术团</td>
            </tr>
            <tr>
                <td class="td1">044</td>
                <td class="td2">黄梅戏《真假新郎》</td>
                <td class="td3">上海演出家艺术团</td>
            </tr>
            <tr>
                <td class="td1">045</td>
                <td class="td2">京剧专场演出</td>
                <td class="td3">上海徐汇燕萍京剧团</td>
            </tr>
            <tr>
                <td class="td1">046</td>
                <td class="td2">经典木偶剧系列</td>
                <td class="td3">上海木偶剧团有限公司</td>
            </tr>
            <tr>
                <td class="td1">047</td>
                <td class="td2">经典折子戏专场</td>
                <td class="td3">上海紫华沪剧团</td>
            </tr>
            <tr>
                <td class="td1">048</td>
                <td class="td2">精品折子戏专场（二）</td>
                <td class="td3">上海越剧艺术传习所（上海越剧院）</td>
            </tr>
            <tr>
                <td class="td1">049</td>
                <td class="td2">精品折子戏专场（一）</td>
                <td class="td3">上海越剧艺术传习所（上海越剧院）</td>
            </tr>
            <tr>
                <td class="td1">050</td>
                <td class="td2">久石让的动漫音乐世界</td>
                <td class="td3">上海寿昌文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">051</td>
                <td class="td2">科普木偶剧《耳朵里的小河》</td>
                <td class="td3">烁歆（上海）文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">052</td>
                <td class="td2">民歌大会</td>
                <td class="td3">上海阳与光舞蹈团有限公司</td>
            </tr>
            <tr>
                <td class="td1">053</td>
                <td class="td2">魔术儿童剧《魔法天下》</td>
                <td class="td3">上海青年马戏团有限公司</td>
            </tr>
            <tr>
                <td class="td1">054</td>
                <td class="td2">魔术杂技专场</td>
                <td class="td3">上海娱涵魔术杂技团</td>
            </tr>
            <tr>
                <td class="td1">055</td>
                <td class="td2">浦江情（社区版）</td>
                <td class="td3">上海杂技团有限公司</td>
            </tr>
            <tr>
                <td class="td1">056</td>
                <td class="td2">戏曲梨园颂专场演出</td>
                <td class="td3">上海振兴戏剧院有限公司</td>
            </tr>
            <tr>
                <td class="td1">057</td>
                <td class="td2">小剧场话剧《生存法则》</td>
                <td class="td3">上海话剧艺术中心有限公司</td>
            </tr>
            <tr>
                <td class="td1">058</td>
                <td class="td2">心古典世界名曲普及“音悦汇”</td>
                <td class="td3">上海心古典交响乐团</td>
            </tr>
            <tr>
                <td class="td1">059</td>
                <td class="td2">原创沪剧《51把钥匙》</td>
                <td class="td3">上海勤苑沪剧团</td>
            </tr>
            <tr>
                <td class="td1">060</td>
                <td class="td2">越剧《孔雀东南飞》</td>
                <td class="td3">上海肖雅文化艺术有限公司</td>
            </tr>
            <tr>
                <td class="td1">061</td>
                <td class="td2">越剧《失子惊疯》</td>
                <td class="td3">上海市徐汇越剧团</td>
            </tr>
            <tr>
                <td class="td1">062</td>
                <td class="td2">越剧《玉堂春》</td>
                <td class="td3">上海市徐汇越剧团</td>
            </tr>
            <tr>
                <td class="td1">063</td>
                <td class="td2">越剧《珍珠塔》</td>
                <td class="td3">上海市徐汇越剧团</td>
            </tr>
            <tr>
                <td class="td1">064</td>
                <td class="td2">杂技幽默剧《三毛哈哈秀》</td>
                <td class="td3">上海青年马戏团有限公司</td>
            </tr>
            <tr>
                <td class="td1">065</td>
                <td class="td2">中外名曲音乐会</td>
                <td class="td3">上海大众乐团</td>
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
                <td class="td1">066</td>
                <td class="td2">“穿越四季”室内交响乐音乐会</td>
                <td class="td3">上海大地之歌室内交响乐团有限公司</td>
            </tr>
            <tr>
                <td class="td1">067</td>
                <td class="td2">“东西南北风”民乐经典专场演出</td>
                <td class="td3">上海民族乐团</td>
            </tr>
            <tr>
                <td class="td1">068</td>
                <td class="td2">“繁花似锦中国梦”综艺演出</td>
                <td class="td3">上海左邻右舍文化艺术传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">069</td>
                <td class="td2">“共圆中国梦·喜迎十八大”综艺演出</td>
                <td class="td3">上海演出家艺术团</td>
            </tr>
            <tr>
                <td class="td1">070</td>
                <td class="td2">“和谐心声”文艺巡演</td>
                <td class="td3">上海益联文化艺术有限公司</td>
            </tr>
            <tr>
                <td class="td1">071</td>
                <td class="td2">“绝妙演绎”超级音乐与模仿秀专场</td>
                <td class="td3">上海市和德社区文化促进中心</td>
            </tr>
            <tr>
                <td class="td1">072</td>
                <td class="td2">“开心•关心•齐心笑”滑稽小品专场演出</td>
                <td class="td3">上海怡莲文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">073</td>
                <td class="td2">“乐在上海·笑侃‘申’活”专场文艺演出</td>
                <td class="td3">上海乐辉文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">074</td>
                <td class="td2">“流金岁月”经典歌曲演唱会</td>
                <td class="td3">上海轻音乐团有限公司</td>
            </tr>
            <tr>
                <td class="td1">075</td>
                <td class="td2">“难忘激情岁月”优秀经典影视歌曲演唱会</td>
                <td class="td3">上海奏凯文化艺术有限公司</td>
            </tr>
            <tr>
                <td class="td1">076</td>
                <td class="td2">“凝聚社区居民·建设美好家圆”综艺演出</td>
                <td class="td3">上海申江艺术团</td>
            </tr>
            <tr>
                <td class="td1">077</td>
                <td class="td2">“侬好，阿拉上海人”上海经典怀旧金曲演唱会</td>
                <td class="td3">上海奏凯文化艺术有限公司</td>
            </tr>
            <tr>
                <td class="td1">078</td>
                <td class="td2">“曲艺流芳”曲艺专场演出</td>
                <td class="td3">上海李军文化艺术有限公司</td>
            </tr>
            <tr>
                <td class="td1">079</td>
                <td class="td2">“上海风情”精品音乐会</td>
                <td class="td3">上海海邻爵士乐团有限公司</td>
            </tr>
            <tr>
                <td class="td1">080</td>
                <td class="td2">“上海老声音”滑稽戏曲专场</td>
                <td class="td3">上海蜜丰滑稽剧团有限公司</td>
            </tr>
            <tr>
                <td class="td1">081</td>
                <td class="td2">“文化点亮生活”综艺演出</td>
                <td class="td3">上海星灿文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">082</td>
                <td class="td2">“文化惠民新气象•演艺传递正能量”综艺演出</td>
                <td class="td3">上海怡莲文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">083</td>
                <td class="td2">“永远快快乐乐”综艺演出</td>
                <td class="td3">上海永乐纵横文化艺术有限公司</td>
            </tr>
            <tr>
                <td class="td1">084</td>
                <td class="td2">《妈妈咪呀》电视真人秀获奖选手演唱会</td>
                <td class="td3">上海新影轻音乐团有限公司</td>
            </tr>
            <tr>
                <td class="td1">085</td>
                <td class="td2">爆笑儿童舞台剧《小红帽智逗狼外婆》</td>
                <td class="td3">上海丫丫兔艺术剧团</td>
            </tr>
            <tr>
                <td class="td1">086</td>
                <td class="td2">传统沪剧《陆雅臣》</td>
                <td class="td3">上海王勤沪剧团</td>
            </tr>
            <tr>
                <td class="td1">087</td>
                <td class="td2">传统京剧折子戏专场演出</td>
                <td class="td3">上海徐汇燕萍京剧团</td>
            </tr>
            <tr>
                <td class="td1">088</td>
                <td class="td2">大型传统沪剧《阿必大新传》</td>
                <td class="td3">上海文亚文化艺术团</td>
            </tr>
            <tr>
                <td class="td1">089</td>
                <td class="td2">大型传统沪剧《槐花泪》</td>
                <td class="td3">上海文慧沪剧团</td>
            </tr>
            <tr>
                <td class="td1">090</td>
                <td class="td2">大型法制宣传滑稽戏《房产证风波》</td>
                <td class="td3">上海佳好艺术剧团有限公司</td>
            </tr>
            <tr>
                <td class="td1">091</td>
                <td class="td2">大型法制宣传滑稽戏《孝在何方》</td>
                <td class="td3">上海佳好艺术剧团有限公司</td>
            </tr>
            <tr>
                <td class="td1">092</td>
                <td class="td2">大型古装越剧《陆游与唐婉》</td>
                <td class="td3">上海智准文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">093</td>
                <td class="td2">大型黄梅戏折子戏专场</td>
                <td class="td3">上海徽苑文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">094</td>
                <td class="td2">大型原创沪剧《家园的春天》</td>
                <td class="td3">上海勤怡沪剧团</td>
            </tr>
            <tr>
                <td class="td1">095</td>
                <td class="td2">儿童剧《超级狼爸比》</td>
                <td class="td3">上海谷都文化演出有限公司</td>
            </tr>
            <tr>
                <td class="td1">096</td>
                <td class="td2">鼓鼓专场音乐会《鼓动乾坤》</td>
                <td class="td3">上海鼓鼓文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">097</td>
                <td class="td2">红歌专题音乐会</td>
                <td class="td3">上海海邻爵士乐团有限公司</td>
            </tr>
            <tr>
                <td class="td1">098</td>
                <td class="td2">红色主题木偶剧系列</td>
                <td class="td3">上海木偶剧团有限公司</td>
            </tr>
            <tr>
                <td class="td1">099</td>
                <td class="td2">互动魔幻童话剧《绿野仙踪》</td>
                <td class="td3">上海叮当剧社</td>
            </tr>
            <tr>
                <td class="td1">100</td>
                <td class="td2">沪剧《女律师的遭遇》</td>
                <td class="td3">上海王勤沪剧团</td>
            </tr>
            <tr>
                <td class="td1">101</td>
                <td class="td2">沪剧大戏《白艳冰雪地产子》</td>
                <td class="td3">上海荣恺文化艺术传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">102</td>
                <td class="td2">沪剧名家折子戏专场</td>
                <td class="td3">上海星妍文化服务中心</td>
            </tr>
            <tr>
                <td class="td1">103</td>
                <td class="td2">滑稽青年人才曲艺专场演出</td>
                <td class="td3">上海滑稽剧团有限公司</td>
            </tr>
            <tr>
                <td class="td1">104</td>
                <td class="td2">淮剧折子戏专场演出</td>
                <td class="td3">上海淮剧艺术传习所（上海淮剧团）</td>
            </tr>
            <tr>
                <td class="td1">105</td>
                <td class="td2">经典传统沪剧大戏《庵堂相会》</td>
                <td class="td3">上海雁韵文化艺术中心</td>
            </tr>
            <tr>
                <td class="td1">106</td>
                <td class="td2">经典卡通励志剧《三只小猪》</td>
                <td class="td3">上海叮当剧社</td>
            </tr>
            <tr>
                <td class="td1">107</td>
                <td class="td2">军旅歌唱家“经典老歌”歌舞专场演出</td>
                <td class="td3">上海名仕歌舞团</td>
            </tr>
            <tr>
                <td class="td1">108</td>
                <td class="td2">科普儿童剧《臭臭城历险记》</td>
                <td class="td3">上海光瑀文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">109</td>
                <td class="td2">劳动者之歌</td>
                <td class="td3">上海纽克拉爵士乐团</td>
            </tr>
            <tr>
                <td class="td1">110</td>
                <td class="td2">民族绝技绝活大荟萃</td>
                <td class="td3">上海阳与光舞蹈团有限公司</td>
            </tr>
            <tr>
                <td class="td1">111</td>
                <td class="td2">魔幻泡泡秀《爱丽丝梦游泡泡仙境》</td>
                <td class="td3">上海聚橙文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">112</td>
                <td class="td2">莫派与海派魔术汇演</td>
                <td class="td3">上海乾韵文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">113</td>
                <td class="td2">青少年防诱拐安全教育正能量舞台剧《天空中最闪亮的星》</td>
                <td class="td3">上海丫丫兔艺术剧团</td>
            </tr>
            <tr>
                <td class="td1">114</td>
                <td class="td2">轻喜剧《下一站，幸福里》</td>
                <td class="td3">上海左邻右舍文化艺术传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">115</td>
                <td class="td2">情景魔术专场《魔法三人行》</td>
                <td class="td3">上海爪玛文化艺术传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">116</td>
                <td class="td2">全本经典越剧《一缕麻》</td>
                <td class="td3">上海梵馨艺术团</td>
            </tr>
            <tr>
                <td class="td1">117</td>
                <td class="td2">上海市北交响乐团专场音乐会</td>
                <td class="td3">上海海娜音乐艺术中心</td>
            </tr>
            <tr>
                <td class="td1">118</td>
                <td class="td2">水滴弦乐四重奏专场演出</td>
                <td class="td3">上海交响乐团</td>
            </tr>
            <tr>
                <td class="td1">119</td>
                <td class="td2">童话主题木偶剧系列</td>
                <td class="td3">上海木偶剧团有限公司</td>
            </tr>
            <tr>
                <td class="td1">120</td>
                <td class="td2">戏曲·音乐秀专场音乐会</td>
                <td class="td3">上海百音鸟广告有限公司</td>
            </tr>
            <tr>
                <td class="td1">121</td>
                <td class="td2">新版沪剧《孤岛血泪》</td>
                <td class="td3">上海勤怡沪剧团</td>
            </tr>
            <tr>
                <td class="td1">122</td>
                <td class="td2">星妍综艺专场</td>
                <td class="td3">上海星妍文化服务中心</td>
            </tr>
            <tr>
                <td class="td1">123</td>
                <td class="td2">异域魔幻儿童剧《 阿拉丁与公主 》</td>
                <td class="td3">上海叮当剧社</td>
            </tr>
            <tr>
                <td class="td1">124</td>
                <td class="td2">幽默小丑秀《欢乐五人行》</td>
                <td class="td3">上海青年马戏团有限公司</td>
            </tr>
            <tr>
                <td class="td1">125</td>
                <td class="td2">原创沪剧《雷雨后》</td>
                <td class="td3">上海勤苑沪剧团</td>
            </tr>
            <tr>
                <td class="td1">126</td>
                <td class="td2">越剧《梁祝》</td>
                <td class="td3">上海肖雅文化艺术有限公司</td>
            </tr>
            <tr>
                <td class="td1">127</td>
                <td class="td2">越剧《盘夫索夫》</td>
                <td class="td3">上海闵行七一艺社</td>
            </tr>
            <tr>
                <td class="td1">128</td>
                <td class="td2">越剧《珍珠塔》</td>
                <td class="td3">上海肖雅文化艺术有限公司</td>
            </tr>
            <tr>
                <td class="td1">129</td>
                <td class="td2">中国著名音乐翻译家薛范专题音乐会</td>
                <td class="td3">上海腾韵交响乐团有限公司</td>
            </tr>
            <tr>
                <td class="td1">130</td>
                <td class="td2">中外电影音乐会</td>
                <td class="td3">上海大众乐团</td>
            </tr>
            <tr>
                <td class="td1">131</td>
                <td class="td2">中外经典名曲音乐会</td>
                <td class="td3">上海睿年交响乐团</td>
            </tr>
            <tr>
                <td class="td1">132</td>
                <td class="td2">综艺演出 《欢歌笑语2017》</td>
                <td class="td3">上海智准文化传播有限公司</td>
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
                <td class="td1">133</td>
                <td class="td2">“传承红色经典·中国梦想飞扬”专场演出</td>
                <td class="td3">上海乐辉文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">134</td>
                <td class="td2">“共逐中国梦”综艺专场</td>
                <td class="td3">上海蜜丰滑稽剧团有限公司</td>
            </tr>
            <tr>
                <td class="td1">135</td>
                <td class="td2">“静抚悠然丝·安坐闻弦音”大型民族音乐会</td>
                <td class="td3">上海庆音文化艺术团</td>
            </tr>
            <tr>
                <td class="td1">136</td>
                <td class="td2">“南北逗”相声滑稽曲艺专场</td>
                <td class="td3">上海乐辉文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">137</td>
                <td class="td2">“平安添异彩·社区更精彩”综艺演出</td>
                <td class="td3">上海申江艺术团</td>
            </tr>
            <tr>
                <td class="td1">138</td>
                <td class="td2">“青春集结号吹响正能量”综艺演出</td>
                <td class="td3">上海怡莲文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">139</td>
                <td class="td2">“曲韵流芳”戏曲专场演出</td>
                <td class="td3">上海李军文化艺术有限公司</td>
            </tr>
            <tr>
                <td class="td1">140</td>
                <td class="td2">“申城春晖”文化馆民乐团民乐专场表演</td>
                <td class="td3">上海新影轻音乐团有限公司</td>
            </tr>
            <tr>
                <td class="td1">141</td>
                <td class="td2">“申曲永流传”沪剧折子戏专场（经典版）</td>
                <td class="td3">上海市沪东之星文化服务中心</td>
            </tr>
            <tr>
                <td class="td1">142</td>
                <td class="td2">“笙箫心曲越风扬”越剧经典折子戏专场</td>
                <td class="td3">上海晓韵文化艺术传播有限公司虹口分公司</td>
            </tr>
            <tr>
                <td class="td1">143</td>
                <td class="td2">“十全十美”民族音乐精粹专场演出</td>
                <td class="td3">上海庆音文化艺术团</td>
            </tr>
            <tr>
                <td class="td1">144</td>
                <td class="td2">“西方音乐之旅”室内乐音乐会</td>
                <td class="td3">热浪文化传播发展（上海）有限公司</td>
            </tr>
            <tr>
                <td class="td1">145</td>
                <td class="td2">“乡曲乡音”经典沪剧专场演出</td>
                <td class="td3">上海申江艺术团</td>
            </tr>
            <tr>
                <td class="td1">146</td>
                <td class="td2">“相声中国风”曲艺专场</td>
                <td class="td3">上海松涛说唱艺术推广交流中心</td>
            </tr>
            <tr>
                <td class="td1">147</td>
                <td class="td2">“笑口常开”滑稽戏、独脚戏专场演出</td>
                <td class="td3">上海梵馨艺术团</td>
            </tr>
            <tr>
                <td class="td1">148</td>
                <td class="td2">“笑声与歌声”综艺演出</td>
                <td class="td3">上海星灿文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">149</td>
                <td class="td2">“心弦”音乐会</td>
                <td class="td3">上海心古典交响乐团</td>
            </tr>
            <tr>
                <td class="td1">150</td>
                <td class="td2">“星光灿烂耀浦江”综艺演出</td>
                <td class="td3">上海星灿文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">151</td>
                <td class="td2">“星光梦”杂技专场</td>
                <td class="td3">上海星光杂技艺术团</td>
            </tr>
            <tr>
                <td class="td1">152</td>
                <td class="td2">“雅韵颂中华”综艺演出专场</td>
                <td class="td3">上海浦雅文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">153</td>
                <td class="td2">北极星弦乐四重奏专场演出</td>
                <td class="td3">上海海娜音乐艺术中心</td>
            </tr>
            <tr>
                <td class="td1">154</td>
                <td class="td2">大型传统经典越剧《何文秀》精选</td>
                <td class="td3">上海晓韵文化艺术传播有限公司虹口分公司</td>
            </tr>
            <tr>
                <td class="td1">155</td>
                <td class="td2">大型传统经典越剧《情探》精选</td>
                <td class="td3">上海晓韵文化艺术传播有限公司虹口分公司</td>
            </tr>
            <tr>
                <td class="td1">156</td>
                <td class="td2">灯与影的艺术——“皮影戏”专场演出</td>
                <td class="td3">上海城市动漫出版传媒有限公司</td>
            </tr>
            <tr>
                <td class="td1">157</td>
                <td class="td2">郭德纲弟子“笑乐汇”相声专场</td>
                <td class="td3">笑苑（上海）文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">158</td>
                <td class="td2">沪剧经典折子戏专场演出</td>
                <td class="td3">上海荣恺文化艺术传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">159</td>
                <td class="td2">沪剧杨派经典折子戏专场</td>
                <td class="td3">上海勤怡沪剧团</td>
            </tr>
            <tr>
                <td class="td1">160</td>
                <td class="td2">沪剧折子戏</td>
                <td class="td3">上海文慧沪剧团</td>
            </tr>
            <tr>
                <td class="td1">161</td>
                <td class="td2">沪剧折子戏专场演出</td>
                <td class="td3">上海雁韵文化艺术中心</td>
            </tr>
            <tr>
                <td class="td1">162</td>
                <td class="td2">科普儿童剧《数学岛小侦探》</td>
                <td class="td3">上海光瑀文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">163</td>
                <td class="td2">科普儿童剧《细菌争霸战》</td>
                <td class="td3">上海光瑀文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">164</td>
                <td class="td2">评弹经典书目专场</td>
                <td class="td3">上海评弹艺术传习所（上海评弹团）</td>
            </tr>
            <tr>
                <td class="td1">165</td>
                <td class="td2">评弹专场</td>
                <td class="td3">上海评弹艺术传习所（上海评弹团）</td>
            </tr>
            <tr>
                <td class="td1">166</td>
                <td class="td2">上海电视台艺术团综艺节目专场</td>
                <td class="td3">上海电视台艺术团</td>
            </tr>
            <tr>
                <td class="td1">167</td>
                <td class="td2">戏曲专场</td>
                <td class="td3">上海王勤沪剧团</td>
            </tr>
            <tr>
                <td class="td1">168</td>
                <td class="td2">现代京剧演唱专场</td>
                <td class="td3">上海徐汇燕萍京剧团</td>
            </tr>
            <tr>
                <td class="td1">169</td>
                <td class="td2">原创儿童剧《小红帽之魔法水晶球》</td>
                <td class="td3">上海城市动漫出版传媒有限公司</td>
            </tr>
            <tr>
                <td class="td1">170</td>
                <td class="td2">越剧《花中君子》选场</td>
                <td class="td3">上海卿昕文化艺术中心</td>
            </tr>
            <tr>
                <td class="td1">171</td>
                <td class="td2">越剧《梁祝》选场</td>
                <td class="td3">上海卿昕文化艺术中心</td>
            </tr>
            <tr>
                <td class="td1">172</td>
                <td class="td2">中型综艺专场</td>
                <td class="td3">上海文亚文化艺术团</td>
            </tr>
            <tr>
                <td class="td1">173</td>
                <td class="td2">综艺演出《我们的中国梦》</td>
                <td class="td3">上海智准文化传播有限公司</td>
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
                <td class="td1">174</td>
                <td class="td2"> “艺术永恒”非遗文化专题导赏</td>
                <td class="td3">上海市沪东之星文化服务中心</td>
            </tr>
            <tr>
                <td class="td1">175</td>
                <td class="td2">“爱乐唱响”专场音乐会</td>
                <td class="td3">上海爱乐合唱团</td>
            </tr>
            <tr>
                <td class="td1">176</td>
                <td class="td2">“传统文化传承，从江南古典园林说起”专题导赏</td>
                <td class="td3">上海青果巷子传统文化促进中心</td>
            </tr>
            <tr>
                <td class="td1">177</td>
                <td class="td2">“吹奏天下”民族吹管乐艺术赏析</td>
                <td class="td3">上海民族乐团</td>
            </tr>
            <tr>
                <td class="td1">178</td>
                <td class="td2">“大爱无疆——用童话与童声传递爱”专题导赏</td>
                <td class="td3">上海长宁区音乐之声艺术团</td>
            </tr>
            <tr>
                <td class="td1">179</td>
                <td class="td2">“大珠小珠落玉盘”琵琶艺术导赏</td>
                <td class="td3">上海鹤音文化传媒有限公司</td>
            </tr>
            <tr>
                <td class="td1">180</td>
                <td class="td2">“弹指挥间”民族弹拨乐艺术赏析</td>
                <td class="td3">上海民族乐团</td>
            </tr>
            <tr>
                <td class="td1">181</td>
                <td class="td2">“感动与梦想”音乐故事互动赏析</td>
                <td class="td3">上海星宇旅游发展有限公司</td>
            </tr>
            <tr>
                <td class="td1">182</td>
                <td class="td2">“弓弦魅力”室内乐赏析音乐会</td>
                <td class="td3">上海爱乐乐团</td>
            </tr>
            <tr>
                <td class="td1">183</td>
                <td class="td2">“顾绣”专题导赏</td>
                <td class="td3">上海智基文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">184</td>
                <td class="td2">“海上花”百年旗袍与老上海专题导赏</td>
                <td class="td3">上海文化出版社有限公司</td>
            </tr>
            <tr>
                <td class="td1">185</td>
                <td class="td2">“沪剧·传承”专题导赏</td>
                <td class="td3">上海文亚文化艺术团</td>
            </tr>
            <tr>
                <td class="td1">186</td>
                <td class="td2">“沪韵悠悠唱中华”申曲导赏</td>
                <td class="td3">上海浦雅文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">187</td>
                <td class="td2">“今话明说”海派相声导赏</td>
                <td class="td3">上海乐辉文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">188</td>
                <td class="td2">“老有意思”摄影导赏</td>
                <td class="td3">上海稻橙文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">189</td>
                <td class="td2">“娜样情淮”邢娜淮剧艺术导赏</td>
                <td class="td3">上海淮剧艺术传习所（上海淮剧团）</td>
            </tr>
            <tr>
                <td class="td1">190</td>
                <td class="td2">“年轻之舞”民间广场舞艺术导赏</td>
                <td class="td3">上海骏轶文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">191</td>
                <td class="td2">“青春越剧进社区”专题导赏</td>
                <td class="td3">上海秋霞圃传统文化研究院</td>
            </tr>
            <tr>
                <td class="td1">192</td>
                <td class="td2">“如何选画”——家居审美专题导赏</td>
                <td class="td3">上海纽约大学</td>
            </tr>
            <tr>
                <td class="td1">193</td>
                <td class="td2">“我教你演魔术变变变”专题导赏</td>
                <td class="td3">上海爪玛文化艺术传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">194</td>
                <td class="td2">“戏遊季”戏剧艺术导赏</td>
                <td class="td3">上海话剧艺术中心有限公司</td>
            </tr>
            <tr>
                <td class="td1">195</td>
                <td class="td2">“弦歌行”民族拉弦乐艺术赏析</td>
                <td class="td3">上海民族乐团</td>
            </tr>
            <tr>
                <td class="td1">196</td>
                <td class="td2">“香”文化艺术导赏</td>
                <td class="td3">上海本茗文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">197</td>
                <td class="td2">“雅乐共赏”古琴艺术导赏</td>
                <td class="td3">上海山上石影业有限公司</td>
            </tr>
            <tr>
                <td class="td1">198</td>
                <td class="td2">“艺术惠民·至高无上”艺术导赏</td>
                <td class="td3">上海市和德社区文化促进中心</td>
            </tr>
            <tr>
                <td class="td1">199</td>
                <td class="td2">“音乐与心灵的互动：艺术导赏</td>
                <td class="td3">上海大众乐团</td>
            </tr>
            <tr>
                <td class="td1">200</td>
                <td class="td2">“影音中邂逅”钢琴电影配乐艺术导赏</td>
                <td class="td3">热浪文化传播发展（上海）有限公司</td>
            </tr>
            <tr>
                <td class="td1">201</td>
                <td class="td2">“永恒的阳光”莫扎特音乐作品导赏</td>
                <td class="td3">上海海娜音乐艺术中心</td>
            </tr>
            <tr>
                <td class="td1">202</td>
                <td class="td2">“越剧综合美”艺术导赏</td>
                <td class="td3">上海智准文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">203</td>
                <td class="td2">“杂唱数来宝”中国传统节击乐器之快板导赏</td>
                <td class="td3">上海乐辉文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">204</td>
                <td class="td2">“中国风”大美昆曲专题导赏</td>
                <td class="td3">上海新影轻音乐团有限公司</td>
            </tr>
            <tr>
                <td class="td1">205</td>
                <td class="td2">《交响管乐》管乐在交响音乐中的作用与未来</td>
                <td class="td3">上海寿昌文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">206</td>
                <td class="td2">2017“国学文化与养生”导赏活动</td>
                <td class="td3">上海泽衡文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">207</td>
                <td class="td2">2017“社区好声音”艺术导赏</td>
                <td class="td3">上海泽衡文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">208</td>
                <td class="td2">2017“说学唱演”沪语艺术导赏活动</td>
                <td class="td3">上海泽衡文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">209</td>
                <td class="td2">编创和跳好广场舞与中国舞蹈赏析</td>
                <td class="td3">上海阳与光舞蹈团有限公司</td>
            </tr>
            <tr>
                <td class="td1">210</td>
                <td class="td2">打击乐器中的新成员——“手碟”艺术赏析</td>
                <td class="td3">烁歆（上海）文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">211</td>
                <td class="td2">钢琴邂逅弦乐四重奏专题导赏</td>
                <td class="td3">上海轻音乐团有限公司</td>
            </tr>
            <tr>
                <td class="td1">212</td>
                <td class="td2">革命歌曲与进步歌曲艺术导赏</td>
                <td class="td3">上海市东方城市历史文化收藏交流中心</td>
            </tr>
            <tr>
                <td class="td1">213</td>
                <td class="td2">宫廷八卦掌艺术、文化、养生分享体验课</td>
                <td class="td3">上海东方广播有限公司</td>
            </tr>
            <tr>
                <td class="td1">214</td>
                <td class="td2">古琴赏析</td>
                <td class="td3">烁歆（上海）文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">215</td>
                <td class="td2">古琴艺术导赏</td>
                <td class="td3">上海石娃社区艺术服务中心</td>
            </tr>
            <tr>
                <td class="td1">216</td>
                <td class="td2">古诗文诵读与欣赏</td>
                <td class="td3">上海秋霞圃传统文化研究院</td>
            </tr>
            <tr>
                <td class="td1">217</td>
                <td class="td2">海派魔术的传承与发展专题导赏</td>
                <td class="td3">上海虹影魔幻艺术团（普通合伙）</td>
            </tr>
            <tr>
                <td class="td1">218</td>
                <td class="td2">海派文化艺术导赏</td>
                <td class="td3">上海新运星文化传媒有限公司</td>
            </tr>
            <tr>
                <td class="td1">219</td>
                <td class="td2">海上奇葩——“滑稽”艺术专题导赏</td>
                <td class="td3">上海睦联文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">220</td>
                <td class="td2">沪剧导赏《王盘声和他的“王派”唱腔艺术》</td>
                <td class="td3">上海勤苑沪剧团</td>
            </tr>
            <tr>
                <td class="td1">221</td>
                <td class="td2">沪剧流派和名段赏析</td>
                <td class="td3">上海勤苑沪剧团</td>
            </tr>
            <tr>
                <td class="td1">222</td>
                <td class="td2">沪剧艺术导赏</td>
                <td class="td3">上海荣恺文化艺术传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">223</td>
                <td class="td2">纪晓兰系列艺术导赏</td>
                <td class="td3">上海海邻爵士乐团有限公司</td>
            </tr>
            <tr>
                <td class="td1">224</td>
                <td class="td2">江南丝竹艺术导赏</td>
                <td class="td3">上海鹤音文化传媒有限公司</td>
            </tr>
            <tr>
                <td class="td1">225</td>
                <td class="td2">流行歌曲演唱入门专题导赏</td>
                <td class="td3">上海纽克拉爵士乐团</td>
            </tr>
            <tr>
                <td class="td1">226</td>
                <td class="td2">毛主席诗词艺术导赏</td>
                <td class="td3">上海石娃社区艺术服务中心</td>
            </tr>
            <tr>
                <td class="td1">227</td>
                <td class="td2">魔术师与经典作品浅析</td>
                <td class="td3">上海乾韵文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">228</td>
                <td class="td2">莫派魔术传承专题导赏</td>
                <td class="td3">上海乾韵文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">229</td>
                <td class="td2">偶戏大课堂</td>
                <td class="td3">上海木偶剧团有限公司</td>
            </tr>
            <tr>
                <td class="td1">230</td>
                <td class="td2">评弹艺术导赏（二）</td>
                <td class="td3">上海评弹艺术传习所（上海评弹团）</td>
            </tr>
            <tr>
                <td class="td1">231</td>
                <td class="td2">评弹艺术导赏（一）</td>
                <td class="td3">上海评弹艺术传习所（上海评弹团）</td>
            </tr>
            <tr>
                <td class="td1">232</td>
                <td class="td2">情系非遗——立体剪折纸（立体纸艺）艺术导赏</td>
                <td class="td3">上海市东方城市历史文化收藏交流中心</td>
            </tr>
            <tr>
                <td class="td1">233</td>
                <td class="td2">趣味鼓乐导赏</td>
                <td class="td3">上海绛州鼓乐团</td>
            </tr>
            <tr>
                <td class="td1">234</td>
                <td class="td2">人人都是演员——即兴戏剧艺术导赏</td>
                <td class="td3">上海即创戏剧文化发展促进中心</td>
            </tr>
            <tr>
                <td class="td1">235</td>
                <td class="td2">如何在广场舞中融入专业拉丁舞蹈元素，做最“海派文化”的广场舞</td>
                <td class="td3">上海雅言文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">236</td>
                <td class="td2">上海话与说唱</td>
                <td class="td3">上海怡莲文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">237</td>
                <td class="td2">声音的艺术魅力专题导赏</td>
                <td class="td3">上海锦霞教育信息咨询有限公司</td>
            </tr>
            <tr>
                <td class="td1">238</td>
                <td class="td2">首席带您领略舞蹈的魅力</td>
                <td class="td3">上海歌剧院</td>
            </tr>
            <tr>
                <td class="td1">239</td>
                <td class="td2">太极艺术、文化、养生分享体验课</td>
                <td class="td3">上海东方广播有限公司</td>
            </tr>
            <tr>
                <td class="td1">240</td>
                <td class="td2">探秘京剧老生艺术</td>
                <td class="td3">上海青果巷子传统文化促进中心</td>
            </tr>
            <tr>
                <td class="td1">241</td>
                <td class="td2">微童话赏析</td>
                <td class="td3">上海长宁区音乐之声艺术团</td>
            </tr>
            <tr>
                <td class="td1">242</td>
                <td class="td2">闻香识茶系列导赏</td>
                <td class="td3">上海音韵室内乐团</td>
            </tr>
            <tr>
                <td class="td1">243</td>
                <td class="td2">我是怎样表演上海说唱的——唱、说、演、噱、动五大艺术特色专题导赏</td>
                <td class="td3">上海睦联文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">244</td>
                <td class="td2">吴侬软语——苏州评弹艺术导赏</td>
                <td class="td3">上海山上石影业有限公司</td>
            </tr>
            <tr>
                <td class="td1">245</td>
                <td class="td2">西班牙弗拉门戈艺术导赏</td>
                <td class="td3">上海山上石影业有限公司</td>
            </tr>
            <tr>
                <td class="td1">246</td>
                <td class="td2">西方古典音乐赏析</td>
                <td class="td3">上海秋霞圃传统文化研究院</td>
            </tr>
            <tr>
                <td class="td1">247</td>
                <td class="td2">夏威夷文化与舞蹈导赏</td>
                <td class="td3">上海璞瓦文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">248</td>
                <td class="td2">小提琴协奏曲《梁祝》赏析</td>
                <td class="td3">上海海娜音乐艺术中心</td>
            </tr>
            <tr>
                <td class="td1">249</td>
                <td class="td2">壹堂•音乐课——中国艺术歌曲导赏</td>
                <td class="td3">上海宜音文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">250</td>
                <td class="td2">咏春拳中的文化、防身分享体验课</td>
                <td class="td3">上海东方广播有限公司</td>
            </tr>
            <tr>
                <td class="td1">252</td>
                <td class="td2">越剧《红楼梦》赏析</td>
                <td class="td3">上海杨浦区君悦文化艺术中心</td>
            </tr>
            <tr>
                <td class="td1">253</td>
                <td class="td2">越剧毕（春芳）流派艺术赏析</td>
                <td class="td3">上海申江艺术团</td>
            </tr>
            <tr>
                <td class="td1">253</td>
                <td class="td2">越剧导赏（二）</td>
                <td class="td3">上海越剧艺术传习所（上海越剧院）</td>
            </tr>
            <tr>
                <td class="td1">254</td>
                <td class="td2">越剧导赏（三）</td>
                <td class="td3">上海越剧艺术传习所（上海越剧院）</td>
            </tr>
            <tr>
                <td class="td1">255</td>
                <td class="td2">越剧导赏（一）</td>
                <td class="td3">上海越剧艺术传习所（上海越剧院）</td>
            </tr>
            <tr>
                <td class="td1">256</td>
                <td class="td2">在笑声中品味海派文化——走进滑稽艺术的殿堂</td>
                <td class="td3">上海怡莲文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">257</td>
                <td class="td2">中国梦旗袍情系列主题活动——旗袍盘扣导赏</td>
                <td class="td3">上海衣谱文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">258</td>
                <td class="td2">中国十大电影音乐作曲家名作赏析</td>
                <td class="td3">上海星妍文化服务中心</td>
            </tr>
            <tr>
                <td class="td1">259</td>
                <td class="td2">中华诗歌朗诵艺术导赏</td>
                <td class="td3">上海石娃社区艺术服务中心</td>
            </tr>
            <tr>
                <td class="td1">260</td>
                <td class="td2">中外舞曲名作赏析</td>
                <td class="td3">上海馨田交响乐团有限公司</td>
            </tr>
            <tr>
                <td class="td1">261</td>
                <td class="td2">竹笛名曲赏析</td>
                <td class="td3">上海庆音文化艺术团</td>
            </tr>
            <tr>
                <td class="td1">262</td>
                <td class="td2">追溯源远流长的古筝艺术——敦煌国乐大讲堂</td>
                <td class="td3">上海闵行区敦煌艺术学校</td>
            </tr>
            <tr>
                <td class="td1">263</td>
                <td class="td2">足尖传奇——芭蕾艺术导赏</td>
                <td class="td3">上海师范大学</td>
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
                <td class="td1">264</td>
                <td class="td2">“对话时空”海派青年艺术联展</td>
                <td class="td3">上海市收藏协会</td>
            </tr>
            <tr>
                <td class="td1">265</td>
                <td class="td2">“反腐倡廉”漫画展</td>
                <td class="td3">上海市收藏协会</td>
            </tr>
            <tr>
                <td class="td1">266</td>
                <td class="td2">“壶乐汇”琉璃内画壶展</td>
                <td class="td3">上海智基文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">267</td>
                <td class="td2">“家居与艺术结合的想象”专题展</td>
                <td class="td3">上海纽约大学</td>
            </tr>
            <tr>
                <td class="td1">268</td>
                <td class="td2">“弄堂记忆”海派风情精品画展</td>
                <td class="td3">上海海派连环画中心</td>
            </tr>
            <tr>
                <td class="td1">269</td>
                <td class="td2">“陶都青韵”宜兴青瓷展</td>
                <td class="td3">上海东方陶瓷艺术交流促进中心</td>
            </tr>
            <tr>
                <td class="td1">270</td>
                <td class="td2">“翼起飞翔”中国大飞机发展主题展</td>
                <td class="td3">上海文化出版社有限公司</td>
            </tr>
            <tr>
                <td class="td1">271</td>
                <td class="td2">“中国梦”旗袍情系列活动之盘扣展</td>
                <td class="td3">上海衣谱文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">272</td>
                <td class="td2">3D打印科普展</td>
                <td class="td3">上海城市动漫出版传媒有限公司</td>
            </tr>
            <tr>
                <td class="td1">273</td>
                <td class="td2">废纸旧布涅槃成大艺专题展</td>
                <td class="td3">上海旻罡环保艺术推广中心</td>
            </tr>
            <tr>
                <td class="td1">274</td>
                <td class="td2">海派旗袍百年历程专题展</td>
                <td class="td3">上海瀚艺服饰有限公司</td>
            </tr>
            <tr>
                <td class="td1">275</td>
                <td class="td2">核雕与竹根雕主题展</td>
                <td class="td3">上海舜元文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">276</td>
                <td class="td2">家风家教家训漫画展</td>
                <td class="td3">上海黄浦区打浦桥社区文化活动中心</td>
            </tr>
            <tr>
                <td class="td1">277</td>
                <td class="td2">近现代中国婚书展</td>
                <td class="td3">上海煜书文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">278</td>
                <td class="td2">景德镇“釉之正色”上海展</td>
                <td class="td3">上海尚莹文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">279</td>
                <td class="td2">历届“上海国际摄影艺术展”金奖作品巡展</td>
                <td class="td3">上海广旭传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">280</td>
                <td class="td2">民间版画收藏展</td>
                <td class="td3">上海城市动漫出版传媒有限公司</td>
            </tr>
            <tr>
                <td class="td1">281</td>
                <td class="td2">趣味甲骨文十二生肖书画展</td>
                <td class="td3">上海市殷商甲骨文研究院</td>
            </tr>
            <tr>
                <td class="td1">282</td>
                <td class="td2">上海市民文化创意产品展</td>
                <td class="td3">上海智市信息科技发展有限公司</td>
            </tr>
            <tr>
                <td class="td1">283</td>
                <td class="td2">社会集资那些事——风险防范与法治专题展</td>
                <td class="td3">上海普陀并购金融展示馆</td>
            </tr>
            <tr>
                <td class="td1">284</td>
                <td class="td2">水月唐卡主题展</td>
                <td class="td3">上海水月堂文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">285</td>
                <td class="td2">文字与文化——汉字源流与书法印章艺术展览</td>
                <td class="td3">上海石娃社区艺术服务中心</td>
            </tr>
            <tr>
                <td class="td1">286</td>
                <td class="td2">新中国官窑——十大瓷厂回忆录</td>
                <td class="td3">上海好瓷信息科技有限公司</td>
            </tr>
            <tr>
                <td class="td1">287</td>
                <td class="td2">宜兴紫砂上海展</td>
                <td class="td3">上海智基文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">288</td>
                <td class="td2">影像中国——知青记忆画展</td>
                <td class="td3">上海驭图网络科技有限公司</td>
            </tr>
            <tr>
                <td class="td1">289</td>
                <td class="td2">月份牌与旗袍——中国最早的广告画</td>
                <td class="td3">上海瀚艺服饰有限公司</td>
            </tr>
            <tr>
                <td class="td1">290</td>
                <td class="td2">致敬最可爱的人——中国人民解放军建军90周年特展</td>
                <td class="td3">上海市东方城市历史文化收藏交流中心</td>
            </tr>
            <tr>
                <td class="td1">291</td>
                <td class="td2">中国民族音乐文化历史主题展</td>
                <td class="td3">上海善怀文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">292</td>
                <td class="td2">诸子百家国风画展</td>
                <td class="td3">上海海派连环画中心</td>
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
                <td class="td1">293</td>
                <td class="td2">“大中华寻宝记”系列漫画</td>
                <td class="td3">上海市动漫行业协会</td>
            </tr>
            <tr>
                <td class="td1">294</td>
                <td class="td2">“读书乐”上海漫画名家邀请展</td>
                <td class="td3">上海图书馆（上海科学技术情报研究所）</td>
            </tr>
            <tr>
                <td class="td1">295</td>
                <td class="td2">“绿色二十四小时”专题展</td>
                <td class="td3">上海市黄浦区文化公益促进会</td>
            </tr>
            <tr>
                <td class="td1">296</td>
                <td class="td2">“上海漫生活”上海石库门弄堂风情画</td>
                <td class="td3">上海市动漫行业协会</td>
            </tr>
            <tr>
                <td class="td1">297</td>
                <td class="td2">“孝文化·海上行”专题展</td>
                <td class="td3">上海市东方城市历史文化收藏交流中心</td>
            </tr>
            <tr>
                <td class="td1">298</td>
                <td class="td2">“中国人的侠义情怀”黄金武林·民国武林老影像展</td>
                <td class="td3">上海明岳文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">299</td>
                <td class="td2">《上海老行当》图片展</td>
                <td class="td3">上海文化广播影视集团有限公司</td>
            </tr>
            <tr>
                <td class="td1">300</td>
                <td class="td2">高山流水——源远流长的古琴艺术专题展</td>
                <td class="td3">上海炳蔚文化发展股份有限公司</td>
            </tr>
            <tr>
                <td class="td1">301</td>
                <td class="td2">各类鼓乐器展示</td>
                <td class="td3">上海绛州鼓乐团</td>
            </tr>
            <tr>
                <td class="td1">302</td>
                <td class="td2">毛泽东像章展览</td>
                <td class="td3">上海金山区学军民俗木雕展示馆</td>
            </tr>
            <tr>
                <td class="td1">303</td>
                <td class="td2">沁凉海洋风——海洋贝壳艺术展</td>
                <td class="td3">上海星际企业管理有限公司</td>
            </tr>
            <tr>
                <td class="td1">304</td>
                <td class="td2">清末民初中外精品烟画（老香烟牌子）展</td>
                <td class="td3">上海懿有文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">305</td>
                <td class="td2">庆建军90周年中国军事题材电影海报精品展</td>
                <td class="td3">浦东新区收藏协会</td>
            </tr>
            <tr>
                <td class="td1">306</td>
                <td class="td2">上海老电影海报展览</td>
                <td class="td3">上海电影评论学会</td>
            </tr>
            <tr>
                <td class="td1">307</td>
                <td class="td2">社区科技创新屋成果展</td>
                <td class="td3">上海暨声文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">308</td>
                <td class="td2">远去的经典——古董打字机展览</td>
                <td class="td3">上海星际企业管理有限公司</td>
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
                <td class="td1">309</td>
                <td class="td2">“Gulugulu多彩故事绘”特色活动</td>
                <td class="td3">上海乐酷青年创意公益发展中心</td>
            </tr>
            <tr>
                <td class="td1">310</td>
                <td class="td2">“和绿色在一起的午后时光”特色活动</td>
                <td class="td3">上海市黄浦区文化公益促进会</td>
            </tr>
            <tr>
                <td class="td1">311</td>
                <td class="td2">“乐多多”趣味音乐启蒙特色活动（2017版）</td>
                <td class="td3">上海善怀文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">312</td>
                <td class="td2">“魅力小主持”青少年特色活动</td>
                <td class="td3">上海泽衡文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">313</td>
                <td class="td2">“民茶国饮·端阳茶汇”特色活动</td>
                <td class="td3">上海青果巷子传统文化促进中心</td>
            </tr>
            <tr>
                <td class="td1">314</td>
                <td class="td2">“偶的世界”木偶皮影体验</td>
                <td class="td3">上海文越文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">315</td>
                <td class="td2">“如何鉴别‘真假’宝贝？”特色活动</td>
                <td class="td3">上海橙娱文化传媒有限公司</td>
            </tr>
            <tr>
                <td class="td1">316</td>
                <td class="td2">“手上舞台”特色活动</td>
                <td class="td3">上海市沪东之星文化服务中心</td>
            </tr>
            <tr>
                <td class="td1">317</td>
                <td class="td2">“体验非洲风情·感受节奏律动”特色活动</td>
                <td class="td3">上海闵行区敦煌艺术学校</td>
            </tr>
            <tr>
                <td class="td1">318</td>
                <td class="td2">“图解上海”系列特色活动</td>
                <td class="td3">上海文化广播影视集团有限公司</td>
            </tr>
            <tr>
                <td class="td1">319</td>
                <td class="td2">“闻香识药，我是中医小神农”特色活动</td>
                <td class="td3">上海市针灸经络研究所</td>
            </tr>
            <tr>
                <td class="td1">320</td>
                <td class="td2">“我们都是小小艺术家”特色活动</td>
                <td class="td3">上海市收藏协会</td>
            </tr>
            <tr>
                <td class="td1">321</td>
                <td class="td2">“形象设计与魅力化妆”活动</td>
                <td class="td3">上海泽衡文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">322</td>
                <td class="td2">“仪之美”个人魅力提升之美丽声音特色活动</td>
                <td class="td3">上海松江区艺树文化发展中心</td>
            </tr>
            <tr>
                <td class="td1">323</td>
                <td class="td2">“自配自缝”中草药自配药方香囊DIY制作</td>
                <td class="td3">上海市东方城市历史文化收藏交流中心</td>
            </tr>
            <tr>
                <td class="td1">324</td>
                <td class="td2">“最强大脑科学试验站”特色活动</td>
                <td class="td3">上海海派连环画中心</td>
            </tr>
            <tr>
                <td class="td1">325</td>
                <td class="td2">DIY编花篮插花特色活动</td>
                <td class="td3">上海舜元文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">326</td>
                <td class="td2">插花体验活动</td>
                <td class="td3">上海尚莹文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">327</td>
                <td class="td2">敦煌音乐课堂“古筝大演习”特色活动</td>
                <td class="td3">上海闵行区敦煌艺术学校</td>
            </tr>
            <tr>
                <td class="td1">328</td>
                <td class="td2">方言展秀特色活动</td>
                <td class="td3">上海泽衡文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">329</td>
                <td class="td2">非遗的现代传承——“会说话的小木偶”特色活动</td>
                <td class="td3">烁歆（上海）文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">330</td>
                <td class="td2">废弃纸完美涅槃成艺术特色活动</td>
                <td class="td3">上海旻罡环保艺术推广中心</td>
            </tr>
            <tr>
                <td class="td1">331</td>
                <td class="td2">感受中秋之美（手工制作兔子灯、月饼、烛灯）特色活动</td>
                <td class="td3">上海骏轶文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">332</td>
                <td class="td2">功夫小飞龙少儿武术体验活动</td>
                <td class="td3">上海云极文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">333</td>
                <td class="td2">惠民高雅艺术欣赏特色活动</td>
                <td class="td3">上海东方艺术中心管理有限公司</td>
            </tr>
            <tr>
                <td class="td1">334</td>
                <td class="td2">健身瑜伽社区行特色活动</td>
                <td class="td3">上海上体文化传媒有限公司</td>
            </tr>
            <tr>
                <td class="td1">335</td>
                <td class="td2">讲武术说历史——“黄金的武林”民国武术大家与门派特色体验活动</td>
                <td class="td3">上海明岳文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">336</td>
                <td class="td2">科技制作小实验特色活动</td>
                <td class="td3">上海暨声文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">337</td>
                <td class="td2">妙手生花——衍纸画(卷纸画）DIY制作特色活动</td>
                <td class="td3">上海市东方城市历史文化收藏交流中心</td>
            </tr>
            <tr>
                <td class="td1">338</td>
                <td class="td2">木偶制作小课堂</td>
                <td class="td3">上海木偶剧团有限公司</td>
            </tr>
            <tr>
                <td class="td1">339</td>
                <td class="td2">盆景，方寸之美——植物微景观制作特色活动</td>
                <td class="td3">上海骏轶文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">340</td>
                <td class="td2">平凡生活变花样——万花筒创意沙龙</td>
                <td class="td3">上海海派连环画中心</td>
            </tr>
            <tr>
                <td class="td1">341</td>
                <td class="td2">奇妙的油彩水拓画特色活动</td>
                <td class="td3">上海星妍文化服务中心</td>
            </tr>
            <tr>
                <td class="td1">342</td>
                <td class="td2">旗袍盘扣手工技艺特色活动</td>
                <td class="td3">上海衣谱文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">343</td>
                <td class="td2">巧手剪出新生活——创新特色剪纸特色活动</td>
                <td class="td3">上海飞蚁文化发展有限公司</td>
            </tr>
            <tr>
                <td class="td1">344</td>
                <td class="td2">亲子绿植特色活动</td>
                <td class="td3">上海米秀文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">345</td>
                <td class="td2">亲子魔术沙龙特色活动</td>
                <td class="td3">上海爪玛文化艺术传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">346</td>
                <td class="td2">情系非遗——“扎染围巾/手帕”体验活动</td>
                <td class="td3">上海市东方城市历史文化收藏交流中心</td>
            </tr>
            <tr>
                <td class="td1">347</td>
                <td class="td2">闪光灯下的奇迹——室内人像摄影体验活动</td>
                <td class="td3">上海圣町市场营销策划有限公司</td>
            </tr>
            <tr>
                <td class="td1">348</td>
                <td class="td2">手工香囊制作特色活动</td>
                <td class="td3">上海皓古文化艺术馆</td>
            </tr>
            <tr>
                <td class="td1">349</td>
                <td class="td2">手帕上的炫彩扎染特色活动</td>
                <td class="td3">上海星妍文化服务中心</td>
            </tr>
            <tr>
                <td class="td1">350</td>
                <td class="td2">送给你最亲的人——DIY多肉礼盒制作特色活动</td>
                <td class="td3">上海市黄浦区文化公益促进会</td>
            </tr>
            <tr>
                <td class="td1">351</td>
                <td class="td2">鲜花花艺DIY特色活动</td>
                <td class="td3">逸琦（上海）文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">352</td>
                <td class="td2">穴位经络保健养生特色活动</td>
                <td class="td3">上海东方广播有限公司</td>
            </tr>
            <tr>
                <td class="td1">353</td>
                <td class="td2">腰椎、颈椎养生保健特色活动</td>
                <td class="td3">上海东方广播有限公司</td>
            </tr>
            <tr>
                <td class="td1">354</td>
                <td class="td2">仪之美——个人魅力提升之美妆课堂特色活动</td>
                <td class="td3">上海松江区艺树文化发展中心</td>
            </tr>
            <tr>
                <td class="td1">355</td>
                <td class="td2">以名画为蓝本的软雕塑——纤维艺术创作特色活动</td>
                <td class="td3">上海纽约大学</td>
            </tr>
            <tr>
                <td class="td1">356</td>
                <td class="td2">艺术电影公益特色活动</td>
                <td class="td3">上海电影评论学会</td>
            </tr>
            <tr>
                <td class="td1">357</td>
                <td class="td2">阅读有戏特色活动</td>
                <td class="td3">上海子攸文化传播有限公司</td>
            </tr>
            <tr>
                <td class="td1">358</td>
                <td class="td2">中老年养生保健的误区及正确做法特色活动</td>
                <td class="td3">上海市针灸经络研究所</td>
            </tr>
            <tr>
                <td class="td1">359</td>
                <td class="td2">中外食疗养生文化讲座——解密红酒的健康密码</td>
                <td class="td3">名酿汇（上海）商贸有限公司</td>
            </tr>
            <tr>
                <td class="td1">360</td>
                <td class="td2">中医“艾”养生特色活动</td>
                <td class="td3">上海市针灸经络研究所</td>
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