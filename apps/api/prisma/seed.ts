import { Pool } from 'pg';
import dotenv from 'dotenv';
import path from 'path';
import fs from 'fs';

dotenv.config({ path: path.join(__dirname, '../config/.env.development') });

const pool = new Pool({ connectionString: process.env.DATABASE_URL });

function parseCSV(filePath: string): any[] {
  const content = fs.readFileSync(filePath, 'utf-8');
  const lines = content.split('\n').filter(line => line.trim());
  
  const categoryMap: Record<string, string> = {
    'Smartphones': 'electronic',
    'Laptops': 'electronic',
    'Baju Pria - Shirts': 'baju pria',
    'Sepatu Pria': 'sepatu pria',
    'Baju Wanita - Dresses': 'baju wanita',
    'Baju Pria/Wanita - Tops': 'baju wanita',
    'Sepatu Wanita': 'sepatu wanita',
  };
  
  return lines.slice(1).map(line => {
    const regex = /,(?=(?:[^"]*"[^"]*")*[^"]*$)/;
    const values = line.split(regex).map(v => v.replace(/^"|"$/g, '').trim());
    
    const originalCategory = values[11];
    const mappedCategory = categoryMap[originalCategory] || 'electronic';
    
    return {
      name: values[13] || values[0],
      price: parseInt(values[2]) || 0,
      promo: parseInt(values[5]) || 0,
      description: values[14] || values[8],
      image: values[12],
      stock: parseInt(values[9]) || 0,
      brand: values[10],
      category: mappedCategory
    };
  });
}

async function main() {
  console.info('🌱 Seeding database from CSV...');
  
  const csvPath = path.join(__dirname, '../../../assets/products_data_indonesia.csv');
  const products = parseCSV(csvPath);
  
  await pool.query('DELETE FROM product_items');
  console.info('🗑️  Cleared existing data');
  
  for (const product of products) {
    await pool.query(
      `INSERT INTO product_items (id, name, price, promo, description, images, stock, vendors, category) 
       VALUES (gen_random_uuid(), $1, $2, $3, $4, $5, $6, $7, $8)`,
      [product.name, product.price, product.promo, product.description, `{${product.image}}`, product.stock, product.brand, product.category]
    );
  }
  
  console.info(`✅ Seeded ${products.length} products!`);
  await pool.end();
}

main().catch(console.error);
