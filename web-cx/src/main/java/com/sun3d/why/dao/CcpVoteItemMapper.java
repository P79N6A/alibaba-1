package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.culturecloud.model.bean.vote.CcpVoteItem;
import com.sun3d.why.dao.dto.CcpVoteItemDto;

public interface CcpVoteItemMapper {
	
	int queryVoteItemCountByCondition(Map<String,Object>map);
	
	
	List<CcpVoteItemDto>queryVoteItemByCondition(Map<String,Object>map);
	
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_vote_item
     *
     * @mbggenerated Mon Nov 07 23:15:46 CST 2016
     */
    int deleteByPrimaryKey(String voteItemId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_vote_item
     *
     * @mbggenerated Mon Nov 07 23:15:46 CST 2016
     */
    int insert(CcpVoteItem record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_vote_item
     *
     * @mbggenerated Mon Nov 07 23:15:46 CST 2016
     */
    int insertSelective(CcpVoteItem record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_vote_item
     *
     * @mbggenerated Mon Nov 07 23:15:46 CST 2016
     */
    CcpVoteItem selectByPrimaryKey(String voteItemId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_vote_item
     *
     * @mbggenerated Mon Nov 07 23:15:46 CST 2016
     */
    int updateByPrimaryKeySelective(CcpVoteItem record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_vote_item
     *
     * @mbggenerated Mon Nov 07 23:15:46 CST 2016
     */
    int updateByPrimaryKey(CcpVoteItem record);
}