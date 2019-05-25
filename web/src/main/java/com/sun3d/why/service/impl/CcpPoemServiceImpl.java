package com.sun3d.why.service.impl;

import java.text.SimpleDateFormat;
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
import com.sun3d.why.dao.ccp.CcpPoemLectorMapper;
import com.sun3d.why.dao.ccp.CcpPoemMapper;
import com.sun3d.why.dao.ccp.CcpPoemUserMapper;
import com.sun3d.why.dao.dto.CmsCulturalSquareDto;
import com.sun3d.why.model.SquareWhiter;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.ccp.CcpPoem;
import com.sun3d.why.model.ccp.CcpPoemLector;
import com.sun3d.why.model.ccp.CcpPoemUser;
import com.sun3d.why.model.ccp.CcpWalkImg;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpPoemService;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.api.util.HttpResponseText;

@Service
@Transactional
public class CcpPoemServiceImpl implements CcpPoemService{
    
    @Resource
    private CcpPoemMapper ccpPoemMapper;
    @Resource
    private CcpPoemLectorMapper ccpPoemLectorMapper;
    @Resource
    private CcpPoemUserMapper ccpPoemUserMapper;
    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;

	@Override
	public List<CcpPoem> queryPoemByCondition(CcpPoem ccpPoem) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (StringUtils.isNotBlank(ccpPoem.getPoemId())) {
			map.put("poemId", ccpPoem.getPoemId());
		}
		if (StringUtils.isNotBlank(ccpPoem.getUserId())) {
			map.put("userId", ccpPoem.getUserId());
		}
		if (StringUtils.isNotBlank(ccpPoem.getPoemDate())) {
			map.put("poemDate", ccpPoem.getPoemDate()+"%");
		}
		List<CcpPoem> list = ccpPoemMapper.queryPoemByCondition(map);
		
		//查询用户已完成的题目总数
		if(list.size()>0 && ccpPoem.getSelectCompleteCount()==1){
			list.get(0).setPoemCompleteCount(ccpPoemUserMapper.selectPoemUserList(new CcpPoemUser(ccpPoem.getUserId())).size());
		}else if(list.size()==0 && ccpPoem.getSelectCompleteCount()==1){	//未查到每日一诗时
			list.add(new CcpPoem(ccpPoemUserMapper.selectPoemUserList(new CcpPoemUser(ccpPoem.getUserId())).size()));
		}
		return list;
	}

	@Override
	public String addPoemUser(CcpPoemUser vo) {
		try {
			if(StringUtils.isNotBlank(vo.getUserId())){
				List<CcpPoemUser> list = ccpPoemUserMapper.selectPoemUserList(vo);
				
				if(list.size() == 0){
					//添加积分
					UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
					userIntegralDetail.setIntegralChange(100);
					userIntegralDetail.setChangeType(0);
					userIntegralDetail.setIntegralFrom("每日诗品："+vo.getPoemId());
					userIntegralDetail.setIntegralType(IntegralTypeEnum.POEM_USER.getIndex());
					userIntegralDetail.setUserId(vo.getUserId());
					userIntegralDetail.setUpdateType(1);
					HttpResponseText res = HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/updateIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
					JSONObject jsonObject = JSON.parseObject(res.getData());
					if (jsonObject.get("data").toString().equals("success")) {
						vo.setCreateTime(new Date());
						int result = ccpPoemUserMapper.insert(vo);
						if(result == 1){
						    return  "200";
						}else{
						    return  "500";
						}
					}else{
						return "500";
					}
				}else{
					return "100";
				}
			}else{
				return  "500";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "500";
		}
	}

	@Override
	public List<CcpPoemLector> queryAllPoemLector() {
		return ccpPoemLectorMapper.queryAllPoemLector();
	}

}
