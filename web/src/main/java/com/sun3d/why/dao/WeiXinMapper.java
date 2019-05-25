//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.weixin.WeiXin;
import com.sun3d.why.util.Pagination;


public interface WeiXinMapper {
	 /**
     * 保存自动回复信息
     * @param weiXin 自动回复对象
     * @return 0 失败, 1成功
     */
    int addWeiXin(WeiXin weiXin);

    /**
     * 修改自动回复信息
     * @param activity  自动回复对象
     * @return 0 失败, 1成功
     */
    int editWeiXin(WeiXin weiXin);
    /**
     * 根据传入的map查询活动列表信息
     * @param map  查询条件
     * @return 活动列表信息
     */
    public List<WeiXin> queryWeiXinByCondition(Map<String, Object> map);
    /**
     * 根据传入的map查询活动列表信息数量
     * @param map  查询条件
     * @return 活动列表信息
     */
	int queryWeiXinCountByCondition(Map<String, Object> map);
	/**
     * 根据传入的ID查询对应的信息
     * @param map  查询条件
     * @return 自动回复信息
     */

	WeiXin queryWeixinById(String weiXinId);
	/**
     * 保存修改的信息
     * @param map  查询条件
     * @return 自动回复信息
     */

	int editWeiXinById(WeiXin weiXin);
	/**
     * 获取自动回复信息
     * @param map  查询条件
     * @return 自动回复信息
     */
	WeiXin queryWeiXin();

}
