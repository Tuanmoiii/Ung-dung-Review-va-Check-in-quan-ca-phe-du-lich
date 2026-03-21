const express = require('express');
const cors = require('cors');
const pool = require('./db');
const dotenv = require('dotenv');

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.json({ status: 'OK', message: 'BTL Backend for Review & Check-in app' });
});

// users
app.get('/users', async (req, res) => {
  const [rows] = await pool.query('SELECT user_id, username, email, full_name, avatar_url, bio, user_level, total_points, total_visits, total_reviews, is_active, created_at, updated_at FROM users');
  res.json(rows);
});

app.post('/users', async (req, res) => {
  const { username, email, password_hash, full_name, avatar_url, bio } = req.body;
  const [result] = await pool.query(
    'INSERT INTO users (username, email, password_hash, full_name, avatar_url, bio) VALUES (?, ?, ?, ?, ?, ?)',
    [username, email, password_hash, full_name, avatar_url, bio]
  );
  const [rows] = await pool.query('SELECT * FROM users WHERE user_id = ?', [result.insertId]);
  res.status(201).json(rows[0]);
});

// venues, categories, checkins, reviews trình mẫu: GET /venues
app.get('/venues', async (req, res) => {
  const [rows] = await pool.query('SELECT * FROM venues');
  res.json(rows);
});

app.post('/venues', async (req, res) => {
  const { name, description, address, city, latitude, longitude, open_time, close_time, phone, website_url, featured_image, is_recommended } = req.body;
  const [result] = await pool.query(
    `INSERT INTO venues (name, description, address, city, latitude, longitude, open_time, close_time, phone, website_url, featured_image, is_recommended)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [name, description, address, city, latitude, longitude, open_time, close_time, phone, website_url, featured_image, is_recommended || false]
  );
  const [rows] = await pool.query('SELECT * FROM venues WHERE venue_id = ?', [result.insertId]);
  res.status(201).json(rows[0]);
});

// check-ins
app.post('/checkins', async (req, res) => {
  const { user_id, venue_id, points_earned, is_verified } = req.body;
  const [result] = await pool.query(
    'INSERT INTO check_ins (user_id, venue_id, points_earned, is_verified) VALUES (?, ?, ?, ?)',
    [user_id, venue_id, points_earned || 10, is_verified ?? true]
  );
  const [rows] = await pool.query('SELECT * FROM check_ins WHERE checkin_id = ?', [result.insertId]);
  res.status(201).json(rows[0]);
});

// reviews
app.post('/reviews', async (req, res) => {
  const { user_id, venue_id, rating, comment, checkin_id } = req.body;
  const [result] = await pool.query(
    'INSERT INTO reviews (user_id, venue_id, rating, comment, checkin_id) VALUES (?, ?, ?, ?, ?)',
    [user_id, venue_id, rating, comment, checkin_id || null]
  );
  const [rows] = await pool.query('SELECT * FROM reviews WHERE review_id = ?', [result.insertId]);
  res.status(201).json(rows[0]);
});

app.listen(PORT, () => {
  console.log(`BTL backend listening on http://localhost:${PORT}`);
});
