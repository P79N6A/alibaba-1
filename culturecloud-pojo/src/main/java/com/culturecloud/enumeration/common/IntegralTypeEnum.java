package com.culturecloud.enumeration.common;

/**
 * 积分类型枚举
 * 
 * @author zhangshun
 *
 */
public enum IntegralTypeEnum {

	REGISTER("欢迎礼","首次注册账号",1),
	COMMENT("发言奖励","成功评论1次",2),
	FORWARDING("转发一次","转发奖励",3),
	VERIFICATION("活动奖励","活动到场 成功验票",4),
	EVERYDAY("登录","每日登录",5),
	WEEK_OPEN("活跃奖励","自然周登录访问三次及以上",6),
	REDUCE_INTEGRAL("支付消费","热门活动支付",7),
	COMMENT_DELETE("评论","删除评论",8),
	CLOUD_INTEGRAL("云叔积分","云叔人肉奖励或惩罚",9),
	RETURN_INTEGRAL("退订返还","退订成功返还",10),
	NOT_VERIFICATION("放鸽子惩罚","预订活动未到场",11),
	TGB_JOIN("真善美","参与",12),
	TGB_VOTE("真善美","投票",13),
	ACTIVITY_QR("扫二维码进活动 ","特别奖励",14),
	FX_ANSWER("奉贤答题","完善个人信息",15),
	RS_ANSWER("红星耀中国","抽奖",16),
	BEAUTYCITY("最美城市","集满多个不同空间",17),
	DRAMA("上海当代艺术节","提交剧评",18),
	DC_VIDEO("春华秋实市民投票通道","首次投票视频",19),
	DC_VOTE("春华秋实市民投票通道","投票视频",20),
	COMEDY("上海国际喜剧节","上传笑脸",21),
	CITY_USER("城市名片","首次参与",22),
	CITY_IMG("城市名片","发布超过9张照片",23),
	CITY_VOTE("城市名片","作品被投票",24),
	DELETE_INTEGRAL("线上活动奖励扣除","提交内容不符合规定被删除",25),
	OPERA_ANSWER("歌剧小知识问答","完善信息",26),
	NY_IMG("文化新年","成功参与",27),
	NY_VOTE("文化新年","作品被投票",28),
	COMMENT_SPECIAL("发言特别奖励","成功评论1次",29),
	SCENE_IMG("文化直播-我在现场","成功参与",30),
	SCENE_ORDER("文化直播-我在现场","额外奖励",31),
	
	LIVE_LIKE("文化直播点赞","文化直播点赞",32),
	LIVE_COMMENT("文化直播评论","文化直播中评论",33),
	LIVE_COMMENT_IMG("文化直播评论","文化直播中带图评论",34),
	LIVE_COMMENT_DELETE("文化直播评论","文化直播删除评论",35),
	
	CONTEST_QUIZ_TOPIC_COMPLETE("完成互动挑战","完成互动挑战",36),
	WALK_USER("我们的行走故事","首次参与",37),
	POEM_USER("每日诗品","完成答题",38),
	
	MUSIC_WP("音乐真善美","微评参与",39),
	
	MUSIC_ZW("音乐真善美","征文参与",40),
	
	MUSIC_DEL("音乐真善美","删除文章",41),
	
	CULTURE_CONTEST("2017传统文化知识大赛答题","参与",42),
	
	MOVIE_WP("电影真善美","微评参与",43),
	
	MOVIE_ZW("电影真善美","征文参与",44);
	
	
	
	
	private String name;
    private String description;
    private int index;

	
	IntegralTypeEnum(String name, String description, int index)
	{
		this.name=name;
		this.index=index;
		this.description=description;
	}
	
	/**
	 * 根据下标获取积分类型名称
	 * 
	 * @param index
	 * @return
	 */
	public static IntegralTypeEnum getIntegralType(int index)
	{
		if(index>0&&index<=values().length)
		{
			return IntegralTypeEnum.values()[index-1];
		}
		else 
			return null;
	}

	public String getName() {
		return name;
	}

	public String getDescription() {
		return description;
	}

	public int getIndex() {
		return index;
	}
	
	
}
