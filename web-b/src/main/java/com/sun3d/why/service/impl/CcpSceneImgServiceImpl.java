package com.sun3d.why.service.impl;

import java.util.ArrayList;
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
import com.sun3d.why.dao.CmsCulturalSquareMapper;
import com.sun3d.why.dao.ccp.CcpSceneImgMapper;
import com.sun3d.why.dao.ccp.CcpSceneUserMapper;
import com.sun3d.why.dao.ccp.CcpSceneVoteMapper;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.ccp.CcpSceneImg;
import com.sun3d.why.model.ccp.CcpSceneUser;
import com.sun3d.why.model.ccp.CcpSceneVote;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpSceneImgService;
import com.sun3d.why.util.Pagination;
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
	private CmsCulturalSquareMapper cmsCulturalSquareMapper;
    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;
    
    
    @Override
	public List<CcpSceneImg> querySceneImgByCondition(CcpSceneImg ccpSceneImg, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (StringUtils.isNotBlank(ccpSceneImg.getUserName())) {
			map.put("userName", "%"+ccpSceneImg.getUserName()+"%");
		}
		if (StringUtils.isNotBlank(ccpSceneImg.getSceneImgContent())) {
			map.put("sceneImgContent", "%"+ccpSceneImg.getSceneImgContent()+"%");
		}
		if (StringUtils.isNotBlank(ccpSceneImg.getUserMobile())){
			map.put("userMobile", "%"+ccpSceneImg.getUserMobile()+"%");
		}
		if(ccpSceneImg.getSceneStatus()!=null){
			map.put("sceneStatus", ccpSceneImg.getSceneStatus());
		}
		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = ccpSceneImgMapper.querySceneImgCountByCondition(map);
			// 设置分页的总条数来获取总页数
			page.setTotal(total);
		}
		return ccpSceneImgMapper.querySceneImgByCondition(map);
	}


	@Override
	public String deleteSceneImg(String sceneImgId) {
		CcpSceneImg ccpSceneImg = ccpSceneImgMapper.selectByPrimaryKey(sceneImgId);
		
		int count = ccpSceneImgMapper.deleteByPrimaryKey(sceneImgId);
		if (count > 0) {
			//删除广场信息
        	cmsCulturalSquareMapper.deleteByOutId(sceneImgId);
			//扣除积分
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("userId", ccpSceneImg.getUserId());
			List<CcpSceneImg> sceneImgList = ccpSceneImgMapper.querySceneImgByCondition(map);
			if(sceneImgList.size()==0){
				UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
				userIntegralDetail.setIntegralChange(100);
				userIntegralDetail.setIntegralFrom("文化直播-我在现场成功参与");
				userIntegralDetail.setIntegralType(IntegralTypeEnum.SCENE_IMG.getIndex());
				userIntegralDetail.setUserId(ccpSceneImg.getUserId());
				userIntegralDetail.setUpdateType(1);
				HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/deteleIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
			}
			
			//删除投票
			CcpSceneVote sceneVoteDto = new CcpSceneVote();
			sceneVoteDto.setSceneImgId(sceneImgId);
			ccpSceneVoteMapper.deleteByCondition(sceneVoteDto);
			
			//重新计算被投票用户的最高单作品投票
			CcpSceneImg sceneImgDto = new CcpSceneImg();
			sceneImgDto.setUserId(ccpSceneImg.getUserId());
			sceneImgDto.setIsMe(1);
			sceneImgDto.setIsVoteSort(1);
			List<CcpSceneImg> list = ccpSceneImgMapper.selectSceneImgList(sceneImgDto);
			if(list.size()>0){
				CcpSceneUser sceneUserDto = new CcpSceneUser();
				sceneUserDto.setUserId(ccpSceneImg.getUserId());
				sceneUserDto.setUserMaxVote(list.get(0).getVoteCount());
				sceneUserDto.setUserMaxImg(list.get(0).getSceneImgId());
				ccpSceneUserMapper.update(sceneUserDto);
			}else{
				//清空
				CcpSceneUser sceneUserDto = new CcpSceneUser();
				sceneUserDto.setUserId(ccpSceneImg.getUserId());
				sceneUserDto.setUserMaxVote(0);
				sceneUserDto.setUserMaxImg("0");
				ccpSceneUserMapper.update(sceneUserDto);
			}
			return "200";
		}else{
			return "500";
		}
	}


	@Override
	public CcpSceneImg querySceneImgById(String sceneImgId) {
		return ccpSceneImgMapper.selectByPrimaryKey(sceneImgId);
	}

	@Override
	public int update(CcpSceneImg ccpSceneImg) {
		return ccpSceneImgMapper.update(ccpSceneImg);
	}

}
