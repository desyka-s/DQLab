#Mengecek tabel orders_1
SELECT * FROM orders_1 limit 5;
#Mengecek tabel orders_2
SELECT * FROM orders_2 limit 5;
#Mengecek tabel customer
SELECT * FROM customer limit 5;
#1. Dari tabel orders_1 lakukan penjumlahan pada kolom quantity dengan fungsi aggregate sum() dan beri nama "total_penjualan", kalikan kolom quantity dengan kolom priceEach kemudian jumlahkan hasil perkalian kedua kolom tersebut dan beri nama "revenue"
#2. Perusahaan hanya ingin menghitung penjualan dari produk yang terkirim saja, sehingga kita perlu mem-filter kolom 'status' maka dari itu kita hanya menampilkan order dengan status "Shipped".
#3. Lakukan langkah 1 & 2, untuk tabel orders_2.
#Notes: Jangan lupa untuk mengakhiri setiap statement dengan titik koma sehingga kedua statement dapat dijalankan bersamaan (;).
SELECT SUM(quantity) as total_penjualan, SUM(priceEach * quantity) as revenue FROM orders_1 WHERE status = 'Shipped';
SELECT SUM(quantity) as total_penjualan, SUM(priceEach * quantity) as revenue FROM orders_2 WHERE status = 'Shipped';
#1. Pilihlah kolom “orderNumber”, “status”, “quantity”, “priceEach” pada tabel orders_1, dan tambahkan kolom baru dengan nama “quarter” dan isi dengan value “1”. Lakukan yang sama dengan tabel orders_2, dan isi dengan value “2”, kemudian gabungkan kedua tabel tersebut.
#2. Gunakan statement dari Langkah 1 sebagai subquery dan beri alias “tabel_a”.
#3. Dari “tabel_a”, lakukan penjumlahan pada kolom “quantity” dengan fungsi aggregate sum() dan beri nama “total_penjualan”, dan kalikan kolom quantity dengan kolom priceEach kemudian jumlahkan hasil perkalian kedua kolom tersebut dan beri nama “revenue”
#4. Filter kolom ‘status’ sehingga hanya menampilkan order dengan status “Shipped”.
#5. Kelompokkan total_penjualan berdasarkan kolom “quarter”, dan jangan lupa menambahkan kolom ini pada bagian select.
SELECT quarter, SUM(quantity) AS total_penjualan, SUM(quantity * priceeach) AS revenue FROM 
(
SELECT orderNumber, status, quantity, priceeach, 1 AS quarter FROM orders_1
UNION
SELECT orderNumber, status, quantity, priceeach, 2 AS quarter FROM orders_2
);
#1. Dari tabel customer, pilihlah kolom customerID, createDate dan tambahkan kolom baru dengan menggunakan fungsi QUARTER(…) untuk mengekstrak nilai quarter dari CreateDate dan beri nama “quarter”
#2. Filter kolom “createDate” sehingga hanya menampilkan baris dengan createDate antara 1 Januari 2004 dan 30Juni 2004
#3. Gunakan statement Langkah 1 & 2 sebagai subquery dengan alias tabel_b
#4. Hitunglah jumlah unik customers sehingga tidak ada duplikasi customers dan beri nama “total_customers”
#5. Kelompokkan total_customer berdasarkan kolom “quarter”, dan jangan lupa menambahkan kolom ini pada bagian select.
SELECT quarter, COUNT(DISTINCT customerID) AS total_customers FROM
(
SELECT customerID, QUARTER(createDate) AS quarter FROM customer
)
AS tabel_b WHERE quarter = '1' OR quarter = '2' GROUP BY quarter;
#1. Dari tabel customer, pilihlah kolom customerID, createDate dan tambahkan kolom baru dengan menggunakan fungsi QUARTER(…) untuk mengekstrak nilai quarter dari CreateDate dan beri nama “quarter”
#2. Filter kolom “createDate” sehingga hanya menampilkan baris dengan createDate antara 1 Januari 2004 dan 30 Juni 2004
#3. Gunakan statement Langkah 1&2 sebagai subquery dengan alias tabel_b
#4. Dari tabel orders_1 dan orders_2, pilihlah kolom customerID, gunakan DISTINCT untuk menghilangkan duplikasi, kemudian gabungkan dengan kedua tabel tersebut dengan UNION.
#5. Filter tabel_b dengan operator IN() menggunakan 'Select statement langkah 4' , sehingga hanya customerID yang pernah bertransaksi (customerID tercatat di tabel orders) yang diperhitungkan.
#6. Hitunglah jumlah unik customers (tidak ada duplikasi customers) di statement SELECT dan beri nama “total_customers”
#7. Kelompokkan total_customer berdasarkan kolom “quarter”, dan jangan lupa menambahkan kolom ini pada bagian select.
SELECT quarter, COUNT(customerID) AS total_customers FROM
(
SELECT customerID, QUARTER(createDate) AS quarter FROM customer
)
AS tabel_b WHERE customerID
IN
(
SELECT DISTINCT customerID FROM orders_1
UNION
SELECT DISTINCT customerID FROM orders_2
)
GROUP BY quarter;
#1. Dari kolom orders_2, pilih productCode, orderNumber, quantity, status
#2. Tambahkan kolom baru dengan mengekstrak 3 karakter awal dari productCode yang merupakan ID untuk kategori produk; dan beri nama categoryID
#3. Filter kolom “status” sehingga hanya produk dengan status “Shipped” yang diperhitungkan
#4. Gunakan statement Langkah 1, 2, dan 3 sebagai subquery dengan alias tabel_c
#5. Hitunglah total order dari kolom “orderNumber” dan beri nama “total_order”, dan jumlah penjualan dari kolom “quantity” dan beri nama “total_penjualan”
#6. Kelompokkan berdasarkan categoryID, dan jangan lupa menambahkan kolom ini pada bagian select.
#7. Urutkan berdasarkan “total_order” dari terbesar ke terkecil
SELECT categoryID, total_order, total_penjualan FROM 
(
SELECT categoryID, COUNT(DISTINCT(orderNumber)) AS total_order, SUM(quantity) AS total_penjualan FROM
(
SELECT productCode, orderNumber, quantity, status, SUBSTR(productCode, 1, 3) AS categoryID FROM orders_2 WHERE status = 'Shipped'
)
AS tabel_c GROUP BY categoryID
)
AS tabel_c ORDER BY total_order DESC;

#Untuk produk yang paling banyak diminati pada Q1 & Q2 (KESELURUHAN)
SELECT categoryID, total_order, total_penjualan FROM 
(
SELECT categoryID, COUNT(DISTINCT(orderNumber)) AS total_order, SUM(quantity) AS total_penjualan 
FROM 
(
SELECT productCode, orderNumber, quantity, status, SUBSTR(productCode, 1, 3) AS categoryID FROM 
(
SELECT * FROM orders_1
UNION
SELECT * FROM orders_2
) 
AS tabel_c WHERE status = 'Shipped'
)
AS tabel_c GROUP BY categoryID
)
AS tabel_c ORDER BY total_order DESC;
#1. Dari tabel orders_1, tambahkan kolom baru dengan value “1” dan beri nama “quarter”
#2. Dari tabel orders_2, pilihlah kolom customerID, gunakan distinct untuk menghilangkan duplikasi
#3. Filter tabel orders_1 dengan operator IN() menggunakan 'Select statement langkah 2', sehingga hanya customerID yang pernah bertransaksi di quarter 2 (customerID tercatat di tabel orders_2) yang diperhitungkan.
#4. Hitunglah jumlah unik customers (tidak ada duplikasi customers) dibagi dengan total_ customers dalam percentage, pada Select statement dan beri nama “Q2”
#Menghitung total unik customers yang transaksi di quarter_1
SELECT COUNT(DISTINCT customerID) as total_customers FROM orders_1;
#output = 25
SELECT 1 AS quarter, (COUNT (DISTINCT customerID) / 25) * 100 AS Q2 FROM orders_1 WHERE customerID IN
(
SELECT DISTINCT customerID FROM orders_2
);