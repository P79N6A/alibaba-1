package com.sun3d.why.service;


import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.ccp.CcpAdvertRecommend;

import java.util.List;

public interface CcpAdvertRecommendService {
    /**
     * 查询运营信息
     * @param adverts
     * @return
     */
    List<CcpAdvertRecommend> queryCcpAdvertRecommend(CcpAdvertRecommend adverts);


    /**
     * 新增运营信息
     * @param adverts
     * @return
     */
    int insertAdvert(CcpAdvertRecommend adverts, SysUser sysUser);


    /**
     * 更新运营信息
     * @param adverts
     * @return
     */
    int updateAdvert(CcpAdvertRecommend adverts, SysUser sysUser);

    int deleteAdvert(CcpAdvertRecommend adverts);

}
