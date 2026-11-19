import fs from 'fs';
import path from 'path';
import { prisma } from '../src/config/prisma.js';

// Danh sách các cột Boolean theo model
const boolCols: Record<string, string[]> = {
  bot_prompts: ['is_active'],
  categories: ['status'],
  coupons: ['status'],
  product_images: ['is_thumbnail'],
  products: ['status'],
  reviews: ['status'],
  user_addresses: ['is_default'],
  users: ['status'],
  banners: ['is_active'],
  showcases: ['is_active'],
  spaces: ['is_active'],
  suppliers: ['status'],
};

// Thứ tự import đảm bảo khóa ngoại
const tableOrder = [
  'roles',
  'users',
  'user_addresses',
  'password_otps',
  'bot_prompts',
  'categories',
  'spaces',
  'suppliers',
  'coupons',
  'products',
  'product_variants',
  'product_images',
  'banners',
  'orders',
  'order_items',
  'reviews',
  'wishlists',
  'chat_sessions',
  'chat_messages',
  'cash_transactions',
  'email_campaigns',
  'import_slips',
  'import_slip_items',
];

async function run() {
  const sqlDumpPath = path.join(process.cwd(), '..', 'database', 'web_ban_noi_that.sql');
  const sqlContent = fs.readFileSync(sqlDumpPath, 'utf8');

  // Trích xuất cấu trúc cột cho từng bảng
  const tableColumns: Record<string, string[]> = {};
  const createTableRegex = /CREATE TABLE `([^`]+)` \(([\s\S]+?)\) ENGINE=/g;
  let match;
  while ((match = createTableRegex.exec(sqlContent)) !== null) {
    const tableName = match[1];
    const body = match[2];
    const colLines = body.split('\n')
      .map(l => l.trim())
      .filter(l => l.startsWith('`'));
    const cols = colLines.map(l => {
      const m = l.match(/^`([^`]+)`/);
      return m ? m[1] : '';
    }).filter(Boolean);
    tableColumns[tableName] = cols;
  }

  console.log('Detected table columns:', Object.keys(tableColumns).length, 'tables');

  // Trích xuất các câu INSERT INTO
  const insertStatements: Record<string, string> = {};
  const insertRegex = /INSERT INTO `([^`]+)` VALUES ([\s\S]+?);/g;
  let insertMatch;
  while ((insertMatch = insertRegex.exec(sqlContent)) !== null) {
    insertStatements[insertMatch[1]] = insertMatch[2];
  }

  console.log('Detected insert statements:', Object.keys(insertStatements).length, 'tables');

  // Tắt kiểm tra khóa ngoại tạm thời nếu có thể, hoặc dùng thứ tự cha -> con
  for (const tableName of tableOrder) {
    const valuesStr = insertStatements[tableName];
    if (!valuesStr) {
      console.log(`- Table ${tableName}: No data in dump.`);
      continue;
    }

    const cols = tableColumns[tableName];
    if (!cols) {
      console.log(`- Table ${tableName}: No column definitions found.`);
      continue;
    }

    const booleans = boolCols[tableName] || [];
    const boolIndices = new Set(cols.map((c, i) => booleans.includes(c) ? i : -1).filter(i => i >= 0));

    // Parse các tuple giá trị: (val1, val2, ...), (val1, val2, ...)
    // Viết regex hoặc parser đơn giản cho tuple SQL
    // Xử lý chuyển đổi 1 / 0 sang true / false cho cột boolean
    console.log(`Processing table: ${tableName} (${cols.length} columns)...`);

    // Chuyển tên bảng sang cú pháp Postgres: "tableName"
    // Cột: ("col1", "col2", ...)
    const colNamesStr = cols.map(c => `"${c}"`).join(', ');

    // Chuyển đổi values:
    // Tách các tuple
    // Lưu ý: trong tuple có thể chứa chuỗi chứa dấu phẩy hoặc ngoặc đơn, nên dùng tokenizing cẩn thận
    const rows = parseSqlTuples(valuesStr);
    console.log(`  Parsed ${rows.length} rows for ${tableName}`);

    // Convert booleans
    const convertedRows = rows.map(row => {
      return row.map((val, colIdx) => {
        if (boolIndices.has(colIdx)) {
          if (val === '1' || val === 'TRUE' || val === "'1'") return 'TRUE';
          if (val === '0' || val === 'FALSE' || val === "'0'") return 'FALSE';
        }
        // Xử lý các chuỗi hex hoặc escape đặc thù MySQL nếu có
        return val;
      });
    });

    // Gom thành các batch nhỏ (mỗi batch 100 rows) để tránh quá dài
    const batchSize = 100;
    for (let i = 0; i < convertedRows.length; i += batchSize) {
      const batch = convertedRows.slice(i, i + batchSize);
      const valuesClause = batch.map(r => `(${r.join(', ')})`).join(', ');
      const query = `INSERT INTO "${tableName}" (${colNamesStr}) VALUES ${valuesClause} ON CONFLICT DO NOTHING;`;
      await prisma.$executeRawUnsafe(query);
    }

    // Reset sequence nếu bảng có cột 'id'
    if (cols.includes('id')) {
      try {
        await prisma.$executeRawUnsafe(`
          SELECT setval(pg_get_serial_sequence('"${tableName}"', 'id'), COALESCE(MAX(id), 1)) FROM "${tableName}";
        `);
      } catch (err: any) {
        // Một số bảng không dùng serial sequence
      }
    }

    console.log(`  ✅ Finished table: ${tableName}`);
  }

  console.log('🎉 Data migration completed successfully!');
  await prisma.$disconnect();
}

// Helper phân tích các tuple SQL: (1, 'abc', NULL), (2, 'def', 'x,y')
function parseSqlTuples(input: string): string[][] {
  const rows: string[][] = [];
  let inString = false;
  let stringChar = '';
  let isEscaped = false;
  let inTuple = false;
  let currentVal = '';
  let currentRow: string[] = [];

  for (let i = 0; i < input.length; i++) {
    const char = input[i];

    if (inString) {
      currentVal += char;
      if (isEscaped) {
        isEscaped = false;
      } else if (char === '\\') {
        isEscaped = true;
      } else if (char === stringChar) {
        // Kiểm tra xem có escape kiểu '' không
        if (input[i + 1] === stringChar) {
          currentVal += input[i + 1];
          i++;
        } else {
          inString = false;
        }
      }
      continue;
    }

    if (char === "'" || char === '"') {
      inString = true;
      stringChar = char;
      currentVal += char;
      continue;
    }

    if (char === '(' && !inTuple) {
      inTuple = true;
      currentRow = [];
      currentVal = '';
      continue;
    }

    if (char === ')' && inTuple) {
      currentRow.push(currentVal.trim());
      rows.push(currentRow);
      inTuple = false;
      currentVal = '';
      continue;
    }

    if (char === ',' && inTuple) {
      currentRow.push(currentVal.trim());
      currentVal = '';
      continue;
    }

    if (inTuple) {
      currentVal += char;
    }
  }

  return rows;
}

run().catch((err) => {
  console.error('Migration failed:', err);
  process.exit(1);
});

