package com.sun3d.why.service.impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.culturecloud.model.bean.culture.CcpCultureContestUser;
import com.sun3d.why.dao.CcpCultureContestAnswerMapper;
import com.sun3d.why.dao.CcpCultureContestUserMapper;
import com.sun3d.why.dao.dto.CcpCultureContestAnswerDto;
import com.sun3d.why.service.CcpCultureContestUserService;
import com.sun3d.why.util.Pagination;

@Service
@Transactional
public class CcpCultureContestUserServiceImpl implements CcpCultureContestUserService {

	@Autowired
	private CcpCultureContestUserMapper cultureContestUserMapper;
	
	@Autowired
	private CcpCultureContestAnswerMapper ccpCultureContestAnswerMapper;

	@Override
	public List<CcpCultureContestAnswerDto> queryUserByCondition(Map<String,Object> map,Pagination page) {
		
		//分页显示查询的用户信息
		if(page!=null && page.getFirstResult()!=null && page.getRows()!=null){
			map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = cultureContestUserMapper.queryCountByUserId(map);
            //设置分页的总条数来获取总页数
            List<CcpCultureContestAnswerDto> list = ccpCultureContestAnswerMapper.queryUserContestAnswerList(map);
            page.setTotal(total);
            return list;
            
		}
		return null;
	}
	
	
	@Override
	public List<CcpCultureContestUser> queryDetailByUserId(String id) {
		List<CcpCultureContestUser> info= cultureContestUserMapper.queryDetailByUserId(id);
		return info;
	}

	/**
	 * 查询所有用户所有阶段信息返回到页面展现
	 *
	 * @param page Pagination 分页功能类
	 * @param Map map 参数集合           
	 * @return List<CcpCultureContestAnswerDto> 用户信息
	 */
	@Override
	public List<CcpCultureContestAnswerDto> queryUserContestAnswerAllList(Map<String,Object> map,Pagination page) {
		
		//分页显示查询的用户信息
		if(page!=null && page.getFirstResult()!=null && page.getRows()!=null){
			map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = cultureContestUserMapper.queryCountByUserId(map);
            //设置分页的总条数来获取总页数
            page.setTotal(total);     
		}
		List<CcpCultureContestAnswerDto> list = ccpCultureContestAnswerMapper.queryUserContestAnswerAllList(map);
		return list;
	}


	
	@Override
	public List<CcpCultureContestAnswerDto> queryUserContestAnswerDetailList(String cultureUserId) {
		List<CcpCultureContestAnswerDto> list =  ccpCultureContestAnswerMapper.queryUserContestAnswerDetailList(cultureUserId);
		return list;
	}


	@Override
	public List queryUserContestAnswerSort(Map<String, Object> map) {
		List list = ccpCultureContestAnswerMapper.queryUserContestAnswerSort(map);
		return list;
	}


	@Override
	public List queryUserContestAnswerSortAll(Map<String, Object> map) {
		List list = ccpCultureContestAnswerMapper.queryUserContestAnswerSortAll(map);
		return list;
	}


	@Override
	public String queryUsernameByUserId(String userId) {
		String userName = cultureContestUserMapper.queryUsernameByUserId(userId);
		return userName;
	}
	
	
	
	
	

}
