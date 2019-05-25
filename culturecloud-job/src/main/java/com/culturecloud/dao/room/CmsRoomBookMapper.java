package com.culturecloud.dao.room;

import com.culturecloud.model.bean.room.CmsRoomBook;

public interface CmsRoomBookMapper {
   
	int addCmsRoomBook(CmsRoomBook record);
	
	 /**
     * 判断数据是否重复使用
     * @param cmsRoomBook
     * @return
     */
    int queryCmsRoomBookCount(CmsRoomBook cmsRoomBook);
}