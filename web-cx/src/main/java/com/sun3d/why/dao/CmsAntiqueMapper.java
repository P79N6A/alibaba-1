package com.sun3d.why.dao;

import com.sun3d.why.model.CmsAntique;

import java.util.List;
import java.util.Map;

/**
 * 藏品模块的数据操作层，这里直接对应的sqlmaps文件夹下面的mapping文件映射，由Mybatis Generator自动生成
 * 如果不想用自动生成的方法，可以自定义添加方法实现，这里的dao文件对应sqlmaps下面的xml文件
 * 方法名称对应Mybatis文件中的id
 *
 * @author cj 2015/04/21
 */
public interface CmsAntiqueMapper {

    /**
     * 新增一条完整的藏品信息，模型信息固定所有属性
     *
     * @param record CmsAntique 藏品模型
     * @return int 成功返回1
     */
    int addCmsAntique(CmsAntique record);

    /**
     * 根据藏品主键id来修改藏品所有信息
     *
     * @param record CmsAntique 藏品信息
     * @return int 成功返回1
     */
    int editCmsAntique(CmsAntique record);

    /**
     * 根据藏品主键id获取藏品信息
     *
     * @param antiqueId String 藏品主键id
     * @return CmsAntique 藏品模型
     */
    CmsAntique queryCmsAntiqueById(String antiqueId);

    /**
     * 根据map中对应key值传入的参数作为where条件进行带条件分页查询
     * @param map
     * @return
     */
    List<CmsAntique> queryCmsAntiqueByCondition(Map<String,Object> map);

    /**
     * 根据map中对应key值传入的参数作为where条件进行带条件查询记录个数
     * @param map
     * @return
     */
    int queryCmsAntiqueCountByCondition(Map<String,Object> map);

    /**
     * 根据查询条件封装而成的MAP查询馆藏列表
     *
     * @param map
     * @return List<CmsAntique> 馆藏列表
     */
    List<CmsAntique> queryBestWelcomeAntique(Map<String,Object> map);

    /**
     * 根据查询条件封装而成的MAP查询馆藏列表数量
     *
     * @param map
     * @return List<CmsAntique> 馆藏列表
     */
    int countBestWelcomeAntique(Map<String,Object> map);

    //前台场馆显示详情获取推荐馆藏
    List<CmsAntique> queryCmsAntique(Map<String, Object> map);

    //前台场馆显示详情获取推荐馆藏总数
    int countAntique(Map<String, Object> map);

    int updateAntiqueStateById(Map<String,Object> map);
    int deleteAntiqueById(String antiqueId);


    /**
     * app根据展馆id获取藏品名称
     * @param map
     * @return
     */
    List<CmsAntique> queryAppAntiqueList(Map<String, Object> map);
    
    /**
     * app根据藏品类别和年代筛选藏品名称
     * @param map
     * @return
     */
    List<CmsAntique> queryAppAntique(Map<String, Object> map);

    /**
     * app根据藏品类别筛选藏品名称
     * @param map
     * @return
     */
    List<CmsAntique> queryAppAntiqueTypeNameList(Map<String, Object> map);
    /**
     * app根据藏品年代筛选藏品名称
     * @param map
     * @return
     */
    List<CmsAntique> queryAppAntiqueDynastyList(Map<String, Object> map);


    /**
     * 带条件查询符合的统计数据[平台内容统计--藏品统计]
     * @param cmsAntique
     * @return
     */
    List<CmsAntique> queryAntiqueStatistic(CmsAntique cmsAntique);

    /**
     * 推荐馆藏
     * @param map
     * @return
     */
    List<CmsAntique> queryRelatedAntique(Map<String,Object> map);

    /**
     * why3.5 app根据展馆id获取藏品个数
     * @param map
     * @return
     */
    int queryAppAntiqueListCount(Map<String, Object> map);
}