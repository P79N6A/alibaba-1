package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsAdvertMapper;
import com.sun3d.why.model.CmsAdvert;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsAdvertService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * <p>
 * 广告服务层实现类
 * 事务管理层
 * 需要用到事务的功能都在此编写
 * <p/>
 * Created by cj on 2015/4/24.
 */
@Service
@Transactional
public class CmsAdvertServiceImpl implements CmsAdvertService {

    /**
     * 自动注入数据操作层dao实例
     */
    @Autowired
    private CmsAdvertMapper cmsAdvertMapper;

    //log4j日志
    private Logger logger = Logger.getLogger(CmsAdvertServiceImpl.class);

    /**
     * 根据广告sql语句示例条件查询符合的信息总数，一般分页功能的时候需要用到该方法
     *
     * @param map Map 带查询条件的map集合
     * @return int 查询结果总数
     */
    @Override
    @Transactional(readOnly = true)
    public int queryCmsAdvertCountByCondition(Map<String,Object> map){

        return cmsAdvertMapper.queryCmsAdvertCountByCondition(map);
    }

    /**
     * 根据广告sql语句示例来更新符合的数据，不包涵团队描述字段
     *
     * @param record CmsAdvert 广告信息
     * @param page Pagination 分页信息
     * @return List<CmsAdvert> 广告信息列表
     */
    @Override
    @Transactional(readOnly = true)
    public List<CmsAdvert> queryCmsAdvertByCondition(CmsAdvert record,Pagination page) {
        List<CmsAdvert> list = null;
        //设置要查询的条件，map中的key值应与mapper中的判断条件一致
        Map<String,Object> map = new HashMap<String,Object>();
        try {
            //添加根据广告名称模糊查询条件
            if (StringUtils.isNotBlank(record.getAdvertTitle())) {
                map.put("advertTitle","%"+record.getAdvertTitle()+"%");
            }
/*            if(record.getAdvertIsDel() != null){
                map.put("advertIsDel",record.getAdvertIsDel());
            }else{
                map.put("advertIsDel",Constant.NORMAL);
            }*/
            /**
             * 赵大英说暂时去掉状态 显示所以数据
             */
            //record.setAdvertState(Constant.AdvertState);

            if (StringUtils.isNotBlank(record.getAdvertColumn())) {
                map.put("advertColumn",record.getAdvertColumn());
            }

            if(StringUtils.isNotBlank(record.getAdvertSite())){
                map.put("advertSite",record.getAdvertSite());
            }

            if(StringUtils.isNotBlank(record.getDisplayPosition())){
                map.put("displayPosition",record.getDisplayPosition());
            }

            //根据管理员区县筛选
            //获得符合条件的总条数，这里需放在设置分页功能的前面执行，为列表页面分页功能提供
            int total = queryCmsAdvertCountByCondition(map);
            //设置分页的总条数来获取总页数
            page.setTotal(total);
            page.setRows(page.getRows());
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());

//            map.put("orderClause"," A.ADVERT_CREATE_TIME DESC");
            //将设定好的查询条件传入方法中返回符合的CmsAdvert集合数据
            list = cmsAdvertMapper.queryCmsAdvertByCondition(map);
        } catch (Exception e) {
            logger.error("执行带条件分页查询广告信息时出错",e);
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
    public CmsAdvert queryCmsAdvertById(String advertId) {

        return cmsAdvertMapper.queryCmsAdvertById(advertId);
    }


    public static String  getAdvertPos(String key){

        Map<String,Object> map = new HashMap<String, Object>();

        map.put("0",Constant.advertPos_app);
        map.put("1",Constant.advertPos_app_1);

        map.put("45",Constant.advertPos_45);
        map.put("46",Constant.advertPos_46);
        map.put("48",Constant.advertPos_48);
        map.put("49",Constant.advertPos_49);
        map.put("50",Constant.advertPos_50);
        map.put("51",Constant.advertPos_51);
        map.put("52",Constant.advertPos_52);
        map.put("53",Constant.advertPos_53);
        map.put("54",Constant.advertPos_54);

        map.put("55",Constant.advertPos_55);
        map.put("56",Constant.advertPos_56);

        map.put("57",Constant.advertPos_57);
        map.put("58",Constant.advertPos_58);
        map.put("59",Constant.advertPos_59);
        map.put("60",Constant.advertPos_60);
        map.put("61",Constant.advertPos_61);

        map.put("63",Constant.advertPos_63);
        map.put("64",Constant.advertPos_64);

        return (String)map.get(key);
    }


    @Override
    public int addCmsAdvert(CmsAdvert record,SysUser sysUser) {
        Map<String,Object> map = new HashMap<String,Object>();
        int count = 0;
        int advertCount = 0;
        record.setAdvertIsDel(Constant.NORMAL);
        //  广告创建者
        record.setAdvertCreateUser(sysUser.getUserId());
        //  广告创建时间
        record.setAdvertCreateTime(new Date());
        //  广告最后修改者
        record.setAdvertUpdateUser(sysUser.getUserId());
        //  广告最后修改时间
        record.setAdvertUpdateTime(new Date());


        if("0".equals(record.getAdvertPos()) || "1".equals(record.getAdvertPos())){
            //  广告尺寸的宽度
            record.setAdvertSizeWidth("750");
            //  广告尺寸的高度
            record.setAdvertSizeHeight("400");
        }else{
            //  广告尺寸的宽度
            record.setAdvertSizeWidth("800");
            //  广告尺寸的高度
            record.setAdvertSizeHeight("500");
        }

        if("2".equals(record.getDisplayPosition())){
            //  广告尺寸的宽度
            record.setAdvertSizeWidth("1200");
            //  广告尺寸的高度
            record.setAdvertSizeHeight("530");
        }else if("3".equals(record.getDisplayPosition())){
            record.setAdvertSizeWidth("750");
            //  广告尺寸的高度
            record.setAdvertSizeHeight("150");
        }

        //获取排序位置
        Integer advertPosSort = record.getAdvertPosSort();
        record.setAdvertPosSort(advertPosSort);
        //广告类型  默认设为1
        record.setAdvertType(Constant.AdvertType);
        //广告状态 默认设为1
        if(!StringUtils.isNotBlank(record.getAdvertId())){
            record.setAdvertState(Constant.AdvertState);
        }
        //广告连接目标
        record.setAdvertConnectTarget(Constant.AdvertConnectTarget);
        //将地址复制进去
        String AdvertPicUrl =  record.getAdvertPicUrl();
        record.setAdvertPicUrl(AdvertPicUrl);
        record.setIsRecommendType(2);

        if(record.getAdvertPos() != null){
            String advertColumn =  getAdvertPos(record.getAdvertPos());

            record.setAdvertSite(record.getAdvertSite());
            record.setAdvertColumn(advertColumn);

            map.put("advertColumn",advertColumn);
            map.put("advertPos",advertColumn);
            map.put("advertPosSort",advertPosSort);
            map.put("displayPosition",record.getDisplayPosition()) ;
        }

        /**
         * 如果非app 不设置栏目
         */
        if(!"0".equals(record.getAdvertSite())){
            record.setAdvertRecDes(null);
        }

        /**
         * 编辑
         */
        if(StringUtils.isNotBlank(record.getAdvertId())){
            CmsAdvert ExtRecord = cmsAdvertMapper.queryCmsAdvertById(record.getAdvertId());
            if(!String.valueOf(ExtRecord.getAdvertPosSort()).equals(String.valueOf(record.getAdvertPosSort()))){
                advertCount =  cmsAdvertMapper.queryAdvertPositionCount(map);
                if(advertCount>0){
                    return 100;
                }
            }
            return cmsAdvertMapper.editCmsAdvert(record);
        }else{
            record.setAdvertId(UUIDUtils.createUUId());
        }

        /**
         * 新增
         */
        advertCount =  cmsAdvertMapper.queryAdvertPositionCount(map);
        if(advertCount > 0){
            return 100;
        }
        return  cmsAdvertMapper.addCmsAdvert(record);
    }

    /**
     * 根据广告主键id来更新模块信息，更新所有属性字段，包涵团队会延缓描述
     *
     * @param record CmsAdvert 模块信息
     * @param sysUser SysUser 用户信息
     * @return int 执行结果 1：成功 0：失败
     */
    @Override
    public int editCmsAdvert(CmsAdvert record,SysUser sysUser) {
        int count = 0;
        try {
            //根据广告ID查询广告信息
            CmsAdvert cmsAdvert = cmsAdvertMapper.queryCmsAdvertById(record.getAdvertId());
            //修改广告时，默认赋值
            record.setAdvertCreateTime(cmsAdvert.getAdvertCreateTime());
            record.setAdvertCreateUser(cmsAdvert.getAdvertCreateUser());
            record.setAdvertUpdateUser(sysUser.getUserId());
            record.setAdvertUpdateTime(new Date());
            record.setAdvertIsDel(cmsAdvert.getAdvertIsDel());
            count = cmsAdvertMapper.editCmsAdvert(record);
        } catch (Exception e) {
            logger.error("修改广告信息时出错",e);
        }
        return count;
    }

    /**
     * 根据广告主键id来更新模块信息，更新所有属性字段，包涵团队会延缓描述
     *
     * @param record CmsAdvert 模块信息
     * @param sysUser SysUser 用户信息
     * @return int 执行结果 1：成功 0：失败
     */
    @Override
    public int deleteCmsAdvert(CmsAdvert record,SysUser sysUser) {
        int count = 0;
        try {
            //执行广告信息表数据更新操作
            record.setAdvertUpdateUser(sysUser.getUserId());
            record.setAdvertUpdateTime(new Date());
            record.setAdvertState(2);
            count = cmsAdvertMapper.editCmsAdvert(record);
        } catch (Exception e) {
            logger.error("修改广告信息时出错",e);
        }
        return count;
    }
    /**
     *  根据广告中的站点、栏目以及版位查找最大的顺序
     * @param cmsAdvert 广告信息
     * @return 最大版位
     */
    @Override
    public Integer queryMaxAdvertPosSort(CmsAdvert cmsAdvert) {
        Integer maxAdvertPosSort = cmsAdvertMapper.queryMaxAdvertPosSort(cmsAdvert);
        if(maxAdvertPosSort == null){
            maxAdvertPosSort = 0;
        }
        return maxAdvertPosSort;
    }

    /**
     * 根据站点名称以及栏目名称查询对应的广告信息列表
     * @param siteName 网站名称
     * @param columnName 栏目名称
     * @return 广告列表
     */
    @Override
    public List<CmsAdvert> queryAdvertByName(String siteName,String columnName) {
        Map<String,Object> map = new HashMap<String, Object>();
        List<CmsAdvert> list = null;
        try {
            if(StringUtils.isNotBlank(siteName)){
                map.put("siteName",siteName);
            }
            if(StringUtils.isNotBlank(columnName)){
                map.put("keyWord",columnName);
            }
            map.put("advertIsDel",Constant.NORMAL);
            map.put("advertState",Constant.PUBLISH);
            list = cmsAdvertMapper.queryAdvertByName(map);
        } catch (Exception e) {
            logger.error("根据站点名称以及栏目名称查找已发布且状态为正常的广告列表!",e);
        }
        return list;
    }

    @Override
    public List<CmsAdvert> queryAdvertBySite(String siteId,String displayPositions) {
        List<CmsAdvert> list = new ArrayList<CmsAdvert>();
        int displayPosition = Integer.valueOf(displayPositions);
        Map<String,Object> map = new HashMap<>();
        try {
            if(StringUtils.isNotBlank(siteId)){
                map.put("siteId",siteId);
            }
            list = this.cmsAdvertMapper.queryAdvertBySite(map);
        }catch (Exception e){
            logger.error("查询广告出错",e);
        }
        return list;
    }

    /**
     *  通过传递过来的信息获取 版位图片的顺序
     * @param cmsAdvert
     * @return
     */
    @Override
    public List<CmsAdvert> queryAdvertSitePosition(CmsAdvert cmsAdvert) {
        Map<String,Object> map = new HashMap<String,Object>();
        //获取  广告站点
        String advertSite = cmsAdvert.getAdvertSite();
//        map.put("advertColumn","%"+cmsAdvert.getAdvertColumn()+"%");
//        map.put("advertPosSort",cmsAdvert.getAdvertPosSort());

        List<CmsAdvert> cmsAdvertsList =  cmsAdvertMapper.queryAdvertSitePosition(map);
        return cmsAdvertsList;
    }

    @Override
    public String recoveryCmsAdvert(String id, SysUser sysUser) {
        CmsAdvert record = new CmsAdvert();
        record.setAdvertId(id);
        record.setAdvertState(1);
        record.setAdvertUpdateUser(sysUser.getUserId());
        record.setAdvertUpdateTime(new Date());
        record.setAdvertIsDel(Constant.NORMAL);
        cmsAdvertMapper.editCmsAdvert(record);
        return Constant.RESULT_STR_SUCCESS;
    }

    @Override
    public String deleteCmsAdvert(String id, SysUser sysUser) {
        CmsAdvert record = new CmsAdvert();
        record.setAdvertId(id);
        record.setAdvertUpdateUser(sysUser.getUserId());
        record.setAdvertUpdateTime(new Date());
        record.setAdvertIsDel(Constant.DELETE);
        record.setAdvertState(2);
        cmsAdvertMapper.editCmsAdvert(record);
        return Constant.RESULT_STR_SUCCESS;
    }

    @Override
    public int queryExistSort(CmsAdvert advert) {
        return cmsAdvertMapper.queryExistSort(advert);
    }




    /**
     * 查询热点推荐列表
     *
     * @param record CmsAdvert 广告信息
     * @param page Pagination 分页信息
     * @return List<CmsAdvert> 广告信息列表
     */
    @Override
    public List<CmsAdvert> queryRecommendCmsAdvertByList(CmsAdvert record,Pagination page) {
        List<CmsAdvert> list = null;
        //设置要查询的条件，map中的key值应与mapper中的判断条件一致
        Map<String,Object> map = new HashMap<String,Object>();
        try {
            //添加根据广告名称模糊查询条件
            if (StringUtils.isNotBlank(record.getAdvertTitle())) {
                map.put("advertTitle","%"+record.getAdvertTitle()+"%");
            }
/*            if(record.getAdvertIsDel() != null){
                map.put("advertIsDel",record.getAdvertIsDel());
            }else{
                map.put("advertIsDel",Constant.NORMAL);
            }*/
            /**
             * 赵大英说暂时去掉状态 显示所以数据
             */
            //record.setAdvertState(Constant.AdvertState);

            if (StringUtils.isNotBlank(record.getAdvertColumn())) {
                map.put("advertColumn",record.getAdvertColumn());
            }

            if(StringUtils.isNotBlank(record.getAdvertSite())){
                map.put("advertSite",record.getAdvertSite());
            }

            //根据管理员区县筛选
            //获得符合条件的总条数，这里需放在设置分页功能的前面执行，为列表页面分页功能提供
            int total = queryRecommendCmsAdvertCountByCondition(map);
            //设置分页的总条数来获取总页数
            page.setTotal(total);
            page.setRows(page.getRows());
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());

//            map.put("orderClause"," A.ADVERT_CREATE_TIME DESC");
            //将设定好的查询条件传入方法中返回符合的CmsAdvert集合数据
            list = cmsAdvertMapper.queryRecommendCmsAdvertByList(map);
        } catch (Exception e) {
            logger.error("执行带条件分页查询广告信息时出错",e);
        }
        return list;
    }



    public int addRecommendCmsAdvert(CmsAdvert record,SysUser sysUser) {
        Map<String,Object> map = new HashMap<String,Object>();
        int count = 0;
        int advertCount = 0;
        record.setAdvertIsDel(Constant.NORMAL);
        //  广告创建者
        record.setAdvertCreateUser(sysUser.getUserId());
        //  广告创建时间
        record.setAdvertCreateTime(new Date());
        //  广告最后修改者
        record.setAdvertUpdateUser(sysUser.getUserId());
        //  广告最后修改时间
        record.setAdvertUpdateTime(new Date());
        //  广告尺寸的宽度
        record.setAdvertSizeWidth(Constant.AdvertSizeWidth);
        //  广告尺寸的高度
        record.setAdvertSizeHeight(Constant.AdvertSizeHeight);
        //获取排序位置
        Integer advertPosSort = record.getAdvertPosSort();
        record.setAdvertPosSort(advertPosSort);
        //广告类型  默认设为1
        record.setAdvertType(Constant.AdvertType);
        //广告状态 默认设为1
        record.setAdvertState(Constant.AdvertState);
        //广告连接目标
        record.setAdvertConnectTarget(Constant.AdvertConnectTarget);
        //将地址复制进去
        String AdvertPicUrl =  record.getAdvertPicUrl();
        record.setAdvertPicUrl(AdvertPicUrl);

        if(record.getAdvertPos() != null){
            String advertColumn =  getAdvertPos(record.getAdvertPos());

            record.setAdvertSite(record.getAdvertPos());
            record.setAdvertColumn(advertColumn);

            map.put("advertPos",advertColumn);
            map.put("advertPosSort",advertPosSort);
        }
        record.setAdvertId(UUIDUtils.createUUId());

        String linkUrl = record.getAdvertConnectUrl();

        //如果ulr中包含文化云的域名 ，则将活动的id存到表中
        if(StringUtils.isNotBlank(linkUrl)){
            if(linkUrl.lastIndexOf("wenhuayun.cn")!=-1){
                String[] activityIds = linkUrl.split("=");
                record.setActivityId(activityIds[1]);
            }
        }

        return  cmsAdvertMapper.addCmsAdvert(record);
    }


    @Override
    public int editRecommendCmsAdvert(CmsAdvert record,SysUser sysUser) {
        int count = 0;
        try {
            //根据广告ID查询广告信息
            CmsAdvert cmsAdvert = cmsAdvertMapper.queryCmsAdvertById(record.getAdvertId());
            //修改广告时，默认赋值

            cmsAdvert.setAdvertState(2);
            cmsAdvert.setAdvertUpdateTime(new Date());
            cmsAdvert.setAdvertUpdateUser(sysUser.getUserId());
            cmsAdvert.setAdvertIsDel(2);
            count = cmsAdvertMapper.editRecommendCmsAdvert(cmsAdvert);
        } catch (Exception e) {
            logger.error("修改广告信息时出错",e);
        }
        return count;
    }

    /**
     * app端轮播图List
     *
     * @param record CmsAdvert 广告信息
     * @param page Pagination 分页信息
     * @return List<CmsAdvert> 广告信息列表
     */
    @Override
    @Transactional(readOnly = true)
    public List<CmsAdvert> appRecommendadvertlist(CmsAdvert record,Pagination page) {
        List<CmsAdvert> list = null;
        //设置要查询的条件，map中的key值应与mapper中的判断条件一致
        Map<String,Object> map = new HashMap<String,Object>();
        try {
            //添加根据广告名称模糊查询条件
            if (StringUtils.isNotBlank(record.getAdvertTitle())) {
                map.put("advertTitle","%"+record.getAdvertTitle()+"%");
            }
/*            if(record.getAdvertIsDel() != null){
                map.put("advertIsDel",record.getAdvertIsDel());
            }else{
                map.put("advertIsDel",Constant.NORMAL);
            }*/
            /**
             * 赵大英说暂时去掉状态 显示所以数据
             */
            //record.setAdvertState(Constant.AdvertState);

            if (StringUtils.isNotBlank(record.getAdvertColumn())) {
                map.put("advertColumn",record.getAdvertColumn());
            }

            if(StringUtils.isNotBlank(record.getAdvertSite())){
                map.put("advertSite",record.getAdvertSite());
            }

            //根据管理员区县筛选
            //获得符合条件的总条数，这里需放在设置分页功能的前面执行，为列表页面分页功能提供
            int total = queryRecommendCmsAdvertCountByCondition(map);
            //设置分页的总条数来获取总页数
            page.setTotal(total);
            page.setRows(page.getRows());
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());

//            map.put("orderClause"," A.ADVERT_CREATE_TIME DESC");
            //将设定好的查询条件传入方法中返回符合的CmsAdvert集合数据
            list = cmsAdvertMapper.appRecommendadvertlist(map);
        } catch (Exception e) {
            logger.error("执行带条件分页查询广告信息时出错",e);
        }
        return list;
    }

    /**
     * 文化云3.1前端首页热点推荐
     * @param page
     * @return
     */
    @Override
    public List<CmsAdvert> queryHotelRecommendAdvert(Pagination page){
        Map<String, Object> map = new HashMap<String, Object>();
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        return cmsAdvertMapper.queryHotelRecommendAdvert(map);
    }


    /**
     * 根据广告sql语句示例条件查询符合的信息总数，一般分页功能的时候需要用到该方法
     *
     * @param map Map 带查询条件的map集合
     * @return int 查询热点推荐结果总数
     */
    @Override
    @Transactional(readOnly = true)
    public int queryRecommendCmsAdvertCountByCondition(Map<String,Object> map){

        return cmsAdvertMapper.queryRecommendCmsAdvertCountByCondition(map);
    }
}
