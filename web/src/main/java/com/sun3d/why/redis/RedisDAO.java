package com.sun3d.why.redis;

import java.io.Serializable;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * 接口：定义基于RedisCache的增、删、改、查等操作接口。
 * 
 * @author Arthur
 * @version 0.1
 * @since 2014-09-15
 * 
 */
public interface RedisDAO<T extends Serializable> {
	

	/**
	 * 保存redis（不带失效时间）
	 * 
	 * @param key
	 * @param data
	 */
	public void save(String key, T data);
	
	void save( byte[] key, byte[] data);
	
	/**
	 * 根据key获取缓存数据（不带失效时间）
	 * 
	 * @param keystr
	 * @return
	 */
	public T getData(String keystr);
	
	/**
	 * 根据key获取缓存数据（不带失效时间）
	 * 
	 * @param keystr
	 * @return
	 */
	public byte[] getData(byte[] keystr);
	
	/**
	 * 保存redis（带失效时间）
	 * @param key
	 * @param v
	 * @param timeout 单位：秒
	 */
	public void save(String key, T v, long timeout);

	/**
	 * 批量保存数据至redis缓存（不带失效时间）
	 * 
	 * @param keys
	 * @param values
	 */
	public void save(Map<String, T> kvmap);

	/**
	 * 批量保存数据至redis缓存(带失效时间)
	 * 
	 * @param kvmap
	 *            需要保存的数据
	 * @param timeout
	 *            失效时间 单位（秒）
	 */
	public void save(Map<String, T> kvmap, long timeout);

	/**
	 * 根据key集合获取缓存数据列表
	 * 
	 * @param keystr
	 * @return
	 */
	public List<T> getData(Set<String> keys);
	
	/**根据key删除缓存数据
	 * @param key
	 */
	public void delete(byte[] key);
	
	/**
	 * 根据key集合删除缓存数据
	 * @param keys
	 */
	public void delete(List<String> keys);
	
	public void delete(String key);
	
	/**
	 * 保存set数据格式 redis
	 * @param key
	 * @param data
	 * @return
	 */
	public long saveSet(String key,T data);
	
	public boolean isMember(String key,T data);
	
	public Set<T> getDataSet(String key);
	
	/**
	 * 递增或递减：incr()/decr()
	 * @param key
	 * @return
	 */
	public long incr(String key);

	public boolean expire(String key,int expireSeconds );

	public boolean expire(byte[] keystr,int expireSeconds);
	
	/**
	 * 实现命令：TTL key，以秒为单位，返回给定 key的剩余生存时间(TTL, time to live)
	 * 
	 * @param key
	 * @return
	 */
	public long ttl(String key);
}
