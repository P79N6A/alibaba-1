package com.sun3d.why.util;

import java.math.BigDecimal;
import java.util.Comparator;
import java.util.Map;

import static java.lang.String.valueOf;

/**
 * Created by Administrator on 2015/7/22.
 */
public class ComparatorList implements Comparator{


    private String compareStr;

    public ComparatorList(){

    }
    public ComparatorList(String compareStr){
        this.compareStr=compareStr;
    }

    @Override
    public int compare(Object o1, Object o2) {
        int flag2=0;
        Map map1=(Map)o1;
        Map map2=(Map)o2;
        BigDecimal bd=new BigDecimal(String.valueOf(map1.get(compareStr)));
        BigDecimal bh=new BigDecimal(String.valueOf(map2.get(compareStr)));
        if(bd.doubleValue()>bh.doubleValue()){
            return 1;
        }
           return -1;
    }
}
