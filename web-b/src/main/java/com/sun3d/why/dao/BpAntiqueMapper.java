package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.BpAntique;

public interface BpAntiqueMapper {
    /**
     * 增加一条文物记录
     * @param record
     * @return
     */
    int addBpAntique(BpAntique record);

    /**
     * 根据条件查询文物的条数
     * @param map
     * @return
     */
	int queryBpAntiqueCountByCondition(Map<String, Object> map);

	/**
	 * 根据条件查询文物
	 * @param map
	 * @return
	 */
	List<BpAntique> queryBpAntiqueByCondition(Map<String, Object> map);
	
	/**
	 * 更新文物信息
	 * @param record
	 * @return
	 */
	int editBpAntique(BpAntique record);

	/**
	 * 根据id更新文物状态
	 * @param map
	 * @return
	 */
	int updateAntiqueDelById(Map<String, Object> map);
	
	/**
	 * 根据id查询一条文物信息
	 * @param antiqueId
	 * @return
	 */
	BpAntique queryBpAntiqueById(String antiqueId);


}