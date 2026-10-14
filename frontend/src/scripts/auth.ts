// src/scripts/auth.ts
// Lưu thông tin người dùng đã đăng nhập ở trình duyệt (giống cách giỏ hàng đang làm).
// Header đọc từ đây để hiện tên khách.

export interface AuthUser {
  name: string;
  role?: 'customer' | 'admin';
}

export const AUTH_KEY = 'auth_user';
export const AUTH_EVENT = 'auth:changed';

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

// Gọi sau khi đăng nhập thành công
export function saveUser(user: AuthUser): void {
  localStorage.setItem(AUTH_KEY, JSON.stringify(user));
  window.dispatchEvent(new Event(AUTH_EVENT));
}

// Gọi khi đăng xuất
export function clearUser(): void {
  localStorage.removeItem(AUTH_KEY);
  window.dispatchEvent(new Event(AUTH_EVENT));
}