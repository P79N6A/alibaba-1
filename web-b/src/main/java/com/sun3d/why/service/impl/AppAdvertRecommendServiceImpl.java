package com.sun3d.why.service.impl;

import com.sun3d.why.dao.AppAdvertRecommendMapper;
import com.sun3d.why.dao.AppAdvertRecommendRferMapper;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sun3d.why.service.AppAdvertRecommendService;

import com.sun3d.why.model.AppAdvertRecommend;
import com.sun3d.why.model.AppAdvertRecommendRfer;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class AppAdvertRecommendServiceImpl implements AppAdvertRecommendService {
    @Autowired
    private AppAdvertRecommendMapper appAdvertRecommendMapper;
    @Autowired
    private AppAdvertRecommendRferMapper appAdvertRecommendRferMapper;


    @Override
    public String addAdvert(AppAdvertRecommend appadvertrecommend, SysUser user) {
        try {
            String uuid="";
            if (StringUtils.isNotBlank(appadvertrecommend.getAdvertId())) {
                uuid=appadvertrecommend.getAdvertId();
                appadvertrecommend.setUpdateBy(user.getUserId());
                appadvertrecommend.setUpdateTime(new Date());
                appAdvertRecommendMapper.editAdvert(appadvertrecommend);
            } else {
                uuid=UUIDUtils.createUUId();
                appadvertrecommend.setAdvertId(uuid);
                appadvertrecommend.setAdvState(Constant.NORMAL);
                appadvertrecommend.setCreateBy(user.getUserId());
                appadvertrecommend.setUpdateBy(user.getUserId());
                appadvertrecommend.setCreateTime(new Date());
                appadvertrecommend.setUpdateTime(new Date());
                appAdvertRecommendMapper.addAdvert(appadvertrecommend);
            }
            List<AppAdvertRecommendRfer> appAdvertRecommendRferList = appadvertrecommend.getDataList();
            appAdvertRecommendRferMapper.delete(appadvertrecommend.getAdvertId());
            if (appAdvertRecommendRferList != null &&appadvertrecommend.getIsContainActivtiyAdv()!= null ) {
                for (AppAdvertRecommendRfer appAdvertRecommendRfer : appAdvertRecommendRferList) {
                    if(StringUtils.isNotBlank(appAdvertRecommendRfer.getAdvertImgUrl())){
                    AppAdvertRecommendRfer appAdvertRecommendRferMap = new AppAdvertRecommendRfer();
                        appAdvertRecommendRferMap.setAdvertId(UUIDUtils.createUUId());
                        appAdvertRecommendRferMap.setAdvertUrl(appAdvertRecommendRfer.getAdvertUrl() != null ? appAdvertRecommendRfer.getAdvertUrl() : "");
                        appAdvertRecommendRferMap.setAdvertImgUrl(appAdvertRecommendRfer.getAdvertImgUrl() != null ? appAdvertRecommendRfer.getAdvertImgUrl() : "");
                        appAdvertRecommendRferMap.setAdvertSort((Integer) (appAdvertRecommendRfer.getAdvertSort() != null ? appAdvertRecommendRfer.getAdvertSort() : ""));
                        appAdvertRecommendRferMap.setAdvertReferId(uuid!= null ? uuid : "");
                        appAdvertRecommendRferMap.setCreateBy(user.getUserId() != null ? user.getUserId()  : "");
                        appAdvertRecommendRferMap.setUpdateBy(user.getUserId() != null ? user.getUserId()  : "");
                        appAdvertRecommendRferMap.setCreateTime(new Date());
                        appAdvertRecommendRferMap.setUpdateTime(new Date());
                        appAdvertRecommendRferMapper.addAdvertRfer(appAdvertRecommendRferMap);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException();
        }
        return Constant.RESULT_STR_SUCCESS;
    }

    /**
     * 根据广告sql语句示例来更新符合的数据，不包涵团队描述字段
     *
     * @param record AppAdvertRecommend 广告信息
     * @param page   Pagination 分页信息
     * @return List<CmsAdvert> 广告信息列表
     */
    @Override
    @Transactional(readOnly = true)
    public List<AppAdvertRecommend> queryCmsAdvertByCondition(AppAdvertRecommend record, Pagination page) {
        List<AppAdvertRecommend> list = null;
        //设置要查询的条件，map中的key值应与mapper中的判断条件一致
        Map<String, Object> map = new HashMap<String, Object>();
        try {
            if (StringUtils.isNotBlank(record.getAdvertId())) {
                map.put("advertId", record.getAdvertId());
            }
            //获得符合条件的总条数，这里需放在设置分页功能的前面执行，为列表页面分页功能提供
            int total = appAdvertRecommendMapper.selectAdvertCount(map);
            //设置分页的总条数来获取总页数
            page.setTotal(total);
            page.setRows(page.getRows());
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            list = appAdvertRecommendMapper.selectAdvertIndex(map);
        } catch (Exception e) {
        }
        return list;
    }
    /**
     * 根据广告sql语句示例来更新符合的数据，不包涵团队描述字段
     *
     * @param record AppAdvertRecommend 广告信息
     * @return List<CmsAdvert> 广告信息列表
     */
    @Override
    @Transactional(readOnly = true)
    public List<AppAdvertRecommendRfer> queryAdvertRecommendRferCondition(AppAdvertRecommendRfer record) {
        List<AppAdvertRecommendRfer> list = null;
        //设置要查询的条件，map中的key值应与mapper中的判断条件一致
        String advertReferId="";
        try {
            if (StringUtils.isNotBlank(record.getAdvertReferId())) {
                advertReferId= record.getAdvertReferId();
            }

            list = appAdvertRecommendRferMapper.selectAdvertIndex(advertReferId);
        } catch (Exception e) {
        }
        return list;
    }
    /**
     * 根据广告主键id查询模块信息
     *
     * @param advertId String 广告主键id
     * @return CmsAdvert 广告信息
     */
    @Override
    @Transactional(readOnly = true)
    public AppAdvertRecommend selectAdvertById(String advertId) {

        return appAdvertRecommendMapper.selectAdvertById(advertId);
    }
    /**
     * 根据广告主键id删除
     *
     * @param advertId String 广告主键id
     * @return CmsAdvert 广告信息
     */
    @Override
    public String deletedvertById(String advertId) {
        try {
            if(StringUtils.isNotBlank(advertId)){
            AppAdvertRecommend appadvertrecommend=new AppAdvertRecommend();
            appadvertrecommend.setAdvertId(advertId);
            appadvertrecommend.setAdvState(3);
             appAdvertRecommendMapper.editAdvert(appadvertrecommend);
             return Constant.RESULT_STR_SUCCESS;
        }

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException();

        }

        return Constant.RESULT_STR_FAILURE;

    }
}
