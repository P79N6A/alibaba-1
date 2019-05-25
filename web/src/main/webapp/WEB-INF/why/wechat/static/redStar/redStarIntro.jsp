<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·红星照耀中国</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		
		//分享是否隐藏
        if(window.injs){
        	//分享文案
        	appShareTitle = '安康文化云-红星照耀中国史料收藏线上展';
        	appShareDesc = '纪念中国共产党建党95周年暨红军长征胜利八十周年';
        	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/redStar/shareIcon.jpg';
        	appShareLink = '${basePath}/wechatStatic/cnAnswer.do';
        	
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
					title: "安康文化云-红星照耀中国史料收藏线上展",
					desc: '纪念中国共产党建党95周年暨红军长征胜利八十周年',
					imgUrl: '${basePath}/STATIC/wxStatic/image/redStar/shareIcon.jpg'
				});
				wx.onMenuShareTimeline({
					title: '安康文化云-红星照耀中国史料收藏线上展',
					imgUrl: '${basePath}/STATIC/wxStatic/image/redStar/shareIcon.png'
				});
				wx.onMenuShareQQ({
					title: "安康文化云-红星照耀中国史料收藏线上展",
					desc: '纪念中国共产党建党95周年暨红军长征胜利八十周年',
					imgUrl: '${basePath}/STATIC/wxStatic/image/redStar/shareIcon.png'
				});
				wx.onMenuShareWeibo({
					title: "安康文化云-红星照耀中国史料收藏线上展",
					desc: '纪念中国共产党建党95周年暨红军长征胜利八十周年',
					imgUrl: '${basePath}/STATIC/wxStatic/image/redStar/shareIcon.png'
				});
				wx.onMenuShareQZone({
					title: "安康文化云-红星照耀中国史料收藏线上展",
					desc: '纪念中国共产党建党95周年暨红军长征胜利八十周年',
					imgUrl: '${basePath}/STATIC/wxStatic/image/redStar/shareIcon.png'
				});
			});
		}
		
		$(function () {
			//前三页图片前缀
			$(".redStar").find("img").each(function() {
				if($(this).attr("src").length>0){
					$(this).attr("src", getImgUrl($(this).attr("src")));
				}
			});
			
			var swiper = new Swiper('.swiper-container', {
				direction: 'vertical',
				slidesPerView: 1,
				paginationClickable: true,
				spaceBetween: 0,
				mousewheelControl: true,
				onInit: function () {
					$('.arrowbtn').attr("src", getImgUrl($('.arrowbtn').attr("data-url")));
				},
				onSlideChangeEnd: function(swiper) {
					var snapIndex = swiper.snapIndex;
					if(snapIndex>1){
						var $slide = $(".swiper-wrapper .swiper-slide:eq(" + (snapIndex+1) + ")");
						//加载图片
						$slide.find("img").each(function() {
							$(this).attr("src", getImgUrl($(this).attr("data-url")));
						});
					}
				}
			});
		});
		
	</script>
	
	<style>
		html,body {
			position: relative;
			height: 100%;
		}
		
		img {
			vertical-align: middle;
		}
	</style>
	
</head>

<body>
	<div class="swiper-container redStar">
		<div class="swiper-wrapper">
			<div class="swiper-slide bg1 sectionImg"><img src="redStarStatic/img//pic1.png"></div>
			<div class="swiper-slide bg1">
				<div class="jz670">
					<img src="redStarStatic/img/pic2.png" class="ping2_1">
					<div class="ping2_2">
						<p>雪皑皑，野茫茫，高原寒，炊断粮。<br>红军都是钢铁汉，千锤百炼不怕难。</p>
                        <p>在历史的长河中，往事依稀恍若梦。人们从历史的星空中，寻找那些不朽的灵魂。</p>
                        <p>1927年8月1日，南昌起义打响了武装反抗国民党反动派的第一枪。接着，中共中央在汉口召开八七会议，确定了土地革命和武装斗争的总方针。从此，中国革命进入了武装暴动和建立农村革命根据地的新阶段。1930年至1932年间，在党的领导下，大部分根据地先后取得了第一至四次反“围剿”斗争的胜利，红军和革命根据地（也称苏区）不断巩固和壮大。</p>
                        <p>1933年9月，国民党军队对红军和各苏区发动第五次“围剿”，中央红军苦战一年，未能打破敌军的“围剿”，被迫实行战略转移。随后，其他几个革命根据地的红军也先后出发长征。</p>
					</div>
				</div>
			</div>
			<div class="swiper-slide bg1 sectionjuz">
				<div class="jz670">
					<div class="ping2_2">
						<p>1934年10月，中央红军从江西瑞金、于都等地出发，开始长征。历时一年，行程两万五千里，纵横驰骋十几个省，克服了无数艰难险阻，胜利到达陕北。1936年10月，各路红军先后到达陕甘地区，红军三大主力会师，长征胜利结束。主力红军北上长征后，留守红军继续在南方各根据地坚持斗争，在8省14个地区开展了长达三年的游击战争。长征胜利是中国革命第二次由失败转向胜利的关键，实现了国内革命战争向民族解放战争的转变，随后以国共第二次合作为基础的抗日民族统一战线正式形成，为全民族抗日战争的胜利奠定了基础。</p>
                        <p>本次展览以美国记者埃德加·斯诺的著作《红星照耀中国》（《西行漫记》）为主题，运用一系列的“第一”资源，融图文为一体，近百余幅珍贵照片以“星火燎原”“、“转战南北”“、“浴血坚持”、“共赴国难”四个部分进行展呈，浓缩了自1921年中国共产党成立以来，带领中国人民经过艰苦卓绝的斗争，最终迎来伟大胜利的光辉历史。</p>
					</div>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionImg"><img src="" data-url="redStarStatic/img/pic3.png"></div>
			<div class="swiper-slide bg2 sectionjuz"><img src="" data-url="redStarStatic/img/pic4.png"></div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic5.jpg">
					<p>南昌起义</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz"><img src="" data-url="redStarStatic/img/pic6.png"></div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic7.jpg">
					<p>1927年井冈山红军教导队旧址</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic8.jpg">
					<p>1927年秋收起义</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz"><img src="" data-url="redStarStatic/img/pic9.png"></div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic10.png">
					<p>1931年红七军第一纵队第一营第四连军旗</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic11.jpg">
					<p>红军25军3团1连的旗帜</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic12.jpg" style="width:455px;height:auto;">
					<p>1931年红七军用过的电话和手电筒</p>
					<br><br><br>
					<img src="" data-url="redStarStatic/img/pic13.jpg">
					<p>1931年1月红一方面军在东固坳创办的无线电训练班</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic14.jpg">
					<p>1931年中华苏维埃第一次全国代表大会</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic15.jpg">
					<p>1931年红七军到达湘赣边区</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic16.jpg">
					<p>1931年3月鄂预皖苏区红四军<br>活捉国民党34师师长岳维峻 漫画</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz"><img src="" data-url="redStarStatic/img/pic17.png"></div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic18.jpg">
					<p>1929年古田会议决议案的1930年版本</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic19.jpg">
					<p>革命根据地形势图（1930年夏）</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz"><img src="" data-url="redStarStatic/img/pic20.png"></div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic21.jpg">
					<p>1932年4月红四军在漳州石码合影</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz"><img src="" data-url="redStarStatic/img/pic22.png"></div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic23.jpg">
					<p>湘鄂赣革命根据地形式示意图（1928年-1933年）</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic24.jpg">
					<p>1933年修水县上杉的湘鄂赣省苏维埃政府旧址</p>
					<br><br><br>
					<img src="" data-url="redStarStatic/img/pic25.jpg">
					<p>1933年红军标语</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic26.jpg" style="width:450px;height: auto;">
					<p>1933年粉碎第四次围剿后集训的红军机枪班</p>
					<br><br><br>
					<img src="" data-url="redStarStatic/img/pic26_1.jpg" style="width:450px;height: auto;">
					<p>1933年中央苏区军械修理所</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz"><img src="" data-url="/redStarStatic/img/pic27.png"></div>
			<div class="swiper-slide bg2 sectionjuz"><img src="" data-url="redStarStatic/img/pic28.png"></div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic29.jpg">
					<p>中央革命根据地第五次反“围剿”示意图</p>
				</div>
			</div>
			<!-- <div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic30.jpg" style="width:450px;height: auto;">
					<p>1934年国民党军在中央苏区周围修建的碉堡</p>
				</div>
			</div> -->
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic31.jpg">
					<p>1934年国民党空军轰炸中央苏区</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic32.jpg">
					<p>1934年国民党军在中央苏区周围修建的碉堡</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz"><img src="" data-url="redStarStatic/img/pic33.png"></div>
			<div class="swiper-slide bg2 sectionjuz"><img src="" data-url="redStarStatic/img/pic34.png"></div>
			<div class="swiper-slide bg2 sectionjuz"><img src="" data-url="redStarStatic/img/pic35.png"></div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic36.jpg">
					<p>1931年4月红军“列宁号”飞机残骸</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic37.jpg">
					<p>红军“列宁号”飞机</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz"><img src="" data-url="redStarStatic/img/pic38.png"></div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic39.jpg">
					<p>1932年红军夺取漳州后缴获的“马克思”号飞机</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic40.jpg">
					<p>中国红军“马克思”号飞机</p>
				</div>
			</div>
			<div class="swiper-slide bg2 sectionjuz"><img src="" data-url="redStarStatic/img/pic41.png"></div>
			<div class="swiper-slide bg3 sectionjuz"><img src="" data-url="redStarStatic/img/pic42.png"></div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic43.jpg">
					<p>“自愿参加红军，在此洋楼报名”，“欢迎贫苦工农自动参加红军”，这是遗留在“红军楼”墙壁上的红军标语。如今，位于湖南省汝城县濠头乡学校内的这栋“红军楼”，已然成为当地百姓心中的“红军象征”。“红军楼”始建于1931年，时为国民党乡公所用房。1934年10月底至11月上旬，红3军团、红8军团随中央红军长征，从江西崇义进入汝城濠头，其中部分红军曾将指挥部设在“红军楼”，在此指挥作战和开展革命工作。</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic44.jpg">
					<p>1934年，中国革命历史上极为艰苦的一年，中共湘鄂川黔省委、省革委会、省军区等领导机关由大庸城（今为张家界）迁来塔卧，还设立了红军学校、红军医院、红军兵工厂、保卫局、无线电台和红二、六军团指挥部，塔卧成了湘鄂川黔革命根据地中心，这是塔卧镇上的湘鄂川黔革命根据地纪念馆。</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic44_2.jpg">
					<p>立在福建长汀中复村村头的“红军长征第一村”七个大字</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic45.jpg">
					<p>1934年11月上旬，红军突破国民党第二道封锁线后，中央红军卫生部驻扎在湘赣边界的湖南汝城文明镇沙洲瑶族村。这本“红军书”是一位受伤的女红军因受到当地百姓的照料，交给罗旺娣留存的。此书为32开，共约140页，为钢板刻印，用铜钉装订。书的前半部分为《指导员》《政治委员》《政治部》等6节内容，汇集有《总政治部关于连队政治工作的指示》《三中全会的政治决议》《中国共产党中央委员会扩大会第四次全体会议决议案》等文献资料。</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic46.jpg">
					<p>1934年12月12日，湖南西南部通道县恭城书院里，一次关系到中国革命的临时会议正在这里举行。参加会议的有毛泽东、周恩来、朱德、张闻天、王稼祥、博古、李德等人，会议由周恩来主持。会议根据大多数人的意见，通过了毛泽东甩掉强敌、西进贵州的主张。</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic47.jpg">
					<p>保存完整的湖南桑植县红二军团军团部（总指挥部）旧址</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic48.jpg">
					<p>湖南桑植县城区内的贺龙雕像。位于武陵山脉腹地的桑植，曾是湘鄂西、湘鄂川黔革命根据地的中心地，也是中国工农红军第二方面军长征的起点。1935年，红二、六军团从这里出发，踏上了北上抗日的长征之路。</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic49.jpg">
					<p> 2014年10月17日，江西于都中央红军长征出发纪念广场上，开国上将杨得志的儿子杨建华（左），向于都中央红军长征出发地纪念馆捐赠了父亲曾随身携带保存的3颗子弹。三颗子弹分别来自苏区时期、抗日战争时期、解放战争时期三个不同阶段，每颗子弹背后都浓缩着一段难忘的历史。</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic50.jpg">
					<p>游客在广西兴安县红军长征突破湘江战役纪念碑园内参观。湘江战役是中央红军长征突围过程中最壮烈、最关键的一场战役。据不完全统计，湘江战役中，牺牲师级指挥员8名，团级干部28名，再加上途中受伤、被俘、牺牲的，损失人数达到33100余人。</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/pic51.jpg">
					<p>1934年8月-1936年10月红军长征路线图</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz"><img src="" data-url="redStarStatic/img/52.jpg"></div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/53.jpg">
					<p>1935年遵义会议 油画</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/56.jpg">
					<p>1935年遵义会议</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/59.jpg" style="width:500px;height: auto;">
					<br>
					<img src="" data-url="redStarStatic/img/60.jpg" style="width:500px;height: auto;">
					<br>
					<img src="" data-url="redStarStatic/img/61.jpg" style="width:500px;height: auto;">
					<p>1935年遵义会议</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/54.jpg">
					<p>1935年遵义郊外娄山关战役旧址</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/55.jpg">
					<p>1935年遵义老场中学成为毛泽东演说地点</p>
				</div>
			</div>
			
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/57.jpg">
					<p>1935年遵义天主教堂进行全军干部会议精神传达</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/58.jpg">
					<p>1935年遵义南郊回山乡革命委员会旧址</p>
				</div>
			</div>
			
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/62.jpg">
					<p>1935年遵义留下的红军歌谣</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/63.jpg">
					<p>1935年遵义会议后红军留在枫香坝的宣传画</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/64.jpg">
					<p>1935年遵义会议后毛泽东在鸭溪下达作战命令电文</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/65.jpg">
					<p>1935年遵义会议关于反五次围剿的总结决议</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/66.jpg">
					<p>1935年遵义会议红军总政治部布告</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz"><img src="" data-url="redStarStatic/img/67.jpg"></div>
	       <div class="swiper-slide bg3 sectionjuz">
	           <div class="tuwen">
	               <img src="" data-url="redStarStatic/img/68.jpg">
	               <p>1934年红军过湘江木版画</p>
	           </div>
	       </div>
			<div class="swiper-slide bg3 sectionjuz"><img src="" data-url="redStarStatic/img/69.jpg"></div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/72.jpg">
					<p>1935年红军巧渡金沙江时的毛泽东所住岩洞</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/70.jpg">
					<p>中国工农红军第一方面军四渡赤水河示意图</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/73.jpg">
					<p>1935年红军一渡赤水渡口土城</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/74.jpg">
					<p>1935年红军二渡赤水渡口太平渡</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/75.jpg">
					<p>1935年红军三渡赤水渡口茅台</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/71.jpg">
					<p>1935年红军四渡赤水渡口二郎滩</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/76.jpg">
					<p>长征途中的毛主席</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/77.jpg">
					<p>1935年红二方面军在贵州大定合影</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/78.jpg">
					<p>1935年9月红二十五军与陕北红军会师永平镇</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/79.jpg">
					<p>1935年红四方面军书写标语</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/80.jpg" style="width:429px;height: auto;">
					<p>1935年红军标语口号</p>
					<br><br><br>
					<img src="" data-url="redStarStatic/img/81.jpg">
					<p>1935年9月党中央命令张国焘北上的电文</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz"><img src="" data-url="redStarStatic/img/82.jpg"></div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/83.jpg">
					<p>1935年红军翻越夹金山</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/84.jpg">
					<p>1935年红军经过的川西草地</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/84_2.jpg">
					<p>1935年红军经过六盘山</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/85.jpg">
					<p>1935年红军巴西会议</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/86.jpg">
					<p>1935年红军北上经过的岷山栈道</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/87.jpg">
					<p>1936年红军北上渡过渭河</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/88.jpg">
					<p>1936年红军草地宿营绘画</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/89.jpg">
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz"><img src="" data-url="redStarStatic/img/90.jpg"></div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/91.jpg">
					<p>1935年红军过彝区时成立的彝民沽鸡支队队旗</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/92.jpg">
					<p>1935年红军留在四川彝区的标语</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/93.jpg">
					<p>1935年红军在四川彝区布告</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz"><img src="" data-url="redStarStatic/img/94.jpg"></div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/95.jpg">
					<p>红军时期的萧克</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/96.jpg">
					<p>瑞士传教士薄复礼</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/97.jpg">
					<p>薄复礼为红军翻译的法文版地图</p>
				</div>
			</div>
			<div class="swiper-slide bg3 sectionjuz"><img src="" data-url="redStarStatic/img/98.png"></div>
			<div class="swiper-slide bg4 sectionjuz"><img src="" data-url="redStarStatic/img/99.png"></div>
			<div class="swiper-slide bg4 sectionjuz"><img src="" data-url="redStarStatic/img/100.jpg"></div>
			<div class="swiper-slide bg4 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/101.jpg">
					<p>南方三年游击战争形势图</p>
				</div>
			</div>
			<div class="swiper-slide bg4 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/102.jpg">
					<p>红军游击队收据</p>
				</div>
			</div>
			<div class="swiper-slide bg4 sectionjuz"><img src="" data-url="redStarStatic/img/103.jpg"></div>
			<div class="swiper-slide bg4 sectionjuz"><img src="" data-url="redStarStatic/img/104.jpg"></div>
			<div class="swiper-slide bg4 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/105.jpg">
					<p>江西大余县瓷江小汾村是游击队给养站</p>
				</div>
			</div>
			<div class="swiper-slide bg4 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/106.jpg">
					<p>闽西游击队根据地金丰山</p>
				</div>
			</div>
			<div class="swiper-slide bg4 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/107.jpg" style="width:323px;height: auto;">
					<p>粤赣边界游击队根据地油山</p>
					<br><br><br>
					<img src="" data-url="redStarStatic/img/108.jpg">
					<p>江西信丰县油山塔下村古塔是游击队联络站</p>
				</div>
			</div>
			<div class="swiper-slide bg4 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/109.jpg">
					<p>闽南游击队揭露国民党罪行的宣传品</p>
				</div>
			</div>
			<div class="swiper-slide bg4 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/110.jpg">
					<p>闽西南军政委员会布告</p>
				</div>
			</div>
			<div class="swiper-slide bg4 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/111.jpg">
					<p>陈毅手迹赣南游击十二首</p>
				</div>
			</div>
			<div class="swiper-slide bg4 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/112.jpg">
				</div>
			</div>
			<div class="swiper-slide bg4 sectionjuz"><img src="" data-url="redStarStatic/img/113.jpg"></div>
			<div class="swiper-slide bg4 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/114.jpg">
					<p>湘南游击队政治处条印</p>
				</div>
			</div>
			<div class="swiper-slide bg4 sectionjuz"><img src="" data-url="redStarStatic/img/115.jpg"></div>
			<div class="swiper-slide bg4 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/116.jpg">
					<p>湘赣边游击队根据地九龙山</p>
				</div>
			</div>
			<div class="swiper-slide bg4 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/117.jpg">
					<p>湘赣边根据地部分同志1939年在延安合影</p>
				</div>
			</div>
			<div class="swiper-slide bg4 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/118.jpg">
					<p>湘鄂赣军区对两广出师抗日讨蒋宣言</p>
				</div>
			</div>
			<div class="swiper-slide bg4 sectionjuz"><img src="" data-url="redStarStatic/img/119.jpg"></div>
			<div class="swiper-slide bg4 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/120.jpg">
					<p>闽浙军区司令部政治部布告</p>
				</div>
			</div>
			<div class="swiper-slide bg4 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/121.jpg" style="width:521px;height: auto;">
					<p>闽浙边游击队使用的土枪与宝剑</p>
					<br><br><br>
					<img src="" data-url="redStarStatic/img/122.jpg">
					<p>闽浙游击队根据地龟子山</p>
				</div>
			</div>
			<div class="swiper-slide bg4 sectionjuz"><img src="" data-url="redStarStatic/img/123.png"></div>
			<div class="swiper-slide bg4 sectionjuz"><img src="" data-url="redStarStatic/img/124.png"></div>
			<div class="swiper-slide bg5 sectionjuz"><img src="" data-url="redStarStatic/img/125.jpg"></div>
			<div class="swiper-slide bg5 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/126.jpg" style="width:400px;height: auto;">
					<br><br><br>
					<img src="" data-url="redStarStatic/img/127.jpg" style="width:400px;height: auto;">
				</div>
			</div>
			<div class="swiper-slide bg5 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/128.jpg">
					<br><br><br>
					<img src="" data-url="redStarStatic/img/129.jpg">
				</div>
			</div>
			<div class="swiper-slide bg5 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/130.jpg">
					<br><br><br>
					<img src="" data-url="redStarStatic/img/131.jpg">
				</div>
			</div>
			<div class="swiper-slide bg5 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/132.jpg">
					<br><br><br>
					<img src="" data-url="redStarStatic/img/133.jpg">
				</div>
			</div>
			<div class="swiper-slide bg5 sectionjuz"><img src="" data-url="redStarStatic/img/134.jpg"></div>
			<div class="swiper-slide bg5 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/135.jpg" style="width:459px;height: auto;">
					<p>朱德在延安与红七军同志合影</p>
					<br><br><br>
					<img src="" data-url="redStarStatic/img/136.jpg">
					<p>1937年陕甘根据地等待改编的红军战士</p>
				</div>
			</div>
			<div class="swiper-slide bg5 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/137.jpg">
					<p>1937年红军在延安举行“八一”运动会</p>
				</div>
			</div>
			<div class="swiper-slide bg5 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img//138.jpg">
					<p>革命圣地延安</p>
				</div>
			</div>
			<div class="swiper-slide bg5 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/139.png">
				</div>
			</div>
			<div class="swiper-slide bg5 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/140.jpg">
					<p>油画：《长征·过草地》</p>
				</div>
			</div>
			<div class="swiper-slide bg5 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/141.jpg">
					<p>毛泽东七言律诗《七律·长征》</p>
				</div>
			</div>
			<div class="swiper-slide bg5 sectionjuz">
				<div class="tuwen">
					<img src="" data-url="redStarStatic/img/142.png">
					<p></p>
				</div>
			</div>
		</div>

		<img src="" class="arrowbtn" data-url="redStarStatic/img/btn.png">
	</div>
</body>
</html>