package com.sun3d.why.util;

import com.sun3d.why.model.SysDict;
import com.sun3d.why.service.CacheConstant;

import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by liyang on 2015/5/28.
 */
public class RandomUtils {


    private String[] securityCodes = new String[]{
            "a", "b", "c", "d", "e", "f", "g", "h", "j", "k", "m", "n", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
            , "A", "B", "C", "D", "E", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
            , "1", "2", "3", "4", "5", "6", "7", "8", "9"
    };

    private String randomCode(int length) {
        StringBuilder builder = new StringBuilder();
        int size = securityCodes.length;
        for (int i = 0; i < length; i++) {
            double rdm = Math.random();
            int index = (int) (rdm * size);
            builder.append(securityCodes[index]);
        }
        return builder.toString();
    }


    /**
     * 这个方法生成redis中存储订单编号信息的key
     *
     * @return
     */
    public static String genOrderNumberRedisKey() {
        return CacheConstant.ORDER_NUMBER_KEY_PREFIX + genOrderNumberPrefix();
    }


    /**
     * 这个方法生成redis中存储用户编号信息的key
     *
     * @return
     */
    public static String genUserNumberRedisKey() {
        return CacheConstant.USER_NUMBER_KEY_PREFIX + genUserNumberPrefix();
    }

    /**
     * 这个方法生成订单的前缀，前缀为当前日期按yyMMdd格式化之后的字符串
     *
     * @return 订单前缀
     */
    public static String genOrderNumberPrefix() {
        Date current = new Date();
        SimpleDateFormat orderPrefixFormat = new SimpleDateFormat(DateUtils.DATE_PATTERN_yyMMdd);
        return orderPrefixFormat.format(current);
    }


    /**
     * 这个方法生成用户编号的前缀，前缀为当前日期按yyMMdd格式化之后的字符串
     *
     * @return 订单前缀
     */
    public static String genUserNumberPrefix() {
        Date current = new Date();
        SimpleDateFormat orderPrefixFormat = new SimpleDateFormat(DateUtils.DATE_PATTERN_yyMMdd);
        return orderPrefixFormat.format(current);
    }
    /**
     * 这个方法把一个long类型的数值格式化，格式化要求包括不使用组，
     * 位数为给定的参数，多余的位数强制截断，不足的位数补零
     *
     * @param number 需要格式化的数值
     * @param length 格式化后的位数
     */
    public static String digitsFormat(long number, int length) {
        NumberFormat numberFormat = NumberFormat.getIntegerInstance();
        numberFormat.setGroupingUsed(false);
        numberFormat.setMaximumIntegerDigits(length);
        numberFormat.setMinimumIntegerDigits(length);
        return numberFormat.format(number);
    }


    /**
     * 后端注册会员时随机生成9位(数字+字母)的用户密码
     * @return
     */
    public static String getPassWord(){
        String code = "";
        Random random = new Random();

        //参数length，表示生成几位随机数
        while (code.length() < 6) {

            String charOrNum = random.nextInt(2) % 2 == 0 ? "char" : "num";
            //输出字母还是数字
            if( "char".equalsIgnoreCase(charOrNum) ) {
                //输出是大写字母还是小写字母
                int temp = random.nextInt(2) % 2 == 0 ? 65 : 97;
                char car = (char)(random.nextInt(26) + temp);
                if(car == 'i' || car == 'I' || car == 'o' || car == 'O'){
                    continue;
                }
                code += car;
            } else if( "num".equalsIgnoreCase(charOrNum) ) {
                code += String.valueOf(random.nextInt(10));
            }
        }
        return code;
    }

    /**
     * 取0-max的随机不重复的count个数
     * @param max 最大值
     * @param count 个数
     * @return
     */
    public static Object[] getRandomNumber(int max, int count){
        Set<Integer> hs = new TreeSet<Integer>();
        Random random = new Random();
        while (true) {
            int a = random.nextInt(max);
            if(a >= 0 && a < max) {
                hs.add(a);
            }
            if (hs.size() >= count) {
                break;
            }
        }
        return hs.toArray();
    }
}
