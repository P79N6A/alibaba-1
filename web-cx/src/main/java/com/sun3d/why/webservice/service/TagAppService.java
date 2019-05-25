package com.sun3d.why.webservice.service;

import com.sun3d.why.model.CmsTag;
import com.sun3d.why.model.CmsUserTag;

import java.util.List;


public interface TagAppService {

  /**
   * app根据标签id查询标签
   * @param tagId
   * @return
   */
  public CmsTag queryAppTagByTagId(String tagId);

  /**
   * app获取展馆与活动标签列表
   * @param type1 活动类型
   * @param type2  展馆类型
   * @return
   */
  public String queryActivityVenueTagsByType(int type1, int type2);

  /**
   * app获取活动标签列表
   * @param tagMood 活动心情标签
   * @param tagTheme 活动主题与展馆类型标签
   * @param tagCrowd 活动与展馆人群标签
   * @return
   */
     public String queryCmsActivityTagByCondition(String tagMood,String tagTheme,String tagCrowd);

  /**
   * app用户选择喜欢标签
   * @param cmsUsertag
   * @return
   */
     public String addUserTags(CmsUserTag cmsUsertag);
    /**
     * app获取热门搜索
     *
     * @return
     */
    public String activityHot();
    /**
     * app获取热门搜索
     *
     * @return
     */
    public String venueHot();
}
