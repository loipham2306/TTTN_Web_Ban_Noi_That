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
  item: { slug: string; name: string; price: number; thumbnail?: string; category?: string; maxStock?: number },
  qty = 1
): CartItem[] => {
  const items = readCart();
  const existing = items.find((entry) => entry.slug === item.slug);
  const limit = item.maxStock !== undefined ? item.maxStock : 99;

  if (existing) {
    existing.qty = Math.min(limit, existing.qty + qty);
    if (item.thumbnail && !existing.thumbnail) existing.thumbnail = item.thumbnail;
    if (item.price && !existing.price) existing.price = item.price;
  } else {
    items.push({
      slug: item.slug,
      name: item.name,
      price: item.price,
      qty: Math.min(limit, Math.max(1, qty)),
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
  toast.className = 'fixed bottom-6 left-6 z-[9999] flex items-center gap-3 rounded-md bg-walnut-900 px-5 py-3.5 text-sm font-medium text-sand-50 shadow-2xl transition-all duration-300 translate-y-3 opacity-0';
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