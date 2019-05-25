package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.culturecloud.model.bean.association.CcpAssociationApply;
import com.sun3d.why.dao.CcpAssociationMapper;
import com.sun3d.why.model.CcpAssociation;
import com.sun3d.why.service.CcpAssociationService;
import com.sun3d.why.util.Pagination;

@Service
public class CcpAssociationServiceImpl implements CcpAssociationService {

    private Logger logger = Logger.getLogger(CcpAssociationServiceImpl.class);
    @Autowired
    private CcpAssociationMapper ccpAssociationMapper;

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
}
