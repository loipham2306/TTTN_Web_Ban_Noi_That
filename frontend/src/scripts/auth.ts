// src/scripts/auth.ts
// Quản lý trạng thái xác thực và bảo mật tài khoản phía Client

export interface AuthUser {
  id?: number;
  name: string;
  email?: string;
  phone?: string;
  avatar?: string;
  role?: 'customer' | 'admin' | 'seller';
}

export const AUTH_KEY = 'current_user';
export const TOKEN_KEY = 'auth_token';
export const ADMIN_AUTH_KEY = 'admin_user';
export const ADMIN_TOKEN_KEY = 'admin_token';
export const AUTH_EVENT = 'auth:changed';

export function getToken(): string | null {
  try {
    return localStorage.getItem(TOKEN_KEY);
  } catch {
    return null;
  }
}

export function getAdminToken(): string | null {
  try {
    return localStorage.getItem(ADMIN_TOKEN_KEY) || localStorage.getItem(TOKEN_KEY);
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
    const raw = localStorage.getItem(AUTH_KEY);
    if (!raw) return null;
    const user = JSON.parse(raw) as AuthUser;
    if (user && typeof user.name === 'string' && user.name) {
      const cleanName = sanitizeUserName(user.name, user.role);
      if (cleanName !== user.name) {
        user.name = cleanName;
        try {
          localStorage.setItem(AUTH_KEY, JSON.stringify(user));
        } catch {}
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
  } catch {}

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
    window.dispatchEvent(new Event(AUTH_EVENT));
    window.dispatchEvent(new CustomEvent('cart:updated', { detail: [] }));
    if (redirectUrl) {
      window.location.href = redirectUrl;
    }
  } catch (e) {
    console.error('Lỗi khi đăng xuất:', e);
  }
}