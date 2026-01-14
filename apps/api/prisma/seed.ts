import { Pool } from 'pg';
import dotenv from 'dotenv';
import path from 'path';

dotenv.config({ path: path.join(__dirname, '../config/.env.development') });

const pool = new Pool({ connectionString: process.env.DATABASE_URL });

const products = [
  ['iPhone 5s', 3199840, 1599920, 'IPhone 5s adalah smartphone klasik yang terkenal dengan desainnya yang ringkas dan fitur-fitur canggih saat dirilis.', '{https://cdn.dummyjson.com/product-images/smartphones/iphone-5s/1.webp}', 25, 'Apple', 'electronic'],
  ['iPhone 6', 4799840, 1919936, 'IPhone 6 adalah ponsel cerdas yang bergaya dan mumpuni dengan layar lebih besar dan kinerja lebih baik.', '{https://cdn.dummyjson.com/product-images/smartphones/iphone-6/1.webp}', 60, 'Apple', 'electronic'],
  ['iPhone 13 Pro', 17599840, 14079872, 'IPhone 13 Pro adalah ponsel cerdas mutakhir dengan sistem kamera bertenaga, chip berperforma tinggi, dan tampilan memukau.', '{https://cdn.dummyjson.com/product-images/smartphones/iphone-13-pro/1.webp}', 56, 'Apple', 'electronic'],
  ['iPhone X', 14399840, 11519872, 'IPhone X merupakan smartphone andalan yang menampilkan layar OLED tanpa bezel, teknologi pengenalan wajah (Face ID), dan performa mengesankan.', '{https://cdn.dummyjson.com/product-images/smartphones/iphone-x/1.webp}', 37, 'Apple', 'electronic'],
  ['Oppo A57', 3999840, 3199872, 'Oppo A57 merupakan smartphone kelas menengah yang terkenal dengan desain ramping dan fitur mumpuni.', '{https://cdn.dummyjson.com/product-images/smartphones/oppo-a57/1.webp}', 19, 'Oppo', 'electronic'],
  ['Oppo F19 Pro Ditambah', 6399840, 3199920, 'Oppo F19 Pro Plus merupakan smartphone kaya fitur dengan fokus pada kemampuan kamera.', '{https://cdn.dummyjson.com/product-images/smartphones/oppo-f19-pro-plus/1.webp}', 78, 'Oppo', 'electronic'],
  ['Oppo K1', 4799840, 3839872, 'Seri Oppo K1 menawarkan jajaran smartphone dengan fitur dan spesifikasi beragam.', '{https://cdn.dummyjson.com/product-images/smartphones/oppo-k1/1.webp}', 55, 'Oppo', 'electronic'],
  ['Realme C35', 2399840, 1919872, 'Realme C35 merupakan smartphone ramah anggaran dengan fokus menyediakan fitur-fitur penting untuk penggunaan sehari-hari.', '{https://cdn.dummyjson.com/product-images/smartphones/realme-c35/1.webp}', 48, 'Realme', 'electronic'],
  ['realme X', 4799840, 2399920, 'Realme X adalah smartphone kelas menengah yang terkenal dengan desainnya yang ramping dan tampilan yang mengesankan.', '{https://cdn.dummyjson.com/product-images/smartphones/realme-x/1.webp}', 12, 'Realme', 'electronic'],
  ['realme XT', 5599840, 2239936, 'Realme XT merupakan smartphone kaya fitur dengan fokus pada teknologi kamera.', '{https://cdn.dummyjson.com/product-images/smartphones/realme-xt/1.webp}', 80, 'Realme', 'electronic'],
];

async function main() {
  console.info('🌱 Seeding database...');
  
  for (const product of products) {
    await pool.query(
      `INSERT INTO product_items (id, name, price, promo, description, images, stock, vendors, category) 
       VALUES (gen_random_uuid(), $1, $2, $3, $4, $5, $6, $7, $8)`,
      product
    );
  }
  
  console.info('✅ Seeding completed!');
  await pool.end();
}

main().catch(console.error);
