package com.sun3d.why.service;

import com.culturecloud.model.bean.common.CcpInformation;
import com.sun3d.why.dao.dto.CcpInformationDto;
import com.sun3d.why.dao.dto.CcpInformationDto1;
import com.sun3d.why.util.Pagination;

import java.util.List;

public interface CcpInformationService {

	 /**
     * 根据活动对象查询活动列表信息
     *
     * @param information 活动对象
     * @param page     分页对象
     * @param sysUser  用户对象
     * @return 活动列表信息
     */
    List<CcpInformationDto1> informationList(CcpInformation information, String userId, Integer pageIndex, Integer pageNum, String shopPath);

    /**
     * 根据活动对象查询活动列表信息,带上明细
     *
     * @param information 活动对象
     * @param page     分页对象
     * @param sysUser  用户对象
     * @return 活动列表信息
     */
    List<CcpInformationDto> informationListWithDetail(CcpInformation information, String userId, Pagination page, String shopPath);


    /**
     * 根据活动对象查询活动列表信息
     *
     * @return 活动列表信息
     */
    CcpInformationDto getInformation(String informationId, String userId);


    /**
     * 查询用户资讯点赞 收藏信息
     * @param informationId
     * @param userId
     * @return
     */
    CcpInformationDto queryInformationUserInfo(String informationId, String userId);

    /**
     * 根据id查询
     * @param advertUrl
     * @return
     */
    CcpInformation queryInformationById(String advertUrl);

    List<CcpInformation> pcnewInfo(int i);
}
