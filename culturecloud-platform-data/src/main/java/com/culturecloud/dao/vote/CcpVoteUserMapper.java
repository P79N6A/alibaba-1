package com.culturecloud.dao.vote;

import com.culturecloud.model.bean.vote.CcpVoteUser;

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
}