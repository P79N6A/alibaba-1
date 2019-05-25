package com.culturecloud.service.rs.platformservice.training;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.coreutils.UUIDUtils;
import com.culturecloud.exception.BizException;
import com.culturecloud.model.bean.training.CcpTraining;
import com.culturecloud.model.request.training.CcpTrainingVO;
import com.culturecloud.model.response.training.CcpTrainingResponseVO;
import com.culturecloud.service.BaseService;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Component
@Path("/training")
public class CcpTrainingResource {

    @Autowired
    private BaseService baseService;

    @POST
    @Path("/list")
    @SysBusinessLog(remark = "获取培训")
    @Produces(MediaType.APPLICATION_JSON)
    public List<CcpTrainingResponseVO> recommendTraining(CcpTrainingVO request) {
        CcpTraining training = new CcpTraining();
        try {
            PropertyUtils.copyProperties(training, request);
        } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
            e.printStackTrace();
        }
        List<CcpTraining> trainings = new ArrayList<>();
        List<CcpTrainingResponseVO> trainingsVO = new ArrayList<>();
        if (StringUtils.isNotBlank(training.getTrainingId())) {
            trainings = baseService.find(CcpTraining.class, " where TRAINING_ID='" + training.getTrainingId() + "'");
            if (trainings.size() > 0) {
                CcpTrainingResponseVO trainingVO = new CcpTrainingResponseVO(trainings.get(0));
                trainingsVO.add(trainingVO);
            }
        } else {
            trainings = baseService.find(CcpTraining.class, "");
            if (trainings.size() > 0) {
                for (CcpTraining tra : trainings) {
                    CcpTrainingResponseVO trainingVO = new CcpTrainingResponseVO(tra);
                    trainingsVO.add(trainingVO);
                }
            }
        }
        return trainingsVO;
    }

    @POST
    @Path("/change")
    @SysBusinessLog(remark = "增改培训")
    @Produces(MediaType.APPLICATION_JSON)
    public String changeTraining(CcpTrainingVO request) {
        CcpTraining training = new CcpTraining();
        try {
            PropertyUtils.copyProperties(training, request);
        } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
            e.printStackTrace();
        }
        List<CcpTraining> trainings = new ArrayList<>();
        if (StringUtils.isNotBlank(training.getTrainingId())) {
            trainings = baseService.find(CcpTraining.class, " where TRAINING_ID='" + training.getTrainingId() + "'");
            if (trainings.size() > 0) {
                training.setUpdateTime(new Date());
                baseService.update(training," where TRAINING_ID='" + training.getTrainingId() + "'");
            }else{
                BizException.Throw("400", "该培训不存在");
            }
        } else {
            training.setTrainingId(UUIDUtils.createUUId());
            training.setCreateTime(new Date());
            training.setUpdateTime(new Date());
            baseService.create(training);
        }
        return "success";
    }
}
