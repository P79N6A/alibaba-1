package com.sun3d.why.controller.wechat.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.model.weixin.resp.Article;
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
			// 回复文本消息
			TextMessage textMessage = new TextMessage();
			textMessage.setToUserName(fromUserName);
			textMessage.setFromUserName(toUserName);
			textMessage.setCreateTime(new Date().getTime());
			textMessage.setMsgType(MessageUtil.RESP_MESSAGE_TYPE_TEXT);
			textMessage.setFuncFlag(0);
			String autoContent = weiXinService.queryWeiXin().getAutoContent();
			respContent = autoContent;
			if(msgType.equals(MessageUtil.REQ_MESSAGE_TYPE_EVENT)){		//事件推送
				// 事件类型
				String eventType = requestMap.get("Event");
				if(eventType.equals(MessageUtil.EVENT_TYPE_CLICK)){
					// 事件KEY值，与创建自定义菜单时指定的KEY值对应
					String eventKey = requestMap.get("EventKey");
					if(eventKey.equals("ABOUT_WHY")){
						respContent = "文化云是一款聚焦文化领域，提供公众文化生活和消费的互联网平台；目前已汇聚全上海22万场文化活动、5500余文化场馆，上万家文化社团，为公众提供便捷和有品质的文化生活服务。下载文化云，发现更多品质生活：http://www.wenhuayun.cn/appdownload/index.html";
					}else if(eventKey.equals("CONTACT_WHY")){
						respContent = "对外合作或意见建议请联系电子邮件：business@sun3d.com或直接在微信留言，云叔会回复~";
					}
				}
			}else if(msgType.equals(MessageUtil.REQ_MESSAGE_TYPE_TEXT)){	//普通消息
				String reqContent = requestMap.get("Content");
				/*if(reqContent.contains("琴迷巴西")){
					respContent = "如何获取免费演出票？\n\n转发此次活动文章到朋友圈并截图发给文化云后台参与抽奖。即有机会免费获得2016上海城市草坪音乐会“琴迷巴西”的演出票2张。";
				}else{
					return respMessage;
				}*/
				//获取图文素材
				HttpResponseText res = BindWS.getMaterialList(cacheService);
				JSONObject jsonObject = JSON.parseObject(res.getData());
				List<News> newsList = JSON.parseArray(jsonObject.get("news_item").toString(), News.class);
				//创建图文消息(回复用)
		        NewsMessage newsMessage = new NewsMessage();
		        newsMessage.setToUserName(fromUserName);
		        newsMessage.setFromUserName(toUserName);
		        newsMessage.setCreateTime(new Date().getTime());
		        newsMessage.setMsgType(MessageUtil.RESP_MESSAGE_TYPE_NEWS);
		        List<Article> articleList = new ArrayList<Article>();
				if(reqContent.contains("宝山区")){
					for(int i=0;i<newsList.size();i++){
						if(newsList.get(i).getTitle().contains("宝山")){
							Article article = new Article();
							article.setTitle(newsList.get(i).getTitle());
							article.setDescription(newsList.get(i).getDigest());	
							article.setPicUrl(newsList.get(i).getThumb_url());
							article.setUrl(newsList.get(i).getUrl());
							articleList.add(article);
						}
					}
					
					// 设置图文消息个数
					newsMessage.setArticleCount(articleList.size());
			          // 设置图文消息包含的图文集合
					newsMessage.setArticles(articleList);
			          // 将图文消息对象转换成xml字符串
					respMessage = MessageUtil.newsMessageToXml(newsMessage);
					return respMessage;
				}else{
					return respMessage;
				}
				//return respMessage;
			}
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
}
