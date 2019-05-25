
package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsVenueSeatMapper;
import com.sun3d.why.model.CmsVenueSeat;
import com.sun3d.why.service.CmsVenueSeatService;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class CmsVenueSeatServiceImpl implements CmsVenueSeatService {

    @Autowired
    private CmsVenueSeatMapper cmsVenueSeatMapper;

    private Logger logger = Logger.getLogger(CmsVenueSeatServiceImpl.class);

    /**
     * 根据场馆座位ID查询单条座位信息
     * @param venueSeatId
     * @return
     */
    @Override
    public CmsVenueSeat queryVenueSeatById(String venueSeatId) {
        return cmsVenueSeatMapper.queryCmsVenueSeatById(venueSeatId);
    }

    /**
     * 根据分页信息、带条件查询场馆座位数据信息
     * @param CmsVenueSeat
     * @return
     */
    @Override
    public List<CmsVenueSeat> queryCmsVenueSeatByCondition(CmsVenueSeat CmsVenueSeat) {

        Map<String,Object> map = new HashMap<String, Object>();
        List<CmsVenueSeat> list = null;
        try {
            if(CmsVenueSeat.getTemplateId() != null){
                map.put("templateId",CmsVenueSeat.getTemplateId());
            }
            //分页信息
            map.put("firstResult", CmsVenueSeat.getFirstResult());
            map.put("rows",cmsVenueSeatMapper.queryCmsVenueSeatCountByCondition(map));
            list = cmsVenueSeatMapper.queryCmsVenueSeatByCondition(map);
        } catch (Exception e) {
            logger.error("带条件查询场馆座位时出错",e);
        }
        return list;
    }

    /**
     * 场馆座位条数
     * @param map
     * @return int 条数
     */
    @Override
    public int queryCmsVenueSeatCountByCondition(Map<String, Object> map) {

        return cmsVenueSeatMapper.queryCmsVenueSeatCountByCondition(map);
    }

    /**
     * 添加场馆座位信息
     * @param cmsVenueSeat
     * @return
     */
    @Override
    public int addVenueSeat(CmsVenueSeat cmsVenueSeat) {

        return cmsVenueSeatMapper.addCmsVenueSeat(cmsVenueSeat);
    }

    /**
     * 更新场馆座位信息
     * @param cmsVenueSeat
     * @return
     */
    @Override
    public int editVenueSeat(CmsVenueSeat cmsVenueSeat) {

        return cmsVenueSeatMapper.editCmsVenueSeat(cmsVenueSeat);
    }


    /**
     * 根据场馆座位状态查询特定的座位列表
     * @param venueId
     * @param venueStatus
     * @return
     */
    public List<CmsVenueSeat> queryVenueSeatByStatus(String venueId,Integer venueStatus){
        Map<String,Object> map = new HashMap<String, Object>();
        List<CmsVenueSeat> list = null;
        try {
            if(venueId != null){
                map.put("venueId",venueId);
            }
            if(venueStatus != null){
                map.put("venueStatus",venueStatus);
            }
            //分页信息
            map.put("firstResult", 0);
            map.put("rows",cmsVenueSeatMapper.queryCmsVenueSeatCountByCondition(map));
            list = cmsVenueSeatMapper.queryCmsVenueSeatByCondition(map);
        } catch (Exception e) {
            logger.error("带条件查询场馆座位时出错",e);
        }
        return list;
    }

     /**
     * 根据条件删除座位信息
     * @param cmsVenueSeat
     * @return
     */
     public int deleteVenueSeat(CmsVenueSeat cmsVenueSeat){

        return cmsVenueSeatMapper.deleteVenueSeat(cmsVenueSeat);
     }

}
