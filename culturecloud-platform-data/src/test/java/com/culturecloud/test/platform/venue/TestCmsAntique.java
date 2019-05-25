package com.culturecloud.test.platform.venue;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import com.culturecloud.model.bean.venue.CmsAntique;
import com.culturecloud.model.request.venue.CmsAntiqueListVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;

public class TestCmsAntique extends TestRestService{

	@Test
	public void createCmsAntique(){
		
		
		String [] s1=new String[]{"dsadsa"};
		String [] s2=new String[]{"dsadsa"};
		
		List<CmsAntique> list=new ArrayList<CmsAntique>();
			
		
		
		
		CmsAntique cmsAntique01 =new CmsAntique();
		
		cmsAntique01.setAntiqueName("敦煌绘画的传承者——王琦荣和他的敦煌_文化");
		
		cmsAntique01.setAntiqueVideoUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016122151319MScJcND3X72Kw0WmHcg41XWvHDPMwO.mp4");
		
		cmsAntique01.setAntiqueRemark(
"<p>甘肃是中华文明的发祥地，博大精深的敦煌文化滋养了一代代的陇原人，在描摹敦煌笔画基础上形成的敦煌画派则是敦煌文化继承创新的实证，画家王琦荣因其作品具有浓厚的敦元素，被誉为敦煌画派的传承者。</p>"+
"<p>王琦荣的绘画作品贯穿边塞文化特有的苍茫与悲凉，在这一特定的氛围背后，则是一种粗犷、阳刚与雄健的本质表现。他执着于西部山水主题，面对长河落日、大漠孤烟，孤独的与苍茫大地对话，体现的正是一种精神上的自信、艺术上的坚定、取向上的专一；显然，置身于当代文化语境中的王琦荣，所挑战的不只是自我，还挑战着他的绘画文本。</p>"
);
		
	CmsAntique cmsAntique02 =new CmsAntique();
		
		cmsAntique02.setAntiqueName("非遗传承任重道远 根植民间与时俱进_文化");
		
		cmsAntique02.setAntiqueVideoUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016122151411BaPcK4TkNiu7ysIXqENxVUNyTOoKog.mp4");
		
		cmsAntique02.setAntiqueRemark(
"<p>联合国教科文组织颁布的《保护非物质文化遗产公约》中定义，被各群体、团体、有时为个人所视为其文化遗产的各种实践、表演、表现形式、知识体系和技能及其有关的工具、实物、工艺品和文化场所等即为非物质文化遗产。</p>"+
"<p>随着时代的发展、生活方式的变化特别是受新型文化的影响，非物质文化遗产保护与传承面临着危机，一些有历史和文化价值的“非遗”项目面临着濒危、消失甚至后继乏人等问题，让“非遗”的保护与传承工作“活”起来，“非遗”这份文化资源才能经久不衰。</p>"
);
		
	CmsAntique cmsAntique03 =new CmsAntique();
		
		cmsAntique03.setAntiqueName("竹素流芳——周颢艺术特展_文化");
		
		cmsAntique03.setAntiqueVideoUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016122151719hVQLaa6WAsM9nourpmnDdFt80HyJfI.mp4");
		
		cmsAntique03.setAntiqueRemark(
"<p>由上海博物馆主办，天津博物馆、南京博物院、苏州博物馆、宁波博物馆、嘉定博物馆、上海文物商店、上海市历史博物馆等文博单位协办的“竹素流芳——周颢艺术特展”于2016年6月15日下午在上海博物馆开幕。</p>"+
"<p>周颢(1685-1773)，字晋瞻，号芷岩，清代最著名的竹刻家，中国竹刻史上里程碑式的人物。作为一名擅长诗文、精通书画的文人，受家乡嘉定地区竹刻传统的影响，周颢将自己擅长的绘画，特别是山水与竹石施于刻竹，开创了独具的艺术风格，对其后的竹刻艺术影响极为深远。人们认为他在竹刻历史上的地位，如同诗圣杜甫在中国诗歌史上的地位。</p>"
);
	
	//	list.add(cmsAntique01);
	//	list.add(cmsAntique02);
	//	list.add(cmsAntique03);
		
	CmsAntique cmsAntique1 =new CmsAntique();
		
		cmsAntique1.setAntiqueName("舞台剧《咔哧咔哧山》——静安现代戏剧谷名剧展演_宣传片");
		
		cmsAntique1.setAntiqueVideoUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016122151954eFgZsUJpWhupcOvWbwhcwyNGOzw577.mp4");
		
		cmsAntique1.setAntiqueRemark(
"<p>本届现代戏剧谷以“融”为主题，“融”是静安深厚历史文化底蕴的一种观照，透过剧场，触及的是戏剧的融合、生命的融合。</p>"+
"<p>《咔哧咔哧山》由日本著名戏剧大师铃木忠志执导。该剧改编自太宰治所著的日本传统民间故事集《御伽草纸》中的同名故事，铃木忠志从现代视角出发，把它描写成医院里的医生、护士与患者之间的爱情故事。</p>"+
"<br>"+
"<p>导演：铃木忠志</p>"+
"<p>编剧：太宰治、铃木忠志</p>"
);
	
		
	CmsAntique cmsAntique2 =new CmsAntique();
		
		cmsAntique2.setAntiqueName("舞台剧《恋爱的犀牛》——静安现代戏剧谷名剧展演_宣传片");
		
		cmsAntique2.setAntiqueVideoUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016122152012nUlE2BPcQ7bxlYBaVtTcDxV7KnH674.mp4");
		
		cmsAntique2.setAntiqueRemark(
"<p>《恋爱的犀牛》被誉为“年轻一代的爱情圣经”，是中国小剧场戏剧史上最受欢迎的作品。剧情主要是一个关于爱情的故事，讲一个男人爱上一个女人，为了她做了一个人所能做的一切，剧中的主角马路是别人眼中的偏执狂，如他朋友所说过分夸大一个女人和另一个女人之间的差别，在人人都懂得明智选择的今天，算是人群中的犀牛实属异类。</p>"+
"<p>12年间，《恋爱的犀牛》在全世界36个城市累计达900场演出，巡演里程226800公里，观众人次达34万。</p>"+
"<br>"+
"<p>编剧：廖一梅</p>"+
"<p>导演：孟京辉</p>"
);
	
CmsAntique cmsAntique3 =new CmsAntique();
		
		cmsAntique3.setAntiqueName("词唱会《双声慢·歌宋》——静安现代戏剧谷名剧展演_宣传片");
		
		cmsAntique3.setAntiqueVideoUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016122152111HkF944n1GHwoMsG2jUI7c0R3NcqsXR.mp4");
		
		cmsAntique3.setAntiqueRemark(
"<p>这将是一场特别的“个唱会”，昆曲人吴双不唱当下的风花雪月，也不唱舞台上的昆曲，他要唱唱一千年前的流行歌曲，曾遍布在茶寮酒肆勾栏瓦舍，从文人笔下写就，从歌者喉中流出的唐宋词。</p>"+
"<br>"+
"<p>演唱者：</p>"+
"<p>吴双</p>"	+
"<p>中国戏剧最高奖梅花奖得主</p>"+
"<p>上海昆剧团一级演员</p>"
);
	
		
CmsAntique cmsAntique4 =new CmsAntique();
		
		cmsAntique4.setAntiqueName("办公室喜剧《五斗米靠腰》——静安现代戏剧谷名剧展演_宣传片");
		
		cmsAntique4.setAntiqueVideoUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/201612215265lBXPtAYRpjAVqruicOrJaWf1g2YQFy.mp4");
		
		cmsAntique4.setAntiqueRemark(
"<p>台湾2014 年首演至今两岸演出逾70 场，四度加演，一票难求，二部曲今年乘胜追击，观众一致点赞的奇作！</p>"+
"<p>靠腰——在台湾是鲜活多用的词汇，能充分表达内心情绪。面对拎不清的老板，少根筋的下属，客户极啰嗦，同事耍阴险。上班好比打仗，下班遥遥无期。职场上苦闷走跳，这种生活怎能不靠腰？</p>"+
"<br>"+
"<p>制作演出:果陀剧场</p>"+
"<p>制作暨演出总整合人： Baboo</p>"	+
"<p>导演：黄郁晴 / 许哲彬</p>"+
"<p>编剧：简莉颖 / 叶志伟 / 叶晏如</p>"		
);
	
CmsAntique cmsAntique5 =new CmsAntique();
		
		cmsAntique5.setAntiqueName("纸偶剧《纸美人》——静安现代戏剧谷名剧展演_宣传片");
		
		cmsAntique5.setAntiqueVideoUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016122152615ofjmceXD4aHaiqVjxH380hJT2Ug7gz.mp4");
		
		cmsAntique5.setAntiqueRemark(
"<p>白色的纸板屋，黑色线条勾勒出来的家具——这就是纸美人的黑白两色小世界，她习惯了，也觉得挺好。可有一天，调皮的“色彩”们突然冒了出来，他们要跟纸美人做游戏! </p>"+
		"<p>现场音乐瞬间激活淘气、傲娇的纸美人。暗藏玄机、惊喜连连的纸板屋，激发宝贝不停歇的惊叹、欢笑，启发他们对色彩的认知。颜色不仅仅是一件物品的某一属性，还是有性格特点的独立主体。从此以后，他们眼里的彩色世界也活泼起来了吧。</p>"+
		"<br>"+
		"<p>制作演出：</p>"+
		"<p>冰雪夏洛特剧团</p>"		
);
	
CmsAntique cmsAntique6 =new CmsAntique();
		
		cmsAntique6.setAntiqueName("话剧《大先生》——静安现代戏剧谷名剧展演_宣传片");
		
		cmsAntique6.setAntiqueVideoUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016122152750hhZcTojhKXXraIkQh9tG8H15PkSb6N.mp4");
		
		cmsAntique6.setAntiqueRemark(
"<p>很难说《大先生》写的是鲁迅的时代。它更多的是我们的时代。剧本提出了一个巨大的设问：如果鲁迅没有死，他会如何存在？鲁迅会如何评论、如何反抗、如何死去？他会对我们说什么、做什么、唏嘘什么？</p>"+
		"<p>《大先生》写的也不是鲁迅的一生。它其实只写了鲁迅生命里的最后一分钟。在这一分钟里，鲁迅看到了前后百年的中国史，看到了中国人的伤痛和追寻。</p>"+
		"<br>"+
		"<p>编剧：李静</p>"+
		"<p>导演：王翀</p>"		
);
	
		
CmsAntique cmsAntique7 =new CmsAntique();
		
		cmsAntique7.setAntiqueName("国家话剧院《伏生》——静安现代戏剧谷名剧展演_宣传片");
		
		cmsAntique7.setAntiqueVideoUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016122152824DkaQ3qLQuapPrhrlYqcuuBRmyZgK6.mp4");
		
		cmsAntique7.setAntiqueRemark(
		"<p>秦时统一天下，伏生通晓儒学精髓，被立为博士。随时间发展，一时被尊崇备至的儒学地位竟翻天沦至废黜，秦始皇下令\"焚书坑儒\"，伏生传奇般地将儒家大成之作《尚书》以奇特方式保存下来，得以免受焚烧之祸。为用个体生命扛起文化坚守，当坚守看似终得圆满时，他又经历了内心深处更为震彻心灵的拷问，他毕生承载的究竟是什么？</p>"+
		"<br>"+
		"<p>编 剧：孟冰、冯必烈</p>"+
		"<p>导 演：王晓鹰</p>"		
);
	
		
CmsAntique cmsAntique8 =new CmsAntique();
		
		cmsAntique8.setAntiqueName("科技与人文的融合——上海博物馆内的高科技_宣传片");
		
		cmsAntique8.setAntiqueVideoUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016122152852MRyjIL6TDb4iBj6Rvtfph0nv2Qh80p.mp4");
		
		cmsAntique8.setAntiqueRemark(
		"<p>上海博物馆的重心就是科技与人文的互动。早在1975年，上海博物馆文物保护实验室就建立了热释光考古研究室，40年来研究建立了一整套比较精确的陶器、瓷器热释光年代测量方法。1997年又引进了X射线能量色散荧光仪，由此开展了馆藏完整器的无损检测分析研究，并建立了古陶瓷数据库。“实验室和陶瓷研究部长期联合研究，保障了古瓷器研究在文物材质、产地、制作工艺和鉴别真伪方面的提升。</p>"
);
	
CmsAntique cmsAntique9 =new CmsAntique();
		
		cmsAntique9.setAntiqueName("走进玻璃的奇妙世界——上海玻璃博物馆_宣传片");
		
		cmsAntique9.setAntiqueVideoUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016122153136l7ZSqoiBfoyQSOyb7C5qV9ZrQMQxJ1.mp4");
		
		cmsAntique9.setAntiqueRemark(
		"<p>从熔炉车间到艺术空间，上海玻璃博物馆的建筑在一甲子的发展中经历了工业化到现代化的转型。场馆改建时，在大量保留原有空间结构与细节的基础上，上海玻璃博物馆被赋予了艺术观赏性、互动娱乐性与再生创造性。结合玻璃艺术与建筑本身的特点，在主馆内塑造了众多参观亮点，如“万花筒入口”、“历史长廊”、“玻璃屋”、“古玻璃珍宝馆”等，实现着玻璃艺术在空间上的升华。</p>"
);
	
		
CmsAntique cmsAntique10 =new CmsAntique();
		
		cmsAntique10.setAntiqueName("见证上海电影的文化魅力——上海电影博物馆_宣传片");
		
		cmsAntique10.setAntiqueVideoUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016122153155Q3ohKB4DpEgJ2TeizR4CXNqRg5s4sF.mp4");
		
		cmsAntique10.setAntiqueRemark(
		"<p>博物馆将分为四大主题展区，1座艺术影厅、五号摄影棚等，是融展示与互动、参观与体验为一体的，涵盖了文物收藏、学术研究、社会教育、陈列展列等功能，是向参观者呈现百年上海电影的魅力，生动演绎电影人、电影事和电影背后故事的一座城市文化标志性场馆，是徐汇区打造的首个4A级都市旅游景区的重要文化景点之一。</p>"
);
		
CmsAntique cmsAntique11 =new CmsAntique();
		
		cmsAntique11.setAntiqueName("揭秘“中国制造” 聚焦上海老相机博物馆_宣传片");
		
		cmsAntique11.setAntiqueVideoUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016122153228Nw7WfdYwx0UEuo8wupCKtJuFHpRIsr.mp4");
		
		cmsAntique11.setAntiqueRemark(
		"<p>上海老相机制造博物馆坐落于上海黄浦区重庆南路308号（白玉兰剧场楼下），6月10日起正式向公众免费开放，逢周一休馆。</p>"+
		"<p>展厅内容包括中国老相机制造厂家专区、全机械120双反(胶片)相机“海鸥”4A-109型工艺技术专区、摄影留念群体雕塑群、珍贵收藏相机展区、全机械120双反(胶片)相机“海鸥”4A-109型整套传统装配作业线。</p>"+
		"<p>博物馆以唯一遗存、当时中国最高水平的传统装配作业线——“海鸥”4A-109型为展示主体，凭借经典相机、经典制造、经典影像、经典体验组合五大展区解密相机制造原理、阐释摄影文化的本源，传动老相机制造时代的特殊情感与珍视。 </p>"
);
		
CmsAntique cmsAntique12 =new CmsAntique();
		
		cmsAntique12.setAntiqueName("“菩提的世界”醍醐寺艺术珍宝展之幕后_宣传片");
		
		cmsAntique12.setAntiqueVideoUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/201612215333lvwGq4OBdttKXzDL57FGJSMhG7IwGo.mp4");
		
		cmsAntique12.setAntiqueRemark(
		"<p>上海博物馆2016年重磅展览的首场重头戏“菩提的世界：醍醐寺艺术珍宝展”将于5月11日—7月10日展出。日本醍醐寺内收藏有69419件文物精品、6522件重要文化遗产，其他未指定寺宝更是多达15万件。这次有六十余件（组）醍醐寺珍贵文物来到上海博物馆，包括雕刻、绘画、织物等，向观众展示日本密宗的文化艺术以及风雅醍醐寺背后的故事。</p>"
);
		
		//list.add(cmsAntique1);
		//	list.add(cmsAntique2);
		//	list.add(cmsAntique3);
					
		//	list.add(cmsAntique4);
		//	list.add(cmsAntique5);
		//	list.add(cmsAntique6);
		
			///list.add(cmsAntique7);
			//list.add(cmsAntique8);
			//list.add(cmsAntique9);
			//list.add(cmsAntique10);
		list.add(cmsAntique11);
		
			list.add(cmsAntique12);

		//list.add(cmsAntique1);
		//list.add(cmsAntique2);
	//	list.add(cmsAntique3);
	//	list.add(cmsAntique4);
	//	list.add(cmsAntique5);
	//	list.add(cmsAntique6);
	//	list.add(cmsAntique7);
	//	list.add(cmsAntique8);
		
CmsAntiqueListVO vo=new CmsAntiqueListVO();
		
		vo.setList(list);
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/antique/create", vo));
	}
}
