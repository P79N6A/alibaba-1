package com.sun3d.why.dao;

import java.util.List;

import com.sun3d.why.model.WechatPrize;

public interface WechatPrizeMapper {
    int deleteByPrimaryKey(String prizeId);

    int insert(WechatPrize record);

    WechatPrize selectByPrimaryKey(String prizeId);
    
    int update(WechatPrize record);
    
    List<WechatPrize> selectWechatPrizeByCondition(WechatPrize record);
}