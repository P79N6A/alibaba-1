package com.sun3d.why.service.impl;

import com.sun3d.why.dao.ManagementInformationMapper;
import com.sun3d.why.model.ManagementInformation;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CacheConstant;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.ManagementInformationService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisSentinelPool;
import redis.clients.jedis.Transaction;

import java.util.*;

@Transactional
@Service
public class ManagementInformationServicelmpl implements ManagementInformationService {
    @Autowired
    private ManagementInformationMapper managementInformationMapper;

    @Autowired
    private CacheService cacheService;

    @Override
    public List<ManagementInformation> informationList(ManagementInformation information, Pagination page, SysUser sysUser) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (information != null && StringUtils.isNotBlank(information.getInformationTitle())) {
            map.put("informationTitle", "%" + information.getInformationTitle() + "%");

        }
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = managementInformationMapper.informationListCount(map);
            page.setTotal(total);
        }

        return managementInformationMapper.informationList(map);
    }

    @Override
    public String addInformation(ManagementInformation information, SysUser sysUser) {
        int count;
        information.setInformationUpdateTime(new Date());
        information.setInformationUpdateUser(sysUser.getUserId());
        if (StringUtils.isBlank(information.getInformationId())) {
            information.setInformationId(UUIDUtils.createUUId());
            information.setBrowseCount(0);
            information.setInformationCreateTime(new Date());
            information.setInformationCreateUser(sysUser.getUserId());
            count = managementInformationMapper.insertInformation(information);

        } else {
            count = managementInformationMapper.updateByInformationId(information);
        }
        final ManagementInformation info=information;
        final String key = "Info" + info.getInformationId();
        new Thread(new Runnable() {
            @Override
            public void run() {
                if (info != null) {
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(new Date());
                    //设置过期时间为当前时间之后的240小时
                    calendar.add(Calendar.HOUR_OF_DAY, 240);
                    cacheService.addInfo(key, info, calendar.getTime());
                }
            }
        }).start();
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }

    }

    @Override
    public ManagementInformation getInformation(String informationId) {
        final String key = "Info" + informationId;
        ManagementInformation info = cacheService.getInfo(key);
        if (info!=null&&StringUtils.isNotBlank(info.getInformationId())) {

        }else{
            info = managementInformationMapper.selectByInformationId(informationId);
        }
        if (info.getBrowseCount()!=null) {
            info.setBrowseCount(info.getBrowseCount() + 1);
        } else {
            info.setBrowseCount(1);
        }
        final ManagementInformation finalInfo = info;
        new Thread(new Runnable() {
            @Override
            public void run() {
                if (finalInfo != null) {
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(new Date());
                    //设置过期时间为当前时间之后的240小时
                    calendar.add(Calendar.HOUR_OF_DAY, 240);
                    cacheService.addInfo(key, finalInfo, calendar.getTime());
                    if(finalInfo.getBrowseCount()%100==0){
                        managementInformationMapper.updateByInformationId(finalInfo);
                    }
                }
            }
        }).start();
        return info;
    }

    @Override
    public ManagementInformation getInformationSQL(String informationId) {
        final String key = "Info" + informationId;
        ManagementInformation info= managementInformationMapper.selectByInformationId(informationId);
        if (info.getBrowseCount()!=null) {
            info.setBrowseCount(info.getBrowseCount() + 1);
        } else {
            info.setBrowseCount(1);
        }
        final ManagementInformation finalInfo = info;
        new Thread(new Runnable() {
            @Override
            public void run() {
                if (finalInfo != null) {
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(new Date());
                    //设置过期时间为当前时间之后的240小时
                    calendar.add(Calendar.HOUR_OF_DAY, 240);
                    cacheService.addInfo(key, finalInfo, calendar.getTime());
                    if(finalInfo.getBrowseCount()%100==0){
                        managementInformationMapper.updateByInformationId(finalInfo);
                    }
                }
            }
        }).start();
        return info;
    }
}
