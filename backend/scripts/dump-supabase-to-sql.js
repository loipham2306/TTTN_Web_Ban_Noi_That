import { Client } from 'pg';
import fs from 'fs';
import path from 'path';

const connectionString = 'postgresql://postgres.apphmfgvaefciwvizlai:NoiThat2026%40Pass@aws-1-ap-south-1.pooler.supabase.com:5432/postgres';
const outputPath = path.resolve(process.cwd(), '../database/web_ban_noi_that_supabase.sql');

// Thứ tự xuất bảng đảm bảo khóa ngoại
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
  'shopping_carts',
  'cart_items',
  'showcases',
  'system_logs',
];

function formatSqlValue(val, udtName) {
  if (val === null || val === undefined) return 'NULL';
  if (typeof val === 'boolean') return val ? 'TRUE' : 'FALSE';
  if (typeof val === 'number') return String(val);
  if (typeof val === 'bigint') return String(val);
  if (val instanceof Date) return `'${val.toISOString()}'`;
  if (typeof val === 'object') {
    return `'${JSON.stringify(val).replace(/'/g, "''")}'`;
  }
  const str = String(val).replace(/'/g, "''");
  return `'${str}'`;
}

async function dump() {
  console.log('🔄 Đang kết nối tới Supabase PostgreSQL...');
  const client = new Client({
    connectionString,
    ssl: { rejectUnauthorized: false },
  });

  await client.connect();
  console.log('✅ Đã kết nối thành công tới Supabase!');

  // Lấy tất cả các bảng trong public schema
  const tablesRes = await client.query(`
    SELECT table_name 
    FROM information_schema.tables 
    WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
  `);
  const existingTables = new Set(tablesRes.rows.map(r => r.table_name));

  // Sắp xếp theo tableOrder, nếu có bảng ngoài thì thêm vào cuối
  const sortedTables = [];
  for (const t of tableOrder) {
    if (existingTables.has(t)) sortedTables.push(t);
  }
  for (const t of existingTables) {
    if (!sortedTables.includes(t)) sortedTables.push(t);
  }

  let sql = `-- ================================================================\n`;
  sql += `-- SUPABASE POSTGRESQL DATABASE DUMP\n`;
  sql += `-- Project: KTUFA-WebNoiThat (apphmfgvaefciwvizlai)\n`;
  sql += `-- Export Date: ${new Date().toISOString()}\n`;
  sql += `-- Total Tables: ${sortedTables.length}\n`;
  sql += `-- ================================================================\n\n`;
  sql += `SET statement_timeout = 0;\n`;
  sql += `SET lock_timeout = 0;\n`;
  sql += `SET client_encoding = 'UTF8';\n`;
  sql += `SET standard_conforming_strings = on;\n`;
  sql += `SET check_function_bodies = false;\n`;
  sql += `SET client_min_messages = warning;\n`;
  sql += `SET row_security = off;\n\n`;

  for (const tableName of sortedTables) {
    console.log(`📦 Đang xuất bảng: ${tableName}...`);

    // Lấy thông tin cột
    const colsRes = await client.query(`
      SELECT 
        column_name, 
        data_type, 
        udt_name,
        is_nullable, 
        column_default,
        character_maximum_length
      FROM information_schema.columns 
      WHERE table_schema = 'public' AND table_name = $1
      ORDER BY ordinal_position;
    `, [tableName]);

    // Lấy Primary Key
    const pkRes = await client.query(`
      SELECT kcu.column_name
      FROM information_schema.table_constraints tc
      JOIN information_schema.key_column_usage kcu
        ON tc.constraint_name = kcu.constraint_name
        AND tc.table_schema = kcu.table_schema
      WHERE tc.constraint_type = 'PRIMARY KEY'
        AND tc.table_schema = 'public'
        AND tc.table_name = $1;
    `, [tableName]);
    const pkCols = pkRes.rows.map(r => `"${r.column_name}"`);

    sql += `-- ------------------------------------------------------------\n`;
    sql += `-- Cấu trúc bảng: ${tableName}\n`;
    sql += `-- ------------------------------------------------------------\n`;
    sql += `CREATE TABLE IF NOT EXISTS public."${tableName}" (\n`;

    const colDefs = colsRes.rows.map(col => {
      let typeStr = col.data_type;
      if (col.data_type === 'character varying') {
        typeStr = col.character_maximum_length ? `character varying(${col.character_maximum_length})` : 'character varying';
      } else if (col.data_type === 'USER-DEFINED') {
        typeStr = col.udt_name;
      }
      let def = `    "${col.column_name}" ${typeStr}`;
      if (col.column_default) {
        def += ` DEFAULT ${col.column_default}`;
      }
      if (col.is_nullable === 'NO') {
        def += ' NOT NULL';
      }
      return def;
    });

    if (pkCols.length > 0) {
      colDefs.push(`    CONSTRAINT "${tableName}_pkey" PRIMARY KEY (${pkCols.join(', ')})`);
    }

    sql += colDefs.join(',\n') + '\n);\n\n';

    // Xuất dữ liệu INSERT
    const dataRes = await client.query(`SELECT * FROM public."${tableName}";`);
    if (dataRes.rows.length > 0) {
      sql += `-- Dữ liệu cho bảng: ${tableName} (${dataRes.rows.length} bản ghi)\n`;
      const colNames = colsRes.rows.map(c => `"${c.column_name}"`).join(', ');

      for (const row of dataRes.rows) {
        const valStrings = colsRes.rows.map(c => {
          const val = row[c.column_name];
          return formatSqlValue(val, c.udt_name);
        });
        sql += `INSERT INTO public."${tableName}" (${colNames}) VALUES (${valStrings.join(', ')});\n`;
      }
      sql += '\n';
    } else {
      sql += `-- Bảng ${tableName} hiện chưa có bản ghi nào.\n\n`;
    }
  }

  // Cập nhật lại các sequence cho primary keys autoincrement
  sql += `-- ------------------------------------------------------------\n`;
  sql += `-- Đồng bộ Sequence cho các cột ID tự tăng (SERIAL / BIGSERIAL)\n`;
  sql += `-- ------------------------------------------------------------\n`;
  for (const tableName of sortedTables) {
    sql += `SELECT setval(pg_get_serial_sequence('public."${tableName}"', 'id'), coalesce(max(id), 1), max(id) IS NOT null) FROM public."${tableName}";\n`;
  }

  fs.writeFileSync(outputPath, sql, 'utf8');
  console.log(`\n🎉 HOÀN TẤT XUẤT CSDL SUPABASE!`);
  console.log(`📁 Đường dẫn file: ${outputPath}`);
  console.log(`📊 Kích thước file: ${(fs.statSync(outputPath).size / 1024).toFixed(2)} KB`);

  await client.end();
}

dump().catch(err => {
  console.error('❌ Lỗi khi xuất CSDL:', err);
  process.exit(1);
});
