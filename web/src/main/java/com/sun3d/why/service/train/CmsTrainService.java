package com.sun3d.why.service.train;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.train.*;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;

import java.util.List;
import java.util.Map;

/**
 * Created by ct on 16/9/27.
 */
public interface CmsTrainService
{
    int deleteByPrimaryKey(String id);

    int insert(CmsTrain record);

    int insertSelective(CmsTrain record);

    CmsTrainBean selectByPrimaryKey(String id, String userId);

    int updateByPrimaryKeySelective(CmsTrain record);

    int updateByPrimaryKey(CmsTrain record);

    String queryTrainList(CmsTrainBean train, CmsTerminalUser user, PaginationApp paginationApp);

    String queryTrainFieldListByTrainId(String id);

    List<CmsTrainOrderBean> queryTrainOrderList(CmsTrainOrderBean orderBean);

    String saveOrder(CmsTrainOrderBean order, CmsTerminalUser user);

    String checkEntry(CmsTrainBean trainBean);

    CmsTrainOrder queryTrainOrderById(String id);

    List<CmsTrainField> queryFieldListByTrainId(String trainId);

    List<CmsTrainOrderBean> queryCenterTrainOrderList(Map<String, Object> map, Pagination page);

    List<CmsTrainOrderBean> queryTrainOrderListByCreateUser(String userId);

    List<CmsTrainBean> queryTrainList1();

    CmsTrainBean queryTrainById(String advertUrl);

    List<CmsTrainBean> pcnewVenue(int i);

    String queryTrainList2(Integer typeStatus, CmsTrainBean train, CmsTerminalUser terminalUser, PaginationApp pageApp);
}
