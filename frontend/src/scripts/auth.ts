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
export const AUTH_EVENT = 'auth:changed';

export function getToken(): string | null {
  try {
    return localStorage.getItem(TOKEN_KEY);
  } catch {
    return null;
  }
}

export function readUser(): AuthUser | null {
  try {
    const raw = localStorage.getItem(AUTH_KEY);
    if (!raw) return null;
    const user = JSON.parse(raw) as AuthUser;
    return user && typeof user.name === 'string' && user.name ? user : null;
  } catch {
    return null;
  }
}

export function isAdmin(): boolean {
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
    if (redirectUrl) {
      window.location.href = redirectUrl;
    }
  } catch (e) {
    console.error('Lỗi khi đăng xuất:', e);
  }
}