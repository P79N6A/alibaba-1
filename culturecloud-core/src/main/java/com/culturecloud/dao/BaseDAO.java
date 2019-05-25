package com.culturecloud.dao;

import java.util.List;

import com.culturecloud.bean.BaseEntity;
import com.culturecloud.bean.QueryResult;

public interface BaseDAO {

	/** 添加 */
	public void create(BaseEntity entity);

	/** 单表查询 */
	public <E extends BaseEntity> List<E> find(Class<E> clazz, String whereSql);

	/**
	 * 根据ID获取数据
	 */
	public <E extends BaseEntity> E findById(Class<E> clazz, String id);

	/**
	 * 根据model查询单表数据
	 *  
	 * @throws Exception
	 */
	public <E extends BaseEntity> List<E> findByModel(E entity);
	
	/** 更新 */
	public void update(final BaseEntity model, String whereSql);

	/** 删除 */
	public <E extends BaseEntity> void delete(Class<E> clazz, String whereSql);

	/** 单表查询分页 */
	public <E extends BaseEntity> QueryResult<E> findPage(Class<E> clazz, String whereSql, Integer firstindex,
			Integer maxresult);
}
