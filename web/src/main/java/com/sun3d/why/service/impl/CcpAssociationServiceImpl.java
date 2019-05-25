package com.sun3d.why.service.impl;

import com.culturecloud.model.bean.association.CcpAssociationApply;
import com.sun3d.why.dao.CcpAssociationMapper;
import com.sun3d.why.dao.CcpAssociationRecruitApplyMapper;
import com.sun3d.why.dao.CcpAssociationRecruitMapper;
import com.sun3d.why.model.CcpAssociation;
import com.sun3d.why.model.CcpAssociationRecruit;
import com.sun3d.why.model.CcpAssociationRecruitApply;
import com.sun3d.why.service.CcpAssociationService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CcpAssociationServiceImpl implements CcpAssociationService {

    private Logger logger = Logger.getLogger(CcpAssociationServiceImpl.class);
    @Autowired
    private CcpAssociationMapper ccpAssociationMapper;
    @Autowired
    private CcpAssociationRecruitMapper ccpAssociationRecruitMapper;
    @Autowired
    private CcpAssociationRecruitApplyMapper ccpAssociationRecruitApplyMapper;

	@Override
	public List<CcpAssociation> queryAssociationByCondition(CcpAssociation ccpAssociation, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (ccpAssociation != null) {
            if (StringUtils.isNotBlank(ccpAssociation.getAssnName())){
                map.put("assnName", "%" + ccpAssociation.getAssnName() + "%");
            }
        }
		//分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = ccpAssociationMapper.queryAssociationCountByCondition(map);
            page.setTotal(total);
        }

        return ccpAssociationMapper.queryAssociationByCondition(map);
	}

	@Override
	public boolean saveAssnApply(CcpAssociationApply ccpAssociationApply) {
        try {
            int count = ccpAssociationMapper.saveAssnApply(ccpAssociationApply);
            if (count > 0) {
                return true;
            }
        } catch (Exception e) {
            logger.error("saveAssnApply error", e);
            return false;
        }
        return false;
	}

	@Override
	public CcpAssociationRecruit getAssnRecruitByAssnId(String assnId) {
		List<CcpAssociationRecruit> list= ccpAssociationRecruitMapper.selectByAssnId(assnId);
		if(list!=null&&list.size()>0){
			return list.get(0);
		}else{
			return null;
		}
	}

	@Override
	public String saveRecruitApplyPc(CcpAssociationRecruitApply ccpAssociationRecruitApply) {
		try {
			Map<String,Object> map = new HashMap<String,Object>();
			if(StringUtils.isNotBlank(ccpAssociationRecruitApply.getApplyId())){
				map.put("applyId", ccpAssociationRecruitApply.getApplyId());
			}
			if(StringUtils.isNotBlank(ccpAssociationRecruitApply.getRecruitId())){
				map.put("recruitId", ccpAssociationRecruitApply.getRecruitId());
			}
			int userApplyCount = ccpAssociationRecruitApplyMapper.queryRecruitApplyCountByMap(map);
			if(userApplyCount>0){
				return "applyed";
			}
            int count = ccpAssociationRecruitApplyMapper.insertSelective(ccpAssociationRecruitApply);
            if (count > 0) {
                return "success";
            }
        } catch (Exception e) {
            logger.error("saveRecruitApply error", e);
            return "failure";
        }
        return "failure";
	}

	@Override
	public boolean saveRecruitApply(CcpAssociationRecruitApply recruitApply) {
		// TODO Auto-generated method stub
		try {
            int count = ccpAssociationRecruitApplyMapper.insertSelective(recruitApply);
            if (count > 0) {
                return true;
            }
        } catch (Exception e) {
            logger.error("saveRecruitApply error", e);
            return false;
        }
        return false;
	}

    //获取首页推荐社团
    @Override
    public CcpAssociation queryAssociationFromIndex(String ids) {
	    try{
            CcpAssociation ccp = ccpAssociationMapper.queryAssociationFromIndex(ids);
            return ccp;
        }catch (Exception e){
	        e.printStackTrace();
	        return null;
        }
    }
    
    @Override
	public CcpAssociation queryFrontAssnByAssnId(String assnId){
		return ccpAssociationMapper.queryAssnById(assnId);
	}

    @Override
    public String queryAppCmsAssnListByCondition(String name, PaginationApp pageApp) {
        /*List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = new HashMap<String, Object>();
        try {

            //活动名称模糊查询
            if (StringUtils.isNotBlank(name)) {
                map.put("activityName", "%/" + name + "%");
            }
            if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
                map.put("firstResult", pageApp.getFirstResult());
                map.put("rows", pageApp.getRows());
                int total = ccpAssociationMapper.queryAppCmsAssnListCountByCondition(map);
                pageApp.setTotal(total);
            }
            List<CcpAssociation> activityList = ccpAssociationMapper.queryAppCmsAssnListByCondition(map);
            listMap = this.getAppCmsActivityListResult(activityList, staticServer);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("query activityList error" + e.getMessage());
        }
        return JSONResponse.toAppActivityResultFormat(0, listMap, pageApp.getTotal());*/
        return null;
    }
}
