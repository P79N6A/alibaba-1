<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>公共文化配送产品设计大赛</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css">
<style type="text/css">
html,body{height: 100%; width: 100%; background-color: #3c1d4c;}
</style>
<script type="text/javascript">
//分享是否隐藏
if(window.injs){
	//分享文案
	appShareTitle = '给喜欢的产品设计投票，为公共文化添上浓墨重彩的一笔';
	appShareDesc = '2016年上海市民文化节公共文化配送产品设计大赛市民投票活动';
	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg';
	
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
			title: "给喜欢的产品设计投票，为公共文化添上浓墨重彩的一笔",
			desc: '2016年上海市民文化节公共文化配送产品设计大赛市民投票活动',
			link: '${basePath}wechatDc/index.do?tab='+tab,
			imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon.jpg'
		});
		wx.onMenuShareTimeline({
			title: "给喜欢的产品设计投票，为公共文化添上浓墨重彩的一笔",
			imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon.jpg',
			link: '${basePath}wechatDc/index.do?tab='+tab
		});
		wx.onMenuShareQQ({
			title: "给喜欢的产品设计投票，为公共文化添上浓墨重彩的一笔",
			desc: '2016年上海市民文化节公共文化配送产品设计大赛市民投票活动',
			imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon.jpg'
		});
		wx.onMenuShareWeibo({
			title: "给喜欢的产品设计投票，为公共文化添上浓墨重彩的一笔",
			desc: '2016年上海市民文化节公共文化配送产品设计大赛市民投票活动',
			imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon.jpg'
		});
		wx.onMenuShareQZone({
			title: "给喜欢的产品设计投票，为公共文化添上浓墨重彩的一笔",
			desc: '2016年上海市民文化节公共文化配送产品设计大赛市民投票活动',
			imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon.jpg'
		});
	});
}

$(function(){
	//分享
	$(".share-button").click(function() {
		if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
			dialogAlert('系统提示', '请用微信浏览器打开分享！');
		}else{
			$("html,body").addClass("bg-notouch");
			$(".background-fx").css("display", "block")
		}
	})
	$(".background-fx").click(function() {
		$("html,body").removeClass("bg-notouch");
		$(".background-fx").css("display", "none")
	})
    //关注
	$(".keep-button").on("touchstart", function() {
		$('.div-share').show()
		$("body,html").addClass("bg-notouch")
	})
	
})

</script>
</head>

<body>
<div class="div-share">
	<div class="share-bg"></div>
	<div class="share">
		<img src="${path}/STATIC/wechat/image/wx-er2.png" />
		<p style="margin-top: 310px;">扫一扫&nbsp;关注文化云</p>
		<p>更多精彩活动、场馆等你发现</p>
		<button type="button" onclick="$('.div-share').hide();$('body,html').removeClass('bg-notouch')">关闭</button>
	</div>
</div>
<div class="pszxMain">
    <div class="pszxBan">
        <img class="bg" src="${path }/STATIC/wxStatic/image/pszx/pic3.jpg">
        <div class="pszx_guanfx clearfix" style="top:25px;">
            <a href="javascript:;" class="keep-button">关注</a>
            <a href="javascript:;" class="share-button">分享</a>
        </div>
        <div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		    <img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
        </div>
        <div class="navIndex">
            <a class="a1" href="${path }/wechatQyg/index.do?guide=1&tab=0"></a>
            <a class="a2" href="${path }/wechatQyg/voteRule.do"></a>
            <a class="a3 current" href="${path }/wechatQyg/announcement.do"></a>
            <a class="a4" href="${path }/wechatQyg/toRanking.do"></a>
        </div>
    </div>
    <div class="pszxRank_wc">
        <div class="pszxRule">
            <div class="nc">
                <div class="tit"><span>#</span>&nbsp;&nbsp;&nbsp;&nbsp;赛事公告&nbsp;&nbsp;&nbsp;&nbsp;<span>#</span></div>
                <div class="cont">
                    <div class="biao">赛事宗旨</div>
                    <p>为总结2016年公共文化配送工作，展示配送主体风采，促进公共文化产品创新优化，激发各类社会主体参与公共文化建设的热情，特举办公共文化配送产品设计大赛，评选“百强公共文化配送创新产品”。</p>
                </div>
                <div class="cont">
                    <div class="biao">大赛主题</div>
                    <p>文化的创新·艺术的传递</p>
                </div>
                <div class="cont">
                    <div class="biao">组织机构</div>
                    <p>指导单位：上海市民文化节指导委员会</p>
                    <p>
                        主办单位：上海市群众艺术馆<br>
                        　　　　　各区文化（广）局
                    </p>
                    <p>
                        承办单位：上海市东方公共文化配送中心（筹）<br>
                        　　　　　上海市民文化协会<br>
                        　　　　　各区公共文化配送中心
                    </p>
                    <p>技术平台：文化上海云</p>
                </div>
                <div class="cont">
                    <div class="biao">大赛安排</div>
                    <p>报名阶段：2016年11月21日-12月31日（材料上传时间：12月19日-12月31日） </p>
                    <p>评选阶段：2017年1月7日-20日</p>
                    <p>总结阶段：2017年2月</p>
                </div>
                <div class="cont">
                    <div class="biao">参赛要求</div>
                    <p>（一）参赛对象</p>
                    <p>截止本次大赛，具有参与全市各级公共文化服务经历满1年以上的，各类具有独立法人资格的社会主体，均可报名参赛。其中，申报文艺演出的主体须持有文化主管部门核发的《营业性演出许可证》。</p>
                    <br>
                    <p>（二）参赛内容</p>
                    <p>本次大赛评选的公共文化配送产品分为4大门类：文艺演出、艺术导赏、展览展示、特色活动。</p>
                    <br>
                    <p>（三）报名要求</p>
                    <p>1.由各区推荐优秀的社会主体，设计公共文化配送新产品，统一报名参加比赛。推荐产品须包含以上4大门类，其中，文艺演出不少于5项，艺术导赏不少于4项，展览展示不少于2项，特色活动不少于3项。</p>
                    <p>2.各社会主体可根据大赛要求，设计公共文化新产品，直接申报公共文化配送产品设计方案参加比赛。</p>
                    <p>3.同一主体可申报门类不限，每个门类不多于2项。目前已在市级公共文化配送平台上线的相关产品，不予参赛资格。</p>
                    <br>
                    <p>（四）参赛方式</p>
                    <p>由各区推荐或各社会主体申报优秀公共文化配送新产品，为所设计的产品准备以下材料，以电子版形式提交。（产品设计要求详见附件）</p>
                    <p>1.文艺演出</p>
                    <p>
                        （1）产品设计方案1份。演出内容包括戏曲曲艺、音乐舞蹈、舞台戏剧、魔术杂技等，须提交完整设计方案，包含主旨主题、演出简介（剧情简介）、主要演员、人员配置、节目内容、舞美设计等。<br>
                        （2）舞台剧照，不少于5张。提交照片须为舞台剧照。<br>
                        （3）产品宣传海报1张。宣传海报可选报以往演出海报。<br>
                        （4）视频资料1份。所提交视频资料为节选展示，时长不超过10分钟。
                    </p>
                    <p>2.艺术导赏</p>
                    <p>
                        （1）产品设计方案1份。导赏内容以普及文化艺术知识为主，包含民族的、西洋的，古典的、现代的等文化艺术领域。形式须为艺术类讲座与现场表演相结合，须提交完整设计方案，包含选题、立意、主讲人、提纲、演出内容、人员配置等各要素。<br>
                        （2）导赏现场照片，不少于5张。提交照片须为以往导赏活动现场照片。<br>
                        （3）产品宣传海报1张。宣传海报可选报以往导赏活动举办海报。<br>
                        （4）视频资料1份。所提交视频资料为节选展示，时长不超过10分钟。
                    </p>
                    <p>3.展览展示</p>
                    <p>
                        （1）产品设计方案1份。展览内容包含文化艺术、文物收藏及用于形势宣传、法制教育等主题。须提交完整设计方案，包含选题、立意、展品介绍、设计理念、部分设计稿等。<br>
                        （2）展品效果图/展板效果图，不少于20张。<br>
                        （3）产品宣传海报1张。宣传海报可选报以往展览举办海报。<br>
                        （4）布展效果图，不少于3张。可为以往举办展览的实拍图，或虚拟效果图。
                    </p>
                    <p>4.特色活动</p>
                    <p>
                        （1）产品设计方案1份。活动内容可涉及富有特色的都市文化、乡土文化、“非遗”文化、亲子文化、创新艺术等，能吸引群众广泛参与的活动。须提交完整设计方案，包含选题、立意、活动简介、主要流程、人员配置、辅助材料等。<br>
                        （2）活动现场照片，不少于5张。提交照片须为以往举办活动现场照片。<br>
                        （3）产品宣传海报1张。宣传海报可选报以往活动举办海报。<br>
                        （4）视频资料1份。所提交视频资料为节选展示，时长不超过6分钟。
                    </p>
                    <br>
                    <p>（五）材料要求</p>
                    <p>1.材料提交</p>
                    <p>
                        （1）2016年12月19日起，各区二级配送中心将各推荐主体报送的设计方案等相关资料，上传至网址：www.wenhuayun.<br>cn（“文化上海云”平台），统一报名。其他报名参赛的社会主体将设计方案等相关资料，自行上传至安康文化云。截止日期：2016年12月31日。<br>
                        （2）上传方式：点击“文化上海云”首页轮播图“公共文化配送产品设计大赛”的宣传图片，进入报名页面，上传视频等素材，并填写信息表，统一报名。
                    </p>
                    <p>2.技术参数</p>
                    <p>
                        （1）产品设计方案：A4纸纵向排版，以电子版形式提交。<br>
                        （2）照片：彩色数码照片，JPG格式，不少于5张，每张照片不小于3M，以电子版形式提交。<br>
                        （3）海报：彩色数码图片，JPG格式，每张海报文件不小于3M，以电子版形式提交。<br>
                        （4）效果图：彩色数码图片，JPG格式，每张海报文件不小于3M，以电子版形式提交。<br>
                        （5）视频：以电子版形式提交。请按以下格式拍摄，画面稳定，避免抖动，突出内容和人物。
                    </p>
                    <table class="table">
                        <tr>
                            <th>产品</th>
                            <th>参数值</th>
                            <th>说明</th>
                            <th>备注</th>
                        </tr>
                        <tr>
                            <td>文件封装</td>
                            <td>格式</td>
                            <td>MP4/RM/MPG/AVI</td>
                            <td></td>
                        </tr>
                        <tr>
                            <td rowspan="8">视频要求</td>
                            <td>编码格式</td>
                            <td>H264</td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>码率</td>
                            <td>不低于4M</td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>分辨率</td>
                            <td>不低于 720 X 576</td>
                            <td>PAL制</td>
                        </tr>
                        <tr>
                            <td>宽高比</td>
                            <td>4 : 3</td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>帧率</td>
                            <td>25fps</td>
                            <td>PAL制</td>
                        </tr>
                        <tr>
                            <td>Gop</td>
                            <td>M=3，N=12</td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>扫描模式</td>
                            <td>隔行扫描（顶场优先）或逐行扫描</td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>封装格式</td>
                            <td>MP4/RM/MPG/AVI</td>
                            <td></td>
                        </tr>
                        <tr>
                            <td rowspan="8">视频中音频要求</td>
                            <td>编码格式</td>
                            <td>AAC</td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>音频码率</td>
                            <td>不低于128K</td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>声道</td>
                            <td>立体声或5.1声道</td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>采样率</td>
                            <td>48kHz</td>
                            <td>可选44.1kHZ</td>
                        </tr>
                    </table>
                </div>
                <div class="cont">
                    <div class="biao">赛事评审</div>
                    <p>（一）评审方式：本次大赛以专家评审，结合市民投票的形式进行评选。专家评分与市民投票得分以各占85%与15%的比例计入总分，最终评选出“百强公共文化配送创新产品”。</p>
                    <p>（二）投票方式：自2017年1月7日开始，市民可通过“文化上海云”终端进行投票。方式一：文化云APP（下载并安装），点击“公共文化配送产品设计大赛”；方式二：文化云微信公众账号（微信搜索“文化云”，关注后点击菜单“公共文化配送产品设计大赛”）。</p>
                    <p>（三）评选与颁奖：主办单位负责本次大赛的评选及颁奖工作。大赛将评选出 “百强公共文化配送创新产品”，并颁发获奖证书、铜牌及产品画册。</p>
                    <p>（四）签约与推荐：主办单位将向全市各区优先推荐获奖产品。同时可于2017-2018年度，直接签约进入上海市公共文化配送平台，接受社区点单。</p>
                </div>
                <div class="cont">
                    <div class="biao">联系方式</div>
                    <p>上海市群众艺术馆、上海市东方公共文化配送中心（筹）</p>
                    <p>联 系 人：  陶  冶      黄仁俊</p>
                    <p>联系电话：  34776356    34776342</p>
                    <p>联系地址：  上海市徐汇区古宜路125号振飞楼214室</p>
                    <p>邮    编：  200235</p>
                </div>
                <div class="cont">
                    <p style="text-align:right;">上海市东方公共文化配送中心（筹）</p>
                    <p style="text-align:right;">2016年 11 月21日</p>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>