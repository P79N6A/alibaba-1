package com.sun3d.why.service.train.impl;

import com.alibaba.fastjson.JSONArray;
import com.sun3d.why.dao.train.CmsTrainEnrolmentMapper;
import com.sun3d.why.dao.train.CmsTrainFieldMapper;
import com.sun3d.why.dao.train.CmsTrainMapper;
import com.sun3d.why.dao.train.CmsTrainOrderMapper;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.train.*;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.train.CmsTrainService;
import com.sun3d.why.util.*;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
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

    @Autowired
    private CacheService cacheService;

    @Autowired
    private com.sun3d.why.util.SmsUtil SmsUtil;

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

    @Autowired
    private CmsTrainEnrolmentMapper enrolmentMapper;

    @Override
    public CmsTrainBean selectByPrimaryKey(String id, String userId) {
        CmsTrainBean trainBean = mapper.selectByPrimaryKey(id, userId);
        if(trainBean.getTrainTag().contains(",")){
            String tag = trainBean.getTrainTag().split(",")[0];
            trainBean.setTrainTag(tag);
        }
        if(trainBean.getVenueName() == null || trainBean.getVenueName() == ""){
            trainBean.setVenueName("点击查看地图");
        }
        return trainBean;
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
    public List<CmsTrainBean> queryTrainList1() {
        List<CmsTrainBean> list = mapper.queryTrainList1();
        return list;
    }

    @Override
    public String queryTrainList(CmsTrainBean train, CmsTerminalUser user, PaginationApp paginationApp) {
        Map<String, Object> map = new HashMap<>();
        if (StringUtils.isNotBlank(train.getTrainTitle())) {
            map.put("trainTitle", train.getTrainTitle());
        }
        if (StringUtils.isNotBlank(train.getVenueId())) {
            map.put("venueId", train.getVenueId());
        }
        if (StringUtils.isNotBlank(train.getTrainType())) {
            map.put("trainType", train.getTrainType());
        }
        if (StringUtils.isNotBlank(train.getTrainTag())) {
            map.put("trainTag", train.getTrainTag());
        }
        if (train.getTrainField() != null) {
            map.put("trainField", train.getTrainField());
        }
        if (train.getAdmissionType() != null) {
            map.put("admissionType", train.getAdmissionType());
        }
        if (train.getTrainStatus() != null) {
            map.put("trainStatus", train.getTrainStatus());
        }
        if (StringUtils.isNotBlank(train.getTrainStartTime())) {
            map.put("trainStartTime", train.getTrainStartTime());
        }
        if (StringUtils.isNotBlank(train.getTrainEndTime())) {
            map.put("trainEndTime", train.getTrainEndTime());
        }
        if (StringUtils.isNotBlank(train.getState())) {
            map.put("state", train.getState());
        }
        if (train.getOrder() != null) {
            map.put("order", train.getOrder());
        }
        if (user != null) {
            map.put("userId", user.getUserId());
        }
        if (StringUtils.isNotBlank(train.getTrainArea())) {
            map.put("trainArea", train.getTrainArea());
        }
        if (StringUtils.isNotBlank(train.getTrainLocation())) {
            map.put("trainLocation", train.getTrainLocation());
        }
        map.put("isDelete", 1);
        //分页
        if (paginationApp.getFirstResult() != null && paginationApp.getRows() != null) {
            map.put("firstResult", paginationApp.getFirstResult());
            map.put("rows", paginationApp.getRows());
            int total = mapper.queryTrainListCount(map);
            train.setTotal(total);
        }
        Pagination page = new Pagination();
        page.setTotal(train.getTotal());
        page.setRows(paginationApp.getRows());
        page.setPage(paginationApp.getPage());
        paginationApp.setTotal(train.getTotal());
        return JSONResponse.toResultFormat(0, mapper.queryTrainList(map),page);
    }

    /**
     * 获取培训场次列表
     *
     * @param trainId
     * @return
     */
    @Override
    public String queryTrainFieldListByTrainId(String trainId) {
        List<CmsTrainField> fields = fieldMapper.queryTrainFieldListByTrainId(trainId);
        String dd = "";
        String week = "";
        String dstr = "";
        String year = "", mouth = "", date = "";
        Map<String, Object> map = new HashMap<>();
        List<Object> dstrs = new ArrayList<>();
        List<Object> list = new ArrayList<>();
        Map<String, Object> tmp = new HashMap<>();
        for (CmsTrainField field : fields) {
            tmp = new HashMap<>();
            String tmpDD = "";
            String fieldTimeStr = "";
            if (StringUtils.isNotBlank(field.getFieldTimeStr())) {
                fieldTimeStr = field.getFieldTimeStr();
            } else {
                fieldTimeStr = DateUtil.dateToString(field.getFieldStartTime(), "yyyy-MM-dd HH:mm");
                fieldTimeStr += "-" + DateUtil.dateToString(field.getFieldEndTime(), "yyyy-MM-dd HH:mm").substring(11, 16);
            }
            year = fieldTimeStr.substring(0, 4);
            mouth = fieldTimeStr.substring(5, 7);
            String day = fieldTimeStr.substring(8, 10);
            date = fieldTimeStr.substring(0, 10);
            try {
                tmpDD = year + "年" + mouth + "月";
                Date date1 = DateUtil.stringToDate(date, "yyyy-MM-dd");
                if (date1.before(new Date())) {
                    tmp.put("flag", 1);
                } else {
                    tmp.put("flag", 0);
                }
                week = DateUtil.getDayOfWeek(date1, 1);
                if (StringUtils.isBlank(dd)) {
                    dd = tmpDD;
                    tmp.put("str", mouth + "月" + day + "日（周" + week + ") " + fieldTimeStr.substring(11, 22));
                    dstrs.add(tmp);
                } else {
                    if (dd.equals(tmpDD)) {
                        tmp.put("str", mouth + "月" + day + "日（周" + week + ") " + fieldTimeStr.substring(11, 22));
                        dstrs.add(tmp);
                    } else {
                        map.put("dateStr", dd);
                        map.put("times", dstrs);
                        list.add(map);

                        map = new HashMap<>();
                        dstrs = new ArrayList<>();
                        dd = tmpDD;
                        tmp.put("str", mouth + "月" + day + "日（周" + week + ") " + fieldTimeStr.substring(11, 22));
                        dstrs.add(tmp);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        map.put("dateStr", dd);
        map.put("times", dstrs);
        list.add(map);
        //String json = JSONObject.toJSONString(map);
        //System.out.println(JSONArray.toJSON(list));
        return JSONArray.toJSON(list).toString();
    }

    /**
     * 培训报名管理
     *
     * @param orderBean
     * @return
     */
    @Override
    public List<CmsTrainOrderBean> queryTrainOrderList(CmsTrainOrderBean orderBean) {
        Map<String, Object> map = new HashMap<>();
        if (StringUtils.isNotBlank(orderBean.getOrderNum())) {
            map.put("orderNum", orderBean.getOrderNum());
        }
        if (StringUtils.isNotBlank(orderBean.getPhoneNum())) {
            map.put("phoneNum", orderBean.getPhoneNum());
        }
        if (StringUtils.isNotBlank(orderBean.getIdCard())) {
            map.put("idCard", orderBean.getIdCard());
        }
        if (orderBean.getState() != null) {
            map.put("state", orderBean.getState());
        }
        if (orderBean.getQueryType() != null) {
            map.put("queryType", orderBean.getQueryType());
        }
        if (orderBean.getCreateUser() != null) {
            map.put("createUser", orderBean.getCreateUser());
        }
        if (orderBean.getFirstResult() != null && orderBean.getRows() != null) {
            map.put("firstResult", orderBean.getFirstResult());
            map.put("rows", orderBean.getRows());
            //int total = orderMapper.queryTrainOrderListCount(map);
            //orderBean.setTotal(total);
        }
        List<CmsTrainOrderBean> orderBeans = orderMapper.queryTrainOrderList(map);
/*        if (StringUtils.isNotBlank(orderBean.getQueryType()) && orderBean.getQueryType().equals("2")) {
            for (CmsTrainOrderBean bean : orderBeans) {
                try {
                    if(bean.getState()==3){
                        bean.setState(4);
                        saveOrder(bean, null);
                        log.info("历史订单修改为审核拒绝:" + bean.getId());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    log.error("历史订单修改为审核拒绝失败:" + bean.getId(), e);
                }
            }
        }*/
        return orderBeans;
    }

    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE)
    public String saveOrder(final CmsTrainOrderBean order, CmsTerminalUser user) {
        CmsTrainOrder orderBean = orderMapper.selectByPrimaryKey(order.getId());
        CmsTrainEnrolment enrolment = enrolmentMapper.selectAll();
        try {
            if (StringUtils.isNotBlank(order.getId())) {
                final CmsTrainBean train = mapper.selectByPrimaryKey(orderBean.getTrainId(), user.getUserId());
                //前台用户修改报名信息
                order.setUpdateUser(user != null ? user.getUserId() : null);
                order.setUpdateTime(new Date());
                int res = orderMapper.updateByPrimaryKeySelective(order);
                if(order.getState()==2 && res >= 1){
                    Map<String, Object> params = new HashMap<>();
/*                    if(train.getCourseType().equals("1")){
                        params.put("courseType", "新春班");
                    }
                    if(train.getCourseType().equals("2")){
                        params.put("courseType", "春季班");
                    }
                    if(train.getCourseType().equals("3")){
                        params.put("courseType", "暑期班");
                    }
                    if(train.getCourseType().equals("4")){
                        params.put("courseType", "秋季班");
                    }*/
                    params.put("trainTitle", train.getTrainTitle());
                    //params.put("trainStartTime", train.getTrainStartTime().split(" ")[0]);
                    SmsUtil.sendTrainUnsubscribe(orderBean.getPhoneNum(), params);
                }
            } else {
                final CmsTrainBean train = mapper.selectByPrimaryKey(order.getTrainId(), user.getUserId());
                //判断时间冲突
                Map<String,Object> orderMap = new HashMap<>();
                // orderMap.put("createUser",user.getUserId());
                orderMap.put("idCard", order.getIdCard());
                List<CmsTrainOrderBean> orderList = orderMapper.queryTrainOrderList(orderMap);
                if(orderList != null){
                    for (CmsTrainOrder trainOrder:orderList ) {
                        if(trainOrder.getState() == 1 || trainOrder.getState() == 3){
                            Map<String,Object> trainListMap = new HashMap<>();
                            trainListMap.put("id",trainOrder.getTrainId());
                            List<CmsTrainBean> trainList = mapper.queryTrainList(trainListMap);
                            for (CmsTrainBean trainBean:trainList) {
                                    SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd hh:mm");
                                    Date trainStart = sdf.parse(train.getTrainStartTime());
                                    Date trainEnd = sdf.parse(train.getTrainEndTime());
                                    Date beanStart = sdf.parse(trainBean.getTrainStartTime());
                                    Date beanEnd = sdf.parse(trainBean.getTrainEndTime());
                                    if((trainStart.before(beanEnd)&&trainStart.after(beanStart))||(beanStart.before(trainEnd)&&beanStart.after(trainStart))||(trainEnd.before(beanEnd)&&trainEnd.after(beanStart))||(beanEnd.before(trainEnd)&&beanEnd.after(trainStart))){
                                        return JSONResponse.getResult(10001, "报名时间与其他课程有冲突！");
                                    }
                            }
                        }
                    }
                }
                if(train.getMaxPeople() != null){
                    //判断余票
                    if (train.getMaxPeople() <= train.getAdmissionsPeoples()) {
                        return JSONResponse.getResult(10002, "报名名额已满！");
                    }
                }
                //判断是否允许报名
                Map<String, Object> map = new HashMap<>();
                map.put("trainId", train.getId());
                map.put("idCard", order.getIdCard());
                // map.put("createUser", user.getUserId());
                Integer userOrderCount = orderMapper.queryTrainOrderListCount(map);
                if (userOrderCount >= 1) {
                    return JSONResponse.getResult(10001, "您已报名该培训，不可重复报名！");
                }
                Map<String,Object> regMap = new HashMap<>();
                regMap.put("regStartTime",train.getRegistrationStartTime());
                regMap.put("regEndTime",train.getRegistrationEndTime());
                regMap.put("location",train.getTrainLocation());
                Integer minSubCount = mapper.queryMinSubCountByRegsitTime(regMap);
                // regMap.put("userId",user.getUserId());
                regMap.put("idCard", order.getIdCard());
                Integer userSubCount = orderMapper.queryUserSubCountByRegsitTime(regMap);
                if(userSubCount >= minSubCount){
                    return JSONResponse.getResult(10001, "同一用户在" + train.getRegistrationStartTime()+"至"+train.getRegistrationEndTime() + "的报名时间段内只能报名参加"+minSubCount+"门培训课程。");
                }
/*                if (StringUtils.isNotBlank(train.getCourseType())) {
                    map.put("courseType", train.getCourseType());
                    map.remove("trainId");
                    map.put("state4",4);
                    map.put("curYear",DateUtil.getCurrDate("YYYY"));
                    userOrderCount = orderMapper.queryTrainOrderListCount(map);
                    //TODO 同一课程类型的培训报名次数后台可配置
                    int subCount = 0;
                    if(train.getCourseType().equals("1")){
                        subCount = enrolment.getNewSpringCount();
                    }
                    if(train.getCourseType().equals("2")){
                        subCount = enrolment.getSpringCount();
                    }
                    if(train.getCourseType().equals("3")){
                        subCount = enrolment.getSummerCount();
                    }
                    if(train.getCourseType().equals("4")){
                        subCount = enrolment.getAutumnCount();
                    }
                    if (userOrderCount >= subCount) {
                        String sourceTypeName = "";
                        switch (train.getCourseType()) {
                            case "1":
                                sourceTypeName =  "新春班";
                                break;
                            case "2":
                                sourceTypeName = "春季班";
                                break;
                            case "3":
                                sourceTypeName = "暑期班";
                                break;
                            case "4":
                                sourceTypeName = "秋季班";
                                break;
                        }
                        return JSONResponse.getResult(10001, "同一用户在" + sourceTypeName + "只能报名参加"+subCount+"门培训课程。");
                    }

                }*/

                //保存报名信息
                if (train.getAdmissionType() == 1) {
                    order.setState(1);
                } else {
                    order.setState(3);
                }
                order.setOrderNum(cacheService.genOrderNumber());
                order.setId(UUIDUtils.createUUId());
                order.setCreateUser(user.getUserId());
                order.setCreateTime(new Date());
                int res = orderMapper.insertSelective(order);
                if (order.getState() == 1 && res >= 1) {
                    Runnable runnable = new Runnable() {
                        @Override
                        public void run() {
                            Map<String, Object> params = new HashMap<>();
/*                            if(train.getCourseType().equals("1")){
                                params.put("courseType", "新春班");
                            }
                            if(train.getCourseType().equals("2")){
                                params.put("courseType", "春季班");
                            }
                            if(train.getCourseType().equals("3")){
                                params.put("courseType", "暑期班");
                            }
                            if(train.getCourseType().equals("4")){
                                params.put("courseType", "秋季班");
                            }*/
                            params.put("trainTitle", train.getTrainTitle());
                            params.put("trainStartTime", train.getTrainStartTime().split(" ")[0]);
                            params.put("trainAddress", train.getTrainAddress());
                            SmsUtil.sendTrainEntrySuccess(order.getPhoneNum(), params);
                        }
                    };
                    Thread thread = new Thread(runnable);
                    thread.start();
                }
            }


            return JSONResponse.getResult(200, order.getId());
        } catch (Exception e) {
            e.printStackTrace();
            return JSONResponse.getResult(500, "操作订单异常");
        }
    }

    @Override
    public String checkEntry(CmsTrainBean bean) {
        if(bean.getMaxPeople() != null){
            if (bean.getAdmissionsPeoples() >= bean.getMaxPeople()) {
                return JSONResponse.getResult(300, "报名名额已满！");
            }
        }
        Date endTime = DateUtil.stringToDate(bean.getRegistrationEndTime(), "yyyy-MM-dd HH:mm");
        Date now = DateUtil.getCurrDateOfDate("yyyy-MM-dd HH:mm");
        if (now.after(endTime)) {
            return JSONResponse.getResult(400, "报名已结束！");
        }
        return JSONResponse.getResult(200, "success！");
    }

    @Override
    public CmsTrainOrder queryTrainOrderById(String id) {
        return orderMapper.selectByPrimaryKey(id);
    }

    @Override
    public List<CmsTrainField> queryFieldListByTrainId(String trainId) {
        return fieldMapper.queryTrainFieldListByTrainId(trainId);
    }

    @Override
    public List<CmsTrainOrderBean> queryCenterTrainOrderList(Map<String,Object> map, Pagination page) {
        map.put("firstResult",(page.getPage() -1) * page.getRows());
        map.put("rows",page.getRows());
        int total = orderMapper.queryCenterTrainOrderListCount(map);
        page.setTotal(total);
        return orderMapper.queryCenterTrainOrderList(map);
    }

    @Override
    public List<CmsTrainOrderBean> queryTrainOrderListByCreateUser(String userId) {
        return orderMapper.queryTrainOrderListByCreateUser(userId);
    }

    @Override
    public CmsTrainBean queryTrainById(String advertUrl) {
        return mapper.queryTrainById(advertUrl);
    }

    @Override
    public List<CmsTrainBean> pcnewVenue(int num) {
        Map map = new HashMap();
        map.put("orderBy", "CREATE_TIME DESC");
        map.put("firstResult", 0);
        map.put("rows", num);
        return mapper.pcnewVenue(map);
    }

    @Override
    public String queryTrainList2(Integer typeStatus, CmsTrainBean train, CmsTerminalUser user, PaginationApp paginationApp) {
        Map<String, Object> map = new HashMap<>();
        if (typeStatus != null){
            map.put("typeStatus",typeStatus);
        }
        if (StringUtils.isNotBlank(train.getTrainTitle())) {
            map.put("trainTitle", train.getTrainTitle());
        }
        if (StringUtils.isNotBlank(train.getVenueId())) {
            map.put("venueId", train.getVenueId());
        }
        if (StringUtils.isNotBlank(train.getTrainType())) {
            map.put("trainType", train.getTrainType());
        }
        if (StringUtils.isNotBlank(train.getTrainTag())) {
            map.put("trainTag", train.getTrainTag());
        }
        if (train.getTrainField() != null) {
            map.put("trainField", train.getTrainField());
        }
        if (train.getAdmissionType() != null) {
            map.put("admissionType", train.getAdmissionType());
        }
        if (train.getTrainStatus() != null) {
            map.put("trainStatus", train.getTrainStatus());
        }
        if (StringUtils.isNotBlank(train.getTrainStartTime())) {
            map.put("trainStartTime", train.getTrainStartTime());
        }
        if (StringUtils.isNotBlank(train.getTrainEndTime())) {
            map.put("trainEndTime", train.getTrainEndTime());
        }
        if (StringUtils.isNotBlank(train.getState())) {
            map.put("state", train.getState());
        }
        if (train.getOrder() != null) {
            map.put("order", train.getOrder());
        }
        if (user != null) {
            map.put("userId", user.getUserId());
        }
        if (StringUtils.isNotBlank(train.getTrainArea())) {
            map.put("trainArea", train.getTrainArea());
        }
        if (StringUtils.isNotBlank(train.getTrainLocation())) {
            map.put("trainLocation", train.getTrainLocation());
        }
        map.put("isDelete", 1);
        //分页
        if (paginationApp.getFirstResult() != null && paginationApp.getRows() != null) {
            map.put("firstResult", paginationApp.getFirstResult());
            map.put("rows", paginationApp.getRows());
            int total = mapper.queryTrainListCount2(map);
            train.setTotal(total);
        }
        Pagination page = new Pagination();
        page.setTotal(train.getTotal());
        page.setRows(paginationApp.getRows());
        page.setPage(paginationApp.getPage());
        paginationApp.setTotal(train.getTotal());
        return JSONResponse.toResultFormat(0, mapper.queryTrainList2(map), page);
    }
}
