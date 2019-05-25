package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsReport;

public interface CmsReportMapper {

    int queryReportInformationByCount(Map<String, Object> map);

    List<CmsReport> queryReportInformationByContent(Map<String, Object> map);
    
    int insertReport(CmsReport cmsReport);
}