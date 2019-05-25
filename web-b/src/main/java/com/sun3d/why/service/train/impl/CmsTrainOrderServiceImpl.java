package com.sun3d.why.service.train.impl;

import com.sun3d.why.dao.train.CmsTrainOrderMapper;
import com.sun3d.why.model.train.CmsTrainOrder;
import com.sun3d.why.service.train.CmsTrainOrderService;
import org.springframework.beans.factory.annotation.Autowired;

public class CmsTrainOrderServiceImpl implements CmsTrainOrderService {

    @Autowired
    private CmsTrainOrderMapper mapper;


    @Override
    public int deleteByPrimaryKey(String id) {
        return 0;
    }

    @Override
    public int insert(CmsTrainOrder record) {
        return 0;
    }

    @Override
    public int insertSelective(CmsTrainOrder record) {
        return 0;
    }

    @Override
    public CmsTrainOrder selectByPrimaryKey(String id) {
        return null;
    }

    @Override
    public int updateByPrimaryKeySelective(CmsTrainOrder record) {
        return 0;
    }

    @Override
    public int updateByPrimaryKey(CmsTrainOrder record) {
        return 0;
    }
}
