package com.culturecloud.model.response.volunteer;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.PropertyUtils;

import com.culturecloud.model.bean.volunteer.CcpVolunteerRecruit;

public class CcpVolunteerRecruitVO extends CcpVolunteerRecruit{

	
	public CcpVolunteerRecruitVO(CcpVolunteerRecruit recruit) {
		
		try {
			PropertyUtils.copyProperties(this, recruit);
		} catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
			e.printStackTrace();
		}
		
	}
}
