package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsGatherMapper;
import com.sun3d.why.dao.UserAddressMapper;
import com.sun3d.why.model.CmsGather;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.UserAddress;
import com.sun3d.why.service.CmsGatherService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
@Transactional
public class CmsGatherServiceImpl implements CmsGatherService {

	private Logger logger = Logger.getLogger(CmsGatherServiceImpl.class);
    @Autowired
    private CmsGatherMapper cmsGatherMapper;
    @Autowired
    private UserAddressMapper userAddressMapper;
    @Autowired
    private HttpSession session;

	@Override
	public List<CmsGather> queryGatherByCondition(CmsGather cmsGather, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (cmsGather != null) {
            if (StringUtils.isNotBlank(cmsGather.getGatherName())){
                map.put("gatherName", "%" + cmsGather.getGatherName() + "%");
            }
            if (StringUtils.isNotBlank(cmsGather.getGatherId())){
                map.put("gatherId", cmsGather.getGatherId());
            }
            if (StringUtils.isNotBlank(cmsGather.getGatherTag())){
            	map.put("gatherTag", cmsGather.getGatherTag());
            }
            if (cmsGather.getGatherType() != null){
            	map.put("gatherType", cmsGather.getGatherType());
            }
            if (StringUtils.isNotBlank(cmsGather.getGatherStartDate())){
                map.put("gatherStartDate", cmsGather.getGatherStartDate());
            }
            if (StringUtils.isNotBlank(cmsGather.getGatherEndDate())){
                map.put("gatherEndDate", cmsGather.getGatherEndDate());
            }
            if (StringUtils.isNotBlank(cmsGather.getGatherGrade())){
                map.put("gatherGrade", cmsGather.getGatherGrade());
            }
            if (cmsGather.getSortType() != null){
            	map.put("sortType", cmsGather.getSortType());
            }
        }
		//分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = cmsGatherMapper.queryGatherCountByCondition(map);
            page.setTotal(total);
        }
        return cmsGatherMapper.queryGatherByCondition(map);
	}

	@Override
	public String saveOrUpdateGather(CmsGather vo) {
		try {
			int result = 1;
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if(sysUser != null){
				if (StringUtils.isNotBlank(vo.getGatherAddressId())) {
					UserAddress address = userAddressMapper.selectAddressById(vo.getGatherAddressId());
                    if (address.getActivityLon() != null) {
                        vo.setGatherAddressLon(address.getActivityLon());
                    }
                    if (address.getActivityLat() != null) {
                        vo.setGatherAddressLat(address.getActivityLat());
                    }
                }else{
                	vo.setGatherAddressLon((double) 0);
                	vo.setGatherAddressLat((double) 0);
                }
				
				CmsGather cmsGather = cmsGatherMapper.selectByPrimaryKey(vo.getGatherId());
				if(cmsGather!=null){
					vo.setGatherUpdateUser(sysUser.getUserId());
					vo.setGatherUpdateTime(new Date());
					result = cmsGatherMapper.update(vo);
				}else{
					vo.setGatherId(UUIDUtils.createUUId());
					vo.setGatherCreateUser(sysUser.getUserId());
					vo.setGatherCreateTime(new Date());
					vo.setGatherUpdateUser(sysUser.getUserId());
					vo.setGatherUpdateTime(new Date());
					result = cmsGatherMapper.insert(vo);
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
	public CmsGather queryGatherByPrimaryKey(String gatherId) {
		CmsGather cmsGather = cmsGatherMapper.selectByPrimaryKey(gatherId);
		return cmsGather;
	}

	@Override
	public String deleteGather(String gatherId) {
		int result = cmsGatherMapper.deleteByPrimaryKey(gatherId);
		if(result == 1){
			return  "200";
		}else{
		    return  "500";
		}
	}

}
