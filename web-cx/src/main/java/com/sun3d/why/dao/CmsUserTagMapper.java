package com.sun3d.why.dao;
import com.sun3d.why.model.CmsUserTag;
import com.sun3d.why.model.CmsUserTag;

import java.util.List;

public interface CmsUserTagMapper {


    int deleteByPrimaryKey(String tagId);

    int insert(CmsUserTag record);

    int insertSelective(CmsUserTag record);

    CmsUserTag selectByPrimaryKey(String tagId);

    int updateByPrimaryKeySelective(CmsUserTag record);

    int updateByPrimaryKey(CmsUserTag record);

    /**
     * app查询该用户是否选择喜欢标签
     * @param userId 用户id
     * @return
     */
    public int queryAppUserTagCount(String userId);

    /**
     * app删除用户选择喜欢标签
     * @param userId 用户id
     * @return
     */
    public int deleteAppUserListTagsById(String userId);

    /**
     * app添加用户习惯标签
     * @param userTagList 用户喜欢标签list
     * @return
     */
    public int addUserTags(List<CmsUserTag> userTagList);

    /**
     * app查询用户选择喜欢标签列表
     * @param userId 用户id
     * @return
     */
    public List<CmsUserTag> queryActivityUserTagListById(String userId);
}