package com.culturecloud.model.response.venue;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

import org.apache.commons.beanutils.PropertyUtils;

import com.culturecloud.model.bean.venue.CmsVenue;
import com.culturecloud.model.response.common.CmsTagSubVO;

public class CmsVenueVO extends CmsVenue{
	
	private String tagName;
	
	private Integer venueSort;
	
	// 标签列表 
	private List<CmsTagSubVO> subList;

	
	public CmsVenueVO(CmsVenue cmsVenue) {
		
		try {
			PropertyUtils.copyProperties(this, cmsVenue);
		} catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
			e.printStackTrace();
		}
		
	}


	public String getTagName() {
		return tagName;
	}


	public void setTagName(String tagName) {
		this.tagName = tagName;
	}


	public List<CmsTagSubVO> getSubList() {
		return subList;
	}


	public void setSubList(List<CmsTagSubVO> subList) {
		this.subList = subList;
	}


	public Integer getVenueSort() {
		return venueSort;
	}


	public void setVenueSort(Integer venueSort) {
		this.venueSort = venueSort;
	}
	
	
}
