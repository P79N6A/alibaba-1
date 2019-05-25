package com.culturecloud.dao.venue;

import com.culturecloud.model.bean.venue.CmsVenueSeatTemplate;

public interface CmsVenueSeatTemplateMapper {

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table cms_venue_seat_template
	 * @mbggenerated  Mon Jul 25 16:20:45 CST 2016
	 */
	int deleteByPrimaryKey(String templateId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table cms_venue_seat_template
	 * @mbggenerated  Mon Jul 25 16:20:45 CST 2016
	 */
	int insert(CmsVenueSeatTemplate record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table cms_venue_seat_template
	 * @mbggenerated  Mon Jul 25 16:20:45 CST 2016
	 */
	int insertSelective(CmsVenueSeatTemplate record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table cms_venue_seat_template
	 * @mbggenerated  Mon Jul 25 16:20:45 CST 2016
	 */
	CmsVenueSeatTemplate selectByPrimaryKey(String templateId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table cms_venue_seat_template
	 * @mbggenerated  Mon Jul 25 16:20:45 CST 2016
	 */
	int updateByPrimaryKeySelective(CmsVenueSeatTemplate record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table cms_venue_seat_template
	 * @mbggenerated  Mon Jul 25 16:20:45 CST 2016
	 */
	int updateByPrimaryKeyWithBLOBs(CmsVenueSeatTemplate record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table cms_venue_seat_template
	 * @mbggenerated  Mon Jul 25 16:20:45 CST 2016
	 */
	int updateByPrimaryKey(CmsVenueSeatTemplate record);
}