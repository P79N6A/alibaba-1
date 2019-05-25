package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsCollectMapper;
import com.sun3d.why.model.CmsCollect;
import com.sun3d.why.service.CollectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 模块服务层实现类
 * 事务管理层
 * 需要用到事务的功能都在此编写
 *
 * author wangkun
 */
@Service
@Transactional
public class CollectServiceImpl implements CollectService {
    /**
     * 自动注入数据操作层dao实例
     */
    @Autowired
    private CmsCollectMapper cmsCollectMapper;

	@Override
	public int insertSelective(CmsCollect cmsCollect) {
        if(cmsCollect!=null){
        	  //cmsCollect.setRelateId(UUIDUtils.createUUId());
        	  return cmsCollectMapper.insertSelective(cmsCollect);
        }else{
		return 0;
	    }
	}

	@Override
	public boolean checkCollect(CmsCollect cmsCollect) {
	    int count=cmsCollectMapper.checkCollect(cmsCollect);
	    if(count>0){
		return true;
	} else{
		return false;
	}
	}

	@Override
	public CmsCollect selectBycmsCollect(CmsCollect cmsCollect) {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * 前端2.0删除收藏
	 * @param collect
	 * @return
	 */
	@Override
	public int deleteCollectByCondition(CmsCollect collect) {
		return cmsCollectMapper.deleteCollectByCondition(collect);
	}

	@Override
	public int getHotNum(String relateId,int type) {
		CmsCollect cmsCollect = new CmsCollect();
		cmsCollect.setRelateId(relateId);
		cmsCollect.setType(type);
		return cmsCollectMapper.getHotNum(cmsCollect);
	}


	@Override
	public int isHadCollect(String relateId,int type,String userId) {
		Map map = new HashMap();
		map.put("userId",userId);
		map.put("type",type);
		map.put("relateId",relateId);
		return cmsCollectMapper.isHadCollect(map);
	}

	public int queryCountByCollect(Map map) {
		return cmsCollectMapper.isHadCollect(map);
	}

	public List<CmsCollect> queryByCmsCollect(CmsCollect record) {
		return cmsCollectMapper.queryByCmsCollect(record);
	}

	public int queryCountByCmsCollect(CmsCollect record) {
		return cmsCollectMapper.queryCountByCmsCollect(record);
	}
}
