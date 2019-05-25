package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.culturecloud.model.bean.special.CcpSpecialPage;
import com.culturecloud.model.bean.special.CcpSpecialPageActivity;
import com.sun3d.why.dao.dto.CcpSpecialPageDto;

public interface CcpSpecialPageMapper {
    int deleteByPrimaryKey(String pageId);

    int insert(CcpSpecialPage record);

    CcpSpecialPage selectByPrimaryKey(String pageId);

    int update(CcpSpecialPage record);
    
    int queryPageCountByCondition(Map<String, Object> map);

    List<CcpSpecialPageDto> queryPageByCondition(Map<String, Object> map);
    
    int insertActivity(CcpSpecialPageActivity record);
    
    int deleteActivityByPrimaryKey(CcpSpecialPageActivity record);
}