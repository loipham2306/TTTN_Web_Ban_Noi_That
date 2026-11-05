const fs = require('fs');
const files = [
  'frontend/public/previews/order-email.html',
  'frontend/public/previews/payment-email.html',
  'backend/assets/preview-order-email.html',
  'backend/assets/preview-payment-email.html'
];

files.forEach(p => {
  if (fs.existsSync(p)) {
    let c = fs.readFileSync(p, 'utf8');
    c = c.replace(
      /<div style="font-size: 26px; line-height: 1; margin-bottom: 4px;">🏛️<\/div>/g,
      '<img src="/images/logo1.jpg" alt="KTUFA Luxury Furniture" style="max-height: 52px; width: auto; object-fit: contain; margin-bottom: 8px; border-radius: 4px; display: inline-block;" />'
    );
    fs.writeFileSync(p, c, 'utf8');
  }
});
console.log('Update preview logo complete!');

