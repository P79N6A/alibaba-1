package com.culturecloud.service;

import org.springframework.stereotype.Service;

import com.culturecloud.bean.BaseEntity;
import com.culturecloud.dao.BaseDAOImpl;

@Service
public class BaseServiceImpl extends BaseDAOImpl implements BaseService{

	@Override
	public <E extends BaseEntity> E createGetBean(BaseEntity entity,
			Class<E> clazz, String uuid) {
		super.create(entity);
		E e=super.find(clazz, " where uuid='"+uuid+"'").get(0);
		return e;
	}

}
