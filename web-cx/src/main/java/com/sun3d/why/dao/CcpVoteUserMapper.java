package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.culturecloud.model.bean.vote.CcpVoteUser;
import com.sun3d.why.model.CmsUserAnswer;

public interface CcpVoteUserMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_vote_user
     *
     * @mbggenerated Wed Nov 16 15:06:39 CST 2016
     */
    int deleteByPrimaryKey(String userId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_vote_user
     *
     * @mbggenerated Wed Nov 16 15:06:39 CST 2016
     */
    int insert(CcpVoteUser record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_vote_user
     *
     * @mbggenerated Wed Nov 16 15:06:39 CST 2016
     */
    int insertSelective(CcpVoteUser record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_vote_user
     *
     * @mbggenerated Wed Nov 16 15:06:39 CST 2016
     */
    CcpVoteUser selectByPrimaryKey(String userId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_vote_user
     *
     * @mbggenerated Wed Nov 16 15:06:39 CST 2016
     */
    int updateByPrimaryKeySelective(CcpVoteUser record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_vote_user
     *
     * @mbggenerated Wed Nov 16 15:06:39 CST 2016
     */
    int updateByPrimaryKey(CcpVoteUser record);

	int queryUserList(Map<String, Object> map);

	List<CcpVoteUser> queryUserMessage(Map<String, Object> map);

}