package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CcpAdvertRecommendMapper;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.ccp.CcpAdvertRecommend;
import com.sun3d.why.service.CcpAdvertRecommendService;
import com.sun3d.why.util.UUIDUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
@Transactional
public class CcpAdvertRecommendServiceImpl implements CcpAdvertRecommendService {
    @Autowired
    private CcpAdvertRecommendMapper ccpAdvertRecommendMapper;

    @Override
    public List<CcpAdvertRecommend> queryCcpAdvertRecommend(CcpAdvertRecommend adverts) {
        return ccpAdvertRecommendMapper.selectAdvertByModel(adverts);
    }

    @Override
    public int insertAdvert(CcpAdvertRecommend advert,SysUser sysUser) {
        advert.setAdvertId(UUIDUtils.createUUId());
        advert.setCreateTime(new Date());
        advert.setUpdateTime(new Date());
        advert.setCreateBy(sysUser.getUserId());
        advert.setUpdateBy(sysUser.getUserId());
        return ccpAdvertRecommendMapper.insertAdvert(advert);
    }

    @Override
    public int updateAdvert(CcpAdvertRecommend advert,SysUser sysUser) {
        advert.setUpdateTime(new Date());
        advert.setUpdateBy(sysUser.getUserId());
        return ccpAdvertRecommendMapper.updateAdvert(advert);
    }

    @Override
    public int deleteAdvert(CcpAdvertRecommend advert) {
        return ccpAdvertRecommendMapper.deleteAdvertByModel(advert);
    }
}
