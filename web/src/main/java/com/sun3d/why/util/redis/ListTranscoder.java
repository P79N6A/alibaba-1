package com.sun3d.why.util.redis;

import java.io.*;

/**
 * Created by liyang on 2015/4/16.
 */
public class ListTranscoder {

    public static byte[] serialize(Object value) {
        if (value == null) {
            throw new NullPointerException("Can't serialize null");
        }
        byte[] rv = null;
        ByteArrayOutputStream bos = null;
        ObjectOutputStream os = null;
        try {
            bos = new ByteArrayOutputStream();
            os = new ObjectOutputStream(bos);
            os.writeObject(value);
          
            rv = bos.toByteArray();
        } catch (IOException e) {
            throw new IllegalArgumentException("Non-serializable object", e);
        } finally {
            try {
                if(os!=null)
                	os.close();
                if(bos!=null)
                	bos.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return rv;
    }

    public static Object deserialize(byte[] in) {
        Object rv = null;
        ByteArrayInputStream bis = null;
        ObjectInputStream is = null;
        try {
            if (in != null) {
                bis = new ByteArrayInputStream(in);
                is = new ObjectInputStream(bis);
                rv = is.readObject();
            }
        } catch (IOException e) {
        	
        	 e.printStackTrace();

        } catch (ClassNotFoundException e) {
        } finally {
            try {
            	if(is!=null)
            	  is.close();
              if(bis!=null)
                bis.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return rv;
    }
}
