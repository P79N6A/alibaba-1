package com.culturecloud.model.response.vote;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.PropertyUtils;

import com.culturecloud.model.bean.vote.CcpVote;

public class CcpVoteVO extends CcpVote {

	private static final long serialVersionUID = 205047898930813913L;
	 
	public CcpVoteVO() {
		super();
		// TODO Auto-generated constructor stub
	}

	public CcpVoteVO(CcpVote vote) {
		try {
			PropertyUtils.copyProperties(this, vote);
		} catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
			e.printStackTrace();
		}
	}

}
