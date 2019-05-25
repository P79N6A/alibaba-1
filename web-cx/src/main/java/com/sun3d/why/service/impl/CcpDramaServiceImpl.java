package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.sun3d.why.dao.UserIntegralDetailMapper;
import com.sun3d.why.dao.UserIntegralMapper;
import com.sun3d.why.dao.ccp.CcpDramaCommentMapper;
import com.sun3d.why.dao.ccp.CcpDramaMapper;
import com.sun3d.why.dao.ccp.CcpDramaUserMapper;
import com.sun3d.why.dao.ccp.CcpDramaVoteMapper;
import com.sun3d.why.model.UserIntegral;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.ccp.CcpDrama;
import com.sun3d.why.model.ccp.CcpDramaComment;
import com.sun3d.why.model.ccp.CcpDramaUser;
import com.sun3d.why.model.ccp.CcpDramaVote;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpDramaService;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.service.UserIntegralService;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.api.util.HttpResponseText;

@Service
@Transactional
public class CcpDramaServiceImpl implements CcpDramaService {
    @Autowired
    private CcpDramaMapper ccpDramaMapper;
    @Autowired
    private CcpDramaUserMapper ccpDramaUserMapper;
    @Autowired
    private CcpDramaVoteMapper ccpDramaVoteMapper;
    @Autowired
    private CcpDramaCommentMapper ccpDramaCommentMapper;
    @Autowired
    private StaticServer staticServer;

    /**
     * 戏剧列表
     */
	@Override
	public List<CcpDrama> queryCcpDramalist(CcpDrama vo) {
		return ccpDramaMapper.queryCcpDramalist(vo);
	}
	
	/**
	 * 评论列表
	 */
	@Override
	public List<CcpDramaComment> queryCcpDramaCommentlist(CcpDramaComment vo) {
		return ccpDramaCommentMapper.queryCcpDramaCommentlist(vo);
	}

	/**
	 * 投票
	 */
	@Override
	public String addDramaVote(CcpDramaVote vo) {
		String result; 
		try {
			int todayVoteCount = ccpDramaVoteMapper.queryTodayVoteCount(vo);
			if(todayVoteCount>0){
				return result = "repeat";
			}
			vo.setDramaVoteId(UUIDUtils.createUUId());
			vo.setCreateTime(new Date());
			int count = ccpDramaVoteMapper.insert(vo);
			if (count > 0) {
				result = "200";
			}else{
				result = "500";
			}
		} catch (Exception e) {
			e.printStackTrace();
			result = "500";
		}
		return result;
	}

	/**
	 * 填写个人信息
	 */
	@Override
	public String addDramaUser(CcpDramaUser vo) {
		String result; 
		try {
			vo.setCreateTime(new Date());
			int count = ccpDramaUserMapper.insert(vo);
			if (count > 0) {
				result = "200";
			}else{
				result = "500";
			}
		} catch (Exception e) {
			e.printStackTrace();
			result = "500";
		}
		return result;
	}

	/**
	 * 评论
	 */
	@Override
	@Transactional(isolation=Isolation.SERIALIZABLE)
	public String addDramaComment(CcpDramaComment vo) {
		//添加积分
		UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
		userIntegralDetail.setIntegralChange(200);
		userIntegralDetail.setChangeType(0);
		userIntegralDetail.setIntegralFrom("上海当代艺术节提交剧评获积分");
		userIntegralDetail.setIntegralType(IntegralTypeEnum.DRAMA.getIndex());
		userIntegralDetail.setUserId(vo.getUserId());
		userIntegralDetail.setUpdateType(1);
		HttpResponseText res = HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/updateIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
		JSONObject jsonObject = JSON.parseObject(res.getData());
		String status = jsonObject.get("status").toString();
		if(!status.equals("200")){
			return "500";
		}
		
		//添加评论
		vo.setDramaCommentId(UUIDUtils.createUUId());
		vo.setDramaStatus(0);
		vo.setCreateTime(new Date());
		int count = ccpDramaCommentMapper.insert(vo);
		if (count > 0) {
			return "200";
		}else{
			return "500";
		}
	}
	
	/**
	 * 查询个人信息
	 */
	@Override
	public CcpDramaUser queryCcpDramaUser(String userId) {
		return ccpDramaUserMapper.selectByPrimaryKey(userId);
	}

}
