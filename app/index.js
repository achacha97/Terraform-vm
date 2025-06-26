require('dotenv').config();
const express = require('express');
const app = express();

const PORT = 3000;
const env = process.env.ENVIRONMENT_NAME || 'not set';

app.get('/', (req, res) => {
  res.send(`Hello from ${env} environment!`);
});

app.listen(PORT, () => {
  console.log(`App running on port ${PORT}`);
});
