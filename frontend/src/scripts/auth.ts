// src/scripts/auth.ts
// Quản lý trạng thái xác thực và bảo mật tài khoản phía Client

export interface AuthUser {
  id?: number;
  name: string;
  email?: string;
  phone?: string;
  avatar?: string;
  role?: 'customer' | 'admin' | 'seller';
  tier?: string;
  tierBadge?: string;
  tierColor?: string;
  totalSpent?: number;
}

export const AUTH_KEY = 'current_user';
export const TOKEN_KEY = 'auth_token';
export const ADMIN_AUTH_KEY = 'admin_user';
export const ADMIN_TOKEN_KEY = 'admin_token';
export const AUTH_EVENT = 'auth:changed';

/**
 * Tự động xóa sạch các dữ liệu thử nghiệm cũ (mock) có chứa mật khẩu bản rõ hoặc dữ liệu rác
 * còn sót lại trong LocalStorage của trình duyệt từ các phiên bản trước.
 */
export function cleanupLegacySensitiveStorage(): void {
  if (typeof window === 'undefined') return;
  try {
    const legacySensitiveKeys = [
      'registered_customers',
      'registered_users',
      'user_passwords',
      'mock_customers',
    ];
    legacySensitiveKeys.forEach((key) => {
      if (localStorage.getItem(key)) {
        localStorage.removeItem(key);
      }
    });
  } catch {}
}

if (typeof window !== 'undefined') {
  cleanupLegacySensitiveStorage();
}

export function isTokenExpired(token: string): boolean {
  try {
    const parts = token.split('.');
    if (parts.length !== 3) return true;
    const payload = JSON.parse(atob(parts[1]));
    if (!payload.exp) return false;
    return payload.exp * 1000 <= Date.now();
  } catch {
    return true;
  }
}

export function getToken(): string | null {
  try {
    const token = localStorage.getItem(TOKEN_KEY);
    if (!token) return null;
    if (isTokenExpired(token)) {
      clearUser();
      return null;
    }
    return token;
  } catch {
    return null;
  }
}

export function getAdminToken(): string | null {
  try {
    const adminToken = localStorage.getItem(ADMIN_TOKEN_KEY);
    if (adminToken && !isTokenExpired(adminToken)) {
      return adminToken;
    }
    const token = getToken();
    return token;
  } catch {
    return null;
  }
}
export function sanitizeUserName(name?: string | null, role?: string): string {
  if (!name || !name.trim()) return role === 'admin' ? 'Quản Trị Viên' : 'Khách';
  let cleaned = name.trim();

  // Chỉ chuẩn hóa nếu tên bị lỗi hoặc là từ khóa admin mặc định của hệ thống
  if (
    cleaned.toLowerCase() === 'admin' ||
    cleaned.toLowerCase().includes('admin@noithat.vn')
  ) {
    return 'Quản Trị Viên';
  }

  // Khắc phục các ký tự lỗi mã hóa UTF-8 (mojibake) phổ biến từ database cũ
  cleaned = cleaned
    .replace(/Nguyá»…n/g, 'Nguyễn')
    .replace(/Pháº¡m/g, 'Phạm')
    .replace(/Há»¯u/g, 'Hữu')
    .replace(/Lá»£i/g, 'Lợi')
    .replace(/Vá»¹/g, 'Vỹ')
    .replace(/VÄƒn/g, 'Văn')
    .replace(/\s*Cáº¥p Cao/gi, '')
    .trim();

  return cleaned || 'Khách';
}

export function readUser(): AuthUser | null {
  try {
    const token = getToken();
    if (!token) {
      // Nếu không có token hợp lệ (hoặc token đã hết hạn), dọn dẹp cache rác nếu có
      if (typeof window !== 'undefined' && localStorage.getItem(AUTH_KEY)) {
        localStorage.removeItem(AUTH_KEY);
      }
      return null;
    }

    const raw = localStorage.getItem(AUTH_KEY);
    if (!raw) return null;
    const user = JSON.parse(raw) as AuthUser;
    if (user && typeof user.name === 'string' && user.name) {
      const cleanName = sanitizeUserName(user.name, user.role);
      if (cleanName !== user.name) {
        user.name = cleanName;
        try {
          localStorage.setItem(AUTH_KEY, JSON.stringify(user));
        } catch { }
      }
      return user;
    }
    return null;
  } catch {
    return null;
  }
}

export function isAdmin(): boolean {
  try {
    const adminUserRaw = localStorage.getItem('admin_user');
    const adminToken = localStorage.getItem('admin_token');
    if (adminToken && adminUserRaw) {
      const au = JSON.parse(adminUserRaw);
      if (au.role === 'admin' || au.role === 'seller') return true;
    }
  } catch { }

  const user = readUser();
  const token = getToken();
  return Boolean(token && user && (user.role === 'admin' || user.role === 'seller'));
}

// Gọi sau khi đăng nhập thành công
export function saveAuth(user: AuthUser, token?: string): void {
  try {
    localStorage.setItem(AUTH_KEY, JSON.stringify(user));
    if (token) {
      localStorage.setItem(TOKEN_KEY, token);
    }
    window.dispatchEvent(new Event(AUTH_EVENT));
    window.dispatchEvent(new CustomEvent('cart:updated', { detail: [] }));
  } catch (e) {
    console.error('Lỗi khi lưu thông tin xác thực:', e);
  }
}

export function saveUser(user: AuthUser): void {
  saveAuth(user);
}

// Gọi khi đăng xuất
export function clearUser(redirectUrl?: string): void {
  try {
    localStorage.removeItem(AUTH_KEY);
    localStorage.removeItem(TOKEN_KEY);
    localStorage.removeItem(ADMIN_AUTH_KEY);
    localStorage.removeItem(ADMIN_TOKEN_KEY);
    window.dispatchEvent(new Event(AUTH_EVENT));
    window.dispatchEvent(new CustomEvent('cart:updated', { detail: [] }));
    if (redirectUrl) {
      window.location.href = redirectUrl;
    }
  } catch (e) {
    console.error('Lỗi khi đăng xuất:', e);
  }
}

// Làm mới thông tin phiên làm việc và bậc hạng hội viên từ server
export async function refreshUserProfile(): Promise<AuthUser | null> {
  const token = getToken();
  if (!token) return null;
  try {
    const res = await fetch('http://localhost:4000/api/auth/me', {
      headers: { Authorization: `Bearer ${token}` },
    });
    const json = await res.json();
    if (json.success && json.user) {
      const u = json.user;
      const currentUser = readUser() || { name: u.full_name || 'Khách' };
      const updatedUser: AuthUser = {
        ...currentUser,
        id: u.id,
        name: sanitizeUserName(u.full_name, u.role),
        email: u.email,
        phone: u.phone,
        avatar: u.avatar,
        role: u.role,
        tier: u.tier,
        tierBadge: u.tierBadge,
        tierColor: u.tierColor,
        totalSpent: u.totalSpent,
      };
      localStorage.setItem(AUTH_KEY, JSON.stringify(updatedUser));
      window.dispatchEvent(new Event(AUTH_EVENT));
      return updatedUser;
    }
  } catch (err) {
    console.warn('Không thể đồng bộ hồ sơ /me:', err);
  }
  return readUser();
}
