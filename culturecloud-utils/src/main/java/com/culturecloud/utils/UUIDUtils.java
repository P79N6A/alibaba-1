package com.culturecloud.utils;


import java.util.UUID;

public class UUIDUtils {

        /**
         * 生成UUID
         *
         * @return String
         */
        public static String createUUId() {
            return UUID.randomUUID().toString().replace("-", "");
        }

}
