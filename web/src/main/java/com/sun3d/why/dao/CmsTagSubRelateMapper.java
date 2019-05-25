package com.sun3d.why.dao;


import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsTagSubRelate;

public interface CmsTagSubRelateMapper {

    int addCmsTagSubRelate(CmsTagSubRelate record);

    List<CmsTagSubRelate> queryCmsTagSubRelateByCmsTagSubRelate(CmsTagSubRelate CmsTagSubRelate);

    int editByCmsTagSubRelate(CmsTagSubRelate record);

    List<CmsTagSubRelate> queryCmsTagSubRelateByMap(Map map);

    int deleteByMap(Map map);
}