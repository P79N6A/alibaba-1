package com.sun3d.why.dao;



import com.sun3d.why.model.CmsVenueSeat;

import java.util.List;
import java.util.Map;

public interface CmsVenueSeatMapper {

    /**
     * 新增一条完整的场馆座位信息
     *
     * @param record CmsVenueSeat 场馆座位模型
     * @return int 成功返回1
     */
    int addCmsVenueSeat(CmsVenueSeat record);

    /**
     * 根据场馆座位主键id来修改场馆座位所有信息
     *
     * @param record CmsVenueSeat 场馆座位信息
     * @return int 成功返回1
     */
    int editCmsVenueSeat(CmsVenueSeat record);

    /**
     * 根据场馆座位主键id获取场馆座位信息
     *
     * @param venueSeatId String 场馆座位主键id
     * @return CmsVenueSeat 场馆座位模型
     */
    CmsVenueSeat queryCmsVenueSeatById(String venueSeatId);

    /**
     * 根据map中对应key值传入的参数作为where条件进行带条件分页查询
     * @param map
     * @return
     */
    List<CmsVenueSeat> queryCmsVenueSeatByCondition(Map<String,Object> map);

    /**
     * 根据map中对应key值传入的参数作为where条件进行带条件查询记录个数
     * @param map
     * @return
     */
    int queryCmsVenueSeatCountByCondition(Map<String,Object> map);

    /**
     * 根据条件删除座位信息
     * @param cmsVenueSeat
     * @return
     */
    int deleteVenueSeat(CmsVenueSeat cmsVenueSeat);
}