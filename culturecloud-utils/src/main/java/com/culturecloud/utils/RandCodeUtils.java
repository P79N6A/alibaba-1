package com.culturecloud.utils;

import java.util.Random;

/**
 * ��������
 * @author gaoyr
 */
public class RandCodeUtils {
	/**
	 * ����
	 */
	static char[] seeds=new char[]{'2','3','4','5','6','7','8','a','b','c','d','e','f','h','i','j','k','m','n','p','q','r','s','t','u','v','w','x','y','z'};
	
	/**
	 * �������ַ�
	 * @author tanyf
	 * @param len
	 * 			�ַ���
	 * @return
	 * 			����ַ�
	 */
	public static String randCode(int len){
		StringBuffer sb = new StringBuffer();
		Random rand = new Random(System.currentTimeMillis());
		for(int i=0;i<len;i++){
			sb.append(seeds[rand.nextInt(seeds.length)]);
		}
		return sb.toString();
	}
	
	/**
	 * ����4λ�����
	 * @return
	 */
	public static String getNumber4FromRandom(){
	   // return getRandomNum(4); //��˶�����������⣬��ʱ�����
	    return nextRintBetweenMin_Max(1000, 9999)+"";
		//return "0000";
	}
	
	/**
	 * ����һ�� MIN �� MAX ��Χ�ڵ�����ֵ
	 * ��ʽ��int randNumber = rand.nextInt(MAX - MIN + 1) + MIN;
	 * @param min
	 * @param max
	 * @return
	 */
	private static int nextRintBetweenMin_Max(final int MIN,final int MAX){
		 Random rand = new Random();  
		 return  rand.nextInt(MAX - MIN + 1) + MIN;
	}

}
