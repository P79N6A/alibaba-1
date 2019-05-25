package com.sun3d.why.util;

import java.util.UUID;

/**
 * 获取uuid
 *
 * @author zuowm
 * @date 2015年4月16日 下午8:01:51
 */
public final class UUIDUtils {

    /**
     * 生成UUID
     *
     * @return String
     */
    public static String createUUId() {
        return UUID.randomUUID().toString().replace("-", "");
    }
}
