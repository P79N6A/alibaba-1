package com.sun3d.why.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsUserWantgoMapper;
import com.sun3d.why.dao.ccp.CcpPoemLectorMapper;
import com.sun3d.why.dao.ccp.CcpPoemMapper;
import com.sun3d.why.dao.ccp.CcpPoemUserMapper;
import com.sun3d.why.model.CmsUserWantgo;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.ccp.CcpPoem;
import com.sun3d.why.model.ccp.CcpPoemLector;
import com.sun3d.why.model.ccp.CcpPoemUser;
import com.sun3d.why.model.ccp.CcpWalkImg;
import com.sun3d.why.model.ccp.CcpWalkUser;
import com.sun3d.why.model.ccp.CcpWalkVote;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpPoemService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
@Transactional
public class CcpPoemServiceImpl implements CcpPoemService{
    
    @Resource
    private CcpPoemMapper ccpPoemMapper;
    @Resource
    private CcpPoemLectorMapper ccpPoemLectorMapper;
    @Resource
    private CcpPoemUserMapper ccpPoemUserMapper;
    @Autowired
    private CmsUserWantgoMapper cmsUserWantgoMapper;
    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;
    
	@Override
	public List<CcpPoemLector> queryPoemLectorByCondition(CcpPoemLector ccpPoemLector, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (StringUtils.isNotBlank(ccpPoemLector.getLectorName())) {
			map.put("lectorName", "%"+ccpPoemLector.getLectorName()+"%");
		}
		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = ccpPoemLectorMapper.queryPoemLectorCountByCondition(map);
			// 设置分页的总条数来获取总页数
			page.setTotal(total);
		}
		return ccpPoemLectorMapper.queryPoemLectorByCondition(map);
	}

	@Override
	public String saveOrUpdatePoemLector(CcpPoemLector vo) {
		try {
			int result = 1;
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if(sysUser != null){
				CcpPoemLector ccpPoemLector = ccpPoemLectorMapper.selectByPrimaryKey(vo.getLectorId());
				if(ccpPoemLector!=null){
					result = ccpPoemLectorMapper.update(vo);
				}else{
					vo.setLectorId(UUIDUtils.createUUId());
					vo.setCreateUser(sysUser.getUserId());
					vo.setCreateTime(new Date());
					result = ccpPoemLectorMapper.insert(vo);
				}
				if(result == 1){
				    return  "200";
				}else{
				    return  "500";
				}
			}else{
				return  "500";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return  "500";
		}
	}

	@Override
	public String deletePoemLector(String lectorId) {
		int result = ccpPoemLectorMapper.deleteByPrimaryKey(lectorId);
		if(result == 1){
			return  "200";
		}else{
		    return  "500";
		}
	}

	@Override
	public List<CcpPoem> queryPoemByCondition(CcpPoem ccpPoem, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (StringUtils.isNotBlank(ccpPoem.getPoemTitle())) {
			map.put("poemTitle", "%"+ccpPoem.getPoemTitle()+"%");
		}
		if (StringUtils.isNotBlank(ccpPoem.getLectorName())) {
			map.put("lectorName", "%"+ccpPoem.getLectorName()+"%");
		}
		if (StringUtils.isNotBlank(ccpPoem.getPoemDate())) {
			map.put("poemDate", ccpPoem.getPoemDate());
		}
		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = ccpPoemMapper.queryPoemCountByCondition(map);
			// 设置分页的总条数来获取总页数
			page.setTotal(total);
		}
		return ccpPoemMapper.queryPoemByCondition(map);
	}

	@Override
	public String saveOrUpdatePoem(CcpPoem vo) {
		try {
			int result = 1;
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if(sysUser != null){
				CcpPoem ccpPoem = ccpPoemMapper.selectByPrimaryKey(vo.getPoemId());
				if(ccpPoem!=null){
					result = ccpPoemMapper.update(vo);
				}else{
					//判断日期不重复
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("poemDate", vo.getPoemDate());
					List<CcpPoem> list = ccpPoemMapper.queryPoemByCondition(map);
					if(list.size()>0){
						return  "repeat";
					}
					
					vo.setPoemId(UUIDUtils.createUUId());
					vo.setCreateUser(sysUser.getUserId());
					vo.setCreateTime(new Date());
					result = ccpPoemMapper.insert(vo);
				}
				if(result == 1){
				    return  "200";
				}else{
				    return  "500";
				}
			}else{
				return  "500";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return  "500";
		}
	}

	@Override
	public String deletePoem(String poemId) {
		int result = ccpPoemMapper.deleteByPrimaryKey(poemId);
		if(result == 1){
			return  "200";
		}else{
		    return  "500";
		}
	}

	@Override
	public List<CcpPoemUser> queryPoemUserByCondition(CcpPoemUser ccpPoemUser, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (StringUtils.isNotBlank(ccpPoemUser.getUserName())) {
			map.put("userName", "%"+ccpPoemUser.getUserName()+"%");
		}
		if (ccpPoemUser.getPoemCompleteCount() != null) {
			map.put("poemCompleteCount", ccpPoemUser.getPoemCompleteCount());
		}
		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = ccpPoemUserMapper.queryPoemUserCountByCondition(map);
			// 设置分页的总条数来获取总页数
			page.setTotal(total);
		}
		return ccpPoemUserMapper.queryPoemUserByCondition(map);
	}

	@Override
	public String brushWantGo(String poemId, Integer count) {
		if(StringUtils.isNotBlank(poemId) && count != null){
			try {
				List<CmsUserWantgo> wantgolist = new ArrayList<CmsUserWantgo>(); 
				for(int i=0;i<count;i++){
					CmsUserWantgo vo = new CmsUserWantgo();
					vo.setSid(UUIDUtils.createUUId());
					vo.setRelateId(poemId);
					vo.setUserId("0");
					vo.setCreateTime(new Date());
			        vo.setRelateType(11);
			        wantgolist.add(vo);
				}
				int result = cmsUserWantgoMapper.brushWantgo(wantgolist);
				if(result>0){
					return "200";
				}else{
					return "500";
				}
			} catch (Exception e) {
				e.printStackTrace();
				return "500";
			}
		}else{
			return "500";
		}
	}
}
