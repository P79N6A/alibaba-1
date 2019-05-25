package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.weixin.WeiXin;
import com.sun3d.why.util.Pagination;

public interface WeiXinService {
	/**
	 * 后端微信自动回复管理列表
	 * @param WeiXin
	 * @param page
	 * @return 场馆对象集合
	 */
	List<WeiXin> queryWeiXinByCondition(WeiXin weiXin,Pagination page);
	
	/**
	 * 根据id查询自助回复信息
	 * @return
	 */
	WeiXin queryWeixinById(String weiXinId);
	
	/**
	 * 根据id更新自助回复信息
	 * @return
	 */
	int editWeiXinById(WeiXin weiXin);
	
	/**
	 * 获取自动回复信息
	 * @return
	 */
	WeiXin queryWeiXin();

	/**
	 * 获取微信用户信息
	 * @param code
	 * @return
	 */
	CmsTerminalUser queryWechatUserInfo(String code);
}

