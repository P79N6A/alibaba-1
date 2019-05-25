package com.sun3d.why.dao;

import com.sun3d.why.model.ManagementInformation;

import java.util.List;
import java.util.Map;

public interface ManagementInformationMapper {
    int deleteByPrimaryKey(String informationId);


    int insertInformation(ManagementInformation record);

    ManagementInformation selectByInformationId(String informationId);

    int updateByInformationId(ManagementInformation record);
    /**
     * 根据传入的map查询咨询管理的总条数
     * @param map 查询条件
     * @return 咨询管理总条数
     */
    int informationListCount(Map<String, Object> map);
    /**
     * 根据传入的map查询咨询管理列表信息
     * @param map  查询条件
     * @return 咨询管理列表信息
     */
    List<ManagementInformation> informationList(Map<String, Object> map);

}