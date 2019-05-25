<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>公共文化服务保障法</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	
	<script>
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '《中华人民共和国公共文化服务保障法》3月起正式施行，公共文化服务迈向法制化';
	    	appShareDesc = '《公共文化服务保障法》构筑了我国公共文化服务基本法律制度体系的框架，明确了公共文化的定义和发展方向，保障了公民的基本文化权益。';
	    	appShareImgUrl = 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017224171250Va9ukYjRSTE1AOddOhTOvlRPWQq1jU.jpg@300w';
	    	
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
					title: "《中华人民共和国公共文化服务保障法》3月起正式施行，公共文化服务迈向法制化",
					desc: '《公共文化服务保障法》构筑了我国公共文化服务基本法律制度体系的框架，明确了公共文化的定义和发展方向，保障了公民的基本文化权益。',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017224171250Va9ukYjRSTE1AOddOhTOvlRPWQq1jU.jpg@300w'
				});
				wx.onMenuShareTimeline({
					title: "《中华人民共和国公共文化服务保障法》3月起正式施行，公共文化服务迈向法制化",
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017224171250Va9ukYjRSTE1AOddOhTOvlRPWQq1jU.jpg@300w'
				});
				wx.onMenuShareQQ({
					title: "《中华人民共和国公共文化服务保障法》3月起正式施行，公共文化服务迈向法制化",
					desc: '《公共文化服务保障法》构筑了我国公共文化服务基本法律制度体系的框架，明确了公共文化的定义和发展方向，保障了公民的基本文化权益。',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017224171250Va9ukYjRSTE1AOddOhTOvlRPWQq1jU.jpg@300w'
				});
				wx.onMenuShareWeibo({
					title: "《中华人民共和国公共文化服务保障法》3月起正式施行，公共文化服务迈向法制化",
					desc: '《公共文化服务保障法》构筑了我国公共文化服务基本法律制度体系的框架，明确了公共文化的定义和发展方向，保障了公民的基本文化权益。',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017224171250Va9ukYjRSTE1AOddOhTOvlRPWQq1jU.jpg@300w'
				});
				wx.onMenuShareQZone({
					title: "《中华人民共和国公共文化服务保障法》3月起正式施行，公共文化服务迈向法制化",
					desc: '《公共文化服务保障法》构筑了我国公共文化服务基本法律制度体系的框架，明确了公共文化的定义和发展方向，保障了公民的基本文化权益。',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017224171250Va9ukYjRSTE1AOddOhTOvlRPWQq1jU.jpg@300w'
				});
			});
		}
		
		$(function () {
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
        });
	</script>
	
	<style>
		.toIndex {
			position: absolute;
			width: 78px;
			height: 40px;
			right: 130px;
			top: 20px;
			color: #fff;
			font-size: 24px;
			background-color: rgba(0, 0, 0, 0.5);
			border-radius: 5px;
			text-align: center;
			line-height: 40px;
		}
		
		.share {
			position: absolute;
			width: 78px;
			height: 40px;
			right: 30px;
			left: auto;
			top: 20px;
			color: #fff;
			font-size: 24px;
			background-color: rgba(0, 0, 0, 0.5);
			border-radius: 5px;
			text-align: center;
			line-height: 40px;
		}
		
		.cultureLowMain {
			width: 750px;
			margin: auto;
		}
		
		.cultureLowHead {
			background: url("http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201722414340bM6Vh6u0JTze1hNVGQ10eogwOL1VPo.jpg") no-repeat center center;
			width: 750px;
			height: 250px;
			position: relative;
			overflow: hidden;
			background-position: 100% 100%;
		}
		
		.cultureLowContent {
			background: url("http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017224143434BfshPRTjulYV13o7kKDdfsGcA0ToJR.jpg") repeat-y center;
			padding: 0 50px;
			font-size: 26px;
			color: #333333;
			overflow: hidden;
		}
		
		.cultureLowFoot {
			background: url("http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017224143549xC3ewotqQgRquJ3YFngZJFYPsb2LRF.jpg") no-repeat center center;
			width: 750px;
			height: 136px;
			background-position: 100% 100%;
		}
		
		.cultureLowContent .indent {
			text-indent: 2em;
			line-height: 50px;
			margin-bottom: 40px;
		}
		
		.cultureLowContent .textTitle {
			text-align: center;
			font-weight: bold;
			margin-bottom: 40px;
		}
	</style>
</head>

<body>
	<div class="cultureLowMain">
		<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
			<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
		</div>
		<div class="cultureLowHead">
			<div class="toIndex" onclick="toWhyIndex();">首页</div>
			<div class="share share-button">分享</div>
			<p style="font-size: 38px;text-align: center;color: #fff9c7;margin-top: 80px;">《中华人民共和国公共文化服务保障法》</p>
			<p style="font-size: 30px;text-align: center;color: #fff9c7;margin-top: 10px;">3月1日正式施行（附全文）</p>
		</div>
		<div class="cultureLowContent">
			<p class="indent">2016年12月25日第十二届全国人民代表大会常务委员会第二十五次会议通过了《中华人民共和国公共文化服务保障法》（以下简称公共文化服务保障法），自2017年3月1日起施行。</p>
			<p class="indent">公共文化服务保障法共六章65条，对公共文化设施建设与管理、公共文化服务提供、保障措施、法律责任等分别作了详细规定，是中国文化领域一部重要的综合性、全局性、基础性法律。</p>
			<p class="indent">这部法律的亮点之一在于坚持政府主导，社会参与。公共文化服务保障法首次以法律的形式明确了各级人民政府是承担公共文化服务的责任主体，明确以政府为主导，政府是公共文化服务的主体，这是以法律形式的第一次体现。同时也明确要激励和支持社会力量参与到公共文化服务之中，也就是公共文化服务为大家，公共文化服务大家办。</p>
			<p class="indent">亮点之二在于坚持保障基本，促进均等。公共文化服务保障法的实施，将进一步强化政府的兜底作用，政府的作用在公共文化服务中就是要保住人民群众的基本公共文化服务。同时加快推进基本公共文化服务标准化、均等化，为全体人民提供系统性、制度性、公平性、可持续的公共文化服务。</p>
			<p class="indent">亮点之三在于坚持统筹协调，共建共享。公共文化服务保障法明确将建立公共文化服务综合协调机制作为重要内容，这一机制将进一步协调政府各方面的行政力量，来共同推进公共文化服务建设。也将进一步明确政府各个部门在公共文化服务体系建设中所承担的责任，也会推动各类公共文化机构加强合作，实现综合利用、融合发展。</p><br />
			<p>以下为《公共文化服务保障法》全文</p><br /><br />
			<p class="textTitle">中华人民共和国公共文化服务保障法</p><br />
			<p style="text-align: center;">（2016年12月25日第十二届全国人民代表大会常务委员会第二十五次会议通过）</p><br />
			<p>目 录</p><br />
			<p class="indent">第一章 总 则</p>
			<p class="indent">第二章 公共文化设施建设与管理</p>
			<p class="indent">第三章 公共文化服务提供</p>
			<p class="indent">第四章 保障措施</p>
			<p class="indent">第五章 法律责任</p>
			<p class="indent">第六章 附 则</p>

			<p class="textTitle">第一章 总 则</p>
			<p class="indent">第一条 为了加强公共文化服务体系建设，丰富人民群众精神文化生活，传承中华优秀传统文化，弘扬社会主义核心价值观，增强文化自信，促进中国特色社会主义文化繁荣发展，提高全民族文明素质，制定本法。</p>
			<p class="indent">第二条 本法所称公共文化服务，是指由政府主导、社会力量参与，以满足公民基本文化需求为主要目的而提供的公共文化设施、文化产品、文化活动以及其他相关服务。</p>
			<p class="indent">第三条 公共文化服务应当坚持社会主义先进文化前进方向，坚持以人民为中心，坚持以社会主义核心价值观为引领；应当按照“百花齐放、百家争鸣”的方针，支持优秀公共文化产品的创作生产，丰富公共文化服务内容。</p>
			<p class="indent">第四条 县级以上人民政府应当将公共文化服务纳入本级国民经济和社会发展规划，按照公益性、基本性、均等性、便利性的要求，加强公共文化设施建设，完善公共文化服务体系，提高公共文化服务效能。</p>
			<p class="indent">第五条 国务院根据公民基本文化需求和经济社会发展水平，制定并调整国家基本公共文化服务指导标准。</p>
			<p class="indent">省、自治区、直辖市人民政府根据国家基本公共文化服务指导标准，结合当地实际需求、财政能力和文化特色，制定并调整本行政区域的基本公共文化服务实施标准。</p>
			<p class="indent">第六条 国务院建立公共文化服务综合协调机制，指导、协调、推动全国公共文化服务工作。国务院文化主管部门承担综合协调具体职责。</p>
			<p class="indent">地方各级人民政府应当加强对公共文化服务的统筹协调，推动实现共建共享。</p>
			<p class="indent">第七条 国务院文化主管部门、新闻出版广电主管部门依照本法和国务院规定的职责负责全国的公共文化服务工作；国务院其他有关部门在各自职责范围内负责相关公共文化服务工作。</p>
			<p class="indent">县级以上地方人民政府文化、新闻出版广电主管部门根据其职责负责本行政区域内的公共文化服务工作；县级以上地方人民政府其他有关部门在各自职责范围内负责相关公共文化服务工作。</p>
			<p class="indent">第八条 国家扶助革命老区、民族地区、边疆地区、贫困地区的公共文化服务，促进公共文化服务均衡协调发展。</p>
			<p class="indent">第九条 各级人民政府应当根据未成年人、老年人、残疾人和流动人口等群体的特点与需求，提供相应的公共文化服务。</p>
			<p class="indent">第十条 国家鼓励和支持公共文化服务与学校教育相结合，充分发挥公共文化服务的社会教育功能，提高青少年思想道德和科学文化素质。</p>
			<p class="indent">第十一条 国家鼓励和支持发挥科技在公共文化服务中的作用，推动运用现代信息技术和传播技术，提高公众的科学素养和公共文化服务水平。</p>
			<p class="indent">第十二条 国家鼓励和支持在公共文化服务领域开展国际合作与交流。</p>
			<p class="indent">第十三条 国家鼓励和支持公民、法人和其他组织参与公共文化服务。</p>
			<p class="indent">对在公共文化服务中作出突出贡献的公民、法人和其他组织，依法给予表彰和奖励。</p>
			<p class="textTitle">第二章 公共文化设施建设与管理</p>
			<p class="indent">第十四条 本法所称公共文化设施是指用于提供公共文化服务的建筑物、场地和设备，主要包括图书馆、博物馆、文化馆（站）、美术馆、科技馆、纪念馆、体育场馆、工人文化宫、青少年宫、妇女儿童活动中心、老年人活动中心、乡镇（街道）和村（社区）基层综合性文化服务中心、农家（职工）书屋、公共阅报栏（屏）、广播电视播出传输覆盖设施、公共数字文化服务点等。</p>
			<p class="indent">县级以上地方人民政府应当将本行政区域内的公共文化设施目录及有关信息予以公布。</p>
			<p class="indent">第十五条 县级以上地方人民政府应当将公共文化设施建设纳入本级城乡规划，根据国家基本公共文化服务指导标准、省级基本公共文化服务实施标准，结合当地经济社会发展水平、人口状况、环境条件、文化特色，合理确定公共文化设施的种类、数量、规模以及布局，形成场馆服务、流动服务和数字服务相结合的公共文化设施网络。</p>
			<p class="indent">公共文化设施的选址，应当征求公众意见，符合公共文化设施的功能和特点，有利于发挥其作用。</p>
			<p class="indent">第十六条 公共文化设施的建设用地，应当符合土地利用总体规划和城乡规划，并依照法定程序审批。</p>
			<p class="indent">任何单位和个人不得侵占公共文化设施建设用地或者擅自改变其用途。因特殊情况需要调整公共文化设施建设用地的，应当重新确定建设用地。调整后的公共文化设施建设用地不得少于原有面积。</p>
			<p class="indent">新建、改建、扩建居民住宅区，应当按照有关规定、标准，规划和建设配套的公共文化设施。</p>
			<p class="indent">第十七条 公共文化设施的设计和建设，应当符合实用、安全、科学、美观、环保、节约的要求和国家规定的标准，并配置无障碍设施设备。</p>
			<p class="indent">第十八条 地方各级人民政府可以采取新建、改建、扩建、合建、租赁、利用现有公共设施等多种方式，加强乡镇（街道）、村（社区）基层综合性文化服务中心建设，推动基层有关公共设施的统一管理、综合利用，并保障其正常运行。</p>
			<p class="indent">第十九条 任何单位和个人不得擅自拆除公共文化设施，不得擅自改变公共文化设施的功能、用途或者妨碍其正常运行，不得侵占、挪用公共文化设施，不得将公共文化设施用于与公共文化服务无关的商业经营活动。</p>
			<p class="indent">因城乡建设确需拆除公共文化设施，或者改变其功能、用途的，应当依照有关法律、行政法规的规定重建、改建，并坚持先建设后拆除或者建设拆除同时进行的原则。重建、改建的公共文化设施的设施配置标准、建筑面积等不得降低。</p>
			<p class="indent">第二十条 公共文化设施管理单位应当按照国家规定的标准，配置和更新必需的服务内容和设备，加强公共文化设施经常性维护管理工作，保障公共文化设施的正常使用和运转。</p>
			<p class="indent">第二十一条 公共文化设施管理单位应当建立健全管理制度和服务规范，建立公共文化设施资产统计报告制度和公共文化服务开展情况的年报制度。</p>
			<p class="indent">第二十二条 公共文化设施管理单位应当建立健全安全管理制度，开展公共文化设施及公众活动的安全评价，依法配备安全保护设备和人员，保障公共文化设施和公众活动安全。</p>
			<p class="indent">第二十三条 各级人民政府应当建立有公众参与的公共文化设施使用效能考核评价制度，公共文化设施管理单位应当根据评价结果改进工作，提高服务质量。</p>
			<p class="indent">第二十四条 国家推动公共图书馆、博物馆、文化馆等公共文化设施管理单位根据其功能定位建立健全法人治理结构，吸收有关方面代表、专业人士和公众参与管理。</p>
			<p class="indent">第二十五条 国家鼓励和支持公民、法人和其他组织兴建、捐建或者与政府部门合作建设公共文化设施，鼓励公民、法人和其他组织依法参与公共文化设施的运营和管理。</p>
			<p class="indent">第二十六条 公众在使用公共文化设施时，应当遵守公共秩序，爱护公共设施，不得损坏公共设施设备和物品。</p>
			<p class="textTitle">第三章 公共文化服务提供</p>
			<p class="indent">第二十七条 各级人民政府应当充分利用公共文化设施，促进优秀公共文化产品的提供和传播，支持开展全民阅读、全民普法、全民健身、全民科普和艺术普及、优秀传统文化传承活动。</p>
			<p class="indent">第二十八条 设区的市级、县级地方人民政府应当根据国家基本公共文化服务指导标准和省、自治区、直辖市基本公共文化服务实施标准，结合当地实际，制定公布本行政区域公共文化服务目录并组织实施。</p>
			<p class="indent">第二十九条 公益性文化单位应当完善服务项目、丰富服务内容，创造条件向公众提供免费或者优惠的文艺演出、陈列展览、电影放映、广播电视节目收听收看、阅读服务、艺术培训等，并为公众开展文化活动提供支持和帮助。</p>
			<p class="indent">国家鼓励经营性文化单位提供免费或者优惠的公共文化产品和文化活动。</p>
			<p class="indent">第三十条 基层综合性文化服务中心应当加强资源整合，建立完善公共文化服务网络，充分发挥统筹服务功能，为公众提供书报阅读、影视观赏、戏曲表演、普法教育、艺术普及、科学普及、广播播送、互联网上网和群众性文化体育活动等公共文化服务，并根据其功能特点，因地制宜提供其他公共服务。</p>
			<p class="indent">第三十一条 公共文化设施应当根据其功能、特点，按照国家有关规定，向公众免费或者优惠开放。</p>
			<p class="indent">公共文化设施开放收取费用的，应当每月定期向中小学生免费开放。</p>
			<p class="indent">公共文化设施开放或者提供培训服务等收取费用的，应当报经县级以上人民政府有关部门批准；收取的费用，应当用于公共文化设施的维护、管理和事业发展，不得挪作他用。</p>
			<p class="indent">公共文化设施管理单位应当公示服务项目和开放时间；临时停止开放的，应当及时公告。</p>
			<p class="indent">第三十二条 国家鼓励和支持机关、学校、企业事业单位的文化体育设施向公众开放。</p>
			<p class="indent">第三十三条 国家统筹规划公共数字文化建设，构建标准统一、互联互通的公共数字文化服务网络，建设公共文化信息资源库，实现基层网络服务共建共享。</p>
			<p class="indent">国家支持开发数字文化产品，推动利用宽带互联网、移动互联网、广播电视网和卫星网络提供公共文化服务。</p>
			<p class="indent">地方各级人民政府应当加强基层公共文化设施的数字化和网络建设，提高数字化和网络服务能力。</p>
			<p class="indent">第三十四条 地方各级人民政府应当采取多种方式，因地制宜提供流动文化服务。</p>
			<p class="indent">第三十五条 国家重点增加农村地区图书、报刊、戏曲、电影、广播电视节目、网络信息内容、节庆活动、体育健身活动等公共文化产品供给，促进城乡公共文化服务均等化。</p>
			<p class="indent">面向农村提供的图书、报刊、电影等公共文化产品应当符合农村特点和需求，提高针对性和时效性。</p>
			<p class="indent">第三十六条 地方各级人民政府应当根据当地实际情况，在人员流动量较大的公共场所、务工人员较为集中的区域以及留守妇女儿童较为集中的农村地区，配备必要的设施，采取多种形式，提供便利可及的公共文化服务。</p>

			<p class="indent">第三十七条 国家鼓励公民主动参与公共文化服务，自主开展健康文明的群众性文化体育活动；地方各级人民政府应当给予必要的指导、支持和帮助。</p>
			<p class="indent">居民委员会、村民委员会应当根据居民的需求开展群众性文化体育活动，并协助当地人民政府有关部门开展公共文化服务相关工作。</p>
			<p class="indent">国家机关、社会组织、企业事业单位应当结合自身特点和需要，组织开展群众性文化体育活动，丰富职工文化生活。</p>
			<p class="indent">第三十八条 地方各级人民政府应当加强面向在校学生的公共文化服务，支持学校开展适合在校学生特点的文化体育活动，促进德智体美教育。</p>
			<p class="indent">第三十九条 地方各级人民政府应当支持军队基层文化建设，丰富军营文化体育活动，加强军民文化融合。</p>
			<p class="indent">第四十条 国家加强民族语言文字文化产品的供给，加强优秀公共文化产品的民族语言文字译制及其在民族地区的传播，鼓励和扶助民族文化产品的创作生产，支持开展具有民族特色的群众性文化体育活动。</p>
			<p class="indent">第四十一条 国务院和省、自治区、直辖市人民政府制定政府购买公共文化服务的指导性意见和目录。国务院有关部门和县级以上地方人民政府应当根据指导性意见和目录，结合实际情况，确定购买的具体项目和内容，及时向社会公布。</p>

			<p class="indent">第四十二条 国家鼓励和支持公民、法人和其他组织通过兴办实体、资助项目、赞助活动、提供设施、捐赠产品等方式，参与提供公共文化服务。</p>
			<p class="indent">第四十三条 国家倡导和鼓励公民、法人和其他组织参与文化志愿服务。</p>
			<p class="indent">公共文化设施管理单位应当建立文化志愿服务机制，组织开展文化志愿服务活动。</p>
			<p class="indent">县级以上地方人民政府有关部门应当对文化志愿活动给予必要的指导和支持，并建立管理评价、教育培训和激励保障机制。</p>
			<p class="indent">第四十四条 任何组织和个人不得利用公共文化设施、文化产品、文化活动以及其他相关服务，从事危害国家安全、损害社会公共利益和其他违反法律法规的活动。</p>

			<p class="textTitle">第四章 保障措施</p>
			<p class="indent">第四十五条 国务院和地方各级人民政府应当根据公共文化服务的事权和支出责任，将公共文化服务经费纳入本级预算，安排公共文化服务所需资金。</p>
			<p class="indent">第四十六条 国务院和省、自治区、直辖市人民政府应当增加投入，通过转移支付等方式，重点扶助革命老区、民族地区、边疆地区、贫困地区开展公共文化服务。</p>
			<p class="indent">国家鼓励和支持经济发达地区对革命老区、民族地区、边疆地区、贫困地区的公共文化服务提供援助。</p>

			<p class="indent">第四十七条 免费或者优惠开放的公共文化设施，按照国家规定享受补助。</p>
			<p class="indent">第四十八条 国家鼓励社会资本依法投入公共文化服务，拓宽公共文化服务资金来源渠道。</p>
			<p class="indent">第四十九条 国家采取政府购买服务等措施，支持公民、法人和其他组织参与提供公共文化服务。</p>
			<p class="indent">第五十条 公民、法人和其他组织通过公益性社会团体或者县级以上人民政府及其部门，捐赠财产用于公共文化服务的，依法享受税收优惠。</p>
			<p class="indent">国家鼓励通过捐赠等方式设立公共文化服务基金，专门用于公共文化服务。</p>
			<p class="indent">第五十一条 地方各级人民政府应当按照公共文化设施的功能、任务和服务人口规模，合理设置公共文化服务岗位，配备相应专业人员。</p>
			<p class="indent">第五十二条 国家鼓励和支持文化专业人员、高校毕业生和志愿者到基层从事公共文化服务工作。</p>
			<p class="indent">第五十三条 国家鼓励和支持公民、法人和其他组织依法成立公共文化服务领域的社会组织，推动公共文化服务社会化、专业化发展。</p>
			<p class="indent">第五十四条 国家支持公共文化服务理论研究，加强多层次专业人才教育和培训。</p>

			<p class="indent">第五十五条 县级以上人民政府应当建立健全公共文化服务资金使用的监督和统计公告制度，加强绩效考评，确保资金用于公共文化服务。任何单位和个人不得侵占、挪用公共文化服务资金。</p>
			<p class="indent">审计机关应当依法加强对公共文化服务资金的审计监督。</p>
			<p class="indent">第五十六条 各级人民政府应当加强对公共文化服务工作的监督检查，建立反映公众文化需求的征询反馈制度和有公众参与的公共文化服务考核评价制度，并将考核评价结果作为确定补贴或者奖励的依据。</p>
			<p class="indent">第五十七条 各级人民政府及有关部门应当及时公开公共文化服务信息，主动接受社会监督。</p>
			<p class="indent">新闻媒体应当积极开展公共文化服务的宣传报道，并加强舆论监督。</p>

			<p class="textTitle">第五章 法律责任</p>
			<p class="indent">第五十八条 违反本法规定，地方各级人民政府和县级以上人民政府有关部门未履行公共文化服务保障职责的，由其上级机关或者监察机关责令限期改正；情节严重的，对直接负责的主管人员和其他直接责任人员依法给予处分。</p>
			<p class="indent">第五十九条 违反本法规定，地方各级人民政府和县级以上人民政府有关部门，有下列行为之一的，由其上级机关或者监察机关责令限期改正；情节严重的，对直接负责的主管人员和其他直接责任人员依法给予处分：</p>

			<p class="indent">（一）侵占、挪用公共文化服务资金的；</p>
			<p class="indent">（二）擅自拆除、侵占、挪用公共文化设施，或者改变其功能、用途，或者妨碍其正常运行的；</p>
			<p class="indent">（三）未依照本法规定重建公共文化设施的；</p>
			<p class="indent">（四）滥用职权、玩忽职守、徇私舞弊的。</p>
			<p class="indent">第六十条 违反本法规定，侵占公共文化设施的建设用地或者擅自改变其用途的，由县级以上地方人民政府土地主管部门、城乡规划主管部门依据各自职责责令限期改正；逾期不改正的，由作出决定的机关依法强制执行，或者依法申请人民法院强制执行。</p>
			<p class="indent">第六十一条 违反本法规定，公共文化设施管理单位有下列情形之一的，由其主管部门责令限期改正；造成严重后果的，对直接负责的主管人员和其他直接责任人员，依法给予处分：</p>
			<p class="indent">（一）未按照规定对公众开放的；</p>
			<p class="indent">（二）未公示服务项目、开放时间等事项的；</p>
			<p class="indent">（三）未建立安全管理制度的；</p>
			<p class="indent">（四）因管理不善造成损失的。</p>
			<p class="indent">第六十二条 违反本法规定，公共文化设施管理单位有下列行为之一的，由其主管部门或者价格主管部门责令限期改正，没收违法所得，违法所得五千元以上的，并处违法所得两倍以上五倍以下罚款；没有违法所得或者违法所得五千元以下的，可以处一万元以下的罚款；对直接负责的主管人员和其他直接责任人员，依法给予处分：</p>

			<p class="indent">（一）开展与公共文化设施功能、用途不符的服务活动的；</p>
			<p class="indent">（二）对应当免费开放的公共文化设施收费或者变相收费的；</p>
			<p class="indent">（三）收取费用未用于公共文化设施的维护、管理和事业发展，挪作他用的。</p>
			<p class="indent">第六十三条 违反本法规定，损害他人民事权益的，依法承担民事责任；构成违反治安管理行为的，由公安机关依法给予治安管理处罚；构成犯罪的，依法追究刑事责任。</p>

			<p class="textTitle">第六章 附 则</p>
			<p class="indent">第六十四条 境外自然人、法人和其他组织在中国境内从事公共文化服务的，应当符合相关法律、行政法规的规定。</p>
			<p class="indent">第六十五条 本法自2017年3月1日起施行。</p>

		</div>
		<div class="cultureLowFoot"></div>
	</div>
</body>
</html>