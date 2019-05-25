package com.sun3d.why.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sun3d.why.dao.CmsCulturalSquareMapper;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
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
import com.sun3d.why.util.Pagination;
import com.sun3d.why.webservice.api.util.HttpClientConnection;

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
    private HttpSession session;
    @Autowired
    private CmsCulturalSquareMapper cmsCulturalSquareMapper;
    @Autowired
    private StaticServer staticServer;
    
    
    @Override
	public List<CcpNyImg> queryNyImgByCondition(CcpNyImg ccpNyImg, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (StringUtils.isNotBlank(ccpNyImg.getUserName())) {
			map.put("userName", "%"+ccpNyImg.getUserName()+"%");
		}
		if (StringUtils.isNotBlank(ccpNyImg.getNyImgContent())) {
			map.put("nyImgContent", "%"+ccpNyImg.getNyImgContent()+"%");
		}
		if(ccpNyImg.getNyStatus() != null){
			map.put("nyStatus", ccpNyImg.getNyStatus());
		}
		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = ccpNyImgMapper.queryNyImgCountByCondition(map);
			// 设置分页的总条数来获取总页数
			page.setTotal(total);
		}
		return ccpNyImgMapper.queryNyImgByCondition(map);
	}


	@Override
	public String deleteNyImg(String nyImgId) {
		CcpNyImg ccpNyImg = ccpNyImgMapper.selectByPrimaryKey(nyImgId);
		
		int count = ccpNyImgMapper.deleteByPrimaryKey(nyImgId);
		if (count > 0) {
			//删除广场信息
        	cmsCulturalSquareMapper.deleteByOutId(nyImgId);
			//扣除积分
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("userId", ccpNyImg.getUserId());
			List<CcpNyImg> nyImgList = ccpNyImgMapper.queryNyImgByCondition(map);
			if(nyImgList.size()==0){
				UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
				userIntegralDetail.setIntegralChange(500);
				userIntegralDetail.setIntegralFrom("文化新年成功参与");
				userIntegralDetail.setIntegralType(IntegralTypeEnum.NY_IMG.getIndex());
				userIntegralDetail.setUserId(ccpNyImg.getUserId());
				userIntegralDetail.setUpdateType(1);
				HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/deteleIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
			}
			
			//删除投票
			CcpNyVote nyVoteDto = new CcpNyVote();
			nyVoteDto.setNyImgId(nyImgId);
			int count2 = ccpNyVoteMapper.deleteByCondition(nyVoteDto);
			if (count2 > 0) {
				UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
				userIntegralDetail.setIntegralChange(5*count2);
				userIntegralDetail.setIntegralFrom("文化新年作品被投票:"+ccpNyImg.getNyImgId());
				userIntegralDetail.setIntegralType(IntegralTypeEnum.NY_VOTE.getIndex());
				userIntegralDetail.setUserId(ccpNyImg.getUserId());
				userIntegralDetail.setUpdateType(0);
				HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/deteleIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
			}
			
			//重新计算被投票用户的最高单作品投票
			CcpNyImg nyImgDto = new CcpNyImg();
			nyImgDto.setUserId(ccpNyImg.getUserId());
			nyImgDto.setIsMe(1);
			nyImgDto.setIsVoteSort(1);
			List<CcpNyImg> list = ccpNyImgMapper.selectNyImgList(nyImgDto);
			if(list.size()>0){
				CcpNyUser nyUserDto = new CcpNyUser();
				nyUserDto.setUserId(ccpNyImg.getUserId());
				nyUserDto.setUserMaxVote(list.get(0).getVoteCount());
				nyUserDto.setUserMaxImg(list.get(0).getNyImgId());
				ccpNyUserMapper.update(nyUserDto);
			}else{
				//清空
				CcpNyUser nyUserDto = new CcpNyUser();
				nyUserDto.setUserId(ccpNyImg.getUserId());
				nyUserDto.setUserMaxVote(0);
				nyUserDto.setUserMaxImg("0");
				ccpNyUserMapper.update(nyUserDto);
			}
			return "200";
		}else{
			return "500";
		}
	}


	@Override
	public int update(CcpNyImg ccpNyImg) {
		return ccpNyImgMapper.update(ccpNyImg) ;
	}


	@Override
	public CcpNyImg queryByNyImgId(String id) {
		return ccpNyImgMapper.selectByPrimaryKey(id);
	}

}
