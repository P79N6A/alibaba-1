package com.sun3d.why.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.sun3d.why.dao.CmsCulturalSquareMapper;
import com.sun3d.why.dao.ccp.CcpWalkImgMapper;
import com.sun3d.why.dao.ccp.CcpWalkUserMapper;
import com.sun3d.why.dao.ccp.CcpWalkVoteMapper;
import com.sun3d.why.model.CmsCulturalSquare;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.ccp.CcpWalkImg;
import com.sun3d.why.model.ccp.CcpWalkUser;
import com.sun3d.why.model.ccp.CcpWalkVote;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpWalkImgService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpClientConnection;

@Service
@Transactional
public class CcpWalkImgServiceImpl implements CcpWalkImgService{
    
    @Resource
    private CcpWalkImgMapper ccpWalkImgMapper;
    @Resource
    private CcpWalkUserMapper ccpWalkUserMapper;
    @Resource
    private CcpWalkVoteMapper ccpWalkVoteMapper;
    @Autowired
	private CmsCulturalSquareMapper cmsCulturalSquareMapper;
    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;
    
    
    @Override
	public List<CcpWalkImg> queryWalkImgByCondition(CcpWalkImg ccpWalkImg, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (StringUtils.isNotBlank(ccpWalkImg.getWalkImgId())) {
			map.put("walkImgId", ccpWalkImg.getWalkImgId());
		}
		if (StringUtils.isNotBlank(ccpWalkImg.getUserName())) {
			map.put("userName", "%"+ccpWalkImg.getUserName()+"%");
		}
		if (StringUtils.isNotBlank(ccpWalkImg.getWalkImgContent())) {
			map.put("walkImgContent", "%"+ccpWalkImg.getWalkImgContent()+"%");
		}
		if (StringUtils.isNotBlank(ccpWalkImg.getUserMobile())){
			map.put("userMobile", "%"+ccpWalkImg.getUserMobile()+"%");
		}
		if (ccpWalkImg.getWalkStatus()!=null){
			map.put("walkStatus",ccpWalkImg.getWalkStatus());
		}
		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = ccpWalkImgMapper.queryWalkImgCountByCondition(map);
			// 设置分页的总条数来获取总页数
			page.setTotal(total);
		}
		return ccpWalkImgMapper.queryWalkImgByCondition(map);
	}


	@Override
	public String deleteWalkImg(String walkImgId, String walkImgUrls) {
		CcpWalkImg ccpWalkImg = ccpWalkImgMapper.selectByPrimaryKey(walkImgId);
		
		int count = 0;
		if(walkImgUrls.equals("")){	//删除作品
			count = ccpWalkImgMapper.deleteByPrimaryKey(walkImgId);
			//删除广场信息
	    	cmsCulturalSquareMapper.deleteByOutId(walkImgId);
			
			//扣除积分
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("userId", ccpWalkImg.getUserId());
			List<CcpWalkImg> walkImgList = ccpWalkImgMapper.queryWalkImgByCondition(map);
			if (walkImgList.size() == 0) {
				//扣除积分
				UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
				userIntegralDetail.setIntegralChange(500);
				userIntegralDetail.setIntegralFrom("行走故事首次参与");
				userIntegralDetail.setIntegralType(IntegralTypeEnum.WALK_USER.getIndex());
				userIntegralDetail.setUserId(ccpWalkImg.getUserId());
				userIntegralDetail.setUpdateType(1);
				HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/deteleIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
			}
			
			//删除投票
			CcpWalkVote walkVoteDto = new CcpWalkVote();
			walkVoteDto.setWalkImgId(walkImgId);
			ccpWalkVoteMapper.deleteByCondition(walkVoteDto);
			
			//重新计算被投票用户的最高单作品投票
			CcpWalkImg walkImgDto = new CcpWalkImg();
			walkImgDto.setUserId(ccpWalkImg.getUserId());
			walkImgDto.setIsMe(1);
			walkImgDto.setIsVoteSort(1);
			List<CcpWalkImg> list = ccpWalkImgMapper.selectWalkImgList(walkImgDto);
			if(list.size()>0){
				CcpWalkUser walkUserDto = new CcpWalkUser();
				walkUserDto.setUserId(ccpWalkImg.getUserId());
				walkUserDto.setUserMaxVote(list.get(0).getVoteCount());
				walkUserDto.setUserMaxImg(list.get(0).getWalkImgId());
				ccpWalkUserMapper.update(walkUserDto);
			}else{
				//清空
				CcpWalkUser walkUserDto = new CcpWalkUser();
				walkUserDto.setUserId(ccpWalkImg.getUserId());
				walkUserDto.setUserMaxVote(0);
				walkUserDto.setUserMaxImg("0");
				ccpWalkUserMapper.update(walkUserDto);
			}
		}else{		//修改作品
			ccpWalkImg.setWalkImgUrl(walkImgUrls);
			count = ccpWalkImgMapper.update(ccpWalkImg);
			
			//修改广场信息
			Map<String, Object> culturalSquareMap=new HashMap<String, Object>();
			culturalSquareMap.put("outId", walkImgId);
			List<CmsCulturalSquare> CulturalSquareList = cmsCulturalSquareMapper.queryCulturalSquareByCondition(culturalSquareMap);
			if(CulturalSquareList.size()>0){
				CmsCulturalSquare cmsCulturalSquare = CulturalSquareList.get(0);
				cmsCulturalSquare.setExt0(walkImgUrls);
				cmsCulturalSquareMapper.update(cmsCulturalSquare);
			}
		}
		
		if (count > 0) {
			return "200";
		}else{
			return "500";
		}
	}


	@Override
	public CcpWalkImg queryWalkImgById(String id) {
		return ccpWalkImgMapper.selectByPrimaryKey(id);
	}

	@Override
	public int update(CcpWalkImg ccpWalkImg) {
		return ccpWalkImgMapper.update(ccpWalkImg);
	}


	@Override
	public String brushWalkVote(String walkImgId, Integer count) {
		if(StringUtils.isNotBlank(walkImgId) && count != null){
			try {
				List<CcpWalkVote> votelist = new ArrayList<CcpWalkVote>(); 
				for(int i=0;i<count;i++){
					CcpWalkVote vo = new CcpWalkVote();
					vo.setWalkVoteId(UUIDUtils.createUUId());
					vo.setWalkImgId(walkImgId);
					vo.setUserId("0");
					vo.setCreateTime(new Date());
					votelist.add(vo);
				}
				int result = ccpWalkVoteMapper.brushWalkVote(votelist);
				if(result>0){
					//重新计算被投票用户的最高单作品投票
					String userId = ccpWalkImgMapper.selectByPrimaryKey(walkImgId).getUserId();
					CcpWalkImg walkImgDto = new CcpWalkImg();
					walkImgDto.setUserId(userId);
					walkImgDto.setIsMe(1);
					walkImgDto.setIsVoteSort(1);
					List<CcpWalkImg> list = ccpWalkImgMapper.selectWalkImgList(walkImgDto);
					if(list.size()>0){
						CcpWalkUser walkUserDto = new CcpWalkUser();
						walkUserDto.setUserId(userId);
						walkUserDto.setUserMaxVote(list.get(0).getVoteCount());
						walkUserDto.setUserMaxImg(list.get(0).getWalkImgId());
						ccpWalkUserMapper.update(walkUserDto);
					}else{
						//清空
						CcpWalkUser walkUserDto = new CcpWalkUser();
						walkUserDto.setUserId(userId);
						walkUserDto.setUserMaxVote(0);
						walkUserDto.setUserMaxImg("0");
						ccpWalkUserMapper.update(walkUserDto);
					}
					return "200";
				}else{
					return "500";
				}
			} catch (Exception e) {
				e.printStackTrace();
				return "500";
			}
		}else{
			return "500";
		}
	}

}
