export interface Product {
  slug: string;
  name: string;
  category: string;
  categoryLabel: string;
  space: string;
  spaceLabel: string;
  price: number;
  material: string;
  isNew?: boolean;
}

export interface ProductDetail {
  description: string;
  dimensions: string;
  warranty: string;
}

export interface Category {
  key: string;
  label: string;
}

export interface Space {
  key: string;
  label: string;
}

export interface PriceRange {
  key: string;
  label: string;
}

export interface CartItem {
  slug: string;
  name: string;
  price: number;
  qty: number;
}

export interface OrderItem {
  slug: string;
  name: string;
  price: number;
  qty: number;
}

export interface Order {
  id?: number | string;
  orderCode?: string;
  customerName: string;
  customerPhone: string;
  customerEmail: string;
  province: string;
  district: string;
  streetAddress: string;
  note?: string;
  paymentMethod: 'cod' | 'bank';
  items: OrderItem[];
  shippingFee?: number;
  subtotalAmount?: number;
  totalAmount: number;
  status?: string;
  createdAt?: string;
}

export interface FengShuiInput {
  namSinh: number;
  gioiTinh: 'nam' | 'nu';
  loaiPhong: string;
}

export interface HuongTot {
  vaiTro: string;
  huong: string;
}

export interface FengShuiResult {
  quaiSo: number;
  cung: string;
  nhomMenh: string;
  nguHanh: string;
  huongTot: HuongTot[];
  mauSac: string[];
  goiY: string[];
  aiAdvice?: string;
}
