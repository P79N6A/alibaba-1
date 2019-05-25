package com.culturecloud.service;

import com.culturecloud.bean.BaseEntity;
import com.culturecloud.dao.BaseDAO;

public interface BaseService extends BaseDAO{

	/** 添加返回JavaBean*/
	public <E extends BaseEntity> E createGetBean(BaseEntity entity,Class<E> clazz,String uuid);
}
