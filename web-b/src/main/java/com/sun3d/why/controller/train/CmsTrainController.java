package com.sun3d.why.controller.train;

import com.sun3d.why.dao.CmsTagSubMapper;
import com.sun3d.why.dao.train.CmsTrainEnrolmentMapper;
import com.sun3d.why.model.CmsComment;
import com.sun3d.why.model.CmsTagSub;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.AreaData;
import com.sun3d.why.model.train.*;
import com.sun3d.why.service.CmsCommentService;
import com.sun3d.why.service.CmsVenueService;
import com.sun3d.why.service.train.CmsTrainService;
import com.sun3d.why.util.*;
import org.apache.commons.collections.map.HashedMap;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
/*import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;*/
import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipOutputStream;
import sun.java2d.pipe.SpanShapeRenderer;

@Controller
@RequestMapping("/train")
public class CmsTrainController {

    private Logger logger = LoggerFactory.getLogger(CmsTrainController.class);

    @Autowired
    private HttpSession session;

    @Autowired
    private CmsTrainService trainService;

    @Autowired
    private ExportExcel exportExcel;

    @Autowired
    private CmsCommentService commentService;

    @Autowired
    private CmsTrainEnrolmentMapper enrolmentMapper;

    @Autowired
    private CmsTagSubMapper tagSubMapper;

    @Autowired
    private CmsVenueService venueService;

    /**
     * 新增培训页
     *
     * @return
     */
    @RequestMapping("/add")
    public String preActivityDetail(CmsTrain train, HttpServletRequest request) {
        SysUser sysUser = (SysUser)session.getAttribute("user");
        if (StringUtils.isNotBlank(train.getId())) {
            train = trainService.selectByPrimaryKey(train.getId());
            request.setAttribute("train", train);
            if (train.getTrainField() == 2) {
                List<CmsTrainField> fields = trainService.queryTrainFieldListByTrainId(train.getId());
                request.setAttribute("fields", fields);
            }
        }
        request.setAttribute("sysUser",sysUser);
        return "admin/train/add";
    }

    @RequestMapping("/save")
    @ResponseBody
    public Object save(CmsTrain bloBs, String fieldStr) {

        SysUser sysUser = (SysUser) session.getAttribute("user");
        if (sysUser == null) {
            logger.error("当前登录用户不存在，返回登录页!");
            return JSONResponse.getResult(400, "当前登录用户不存在，返回登录页!");
        }
        return trainService.save(bloBs, fieldStr, sysUser);
    }


    /**
     * 培训列表页
     *
     * @param train
     * @return
     */
    @RequestMapping("/trainList")
    public ModelAndView trainList(CmsTrainBean train) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<CmsTrainBean> list = trainService.queryTrainList(train,sysUser);
            List<CmsTagSub> tagSubList = tagSubMapper.queryCommonTag(10);
            model.addObject("tagSubList",tagSubList);
            model.addObject("train", train);
            model.addObject("list", list);
            model.setViewName("admin/train/trainList");
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }

    /**
     * 报名管理列表页
     */
    @RequestMapping("/trainOrderList")
    public ModelAndView trainOrderList(CmsTrainOrderBean orderBean) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            CmsTrainBean train= trainService.selectByPrimaryKey(orderBean.getTrainId());
            if(train.getMaxPeople() == null){
                train.setMaxPeople(0);
            }
            model.addObject("train", train);
            List<CmsTrainOrderBean> list = trainService.queryTrainOrderList(orderBean,sysUser);
            model.addObject("order", orderBean);
            model.addObject("list", list);
            model.setViewName("admin/train/trainOrderList");
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }

    @RequestMapping("/saveOrder")
    @ResponseBody
    public Object saveOrder(CmsTrainOrderBean order,String[] ids) {
        SysUser sysUser = (SysUser) session.getAttribute("user");
        if (sysUser == null) {
            logger.error("当前登录用户不存在，返回登录页!");
            return JSONResponse.getResult(500, "当前登录用户不存在，返回登录页!");
        }
        if(ids!=null){
            for (int i = 0; i < ids.length; i++) {
                order.setId(ids[i]);
                trainService.saveOrder(order, sysUser);
            }
        }else{
            trainService.saveOrder(order, sysUser);
        }
        return JSONResponse.getResult(200, "操作成功!");
    }

    /**
     * 万人培训用户导出
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/exportTrainOrderExcel")
    public void exportTrainOrderExcel(CmsTrainOrderBean orderBean, HttpServletRequest request, HttpServletResponse response) {
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            //导出数据不需要分页，查询全部的的数据
            orderBean.setRows(null);
            List<CmsTrainOrderBean> list = trainService.queryTrainOrderList(orderBean,sysUser);



            File file=File.createTempFile("培训报名列表",".xls");

            NsExcelWriteUtils writer=new NsExcelWriteUtils(file.getPath());


            writer.createSheet("导出用户");

            String []title=new String[]{"培训名称","订单号","姓名","手机号","身份证号","生日","性别","报名时间","状态"};

            writer.createRow(0);
            for (int i = 0; i < title.length; i++) {
                writer.createCell(i, title[i]);
            }

            for (int i = 1; i <= list.size(); i++) {
                writer.createRow(i);
                CmsTrainOrderBean u=list.get(i-1);
                writer.createCell(0, u.getTrainTitle());
                writer.createCell(1, u.getOrderNum());
                writer.createCell(2, u.getName());
                writer.createCell(3, u.getPhoneNum());
                writer.createCell(4, u.getIdCard());
                writer.createCell(5, u.getBirthday());
                writer.createCell(6, u.getSex()==1?"男":"女");
               /* writer.createCell(7, u.getHomeAddress());
                writer.createCell(8, u.getHomeConnector());
                writer.createCell(9, u.getConnectorRelationship());
                writer.createCell(10, u.getConnectorPhoneNum());*/
                writer.createCell(7, DateUtil.dateToString(u.getCreateTime(),"yyyy-MM-dd HH:mm"));
                writer.createCell(8, u.getState()==1?"报名成功":u.getState()==2?"退订":u.getState()==3?"审核中":"审核拒绝");
            }
            writer.createExcel();
            NsExcelWriteUtils.downLoadFileByInputStream(file, "培训报名列表.xls", response);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 报名表导出
     * @param orderBean
     * @param request
     * @param response
     */
    @RequestMapping(value = "/exportTrainOrderWord")
    public void exportTrainOrderWord(CmsTrainOrderBean orderBean, HttpServletRequest request, HttpServletResponse response) {
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            //导出数据不需要分页，查询全部的的数据
            orderBean.setRows(null);
            List<CmsTrainOrderBean> list = trainService.queryTrainOrderList(orderBean,sysUser);



            File file=File.createTempFile("培训报名列表",".xls");

            NsExcelWriteUtils writer=new NsExcelWriteUtils(file.getPath());


            writer.createSheet("导出用户");

            String []title=new String[]{"培训名称","订单号","姓名","手机号","身份证号","生日","性别","报名时间","状态"};

            writer.createRow(0);
            for (int i = 0; i < title.length; i++) {
                writer.createCell(i, title[i]);
            }

            for (int i = 1; i <= list.size(); i++) {
                writer.createRow(i);
                CmsTrainOrderBean u=list.get(i-1);
                writer.createCell(0, u.getTrainTitle());
                writer.createCell(1, u.getOrderNum());
                writer.createCell(2, u.getName());
                writer.createCell(3, u.getPhoneNum());
                writer.createCell(4, u.getIdCard());
                writer.createCell(5, u.getBirthday());
                writer.createCell(6, u.getSex()==1?"男":"女");
                writer.createCell(7, DateUtil.dateToString(u.getCreateTime(),"yyyy-MM-dd HH:mm"));
                writer.createCell(8, u.getState()==1?"报名成功":u.getState()==2?"退订":u.getState()==3?"审核中":"审核拒绝");
            }
            writer.createExcel();
            NsExcelWriteUtils.downLoadFileByInputStream(file, "培训报名列表.xls", response);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @RequestMapping("/trainCommentPreList")
    public ModelAndView trainCommentPreList(CmsTrainBean train){
        ModelAndView model = new ModelAndView();
        SysUser sysUser = (SysUser)session.getAttribute("user");
        List<CmsTrainBean> trainList = trainService.queryTrainList(train,sysUser);
        List<CmsTagSub> tagSubList = tagSubMapper.queryCommonTag(10);
        model.addObject("tagSubList",tagSubList);
        model.addObject("trainList",trainList);
        model.addObject("train", train);
        model.setViewName("admin/train/trainCommentPreList");
        return model;
    }

    @RequestMapping("/allComment")
    public ModelAndView allComment(CmsComment comment,String commentStartTime,String commentEndTime,Pagination page){
        ModelAndView model = new ModelAndView();
        comment.setCommentType(10);
        List<CmsComment> commentList = commentService.queryCmsCommentByCondition(comment,page);
        model.addObject("page",page);
        model.addObject("commentList",commentList);
        model.setViewName("admin/train/commentList");
        return model;
    }

    @RequestMapping("/exportTrainOrderWord2")
    public void exportTrainOrderWord2(CmsTrainOrderBean orderBean, HttpServletRequest request, HttpServletResponse response) throws Exception {
        ZipOutputStream zipOut = new ZipOutputStream(response.getOutputStream());
        zipOut.setEncoding("gbk");
        SysUser sysUser = (SysUser) session.getAttribute("user");
        List<CmsTrainOrderBean> list = trainService.queryTrainOrderList(orderBean,sysUser);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
        String now = sdf.format(new Date());
        int nowDate = Integer.parseInt(now);
        String zipName = "报名表";
        response.setContentType("application/zip;charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment;fileName="+new String( zipName.getBytes("gb2312"), "ISO8859-1" )+".zip");
        Map<String, Object> params = new HashMap<String, Object>();
        for(int i = 0 ; i < list.size();i++){
            params.put("${name}", list.get(i).getName());
            if(list.get(i).getSex() == 1){
                params.put("${sex}", "男");
            }else{
                params.put("${sex}", "女");
            }
            int ageDate = Integer.parseInt(list.get(i).getBirthday().split("-")[0]);
            int nowAge = nowDate - ageDate;
            String realAge = String.valueOf(nowAge);
            params.put("${courseName}",list.get(i).getTrainTitle());
            params.put("${idCard}", list.get(i).getIdCard());
            params.put("${phoneNum}", list.get(i).getPhoneNum());
            params.put("${age}",realAge);
            params.put("${address}",list.get(i).getHomeAddress());
            params.put("${conn}", list.get(i).getHomeConnector());
            params.put("${rel}",list.get(i).getConnectorRelationship());
            params.put("${relPhoNum}",list.get(i).getConnectorPhoneNum());

            WordUtil xwpfTUtil = new WordUtil();

            XWPFDocument doc;
            InputStream is;
            String fileNameInResource = "镇江市老年艺术大学报名表.docx";
            is = this.getClass().getClassLoader().getResourceAsStream(fileNameInResource);
            doc = new XWPFDocument(is);

            xwpfTUtil.replaceInPara(doc, params);
            //替换表格里面的变量
            xwpfTUtil.replaceInTable(doc, params);
            String fileName = "镇江市老年艺术大学报名表--"+ list.get(i).getName()+"--"+ list.get(i).getOrderNum() +".docx";
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            doc.write(out);
            xwpfTUtil.close(out);
            xwpfTUtil.close(is);
            out.flush();
            out.close();

            ByteArrayInputStream bais = new ByteArrayInputStream(out.toByteArray());
            ZipEntry zipEntry = new ZipEntry(fileName);
            zipOut.putNextEntry(zipEntry);
            int len = 0 ;
            byte[] buffer = new byte[1024];
            while ((len = bais.read(buffer)) != -1  ) {
                zipOut.write(buffer, 0, len);
                zipOut.flush();
            }
            zipOut.closeEntry();
            bais.close();
        }
/*        String zipName = "报名表.zip";
        response.setContentType("application/zip;charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment;fileName="+zipName);*/
        zipOut.close();
    }

    @RequestMapping("/sendStartMessage")
    @ResponseBody
    public Object sendStartMessage(CmsTrainOrderBean orderBean,HttpServletRequest request, HttpServletResponse response){
        SysUser sysUser = (SysUser) session.getAttribute("user");
        if (sysUser == null) {
            logger.error("当前登录用户不存在，返回登录页!");
            return JSONResponse.getResult(500, "当前登录用户不存在，返回登录页!");
        }
        List<CmsTrainOrderBean> list = trainService.queryTrainOrderList(orderBean,sysUser);
        Map<String,Object> params = new HashMap<>();
        for (CmsTrainOrderBean bean : list) {
            /*if(bean.getCourseType() == 2){
                params.put("courseType","春季班");
            }else{
                params.put("courseType","秋季班");
            }*/
            params.put("trainName",bean.getTrainTitle());
            params.put("trainStartTime",bean.getTrainStartTime());
            params.put("location",bean.getTrainAddress());
            SmsUtil.sendStartMessage(bean.getPhoneNum(),params);
        }
        return JSONResponse.getResult(200,"发送开课通知短信成功");
    }

    /**
     * 报名管理列表页
     */
    @RequestMapping("/allTrainOrderList")
    public ModelAndView allTrainOrderList(CmsTrainOrderBean orderBean) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<CmsTrainOrderBean> list = trainService.queryTrainOrderList(orderBean,sysUser);
            model.addObject("order", orderBean);
            model.addObject("list", list);
            model.setViewName("admin/train/allTrainOrderList");
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }

    /**
     * 报名简章管理页
     */
    @RequestMapping("/trainEnrolment")
    public ModelAndView trainEnrolment(){
        ModelAndView model = new ModelAndView();
        CmsTrainEnrolment enrolment = enrolmentMapper.selectAll();
        model.addObject("enrolment",enrolment);
        model.setViewName("admin/train/enrolment");
        return model;
    }

    /**
     * 保存报名简章
     */
    @RequestMapping("/saveEnrolment")
    @ResponseBody
    public String saveEnrolment(CmsTrainEnrolment enrolment){
        SysUser sysUser = (SysUser) session.getAttribute("user");
        if (sysUser == null) {
            logger.error("当前登录用户不存在，返回登录页!");
            return JSONResponse.getResult(500, "当前登录用户不存在，返回登录页!");
        }
        if(StringUtils.isNotBlank(enrolment.getId())){
            enrolmentMapper.updateByPrimaryKey(enrolment);
        }else{
            enrolment.setId(UUIDUtils.createUUId());
            enrolment.setCreateUser(sysUser.getUserId());
            enrolment.setCreateTime(new Date());
            enrolmentMapper.insert(enrolment);
        }
        return JSONResponse.getResult(200, "操作成功!");
    }
}
