package com.sun3d.why.dao.ccp;

import com.sun3d.why.model.ccp.CcpPoemStatistics;

public interface CcpPoemStatisticsMapper {
    int deleteByPrimaryKey(String id);

    int insert(CcpPoemStatistics record);

    CcpPoemStatistics selectByPrimaryKey(String id);

    int update(CcpPoemStatistics record);
    
    CcpPoemStatistics queryPoemStatisticsByDate(String date);

}