package com.sun3d.why.dao;

import com.sun3d.why.model.CmsUserCnAnswer;

public interface CmsUserCnAnswerMapper {
    int deleteById(String userId);

    int insert(CmsUserCnAnswer record);

    CmsUserCnAnswer selectById(String userId);

    int updateById(CmsUserCnAnswer record);
    
    CmsUserCnAnswer statisticsCnAnswer(CmsUserCnAnswer cmsUserCnAnswer);
}