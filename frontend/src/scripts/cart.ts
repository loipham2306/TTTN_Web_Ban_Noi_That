export interface CartItem {
  slug: string;
  name: string;
  price: number;
  qty: number;
  thumbnail?: string;
  category?: string;
  maxStock?: number;
}

export const CART_EVENT = 'cart:updated';
export const GUEST_KEY = 'noithat_cart_guest';
export const MAX_QTY = 99;

/**
 * Ép số lượng về số nguyên hợp lệ: tối thiểu 1, tối đa limit (mặc định 99 hoặc tồn kho)
 */
export const clampQty = (n: any, max: number = MAX_QTY): number => {
  const parsed = parseInt(String(n), 10);
  if (isNaN(parsed) || parsed < 1) return 1;
  const upperLimit = typeof max === 'number' && max > 0 ? max : MAX_QTY;
  return Math.min(upperLimit, parsed);
};

/**
 * Xác định khóa lưu trữ localStorage:
 * - Khách chưa đăng nhập: 'noithat_cart_guest'
 * - Người đã đăng nhập: 'noithat_cart_u_<id hoặc email>'
 */
export const getCartKey = (): string => {
  if (typeof window === 'undefined') return GUEST_KEY;
  try {
    const raw = window.localStorage.getItem('current_user');
    if (raw) {
      const user = JSON.parse(raw);
      if (user) {
        if (user.id !== undefined && user.id !== null && String(user.id).trim() !== '') {
          return `noithat_cart_u_${String(user.id).trim()}`;
        }
        if (user.email && typeof user.email === 'string' && user.email.trim() !== '') {
          return `noithat_cart_u_${user.email.trim().toLowerCase()}`;
        }
      }
    }
  } catch {}
  return GUEST_KEY;
};

export const formatVnd = (value: number): string => {
  return Number(value || 0).toLocaleString('vi-VN') + ' đ';
};

/**
 * Đọc mảng CartItem từ khóa chỉ định
 */
export const readKey = (key: string): CartItem[] => {
  if (typeof window === 'undefined') return [];
  try {
    const raw = window.localStorage.getItem(key);
    if (!raw) return [];
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) return [];
    return parsed
      .filter((item) => item && typeof item.slug === 'string')
      .map((item) => {
        const limit = typeof item.maxStock === 'number' && item.maxStock > 0 ? item.maxStock : MAX_QTY;
        return {
          slug: String(item.slug),
          name: String(item.name ?? ''),
          price: Number(item.price) || 0,
          qty: clampQty(item.qty ?? item.quantity, limit),
          thumbnail: item.thumbnail ? String(item.thumbnail) : undefined,
          category: item.category ? String(item.category) : undefined,
          maxStock: item.maxStock,
        };
      });
  } catch {
    return [];
  }
};

/**
 * Ghi mảng CartItem vào khóa chỉ định
 */
export const writeKey = (key: string, items: CartItem[]): void => {
  if (typeof window === 'undefined') return;
  window.localStorage.setItem(key, JSON.stringify(items));
};

/**
 * Đọc giỏ hàng hiện tại (dùng getCartKey()).
 * Lần đầu: nếu còn khóa cũ noithat_cart thì chuyển sang noithat_cart_guest rồi xóa khóa cũ.
 */
export const readCart = (): CartItem[] => {
  if (typeof window === 'undefined') return [];
  try {
    // Migration: chuyển dữ liệu cũ ở noithat_cart sang noithat_cart_guest rồi xóa
    const oldCart = window.localStorage.getItem('noithat_cart') || window.localStorage.getItem('cart');
    if (oldCart) {
      const existingGuest = window.localStorage.getItem(GUEST_KEY);
      if (!existingGuest) {
        window.localStorage.setItem(GUEST_KEY, oldCart);
      }
      window.localStorage.removeItem('noithat_cart');
      window.localStorage.removeItem('cart');
    }

    const key = getCartKey();
    return readKey(key);
  } catch {
    return [];
  }
};

/**
 * Ghi giỏ hàng hiện tại và phát sự kiện CART_EVENT
 */
export const writeCart = (items: CartItem[]): void => {
  if (typeof window === 'undefined') return;
  const key = getCartKey();
  writeKey(key, items);
  window.dispatchEvent(new CustomEvent(CART_EVENT, { detail: items }));
};

/**
 * Gộp giỏ hàng khách vào giỏ tài khoản khi đăng nhập:
 * Cùng slug thì cộng dồn qty (có clampQty không vượt MAX_QTY/tồn kho).
 * Xóa giỏ khách sau khi gộp để không bị gộp lặp.
 */
export const mergeGuestCartIntoUser = (): void => {
  if (typeof window === 'undefined') return;
  const guest = readKey(GUEST_KEY);
  if (guest.length === 0) return; // Không có gì để gộp

  const userKey = getCartKey();
  if (userKey === GUEST_KEY) return; // Chưa đăng nhập thì thoát

  const merged = readKey(userKey);
  for (const item of guest) {
    const limit = typeof item.maxStock === 'number' && item.maxStock > 0 ? item.maxStock : MAX_QTY;
    const found = merged.find((i) => i.slug === item.slug);
    if (found) {
      found.qty = clampQty(found.qty + item.qty, limit);
    } else {
      merged.push({ ...item, qty: clampQty(item.qty, limit) });
    }
  }

  writeKey(userKey, merged);
  window.localStorage.removeItem(GUEST_KEY); // Xóa giỏ khách để không gộp lặp
  window.dispatchEvent(new CustomEvent(CART_EVENT, { detail: merged }));
};

// Export alias để tương thích các nơi đang gọi
export const mergeGuestCartOnLogin = mergeGuestCartIntoUser;

export const addToCart = (
  item: { slug: string; name: string; price: number; thumbnail?: string; category?: string; maxStock?: number },
  qty = 1
): CartItem[] => {
  const items = readCart();
  const existing = items.find((entry) => entry.slug === item.slug);
  const limit = typeof item.maxStock === 'number' && item.maxStock > 0 ? item.maxStock : MAX_QTY;
  const validQty = clampQty(qty, limit);

  if (existing) {
    existing.qty = clampQty(existing.qty + validQty, limit);
    if (item.thumbnail && !existing.thumbnail) existing.thumbnail = item.thumbnail;
    if (item.price && !existing.price) existing.price = item.price;
  } else {
    items.push({
      slug: item.slug,
      name: item.name,
      price: item.price,
      qty: validQty,
      thumbnail: item.thumbnail,
      category: item.category,
      maxStock: item.maxStock,
    });
  }

  writeCart(items);
  return items;
};

export const updateQty = (slug: string, qty: any): CartItem[] => {
  const items = readCart();
  const existing = items.find((entry) => entry.slug === slug);
  if (existing) {
    const limit = typeof existing.maxStock === 'number' && existing.maxStock > 0 ? existing.maxStock : MAX_QTY;
    existing.qty = clampQty(qty, limit);
    writeCart(items);
  }
  return items;
};

export const removeItem = (slug: string): CartItem[] => {
  const items = readCart().filter((entry) => entry.slug !== slug);
  writeCart(items);
  return items;
};

export const clearCart = (): void => {
  if (typeof window === 'undefined') return;
  const key = getCartKey();
  writeKey(key, []);
  window.dispatchEvent(new CustomEvent(CART_EVENT, { detail: [] }));
};

export const countItems = (items: CartItem[]): number =>
  items.reduce((sum, entry) => sum + entry.qty, 0);

export const totalPrice = (items: CartItem[]): number =>
  items.reduce((sum, entry) => sum + entry.price * entry.qty, 0);

export const showCartToast = (message: string, type: 'success' | 'warning' | 'error' = 'success'): void => {
  if (typeof document === 'undefined') return;
  const existing = document.getElementById('cart-toast-notification');
  if (existing) existing.remove();

  const isWarn = type === 'warning' || type === 'error';
  const toast = document.createElement('div');
  toast.id = 'cart-toast-notification';
  toast.className = isWarn
    ? 'fixed top-20 right-6 z-[99999] flex items-center gap-3 rounded-lg bg-red-900/95 border border-red-500/60 px-5 py-3.5 text-sm font-semibold text-white shadow-2xl transition-all duration-300 translate-y-[-10px] opacity-0 backdrop-blur-md max-w-md'
    : 'fixed top-20 right-6 z-[99999] flex items-center gap-3 rounded-lg bg-walnut-900/95 border border-walnut-700/60 px-5 py-3.5 text-sm font-medium text-sand-50 shadow-2xl transition-all duration-300 translate-y-[-10px] opacity-0 backdrop-blur-md max-w-md';

  const iconSvg = isWarn
    ? `<svg class="h-5 w-5 text-amber-300 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
      </svg>`
    : `<svg class="h-5 w-5 text-emerald-400 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
      </svg>`;

  toast.innerHTML = `
    ${iconSvg}
    <span class="leading-snug">${message}</span>
  `;
  document.body.appendChild(toast);
  requestAnimationFrame(() => {
    toast.style.opacity = '1';
    toast.style.transform = 'translateY(0)';
  });
  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transform = 'translateY(-10px)';
    setTimeout(() => toast.remove(), 300);
  }, 3200);
};

export const bumpCartIcon = (cartBtn?: HTMLElement | null): void => {
  if (typeof document === 'undefined') return;
  const btn =
    cartBtn ||
    document.querySelector<HTMLElement>('[data-header-cart-btn]') ||
    document.querySelector<HTMLElement>('a[href="/gio-hang"]');
  if (!btn) return;

  // Hiệu ứng nảy giỏ hàng đàn hồi (spring bump)
  btn.animate(
    [
      { transform: 'scale(1)', filter: 'none' },
      { transform: 'scale(1.35) rotate(-14deg)', filter: 'drop-shadow(0 0 14px #f59e0b)' },
      { transform: 'scale(0.88) rotate(10deg)' },
      { transform: 'scale(1.15) rotate(-4deg)' },
      { transform: 'scale(1) rotate(0deg)', filter: 'none' },
    ],
    {
      duration: 550,
      easing: 'cubic-bezier(0.175, 0.885, 0.32, 1.275)',
    }
  );

  // Vòng xung kích sóng tròn (ripple)
  const ripple = document.createElement('span');
  ripple.className = 'cart-bump-ripple pointer-events-none absolute inset-[-6px] rounded-full border-2 border-amber-400 opacity-90';
  btn.appendChild(ripple);

  ripple
    .animate(
      [
        { transform: 'scale(0.7)', opacity: 0.9 },
        { transform: 'scale(1.9)', opacity: 0 },
      ],
      { duration: 550, easing: 'ease-out' }
    )
    .onfinish = () => ripple.remove();
};

export const flyToCart = (startEl?: HTMLElement | null, imageSrc?: string): Promise<void> => {
  return new Promise((resolve) => {
    if (typeof window === 'undefined' || typeof document === 'undefined') {
      resolve();
      return;
    }

    const cartBtn =
      document.querySelector<HTMLElement>('[data-header-cart-btn]') ||
      document.querySelector<HTMLElement>('a[href="/gio-hang"]');

    if (!cartBtn) {
      resolve();
      return;
    }

    const startRect = startEl ? startEl.getBoundingClientRect() : null;
    const targetRect = cartBtn.getBoundingClientRect();

    if (!startRect || startRect.width === 0 || startRect.height === 0) {
      bumpCartIcon(cartBtn);
      resolve();
      return;
    }

    // Tạo khối ảnh thu nhỏ bay lên giỏ hàng
    const flyer = document.createElement('div');
    flyer.className = 'pointer-events-none fixed z-[99999] overflow-hidden border-2 border-white shadow-2xl';

    const flyerSize = Math.min(Math.max(startRect.width * 0.7, 80), 160);
    const startX = startRect.left + (startRect.width - flyerSize) / 2;
    const startY = startRect.top + (startRect.height - flyerSize) / 2;

    Object.assign(flyer.style, {
      left: `${startX}px`,
      top: `${startY}px`,
      width: `${flyerSize}px`,
      height: `${flyerSize}px`,
      backgroundImage: imageSrc ? `url("${imageSrc}")` : 'none',
      backgroundColor: '#173524',
      backgroundSize: 'cover',
      backgroundPosition: 'center',
      borderRadius: '12px',
      boxShadow: '0 12px 30px rgba(216, 182, 112, 0.45), 0 0 0 2px #D8B670',
      willChange: 'transform, left, top, opacity',
    });

    document.body.appendChild(flyer);

    // Tính điểm rơi vào tâm giỏ hàng
    const targetX = targetRect.left + targetRect.width / 2 - 12;
    const targetY = targetRect.top + targetRect.height / 2 - 12;

    // Quỹ đạo cong parabol hướng lên trên cao hơn để dễ quan sát
    const controlY = Math.min(startY, targetY) - 90;
    const midX = startX + (targetX - startX) * 0.45;

    const anim = flyer.animate(
      [
        {
          left: `${startX}px`,
          top: `${startY}px`,
          transform: 'scale(1) rotate(0deg)',
          opacity: 1,
          borderRadius: '12px',
        },
        {
          // 1. Giai đoạn đóng gói tại chỗ (thu nhỏ tạo xung lực)
          left: `${startX}px`,
          top: `${startY}px`,
          transform: 'scale(0.78) rotate(-6deg)',
          opacity: 1,
          borderRadius: '18px',
          boxShadow: '0 16px 40px rgba(216, 182, 112, 0.65), 0 0 0 3px #D8B670',
          offset: 0.18,
        },
        {
          // 2. Vút bay lên đỉnh đường cong parabol
          left: `${midX}px`,
          top: `${controlY}px`,
          transform: 'scale(0.5) rotate(20deg)',
          opacity: 0.95,
          borderRadius: '24px',
          offset: 0.58,
        },
        {
          // 3. Rơi vào tâm giỏ hàng và biến mất
          left: `${targetX}px`,
          top: `${targetY}px`,
          transform: 'scale(0.12) rotate(360deg)',
          opacity: 0.4,
          borderRadius: '9999px',
        },
      ],
      {
        duration: 1200,
        easing: 'cubic-bezier(0.2, 0.85, 0.25, 1)',
        fill: 'forwards',
      }
    );

    anim.onfinish = () => {
      flyer.remove();
      bumpCartIcon(cartBtn);
      resolve();
    };
  });
};
/**
 * Đồng bộ số lượng tồn kho mới nhất từ CSDL máy chủ cho các sản phẩm trong giỏ hàng.
 * Tự động hạ số lượng (clamp) nếu người dùng đang lưu số lượng lớn hơn tồn kho thực tế.
 */
export const syncCartWithServerStock = async (apiUrl?: string): Promise<{ updated: boolean; clampedItems: string[] }> => {
  if (typeof window === 'undefined') return { updated: false, clampedItems: [] };
  const items = readCart();
  if (items.length === 0) return { updated: false, clampedItems: [] };

  const baseUrl = apiUrl || (import.meta as any).env?.PUBLIC_API_URL || 'http://localhost:4000/api';
  let hasChanges = false;
  const clampedItems: string[] = [];

  await Promise.all(
    items.map(async (item) => {
      try {
        const res = await fetch(`${baseUrl}/products/${encodeURIComponent(item.slug)}`, {
          signal: AbortSignal.timeout(3000),
        });
        if (res.ok) {
          const json = await res.json();
          if (json.success && json.data) {
            const serverStock = Number(json.data.stock ?? json.data.variants?.[0]?.stock ?? 99);
            const serverPrice = Number(json.data.price ?? json.data.variants?.[0]?.price ?? item.price);

            if (typeof serverStock === 'number' && serverStock >= 0 && item.maxStock !== serverStock) {
              item.maxStock = serverStock;
              hasChanges = true;
            }
            if (serverPrice > 0 && item.price !== serverPrice) {
              item.price = serverPrice;
              hasChanges = true;
            }

            // Nếu số lượng trong giỏ vượt quá tồn kho thực tế
            if (serverStock > 0 && item.qty > serverStock) {
              item.qty = serverStock;
              hasChanges = true;
              clampedItems.push(item.name);
            }
          }
        }
      } catch {
        // Lỗi mạng hoặc backend chưa sẵn sàng thì bỏ qua
      }
    })
  );

  if (hasChanges) {
    writeCart(items);
  }

  return { updated: hasChanges, clampedItems };
};
