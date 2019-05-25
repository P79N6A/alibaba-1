package com.sun3d.why.util;

import org.apache.log4j.Logger;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 * 佛山图书馆读者证，调用接口返回xml数据处理
 */
public class ReaderCardUtil {

    private static Logger logger = Logger.getLogger(ReaderCardUtil.class);
    /**
     * @description 将xml字符串转换成map
     * @param xml
     * @return Map
     */
    public static Map checkReadCard(String xml) {
        logger.info(xml);
        Map map = new HashMap();
        Document doc = null;
        try {
            doc = DocumentHelper.parseText(xml); // 将字符串转为XML
            Element rootElt = doc.getRootElement(); // 获取根节点
            logger.info("根节点：" + rootElt.getName()); // 拿到根节点的名称
            String aReturn = rootElt.elementText("return"); // 获取根节点下的子节点head
            if(aReturn.equals("1")){
                map.put("status",0);
            }else{
                Map paramMap = new HashMap();
                paramMap.put("identifier",aReturn);
                String url = PropertiesReadUtils.getInstance().getPropValueByKey("readCardQueryReaderInfoURL");
                //xml = SendHttpUtil.sendGetHttp("GET", PropertiesReadUtils.getInstance().getPropValueByKey("readCardQueryReaderInfoURL"), paramMap);
                xml = CallUtils.callUrl3(url, paramMap);
                logger.info(xml);
                map = readCardUser(xml);
                return readCardUser(xml);
            }
        } catch (DocumentException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    /**
     * @description 将xml字符串转换成map
     * @param xml
     * @return Map
     */
    public static Map readCardUser(String xml) {
        Map map = new HashMap();
        Document doc = null;
        try {
            doc = DocumentHelper.parseText(xml); // 将字符串转为XML
            Element rootElt = doc.getRootElement(); // 获取根节点
            logger.info("根节点：" + rootElt.getName()); // 拿到根节点的名称
            Iterator iters = rootElt.elementIterator("return"); ///获取根节点下的子节点body
            // 遍历body节点
            while (iters.hasNext()) {
                Element recordEless = (Element) iters.next();
                map.put("useAddress",recordEless.elementTextTrim("address"));
                map.put("userCardNo",recordEless.elementTextTrim("certify"));
                map.put("userName",recordEless.elementTextTrim("patronName"));
                map.put("userPwd",recordEless.elementTextTrim("patronPassword"));
                map.put("userPwdMD5",MD5Util.toMd5(recordEless.elementTextTrim("patronPassword")));
                map.put("userMobileNo",recordEless.elementTextTrim("phone"));
                map.put("readerCard",recordEless.elementTextTrim("patronIdentifier"));
                map.put("userBirth",recordEless.elementTextTrim("bornDate"));
                map.put("status",1);
            }
        } catch (DocumentException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }
}
