package com.sun3d.why.dao;

import com.sun3d.why.model.CmsRoomBook;

import java.util.List;
import java.util.Map;

public interface CmsRoomBookMapper {

    int addCmsRoomBook(CmsRoomBook record);

    List<CmsRoomBook> queryCmsRoomBookByCondition(CmsRoomBook cmsRoomBook);

    /**
     * 将查询出的活动室预定数据放入Redis中
     * @param cmsRoomBook
     * @return
     */
    List<String> queryRoomBookDataToRedis(CmsRoomBook cmsRoomBook);

    List<CmsRoomBook> queryRoomBookTableByCondition(CmsRoomBook cmsRoomBook);

    int queryCmsRoomBookCountByCondition(CmsRoomBook cmsRoomBook);

    CmsRoomBook queryCmsRoomBookById(String bookId);

    int editCmsRoomBook(CmsRoomBook record);

    int deleteCmsRoomBookById(String bookId);

    /**
     * app获取活动室开放时间
     * @param cmsRoomBook
     * @return
     */
    List<CmsRoomBook> queryAppRoomBookTableByCondition(CmsRoomBook cmsRoomBook);

    /**
     * 判断数据是否重复使用
     * @param cmsRoomBook
     * @return
     */
    int queryCmsRoomBookCount(CmsRoomBook cmsRoomBook);

    /**
     * app根据条件查询预定活动室信息
     * @param map
     * @return
     */
   public String queryAppRoomBookByCondition(Map<String, Object> map);
}