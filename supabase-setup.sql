-- Nile View: إعداد قاعدة البيانات (شغّله مرة واحدة فقط من Supabase > SQL Editor)

create extension if not exists pgcrypto;

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  section text not null,
  name text not null,
  meta text default '',
  description text default '',
  badge text default '',
  badge_hot boolean default false,
  tier text default '',
  wa_key text default 'general',
  button_label text default 'احجز الآن',
  images text[] default '{}',
  video_url text default '',
  poster_url text default '',
  sort integer default 0,
  active boolean default true,
  created_at timestamptz default now()
);

alter table public.products enable row level security;

-- أي زائر يقدر يقرأ المنتجات الظاهرة فقط
create policy "public read active" on public.products
  for select using (active = true);

-- المسجّل دخوله (أنت) يقدر يعمل كل حاجة
create policy "admin full access" on public.products
  for all to authenticated using (true) with check (true);

-- مخزن الصور والفيديوهات
insert into storage.buckets (id, name, public)
values ('media', 'media', true)
on conflict (id) do nothing;

create policy "media public read" on storage.objects
  for select using (bucket_id = 'media');
create policy "media admin insert" on storage.objects
  for insert to authenticated with check (bucket_id = 'media');
create policy "media admin update" on storage.objects
  for update to authenticated using (bucket_id = 'media');
create policy "media admin delete" on storage.objects
  for delete to authenticated using (bucket_id = 'media');

-- المحتوى الحالي للموقع الموحد (الصور والفيديوهات من فولدر الموقع)
insert into public.products
  (section,name,meta,description,badge,badge_hot,tier,wa_key,button_label,images,video_url,poster_url,sort,active)
values
  ('reels_yachts','مركب Lovely','','','',false,'','yacht','','{}'::text[],'videos/lovely-yacht.mp4','assets/lovely-yacht-2.jpg',5,true),
  ('boats','مركب Sai','رحلة خاصة','الأرقى في الأسطول لرحلات اليخوت الخاصة على النيل.','فاخر',true,'luxury','yacht','احجز الآن',ARRAY['assets/sai-1.jpg','assets/sai-g2.jpg','assets/sai-g3.jpg','assets/sai-g4.jpg','assets/sai-g5.jpg','assets/sai-g6.jpg','assets/sai-g7.jpg','assets/sai-g8.jpg','assets/sai-g9.jpg','assets/sai-g10.jpg']::text[],'','',10,true),
  ('boats','يخت Vaya','يتسع 85 فرد','رحلة يخوت VIP للمناسبات الخاصة والاحتفالات الراقية.','فاخر',true,'luxury','yacht','احجز الآن',ARRAY['assets/yacht-vip-1.jpg','assets/yacht-vip-1-g2.jpg','assets/yacht-vip-1-g3.jpg','assets/yacht-vip-1-g4.jpg','assets/yacht-vip-1-g5.jpg']::text[],'','',20,true),
  ('boats','يخت Solo','يتسع 130 فرد','رحلة عائلية واسعة ومناسبة للتجمعات الكبيرة.','فاخر',false,'luxury','yacht','احجز الآن',ARRAY['assets/yacht-family-1.jpg','assets/yacht-family-1-g2.jpg','assets/solo-yacht-03.jpg','assets/solo-yacht-04.jpg','assets/solo-yacht-05.jpg','assets/solo-yacht-06.jpg','assets/solo-yacht-07.jpg','assets/solo-yacht-08.jpg','assets/solo-yacht-09.jpg','assets/solo-yacht-10.jpg','assets/solo-yacht-11.jpg','assets/solo-yacht-12.jpg','assets/solo-yacht-13.jpg']::text[],'','',30,true),
  ('boats','يخت San','يتسع 200 فرد','يخت واسع للمناسبات والتجمعات الكبيرة على النيل.','فاخر',false,'luxury','yacht','احجز الآن',ARRAY['assets/yacht-vip-2.jpg','assets/yacht-vip-2-g2.jpg','assets/yacht-vip-2-g3.jpg','assets/yacht-vip-2-g4.jpg','assets/yacht-vip-2-g5.jpg','assets/yacht-vip-2-g6.jpg']::text[],'','',40,true),
  ('boats','يخت Nubia','يتسع 100 فرد','جولة نيلية عائلية مريحة بإطلالة مفتوحة.','فاخر',false,'luxury','yacht','احجز الآن',ARRAY['assets/yacht-family-2.jpg','assets/yacht-family-2-g2.jpg','assets/yacht-family-2-g3.jpg','assets/yacht-family-2-g4.jpg','assets/yacht-family-2-g5.jpg','assets/yacht-family-2-g6.jpg']::text[],'','',50,true),
  ('boats','يخت The Rock','رحلة خاصة','يخت The Rock للجولات العائلية والمناسبات على النيل.','فاخر',false,'luxury','yacht','احجز الآن',ARRAY['assets/the-rock-1.jpg','assets/the-rock-2.jpg','assets/the-rock-3.jpg','assets/the-rock-4.jpg','assets/the-rock-5.jpg','assets/the-rock-6.jpg','assets/the-rock-7.jpg','assets/the-rock-8.jpg','assets/the-rock-9.jpg','assets/the-rock-10.jpg','assets/the-rock-11.jpg','assets/the-rock-12.jpg','assets/the-rock-13.jpg','assets/the-rock-14.jpg','assets/the-rock-15.jpg','assets/the-rock-16.jpg','assets/the-rock-17.jpg']::text[],'','',60,true),
  ('boats','يخت Orchid','يتسع 100 فرد','رحلة عائلية أنيقة للعائلات والمناسبات الجماعية.','فاخر',false,'luxury','yacht','احجز الآن',ARRAY['assets/yacht-family-3.jpg','assets/yacht-family-3-g2.jpg','assets/yacht-family-3-g3.jpg','assets/yacht-family-3-g4.jpg']::text[],'','',70,true),
  ('boats','يخت VIP','يتسع 60 فرد','تجربة خاصة بإطلالة نيلية كاملة الخدمة بسعر اقتصادي.','اقتصادي',false,'economy','yacht','احجز الآن',ARRAY['assets/yacht-vip-4.jpg','assets/yacht-vip-4-g2.jpg','assets/yacht-vip-4-g3.jpg','assets/yacht-vip-4-g4.jpg','assets/yacht-vip-4-g5.jpg','assets/yacht-vip-4-g6.jpg']::text[],'','',80,true),
  ('boats','يخت Kokorela','يتسع 10 أفراد','يخت صغير للجولات الخاصة واللحظات المميزة.','اقتصادي',false,'economy','yacht','احجز الآن',ARRAY['assets/yacht-vip-5.jpg','assets/yacht-vip-5-g2.jpg','assets/yacht-vip-5-g3.jpg','assets/yacht-vip-5-g4.jpg']::text[],'','',90,true),
  ('boats','يخت La More','يتسع 15 فرد','رحلة رومانسية أو احتفال صغير على النيل.','اقتصادي',false,'economy','yacht','احجز الآن',ARRAY['assets/img_05.jpg','assets/img_05-g2.jpg','assets/img_05-g3.jpg','assets/img_05-g4.jpg','assets/img_05-g5.jpg','assets/img_05-g6.jpg']::text[],'','',100,true),
  ('boats','جولة نيلية عائلية','سعة مرنة','جولة نيلية عائلية للزيارة والتصوير والاستمتاع بالنيل.','اقتصادي',false,'economy','yacht','احجز الآن',ARRAY['assets/img_06.jpg','assets/img_06-g2.jpg','assets/img_06-g3.jpg','assets/img_06-g4.jpg']::text[],'','',110,true),
  ('cruises','باخرة نايل كرستال','رحلة بالفرد · 3 مواعيد يومياً','باخرة نايل كرستال لرحلات نيلية بالفرد مع إطلالة فاخرة على النيل.','مميز',false,'','yacht','احجز الآن',ARRAY['assets/nile-crystal-1.jpg','assets/nile-crystal-2.jpg','assets/nile-crystal-3.jpg','assets/nile-crystal-4.jpg','assets/nile-crystal-5.jpg','assets/nile-crystal-6.jpg','assets/nile-crystal-7.jpg']::text[],'','',111,true),
  ('cruises','باخرة ريفر بوت','رحلة بالفرد · 3 مواعيد يومياً','باخرة ريفر بوت لرحلات نيلية بالفرد مناسبة للعائلات والأصدقاء.','جديد',true,'','yacht','احجز الآن',ARRAY['assets/river-boat-1.jpg','assets/river-boat-2.jpg','assets/river-boat-3.jpg','assets/river-boat-4.jpg','assets/river-boat-5.jpg','assets/river-boat-6.jpg','assets/river-boat-7.jpg','assets/river-boat-8.jpg','assets/river-boat-9.jpg','assets/river-boat-10.jpg','assets/river-boat-11.jpg','assets/river-boat-12.jpg','assets/river-boat-13.jpg','assets/river-boat-14.jpg','assets/river-boat-15.jpg','assets/river-boat-16.jpg','assets/river-boat-17.jpg','assets/river-boat-18.jpg','assets/river-boat-19.jpg','assets/river-boat-20.jpg','assets/river-boat-21.jpg','assets/river-boat-22.jpg','assets/river-boat-23.jpg','assets/river-boat-24.jpg','assets/river-boat-25.jpg']::text[],'','',112,true),
  ('boats','مركب Lovely','استفسر عن تفاصيل الرحلة','مركب Lovely على النيل. تواصل لمعرفة تفاصيل الرحلات والحجز.','جديد',true,'','yacht','احجز الآن',ARRAY['assets/lovely-yacht-1.jpg','assets/lovely-yacht-2.jpg','assets/lovely-yacht-3.jpg','assets/lovely-yacht-4.jpg']::text[],'','',113,true),
  ('boats','يخت تويا','','جولات ورحلات على متن يخت تويا على نهر النيل.','',false,'','yacht','احجز الآن',ARRAY['assets/toya-yacht-01.jpg','assets/toya-yacht-02.jpg','assets/toya-yacht-03.jpg','assets/toya-yacht-04.jpg','assets/toya-yacht-05.jpg','assets/toya-yacht-06.jpg','assets/toya-yacht-07.jpg','assets/toya-yacht-08.jpg','assets/toya-yacht-09.jpg','assets/toya-yacht-10.jpg']::text[],'','',114,true),

  ('resort','المطعم والكافيه النيلي','يومياً من الظهر','أشهى المأكولات والمشروبات مع إطلالة نيلية ساحرة.','مميز',false,'','resort','احجز طاولة',ARRAY['assets/img_02.jpg','assets/resort-3.jpg','assets/resort-4.jpg']::text[],'','',120,true),
  ('resort','حمام السباحة والإطلالة','','','',false,'','resort','استفسر الآن',ARRAY['assets/resort-1.jpg','assets/resort-2.jpg','assets/resort-5.jpg']::text[],'','',130,true),
  ('chalet','شاليه المنتجع','Day Use','شاليه خاص داخل المنتجع للاستخدام اليومي والتجمعات الهادئة على النيل.','الأكثر طلباً',true,'','resort','احجز الشاليه',ARRAY['assets/chalet-1.jpg','assets/chalet-2.jpg','assets/chalet-3.jpg','assets/chalet-4.jpg','assets/merged-c611cf87e79c82.jpg','assets/merged-22a69aa7ef8082.jpg','assets/merged-8c2ba719b7edc6.jpg','assets/merged-5866668557de93.jpg']::text[],'','',150,true),
  ('halls','قاعة أوبن اير على النيل','','قاعة مفتوحة مباشرة على النيل للأفراح والمناسبات.','الأكثر طلباً',true,'','halls','استفسر عن القاعة',ARRAY['assets/img_03.jpg','assets/hall-open-2.jpg','assets/hall-open-3.jpg','assets/hall-open-4.jpg','assets/miramar-img_1264.jpg','assets/miramar-img_1265.jpg','assets/miramar-img_1267.jpg','assets/miramar-img_1268.jpg','assets/miramar-img_1269.jpg','assets/miramar-img_1270.jpg','assets/miramar-img_1271.jpg']::text[],'','',160,true),
  ('halls','قاعة مكيفة فاخرة','','قاعة مغلقة مكيفة بالكامل للمناسبات الخاصة.','مميز',false,'','halls','احجز القاعة',ARRAY['assets/img_10.jpg','assets/hall-ac-2.jpg','assets/hall-ac-3.jpg']::text[],'','',170,true),
  ('apartments','شقق للإيجار','يومي وشهري','شقق نيلية مفروشة بالكامل للإيجار اليومي والشهري.','الأكثر طلباً',true,'','rent','استفسر عن الإيجار',ARRAY['assets/apt-rent.jpg','assets/apt-rent-2.jpg']::text[],'','',180,true),
  ('apartments','شقق للتمليك','سوبر لوكس','وحدات تمليك بإطلالة مباشرة على النيل.','مميز',false,'','buy','استفسر عن التمليك',ARRAY['assets/apt-buy.jpg']::text[],'','',190,true),
  ('cars','سيارات فاخرة','','سيارات راقية للاستقبال والتوصيل في الأفراح والمناسبات.','فاخر',false,'','cars','احجز سيارة فاخرة',ARRAY['assets/car-placeholder.svg']::text[],'','',200,true),
  ('cars','سيارات اقتصادية','','خدمة توصيل مريحة للرحلات والتنقل من وإلى المنتجع.','اقتصادي',false,'','cars','احجز سيارة',ARRAY['assets/car-placeholder.svg']::text[],'','',210,true),
  ('reels_apts','جولة داخل الشقة','','','',false,'','rent','','{}'::text[],'videos/apt-1.mp4','assets/apt-vid.jpg',220,true),
  ('reels_apts','شقة بإطلالة النيل','','','',false,'','rent','','{}'::text[],'videos/apt-4.mp4','assets/apt-vid2.jpg',230,true),
  ('reels_halls','جولة داخل القاعة','','','',false,'','halls','','{}'::text[],'videos/merged-9227930467156a.mp4','assets/merged-f2deecb66d5d96.jpg',246,true),
  ('resort','برجولا على النيل مباشرة','جلسات خاصة','برجولا خشبية مطلة مباشرة على النيل للجلسات الخاصة وأعياد الميلاد والعشاء تحت الأنوار.','جديد',true,'','resort','احجز البرجولا',ARRAY['assets/merged-daccf5901b0aa0.jpg','assets/merged-bd7cee8650bfa2.jpg','assets/merged-7a39ae7ad1cd83.jpg','assets/merged-97eb2d40774c53.jpg','assets/merged-06ff3326b046f5.jpg','assets/merged-99c65f19f892eb.jpg']::text[],'','',141,true),
  ('resort','عشاء رومانسي على النيل مباشرة','','عشاء رومانسي بإطلالة مباشرة على النيل.','',false,'','resort','احجز عشاء رومانسي',ARRAY['assets/romantic-dinner-01.jpg','assets/romantic-dinner-02.jpg','assets/romantic-dinner-03.jpg','assets/romantic-dinner-04.jpg','assets/romantic-dinner-05.jpg','assets/romantic-dinner-06.jpg','assets/romantic-dinner-07.jpg','assets/romantic-dinner-08.jpg']::text[],'','',142,true),
  ('reels_resort','جلسة البرجولا على النيل','','','',false,'','resort','','{}'::text[],'videos/merged-3619a9f0b37c4f.mp4','assets/merged-6d8592343ac0a2.jpg',281,true),
  ('reels_resort','إطلالة البرجولا','','','',false,'','resort','','{}'::text[],'videos/merged-2d938aad2585ea.mp4','assets/merged-b8b53e848ec820.jpg',282,true),
  ('reels_resort','عشاء رومانسي على النيل مباشرة','','','',false,'','resort','','{}'::text[],'videos/romantic-dinner-nile.mp4','assets/romantic-dinner-01.jpg',283,true),
  ('reels_resort','جولة داخل المنتجع','','','',false,'','resort','','{}'::text[],'videos/merged-ac50cada6afce8.mp4','assets/merged-fd8752b07083ce.jpg',284,true),
  ('reels_resort','أجواء المنتجع على النيل','','','',false,'','resort','','{}'::text[],'videos/resort-atmosphere.mp4','assets/resort-atmosphere-poster.jpg',286,true),
  ('reels_resort','حمام السباحة والمنتجع','','','',false,'','resort','','{}'::text[],'videos/resort-pool.mp4','assets/resort-pool-video-poster.jpg',285,true),
  ('reels_halls','قاعة أوبن اير على النيل','','','',false,'','halls','','{}'::text[],'videos/merged-41613f601d9537.mp4','assets/merged-510687f8c44901.jpg',247,true),
  ('reels_halls','قاعة سيجار VIP','','','',false,'','halls','','{}'::text[],'videos/cigar-vip.mp4','assets/cigar-vip-01.jpg',248,true),
  ('reels_apts','شقة للإيجار على النيل','','','',false,'','rent','','{}'::text[],'videos/merged-e9a6df634a938e.mp4','assets/merged-f71157f80b00ee.jpg',231,true),
  ('reels_apts','شقة نيلية للإيجار','','','',false,'','rent','','{}'::text[],'videos/merged-cc16d51c6e8328.mp4','assets/merged-a9e66c07cc26d3.jpg',232,true),
  ('reels_apts','شقة فاخرة للإيجار على النيل','','','',false,'','rent','','{}'::text[],'videos/merged-367e9767f0ee61.mp4','assets/merged-4df4d07a304b69.jpg',233,true),
  ('halls','قاعة سيجار VIP','VIP · إطلالة نيلية','قاعة راقية بإطلالة مباشرة على النيل للمناسبات الخاصة وحفلات الخطوبة والعشاء الرومانسي.','جديد',true,'','halls','احجز قاعة سيجار VIP',ARRAY['assets/cigar-vip-01.jpg','assets/cigar-vip-02.jpg','assets/cigar-vip-03.jpg','assets/cigar-vip-04.jpg','assets/cigar-vip-05.jpg','assets/cigar-vip-06.jpg','assets/cigar-vip-07.jpg','assets/cigar-vip-08.jpg','assets/cigar-vip-09.jpg','assets/cigar-vip-10.jpg','assets/cigar-vip-11.jpg','assets/cigar-vip-12.jpg','assets/cigar-vip-13.jpg','assets/cigar-vip-14.jpg','assets/cigar-vip-15.jpg','assets/cigar-vip-16.jpg','assets/cigar-vip-17.jpg','assets/cigar-vip-18.jpg','assets/cigar-vip-19.jpg','assets/cigar-vip-20.jpg','assets/cigar-vip-21.jpg','assets/cigar-vip-22.jpg']::text[],'','',171,true),

  ('reels_halls','فرح ميرامار في قاعة أوبن إير','','','',false,'','halls','','{}'::text[],'videos/miramar-open-air-wedding.mp4','assets/miramar-open-air-wedding-poster.jpg',249,true);
