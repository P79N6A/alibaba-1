package com.culturecloud.model.response.vote;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.PropertyUtils;

import com.culturecloud.model.bean.vote.CcpVoteUser;

public class CcpVoteUserVO extends CcpVoteUser{

	private static final long serialVersionUID = 6222015137201989533L;

	public CcpVoteUserVO() {
	}
	
	public CcpVoteUserVO(CcpVoteUser user) {
		try {
			PropertyUtils.copyProperties(this, user);
		} catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
			e.printStackTrace();
		}
	}
}
