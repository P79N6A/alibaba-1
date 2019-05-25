package com.sun3d.why.controller.wechat.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.model.weixin.resp.Article;
import com.sun3d.why.model.weixin.resp.Image;
import com.sun3d.why.model.weixin.resp.ImageMessage;
import com.sun3d.why.model.weixin.resp.News;
import com.sun3d.why.model.weixin.resp.NewsMessage;
import com.sun3d.why.model.weixin.resp.TextMessage;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.WeiXinService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.MessageUtil;
import com.sun3d.why.webservice.api.util.HttpResponseText;
@Service
public class CoreService {
	
	@Autowired
    private WeiXinService weiXinService;
	@Autowired
    private CacheService cacheService;
	
	/**
	* 处理微信发来的请求
	* @param request
	* @return
	*/
	public String processRequest(HttpServletRequest request,String xml) {
		String respMessage = null;
		try {
			// 默认返回的文本消息内容
			String respContent = "文化云 - 文化引领品质生活";
			// xml请求解析
			Map<String, String> requestMap = MessageUtil.parseXml(xml);
			// 发送方帐号（open_id）
			String fromUserName = requestMap.get("FromUserName");
			// 公众帐号
			String toUserName = requestMap.get("ToUserName");
			// 消息类型
			String msgType = requestMap.get("MsgType");
			
			//回复文本消息
			TextMessage textMessage = new TextMessage();
			textMessage.setToUserName(fromUserName);
			textMessage.setFromUserName(toUserName);
			textMessage.setCreateTime(new Date().getTime());
			textMessage.setMsgType(MessageUtil.RESP_MESSAGE_TYPE_TEXT);
			textMessage.setFuncFlag(0);
			
			//回复图文消息
	        NewsMessage newsMessage = new NewsMessage();
	        newsMessage.setToUserName(fromUserName);
	        newsMessage.setFromUserName(toUserName);
	        newsMessage.setCreateTime(new Date().getTime());
	        newsMessage.setMsgType(MessageUtil.RESP_MESSAGE_TYPE_NEWS);
	        
	        //回复图片消息
	        ImageMessage imageMessage = new ImageMessage();
			imageMessage.setToUserName(fromUserName);
			imageMessage.setFromUserName(toUserName);
			imageMessage.setCreateTime(new Date().getTime());
			imageMessage.setMsgType(MessageUtil.RESP_MESSAGE_TYPE_IMAGE);
	        
	        
			//String autoContent = weiXinService.queryWeiXin().getAutoContent();
			//respContent = autoContent;
			if(msgType.equals(MessageUtil.REQ_MESSAGE_TYPE_EVENT)){		//事件推送
				// 事件类型
				String eventType = requestMap.get("Event");
				if(eventType.equals(MessageUtil.EVENT_TYPE_CLICK)){
					// 事件KEY值，与创建自定义菜单时指定的KEY值对应
					String eventKey = requestMap.get("EventKey");
					if(eventKey.equals("ABOUT_WHY")){
						respContent = "文化云是一款聚焦文化领域，提供公众文化生活和消费的互联网平台；目前已汇聚全上海22万场文化活动、5500余文化场馆，上万家文化社团，为公众提供便捷和有品质的文化生活服务。下载文化云，发现更多品质生活：http://www.wenhuayun.cn/appdownload/index.html\n\n对外合作或意见建议请联系电子邮件：business@creatoo.cn或直接在微信留言，云叔会回复~";
						textMessage.setContent(respContent);
						respMessage = MessageUtil.textMessageToXml(textMessage);
						return respMessage;
					}
				}
			}else if(msgType.equals(MessageUtil.REQ_MESSAGE_TYPE_TEXT)){	//普通消息
				String reqContent = requestMap.get("Content");
				//图文消息容器
				List<Article> articleList = new ArrayList<Article>();
				
				/*String []num = new String[]{"1","2","3","4","5","6","7","8","9","10"};
				if(Arrays.asList(num).contains(reqContent)){
					imageMessage.setImage(new Image("viqmAJAYCEEWMUl651mJ6IUTpWiSWNyMcmVIcHQb9Og"));
					respMessage = MessageUtil.imageMessageToXml(imageMessage);
					return respMessage;
				}*/
				String []num = new String[]{"A","B","C","D","E","F","G"};
				if(Arrays.asList(num).contains(reqContent)){
					StringBuilder sb = new StringBuilder("最有童心的人，我们已收到您的申请，请耐心等待审核，若符合活动规则，我们将于7个工作日内完成礼品发放。");
					respContent = sb.toString();
					textMessage.setContent(respContent);
					respMessage = MessageUtil.textMessageToXml(textMessage);
					return respMessage;
				}
				if(reqContent.equals("H")){
					StringBuilder sb = new StringBuilder("没有童心可领不到福袋哟~");
					respContent = sb.toString();
					textMessage.setContent(respContent);
					respMessage = MessageUtil.textMessageToXml(textMessage);
					return respMessage;
				}
				if(reqContent.contains("减压")){
					StringBuilder sb = new StringBuilder("如何获得两张魔都首届减压展的门票？\n\n");
					sb.append("1、分享本文至朋友圈，带上一句真挚的转发语哟~；\n\n");
					sb.append("2、将分享截图发送到“文化云”微信公众号后台；\n\n");
					sb.append("3、截止6月28日18：00，开始抽奖。\n\n");
					sb.append("同时完成上面3步即可成功进入本次票务福利抽奖库，6月28日“文化云”微信公布中奖名单。");
					respContent = sb.toString();
					textMessage.setContent(respContent);
					respMessage = MessageUtil.textMessageToXml(textMessage);
					return respMessage;
				}
				if(reqContent.equals("暑期") || reqContent.equals("暑假")){
					Article article = new Article();
					article.setTitle("暑假班 | 听说你的暑假生活，要被文化云承包了！");
					article.setDescription("海量暑期活动送给您！");
					article.setPicUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201762218657E4I3VgmnrkSPsiZBtpMfZKepyiH2rU.jpg@750w");
					article.setUrl("http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=90");
					articleList.add(article);
				}
				if(reqContent.contains("上海的声音")){
					StringBuilder sb = new StringBuilder("如何获得两张《上海的声音》沪剧经典交响演唱会门票？\n\n");
					sb.append("1、分享本文至朋友圈，带上一句真挚的转发语哟~；\n\n");
					sb.append("2、将分享截图发送到“文化云”微信公众号后台；\n\n");
					sb.append("3、截止6月26日18：00，开始抽奖。\n\n");
					sb.append("同时完成上面3步即可成功进入本次票务福利抽奖库，6月26日“文化云”微信公布中奖名单。");
					respContent = sb.toString();
					textMessage.setContent(respContent);
					respMessage = MessageUtil.textMessageToXml(textMessage);
					return respMessage;
				}
				if(reqContent.contains("音乐")){
					StringBuilder sb = new StringBuilder("只要你做，票就送你，决不食言！\n\n");
					sb.append("1、分享本文至朋友圈，请朋友帮忙点30个赞（6月19日第二条微信，不要分享错哟~）；\n\n");
					sb.append("2、将带有30个赞的分享截图发送给“文化云”微信公众号后台；\n\n");
					sb.append("3、前46名发送符合要求截图的用户每人送上1张夏至音乐日的门票。\n\n");
					sb.append("我们将于48小时内，在微信公众号内回复中奖用户并发送手机短信，请保持手机通畅。");
					respContent = sb.toString();
					textMessage.setContent(respContent);
					respMessage = MessageUtil.textMessageToXml(textMessage);
					return respMessage;
				}
				if(reqContent.contains("洛天依")){
					StringBuilder sb = new StringBuilder("如何获得2张洛天依2017全息演唱会的门票？\n\n");
					sb.append("1、分享本文至朋友圈，号召朋友帮你点赞；\n\n");
					sb.append("2、将分享截图发送给“文化云”微信公众号后台；\n\n");
					sb.append("3、截止6月16日10：00，开始抽奖。\n\n");
					sb.append("同时完成上面3步即可成功进入本次票务福利抽奖库，6月16日10:30开始客服会联系中奖用户，请保持手机通畅， 6月16日“文化云”微信公布中奖名单。");
					respContent = sb.toString();
					textMessage.setContent(respContent);
					respMessage = MessageUtil.textMessageToXml(textMessage);
					return respMessage;
				}
				if(reqContent.equals("中华优秀传统文化知识大赛") || reqContent.equals("传统文化大赛")){
					HttpResponseText res = BindWS.getMaterialList(cacheService,"rnOPWYDmAF7FrE5sd5nEvlYNx889v-wnsAM54N25OR4");
					JSONObject jsonObject = JSON.parseObject(res.getData());
					List<News> newsList = JSON.parseArray(jsonObject.get("news_item").toString(), News.class);
			        Article article = new Article();
					article.setTitle(newsList.get(1).getTitle());
					article.setDescription(newsList.get(1).getDigest());	
					article.setPicUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017516103041Pt1sRr5ey9SOU8rqKos1Klb0ex4OLR.jpg@750w");
					article.setUrl(newsList.get(1).getUrl());
					articleList.add(article);
				}
				if(reqContent.equals("文化直播")){
					Article article = new Article();
					article.setTitle("文化云 | 围观文化直播 三种方式看现场");
					article.setDescription("沪上精彩文化活动现场直播及回顾");
					article.setPicUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20173311610586oC9P0k3JMqL0Vq2Cz7WroGvUHOjjk.jpg@750w");
					article.setUrl("http://china.wenhuayun.cn/wxUser/silentInvoke.do?type=http://m.wenhuayun.cn/wechatLive/index.do");
					articleList.add(article);
				}
				if(reqContent.equals("现场")){
					Article article = new Article();
					article.setTitle("文化云 | 互动赢积分，分享活动现场 展现艺术生活");
					article.setDescription("将你真实感受到的精彩活动现场分享给更多人，精彩就会远远大于你的感受");
					article.setPicUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/image/Img646739857eeb4fd6a8d9f7855d4221bc.jpg@750w");
					article.setUrl("http://china.wenhuayun.cn/wxUser/silentInvoke.do?type=http://m.wenhuayun.cn/wechatStatic/sceneIndex.do");
					articleList.add(article);
				}
				if(reqContent.equals("群艺馆") || reqContent.equals("上海市群众艺术馆")){
					HttpResponseText res = BindWS.getMaterialList(cacheService,"rnOPWYDmAF7FrE5sd5nEvkeBj1wtKe2MzIxW60DrYfE");
					JSONObject jsonObject = JSON.parseObject(res.getData());
					List<News> newsList = JSON.parseArray(jsonObject.get("news_item").toString(), News.class);
			        Article article = new Article();
					article.setTitle(newsList.get(0).getTitle());
					article.setDescription(newsList.get(0).getDigest());	
					article.setPicUrl(newsList.get(0).getThumb_url());
					article.setUrl(newsList.get(0).getUrl());
					articleList.add(article);
					
					article = new Article();
					article.setTitle(newsList.get(1).getTitle());
					article.setPicUrl(newsList.get(1).getThumb_url());
					article.setUrl("http://m.wenhuayun.cn/wechatVenue/venueDetailIndex.do?venueId=5e8739f0511b4caeb05c974273b83b96");
					articleList.add(article);
				}
				if(reqContent.equals("长宁") || reqContent.equals("长宁文化艺术中心")){
					HttpResponseText res = BindWS.getMaterialList(cacheService,"rnOPWYDmAF7FrE5sd5nEvrrQWn-E-Ho6pvYJDZPfvbA");
					JSONObject jsonObject = JSON.parseObject(res.getData());
					List<News> newsList = JSON.parseArray(jsonObject.get("news_item").toString(), News.class);
			        Article article = new Article();
					article.setTitle(newsList.get(1).getTitle());
					article.setDescription(newsList.get(1).getDigest());	
					article.setPicUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017222184127T92dFTWyvX41OXc6DfAU79N26dxVDS.jpg@800w");
					article.setUrl(newsList.get(1).getUrl());
					articleList.add(article);
					
					article = new Article();
					article.setTitle(newsList.get(3).getTitle());
					article.setPicUrl(newsList.get(3).getThumb_url());
					article.setUrl("http://m.wenhuayun.cn/wechatVenue/venueDetailIndex.do?venueId=561d99fbd51f44bba25b287843c8d023");
					articleList.add(article);
					
					newsMessage.setArticleCount(articleList.size());
					newsMessage.setArticles(articleList);
					respMessage = MessageUtil.newsMessageToXml(newsMessage);
					return respMessage;
				}
				/*if(reqContent.equals("长宁艺术") || reqContent.equals("我与长宁艺术")){
					HttpResponseText res = BindWS.getMaterialList(cacheService,"rnOPWYDmAF7FrE5sd5nEvrrQWn-E-Ho6pvYJDZPfvbA");
					JSONObject jsonObject = JSON.parseObject(res.getData());
					List<News> newsList = JSON.parseArray(jsonObject.get("news_item").toString(), News.class);
			        Article article = new Article();
					article.setTitle(newsList.get(2).getTitle());
					article.setDescription(newsList.get(2).getDigest());	
					article.setPicUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/image/Imgc797fef00b344b798b0ed3ee4da04357.jpg@750w");
					article.setUrl("http://china.wenhuayun.cn/wxUser/silentInvoke.do?type=http://m.wenhuayun.cn/wechatFunction/cityIndex.do");
					articleList.add(article);
				}*/
				if(reqContent.equals("票务福利") || reqContent.equals("福利") || reqContent.equals("中奖名单") || reqContent.equals("名单")){
					Article article = new Article();
					article.setTitle("文化云票务福利专区——每日更新（福利/中奖名单）");
					article.setPicUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/image/Imgae7baec07f5541c0bac40348d2fdc2e9.png@750w");
					article.setUrl("https://mp.weixin.qq.com/mp/homepage?__biz=MzA5NTQ1MDM2Mg==&hid=4");
					articleList.add(article);
				}
				if(reqContent.equals("内部验票") || reqContent.equals("go")){
					Article article = new Article();
					article.setTitle("内部验票 | 文化云葵花宝典修炼真经");
					article.setDescription("前线的朋友们~~干的漂亮~~~");
					article.setPicUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/image/Img41480378a27f4bb1aa6e28127d7f6e6f.jpg@750w");
					article.setUrl("http://m.wenhuayun.cn/wechatcheckTicket/toLogin.do");
					articleList.add(article);
				}
				/*if(reqContent.equals("藏海花")){
					HttpResponseText res = BindWS.getMaterialList(cacheService,"rnOPWYDmAF7FrE5sd5nEvv81q8QvBkluX-g9kizZ2Aw");
					JSONObject jsonObject = JSON.parseObject(res.getData());
					List<News> newsList = JSON.parseArray(jsonObject.get("news_item").toString(), News.class);
					
					String newsUrl = "";
					for(News news:newsList){
						if(news.getTitle().contains("藏海花")){
							newsUrl = news.getUrl();
							break;
						}
					}
					
					StringBuilder sb = new StringBuilder("获得盗墓笔记外传《藏海花》多媒体3D舞台剧演出票\n\n");
					sb.append("❤1.分享微信文章至朋友圈，文章链接<a href='"+newsUrl+"'>点这里</a>；并将截图发送至“文化云”微信后台；\n\n");
					sb.append("❤2.截止2017年1月10日（周二）下午15:00，抽取2位用户，每人获得2张演出票；\n\n");
					sb.append("❤3.成功发送截图即算参与成功，获奖名单将于2017年1月10日（周二）“文化云”微信推送中公布。");
					respContent = sb.toString();
					textMessage.setContent(respContent);
					respMessage = MessageUtil.textMessageToXml(textMessage);
					return respMessage;
				}*/
				/*if(reqContent.contains("咖啡")){
					HttpResponseText res = BindWS.getMaterialList(cacheService,"rnOPWYDmAF7FrE5sd5nEvgt-iGrLXklPjZT0EB4RH2I");
					JSONObject jsonObject = JSON.parseObject(res.getData());
					List<News> newsList = JSON.parseArray(jsonObject.get("news_item").toString(), News.class);
					
					String newsUrl = "";
					for(News news:newsList){
						if(news.getTitle().contains("福利")){
							newsUrl = news.getUrl();
							break;
						}
					}
					
					StringBuilder sb = new StringBuilder("获得咖啡生活周入场券规则\n\n");
					sb.append("1.\n");
					sb.append("分享微信文章至朋友圈，文章链接<a href='"+newsUrl+"'>点这里</a>；\n\n");
					sb.append("2.\n");
					sb.append("🌟 回复“12.17咖啡+姓名+手机号码”至文化云微信公众号参与“咖啡生活之花艺沙龙”活动抽奖；\n");
					sb.append("🌟 回复“12.18咖啡+姓名+手机号码”至文化云微信公众参加“漫步滨江”活动抽奖；\n");
					sb.append("🌟回复“12.19咖啡+姓名+手机号码”至文化云微信公众参加“维也纳咖啡品鉴会”活动抽奖；\n\n");
					sb.append("3.\n");
					sb.append("截止12月15日（周四）下午15:00，抽取2位用户，每人获得1张“咖啡生活之花艺沙龙”入场券；\n");
					sb.append("抽取10位用户，每人获得1张“漫步滨江”入场券；\n");
					sb.append("抽取5位用户，每人获得1张“维也纳咖啡品鉴会”入场券；\n\n");
					sb.append("4.\n");
					sb.append("获奖用户我们将于12月15日（周四）16:00进行电话通知，请参与活动的用户保持手机通畅。");
					respContent = sb.toString();
					textMessage.setContent(respContent);
					respMessage = MessageUtil.textMessageToXml(textMessage);
					return respMessage;
				}*/
				if(reqContent.equals("文化活动")||reqContent.equals("活动")){
			        Article article = new Article();
					article.setTitle("精选 | 听说这里收集了上海最全的文化活动！准备好了吗？精彩马上开启~");
					article.setDescription("“文化云”用文化引领你的品质生活");
					article.setPicUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016125184158TN5IFAcicYryGZWxEhCaDyrAtsCA2o.jpg@750w");
					article.setUrl("http://china.wenhuayun.cn/wxUser/silentInvoke.do?type=http://m.wenhuayun.cn/wechat/index.do");
					articleList.add(article);
				}
				if(reqContent.equals("有奖活动")){
			        Article article = new Article();
					article.setTitle("有奖活动 | “云上”文化线上活动汇总 最涨姿势 超多奖品");
					article.setDescription("快来赢取奖品吧 手慢无哟~");
					article.setPicUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/image/Img1931bc2f59534abe9b17d89bfecfe608.jpg@750w");
					article.setUrl("http://china.wenhuayun.cn/wxUser/silentInvoke.do?type=http://m.wenhuayun.cn/wechatStatic/contestList.do");
					articleList.add(article);
				}
				if(reqContent.contains("使用指南")||reqContent.contains("帮助")||reqContent.contains("积分")||reqContent.contains("预订")||reqContent.contains("订单")||reqContent.contains("预约")||reqContent.contains("下单")){
					StringBuilder sb = new StringBuilder("文化云全方位使用指南：\n\n");
					sb.append("🌟不知道怎么免费预订公共文化活动？\n<a href='http://m.wenhuayun.cn/STATIC/wechat/guide/guide2.html'>点这里</a>查看下单操作指南\n\n");
					sb.append("🌟不知道怎么使用文化云度过快乐时光？\n<a href='http://m.wenhuayun.cn/STATIC/wechat/guide/guide1.html'>点这里</a>查看注册及登陆指南\n\n");
					sb.append("🌟不知道怎么查询文化云积分？\n<a href='http://m.wenhuayun.cn/STATIC/wechat/guide/guide3.html'>点这里</a>查看积分操作指南\n\n");
					sb.append("🌟不知道在哪里查询预订过的文化活动？\n<a href='http://m.wenhuayun.cn/STATIC/wechat/guide/guide4.html'>点这里</a>查看订单操作指南");
					respContent = sb.toString();
					textMessage.setContent(respContent);
					respMessage = MessageUtil.textMessageToXml(textMessage);
					return respMessage;
				}
				if(reqContent.equals("城市名片")||reqContent.equals("丈量上海")){
			        Article article = new Article();
					article.setTitle("文化云·邀你一起打造上海城市名片");
					article.setDescription("每个月一个主题，征集你在上海各种空间的图片记忆，爱上海，从我做起。");
					article.setPicUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017621143227vZ0Rlz0CMWryH6CXaKlwgRw0gPkVLa.jpg@750w");
					article.setUrl("http://china.wenhuayun.cn/wxUser/silentInvoke.do?type=http://m.wenhuayun.cn/wechatFunction/cityIndex.do");
					articleList.add(article);
				}
				if(reqContent.equals("精品活动")){
					HttpResponseText res = BindWS.getMaterialList(cacheService,"rnOPWYDmAF7FrE5sd5nEvqdKiv4qaYKkmC5wwPt-m64");
					JSONObject jsonObject = JSON.parseObject(res.getData());
					List<News> newsList = JSON.parseArray(jsonObject.get("news_item").toString(), News.class);
			        Article article = new Article();
					article.setTitle(newsList.get(0).getTitle());
					article.setDescription(newsList.get(0).getDigest());	
					article.setPicUrl(newsList.get(0).getThumb_url());
					article.setUrl("http://m.wenhuayun.cn/wechatStatic/bannerList.do");
					articleList.add(article);
				}
				if(reqContent.equals("文化体验师")){
					HttpResponseText res = BindWS.getMaterialList(cacheService,"rnOPWYDmAF7FrE5sd5nEvje14MZBwdVbKGeeAnBuBps");
					JSONObject jsonObject = JSON.parseObject(res.getData());
					List<News> newsList = JSON.parseArray(jsonObject.get("news_item").toString(), News.class);
			        Article article = new Article();
					article.setTitle(newsList.get(0).getTitle());
					article.setDescription(newsList.get(0).getDigest());	
					article.setPicUrl(newsList.get(0).getThumb_url());
					article.setUrl(newsList.get(0).getUrl());
					articleList.add(article);
					
					res = BindWS.getMaterialList(cacheService,"rnOPWYDmAF7FrE5sd5nEvgqJdvQu5rSP0ins6YPD-fM");
					jsonObject = JSON.parseObject(res.getData());
					newsList = JSON.parseArray(jsonObject.get("news_item").toString(), News.class);
			        article = new Article();
					article.setTitle(newsList.get(0).getTitle());
					article.setDescription(newsList.get(0).getDigest());	
					article.setPicUrl(newsList.get(0).getThumb_url());
					article.setUrl(newsList.get(0).getUrl());
					articleList.add(article);
					
					article = new Article();
					article.setTitle("专栏 | NO.1期 文化体验师体验报告作品展示");
					article.setPicUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/image/Img951ea3a0062d49a39e83d82105c61124.jpg@700w");
					article.setUrl("http://www.wenhuayun.cn/information/preInfo.do?informationId=40de704c08fb4e17a761fe5c1603772a");
					articleList.add(article);
				}
				if(reqContent.equals("志愿者")||reqContent.equals("志愿者报名")||reqContent.equals("志愿者报名表")){
					Article article = new Article();
					article.setTitle("招募 | 上海各大文化场馆及大型活动志愿者招募报名表");
					article.setDescription("做传播文化的志愿者 让你更接近自己所爱");
					article.setPicUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016103118532TAxW55h9E0mMjkxV68cP8GzBZWnnbi.jpg@750w");
					article.setUrl("http://m.wenhuayun.cn/wechatStatic/volunteerRecruitIndex.do");
					articleList.add(article);
				}
				if(reqContent.equals("红星")||reqContent.equals("长征")){
			        Article article = new Article();
					article.setTitle("重磅 | “红星照耀中国”纪念长征胜利80周年线上展览与互动挑战赛上线啦~");
					article.setDescription("纪念长征胜利80周年，万份革命锦囊等你来拿！");
					article.setPicUrl("http://img1.ctwenhuayun.cn/admin/45/201609/Img/Imgf36c255067824e5c84fc1bf1cdca83fa_750_500.jpg");
					article.setUrl("http://china.wenhuayun.cn/wxUser/silentInvoke.do?type=http://m.wenhuayun.cn/wechatRedStar/welcome.do");
					articleList.add(article);
				}
				if(reqContent.equals("松江剧场")||reqContent.contains("松江")){
			        Article article = new Article();
					article.setTitle("【松江剧场】最全实时演出清单（可预订）");
					article.setDescription("为松江人民服务，我们是认真的。");
					article.setPicUrl("http://img1.wenhuayun.cn/admin/60/201511/Img/Img9c452e6fe2844d2b9858fc156f4e9d33_750_500.jpg");
					article.setUrl("http://m.wenhuayun.cn/wechatActivity/preActivityList.do?venueId=d1150c4cd00b4307aa1e2cd095072808");
					articleList.add(article);
				}
				if(reqContent.equals("积分")){
					imageMessage.setImage(new Image("viqmAJAYCEEWMUl651mJ6MOd6qDouiARWPkEjdFOuxI"));
					respMessage = MessageUtil.imageMessageToXml(imageMessage);
					return respMessage;
				}
				if(reqContent.equals("沪剧")){
			        Article article = new Article();
					article.setTitle("收藏贴 | 送给沪剧迷们的大礼包，每日更新~");
					article.setDescription("此文在手，沪剧全有。");
					article.setPicUrl("http://img1.wenhuayun.cn/admin/45/201608/Img/Imgd1a55033efe444dcab97763da8e7f702.jpg");
					article.setUrl("http://m.wenhuayun.cn/wechatActivity/preActivityList.do?activityName=%E6%B2%AA%E5%89%A7");
					articleList.add(article);
				}
				if(reqContent.equals("中华艺术宫")){
			        Article article = new Article();
					article.setTitle("中华艺术宫");
					article.setPicUrl("http://img1.wenhuayun.cn/admin/44/201603/Img/Img50c7b1ff81764d508324442dec86bf71_750_500.jpg");
					article.setUrl("http://m.wenhuayun.cn/wechatVenue/venueDetailIndex.do?venueId=2f579b2d7acd497f9ded78df0542d182");
					articleList.add(article);
					
					HttpResponseText res = BindWS.getMaterialList(cacheService,"rnOPWYDmAF7FrE5sd5nEvjf92PZz_0m2JzYRDgBlJsM");
					JSONObject jsonObject = JSON.parseObject(res.getData());
					List<News> newsList = JSON.parseArray(jsonObject.get("news_item").toString(), News.class);
			        article = new Article();
					article.setTitle(newsList.get(0).getTitle());
					article.setDescription(newsList.get(0).getDigest());	
					article.setPicUrl(newsList.get(0).getThumb_url());
					article.setUrl(newsList.get(0).getUrl());
					articleList.add(article);
				}
				if(reqContent.equals("上海博物馆")){
			        Article article = new Article();
					article.setTitle("上海博物馆");
					article.setPicUrl("http://img1.wenhuayun.cn/admin/45/201603/Img/Imga3ab5a6bac0044ee83d96a8e37a507a1_750_500.jpg");
					article.setUrl("http://m.wenhuayun.cn/wechatVenue/venueDetailIndex.do?venueId=05f6b63b4e5e4b2e95139099a8c08ce1");
					articleList.add(article);
				}
				if(reqContent.equals("上海大剧院")){
			        Article article = new Article();
					article.setTitle("上海大剧院");
					article.setPicUrl("http://img1.wenhuayun.cn/admin/45/201608/Img/Img664b47009fef45bfb099a191ada58194_750_500.jpg");
					article.setUrl("http://m.wenhuayun.cn/wechatVenue/venueDetailIndex.do?venueId=d057471712e74069ab63dd2c2172d98f");
					articleList.add(article);
				}
				if(reqContent.equals("上海话剧艺术中心")){
			        Article article = new Article();
					article.setTitle("上海话剧艺术中心");
					article.setPicUrl("http://img1.wenhuayun.cn/admin/45/201607/Img/Img6ad4d7f93d234c87abf5a8048d3c60b4_750_500.jpg");
					article.setUrl("http://m.wenhuayun.cn/wechatVenue/venueDetailIndex.do?venueId=a212b3f8bd1042ec8108d1da7a083990");
					articleList.add(article);
				}
				if(reqContent.equals("上海少年儿童图书馆")||reqContent.equals("少图")){
			        Article article = new Article();
					article.setTitle("上海少年儿童图书馆");
					article.setPicUrl("http://img1.wenhuayun.cn/admin/45/201602/Img/Img09f199bb641542d685d549c6e31ae6d3_750_500.jpg");
					article.setUrl("http://m.wenhuayun.cn/wechatVenue/venueDetailIndex.do?venueId=8717cc42e5b54dc0a177db642fe13e6b");
					articleList.add(article);
				}
				if(reqContent.equals("静安区少年儿童图书馆")){
			        Article article = new Article();
					article.setTitle("静安区少年儿童图书馆");
					article.setPicUrl("http://img1.wenhuayun.cn/admin/45/201602/Img/Img02e3396e8259435387da0b2b9121dead_750_500.jpg");
					article.setUrl("http://m.wenhuayun.cn/wechatVenue/venueDetailIndex.do?venueId=b6e1451537014cf092dfc510660c9761");
					articleList.add(article);
				}
				if(reqContent.equals("亲子")){
			        Article article = new Article();
					article.setTitle("免费公益活动周刊——亲子");
					article.setDescription("这是一本每日更新的上海免费公益文化活动期刊");
					article.setPicUrl("http://m.wenhuayun.cn/STATIC/wxStatic/image/banner-4.jpg");
					article.setUrl("http://china.wenhuayun.cn/wxUser/silentInvoke.do?type=http://m.wenhuayun.cn/wechatStatic/magazine.do?activityType=47486962f28e41ceb37d6bcf35d8e5c3");
					articleList.add(article);
				}
				if(reqContent.equals("演出")){
			        Article article = new Article();
					article.setTitle("免费公益活动周刊——演出");
					article.setDescription("这是一本每日更新的上海免费公益文化活动期刊");
					article.setPicUrl("http://m.wenhuayun.cn/STATIC/wxStatic/image/banner-2.jpg");
					article.setUrl("http://china.wenhuayun.cn/wxUser/silentInvoke.do?type=http://m.wenhuayun.cn/wechatStatic/magazine.do?activityType=bfb37ab6d52f492080469d0919081b2b");
					articleList.add(article);
				}
				if(reqContent.equals("传统知识")){
			        Article article = new Article();
					article.setTitle("重磅 | 大型全民中华传统知识挑战赛已经启程，探索五千年文明古国奥秘");
					article.setDescription("让你欲罢不能的传统知识挑战赛（新手版）");
					article.setPicUrl("https://mmbiz.qlogo.cn/mmbiz_jpg/3Dr58OvtyydcZbkr78pJibKiadU63lqTcq2nsdG3tnHmlichfLJG2JSW7SDskbwuibgMPibkRLw8M90rmv8wcaXe5DQ/0?wx_fmt=jpeg");
					article.setUrl("http://mp.weixin.qq.com/s?__biz=MzA5NTQ1MDM2Mg==&mid=2651697386&idx=1&sn=fecc6424abebd145057776017bcafae8&chksm=8b46357fbc31bc69b2e1356a98bf7220c68efe9afacca461c4bc7282a46b56230af192846050&mpshare=1&scene=1&srcid=0203kGLZcz7yUxq1IzvOgb1m#rd");
					articleList.add(article);
				}
				String []area = new String[]{"奉贤"};
				//获取图文素材
				HttpResponseText res = BindWS.getMaterialList(cacheService,"viqmAJAYCEEWMUl651mJ6A3Z9slUuG5eC7hP8DyrdkA");
				System.out.println(res.getData());
				JSONObject jsonObject = JSON.parseObject(res.getData());
				HttpResponseText res2 = BindWS.getMaterialList(cacheService,"viqmAJAYCEEWMUl651mJ6AquvV-Lpmv2lILOFD6IpWQ");
				JSONObject jsonObject2 = JSON.parseObject(res2.getData());
				List<News> newsList = JSON.parseArray(jsonObject.get("news_item").toString(), News.class);
				newsList.addAll(JSON.parseArray(jsonObject2.get("news_item").toString(), News.class));
		        outerloop:for(int j=0;j<area.length;j++){
					if(reqContent.contains(area[j])){
						for(int i=0;i<newsList.size();i++){
							if(newsList.get(i).getTitle().contains(area[j])){
								Article article = new Article();
								article.setTitle(newsList.get(i).getTitle());
								article.setDescription(newsList.get(i).getDigest());	
								article.setPicUrl(newsList.get(i).getThumb_url());
								article.setUrl(newsList.get(i).getUrl());
								articleList.add(article);
								if(articleList.size()==10){	//最多10篇
									break outerloop;
								}
							}
						}
					}
				}
		        
		        //回复图文消息
				if(articleList.size()>0){
					// 设置图文消息个数
					newsMessage.setArticleCount(articleList.size());
			          // 设置图文消息包含的图文集合
					newsMessage.setArticles(articleList);
			          // 将图文消息对象转换成xml字符串
					respMessage = MessageUtil.newsMessageToXml(newsMessage);
					return respMessage;
				}
				return respMessage;
			}else if(msgType.equals(MessageUtil.REQ_MESSAGE_TYPE_IMAGE)){	//图片消息
				return respMessage;
			}else if(msgType.equals(MessageUtil.REQ_MESSAGE_TYPE_LINK)){	//链接消息
				return respMessage;
			}else if(msgType.equals(MessageUtil.REQ_MESSAGE_TYPE_LOCATION)){	//地理位置消息
				return respMessage;
			}else if(msgType.equals(MessageUtil.REQ_MESSAGE_TYPE_VOICE)){	//音频消息
				return respMessage;
			}else if(msgType.equals(MessageUtil.REQ_MESSAGE_TYPE_VIDEO)){	//视频消息
				return respMessage;
			}else if(msgType.equals(MessageUtil.REQ_MESSAGE_TYPE_SHORTVIDEO)){	//小视频消息
				return respMessage;
			}
			
			//首次关注默认回复
			/*StringBuilder sb = new StringBuilder("有朋自远方来，不亦说乎\n爱文化的你，我们终于见面了\n\n");
			sb.append("我们致力于提供就在你身边的公共文化资源，\n免费活动在线预订，文化空间尽在掌握，文化社团正在发生\n\n");
			sb.append("🌟高雅文化人，看这里：\n<a href='http://m.wenhuayun.cn/wxUser/silentInvoke.do?type=/wechatVenue/venueDetailIndex.do?venueId=2f579b2d7acd497f9ded78df0542d182'>中华艺术宫</a> <a href='http://m.wenhuayun.cn/wxUser/silentInvoke.do?type=/wechatVenue/venueDetailIndex.do?venueId=05f6b63b4e5e4b2e95139099a8c08ce1'>上海博物馆</a>\n");
			sb.append("🌟轻文艺患者，看这里：\n<a href='http://m.wenhuayun.cn/wxUser/silentInvoke.do?type=/wechatVenue/venueDetailIndex.do?venueId=d057471712e74069ab63dd2c2172d98f'>上海大剧院</a>\n<a href='http://m.wenhuayun.cn/wxUser/silentInvoke.do?type=/wechatVenue/venueDetailIndex.do?venueId=a212b3f8bd1042ec8108d1da7a083990'>上海话剧艺术中心</a>\n");
			sb.append("🌟亲子教育派，看这里：\n<a href='http://m.wenhuayun.cn/wxUser/silentInvoke.do?type=/wechatVenue/venueDetailIndex.do?venueId=8717cc42e5b54dc0a177db642fe13e6b'>上海少年儿童图书馆</a>\n<a href='http://m.wenhuayun.cn/wxUser/silentInvoke.do?type=/wechatVenue/venueDetailIndex.do?venueId=b6e1451537014cf092dfc510660c9761'>静安区少年儿童图书馆</a>\n");
			sb.append("🌟青年艺术派，看这里：\n<a href='http://m.wenhuayun.cn/wxUser/silentInvoke.do?type=/wechatStatic/fxActivity.do'>2016中国国际青年艺术周(上海·奉贤)</a>\n\n");
			sb.append("第18届中国上海国际艺术节·艺术天空订票专场\n");
			sb.append("<a href='http://m.wenhuayun.cn/wxUser/silentInvoke.do?type=/wechatStatic/artSky.do'>点这里订票</a>\n\n");
			sb.append("查看全部文化活动\n");
			sb.append("<a href='http://m.wenhuayun.cn/wxUser/silentInvoke.do?type=/wechat/index.do'>点这里</a>\n");
			sb.append("近期大型专场活动\n");
			sb.append("<a href='http://mp.weixin.qq.com/s?__biz=MzA5NTQ1MDM2Mg==&mid=504210077&idx=1&sn=3c9888891c77d21c691dfe76afbebead#wechat_redirect'>点这里</a>");*/
			
			StringBuilder sb = new StringBuilder("爱文化的你，我们终于见面了😄\n");
			sb.append("我们致力于提供就在你身边的公共文化，\n");
			sb.append("免费活动在线预订，文化空间尽在掌握，文化志愿者正在征集\n\n");
			sb.append("⭐<a href='http://china.wenhuayun.cn/wxUser/silentInvoke.do?type=http://m.wenhuayun.cn/wechat/index.do'>点这里</a>预订文化活动\n");
			sb.append("⭐<a href='http://china.wenhuayun.cn/wxUser/silentInvoke.do?type=http://m.wenhuayun.cn/wechatVenue/toSpace.do'>点这里</a>查看文化空间\n\n");
			sb.append("🔥近期最热：\n");
			sb.append("⭐“我们的行走故事”摄影大赛正在火热进行中， <a href='http://china.wenhuayun.cn/wxUser/silentInvoke.do?type=http://m.wenhuayun.cn/wechatStatic/walkIndex.do'>点这里</a>立刻参与\n\n");
			sb.append("⭐文化广场汇聚文化节最新动态， <a href='http://china.wenhuayun.cn/wxUser/silentInvoke.do?type=http://m.wenhuayun.cn/wechatStatic/cultureSquare.do'>点这里</a>浏览全部");
			respContent = sb.toString();
			textMessage.setContent(respContent);
			respMessage = MessageUtil.textMessageToXml(textMessage);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return respMessage;
	}	
	
	//判断字符串是否存在11位数字
	public static boolean hasEleNumer(String str){
		int n = 0;
		for (int i = 0; i < str.length(); i++){
			if (Character.isDigit(str.charAt(i))){
				n++;
				if(n==12){
					n = 0;
				}
			}else{
				if(n==11){
					return true;
				}
				n = 0;
			}
		}
		if(n==11){
			return true;
		}
		return false;
	}
	
	//判断手机号
	public static boolean isMobileNO(String mobiles){
		Pattern p = Pattern.compile("^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$");
		Matcher m = p.matcher(mobiles);
		return m.matches();
	}
}
