package com.culturecloud.model.response.common;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.PropertyUtils;

import com.culturecloud.model.bean.common.CmsTagSub;

public class CmsTagSubVO extends CmsTagSub{
	
	private static final long serialVersionUID = 7421294708136238977L;

	public CmsTagSubVO() {
		super();
	}

	public CmsTagSubVO(CmsTagSub tagSub) {
		
		  try {
	            PropertyUtils.copyProperties(this, tagSub);
	        } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
	            e.printStackTrace();
	        }
	}
}
