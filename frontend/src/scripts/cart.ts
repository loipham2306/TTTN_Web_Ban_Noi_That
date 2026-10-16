export interface CartItem {
  slug: string;
  name: string;
  price: number;
  qty: number;
  thumbnail?: string;
  category?: string;
}

export const CART_EVENT = 'cart:updated';

// Xác định key giỏ hàng động theo tài khoản đang đăng nhập
export const getCartKey = (): string => {
  if (typeof window === 'undefined') return 'noithat_cart_guest';
  try {
    const raw = window.localStorage.getItem('current_user');
    if (raw) {
      const user = JSON.parse(raw);
      if (user && user.email) {
        return `noithat_cart_${user.email.trim().toLowerCase()}`;
      }
    }
  } catch {}
  return 'noithat_cart_guest';
};

export const formatVnd = (value: number): string => {
  return Number(value || 0).toLocaleString('vi-VN') + ' đ';
};

export const readCart = (): CartItem[] => {
  if (typeof window === 'undefined') return [];
  try {
    const key = getCartKey();

    // Dọn dẹp key cũ dùng chung trên máy nếu còn sót lại
    if (window.localStorage.getItem('noithat_cart') || window.localStorage.getItem('cart')) {
      window.localStorage.removeItem('noithat_cart');
      window.localStorage.removeItem('cart');
    }

    const raw = window.localStorage.getItem(key);
    if (!raw) return [];
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) return [];
    return parsed
      .filter((item) => item && typeof item.slug === 'string')
      .map((item) => ({
        slug: String(item.slug),
        name: String(item.name ?? ''),
        price: Number(item.price) || 0,
        qty: Math.min(99, Math.max(1, Number(item.qty ?? item.quantity) || 1)),
        thumbnail: item.thumbnail ? String(item.thumbnail) : undefined,
        category: item.category ? String(item.category) : undefined,
      }));
  } catch {
    return [];
  }
};

export const writeCart = (items: CartItem[]): void => {
  if (typeof window === 'undefined') return;
  const key = getCartKey();
  window.localStorage.setItem(key, JSON.stringify(items));
  window.dispatchEvent(new CustomEvent(CART_EVENT, { detail: items }));
};

// Tự động gộp giỏ hàng của khách vãng lai vào tài khoản khi vừa đăng nhập
export const mergeGuestCartOnLogin = (): void => {
  if (typeof window === 'undefined') return;
  const userKey = getCartKey();
  if (userKey === 'noithat_cart_guest') return;

  try {
    const guestRaw = window.localStorage.getItem('noithat_cart_guest');
    if (!guestRaw) return;
    const guestItems: CartItem[] = JSON.parse(guestRaw);
    if (!Array.isArray(guestItems) || guestItems.length === 0) return;

    const userItems = readCart();
    for (const g of guestItems) {
      const existing = userItems.find((u) => u.slug === g.slug);
      if (existing) {
        existing.qty = Math.min(99, existing.qty + g.qty);
      } else {
        userItems.push(g);
      }
    }
    window.localStorage.setItem(userKey, JSON.stringify(userItems));
    window.localStorage.removeItem('noithat_cart_guest');
    window.dispatchEvent(new CustomEvent(CART_EVENT, { detail: userItems }));
  } catch (e) {
    console.warn('Lỗi gộp giỏ hàng khách:', e);
  }
};

export const addToCart = (
  item: { slug: string; name: string; price: number; thumbnail?: string; category?: string },
  qty = 1
): CartItem[] => {
  const items = readCart();
  const existing = items.find((entry) => entry.slug === item.slug);

  if (existing) {
    existing.qty = Math.min(99, existing.qty + qty);
    if (item.thumbnail && !existing.thumbnail) existing.thumbnail = item.thumbnail;
    if (item.price && !existing.price) existing.price = item.price;
  } else {
    items.push({
      slug: item.slug,
      name: item.name,
      price: item.price,
      qty: Math.min(99, Math.max(1, qty)),
      thumbnail: item.thumbnail,
      category: item.category,
    });
  }

  writeCart(items);
  return items;
};

export const updateQty = (slug: string, qty: number): CartItem[] => {
  const items = readCart();
  const existing = items.find((entry) => entry.slug === slug);
  if (existing) {
    existing.qty = Math.min(99, Math.max(1, qty));
    writeCart(items);
  }
  return items;
};

export const removeItem = (slug: string): CartItem[] => {
  const items = readCart().filter((entry) => entry.slug !== slug);
  writeCart(items);
  return items;
};

export const clearCart = (): void => writeCart([]);

export const countItems = (items: CartItem[]): number =>
  items.reduce((sum, entry) => sum + entry.qty, 0);

export const totalPrice = (items: CartItem[]): number =>
  items.reduce((sum, entry) => sum + entry.price * entry.qty, 0);

export const showCartToast = (message: string): void => {
  if (typeof document === 'undefined') return;
  const existing = document.getElementById('cart-toast-notification');
  if (existing) existing.remove();

  const toast = document.createElement('div');
  toast.id = 'cart-toast-notification';
  toast.className = 'fixed bottom-6 right-6 z-[9999] flex items-center gap-3 rounded-md bg-walnut-900 px-5 py-3.5 text-sm font-medium text-sand-50 shadow-2xl transition-all duration-300 translate-y-3 opacity-0';
  toast.innerHTML = `
    <svg class="h-5 w-5 text-emerald-400 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
    </svg>
    <span>${message}</span>
  `;
  document.body.appendChild(toast);
  requestAnimationFrame(() => {
    toast.style.opacity = '1';
    toast.style.transform = 'translateY(0)';
  });
  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transform = 'translateY(10px)';
    setTimeout(() => toast.remove(), 300);
  }, 2800);
};