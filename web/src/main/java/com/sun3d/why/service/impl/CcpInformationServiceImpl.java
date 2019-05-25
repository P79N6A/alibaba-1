package com.sun3d.why.service.impl;

import com.culturecloud.model.bean.common.CcpInformation;
import com.culturecloud.model.bean.common.CcpInformationType;
import com.sun3d.why.dao.CcpInformationMapper;
import com.sun3d.why.dao.CcpInformationTypeMapper;
import com.sun3d.why.dao.dto.CcpInformationDto;
import com.sun3d.why.dao.dto.CcpInformationDto1;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpInformationService;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.swing.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class CcpInformationServiceImpl implements CcpInformationService {
	@Autowired
	private StaticServer staticServer;
	@Autowired
	private CcpInformationMapper ccpInformationMapper;
	@Autowired
	private CcpInformationTypeMapper ccpInformationTypeMapper;

	@Override
	public List<CcpInformationDto1> informationList(CcpInformation information, String userId, Integer pageIndex, Integer pageNum, String shopPath) {
		Map<String, Object> map = new HashMap<>();
		
		if(StringUtils.isNotBlank(userId)){
			
			map.put("userId", userId);
		}
		

		String informationTitle=information.getInformationTitle();
		
		if(StringUtils.isNotBlank(informationTitle)){
			
			map.put("informationTitle", informationTitle);
		}
		
		String informationType=information.getInformationType();
		
		if(StringUtils.isNotBlank(informationType)){
			CcpInformationType informationTypeObj = ccpInformationTypeMapper.selectByPrimaryKey(informationType);
			String informationTypes = informationTypeObj.getTypeRelateId();
			if(StringUtils.isNotBlank(informationTypes)){
				String[] types = informationTypes.split(",");
				String newTypes = "";
				 for (int j=0; j<types.length; j++){
					 newTypes += "'"+types[j]+"',";
				 }
				 if(StringUtils.isNotBlank(newTypes)){
    	        	map.put("informationTypes", newTypes.substring(0,newTypes.length()-1));
				 }
			}else{
				map.put("informationType", informationType);
			}
		}
		
		Integer informationIsRecommend=information.getInformationIsRecommend();
		
		if(informationIsRecommend!=null){
			map.put("informationIsRecommend", informationIsRecommend);
		}
		
		if(StringUtils.isNotBlank(information.getInformationModuleId())){
			map.put("informationModuleId", information.getInformationModuleId());
		}
		
		if(pageIndex!=null&&pageNum!=null){
			map.put("firstResult", pageIndex);
			map.put("rows", pageNum);
		
		}
		List<CcpInformationDto1>  list=	ccpInformationMapper.queryInformationByCondition(map);
		
		for(CcpInformationDto1 informationDto : list){
			String typeId = informationDto.getInformationType();
			CcpInformationType type = ccpInformationTypeMapper.selectByPrimaryKey(typeId);
			informationDto.setInformationTypeName(type.getTypeName());
		}
		
		return list;
	}

	@Override
	public List<CcpInformationDto> informationListWithDetail(CcpInformation information, String userId, Pagination page, String shopPath) {
		Map<String, Object> map = new HashMap<>();

		if(StringUtils.isNotBlank(userId)){

			map.put("userId", userId);
		}


		String informationTitle=information.getInformationTitle();

		if(StringUtils.isNotBlank(informationTitle)){

			map.put("informationTitle", informationTitle);
		}

		String informationType=information.getInformationType();

		if(StringUtils.isNotBlank(informationType)){
			/*CcpInformationType informationTypeObj = ccpInformationTypeMapper.selectByPrimaryKey(informationType);
			String informationTypes = informationTypeObj.getTypeRelateId();
			if(StringUtils.isNotBlank(informationTypes)){
				String[] types = informationTypes.split(",");
				String newTypes = "";
				for (int j=0; j<types.length; j++){
					newTypes += "'"+types[j]+"',";
				}
				if(StringUtils.isNotBlank(newTypes)){
					map.put("informationTypes", newTypes.substring(0,newTypes.length()-1));
				}
			}else{
				map.put("informationType", informationType);
			}*/

			map.put("informationType", informationType);
		}

		Integer informationIsRecommend=information.getInformationIsRecommend();

		if(informationIsRecommend!=null){
			map.put("informationIsRecommend", informationIsRecommend);
		}

		if(StringUtils.isNotBlank(information.getInformationModuleId())){
			map.put("informationModuleId", information.getInformationModuleId());
		}

		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
//			map.put("rows",12);
			List<String> ids = ccpInformationMapper.queryInformationByConditionCount(map);
			int total = ids.size();
			// 设置分页的总条数来获取总页数
			page.setTotal(total);
			page.setRows(page.getRows());
//			page.setRows(12);
		}
		//遍历ids，从ccp_information和ccp_information_detail表中取数据
		map.put("diff",1);
		List<CcpInformationDto> list = new ArrayList<>();
		List<String> ids_currPage = ccpInformationMapper.queryInformationByConditionCount(map);
		for (String id : ids_currPage) {
			map.put("informationId",id);
			CcpInformationDto infoDto= ccpInformationMapper.queryInformationByConditionWithDetail(map);
			list.add(infoDto);
		}

		//Anterior high energy
		/*List<CcpInformationDto>  list2 = new ArrayList<>();
		int i = 12;
		while (list.size()<total && list.size()<12){
			map.put("firstResult", page.getFirstResult()+i);
			list2=	ccpInformationMapper.queryInformationByConditionWithDetail(map);
			if (list2 == null || list2.size() == 0){
				break;
			}
			list.addAll(list2);
			if (list.size()>12){
				for (int j = list.size()-1; j >= 12; j--) {
					list.remove(j);
				}
				//TODO 对list去重...
			}
			i += 12;
		}*/

		for(CcpInformationDto informationDto : list){
			String typeId = informationDto.getInformationType();
			CcpInformationType type = ccpInformationTypeMapper.selectByPrimaryKey(typeId);
			informationDto.setInformationTypeName(type.getTypeName());

			if(informationDto.getInformationIconUrl() != null) {
//				informationDto.setInformationIconUrl(staticServer.getStaticServerUrl() + informationDto.getInformationIconUrl());
				informationDto.setInformationIconUrl(informationDto.getInformationIconUrl());
			}
		}

		return list;
	}
	
	@Override
	public CcpInformationDto getInformation(String informationId, String userId) {
		return ccpInformationMapper.queryInformationDetail(informationId,userId);
	}


	@Override
	public CcpInformationDto queryInformationUserInfo(String informationId, String userId) {
		return ccpInformationMapper.queryInformationUserInfo(informationId,userId);
	}

	@Override
	public CcpInformation queryInformationById(String advertUrl) {
		return ccpInformationMapper.queryInformationById(advertUrl);
	}

	@Override
	public List<CcpInformation> pcnewInfo(int num) {
		Map map = new HashMap();
		map.put("orderBy", "INFORMATION_CREATE_TIME DESC");
		map.put("firstResult", 0);
		map.put("rows", num);
		return ccpInformationMapper.pcnewInfo(map);
	}
}
