package com.sun3d.why.util;

import com.sun3d.why.model.CmsVenueSeat;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by cj on 2015/7/23.
 */
public class DomUtil {

    private static Logger logger = Logger.getLogger(DomUtil.class);

    public static void main(String[] args) {
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        List<CmsVenueSeat> cmsVenueSeatList = new ArrayList<CmsVenueSeat>();

        try {
            CmsVenueSeat cmsVenueSeat = new CmsVenueSeat();
            cmsVenueSeat.setSeatId("0008179b0e0941a9a9f6b37fe6634291");
            cmsVenueSeat.setSeatArea("ALL");
            cmsVenueSeat.setSeatRow(1);
            cmsVenueSeat.setSeatColumn(1);
            cmsVenueSeat.setSeatCode("1_1");
            cmsVenueSeat.setSeatStatus(1);
            cmsVenueSeat.setSeatCreateTime(new Date());
            cmsVenueSeat.setSeatCreateUser("陈杰");
            cmsVenueSeat.setSeatUpdateTime(new Date());
            cmsVenueSeat.setSeatUpdateUser("陈杰");
            cmsVenueSeat.setTemplateId("40d819f9e08442f089de86d19224a07e");
            cmsVenueSeatList.add(cmsVenueSeat);

            for(int i=0; i<10000; i++){
                cmsVenueSeat = new CmsVenueSeat();
                cmsVenueSeat.setSeatId("0008179b0e0941a9a9f6b37fe6634292");
                cmsVenueSeat.setSeatArea("ALL");
                cmsVenueSeat.setSeatRow(1);
                cmsVenueSeat.setSeatColumn(1);
                cmsVenueSeat.setSeatCode("1_1");
                cmsVenueSeat.setSeatStatus(1);
                cmsVenueSeat.setSeatCreateTime(new Date());
                cmsVenueSeat.setSeatCreateUser("陈杰");
                cmsVenueSeat.setSeatUpdateTime(new Date());
                cmsVenueSeat.setSeatUpdateUser("陈杰");
                cmsVenueSeat.setTemplateId("40d819f9e08442f089de86d19224a07e");
                cmsVenueSeatList.add(cmsVenueSeat);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        //writeFile(cmsVenueSeatList);
        readVenueSeatFromXml("a40ce603d75540e09c8e27d8c61e60ef");
    }

    /**
     * 将某个模板的所有座位信息写入XML文件中
     * 必须为同一个模板的座位信息
     * @param cmsVenueSeatList
     */
    public static void writeFile( List<CmsVenueSeat> cmsVenueSeatList){
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        logger.info("写XML开始时间：" + dateFormat.format(new Date()));
        try {
            // 第一种方式：创建文档，并创建根元素
            // 创建文档:使用了一个Helper类
            Document document = DocumentHelper.createDocument();
            // 创建根节点并添加进文档
            Element root = DocumentHelper.createElement("cmsVenueSeats");
            document.setRootElement(root);

            Class cls = CmsVenueSeat.class;
            Field[] fields = cls.getDeclaredFields();
            Method[] methods = cls.getDeclaredMethods();

            CmsVenueSeat cmsVenueSeat = null;

            for(int i=0; i<cmsVenueSeatList.size(); i++){
                Element second = second = root.addElement("cmsVenueSeat");
                Element element = null;
                cmsVenueSeat = cmsVenueSeatList.get(i);

                for (int j=0; j<fields.length; j++){
                    Field field = fields[j];
                    String elementName = field.getName();
                    element = second.addElement(elementName);
                    StringBuilder strBuilder = new StringBuilder(elementName);
                    strBuilder.setCharAt(0, Character.toUpperCase(strBuilder.charAt(0)));
                    elementName = strBuilder.toString();
                    Method method = cls.getDeclaredMethod("get" + elementName);
                    Object obj = method.invoke(cmsVenueSeat);
                    element.setText(obj.toString());
                }
            }
            // 输出到文件
            // 格式
            OutputStream os = new FileOutputStream("D:/xml-seat/"+cmsVenueSeat.getTemplateId()+".xml");
            OutputFormat format = new OutputFormat("    ", true);// 设置缩进为4个空格，并且另起一行为true
            XMLWriter xmlWriter = new XMLWriter(os, format);
            xmlWriter.write(document);
            // close()方法也可以
        } catch (Exception e) {
            logger.error("写XML文件出错了!",e);
        } finally {
            logger.info("写XML结束时间："+dateFormat.format(new Date()));
        }
    }

    /**
     * 从XML文件中读取特定模板的座位列表
     * @param templateId
     * @return
     */
    public static List<CmsVenueSeat> readVenueSeatFromXml(String templateId){
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        SimpleDateFormat sdf = new SimpleDateFormat("EEE MMM dd HH:mm:ss zzz yyyy", Locale.US);
        logger.info("读XML开始时间：" + dateFormat.format(new Date()));
        List<CmsVenueSeat> cmsVenueSeatList = new ArrayList<CmsVenueSeat>();
        String filePath = "D:/xml-seat/" + templateId + ".xml";
        try {
            Class cls = CmsVenueSeat.class;
            Field[] fields = cls.getDeclaredFields();
            Method[] methods = cls.getDeclaredMethods();
            Method method = null;

            File file = new File(filePath);
            SAXReader saxReader = new SAXReader();
            Document document = saxReader.read(file);

            Element root = document.getRootElement();

            Element second = null;
            Element element = null;
            CmsVenueSeat cmsVenueSeat = new CmsVenueSeat();

            Iterator<Element> secondIterator = root.elementIterator();
            while (secondIterator.hasNext()){
                second = secondIterator.next();
                Iterator<Element> elementIterator = second.elementIterator();
                while (elementIterator.hasNext()){
                    element = elementIterator.next();

                    String elementName = element.getName();
                    String elementText = element.getText();
                    StringBuilder strBuilder = new StringBuilder(elementName);
                    strBuilder.setCharAt(0, Character.toUpperCase(strBuilder.charAt(0)));
                    elementName = strBuilder.toString();

                    if(elementName.equals("SeatRow") || elementName.equals("SeatColumn") || elementName.equals("SeatStatus")){
                        method = cls.getDeclaredMethod("set" + elementName,Integer.class);
                        if(StringUtils.isNotBlank(elementText)){
                            method.invoke(cmsVenueSeat, Integer.parseInt(elementText));
                        }
                    }else if(elementName.equals("SeatCreateTime") || elementName.equals("SeatUpdateTime")){
                        method = cls.getDeclaredMethod("set" + elementName,Date.class);
                        if(StringUtils.isNotBlank(elementText)){
                            method.invoke(cmsVenueSeat,sdf.parse(elementText));
                        }
                    }else{
                        method = cls.getDeclaredMethod("set" + elementName,String.class);
                        method.invoke(cmsVenueSeat,elementText);
                    }
                }
                cmsVenueSeatList.add(cmsVenueSeat);
            }
            logger.info("模板座位数:" + cmsVenueSeatList.size());
        } catch (Exception e) {
            logger.error("读XML文件出错了!",e);
        }finally {
            logger.info("读XML结束时间："+dateFormat.format(new Date()));
        }
        return cmsVenueSeatList;
    }


}
