package com.sun3d.why.statistics.service.impl;

import com.sun3d.why.dao.IndexStatisticsMapper;
import com.sun3d.why.model.IndexStatistics;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.statistics.service.IndexStatisticsService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class IndexStatisticsServiceImpl implements IndexStatisticsService{

    @Autowired
    private IndexStatisticsMapper indexStatisticsMapper;

    @Override
    public List<IndexStatistics> queryByMap(Map map) {
        return indexStatisticsMapper.queryByMap(map);
    }

    @Override
    public int addIndexStatistics(IndexStatistics record) {
        return indexStatisticsMapper.addIndexStatistics(record);
    }

    @Override
    public int deleteInfo() {
        return indexStatisticsMapper.deleteInfo();
    }

    @Override
    public List<IndexStatistics> queryInfoByInfo(Map map, SysUser sysUser,String area)  {
        if (area != null && StringUtils.isNotBlank(area)) {
            map.put("area",area);
        } else {
            map.put("area",sysUser.getUserCounty());
        }
        return indexStatisticsMapper.queryByMap(map);
    }

	@Override
	public List<IndexStatistics> queryIndexStatistics(IndexStatistics vo,SysUser sysUser) {
		List<IndexStatistics> list = null;
		if(sysUser.getUserIsManger() == 1){	//省级
			vo.setActivityCity(sysUser.getUserCity().split(",")[1]);
			list = indexStatisticsMapper.queryIndexStatisticsByArea(vo);
		}else if(sysUser.getUserIsManger() == 2){	//市级
			vo.setActivityCity(sysUser.getUserCity());
			list = indexStatisticsMapper.queryIndexStatisticsByArea(vo);
		}else if(sysUser.getUserIsManger() == 3){		//区级
			vo.setActivityArea(sysUser.getUserCounty());
			list = indexStatisticsMapper.queryIndexStatisticsByVenue(vo);
		}else if(sysUser.getUserIsManger() == 4){		//场馆级
			vo.setVenueDeptId(sysUser.getUserDeptId());
			list = indexStatisticsMapper.queryIndexStatisticsByVenue(vo);
		}
		return list;
	}
}