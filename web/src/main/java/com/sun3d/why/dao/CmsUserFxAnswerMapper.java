package com.sun3d.why.dao;

import com.sun3d.why.model.CmsUserFxAnswer;

public interface CmsUserFxAnswerMapper {
    int deleteById(String userId);

    int insert(CmsUserFxAnswer record);

    CmsUserFxAnswer selectById(String userId);

    int updateById(CmsUserFxAnswer record);
    
    CmsUserFxAnswer statisticsFxAnswer(CmsUserFxAnswer cmsUserFxAnswer);
}