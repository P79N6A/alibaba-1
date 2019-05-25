package com.sun3d.why.service.train.impl;

import com.sun3d.why.dao.train.CmsTrainOrderMapper;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.train.CmsTrainOrder;
import com.sun3d.why.model.train.CmsTrainOrderBean;
import com.sun3d.why.service.train.CmsTrainOrderService;
import com.sun3d.why.util.PaginationApp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
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

    @Override
    public CmsTrainOrder findOrderByUserId(String userId) {
        return mapper.findOrderByUserId(userId);
    }

    @Override
    public List<CmsTrainOrderBean> queryOrderList(CmsTrainOrderBean order, CmsTerminalUser terminalUser, PaginationApp page) {

        return null;
    }
}
