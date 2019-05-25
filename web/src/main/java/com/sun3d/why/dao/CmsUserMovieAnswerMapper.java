package com.sun3d.why.dao;

import com.sun3d.why.model.CmsUserMovieAnswer;

public interface CmsUserMovieAnswerMapper {
    int deleteById(String userId);

    int insert(CmsUserMovieAnswer record);

    CmsUserMovieAnswer selectById(String userId);

    int updateById(CmsUserMovieAnswer record);
    
    CmsUserMovieAnswer statisticsMovieAnswer(CmsUserMovieAnswer cmsUserMovieAnswer);
}