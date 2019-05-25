package com.sun3d.why.dao.ccp;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.ccp.CcpNyImg;

public interface CcpNyImgMapper {
    int deleteByPrimaryKey(String nyImgId);

    int insert(CcpNyImg record);

    CcpNyImg selectByPrimaryKey(String nyImgId);

    int update(CcpNyImg record);

    List<CcpNyImg> selectNyImgList(CcpNyImg record);
    
    int queryNyImgCountByCondition(Map<String, Object> map);
    
    List<CcpNyImg> queryNyImgByCondition(Map<String, Object> map);
}