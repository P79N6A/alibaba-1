package com.sun3d.why.statistics.service.impl;

import com.sun3d.why.dao.CmsStatisticsMapper;
import com.sun3d.why.model.CmsStatistics;
import com.sun3d.why.statistics.service.StatisticService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;

/**
 * 模块服务层实现类
 * 事务管理层
 * 需要用到事务的功能都在此编写
 *
 * author wangkun
 */
@Service
@Transactional
public class StatisticServiceImpl implements StatisticService {
    /**
     * 自动注入数据操作层dao实例
     */
    @Autowired
    private CmsStatisticsMapper cmsStatisticsMapper;

	@Override
	public int editCmsStatisticByCondition(CmsStatistics cmsStatistics) {
		// TODO Auto-generated method stub

		return cmsStatisticsMapper.editCmsStatisticByCondition(cmsStatistics);
	}

	@Override
	public int cmsStatisticCountById(String s) {
		return cmsStatisticsMapper.cmsStatisticCountById(s);
	}


	@Override
	public int addCmsStatisticByCondition(CmsStatistics cmsStatistics) {
		// TODO Auto-generated method stub
		return cmsStatisticsMapper.addCmsStatisticByCondition(cmsStatistics);
	}


	@Override
	public CmsStatistics selectByPrimaryKey(String sId) {
		//return cmsStatisticsMapper.selectByPrimaryKey(sId);
		return  null;
	}

	/**
	 * 前端2.0 根据id和type查询收藏量和浏览量
	 * @param sId
	 * @param sType
	 * @return 统计表对象
	 */
	public CmsStatistics queryStatistics(String sId,int sType){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("sId", sId);
		map.put("sType", sType);
		return cmsStatisticsMapper.queryStatistics(map);
	}
}
