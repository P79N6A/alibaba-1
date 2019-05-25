package com.sun3d.why.redis.vo;

import java.io.Serializable;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * 用户积分信息 缓存 模型对象
 * 
 * @author zhangshun
 *
 */
public class UserIntergralRedisVO implements Serializable{

	private static final long serialVersionUID = -7616816070271604174L;

	// 访问日期 格式 yyyyMMdd
	Set<String> accessDateSet=new HashSet<>();
	
	// 转发缓存记录 
	//key 日期 格式 yyyyMMdd value 转发URL set 
	Map<String,Set<String>> forwardDateMap=new HashMap<String,Set<String>>();
	
	// 积分评论记录
	//key 日期 格式 yyyyMMdd value 今日积分 set 
	Map<String,Integer> commentDateMap=new HashMap<String,Integer>();
	

	public Set<String> getAccessDateSet() {
		return accessDateSet;
	}

	public void setAccessDateSet(Set<String> accessDateSet) {
		this.accessDateSet = accessDateSet;
	}

	public Map<String, Set<String>> getForwardDateMap() {
		return forwardDateMap;
	}

	public void setForwardDateMap(Map<String, Set<String>> forwardDateMap) {
		this.forwardDateMap = forwardDateMap;
	}

	public Map<String, Integer> getCommentDateMap() {
		return commentDateMap;
	}

	public void setCommentDateMap(Map<String, Integer> commentDateMap) {
		this.commentDateMap = commentDateMap;
	}
	
	
	
	
}
