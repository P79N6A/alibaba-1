package com.culturecloud.model.response.common;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.PropertyUtils;

import com.culturecloud.model.bean.common.SysUser;

public class SysUserVO extends SysUser{
	
	private static final long serialVersionUID = -445882741128423308L;

	public SysUserVO() {
		super();
	}

	public SysUserVO(SysUser user) {
		
		  try {
	            PropertyUtils.copyProperties(this, user);
	        } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
	            e.printStackTrace();
	        }
	}
}
