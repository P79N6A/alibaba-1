package com.sun3d.why.webservice.service;
import com.sun3d.why.util.PaginationApp;
/**
 * 藏品列表
 */
public interface AntiqueAppService {
    /**
     * app根据展馆id获取藏品列表
     * @param venueId 展馆id
     * @param pageApp 分页对象
     * @return
     */
    String  queryAppAntiqueListById(String venueId, PaginationApp pageApp);

    /**
     * app根据藏品类别名称筛选藏品列表
     * @param antiqueTypeName 藏品类别名称
     * @param venueId 展馆id
     * @param pageApp 分页对象
     * @return
     */
    String queryAppAntiqueListByTypeName(String antiqueTypeName, PaginationApp pageApp,String venueId);

    /**
     * app根据藏品年代获取藏品列表
     * @param antiqueDynasty 藏品年代
     * @param pageApp 分页对象
     * @param venueId 展馆id
     * @return
     */
    String queryAppAntiqueListByDynasty(String antiqueDynasty, PaginationApp pageApp,String venueId);

    /**
     * app根据藏品id获取藏品信息
     * @param antiqueId 藏品id
     * @return
     */
    String queryAppAntiqueById(String antiqueId);
}
