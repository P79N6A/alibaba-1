package com.sun3d.why.service.train;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.train.CmsTrain;
import com.sun3d.why.model.train.CmsTrainBean;
import com.sun3d.why.model.train.CmsTrainField;
import com.sun3d.why.model.train.CmsTrainOrderBean;

import java.util.List;

/**
 * Created by ct on 16/9/27.
 */
public interface CmsTrainService
{
    int deleteByPrimaryKey(String id);

    int insert(CmsTrain record);

    int insertSelective(CmsTrain record);

    CmsTrainBean selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(CmsTrain record);

    int updateByPrimaryKey(CmsTrain record);

    String save(CmsTrain bloBs, String fieldStr, SysUser sysUser);

    List<CmsTrainBean> queryTrainList(CmsTrainBean train,SysUser sysUser);

    List<CmsTrainField> queryTrainFieldListByTrainId(String id);

    List<CmsTrainOrderBean> queryTrainOrderList(CmsTrainOrderBean orderBean,SysUser sysUser);

    String saveOrder(CmsTrainOrderBean order, SysUser sysUser);

    List<CmsTrainOrderBean> selectAllOrder();

    List<CmsTrainBean> queryTrainListPc(CmsTrainBean train);
}
