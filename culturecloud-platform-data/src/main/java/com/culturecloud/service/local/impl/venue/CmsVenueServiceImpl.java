package com.culturecloud.service.local.impl.venue;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.culturecloud.dao.common.CmsTagSubMapper;
import com.culturecloud.dao.common.SysNearSynonymMapper;
import com.culturecloud.dao.dto.activity.CmsActivityDto;
import com.culturecloud.dao.dto.common.CmsTagSubDto;
import com.culturecloud.dao.dto.venue.CmsVenueDto;
import com.culturecloud.dao.venue.CmsVenueMapper;
import com.culturecloud.kafka.PpsConfig;
import com.culturecloud.model.response.common.CmsTagSubVO;
import com.culturecloud.model.response.venue.CmsVenueVO;
import com.culturecloud.service.local.venue.CmsVenueService;

@Service
public class CmsVenueServiceImpl implements CmsVenueService{
	
	@Resource
	private CmsVenueMapper cmsVenueMapper;
	
	@Resource
	private CmsTagSubMapper cmsTagSubMapper;
	
	@Resource
	private SysNearSynonymMapper sysNearSynonymMapper;
	
	private static String staticServerUrl=PpsConfig.getString("staticServerUrl");

	@Override
	public List<CmsVenueVO> searchVenue(int limit, String keyword) {
	
		
		LinkedHashMap<String,CmsVenueDto> venueAllMap=new LinkedHashMap<String,CmsVenueDto>();
		
		venueAllMap= this.eachSearchVenue(venueAllMap, keyword, limit, 0);
		
		// 搜索为空时 查询是否有近义词继续查询
		if(venueAllMap.size()==0)
		{
			String nearSynonym=sysNearSynonymMapper.queryNearSynonym(keyword);
					
			if(StringUtils.isNotBlank(nearSynonym))
			{
				venueAllMap= this.eachSearchVenue(venueAllMap, nearSynonym, limit, 0);
			}
		}		
		
		List<CmsVenueVO> result= new ArrayList<CmsVenueVO>();
		
		for (CmsVenueDto cmsVenueDto : venueAllMap.values()) {
			
			CmsVenueVO vo=new CmsVenueVO(cmsVenueDto); 
			
			List<CmsTagSubDto> cmsTagSubList=cmsTagSubMapper.queryRelateTagSubList(cmsVenueDto.getVenueId());
			
			List<CmsTagSubVO> subList= new ArrayList<CmsTagSubVO>();
			
			for (CmsTagSubDto cmsTagSubDto : cmsTagSubList) {
				
				subList.add(new CmsTagSubVO(cmsTagSubDto));
			}
			
			vo.setSubList(subList);

			String venueIconUrl = "";
			if (StringUtils.isNotBlank(cmsVenueDto.getVenueIconUrl())) {
				
				if(cmsVenueDto.getVenueIconUrl().indexOf("http:")>-1)
              		
					venueIconUrl=cmsVenueDto.getVenueIconUrl();
              	else
              		venueIconUrl = staticServerUrl+ cmsVenueDto.getVenueIconUrl();
			}
			
			vo.setVenueIconUrl(venueIconUrl);
			
			result.add(vo);
		}
		
		Collections.sort(result,  new Comparator<CmsVenueVO>(){

			@Override
			public int compare(CmsVenueVO v1, CmsVenueVO v2) {
				
				Integer venueSort1=v1.getVenueSort();
				Integer venueSort2=v2.getVenueSort();
				
				if(venueSort1==null)
					venueSort1=-1;
				if(venueSort2==null)
					venueSort2=-1;
				
				return venueSort1.compareTo(venueSort2);
			}
			
		});
		
		return result;
	}
	
	/**
	 * 依次条件查询
	 * 
	 * @param venueAllMap
	 * @param limit
	 * @param index
	 * @return
	 */
	private LinkedHashMap<String,CmsVenueDto> eachSearchVenue (LinkedHashMap<String,CmsVenueDto> venueAllMap,String keyword,int limit,int index) {
		String methodArray[]=new String[]{"searchByName","searchByAddress"};
		
		if(index>=methodArray.length){
			return venueAllMap;
		}
		else
		{
			List<CmsVenueDto> list=new ArrayList<CmsVenueDto>();
			
			Method m;
			try {
				m = CmsVenueMapper.class.getDeclaredMethod(methodArray[index], new Class[]{String.class,int.class});
				
				 list=(List<CmsVenueDto>) m.invoke(cmsVenueMapper, new Object[]{keyword,limit});
			} catch (Exception e) {
				e.printStackTrace();
				return venueAllMap;
			} 
				
			for (CmsVenueDto cmsVenueDto : list) {
				
				if(!venueAllMap.containsKey(cmsVenueDto.getVenueId()))
				{
					venueAllMap.put(cmsVenueDto.getVenueId(), cmsVenueDto);
					limit-=1;
				}
			}
			
			if(limit<=0)
				return venueAllMap;
			else
			{
				index++;
				this.eachSearchVenue(venueAllMap, keyword, limit, index);
			}
		}
		
		return venueAllMap;
	}

}
