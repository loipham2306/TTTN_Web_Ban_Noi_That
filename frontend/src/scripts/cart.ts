export interface CartItem {
  slug: string;
  name: string;
  price: number;
  qty: number;
}

const STORAGE_KEY = 'noithat_cart';

export const CART_EVENT = 'cart:updated';

export const formatVnd = (value: number): string => value.toLocaleString('vi-VN') + '₫';

export const readCart = (): CartItem[] => {
  if (typeof window === 'undefined') return [];
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    if (!raw) return [];
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) return [];
    return parsed
      .filter((item) => item && typeof item.slug === 'string')
      .map((item) => ({
        slug: String(item.slug),
        name: String(item.name ?? ''),
        price: Number(item.price) || 0,
        qty: Math.min(99, Math.max(1, Number(item.qty) || 1)),
      }));
  } catch {
    return [];
  }
};

const writeCart = (items: CartItem[]): void => {
  if (typeof window === 'undefined') return;
  window.localStorage.setItem(STORAGE_KEY, JSON.stringify(items));
  window.dispatchEvent(new CustomEvent(CART_EVENT, { detail: items }));
};

export const addToCart = (item: { slug: string; name: string; price: number }, qty = 1): CartItem[] => {
  const items = readCart();
  const existing = items.find((entry) => entry.slug === item.slug);

  if (existing) {
    existing.qty = Math.min(99, existing.qty + qty);
  } else {
    items.push({
      slug: item.slug,
      name: item.name,
      price: item.price,
      qty: Math.min(99, Math.max(1, qty)),
    });
  }

  writeCart(items);
  return items;
};

export const updateQty = (slug: string, qty: number): CartItem[] => {
  const items = readCart();
  const existing = items.find((entry) => entry.slug === slug);
  if (existing) existing.qty = Math.min(99, Math.max(1, qty));
  writeCart(items);
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
