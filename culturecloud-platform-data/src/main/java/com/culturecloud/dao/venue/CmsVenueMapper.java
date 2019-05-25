package com.culturecloud.dao.venue;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.culturecloud.dao.dto.venue.CmsVenueDto;
import com.culturecloud.model.bean.venue.CmsVenue;

public interface CmsVenueMapper {
	
	List<CmsVenueDto> searchByName(@Param("keyword") String keyword,@Param("limit")int limit);
	
	
	List<CmsVenueDto> searchByAddress(@Param("keyword") String keyword,@Param("limit")int limit);
	
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table cms_venue
     *
     * @mbggenerated Mon Jul 25 16:03:35 CST 2016
     */
    int deleteByPrimaryKey(String venueId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table cms_venue
     *
     * @mbggenerated Mon Jul 25 16:03:35 CST 2016
     */
    int insert(CmsVenue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table cms_venue
     *
     * @mbggenerated Mon Jul 25 16:03:35 CST 2016
     */
    int insertSelective(CmsVenue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table cms_venue
     *
     * @mbggenerated Mon Jul 25 16:03:35 CST 2016
     */
    CmsVenue selectByPrimaryKey(String venueId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table cms_venue
     *
     * @mbggenerated Mon Jul 25 16:03:35 CST 2016
     */
    int updateByPrimaryKeySelective(CmsVenue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table cms_venue
     *
     * @mbggenerated Mon Jul 25 16:03:35 CST 2016
     */
    int updateByPrimaryKeyWithBLOBs(CmsVenue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table cms_venue
     *
     * @mbggenerated Mon Jul 25 16:03:35 CST 2016
     */
    int updateByPrimaryKey(CmsVenue record);
}