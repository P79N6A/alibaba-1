package com.culturecloud.model.response.advert;

import com.culturecloud.model.bean.advert.CcpAdvertRecommend;
import org.apache.commons.beanutils.PropertyUtils;

import java.lang.reflect.InvocationTargetException;

public class CcpAdvertVO extends CcpAdvertRecommend{

	private static final long serialVersionUID = -6659443978186715610L;

	public CcpAdvertVO(CcpAdvertRecommend ccpadvertRecommend){
        try {
            PropertyUtils.copyProperties(this, ccpadvertRecommend);
        } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
            e.printStackTrace();
        }
    }
}
