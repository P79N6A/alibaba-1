package com.sun3d.why.service.impl;

import com.sun3d.why.dao.*;
import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.BookActivitySeatInfo;
import com.sun3d.why.service.*;
import com.sun3d.why.util.*;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;


@Transactional(rollbackFor=Exception.class)
@Service
public class CmsListRecommendTagServiceImpl implements CmsListRecommendTagService {


    private Logger logger = Logger.getLogger(CmsListRecommendTagServiceImpl.class);

    @Autowired
    private CmsListRecommendTagMapper cmsListRecommendTagMapper;


    @Override
    public int  addCmsListRecommendTag(String activityType , SysUser sysUser){
            /*  先删除再向表中插入数据*/
        //step1：查出表中所有的记录
        List<CmsListRecommendTag>  CmsListRecommendTagLists = cmsListRecommendTagMapper.queryCmsListRecommendTagList();

        //step2:删除表中已存在的记录
        if(null !=CmsListRecommendTagLists && !CmsListRecommendTagLists.isEmpty()){
            for(int i=0;i<CmsListRecommendTagLists.size();i++){
                cmsListRecommendTagMapper.deleteCmsListRecommendTagId(CmsListRecommendTagLists.get(i).getListRecommendId());
            }
        }

        //step3：向表中插入数据
        int success = 0;
            if(StringUtils.isNotBlank(activityType)){
                String [] activityTypeTag = activityType.split(",");

                for(int i=0;i<activityTypeTag.length;i++){
                    CmsListRecommendTag cmsListRecommendTag = new CmsListRecommendTag();
                    cmsListRecommendTag.setListRecommendId(UUIDUtils.createUUId());
                    cmsListRecommendTag.setTagId(activityTypeTag[i]);
                    cmsListRecommendTag.setListType(1);
                    cmsListRecommendTag.setListAssortment(1);
                    cmsListRecommendTag.setRecommendUpdateTime(new Date());
                    cmsListRecommendTag.setRecommentUpdateUser(sysUser.getUserId());
                    success+= cmsListRecommendTagMapper.addCmsListRecommendTag(cmsListRecommendTag);
                }
                return success;
            }

                    return 0;

    }


    @Override
    public int  deleteCmsListRecommendTagId(String listRecommendId){

        return cmsListRecommendTagMapper.deleteCmsListRecommendTagId(listRecommendId);

    }



    /**
     * 查询List
     *
     * @return
     */
    @Override
   public  List<CmsListRecommendTag> queryCmsListRecommendTagList(){

        return cmsListRecommendTagMapper.queryCmsListRecommendTagList();

    }
}
