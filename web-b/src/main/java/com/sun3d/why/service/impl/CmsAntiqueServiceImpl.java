package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsAntiqueMapper;
import com.sun3d.why.model.CmsAntique;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsAntiqueService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>
 * 藏品服务层实现类
 * 事务管理层
 * 需要用到事务的功能都在此编写
 * <p/>
 * Created by cj on 2015/4/21.
 */
@Service
@Transactional
public class CmsAntiqueServiceImpl implements CmsAntiqueService {

    /**
     * 自动注入数据操作层dao实例
     */
    @Autowired
    private CmsAntiqueMapper cmsAntiqueMapper;

    //log4j日志
    private Logger logger = Logger.getLogger(CmsAntiqueServiceImpl.class);

    /**
     * 根据藏品主键id获取藏品信息
     *
     * @param antiqueId String 藏品主键id
     * @return CmsAntique 藏品模型
     */
    @Override
    @Transactional(readOnly = true)
    public CmsAntique queryCmsAntiqueById(String antiqueId) {

        return cmsAntiqueMapper.queryCmsAntiqueById(antiqueId);
    }

    /**
     * 新增一条完整的藏品信息
     *
     * @param record CmsAntique 藏品模型
     * @param sysUser 系统用户
     * @return int 成功返回1
     */
    @Override
    public int addCmsAntique(CmsAntique record,SysUser sysUser) {
        int count = 0;
        try {
            count = 0;
            //赋值 是否音频
            if(StringUtils.isNotBlank(record.getAntiqueVoiceUrl())){
                record.setAntiqueIsVoice(2);
            }else{
                record.setAntiqueIsVoice(1);
            }
            //赋值 是否3D展示
            if(StringUtils.isNotBlank(record.getAntique3dUrl())){
                record.setAntiqueIs3d(2);
            }else{
                record.setAntiqueIs3d(1);
            }
            //添加馆藏时，默认赋值
            record.setAntiqueId(UUIDUtils.createUUId());
            record.setAntiqueIsDel(Constant.NORMAL);
            record.setAntiqueCreateTime(new Date());
            record.setAntiqueUpdateTime(new Date());
            record.setAntiqueCreateUser(sysUser.getUserId());
            record.setAntiqueUpdateUser(sysUser.getUserId());
            count = cmsAntiqueMapper.addCmsAntique(record);
        } catch (Exception e) {
            logger.error("添加馆藏信息出错!",e);
        }
        return count;
    }

    /**
     * 编辑藏品信息
     *
     * @param record CmsAntique 藏品信息
     * @param sysUser 系统用户
     * @return int 成功返回1
     */
    @Override
    public int editCmsAntique(CmsAntique record,SysUser sysUser) {
        int count = 0;
        try {
            //根据馆藏ID查询馆藏信息
            CmsAntique cmsAntique = this.queryCmsAntiqueById(record.getAntiqueId());
            record.setAntiqueCreateTime(cmsAntique.getAntiqueCreateTime());
            record.setAntiqueCreateUser(cmsAntique.getAntiqueCreateUser());
            record.setAntiqueIsDel(Constant.NORMAL);

            //赋值 是否音频
            if(StringUtils.isNotBlank(record.getAntiqueVoiceUrl())){
                record.setAntiqueIsVoice(2);
            }else{
                record.setAntiqueIsVoice(1);
            }
            //赋值 是否3D展示
            if(StringUtils.isNotBlank(record.getAntique3dUrl())){
                record.setAntiqueIs3d(2);
            }else{
                record.setAntiqueIs3d(1);
            }
            //修改馆藏时，默认赋值
            record.setAntiqueUpdateTime(new Date());
            record.setAntiqueUpdateUser(sysUser.getUserId());
            count = cmsAntiqueMapper.editCmsAntique(record);
        } catch (Exception e) {
            logger.error("修改馆藏信息时出错!",e);
        }
        return count;
    }

    /**
     * 逻辑删除藏品信息
     *
     * @param record CmsAntique 藏品信息
     * @param sysUser 系统用户
     * @return int 成功返回1
     */
    @Override
    public int deleteCmsAntique(CmsAntique record,SysUser sysUser){
        int count = 0;
        try {
            //修改馆藏时，默认赋值
            record.setAntiqueUpdateTime(new Date());
            record.setAntiqueUpdateUser(sysUser.getUserId());
            record.setAntiqueIsDel(Constant.DELETE);
            record.setAntiqueState(Constant.TRASH);
            count = cmsAntiqueMapper.editCmsAntique(record);
        } catch (Exception e) {
            logger.error("逻辑删除馆藏信息出错!",e);
        }
        return count;
    }

    /**
     * 逻辑恢复藏品信息
     *
     * @param record CmsAntique 藏品信息
     * @param sysUser 系统用户
     * @return int 成功返回1
     */
    @Override
    public int recoverCmsAntique(CmsAntique record,SysUser sysUser){
        int count = 0;
        try {
            //修改馆藏时，默认赋值
            record.setAntiqueUpdateTime(new Date());
            record.setAntiqueUpdateUser(sysUser.getUserId());
            record.setAntiqueIsDel(Constant.NORMAL);
            record.setAntiqueState(Constant.DRAFT);
            count = cmsAntiqueMapper.editCmsAntique(record);
        } catch (Exception e) {
            logger.error("逻辑恢复馆藏信息出错!",e);
        }
        return count;
    }

    /**
     * 根据分页信息、馆藏信息、场馆信息以及用户信息进行馆藏列表查询
     *
     * @param page 分页信息
     * @param record 馆藏信息
     * @param cmsVenue 场馆信息
     * @param sysUser 系统用户
     * @return List<CmsAntique> 馆藏列表
     */
    @Override
    public List<CmsAntique> queryCmsAntiqueByCondition(Pagination page,CmsAntique record,CmsVenue cmsVenue,SysUser sysUser) {
        Map<String,Object> map = new HashMap<String, Object>();
        List<CmsAntique> list = null;
        try {
            String userDeptPath = sysUser.getUserDeptPath();
            if(userDeptPath != null){
                map.put("venueDept", "%"+userDeptPath+"%");
            }
            if (StringUtils.isNotBlank(record.getAntiqueName())){
                map.put("antiqueName","%"+record.getAntiqueName()+"%");
            }
            if(StringUtils.isNotBlank(record.getSearchKey())){
                map.put("searchKey", record.getSearchKey());
            }
/*            if(record.getAntiqueIsDel() != null){
                map.put("antiqueIsDel",record.getAntiqueIsDel());
            }else{
                record.setAntiqueIsDel(Constant.NORMAL);
                map.put("antiqueIsDel",Constant.NORMAL);
            }*/
            if(record.getAntiqueState() != null){
                map.put("antiqueState",record.getAntiqueState());
            }
            if (StringUtils.isNotBlank(cmsVenue.getVenueArea())){
                map.put("venueArea","%"+cmsVenue.getVenueArea()+"%");
            }
            if (StringUtils.isNotBlank(cmsVenue.getVenueType())){
                map.put("venueType",cmsVenue.getVenueType());
            }
            if (StringUtils.isNotBlank(cmsVenue.getVenueId())){
                map.put("venueId",cmsVenue.getVenueId());
            }
            if (StringUtils.isNotBlank(record.getAntiqueYears())){
                map.put("antiqueYears",record.getAntiqueYears());
            }
            //如果含有exclude 代表不包含给定条件的ID
            if(StringUtils.isNotBlank(record.getAntiqueId())){
                if(record.getAntiqueId().contains("exclude")){
                    map.put("antiqueIdExclude",record.getAntiqueId().replace("exclude",""));
                }else{
                    map.put("antiqueId",record.getAntiqueId());
                }
            }
            if(StringUtils.isNotBlank(record.getAntiqueTypeId())){
                map.put("antiqueTypeId",record.getAntiqueTypeId());
            }
            int total = this.queryCmsAntiqueCountByCondition(map);
            //设置分页的总条数来获取总页数
            page.setTotal(total);
            page.setRows(page.getRows());
            map.put("firstResult",page.getFirstResult());
            map.put("rows",page.getRows());
            list = cmsAntiqueMapper.queryCmsAntiqueByCondition(map);
        } catch (Exception e) {
            logger.error("查询馆藏信息时出错",e);
        }
        return list;
    }

    /**
     * 根据馆藏信息进行带条件分页查询
     *
     * @param record CmsAntique 馆藏信息
     * @return List<CmsAntique> 馆藏列表
     */
    @Override
    public List<CmsAntique> queryByCmsAntique(CmsAntique record){
        Map<String,Object> map = new HashMap<String, Object>();
        List<CmsAntique> list = null;
        try {
            if(record.getAntiqueState() != null){
                map.put("antiqueState",record.getAntiqueState());
            }
            if(record.getAntiqueIsDel() != null){
                map.put("antiqueIsDel",record.getAntiqueIsDel());
            }else{
                record.setAntiqueIsDel(Constant.NORMAL);
                map.put("antiqueIsDel",Constant.NORMAL);
            }
            if (StringUtils.isNotBlank(record.getAntiqueName())){
                map.put("antiqueName","%"+record.getAntiqueName()+"%");
            }
            //如果含有exclude 代表不包含给定条件的ID
            if(StringUtils.isNotBlank(record.getAntiqueId())){
                if(record.getAntiqueId().contains("exclude")){
                    map.put("antiqueIdExclude",record.getAntiqueId().replace("exclude",""));
                }else{
                    map.put("antiqueId",record.getAntiqueId());
                }
            }
            if(record.getAntiqueTypeId() != null){
                map.put("antiqueTypeId",record.getAntiqueTypeId());
            }
            if(record.getVenueId() != null){
                map.put("venueId",record.getVenueId());
            }
            //分页信息
            map.put("firstResult", record.getFirstResult());
            map.put("rows",record.getRows());
            list = cmsAntiqueMapper.queryCmsAntiqueByCondition(map);
        } catch (Exception e) {
            logger.error("带条件查询馆藏时出错",e);
        }
        return list;
    }

    /**
     * 与 queryCmsAntiqueByCondition 写在一起，用于返回查询总记录
     *
     * @param map 查询条件以及值都已经按要求设定好的MAP
     * @return 根据条件查询完后的总个数
     */
    @Override
    public int queryCmsAntiqueCountByCondition(Map<String, Object> map) {

        return cmsAntiqueMapper.queryCmsAntiqueCountByCondition(map);
    }

    /**
     * 根据区县以及分页信息返回给定数量的馆藏信息
     *
     * @param areaCode 区县信息
     * @param page 分页信息
     * @return List<CmsAntique> 馆藏列表
     */
    @Override
    public List<CmsAntique> queryBestWelcomeAntique(String areaCode,Pagination page){
        List<CmsAntique> list = null;
        try {
            Map<String,Object> map = new HashMap<String, Object>();
            list = null;
            //条件查询信息
            map.put("antiqueState",Constant.PUBLISH);
            map.put("antiqueIsDel",Constant.NORMAL);
            if (StringUtils.isNotBlank(areaCode)){
                map.put("venueArea","%" + areaCode + "%");
            }
            page.setTotal(cmsAntiqueMapper.countBestWelcomeAntique(map));
            page.setRows(page.getRows());
            //分页信息
            map.put("firstResult", page.getFirstResult());
            map.put("rows",page.getRows());
            list = cmsAntiqueMapper.queryBestWelcomeAntique(map);
        } catch (Exception e) {
            logger.error("查询本周最受欢迎藏品出错",e);
        }
        return list;
    }

    /**
     * 根据馆藏信息查询出最受欢迎馆藏的数量
     *
     * @param cmsAntique
     * @return List<CmsAntique> 馆藏列表
     */
    @Override
    public int countBestWelcomeAntique(CmsAntique cmsAntique){
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("antiqueState",Constant.PUBLISH);
        map.put("antiqueIsDel",Constant.NORMAL);

        return cmsAntiqueMapper.countBestWelcomeAntique(map);
    }

    /**
     * 馆藏详情页馆藏列表显示
     * @param cmsAntique 馆藏信息
     * @return List<CmsAntique> 馆藏列表
     */
    public List<CmsAntique> queryAntiqueDetailList(CmsAntique cmsAntique){
        List<CmsAntique> list = null;
        try {
            CmsAntique condition = new CmsAntique();
            condition.setAntiqueTypeId(cmsAntique.getAntiqueTypeId());
            condition.setVenueId(cmsAntique.getVenueId());
            condition.setAntiqueIsDel(Constant.NORMAL);
            condition.setAntiqueState(Constant.PUBLISH);
            condition.setAntiqueId("exclude"+cmsAntique.getAntiqueId());
            //相关馆藏显示数据为5条
            condition.setRows(5);
            list = queryByCmsAntique(condition);
        } catch (Exception e) {
            logger.error("查询馆藏详情页馆藏列表时出错",e);
        }
        return list;
    }

    /**
     * 馆藏详情页馆藏列表显示
     * @param page 分页信息
     * @param record 馆藏信息
     * @return
     */
    public List<CmsAntique> queryAntiqueListForIndex(Pagination page,CmsAntique record,PaginationApp pageApp){
        Map<String,Object> map = new HashMap<String, Object>();
        List<CmsAntique> list = null;
        try {
            if (StringUtils.isNotBlank(record.getAntiqueName())){
                map.put("antiqueName","%"+record.getAntiqueName()+"%");
            }
            if(record.getAntiqueIsDel() != null){
                map.put("antiqueIsDel",record.getAntiqueIsDel());
            }else{
                record.setAntiqueIsDel(Constant.NORMAL);
                map.put("antiqueIsDel",Constant.NORMAL);
            }
            if(record.getAntiqueState() != null){
                map.put("antiqueState",record.getAntiqueState());
            }
            //藏品年代筛选
            if (StringUtils.isNotBlank(record.getAntiqueYears())){
                map.put("antiqueYears",record.getAntiqueYears());
            }
            //藏品类型
            if(StringUtils.isNotBlank(record. getAntiqueTypeId())){
                map.put("antiqueTypeId",record.getAntiqueTypeId());
            }

            //app根据展馆id查询
            if(record.getVenueId()!=null){
                 map.put("venueId",record.getVenueId());
            }
            //网页分页
            if (page != null && page.getFirstResult() != null && page.getRows() != null) {
                int total = this.queryCmsAntiqueCountByCondition(map);
                //设置分页的总条数来获取总页数
                page.setTotal(total);
                page.setRows(page.getRows());
                map.put("firstResult",page.getFirstResult());
                map.put("rows",page.getRows());
            }
            //app分页
            if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
                map.put("firstResult", pageApp.getFirstResult());
                map.put("rows", pageApp.getRows());
              //  pageApp.setTotal(commentMapper.queryCommentCountByCondition(map));
            }
            list = cmsAntiqueMapper.queryCmsAntiqueByCondition(map);
        } catch (Exception e) {
            logger.error("查询馆藏信息时出错",e);
        }
        return list;
    }

    /**
     * 馆藏详情页推荐馆藏
     * @param cmsAntique 馆藏
     * @param page 分页
     * @return
     */
    @Override
    public List<CmsAntique> queryRelatedAntique(CmsAntique cmsAntique, Pagination page) {
        Map<String,Object> map = new HashMap<>();
        if(cmsAntique.getAntiqueIsDel() != null){
            map.put("antiqueIsDel",cmsAntique.getAntiqueIsDel());
        }else{
            cmsAntique.setAntiqueIsDel(Constant.NORMAL);
            map.put("antiqueIsDel",Constant.NORMAL);
        }
        if(cmsAntique.getAntiqueState() != null){
            map.put("antiqueState",cmsAntique.getAntiqueState());
        }
        if(cmsAntique.getVenueId()!=null){
            map.put("venueId",cmsAntique.getVenueId());
        }
        //如果含有exclude 代表不包含给定条件的ID
        if(StringUtils.isNotBlank(cmsAntique.getAntiqueId())){
            if(cmsAntique.getAntiqueId().contains("exclude")){
                map.put("antiqueIdExclude",cmsAntique.getAntiqueId().replace("exclude",""));
            }else{
                map.put("antiqueId",cmsAntique.getAntiqueId());
            }
        }
        if (page != null) {
            map.put("firstResult",0);
            map.put("rows",page.getRows());
        }
        return cmsAntiqueMapper.queryRelatedAntique(map);
    }

    @Override
    public String updateAntiqueStateById(String antiqueId, SysUser user) {
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("antiqueId",antiqueId);
        map.put("userId",user.getUserId());
        map.put("updateTime",new Date());
        cmsAntiqueMapper.updateAntiqueStateById(map);
        return Constant.RESULT_STR_SUCCESS;
    }

    @Override
    public String deleteAntiqueById(String antiqueId) {

        cmsAntiqueMapper.deleteAntiqueById(antiqueId);
        return Constant.RESULT_STR_SUCCESS;
    }



    /**
     * 带条件查询符合的统计数据[平台内容统计--藏品统计]
     * @param cmsAntique
     * @return
     */
    @Override
    public List<CmsAntique> queryAntiqueStatistic(CmsAntique cmsAntique) {

        return cmsAntiqueMapper.queryAntiqueStatistic(cmsAntique);
    }

	@Override
	public int countAntique(Map<String, Object> map) {
		return cmsAntiqueMapper.countAntique(map);
	}
}
