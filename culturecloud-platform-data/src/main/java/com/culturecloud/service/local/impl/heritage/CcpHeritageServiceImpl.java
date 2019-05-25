package com.culturecloud.service.local.impl.heritage;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.dao.heritage.CcpHeritageImgMapper;
import com.culturecloud.dao.heritage.CcpHeritageMapper;
import com.culturecloud.model.bean.heritage.CcpHeritageImg;
import com.culturecloud.model.request.heritage.CcpHeritageReqVO;
import com.culturecloud.model.response.heritage.CcpHeritageResVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.service.local.heritage.CcpHeritageService;

@Service
public class CcpHeritageServiceImpl implements CcpHeritageService{
	
	@Resource
	private CcpHeritageMapper ccpHeritageMapper;
	@Resource
	private CcpHeritageImgMapper ccpHeritageImgMapper;
	@Resource
	private BaseService baseService;

	@Override
	public List<CcpHeritageResVO> getCcpHeritageList(CcpHeritageReqVO request) {
		return ccpHeritageMapper.selectCcpHeritageList(request);
	}
	
	@Override
	public CcpHeritageResVO getCcpHeritageById(CcpHeritageReqVO request) {
		return ccpHeritageMapper.selectCcpHeritageById(request);
	}
	
	/**
	 * 用于后台编辑
	 * @param request
	 * @return
	 */
	@Override
	public CcpHeritageResVO getHeritageById(CcpHeritageReqVO request) {
		return ccpHeritageMapper.selectHeritageById(request);
	}
	
	@Override
	@Transactional
	public void insertHeritage(CcpHeritageReqVO request) {
		ccpHeritageMapper.insert(request);
		if(request.getCcpHeritageImgList()!=null){
			for(CcpHeritageImg ccpHeritageImg : request.getCcpHeritageImgList()){
				ccpHeritageImgMapper.insert(ccpHeritageImg);
			}
		}
	}

	@Override
	@Transactional
	public void updateHeritage(CcpHeritageReqVO request) {
		ccpHeritageMapper.update(request);
		if(request.getCcpHeritageImgList()!=null){
			ccpHeritageImgMapper.deleteByHerigateId(request.getHeritageId());
			for(CcpHeritageImg ccpHeritageImg : request.getCcpHeritageImgList()){
				ccpHeritageImgMapper.insert(ccpHeritageImg);
			}
		}
	}

}
