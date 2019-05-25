package com.culturecloud.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.mybatis.spring.SqlSessionTemplate;

import com.culturecloud.aop.ExceptionDisplay;
import com.culturecloud.bean.BaseEntity;
import com.culturecloud.bean.QueryResult;
import com.culturecloud.coreutils.SXReflectionUtils;
import com.culturecloud.coreutils.SXStringUtils;
import com.culturecloud.db.MyBatisSQLGenerator;
import com.culturecloud.exception.BizException;

public abstract class BaseDAOImpl implements BaseDAO {

	@Resource(name = "sqlSessionTemplate")
	public SqlSessionTemplate sqlSessionTemplate;

	@Override
	public void create(BaseEntity entity) {
		// TODO Auto-generated method stub
		try {
			sqlSessionTemplate.insert("create_cult", MyBatisSQLGenerator.insert(entity));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			//BizException.Throw("DAO--create error!" + );
			BizException.Throw(ExceptionDisplay.hidden.getValue(), e.getMessage());
		}
	}

	@Override
	public <E extends BaseEntity> E findById(Class<E> clazz, String id) {

		if (StringUtils.isBlank(id)) {
			return null;
		}
		final Map<String, Object> resultMap = this.sqlSessionTemplate.selectOne("findById_cult",
				MyBatisSQLGenerator.getFindByIdSql(id, clazz));
		return this.handleResult(resultMap, clazz);
	}

	@SuppressWarnings("unchecked")
	public <E extends BaseEntity> List<E> findByModel(final E model) {
		final List<E> list = new ArrayList<E>();
		final String sql = MyBatisSQLGenerator.getFindByModelSql(model);
		final List<Map<String, Object>> resultMap = this.sqlSessionTemplate.selectList("findByModel_cult", sql);
		for (final Map<String, Object> map : resultMap) {
			list.add((E) this.handleResult(map, model.getClass()));
		}
		return list;
	}

	@Override
	public <E extends BaseEntity> List<E> find(Class<E> clazz, String whereSql) {
		// TODO Auto-generated method stub
		try {
			final List<E> list = new ArrayList<E>();
			final String sql = MyBatisSQLGenerator.getFind(clazz, whereSql);
			final List<Map<String, Object>> resultMap = this.sqlSessionTemplate.selectList("find_cult", sql);
			for (final Map<String, Object> map : resultMap) {
				list.add(this.handleResult(map, clazz));
			}
			return list;
		} catch (Exception e) {
			BizException.Throw(ExceptionDisplay.hidden.getValue(), e.getMessage());
		}
		return null;
	}
	
	@Override
	public void update(BaseEntity model, String whereSql) {
		// TODO Auto-generated method stub
		try {
			this.sqlSessionTemplate.update("update_cult", MyBatisSQLGenerator.update(model, whereSql));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			BizException.Throw(ExceptionDisplay.hidden.getValue(), e.getMessage());
		}

	}

	/** 将返回的Map转成对象 */
	private <E extends BaseEntity> E handleResult(final Map<String, Object> resultMap, final Class<E> clazz) {
		E t = null;
		try {
			t = clazz.newInstance();
			for (final Map.Entry<String, Object> entry : resultMap.entrySet()) {
				final String key = SXStringUtils.toCamelCase(entry.getKey());
				final Object val = entry.getValue();
				// System.out.println(key + "=======================" + val);
				SXReflectionUtils.invokeSetterMethod(t, key, val);
			}
		} catch (final Exception e) {
			BizException.Throw(ExceptionDisplay.hidden.getValue(), e.getMessage());
		}
		return t;
	}

	@Override
	public <E extends BaseEntity> void delete(Class<E> clazz, String whereSql) {
		// TODO Auto-generated method stub
		try {
			this.sqlSessionTemplate.delete("deleteByWhere_cult", MyBatisSQLGenerator.delete(clazz, whereSql));
		} catch (Exception e) {
			BizException.Throw(ExceptionDisplay.hidden.getValue(), e.getMessage());
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.sxiic.dao.BaseDAO#findPage(java.lang.Class, java.lang.String)
	 */
	@Override
	public <E extends BaseEntity> QueryResult<E> findPage(Class<E> clazz, String whereSql, Integer firstindex,
			Integer maxresult) {
		// TODO Auto-generated method stub

		try {
			final QueryResult<E> resultList = new QueryResult<E>();
			final List<E> list = new ArrayList<E>();
			final String sql = MyBatisSQLGenerator.getFindByPage(clazz, whereSql, firstindex, maxresult);
			final List<Map<String, Object>> resultMap = this.sqlSessionTemplate.selectList("findByPage", sql);
			int resultIndex = firstindex + resultMap.size();// 下次查询结果起始数
			for (final Map<String, Object> map : resultMap) {
				list.add(this.handleResult(map, clazz));
			}
			resultList.setList(list);
			resultList.setTotalrecord((Long) this.sqlSessionTemplate.selectOne("findByCount",
					MyBatisSQLGenerator.getFindCount(clazz, whereSql)));
			resultList.setResultIndex(resultIndex);
			return resultList;
		} catch (Exception e) {
			BizException.Throw(ExceptionDisplay.hidden.getValue(), e.getMessage());
		}
		return null;
	}
}
