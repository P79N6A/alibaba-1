package com.sun3d.why.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.sun3d.why.dao.CmsActivityOrderMapper;
import com.sun3d.why.dao.ccp.CcpSceneImgMapper;
import com.sun3d.why.dao.ccp.CcpSceneUserMapper;
import com.sun3d.why.dao.ccp.CcpSceneVoteMapper;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.ccp.CcpSceneImg;
import com.sun3d.why.model.ccp.CcpSceneUser;
import com.sun3d.why.model.ccp.CcpSceneVote;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpSceneImgService;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.api.util.HttpResponseText;

@Service
@Transactional
public class CcpSceneImgServiceImpl implements CcpSceneImgService{
    
    @Resource
    private CcpSceneImgMapper ccpSceneImgMapper;
    @Resource
    private CcpSceneUserMapper ccpSceneUserMapper;
    @Resource
    private CcpSceneVoteMapper ccpSceneVoteMapper;
    @Autowired
    private CmsTerminalUserService terminalUserService;
    @Autowired
    private CmsActivityOrderMapper cmsActivityOrderMapper;
    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;
    
    
	@Override
	public List<CcpSceneImg> querySceneImgList(CcpSceneImg vo) {
		List<CcpSceneImg> list = ccpSceneImgMapper.selectSceneImgList(vo);
		//本人最高排名
		if(vo.getIsMe() == 1 && vo.getIsVoteSort() == 1 && vo.getIsMonth() == 1){
			if(list.size()>0){
				int ranking = ccpSceneUserMapper.selectRankingByVoteCount(list.get(0).getVoteCount(), list.get(0).getCreateTime());
				list.get(0).setRanking(ranking);
			}
		}
		return list;
	}
	
	@Override
	public List<CcpSceneImg> querySelectSceneImgList(CcpSceneImg vo) {
		List<CcpSceneImg> list = new ArrayList<CcpSceneImg>();
		if(vo.getSceneImgIds()!=null){
			for(String sceneImgId:vo.getSceneImgIds().split(",")){
				CcpSceneImg sceneImgDto = new CcpSceneImg();
				sceneImgDto.setSceneImgId(sceneImgId);
				sceneImgDto.setSceneStatus(vo.getSceneStatus());
				sceneImgDto.setUserId(vo.getUserId());
				list.add(ccpSceneImgMapper.selectSceneImgList(sceneImgDto).get(0));
			}
		}
		return list;
	}
	
	@Override
	public List<CcpSceneUser> querySceneUserRanking() {
		return ccpSceneUserMapper.querySceneUserRanking();
	}

	@Override
	public String addSceneVote(CcpSceneVote vo) {
		int todayVoteCount = ccpSceneVoteMapper.queryTodayVoteCount(vo);
		if(todayVoteCount>0){
			return "repeat";
		}
		
		vo.setSceneVoteId(UUIDUtils.createUUId());
		vo.setCreateTime(new Date());
		int count = ccpSceneVoteMapper.insert(vo);
		if (count > 0) {
			//重新计算被投票用户的最高单作品投票
			CcpSceneImg sceneImgDto = ccpSceneImgMapper.selectByPrimaryKey(vo.getSceneImgId());
			String userId = sceneImgDto.getUserId();
			sceneImgDto = new CcpSceneImg();
			sceneImgDto.setUserId(userId);
			sceneImgDto.setIsMe(1);
			sceneImgDto.setIsVoteSort(1);
			List<CcpSceneImg> list = ccpSceneImgMapper.selectSceneImgList(sceneImgDto);
			if(list.size()>0){
				CcpSceneUser sceneUserDto = new CcpSceneUser();
				sceneUserDto.setUserId(userId);
				sceneUserDto.setUserMaxVote(list.get(0).getVoteCount());
				sceneUserDto.setUserMaxImg(list.get(0).getSceneImgId());
				ccpSceneUserMapper.update(sceneUserDto);
			}
			return "200";
		}else{
			return "500";
		}
	}
	
	@Override
	public String addSceneImg(CcpSceneImg vo) {
		String result = "200";
		//添加积分
		CcpSceneImg sceneImgDto = new CcpSceneImg();
		sceneImgDto.setUserId(vo.getUserId());
		sceneImgDto.setIsMe(1);
		List<CcpSceneImg> sceneImgList = ccpSceneImgMapper.selectSceneImgList(sceneImgDto);
		if(sceneImgList.size()==0){	//首次积分
			UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
			userIntegralDetail.setIntegralChange(100);
			userIntegralDetail.setChangeType(0);
			userIntegralDetail.setIntegralFrom("文化直播-我在现场成功参与");
			userIntegralDetail.setIntegralType(IntegralTypeEnum.SCENE_IMG.getIndex());
			userIntegralDetail.setUserId(vo.getUserId());
			userIntegralDetail.setUpdateType(1);
			HttpResponseText res = HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/updateIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
			JSONObject jsonObject = JSON.parseObject(res.getData());
			String status = jsonObject.get("status").toString();
			if(!status.equals("200")){
				return "500";
			}else{
				result = "1";
			}
		}
		
		//额外积分
		JSONObject voJson=new JSONObject();
    	voJson.put("userId", vo.getUserId());
		HttpResponseText res = HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/querySceneMonthIntegralByJson.do", voJson);
		JSONObject jsonObject = JSON.parseObject(res.getData());
		if(jsonObject.get("status").toString().equals("200") && Integer.parseInt(jsonObject.get("data").toString())<10){	//每月最多10次
			if(!vo.getSceneImgVenueId().equals("0")){	
				CcpSceneUser ccpSceneUser = querySceneUser(vo.getUserId());
				String[] userIntegralActivity = new String[]{};
				if(StringUtils.isNotBlank(ccpSceneUser.getUserIntegralActivity())){
					userIntegralActivity = ccpSceneUser.getUserIntegralActivity().split(",");
				}
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("userId", vo.getUserId());
				map.put("dateType", 1);
				map.put("sortType", 3);
				List<CmsActivityOrder> list = cmsActivityOrderMapper.queryNoCancelActivityOrder(map);
				for(int i=0;i<list.size();i++){
					if(list.get(i).getVenueId().equals(vo.getSceneImgVenueId()) && !Arrays.asList(userIntegralActivity).contains(list.get(i).getActivityOrderId())){
						UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
						userIntegralDetail.setIntegralChange(100);
						userIntegralDetail.setChangeType(0);
						userIntegralDetail.setIntegralFrom("文化直播-我在现场额外奖励activityOrderId："+list.get(i).getActivityOrderId());
						userIntegralDetail.setIntegralType(IntegralTypeEnum.SCENE_ORDER.getIndex());
						userIntegralDetail.setUserId(vo.getUserId());
						userIntegralDetail.setUpdateType(1);
						res = HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/updateIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
						jsonObject = JSON.parseObject(res.getData());
						String status = jsonObject.get("status").toString();
						if(!status.equals("200")){
							return "500";
						}else{
							CcpSceneUser sceneUserDto = new CcpSceneUser();
							sceneUserDto.setUserId(vo.getUserId());
							if(StringUtils.isNotBlank(ccpSceneUser.getUserIntegralActivity())){
								sceneUserDto.setUserIntegralActivity(ccpSceneUser.getUserIntegralActivity() + "," + list.get(i).getActivityOrderId());
							}else{
								sceneUserDto.setUserIntegralActivity(list.get(i).getActivityOrderId());
							}
							ccpSceneUserMapper.update(sceneUserDto);
							if(result.equals("1")){
								result = "2";
							}else{
								result = "1";
							}
							break;
						}
					}
				}
			}
		}
		
		vo.setSceneImgId(UUIDUtils.createUUId());
		vo.setCreateTime(new Date());
		int count = ccpSceneImgMapper.insert(vo);
		if (count > 0) {
			return result;
		}else{
			return "500";
		}
	}

	@Override
	public String addSceneUser(CcpSceneUser vo) {
		JSONObject json=new JSONObject();
		json.put("userId", vo.getUserId());
		json.put("userNickName", vo.getUserName());
		json.put("userTelephone", vo.getUserMobile());
		HttpClientConnection.post(staticServer.getChinaServerUrl() + "wechatUser/editTerminalUserByJson.do", json);
		
		vo.setCreateTime(new Date());
		int count = ccpSceneUserMapper.insert(vo);
		if (count > 0) {
			return "200";
		}else{
			return "500";
		}
	}
	
	@Override
	public CcpSceneUser querySceneUser(String userId) {
		return ccpSceneUserMapper.selectByPrimaryKey(userId);
	}

}
