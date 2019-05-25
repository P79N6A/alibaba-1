package com.sun3d.why.service;

import com.sun3d.why.model.CmsCollect;

import java.util.List;
import java.util.Map;

public interface CollectService {
 /**
  * 保存用户收藏表信息 
  * @param cmsCollect
  * @return
  */
public	int insertSelective(CmsCollect cmsCollect);
/**
 * 根据id获取用户收藏信息
 * @param cmsCollect
 * @return
 */
public CmsCollect selectBycmsCollect(CmsCollect cmsCollect);
/**
 * 检查用户是否已经收藏
 * @param cmsCollect
 * @return
 */
public boolean checkCollect(CmsCollect cmsCollect);

/**
 * 前端2.0删除收藏
 * @param collect
 * @return
 */
public int deleteCollectByCondition(CmsCollect collect);


public int getHotNum(String relateId,int type);


 public int isHadCollect(String relateId,int type,String userId);

 public int queryCountByCollect(Map map);

 public List<CmsCollect> queryByCmsCollect(CmsCollect record) ;

 public int queryCountByCmsCollect(CmsCollect record);

}
