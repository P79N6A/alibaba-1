
package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsVenueSeatMapper;
import com.sun3d.why.dao.CmsVenueSeatTemplateMapper;
import com.sun3d.why.model.CmsVenueSeat;
import com.sun3d.why.model.CmsVenueSeatTemplate;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsVenueSeatTemplateService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.DomUtil;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@Transactional
public class CmsVenueSeatTemplateServiceImpl implements CmsVenueSeatTemplateService {

    @Autowired
    private CmsVenueSeatTemplateMapper cmsVenueSeatTemplateMapper;

    @Autowired
    private CmsVenueSeatMapper cmsVenueSeatMapper;

    private Logger logger = Logger.getLogger(CmsVenueSeatTemplateServiceImpl.class);

    /**
     * 根据模板ID删除对应的场馆座位模板记录
     * @param templateId 模板ID
     * @return
     */
    @Override
    public int deleteVenueSeatTemplateById(String templateId) {

        return cmsVenueSeatTemplateMapper.deleteVenueSeatTemplateById(templateId);
    }

    /**
     * 添加场馆座位模板记录
     * @param record 场馆座位模板信息
     * @return
     */
    @Override
    public int addCmsVenueSeatTemplate(CmsVenueSeatTemplate record) {

        return cmsVenueSeatTemplateMapper.addCmsVenueSeatTemplate(record);
    }

    /**
     * 根据场馆座位模板ID查询单条场馆座位模板记录
     * @param templateId 场馆模板ID
     * @return
     */
    @Override
    public CmsVenueSeatTemplate queryVenueSeatTemplateById(String templateId) {

        return cmsVenueSeatTemplateMapper.queryVenueSeatTemplateById(templateId);
    }

    /**
     * 编辑场馆座位模板记录
     * @param record 场馆座位模板信息
     * @return
     */
    @Override
    public int editCmsVenueSeatTemplate(CmsVenueSeatTemplate record) {

        return cmsVenueSeatTemplateMapper.editCmsVenueSeatTemplate(record);
    }

    /**
     * 将场馆座位模板对象作为条件查询符合条件的所有场馆座位模板
     * @param cmsVenueSeatTemplate 场馆模板信息
     * @return
     */
    @Override
    public List<CmsVenueSeatTemplate> queryVenueSeatTemplateByCondition(CmsVenueSeatTemplate cmsVenueSeatTemplate,Pagination page) {
        cmsVenueSeatTemplate.setRows(page.getRows());
        page.setTotal(queryVenueSeatTemplateCountByCondition(cmsVenueSeatTemplate));
        return cmsVenueSeatTemplateMapper.queryVenueSeatTemplateByCondition(cmsVenueSeatTemplate);
    }

    /**
     * 将场馆座位模板对象作为条件查询符合条件的所有场馆座位模板总记录数
     * @param cmsVenueSeatTemplate 场馆模板信息
     * @return
     */
    @Override
    public int queryVenueSeatTemplateCountByCondition(CmsVenueSeatTemplate cmsVenueSeatTemplate) {

        return cmsVenueSeatTemplateMapper.queryVenueSeatTemplateCountByCondition(cmsVenueSeatTemplate);
    }

    /**
     * 保存场馆座位模板信息并保存场馆模板座位数据
     * @param cmsVenueSeatTemplate 场馆模板信息
     * @param sysUser 操作用户信息
     * @param seatIds 场馆座位状态与Code组成的字符串
     * @return
     */
    @Override
    public boolean addVenueSeatTemplate(final CmsVenueSeatTemplate cmsVenueSeatTemplate,final SysUser sysUser,final String seatIds){
        boolean result = true;

        try {
            Runnable runnable=new Runnable() {
                @Override
                public void run() {
                    if (cmsVenueSeatTemplate != null && sysUser != null) {
                        cmsVenueSeatTemplate.setTemplateId(UUIDUtils.createUUId());
                        cmsVenueSeatTemplate.setTemplateCreateUser(sysUser.getUserId());
                        cmsVenueSeatTemplate.setTemplateUpdateUser(sysUser.getUserId());
                        cmsVenueSeatTemplate.setTemplateCreateTime(new Date());
                        cmsVenueSeatTemplate.setTemplateUpdateTime(new Date());
                        cmsVenueSeatTemplateMapper.addCmsVenueSeatTemplate(cmsVenueSeatTemplate);

                        if (StringUtils.isNotBlank(cmsVenueSeatTemplate.getVenueId()) && StringUtils.isNotBlank(seatIds)) {
                            int row = 0;
                            int column = 0;
                            String seatData = "";
                            String seatStatus = "";
                            String seatCode = "";
                            String seatVal = "";
                            CmsVenueSeat cmsVenueSeat = null;


                            String[] seatIdArr = seatIds.split(",");
                            for (int i = 0; i < seatIdArr.length; i++) {
                                seatData = seatIdArr[i];

                                String[] statusAndCode = seatData.split("-");
                                seatStatus = statusAndCode[0];
                                seatCode = statusAndCode[1];
                                seatVal = statusAndCode[2];

                                row = Integer.parseInt(seatCode.substring(0, seatCode.indexOf("_")));
                                column = Integer.parseInt(seatCode.substring(seatCode.indexOf("_") + 1, seatCode.length()));

                                cmsVenueSeat = new CmsVenueSeat();
                                cmsVenueSeat.setSeatId(UUIDUtils.createUUId());
                                cmsVenueSeat.setTemplateId(cmsVenueSeatTemplate.getTemplateId());
                                cmsVenueSeat.setSeatRow(row);
                                cmsVenueSeat.setSeatColumn(column);
                                cmsVenueSeat.setSeatVal(seatVal);
                                if (seatStatus.equals("D")) {
                                    //D代表座位不存在
                                    cmsVenueSeat.setSeatStatus(Constant.VENUE_SEAT_STATUS_NONE);
                                } else if (seatStatus.equals("U")) {
                                    //U代表座位被占用
                                    cmsVenueSeat.setSeatStatus(Constant.VENUE_SEAT_STATUS_VIP);
                                } else {
                                    //A代表座位可用，暂时除了以上两种状态外其它状态都认为可用
                                    cmsVenueSeat.setSeatStatus(Constant.VENUE_SEAT_STATUS_NORMAL);
                                }
                                cmsVenueSeat.setSeatArea("ALL");
                                cmsVenueSeat.setSeatCode(seatCode);
                                cmsVenueSeat.setSeatCreateTime(new Date());
                                cmsVenueSeat.setSeatCreateUser(sysUser.getUserId());
                                cmsVenueSeat.setSeatUpdateTime(new Date());
                                cmsVenueSeat.setSeatUpdateUser(sysUser.getUserId());
                                cmsVenueSeatMapper.addCmsVenueSeat(cmsVenueSeat);
                            }
                        }
                    }
                }
            };
            Thread thread=new Thread(runnable);
            thread.start();
        } catch (NumberFormatException e) {
            logger.error("添加场馆座位模板出错",e);
            result = false;
        }
        return result;
    }






    /**
     * 保存场馆座位模板信息并保存场馆模板座位数据
     * @param cmsVenueSeatTemplate 场馆模板信息
     * @param sysUser 操作用户信息
     * @param seatIds 场馆座位状态与Code组成的字符串
     * @return
     */
    @Override
    public boolean addVenueSeatTemplate2(CmsVenueSeatTemplate cmsVenueSeatTemplate,SysUser sysUser,String seatIds){
        boolean result = true;
        try {
            List<CmsVenueSeat> cmsVenueSeatList = new ArrayList<CmsVenueSeat>();
            if (cmsVenueSeatTemplate != null && sysUser != null) {
                cmsVenueSeatTemplate.setTemplateId(UUIDUtils.createUUId());
                cmsVenueSeatTemplate.setTemplateCreateUser(sysUser.getUserId());
                cmsVenueSeatTemplate.setTemplateUpdateUser(sysUser.getUserId());
                cmsVenueSeatTemplate.setTemplateCreateTime(new Date());
                cmsVenueSeatTemplate.setTemplateUpdateTime(new Date());
                cmsVenueSeatTemplateMapper.addCmsVenueSeatTemplate(cmsVenueSeatTemplate);

                if (StringUtils.isNotBlank(cmsVenueSeatTemplate.getVenueId()) && StringUtils.isNotBlank(seatIds)) {
                    int row = 0;
                    int column = 0;
                    String seatData = "";
                    String seatStatus = "";
                    String seatCode = "";
                    CmsVenueSeat cmsVenueSeat = null;


                    String[] seatIdArr = seatIds.split(",");
                    for (int i = 0; i < seatIdArr.length; i++) {
                        seatData = seatIdArr[i];

                        String[] statusAndCode = seatData.split("-");
                        seatStatus = statusAndCode[0];
                        seatCode = statusAndCode[1];

                        row = Integer.parseInt(seatCode.substring(0, seatCode.indexOf("_")));
                        column = Integer.parseInt(seatCode.substring(seatCode.indexOf("_") + 1, seatCode.length()));

                        cmsVenueSeat = new CmsVenueSeat();
                        cmsVenueSeat.setSeatId(UUIDUtils.createUUId());
                        cmsVenueSeat.setTemplateId(cmsVenueSeatTemplate.getTemplateId());
                        cmsVenueSeat.setSeatRow(row);
                        cmsVenueSeat.setSeatColumn(column);
                        if (seatStatus.equals("D")) {
                            //D代表座位不存在
                            cmsVenueSeat.setSeatStatus(Constant.VENUE_SEAT_STATUS_NONE);
                        } else if (seatStatus.equals("U")) {
                            //U代表座位被占用
                            cmsVenueSeat.setSeatStatus(Constant.VENUE_SEAT_STATUS_VIP);
                        } else {
                            //A代表座位可用，暂时除了以上两种状态外其它状态都认为可用
                            cmsVenueSeat.setSeatStatus(Constant.VENUE_SEAT_STATUS_NORMAL);
                        }
                        cmsVenueSeat.setSeatArea("ALL");
                        cmsVenueSeat.setSeatCode(seatCode);
                        cmsVenueSeat.setSeatCreateTime(new Date());
                        cmsVenueSeat.setSeatCreateUser(sysUser.getUserId());
                        cmsVenueSeat.setSeatUpdateTime(new Date());
                        cmsVenueSeat.setSeatUpdateUser(sysUser.getUserId());
//                        cmsVenueSeatMapper.addCmsVenueSeat(cmsVenueSeat);
                        cmsVenueSeatList.add(cmsVenueSeat);
                    }
                }
                DomUtil.writeFile(cmsVenueSeatList);
            }
        } catch (NumberFormatException e) {
            logger.error("添加场馆座位模板出错",e);
            result = false;
        }
        return result;
    }







    /**
     * 编辑场馆座位模板信息并保存场馆模板座位数据
     * @param cmsVenueSeatTemplate 场馆模板信息
     * @param sysUser 操作用户信息
     * @param seatIds 场馆座位状态与Code组成的字符串
     * @return
     */
    @Override
    public boolean editVenueSeatTemplate(final CmsVenueSeatTemplate cmsVenueSeatTemplate,final SysUser sysUser,final String seatIds){
        boolean result = true;

        try {
            Runnable runnable=new Runnable() {
                @Override
                public void run() {

                    if (cmsVenueSeatTemplate != null && sysUser != null) {
                        //编辑座位模板信息
                        cmsVenueSeatTemplate.setTemplateUpdateUser(sysUser.getUserId());
                        cmsVenueSeatTemplate.setTemplateUpdateTime(new Date());
                        cmsVenueSeatTemplateMapper.editCmsVenueSeatTemplate(cmsVenueSeatTemplate);

                        if (StringUtils.isNotBlank(cmsVenueSeatTemplate.getVenueId()) && StringUtils.isNotBlank(seatIds)) {
                            String seatData = "";
                            String seatStatus = "";
                            String seatCode = "";
                            String seatVal = "";
                            CmsVenueSeat cmsVenueSeat = null;

                            String[] seatIdArr = seatIds.split(",");
                            for (int i = 0; i < seatIdArr.length; i++) {
                                seatData = seatIdArr[i];

                                String[] statusAndCode = seatData.split("-");
                                seatStatus = statusAndCode[0];
                                seatCode = statusAndCode[1];
                                seatVal = statusAndCode[2];

                                Map<String, Object> map = new HashMap<String, Object>();
                                map.put("templateId", cmsVenueSeatTemplate.getTemplateId());
                                map.put("seatCode", seatCode);
                                map.put("firstResult", 0);
                                map.put("rows", 1);
                                List<CmsVenueSeat> venueSeatList = cmsVenueSeatMapper.queryCmsVenueSeatByCondition(map);
                                if (venueSeatList != null && venueSeatList.size() > 0) {
                                    //正常情况下应该只会有一条
                                    cmsVenueSeat = venueSeatList.get(0);

                                    if (seatStatus.equals("D")) {
                                        //D代表座位不存在
                                        cmsVenueSeat.setSeatStatus(Constant.VENUE_SEAT_STATUS_NONE);
                                    } else if (seatStatus.equals("U")) {
                                        //U代表座位被占用
                                        cmsVenueSeat.setSeatStatus(Constant.VENUE_SEAT_STATUS_VIP);
                                    } else {
                                        //A代表座位可用，暂时除了以上两种状态外其它状态都认为可用
                                        cmsVenueSeat.setSeatStatus(Constant.VENUE_SEAT_STATUS_NORMAL);
                                    }
                                    cmsVenueSeat.setSeatUpdateTime(new Date());
                                    cmsVenueSeat.setSeatUpdateUser(sysUser.getUserId());
                                    cmsVenueSeat.setSeatVal(seatVal);
                                    cmsVenueSeatMapper.editCmsVenueSeat(cmsVenueSeat);
                                }
                            }
                        }
                    }
                }
            };
            Thread thread=new Thread(runnable);
            thread.start();
        } catch (NumberFormatException e) {
            logger.error("修改场馆座位模板出错",e);
            result = false;
        }
        return result;
    }
}
