interface CacheEntry<T> {
  value: T;
  expiresAt: number;
}

const store = new Map<string, CacheEntry<unknown>>();

/**
 * Lấy dữ liệu từ In-Memory Cache nếu còn hạn (TTL).
 */
export function getCache<T>(key: string): T | null {
  const entry = store.get(key);
  if (!entry) return null;

  if (Date.now() > entry.expiresAt) {
    store.delete(key);
    return null;
  }

  return entry.value as T;
}

/**
 * Lưu dữ liệu vào In-Memory Cache với thời gian sống mặc định 60 giây.
 */
export function setCache<T>(key: string, value: T, ttlSeconds = 60): void {
  store.set(key, {
    value,
    expiresAt: Date.now() + ttlSeconds * 1000,
  });
}

/**
 * Xóa toàn bộ các cache key có tiền tố tương ứng (gọi khi Admin cập nhật dữ liệu).
 */
export function invalidateCachePrefix(prefix: string): void {
  for (const key of store.keys()) {
    if (key.startsWith(prefix)) {
      store.delete(key);
    }
  }
}

/**
 * Xóa toàn bộ cache.
 */
export function clearAllCache(): void {
  store.clear();
}

