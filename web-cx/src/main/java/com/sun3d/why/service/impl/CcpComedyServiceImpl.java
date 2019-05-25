package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.sun3d.why.dao.ccp.CcpComedyMapper;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.ccp.CcpComedy;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpComedyService;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.api.util.HttpResponseText;

@Service
@Transactional
public class CcpComedyServiceImpl implements CcpComedyService {
    @Autowired
    private CcpComedyMapper ccpComedyMapper;
    @Autowired
    private StaticServer staticServer;

    /**
     * 喜剧列表
     */
	@Override
	public List<CcpComedy> queryComedyList(CcpComedy vo) {
		return ccpComedyMapper.queryComedyList(vo);
	}
	
	/**
	 * 添加喜剧节信息
	 */
	@Override
	@Transactional(isolation=Isolation.SERIALIZABLE)
	public String saveOrUpdateCcpComedy(CcpComedy vo) {
		CcpComedy dto = ccpComedyMapper.selectByPrimaryKey(vo.getUserId());
		if(dto!=null){
			//添加积分
			UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
			userIntegralDetail.setIntegralChange(500);
			userIntegralDetail.setChangeType(0);
			userIntegralDetail.setIntegralFrom("上海国际喜剧节上传笑脸获积分");
			userIntegralDetail.setIntegralType(IntegralTypeEnum.COMEDY.getIndex());
			userIntegralDetail.setUserId(vo.getUserId());
			userIntegralDetail.setUpdateType(1);
			HttpResponseText res = HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/updateIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
			JSONObject jsonObject = JSON.parseObject(res.getData());
			String status = jsonObject.get("status").toString();
			if(!status.equals("200")){
				return "500";
			}
			
			int count = ccpComedyMapper.update(vo);
			if (count > 0) {
				return "200";
			}else{
				return "500";
			}
		}else{
			vo.setCreateTime(new Date());
			int count = ccpComedyMapper.insert(vo);
			if (count > 0) {
				return "200";
			}else{
				return "500";
			}
		}
	}
	
	/**
	 * 获取喜剧详情
	 */
	@Override
	public CcpComedy selectByPrimaryKey(String userId) {
		return ccpComedyMapper.selectByPrimaryKey(userId);
	}

}
