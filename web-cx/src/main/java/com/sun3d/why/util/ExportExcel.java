package com.sun3d.why.util;
import com.sun3d.why.model.CmsActivityOrderDetail;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.service.SysDictService;


import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.HSSFColor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import weibo4j.ShortUrl;

import javax.servlet.ServletOutputStream;
import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
/**
 * Created by yujinbing on 2015/8/17.
 * @author yujinbing
 * @param <T>
 */
@Component
public class ExportExcel<T> {

    @Autowired
    private SysDictService sysDictService;

    /**
     *
     * @param title
     * @param sysDictTemplateCode  模版名称
     * @param dataSet
     * @param out
     * @param pattern
     */
    @SuppressWarnings("unchecked")
    public String exportActivityExcel(String title, String sysDictTemplateCode, Collection<T> dataSet, ServletOutputStream out, String pattern) {
        List<SysDict> sysDictList =  sysDictService.querySysDictByCode(sysDictTemplateCode);
        String templateCode = "";
        String[] headers = null;
        if (sysDictList != null && sysDictList.size() > 0) {
            templateCode = sysDictList.get(0).getDictRemark();
        }
        Map map = new HashMap();
        if (StringUtils.isNotNull(templateCode)) {
            String[] templateInfo  =templateCode.split(",");
            headers = new String[templateInfo.length];
            int i = 0;
            for (String keyValue : templateInfo) {
                headers[i] = keyValue.split(":")[1];
                map.put(keyValue.split(":")[0],i);
                i++;
            }
        }
        // 声明一个工作薄
        HSSFWorkbook workbook = new HSSFWorkbook();
        // 生成一个表格
        HSSFSheet sheet = workbook.createSheet(title);
        // 设置表格默认列宽度为15个字节
        sheet.setDefaultColumnWidth((short) 15);
        // 生成一个样式
        HSSFCellStyle style = workbook.createCellStyle();
        // 设置这些样式
        style.setFillForegroundColor(HSSFColor.SKY_BLUE.index);
        style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style.setBorderRight(HSSFCellStyle.BORDER_THIN);
        style.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        // 生成一个字体
        HSSFFont font = workbook.createFont();
        font.setColor(HSSFColor.VIOLET.index);
        font.setFontHeightInPoints((short) 12);
        font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
        // 把字体应用到当前的样式
        style.setFont(font);
        // 生成并设置另一个样式
        HSSFCellStyle style2 = workbook.createCellStyle();
        style2.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
        style2.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style2.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style2.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style2.setBorderRight(HSSFCellStyle.BORDER_THIN);
        style2.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style2.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        style2.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
        // 生成另一个字体
        HSSFFont font2 = workbook.createFont();
        font2.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);
        // 把字体应用到当前的样式
        style2.setFont(font2);

        // 声明一个画图的顶级管理器
        HSSFPatriarch patriarch = sheet.createDrawingPatriarch();
        // 定义注释的大小和位置,详见文档
        HSSFComment comment = patriarch.createComment(new HSSFClientAnchor(0, 0, 0, 0, (short) 4, 2, (short) 6, 5));
        // 设置注释内容
        comment.setString(new HSSFRichTextString(""));
        // 设置注释作者，当鼠标移动到单元格上是可以在状态栏中看到该内容.
        comment.setAuthor("why");

        // 产生表格标题行
        HSSFRow row = sheet.createRow(0);
        for (short i = 0; i < headers.length; i++)
        {
            HSSFCell cell = row.createCell(i);
            cell.setCellStyle(style);
            HSSFRichTextString text = new HSSFRichTextString(headers[i]);
            cell.setCellValue(text);
        }

        // 遍历集合数据，产生数据行
        Iterator<T> it = dataSet.iterator();
        int index = 0;
        while (it.hasNext())
        {
            index++;
            row = sheet.createRow(index);
            T t = (T) it.next();
            // 利用反射，根据javabean属性的先后顺序，动态调用getXxx()方法得到属性值
            Field[] fields = t.getClass().getDeclaredFields();
            for (short i = 0; i < fields.length; i++)
            {
                Field field = fields[i];
                String fieldName = field.getName();
                //判断是否需要生成该字段
                if (map.containsKey(fieldName)) {
                    try {
                        HSSFCell cell = row.createCell(Integer.valueOf(map.get(fieldName).toString()));
                        cell.setCellStyle(style2);
                        String getMethodName = "get" + fieldName.substring(0, 1).toUpperCase() + fieldName.substring(1);
                        Class tCls = t.getClass();
                        Method getMethod = tCls.getMethod(getMethodName, new Class[]{});
                        Object value = getMethod.invoke(t, new Object[]{});
                        // 判断值的类型后进行强制类型转换
                        String textValue = null;
                        if (value instanceof Boolean) {
                            boolean bValue = (Boolean) value;
                            textValue = "Y";
                            if (!bValue) {
                                textValue = "N";
                            }
                        } else if (value instanceof Date) {
                            Date date = (Date) value;
                            SimpleDateFormat sdf = new SimpleDateFormat(pattern);
                            textValue = sdf.format(date);
                        } else if (value instanceof byte[]) {
                            // 有图片时，设置行高为60px;
                            row.setHeightInPoints(60);
                            // 设置图片所在列宽度为80px,注意这里单位的一个换算
                            sheet.setColumnWidth(i, (short) (35.7 * 80));
                            // sheet.autoSizeColumn(i);
                            byte[] bsValue = (byte[]) value;
                            HSSFClientAnchor anchor = new HSSFClientAnchor(0, 0,
                                    1023, 255, (short) 6, index, (short) 6, index);
                            anchor.setAnchorType(2);
                            patriarch.createPicture(anchor, workbook.addPicture(
                                    bsValue, HSSFWorkbook.PICTURE_TYPE_JPEG));
                        } else {
                            // 其它数据类型都当作字符串简单处理
                            textValue = value.toString();
                        }
                        // 如果不是图片数据，就利用正则表达式判断textValue是否全部由数字组成
                        if (textValue != null) {
                            Pattern p = Pattern.compile("^//d+(//.//d+)?$");
                            Matcher matcher = p.matcher(textValue);
                            if (matcher.matches()) {
                                // 是数字当作double处理
                                cell.setCellValue(Double.parseDouble(textValue));
                            } else {
                                HSSFRichTextString richString = new HSSFRichTextString(
                                        textValue);
                                HSSFFont font3 = workbook.createFont();
                                font3.setColor(HSSFColor.BLUE.index);
                                richString.applyFont(font3);
                                cell.setCellValue(richString);
                            }
                        }
                    }
                    catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }
            }
        }
        try
        {
            workbook.write(out);
            out.flush();
            out.close();
            //return out.toByteArray();
            return Constant.RESULT_STR_SUCCESS;
        }
        catch (IOException e)
        {
            e.printStackTrace();
            return null;
        }
        finally
        {
            try
            {
                out.close();
            }
            catch (IOException e)
            {
                e.printStackTrace();
            }
        }
    }



    /**
     *
     * @param title
     * @param sysDictTemplateCode  模版名称
     * @param dataSet
     * @param out
     * @param pattern
     */
    @SuppressWarnings("unchecked")
    public String exportActivityOrderExcel(String title, String sysDictTemplateCode, Collection<T> dataSet, ServletOutputStream out, String pattern) {
        List<SysDict> sysDictList =  sysDictService.querySysDictByCode(sysDictTemplateCode);
        String templateCode = "";
        String[] headers = null;
        if (sysDictList != null && sysDictList.size() > 0) {
            templateCode = sysDictList.get(0).getDictRemark();
        }
        Map map = new HashMap();
        if (StringUtils.isNotNull(templateCode)) {
            String[] templateInfo  =templateCode.split(",");
            headers = new String[templateInfo.length];
            int i = 0;
            for (String keyValue : templateInfo) {
                headers[i] = keyValue.split(":")[1];
                map.put(keyValue.split(":")[0],i);
                i++;
            }
        }
        // 声明一个工作薄
        HSSFWorkbook workbook = new HSSFWorkbook();
        // 生成一个表格
        HSSFSheet sheet = workbook.createSheet(title);
        // 设置表格默认列宽度为15个字节
        sheet.setDefaultColumnWidth((short) 15);
        // 生成一个样式
        HSSFCellStyle style = workbook.createCellStyle();
        // 设置这些样式
        style.setFillForegroundColor(HSSFColor.SKY_BLUE.index);
        style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style.setBorderRight(HSSFCellStyle.BORDER_THIN);
        style.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        // 生成一个字体
        HSSFFont font = workbook.createFont();
        font.setColor(HSSFColor.VIOLET.index);
        font.setFontHeightInPoints((short) 12);
        font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
        // 把字体应用到当前的样式
        style.setFont(font);
        // 生成并设置另一个样式
        HSSFCellStyle style2 = workbook.createCellStyle();
        style2.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
        style2.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style2.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style2.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style2.setBorderRight(HSSFCellStyle.BORDER_THIN);
        style2.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style2.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        style2.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
        // 生成另一个字体
        HSSFFont font2 = workbook.createFont();
        font2.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);
        // 把字体应用到当前的样式
        style2.setFont(font2);

        // 声明一个画图的顶级管理器
        HSSFPatriarch patriarch = sheet.createDrawingPatriarch();
        // 定义注释的大小和位置,详见文档
        HSSFComment comment = patriarch.createComment(new HSSFClientAnchor(0, 0, 0, 0, (short) 4, 2, (short) 6, 5));
        // 设置注释内容
        comment.setString(new HSSFRichTextString(""));
        // 设置注释作者，当鼠标移动到单元格上是可以在状态栏中看到该内容.
        comment.setAuthor("why");

        // 产生表格标题行
        HSSFRow row = sheet.createRow(0);
        for (short i = 0; i < headers.length; i++)
        {
            HSSFCell cell = row.createCell(i);
            cell.setCellStyle(style);
            HSSFRichTextString text = new HSSFRichTextString(headers[i]);
            cell.setCellValue(text);
        }

        // 遍历集合数据，产生数据行
        Iterator<T> it = dataSet.iterator();
        int index = 0;
        while (it.hasNext())
        {
            index++;
            row = sheet.createRow(index);
            T t = (T) it.next();
            // 利用反射，根据javabean属性的先后顺序，动态调用getXxx()方法得到属性值
            Field[] fields = t.getClass().getDeclaredFields();
            int columnTemp = 0;
            for (short i = 0; i < fields.length; i++)
            {
                Field field = fields[i];
                String fieldName = field.getName();
                //判断是否需要生成该字段
                if (map.containsKey(fieldName)) {
                    try {
                        HSSFCell cell = row.createCell(Integer.valueOf(map.get(fieldName).toString()));
                        cell.setCellStyle(style2);
                        String getMethodName = "get" + fieldName.substring(0, 1).toUpperCase() + fieldName.substring(1);
                        Class tCls = t.getClass();
                        Method getMethod = tCls.getMethod(getMethodName, new Class[]{});
                        Object value = getMethod.invoke(t, new Object[]{});

                        if("activityArea".equals(fieldName)){
                            if(value == null || org.apache.commons.lang3.StringUtils.isBlank(value.toString())){
                                value = "未知";
                            }else{
                                value = value.toString().split(",")[1];
                            }
                        }

                        if("venueName".equals(fieldName)){
                            String methodName = "get" + "createActivityCode".substring(0, 1).toUpperCase() + "createActivityCode".substring(1);
                            Class cls = t.getClass();
                            Method method = cls.getMethod(methodName, new Class[]{});
                            Object v = method.invoke(t, new Object[]{});
                            if(v != null && "1".equals(v.toString())){
                                value = "市级自建";
                            }else if(v != null && "2".equals(v.toString())){
                                value = "区级自建";
                            }else{
                                if(value == null || org.apache.commons.lang3.StringUtils.isBlank(value.toString())){
                                    value = "未知场馆";
                                }
                            }

                        }

                        if("activitySalesOnline".equals(fieldName)){
                            if(value == null || org.apache.commons.lang3.StringUtils.isBlank(value.toString())){
                                value = "未知";
                            }else{
                                if("Y".equals(value.toString())){
                                    value = "在线选座";
                                }else if("N".equals(value.toString())){
                                    value = "自由入座";
                                }
                            }
                        }

                        if("orderName".equals(fieldName)){
                            if(value ==null || org.apache.commons.lang3.StringUtils.isBlank(value.toString())){
                                value = "未知预订人";
                            }
                        }

                        if("orderPayStatus".equals(fieldName)){
                            if(value != null && org.apache.commons.lang3.StringUtils.isNotBlank(value.toString())){
                                if("1".equals(value.toString())){
                                    value = "未出票";
                                }else if("2".equals(value.toString())){
                                    value = "已取消";
                                }else if("3".equals(value.toString())){
                                    value = "已出票";
                                }else if("4".equals(value.toString())){
                                    value = "已验票";
                                }else if("5".equals(value.toString())){
                                    value = "已失效";
                                }
                            }
                        }
                        // 判断值的类型后进行强制类型转换
                        String textValue = null;
                        if (value instanceof Boolean) {
                            boolean bValue = (Boolean) value;
                            textValue = "Y";
                            if (!bValue) {
                                textValue = "N";
                            }
                        } else if (value instanceof Date) {
                            Date date = (Date) value;
                            SimpleDateFormat sdf = new SimpleDateFormat(pattern);
                            textValue = sdf.format(date);
                        } else if (value instanceof byte[]) {
                            // 有图片时，设置行高为60px;
                            row.setHeightInPoints(60);
                            // 设置图片所在列宽度为80px,注意这里单位的一个换算
                            sheet.setColumnWidth(i, (short) (35.7 * 80));
                            // sheet.autoSizeColumn(i);
                            byte[] bsValue = (byte[]) value;
                            HSSFClientAnchor anchor = new HSSFClientAnchor(0, 0,
                                    1023, 255, (short) 6, index, (short) 6, index);
                            anchor.setAnchorType(2);
                            patriarch.createPicture(anchor, workbook.addPicture(
                                    bsValue, HSSFWorkbook.PICTURE_TYPE_JPEG));
                        } else if (value instanceof List) {
                            List<CmsActivityOrderDetail> details = (List)value;
                            String seatInfo = "";
                            for (CmsActivityOrderDetail orderDetail : details) {
                                String[] seatVal = orderDetail.getSeatVal().split("_");
                                if (seatVal != null && seatVal.length == 2) {
                                    seatInfo += seatVal[0] + "排" + seatVal[1] + "座,";
                                } else {
                                    seatInfo += "票" + seatVal[0] + ",";
                                }
                            }
                            textValue = seatInfo.substring(0,seatInfo.length() - 1);
                        } else {
                            // 其它数据类型都当作字符串简单处理
                            if (value == null) {
                                value = "";
                            }
                            textValue = value.toString();
                        }
                        // 如果不是图片数据，就利用正则表达式判断textValue是否全部由数字组成
                        if (textValue != null) {
                            Pattern p = Pattern.compile("^//d+(//.//d+)?$");
                            Matcher matcher = p.matcher(textValue);
                            if (matcher.matches()) {
                                // 是数字当作double处理
                                cell.setCellValue(Double.parseDouble(textValue));
                            } else {

                                if ("fromType".equals(fieldName)) {
                                    if ("1".equals(textValue)) {
                                        textValue = "网页";
                                    } else if ("2".equals(textValue)) {
                                        textValue = "手机";
                                    } else if ("3".equals(textValue)) {
                                        textValue = "东方有线";
                                    } else if ("4".equals(textValue)) {
                                        textValue = "线下终端";
                                    } else {
                                        textValue = "其它";
                                    }
                                }

                                HSSFRichTextString richString = new HSSFRichTextString(textValue);
                                HSSFFont font3 = workbook.createFont();
                                font3.setColor(HSSFColor.BLUE.index);
                                richString.applyFont(font3);
                                sheet.autoSizeColumn(columnTemp);
                                cell.setCellValue(richString);
                            }
                        }
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                    columnTemp ++;
                }
            }
        }
        try
        {
            workbook.write(out);
            out.flush();
            out.close();
            //return out.toByteArray();
            return Constant.RESULT_STR_SUCCESS;
        }
        catch (IOException e)
        {
            e.printStackTrace();
            return null;
        }
        finally
        {
            try
            {
                out.close();
            }
            catch (IOException e)
            {
                e.printStackTrace();
            }
        }
    }
	public String TrainTerminalExcel(String title, String sysDictTemplateCode, Collection<T> dataSet, ServletOutputStream out, String pattern) {
        List<SysDict> sysDictList =  sysDictService.querySysDictByCode(sysDictTemplateCode);
        String templateCode = "";
        String[] headers = null;
        if (sysDictList != null && sysDictList.size() > 0) {
            templateCode = sysDictList.get(0).getDictRemark();
        }
        Map map = new HashMap();
        if (StringUtils.isNotNull(templateCode)) {
            String[] templateInfo  =templateCode.split(",");
            headers = new String[templateInfo.length];
            int i = 0;
            for (String keyValue : templateInfo) {
                headers[i] = keyValue.split(":")[1];
                map.put(keyValue.split(":")[0],i);
                i++;
            }
        }
        // 声明一个工作薄
        HSSFWorkbook workbook = new HSSFWorkbook();
        // 生成一个表格
        HSSFSheet sheet = workbook.createSheet(title);
        // 设置表格默认列宽度为15个字节
        sheet.setDefaultColumnWidth((short) 15);
        // 生成一个样式
        HSSFCellStyle style = workbook.createCellStyle();
        // 设置这些样式
        style.setFillForegroundColor(HSSFColor.SKY_BLUE.index);
        style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style.setBorderRight(HSSFCellStyle.BORDER_THIN);
        style.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        // 生成一个字体
        HSSFFont font = workbook.createFont();
        font.setColor(HSSFColor.VIOLET.index);
        font.setFontHeightInPoints((short) 12);
        font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
        // 把字体应用到当前的样式
        style.setFont(font);
        // 生成并设置另一个样式
        HSSFCellStyle style2 = workbook.createCellStyle();
        style2.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
        style2.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style2.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style2.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style2.setBorderRight(HSSFCellStyle.BORDER_THIN);
        style2.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style2.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        style2.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
        // 生成另一个字体
        HSSFFont font2 = workbook.createFont();
        font2.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);
        // 把字体应用到当前的样式
        style2.setFont(font2);

        // 声明一个画图的顶级管理器
        HSSFPatriarch patriarch = sheet.createDrawingPatriarch();
        // 定义注释的大小和位置,详见文档
        HSSFComment comment = patriarch.createComment(new HSSFClientAnchor(0, 0, 0, 0, (short) 4, 2, (short) 6, 5));
        // 设置注释内容
        comment.setString(new HSSFRichTextString(""));
        // 设置注释作者，当鼠标移动到单元格上是可以在状态栏中看到该内容.
        comment.setAuthor("why");

        // 产生表格标题行
        HSSFRow row = sheet.createRow(0);
        for (short i = 0; i < headers.length; i++)
        {
            HSSFCell cell = row.createCell(i);
            cell.setCellStyle(style);
            HSSFRichTextString text = new HSSFRichTextString(headers[i]);
            cell.setCellValue(text);
        }

        // 遍历集合数据，产生数据行
        Iterator<T> it = dataSet.iterator();
        int index = 0;
        while (it.hasNext())
        {
            index++;
            row = sheet.createRow(index);
            T t = (T) it.next();
            // 利用反射，根据javabean属性的先后顺序，动态调用getXxx()方法得到属性值
            Field[] fields = t.getClass().getDeclaredFields();
            for (short i = 0; i < fields.length; i++)
            {
                Field field = fields[i];
                String fieldName = field.getName();
                //判断是否需要生成该字段
                if (map.containsKey(fieldName)) {
                    try {
                        HSSFCell cell = row.createCell(Integer.valueOf(map.get(fieldName).toString()));
                        cell.setCellStyle(style2);
                        String getMethodName = "get" + fieldName.substring(0, 1).toUpperCase() + fieldName.substring(1);
                        Class tCls = t.getClass();
                        Method getMethod = tCls.getMethod(getMethodName, new Class[]{});
                        Object value = getMethod.invoke(t, new Object[]{});
                        // 判断值的类型后进行强制类型转换
                        String textValue = null;
                        if (value instanceof Boolean) {
                            boolean bValue = (Boolean) value;
                            textValue = "Y";
                            if (!bValue) {
                                textValue = "N";
                            }
                        } else if (value instanceof Date) {
                            Date date = (Date) value;
                            SimpleDateFormat sdf = new SimpleDateFormat(pattern);
                            textValue = sdf.format(date);
                        } else if (value instanceof byte[]) {
                            // 有图片时，设置行高为60px;
                            row.setHeightInPoints(60);
                            // 设置图片所在列宽度为80px,注意这里单位的一个换算
                            sheet.setColumnWidth(i, (short) (35.7 * 80));
                            // sheet.autoSizeColumn(i);
                            byte[] bsValue = (byte[]) value;
                            HSSFClientAnchor anchor = new HSSFClientAnchor(0, 0,
                                    1023, 255, (short) 6, index, (short) 6, index);
                            anchor.setAnchorType(2);
                            patriarch.createPicture(anchor, workbook.addPicture(
                                    bsValue, HSSFWorkbook.PICTURE_TYPE_JPEG));
                        } else {
                            // 其它数据类型都当作字符串简单处理
                        	if(value!=null && !("").equals(value)){
                        		textValue = value.toString();
                        	}else{
                        		textValue = "";
                        	}
                        		
                        }
                        // 如果不是图片数据，就利用正则表达式判断textValue是否全部由数字组成
                        if (textValue != null) {
                            Pattern p = Pattern.compile("^//d+(//.//d+)?$");
                            Matcher matcher = p.matcher(textValue);
                            if (matcher.matches()) {
                                // 是数字当作double处理
                                cell.setCellValue(Double.parseDouble(textValue));
                            } else {
                                if ("userSex".equals(fieldName)) {
                                    if ("1".equals(textValue)) {
                                        textValue = "男";
                                    } else if ("2".equals(textValue)) {
                                        textValue = "女";
                                    }
                                }else if("attendState".equals(fieldName)){
                                	 if ("1".equals(textValue)) {
                                         textValue = "未参加";
                                     } else if ("2".equals(textValue)) {
                                         textValue = "已参加";
                                     }
                                }else if("orderStatus".equals(fieldName)){
                                	if ("1".equals(textValue)) {
                                		textValue = "待确认";
                                	} else if ("2".equals(textValue)) {
                                		textValue = "已确认";
                                	}else if ("3".equals(textValue)) {
                                		textValue = "取消";
                                	}
                                }else if("unitArea".equals(fieldName)){
                                	 if ("46".equals(textValue)) {
                                         textValue = "黄浦区";
                                     }else if ("48".equals(textValue)) {
                                         textValue = "徐汇区";
                                     }else if ("49".equals(textValue)) {
                                         textValue = "长宁区";
                                     }else if ("50".equals(textValue)) {
                                         textValue = "静安区";
                                     }else if ("51".equals(textValue)) {
                                         textValue = "普陀区";
                                     }else if ("53".equals(textValue)) {
                                         textValue = "虹口区";
                                     }else if ("54".equals(textValue)) {
                                         textValue = "杨浦区";
                                     }else if ("55".equals(textValue)) {
                                         textValue = "闵行区";
                                     } else if ("56".equals(textValue)) {
                                         textValue = "宝山区";
                                     }else if ("57".equals(textValue)) {
                                         textValue = "嘉定区";
                                     }else if ("58".equals(textValue)) {
                                         textValue = "浦东新区";
                                     }else if ("59".equals(textValue)) {
                                         textValue = "金山区";
                                     }else if ("60".equals(textValue)) {
                                         textValue = "松江区";
                                     }else if ("61".equals(textValue)) {
                                         textValue = "青浦区";
                                     }else if ("63".equals(textValue)) {
                                         textValue = "奉贤区";
                                     }else if ("64".equals(textValue)) {
                                         textValue = "崇明县";
                                     }
                                }  	
                                HSSFRichTextString richString = new HSSFRichTextString(
                                        textValue);
                                HSSFFont font3 = workbook.createFont();
                                font3.setColor(HSSFColor.BLUE.index);
                                richString.applyFont(font3);
                                cell.setCellValue(richString);
                            }
                        }
                    }
                    catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }
            }
        }
        try
        {
            workbook.write(out);
            out.flush();
            out.close();
            //return out.toByteArray();
            return Constant.RESULT_STR_SUCCESS;
        }
        catch (IOException e)
        {
            e.printStackTrace();
            return null;
        }
        finally
        {
            try
            {
                out.close();
            }
            catch (IOException e)
            {
                e.printStackTrace();
            }
        }
		
	}


}
