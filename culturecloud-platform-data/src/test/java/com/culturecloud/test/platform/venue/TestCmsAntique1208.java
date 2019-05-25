package com.culturecloud.test.platform.venue;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import com.culturecloud.model.bean.venue.CmsAntique;
import com.culturecloud.model.request.venue.CmsAntiqueListVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;

public class TestCmsAntique1208 extends TestRestService{

	@Test
	public void createCmsAntique(){
		
        String[] antiqueTitles = { "3分钟带你逛完故宫_短片", "北京延迟摄影_短片", "北京房事_创意动画短片", "京剧贵妃醉酒_水墨动画", "西游记新说_BBC北京奥运会动画短片", "《广州·双生》_短片", "水脑袋_动画短片", "在广州生活的五个胶人_短片", "《得闲饮茶》广州民俗文化_短片", "《广州这个地方》_宣传片", "《Zweizwei眼中的广州上海深圳》延时摄影_短片", "城市微电影《IN 深圳》_短片", "关山月美术馆_宣传片", "文兮归来——中国当代艺术展_宣传片", "2016深圳湾艺穗节集结狂欢_宣传片" };
        String[] antiqueVideoUrls = { "http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/201612622312829zEOTXxvS55GoYj9y54jVBjqUHZBq.mp4", "http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016126223143CYXCyfAcA2krE4nMqFTCSDU8mGUA50.mp4", "http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016126223527ZQL8AhxK4kNJH4VYGSTKKNKtiTIzF7.mp4", "http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016126223615gWCuEu9CiaIoWQ3SOyyYvBHANEzVe6.mp4", "http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016126223729hBb8Ya02eNkLZachP977c8P86dHBOH.mp4", "http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016126223852NYxSoC1MaMBlZeMP8TOi9KLgwS0Jxp.mp4", "http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016126224012YMM4qxnjDnw6No6TRKX5RvZLIcDlfU.mp4", "http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016126224056BGWIv4gcqmGYGBRHt56WJ4YW1bKdkA.mp4", "http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/201612893513pqjJbs9CPI8ZQOWXGexzPjlgXAUsPq.mp4", "http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/201612893534NFVL1UY5keQQRlFGI0VIyU9ZAon1AD.mp4", "http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016126224126Y3fjG2sW3tgwzNjkAl0KyATu0UKZlP.mp4", "http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016126224156KkcjJtcPBwg4yjYMhF836zdN8RmZRa.mp4", "http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/201612893723rvTsTrpBtVxB736pwNpucekLnos5iA.mp4", "http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/201612893849Q0LunAaxWxQQ4DlFulfwLl3o90KOdy.mp4", "http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2016128939211d7aF2QIKSOaNmuQETWdbJfRfLDvoE.mp4" };
        String[] antiqueIntros = { "<p>北京故宫是中国明清两代的皇家宫殿，旧称为紫禁城，位于北京中轴线的中心。是中国古代宫廷建筑之精华，占地72万平方米，建筑面积约15万平方米，共有殿宇9999间半，是世界上现存规模最大、保存最为完整的木质结构古建筑之一。有大小宫殿七十多座，房屋九千余间，以太和、中和、保和三大殿为中心。</p>", "<p>从古老的城市建筑群和现代的摩天大楼，从形态各异的SOHO到熟悉的大型商场，从永定门到仰山的中轴线，北京，包罗万象，这正是她的魅力所在。</p>", "<p>今天的房价真的合理么？《北京房事》通过motion graphic的方式，将数据形象化，将北京房价的一些信息进行整合，分别从房子的历史、居住面积、高房价以及房子的生态环境四个方面叙述我们居住状况。让人们能够通过视觉的方式更直观地感受到北京房价的虚高现况，理性对待买房。</p>", "<p>贵妃醉酒又名《百花亭》,源于乾隆时一部地方戏《醉杨妃》的京剧剧目,是梅派经典代表剧目之一。国粹水墨动画与京剧完美结合,堪称一绝。</p>", "<p>英国乐队Blur的主唱Damon Albarn，携手为虚拟乐队Gorillaz设计人物形象的Jamie Hewlett曾为BBC制作了这支2008北京奥运会的宣传短片。本片采用了《西游记》的基本故事框架，重新设计了孙悟空、猪八戒、沙僧以及观世音菩萨的卡通形象，讲述取经队伍前往“鸟巢”的路途中遇到的一系列危机，只是这次师父并不在计划之内。</p>", "<p>广州有着太多争议的城市，每一个角落都会有她本身的冷漠，也有专属于部分人的温存。这个十月，广东外语外贸大学几个大学生尝试着去走过广州一些地方，用这部纪录片去呈现和表达这种温存。献给生活在广州的每一个你。</p><br><p>导演:林文杰</p>", "<p>这是一个关于精神压力的故事。孩子们在一坨大怪物的强压之下，只得选择不断的做作业。随着他们精神压力的增加，大脑里的水也随之沸腾。而这些背后的怪物呢？就是通过吸食从孩子大脑里蒸腾出来的气体来维持生存的，一部反应孩子压力的动画片。</p><br><p>制作团队：</p><br><p>广州美术学院ANI7IME</p>", "<p>本片截取了最能代表广州精神的几个年轻人，通过对他们生活的解读，在DJ彭伟的旁白，带我们走进一个不一样的广州。</p><br><p>用微电影的形式记录一座城市的做法并不算新奇，然而本片以独特的拍摄视角，将城市的记忆与人的生活做了一个非常文艺的链接，在一片泛白的清新色系中，我们看到一座年轻而多元的广州。</p>", "<p>“饮早茶”已经不只是一个广州人所独自享用的事情,很多时候,它被认为是一种人际沟通常用的沟通交际手段。短片通过材料拼接的方式来呈现早茶文化包括的元素。</p><br><p>千百年来,粤人“叹早茶”充分展现中华民族充沛的创造力,体现中华民族优秀的文化价值和审美情趣,是我国优秀传统文化的重要组成部分。而今作为后人的我们更是需要传承。</p><br><p>制作者：广州美术学院</p>", "<p>《广州这个地方》真实记录当下社会环境与时代特征，重新认识一座城市的过去与当下。</p><br><p>我们应该如何认识她——这个备受争议、而又那样有耐性地始终保持沉默的城市。当然，认识一个地方如同认识-个人，永远只能无限地趋近于完全认识——那就让我们平静地以同样的耐性、真切地去感受：广州，这个地方⋯⋯</p>", "<p>来自俄罗斯的摄影师Zweizwei将广州、上海和深圳通过延时摄影的手段表现出来，古老与现代在一座城市中碰撞，在5分钟的影像中浓缩⋯⋯</p>", "<p>这部在深圳大运会前夕发布的微电影，摒弃了大而全的夸张呈现，而是用朴实的笔触以一个三口之家、一对恋人、钢琴少年、图书管理员、幼儿园老师的日常生活和情感经历，勾勒出只属于深圳的城市画卷。在情节结构的处理上分为5个章节，包括亲子关系、爱情的曼妙、师生的感恩情怀、人与城市的关系以及大爱式的感悟。</p><br><p>导演：林旭坚 </p>", "<p>关山月美术馆是由广东省深圳市政府投资兴建，以关山月先生名字命名的国家美术馆。于1995年元月奠基，1997年6月25日正式落成开馆。国家主席江泽民亲笔题写馆名。</p><br><p>该馆占地8000平方米，建筑面积15000平方米，拥有8个室内标准展厅，一个中央圆型大厅和一个户外雕塑广场。是一个非营利性的、对社会和公众开放的永久性国家文化事业机构。以收藏、研究、陈列、推广关山月先生的美术作品为主，同时兼备国家现代美术馆的各项功能。</p>", "<p>“文兮归来——中国当代艺术展”的艺术家，通过不同的图式和语言，展现了不同地区的艺术家在创作中的文化回归，与此同时，此次展览还有机的结合了讲座、工作坊、研讨会等多项具有学术价值的文化活动。</p><br><p>主办单位：深圳美术馆</p>", "<p>2016深圳湾艺穗节（Shenzhen Fringe Festival）于2016年12月3日至11日以热闹的艺术气息在深圳湾举行，为深港市民带来连续九天共86场精彩节目。</p><br><p>2016艺穗节以“停不了的艺穗，Moving Fringe!”为主题，来自全球各地57个艺术团队，为大家献上86场免费好戏，包括音乐、舞蹈、街头艺术、工作坊等多种演出形式，让艺术走入社区同观众交流互动。</p>" };
        
        
    
        ArrayList<CmsAntique> antiqueList = new ArrayList<CmsAntique>();
        
        for (int i = 0; i < antiqueTitles.length; i++) {
            CmsAntique model = new CmsAntique();
            model.setAntiqueName(antiqueTitles[i]);
            model.setAntiqueVideoUrl(antiqueVideoUrls[i]);
            model.setAntiqueRemark(antiqueIntros[i]);
            
            if(i>=10)
            antiqueList.add(model);
        }
		
		
        CmsAntiqueListVO vo=new CmsAntiqueListVO();
		
		vo.setList(antiqueList);
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/antique/create", vo));
	}
}
