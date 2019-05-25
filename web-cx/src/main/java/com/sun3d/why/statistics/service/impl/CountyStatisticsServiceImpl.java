package com.sun3d.why.statistics.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun3d.why.dao.CountyStatisticsDetailMapper;
import com.sun3d.why.dao.SysUserRoleMapper;
import com.sun3d.why.model.SysUserRole;
import com.sun3d.why.model.countyStatistics.CountyStatisticsDetail;
import com.sun3d.why.statistics.service.CountyStatisticsService;

@Service
public class CountyStatisticsServiceImpl implements CountyStatisticsService {

	@Autowired
	CountyStatisticsDetailMapper countyStatisticsDetailMapper;

	@Autowired
	SysUserRoleMapper sysUserRoleMapper;

	@Override
	public List<CountyStatisticsDetail> getCountyActivityStatistics(Map<String, Object> param) {
		return countyStatisticsDetailMapper.getCountyActivityStatistics(param);
	}

	@Override
	public List<CountyStatisticsDetail> getCountyRoomStatistics(Map<String, Object> param) {
		return countyStatisticsDetailMapper.getCountyRoomStatistics(param);
	}

	@Override
	public boolean isUserRoleExist(String roleName, String userId) {
		List<SysUserRole> result = this.sysUserRoleMapper.selectUserRoleByUserIdAndRoleName(roleName, userId);
		if (result != null && result.size() != 0) {
			return true;
		}
		return false;
	}
}
