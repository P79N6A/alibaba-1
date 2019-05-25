package com.sun3d.why.service;

import com.sun3d.why.model.CmsAntique;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;
import org.apache.activemq.store.kahadb.disk.page.Page;

import java.util.List;
import java.util.Map;

/**
 * <p>
 * 藏品管理Service接口
 * Created by cj on 2015/4/21.
 * </p>
 */
public interface CmsAntiqueService {

    /**
     * 根据藏品主键id获取藏品信息
     *
     * @param antiqueId String 藏品主键id
     * @return CmsAntique 藏品模型
     */
    CmsAntique queryCmsAntiqueById(String antiqueId);

    /**
     * 新增一条完整的藏品信息
     *
     * @param record CmsAntique 藏品模型
     * @param sysUser 系统用户
     * @return int 成功返回1
     */
    int addCmsAntique(CmsAntique record,SysUser sysUser);

    /**
     * 编辑藏品信息
     *
     * @param record CmsAntique 藏品信息
     * @param sysUser 系统用户
     * @return int 成功返回1
     */
    int editCmsAntique(CmsAntique record,SysUser sysUser);

    /**
     * 逻辑删除藏品信息
     *
     * @param record CmsAntique 藏品信息
     * @param sysUser 系统用户
     * @return int 成功返回1
     */
    int deleteCmsAntique(CmsAntique record,SysUser sysUser);

    /**
     * 逻辑恢复藏品信息
     *
     * @param record CmsAntique 藏品信息
     * @param sysUser 系统用户
     * @return int 成功返回1
     */
    int recoverCmsAntique(CmsAntique record,SysUser sysUser);

    /**
     * 根据分页信息、馆藏信息、场馆信息以及用户信息进行馆藏列表查询
     *
     * @param page 分页信息
     * @param record 馆藏信息
     * @param cmsVenue 场馆信息
     * @param sysUser 系统用户
     * @return List<CmsAntique> 馆藏列表
     */
    List<CmsAntique> queryCmsAntiqueByCondition(Pagination page,CmsAntique record,CmsVenue cmsVenue,SysUser sysUser);

    /**
     * 与 queryCmsAntiqueByCondition 写在一起，用于返回查询总记录
     *
     * @param map 查询条件以及值都已经按要求设定好的MAP
     * @return 根据条件查询完后的总个数
     */
    int queryCmsAntiqueCountByCondition(Map<String,Object> map);

    /**
     * 根据馆藏信息进行带条件分页查询
     *
     * @param record CmsAntique 馆藏信息
     * @return List<CmsAntique> 馆藏列表
     */
   List<CmsAntique> queryByCmsAntique(CmsAntique record);

    /**
     * 根据区县以及分页信息返回给定数量的馆藏信息
     *
     * @param areaCode 区县信息
     * @param page 分页信息
     * @return List<CmsAntique> 馆藏列表
     */
    List<CmsAntique> queryBestWelcomeAntique(String areaCode,Pagination page);

    /**
     * 根据馆藏信息查询出最受欢迎馆藏的数量
     *
     * @param cmsAntique 馆藏信息
     * @return
     */
    int countBestWelcomeAntique(CmsAntique cmsAntique);

    /**
     * 馆藏详情页馆藏列表显示
     * @param cmsAntique 馆藏信息
     * @return
     */
    List<CmsAntique> queryAntiqueDetailList(CmsAntique cmsAntique);


    /**
     * 馆藏详情页馆藏列表显示
     * @param page 分页信息
     * @param cmsAntique 馆藏信息
     * @return
     */
    //List<CmsAntique> queryAntiqueListForIndex(Pagination page,CmsAntique record);
    List<CmsAntique> queryAntiqueListForIndex(Pagination page, CmsAntique cmsAntique, PaginationApp pageApp);

    /**
     * 馆藏详情页推荐馆藏
     * @param cmsAntique 馆藏
     * @param page 分页
     * @return
     */
    List<CmsAntique> queryRelatedAntique(CmsAntique cmsAntique,Pagination page);

    String updateAntiqueStateById(String antiqueId,SysUser user);

    String deleteAntiqueById(String antiqueId);

    /**
     * 带条件查询符合的统计数据[平台内容统计--藏品统计]
     * @param cmsAntique
     * @return
     */
    List<CmsAntique> queryAntiqueStatistic(CmsAntique cmsAntique);
    
    int countAntique(Map<String, Object> map);
}
