package com.sun3d.why.service.train;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.train.CmsTrainOrder;
import com.sun3d.why.model.train.CmsTrainOrderBean;
import com.sun3d.why.util.PaginationApp;

import java.util.List;

/**
 * Created by ct on 16/9/27.
 */
public interface CmsTrainOrderService
{
    int deleteByPrimaryKey(String id);

    int insert(CmsTrainOrder record);

    int insertSelective(CmsTrainOrder record);

    CmsTrainOrder selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(CmsTrainOrder record);

    int updateByPrimaryKey(CmsTrainOrder record);

    CmsTrainOrder findOrderByUserId(String userId);

    List<CmsTrainOrderBean> queryOrderList(CmsTrainOrderBean order, CmsTerminalUser terminalUser, PaginationApp page);
}
