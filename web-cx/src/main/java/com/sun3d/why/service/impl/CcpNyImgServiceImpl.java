package com.sun3d.why.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.sun3d.why.dao.ccp.CcpNyImgMapper;
import com.sun3d.why.dao.ccp.CcpNyUserMapper;
import com.sun3d.why.dao.ccp.CcpNyVoteMapper;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.ccp.CcpNyImg;
import com.sun3d.why.model.ccp.CcpNyUser;
import com.sun3d.why.model.ccp.CcpNyVote;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpNyImgService;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.api.util.HttpResponseText;

@Service
@Transactional
public class CcpNyImgServiceImpl implements CcpNyImgService{
    
    @Resource
    private CcpNyImgMapper ccpNyImgMapper;
    @Resource
    private CcpNyUserMapper ccpNyUserMapper;
    @Resource
    private CcpNyVoteMapper ccpNyVoteMapper;
    @Autowired
    private CmsTerminalUserService terminalUserService;
    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;
    
    
	@Override
	public List<CcpNyImg> queryNyImgList(CcpNyImg vo) {
		List<CcpNyImg> list = ccpNyImgMapper.selectNyImgList(vo);
		//本人最高排名
		if(vo.getIsMe() == 1 && vo.getIsVoteSort() == 1){
			if(list.size()>0){
				CcpNyUser ccpNyUser = ccpNyUserMapper.selectByPrimaryKey(vo.getUserId());
				int ranking = ccpNyUserMapper.selectRankingByVoteCount(ccpNyUser.getUserMaxVote(), list.get(0).getCreateTime());
				list.get(0).setRanking(ranking);
			}
		}
		return list;
	}
	
	@Override
	public List<CcpNyImg> querySelectNyImgList(CcpNyImg vo) {
		List<CcpNyImg> list = new ArrayList<CcpNyImg>();
		if(vo.getNyImgIds()!=null){
			for(String nyImgId:vo.getNyImgIds().split(",")){
				CcpNyImg nyImgDto = new CcpNyImg();
				nyImgDto.setNyImgId(nyImgId);
				nyImgDto.setUserId(vo.getUserId());
				list.add(ccpNyImgMapper.selectNyImgList(nyImgDto).get(0));
			}
		}
		return list;
	}
	
	@Override
	public List<CcpNyUser> queryNyUserRanking() {
		return ccpNyUserMapper.queryNyUserRanking();
	}

	@Override
	public String addNyVote(CcpNyVote vo) {
		int todayVoteCount = ccpNyVoteMapper.queryTodayVoteCount(vo);
		if(todayVoteCount>0){
			return "repeat";
		}
		
		//添加积分
		CcpNyImg nyImgDto = ccpNyImgMapper.selectByPrimaryKey(vo.getNyImgId());
		
		UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
		userIntegralDetail.setIntegralChange(5);
		userIntegralDetail.setChangeType(0);
		userIntegralDetail.setIntegralFrom("文化新年作品被投票:"+vo.getNyImgId());
		userIntegralDetail.setIntegralType(IntegralTypeEnum.NY_VOTE.getIndex());
		userIntegralDetail.setUserId(nyImgDto.getUserId());
		userIntegralDetail.setUpdateType(0);
		HttpResponseText res = HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/updateIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
		JSONObject jsonObject = JSON.parseObject(res.getData());
		String status = jsonObject.get("status").toString();
		if(!status.equals("200")){
			return "500";
		}
		
		vo.setNyVoteId(UUIDUtils.createUUId());
		vo.setCreateTime(new Date());
		int count = ccpNyVoteMapper.insert(vo);
		if (count > 0) {
			//重新计算被投票用户的最高单作品投票
			String userId = nyImgDto.getUserId();
			nyImgDto = new CcpNyImg();
			nyImgDto.setUserId(userId);
			nyImgDto.setIsMe(1);
			nyImgDto.setIsVoteSort(1);
			List<CcpNyImg> list = ccpNyImgMapper.selectNyImgList(nyImgDto);
			if(list.size()>0){
				CcpNyUser nyUserDto = new CcpNyUser();
				nyUserDto.setUserId(userId);
				nyUserDto.setUserMaxVote(list.get(0).getVoteCount());
				nyUserDto.setUserMaxImg(list.get(0).getNyImgId());
				ccpNyUserMapper.update(nyUserDto);
			}
			return "200";
		}else{
			return "500";
		}
	}
	
	@Override
	public String addNyImg(CcpNyImg vo) {
		//添加积分
		CcpNyImg nyImgDto = new CcpNyImg();
		nyImgDto.setUserId(vo.getUserId());
		nyImgDto.setIsMe(1);
		List<CcpNyImg> nyImgList = ccpNyImgMapper.selectNyImgList(nyImgDto);
		if(nyImgList.size()==0){
			UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
			userIntegralDetail.setIntegralChange(500);
			userIntegralDetail.setChangeType(0);
			userIntegralDetail.setIntegralFrom("文化新年成功参与");
			userIntegralDetail.setIntegralType(IntegralTypeEnum.NY_IMG.getIndex());
			userIntegralDetail.setUserId(vo.getUserId());
			userIntegralDetail.setUpdateType(1);
			HttpResponseText res = HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/updateIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
			JSONObject jsonObject = JSON.parseObject(res.getData());
			String status = jsonObject.get("status").toString();
			if(!status.equals("200")){
				return "500";
			}
		}
		
		vo.setNyImgId(UUIDUtils.createUUId());
		vo.setCreateTime(new Date());
		int count = ccpNyImgMapper.insert(vo);
		if (count > 0) {
			if(nyImgList.size()==0){
				return "1";
			}else{
				return "200";
			}
		}else{
			return "500";
		}
	}

	@Override
	public String addNyUser(CcpNyUser vo) {
		JSONObject json=new JSONObject();
		json.put("userId", vo.getUserId());
		json.put("userNickName", vo.getUserName());
		json.put("userTelephone", vo.getUserMobile());
		HttpClientConnection.post(staticServer.getChinaServerUrl() + "wechatUser/editTerminalUserByJson.do", json);
		
		vo.setCreateTime(new Date());
		int count = ccpNyUserMapper.insert(vo);
		if (count > 0) {
			return "200";
		}else{
			return "500";
		}
	}
	
	@Override
	public CcpNyUser queryNyUser(String userId) {
		return ccpNyUserMapper.selectByPrimaryKey(userId);
	}

}
