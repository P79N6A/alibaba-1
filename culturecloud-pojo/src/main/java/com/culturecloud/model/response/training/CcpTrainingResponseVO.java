package com.culturecloud.model.response.training;

import com.culturecloud.model.bean.training.CcpTraining;
import org.apache.commons.beanutils.PropertyUtils;

import java.lang.reflect.InvocationTargetException;


public class CcpTrainingResponseVO extends CcpTraining {

    private static final long serialVersionUID = -6659443978184715610L;

    public CcpTrainingResponseVO(CcpTraining ccpTraining){
        try {
            PropertyUtils.copyProperties(this, ccpTraining);
        } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
            e.printStackTrace();
        }
    }
}
