package com.sun3d.why.service.train.impl;

import com.alibaba.fastjson.JSONArray;
import com.sun3d.why.dao.train.CmsTrainFieldMapper;
import com.sun3d.why.dao.train.CmsTrainMapper;
import com.sun3d.why.dao.train.CmsTrainOrderMapper;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.train.*;
import com.sun3d.why.service.train.CmsTrainService;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.SmsUtil;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import java.util.*;

/**
 * Created by ct on 18/4/25.
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class CmsTrainServiceImpl implements CmsTrainService {
    private Logger log = LoggerFactory.getLogger(this.getClass());

    @Autowired
    CmsTrainMapper mapper;

    @Autowired
    CmsTrainFieldMapper fieldMapper;

    @Autowired
    CmsTrainOrderMapper orderMapper;


    @Override
    public int deleteByPrimaryKey(String id) {
        return 0;
    }

    @Override
    public int insert(CmsTrain record) {
        return 0;
    }

    @Override
    public int insertSelective(CmsTrain record) {
        return mapper.insertSelective(record);
    }

    @Override
    public CmsTrainBean selectByPrimaryKey(String id) {
        return mapper.selectByPrimaryKey(id);
    }

    @Override
    public int updateByPrimaryKeySelective(CmsTrain record) {
        return mapper.updateByPrimaryKeySelective(record);
    }

    @Override
    public int updateByPrimaryKey(CmsTrain record) {
        return 0;
    }


    @Override
    public String save(CmsTrain bloBs, String fieldStr, SysUser sysUser) {
        try {
            if (StringUtils.isNotBlank(bloBs.getId())) {
                bloBs.setUpdateUser(sysUser.getUserId());
                bloBs.setUpdateTime(new Date());
                updateByPrimaryKeySelective(bloBs);
                //培训修改为下架,取消所有培训订单
                if(bloBs.getTrainStatus()!=null && bloBs.getTrainStatus()==2){
                    unsubscribeTrainOrder(bloBs);
                }
            } else {
                bloBs.setId(UUIDUtils.createUUId());
                bloBs.setCreateUser(sysUser.getUserId());
                bloBs.setCreateTime(new Date());
                bloBs.setUpdateTime(new Date());
                insertSelective(bloBs);
            }

            //更新培训场次信息
            List<CmsTrainField> list = new ArrayList<>();
            if (StringUtils.isNotBlank(fieldStr)) {
                fieldMapper.deleteByTrainId(bloBs.getId());
                JSONArray arr = JSONArray.parseArray(fieldStr);
                for (int i = 0; i < arr.size(); i++) {
                    CmsTrainField field = new CmsTrainField();
                    String fieldTimeStr = arr.getJSONObject(i).getString("fieldTimeStr");
                    field.setFieldStartTime(arr.getJSONObject(i).getString("fieldStartTime"));
                    field.setFieldEndTime(arr.getJSONObject(i).getString("fieldEndTime"));
                    field.setFieldTimeStr(fieldTimeStr);
                    field.setId(UUIDUtils.createUUId());
                    field.setTrainId(bloBs.getId());
                    list.add(field);
                }
            } else {
                if(StringUtils.isNotBlank(bloBs.getTrainStartTime())&&StringUtils.isNotBlank(bloBs.getTrainEndTime())){
                    fieldMapper.deleteByTrainId(bloBs.getId());
                    CmsTrainField field = new CmsTrainField();
                    field.setTrainId(bloBs.getId());
                    field.setId(UUIDUtils.createUUId());
                    field.setFieldStartTime(bloBs.getTrainStartTime());
                    field.setFieldEndTime(bloBs.getTrainEndTime());
                    list.add(field);
                }
            }
            if(list.size()>0)  fieldMapper.insertTrainTimes(list);
            return JSONResponse.getResult(200, "success");
        } catch (Exception e) {
            log.error("发布培训失败：", e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            return JSONResponse.getResult(500, "培训操作异常");
        }
    }

    private void unsubscribeTrainOrder(CmsTrain bloBs) {
        List<CmsTrainOrderBean> orders = orderMapper.queryTrainOrderListByTrain(bloBs);
        for (final CmsTrainOrderBean order : orders) {
            //取消订单
            order.setState(2);
            order.setUpdateUser(bloBs.getUpdateUser());
            order.setUpdateTime(new Date());
            orderMapper.updateByPrimaryKeySelective(order);

            //发送短信：亲爱的${name}，您报名的培训“${trainTitle}”因故取消，系统已为您自动取消订单，因此为您带来的不便，请您谅解
            Map<String, Object> smsParams = new HashMap<>();
            smsParams.put("name", order.getName());
            smsParams.put("trainTitle", order.getTrainTitle());
            SmsUtil.trainOrderUnsubscribe(order.getPhoneNum(), smsParams);
            //log.info("培训下架订单’"+order.getOrderNum()+"‘短信发送结果:"+sendMsg);
        }
    }

    @Override
    public List<CmsTrainBean> queryTrainList(CmsTrainBean train,SysUser sysUser) {
        Map<String,Object> map = new HashMap<>();
        if(StringUtils.isNotBlank(train.getTrainTitle())){
            map.put("trainTitle",train.getTrainTitle());
        }
        if(StringUtils.isNotBlank(train.getVenueId())){
            map.put("venueId",train.getVenueId());
        }
        if(StringUtils.isNotBlank(train.getVenueName())){
            map.put("venueName",train.getVenueName());
        }
        if(StringUtils.isNotBlank(train.getTrainType())){
            map.put("trainType",train.getTrainType());
        }
        if(StringUtils.isNotBlank(train.getTrainTag())){
            map.put("trainTag",train.getTrainTag());
        }
        if(train.getTrainField()!=null){
            map.put("trainField",train.getTrainField());
        }
        if(train.getAdmissionType()!=null){
            map.put("admissionType",train.getAdmissionType());
        }
        if(train.getTrainStatus()!=null){
            map.put("trainStatus",train.getTrainStatus());
        }
        if(StringUtils.isNotBlank(train.getTrainStartTime())){
            map.put("trainStartTime",train.getTrainStartTime());
        }
        if (StringUtils.isNotBlank(train.getTrainEndTime())) {
            map.put("trainEndTime", train.getTrainEndTime()+" 23:59:59");
        }
        if (StringUtils.isNotBlank(train.getState())) {
            map.put("state", train.getState());
        }
        if (StringUtils.isNotBlank(train.getIsBalance())) {
            map.put("isBalance", train.getIsBalance());
        }
        if(train.getTrainTimeDetails()!=null){
            map.put("trainTimeDetails",train.getTrainTimeDetails());
        }
        if(StringUtils.isNotBlank(train.getTrainTag())){
            map.put("trainTag",train.getTrainTag());
        }
        if(StringUtils.isNotBlank(train.getVenueType())){
            map.put("venueType",train.getVenueType());
        }
        if(StringUtils.isNotBlank(train.getTrainArea())){
            map.put("area",train.getTrainArea());
        }
        if(StringUtils.isNotBlank(sysUser.getUserDeptId())){
            map.put("deptId",sysUser.getUserDeptId());
        }
        if(sysUser.getUserIsManger() != null){
            map.put("userIsManger",sysUser.getUserIsManger());
        }
        map.put("isDelete", 1);
        //分页
        if (train.getFirstResult() != null && train.getRows() != null) {
            map.put("firstResult", train.getFirstResult());
            map.put("rows", train.getRows());
            int total = mapper.queryTrainListCount(map);
            train.setTotal(total);
        }
        List<CmsTrainBean> trainList = mapper.queryTrainList(map);
        for (CmsTrainBean bean: trainList) {
            String area = bean.getTrainArea().split(",")[1];
            bean.setTrainArea(area);
        }
        return trainList;
    }

    /**
     * 获取培训场次列表
     * @param trainId
     * @return
     */
    @Override
    public List<CmsTrainField> queryTrainFieldListByTrainId(String trainId) {
        List<CmsTrainField> fields = fieldMapper.queryTrainFieldListByTrainId(trainId);
        return fields;
    }

    /**
     * 培训报名管理
     * @param orderBean
     * @return
     */
    @Override
    public List<CmsTrainOrderBean> queryTrainOrderList(CmsTrainOrderBean orderBean,SysUser sysUser) {
        Map<String,Object> map = new HashMap<>();
        if(StringUtils.isNotBlank(orderBean.getOrderNum())){
            map.put("orderNum",orderBean.getOrderNum());
        }
        if(StringUtils.isNotBlank(orderBean.getPhoneNum())){
            map.put("phoneNum",orderBean.getPhoneNum());
        }
        if(StringUtils.isNotBlank(orderBean.getIdCard())){
            map.put("idCard",orderBean.getIdCard());
        }
        if(orderBean.getState()!=null){
            map.put("state",orderBean.getState());
        }
        if(StringUtils.isNotBlank(orderBean.getTrainId())){
            map.put("trainId",orderBean.getTrainId());
        }
        if(orderBean.getCourseType()!=null){
            map.put("courseType",orderBean.getCourseType());
        }
        if(StringUtils.isNotBlank(orderBean.getOrderStartTime())){
            map.put("orderStartTime",orderBean.getOrderStartTime());
        }
        if(StringUtils.isNotBlank(orderBean.getOrderEndTime())){
            map.put("orderEndTime",orderBean.getOrderEndTime());
        }
        if(orderBean.getSex() != null){
            map.put("sex",orderBean.getSex());
        }
        if(StringUtils.isNotBlank(sysUser.getUserDeptId())){
            map.put("deptId",sysUser.getUserDeptId());
        }
        if(sysUser.getUserIsManger() != null){
            map.put("userIsManger",sysUser.getUserIsManger());
        }
        if (orderBean.getRows() != null && orderBean.getFirstResult() != null) {
            map.put("firstResult", orderBean.getFirstResult());
            map.put("rows", orderBean.getRows());
            int total = orderMapper.queryTrainOrderListCount(map);
            orderBean.setTotal(total);
        }
        return orderMapper.queryTrainOrderList(map);
    }

    @Override
    public String saveOrder(final CmsTrainOrderBean order, SysUser sysUser) {
        try {
            order.setUpdateUser(sysUser.getUserId());
            int res = orderMapper.updateByPrimaryKeySelective(order);
            final CmsTrainOrder trainOrder = orderMapper.selectByPrimaryKey(order.getId());
            final CmsTrain train = mapper.selectByPrimaryKey(trainOrder.getTrainId());
            if (order.getState() == 1 && res >= 1) {
                Runnable runnable = new Runnable() {
                    @Override
                    public void run() {
                        Map<String, Object> params = new HashMap<>();
/*                        if(train.getCourseType().equals("2")){
                            params.put("courseType", "春季班");
                        }else{
                            params.put("courseType", "秋季班");
                        }*/
                        params.put("trainTitle", train.getTrainTitle());
                        params.put("trainStartTime", train.getTrainStartTime().split(" ")[0]);
                        params.put("trainAddress", train.getTrainAddress());
                        SmsUtil.sendTrainEntrySuccess(trainOrder.getPhoneNum(), params);
                    }
                };
                Thread thread = new Thread(runnable);
                thread.start();
            }
            if(order.getState()==2 && res >= 1){
                Runnable runnable = new Runnable() {
                    @Override
                    public void run() {
                Map<String, Object> params = new HashMap<>();
/*                if(train.getCourseType().equals("2")){
                    params.put("courseType", "春季班");
                }else{
                    params.put("courseType", "秋季班");
                }*/
                params.put("trainTitle", train.getTrainTitle());
                //params.put("trainStartTime", train.getTrainStartTime().split(" ")[0]);
                SmsUtil.sendTrainUnsubscribe(trainOrder.getPhoneNum(), params);
                    }
                };
                Thread thread = new Thread(runnable);
                thread.start();
            }
            return JSONResponse.getResult(200, "操作成功");
        }catch (Exception e){
            e.printStackTrace();
            return JSONResponse.getResult(500, "操作订单异常");
        }
    }

    @Override
    public List<CmsTrainOrderBean> selectAllOrder() {
        return orderMapper.selectAllOrder();
    }

    @Override
    public List<CmsTrainBean> queryTrainListPc(CmsTrainBean train) {
        Map<String,Object> map = new HashMap<>();
        if(StringUtils.isNotBlank(train.getTrainTitle())){
            map.put("trainTitle",train.getTrainTitle());
        }
        if(StringUtils.isNotBlank(train.getVenueId())){
            map.put("venueId",train.getVenueId());
        }
        if(StringUtils.isNotBlank(train.getVenueName())){
            map.put("venueName",train.getVenueName());
        }
        if(StringUtils.isNotBlank(train.getTrainType())){
            map.put("trainType",train.getTrainType());
        }
        if(StringUtils.isNotBlank(train.getTrainTag())){
            map.put("trainTag",train.getTrainTag());
        }
        if(train.getTrainField()!=null){
            map.put("trainField",train.getTrainField());
        }
        if(train.getAdmissionType()!=null){
            map.put("admissionType",train.getAdmissionType());
        }
        if(train.getTrainStatus()!=null){
            map.put("trainStatus",train.getTrainStatus());
        }
        if(StringUtils.isNotBlank(train.getTrainStartTime())){
            map.put("trainStartTime",train.getTrainStartTime());
        }
        if (StringUtils.isNotBlank(train.getTrainEndTime())) {
            map.put("trainEndTime", train.getTrainEndTime()+" 23:59:59");
        }
        if (StringUtils.isNotBlank(train.getState())) {
            map.put("state", train.getState());
        }
        if (StringUtils.isNotBlank(train.getIsBalance())) {
            map.put("isBalance", train.getIsBalance());
        }
        if(train.getTrainTimeDetails()!=null){
            map.put("trainTimeDetails",train.getTrainTimeDetails());
        }
        if(StringUtils.isNotBlank(train.getTrainTag())){
            map.put("trainTag",train.getTrainTag());
        }
        if(StringUtils.isNotBlank(train.getArea())){
            map.put("area",train.getArea());
        }
        map.put("isDelete", 1);
        //分页
        if (train.getFirstResult() != null && train.getRows() != null) {
            map.put("firstResult", train.getFirstResult());
            map.put("rows", train.getRows());
            int total = mapper.queryTrainListCountPc(map);
            train.setTotal(total);
        }
        return mapper.queryTrainListPc(map);
    }
}
